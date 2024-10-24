Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7D51FE0E7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793418; cv=none; b=N27qCX956ljDJ7eRXhiHVTnPehqy5Q5JO3eFYeYT713mnkF3Jv+1cH7fBdajIqhYhf/7OzG3ptliJtOAxbASftYhJxVUDA1Ffz3iESqq0y6d2dNzuhZgFlIFLGUOv6PTYIpFwx5eysV/IMpNHdiiea/Ir2XOke0PwM9pmlyiabM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793418; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRI3EFprMFNZRHjdOOlSkUsbcXa9p/bC5NiYm1Qc1pgQPw3Lqit3tZxA4PS4j0EVfq5sF2PKj8BVCT8Q0MHwFUg9/Xdh1a1nSTwfPJZ4gNq3/lP+B2+uGcDqktlhYLDmpTxnPnyLT4I5WAKtWvvOoJWnVF0FURn/1hBOGuIAsGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSkgQoDc; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSkgQoDc"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so13068541fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793414; x=1730398214; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=iSkgQoDchObDMDilYYW9MThfjskBqDd7BgwqbE4nIY0uhjpRREnUg7y/U4DucOf5DB
         Wk7gdStEP6lwO7FlQh72+1YmJsrEijS25trmcde+pvxSBN/IZVEPCGk8yZwVb5BBfXmE
         KV6z8n5osBRpLEudy9SDhc+VN5Nor01PFdaBCqVqa1wme0tB6zCERxGlyZ2bdddlP+SL
         Gr2CNpKiAT2000aje2QI/ifX9X0m52KysadqnZyTrxPvgOP6/DIRATgPc2m3S93Ip+27
         BpBLRrWyZnMBRVG1oM7ckKF2iCy2unaMSDXwKXvZeSqwcD6S1nJDE4f9hOHysvZzZAH1
         uDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793414; x=1730398214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=mBp+7+4VYGaw2y6vfpCkRBz2UCdK7Mt69YUfiIb5Uy85/ReJKOt5Mw7r2JyELdLrY/
         Vr6qstbvavCuHLg5H1r3jwXSmG4SuRuURcwjKGYL6gk3S0eH/89e8QyQon1m4YfSdt8k
         Elmv2yj8aMz4QM1JGdS4yT+D7MY+fLRZ4vy4ISgUrWIBVx9abBECarJ+g7Sh6VhV1zQF
         FtUmirmiLvP0xjpONObsYsZTP+zJA9j3o87CPulS9HAducwE18mRX2oP6wy/YbwW20L+
         zaoh28fWtprySyoYRn9J6JvynJOhG3qW1pwFZbhDqkMIb9zTHFLqRqEv1eVsyMnNz9Nd
         vH3Q==
X-Gm-Message-State: AOJu0Yz1tyr3m/8dxqIItBbhiiTrA2/n6K4w9WtSu0ZQxq2cJ16XfpbW
	vXLyI85MLfpOuWQfy7nQx6t6vYTPgRnjPSvWcF2WtMNclsgQ3b7BkLTZY7yz
X-Google-Smtp-Source: AGHT+IEiAMJeiSbgFNOqRkLPXXgY7AOwb5f/TEqA2Ndc49us4axWOpS9qIuiQ95XR8q+jWTk43PfiQ==
X-Received: by 2002:a2e:859:0:b0:2fb:5da7:47a1 with SMTP id 38308e7fff4ca-2fc9d353f9dmr33457031fa.16.1729793414069;
        Thu, 24 Oct 2024 11:10:14 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae12187sm14555771fa.114.2024.10.24.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:59 +0300
Message-ID: <20241024180959.6846-1-vladimirputin693389@gmail.com>
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
