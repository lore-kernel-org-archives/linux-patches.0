Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D14F1FF7CA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793419; cv=none; b=C4kzEJ7EmzIDORoK9hMMIH+KOnydx6pSyXOL4mJd9dK595I0tUzWj3Lu+wuAmuorFu9kPdKlhvgSM4fqBt6bbxjNARe/NGO5sPa+u+NroEjZEYW3oM495RLR1qDIsEp1Nv5tf7ZK3jU8lnz8KTqndUnyiWxlkasc5hnyfIRnVQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793419; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzTy/0bDHjTUs2J/K/N/jx6AX9xRLpvcrF/a9GAHH6uHqUgREDmlXNNz2cx/UngQI6FrHVlMgwjkzZWQbeVUZ/NsjT9fuqFpEO76jbtNZEqY5QKJiswsnWqbd/yAkacAlh+2AU3ZCZSmtYIEulBg284r8/XvQlM6O0zAFmZYgH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YsdbPYVT; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsdbPYVT"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb470a8b27so21099931fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793415; x=1730398215; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YsdbPYVTvCzmHf1/g3MBJjJVs30EWUtl+GTW2X0uCOh7DYDdPiWnjFcycBMavYz3ql
         YonLgRi+Q0NXokX2Z9gcnTcDr0JU7ZTEeVNDrfQhg+pbqrbLcn6B/PcU297HUqIZd4Nj
         Iy1xI8fKVbthiToT4ROsgHpuzfPYKiLTWr7+zqgNKcSuTpokb6StUNf+W8hDqFNVuRZh
         63299t9XXh8bYprjIiDB45wJf1XO1c6072rlvinjwKEaJyU2ZOXI7e/5erzpG619i8j6
         W0gDJzBkMqDtwJbAzO1mPyVFHdPn8OKmhxzHOyFr6Zln4MXloTRL2JLvwu1FLIo5dJtT
         DmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793415; x=1730398215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=q+ysWZ2N0g3IOr75CqtgcP+cMcrW8/mby9aeLOChesQUQyvPDl8rX3ETcti6NojaUU
         3q2QMPU8q7PftfB1P0TtTcafLo8IXjh4j54clUdlAgTlwNkX9vMYvEM8wsFLCl+dyBDa
         xCnn5sQCsnJbxlWaUB8qb5kRw2lolvqQvmv4WGsaW9ko4tzOyQ8MZAzklqh5sby/KMq7
         ykYsoUgiA34zvouJU/bLYxhFDnDj64JLa00Jm70C6gT7byhFV7aoyphcOvf5Ko+15KMV
         mmQvRH+oDAKL5UUwtifUtVp+tktEiz3eiIqZAoZZN3z2IO4Y9ynyQ7SlCiydtGJDOzlu
         ZZdA==
X-Gm-Message-State: AOJu0YzXJ4ymsTfgCdtkCNhIliaL1xwVQ1IhSdkix5KZsUybWwUErfpn
	zEfBF0D9LRuPXpbPliQDC3mpGNtuPvvBbmv6ZYGIL+d3BgSXpAWH
X-Google-Smtp-Source: AGHT+IGp20shB/5tOvj3a2QIgKsG6sCHNl6jWa029ig+Z/qSbKv4NgIioTC644QcKuSAjcLA2rIJSw==
X-Received: by 2002:ac2:51d0:0:b0:539:f775:c0bc with SMTP id 2adb3069b0e04-53b2375406emr1274567e87.29.1729793415393;
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243ec80sm1430547e87.252.2024.10.24.11.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:05 +0300
Message-ID: <20241024181005.7501-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
