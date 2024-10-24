Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C31FC7F6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793403; cv=none; b=tYctRi9+/lTF7DQvHCUV343lEyx5R7SgdsKAV8kRV9sYYQH1rWqXvpQzOvz0xImUMwBVFTmYL6pfIZFx288Zd848aFZCVrvpVT6sWUcImgCGCc10sphs+o3WvL3t6xiumnfXodbxFwfNxc8V2DIFGFSyS7oikniMYXS2sP+3wu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793403; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k29fFPC4FinlUKUmcEl18V/i14xfZI4+PW880861g30aCB63lYVjjTsdttYiRHeZpgEDWAqUdhzK2in3MFtns4FTOxf2WXN1LjYB011W0cjdNmK6lG+Z/MTwe76Dg83tkhrmCRKd2B+T/dXkVRSETjayaO/5ux00/2j+D3WXSZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bbnla8bo; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bbnla8bo"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fb3ce15172so21745721fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793400; x=1730398200; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Bbnla8boaDT6W04ShfyO9AEKbjtjHyVCfzBUxPMyt+ftTrCgIQ+0Y9eHlN7uH7/QSH
         hzaPdmuU04DYu52/QjYj83Pn1MY/OJ6Qw2o1mk10CUjqfUMlWNTFznMUxS6UOQ7rnGZ4
         bUTPo61PYzWPDZBR94QjO3jj1PUzaP3+itnHBhQRfwX6u3znaAR3kRsEYwxgiXquQ2dz
         NgNRF946pSqUCzSo6aO5b2JQuIfuDyP24503WNffPyOuYgMNRCi7TV+YY86tRhZSn38b
         g/hUPwcvFOvx4FelkVkL5eTDn7U0phpjZIjQBIZQKdIL3o4Je7Jiu2weI4P3KC+VTv4u
         Z1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793400; x=1730398200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YH+mbPnptTbZKuA/hm5M0UadKuVqymsu6NbibnaA6TlgzpG+pNmZTZR5okOyeL+R3i
         QsuqxjC5X97ygZfxr8ja3u1TyQC1Vrf9M8YqC6oxNJn0/vsIxpI95Y1njLw8BK9B7ov4
         /UDJWqOKlBvUcbFPyfZnJsH8IIeniVXBO9Bj4dgvX9xj50+ad1OzsU5FtDkcLWI9LVYu
         JNa+0hAusbkQUB3b021xAwWQrjHxAI5vlOmW/Yo+bD4PtUbdLbUy3nz3ZuUmKGwTXBYv
         i2IWahMHkkqPRuB2PLPDaGYRKTWBeaQWrE7/ZcBtTA1anYwtFwr+3hjMShx5pTPvEMPC
         7jVA==
X-Gm-Message-State: AOJu0YzMMSUHM4038j6c73CU9Hd6RskX+iyuWkYggU04ewVhaIPAeEWQ
	9EIZJDEmILrQsNwH4uoV2WIgcdFUaP/3AiEdTz6LMpE3QSoWnOW3AS/OkKg3
X-Google-Smtp-Source: AGHT+IEjwdKGaRaW3eF7PqmXGCSqm7rSVJSIz4jQuYAO2/poVsqwtZW762ENawSj4FBfkqqUr792Cw==
X-Received: by 2002:a2e:a80c:0:b0:2fb:3960:9657 with SMTP id 38308e7fff4ca-2fca836d3e4mr11617551fa.12.1729793399789;
        Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad4b6f6sm14349811fa.8.2024.10.24.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:51 +0300
Message-ID: <20241024180951.5348-1-vladimirputin693389@gmail.com>
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
