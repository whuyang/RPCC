function [MNF_img]  = MNF(img, d)
% Maximun Noise Fraction Based Dimensionality Reduction
% img: input 3D HSI image (m*n*l)
% d: excepted output dimensionality
% MNF_img: output dimensionality reduced HSI

% reference: A Transformation for Ordering Multispectral Data in
%                   Terms of Image Quality with Implications for Noise
%                   Removal. TGRS 1987.  X = S+N

[m, n, l]  =  size(img);
Z = reshape(img, m*n, l)';

center_Z = Z - mean(Z,2)*ones( 1,m*n);

% Step1: calculate the covaraince matrix of whole data
Sigma_X = (1/(m*n-1))*center_Z*center_Z';


% Step2: estimate the covaraince matrix of noise(with minimum/maximum autocorrelation factors (MAF),)
D_above =zeros(m,n,l);
for i = 2: m
    D_above(i,:,:) = img(i,:,:)- img(i-1,:,:); 
end

 D_right = zeros(m,n,l);
for i = 1:n-1
    D_right(:,i,:) = img(:,i,:)- img(:,i+1,:); 
end

D = (D_above+D_right)./2;

sz = size(D);

D_mat = reshape(D, sz(1)*sz(2), sz(3))';

center_D_mat = D_mat-mean(D_mat,2)*ones( 1,sz(1)*sz(2));
Sigma_N = (1/(sz(1)*sz(2)-1))*center_D_mat*center_D_mat';

[eig_vectors, eig_value] = eig(inv(Sigma_N)*Sigma_X);

% -----------
% [eig_value_sort,index] = sort(diag(eig_value),'descend');
% eig_value_sort = eig_value_sort(index);
% eig_vectors_sort = eig_vectors(:,index);
% project_H = eig_vectors_sort(:, 1:d);
% ------------

project_H = eig_vectors(:, 1:d);
MNF_img_mat = project_H'*Z;
MNF_img = reshape(MNF_img_mat' , [m,n,d]);
end
