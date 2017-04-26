clc
clear
close all

% load data and define number of variables
load('ABBtrenddata.mat')
numvar = 9;

% Define the timespan
data = ABBtrenddata(:,[7, 8]); % longest timespan
cleandata = data(data~=0); % clean zeros
trend = reshape(cleandata,[],2);
sampletime = 1; % s sample time

for i = 1:1:length(trend(:,1))
    DateV = datevec(trend(i,1));
    trend(i,1) = DateV(4)*3600+DateV(5)*60+DateV(6);
end

time = trend(:,1)-trend(1,1);
timeq = time(1,1):sampletime:time(length(time(:,1)),1);

% Interpolate data
MVPV = zeros(length(timeq),numvar*2);

for j =1:2:numvar*2-1;
data = ABBtrenddata(:,[j, j+1]);
cleandata = data(data~=0);
trend = reshape(cleandata,[],2);

for i = 1:1:length(trend(:,1))
    DateV = datevec(trend(i,1));
    trend(i,1) = DateV(4)*3600+DateV(5)*60+DateV(6);
end

time = trend(:,1)-trend(1,1);
V = trend(:,2);
vq = interp1(time,V,timeq,'nearest','extrap');

Vtime = timeq;
Vvalue = vq;
MVPV(:,j)=transpose(Vtime);
MVPV(:,j+1)=transpose(Vvalue);
end

MVData = [MVPV(:,2) MVPV(:,4) MVPV(:,6)];
CVData = [MVPV(:,8) MVPV(:,10) MVPV(:,12) MVPV(:,14) MVPV(:,16) MVPV(:,18)];

save IOData.mat MVData CVData sampletime -v7.3

figure
plot(timeq,MVPV(:,2))
hold on
plot(timeq,MVPV(:,4))
hold on
plot(timeq,MVPV(:,6))
% 
% clf
figure
plot(timeq,MVPV(:,8))
hold on
plot(timeq,MVPV(:,10))
hold on
plot(timeq,MVPV(:,12))
hold on
plot(timeq,MVPV(:,14))
hold on
plot(timeq,MVPV(:,16))
hold on
plot(timeq,MVPV(:,18))