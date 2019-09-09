% Coded Music Composition
% Young Beum Cho

NotesInput = input('Type in Notes Desired: ', 's');        % User Input for List of Notes
Notes = cell2mat(cellstr(split((string(NotesInput)))))';   % Converts User Input String into an Accessible Array

CountInput = input('Type in Counts for each Note: ', 's'); % User Input for Counts Associated with Each Input Note
Count = [str2num(CountInput)];                             % Converts User Input String into a number(double)

SFInput = input('Type in the Sampling Frequency: ', 's');  % User Input for Desired Sampling Frequency
fs = str2num(SFInput);                                     % Converts User Input String into a number(double)

x = [];                                                    % Blank Vector Placeholder
                                                              
for i = 1: length(Notes)                                   % Defines the indexes for each note in the 'Notes' vector
    switch(Notes(i))                                       % Defines the frequency depending on the Note Character
        case 'A'
            f = 220;
        case {'A#', 'A sharp', 'B flat'}
            f = 220 * 2^(1/12);
        case 'B'
            f = 220 * 2^(2/12);
        case 'C' 
            f = 220 * 2^(3/12);
        case {'C#', 'C sharp', 'D flat'}
            f = 220 * 2^(4/12);
        case 'D'
            f = 220 * 2^(5/12);
        case {'D#', 'D sharp', 'E flat'}
            f = 220 * 2^(6/12);
        case 'E'
            f = 220 * 2^(7/12);
        case 'F'
            f = 220 * 2^(8/12);
        case {'F#', 'F sharp', 'G flat'}
            f = 220 * 2^(9/12);    
        case 'G' 
            f = 220 * 2^(10/12);
        case {'G#', 'G sharp', 'A flat'}
            f = 220 * 2^(11/12);    
        otherwise
            disp('Invalid Note Input')
    end
    
    % Specified Overlap of Samples between Notes
    overlap = 100;
    
    % Volume Window Function
    ADSR = [linspace(0, 1, 0.05*Count(i)) linspace(1, 0.8, 0.1*Count(i)) linspace(0.8, 0.8, 0.7*Count(i)) linspace(0.8, 0, 0.15*Count(i))];
    % Defines Sample Period of Note
    n = 0:Count(i)-1;
    % Volumed Varied Note Signal
    WindowedSignal = (cos(2*pi* f/fs * n) .* ADSR);
    
    % Initials Note Sound Vector with 1st Value
    if i == 1    
        x = WindowedSignal;  
    % Overlaps Succeeding Note Signals with Previous Note Sound Vector 
    else
        x = [x zeros(1, 0.0625*fs)];
        FirstOverlap = [x, zeros(1, length(WindowedSignal)-overlap)]; 
        SecondOverlap = [zeros(1,length(x)-overlap), WindowedSignal] ;
        CombinedSignals = FirstOverlap + SecondOverlap;
        
        x = CombinedSignals;
    end
end

% Plays Note Sound Vector
soundsc(x)