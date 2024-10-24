Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2615A1FBF50
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793423; cv=none; b=tBZiKIwupamKLTa6ictthokyZGGA1iObfJz2SngYOyHrokX52PSbJQxQQ70hhYWKzyPhPkvdil8MatlKBLzJKNJGGBBEjhDKNF11AS3N9cNGqbOWd1zwc7DCJpcK48jSllqxi1ECbJxKQ+NCEeQdoeRO9s2jLCWD5uMXWoA76wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793423; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmTfqWhpXsEtXPZVhCIbbsjL1K6MyIC/oVPkBhqB2XmEDa00z5vaL2ohv1nmVky18h8EdK9G71DoH5x1J/kY5EeGJC1B9yJaMOBUwK5C58yA+iQfHedwIQLB5NIRmLu98/cD1SAEM2mQBpFXZMBL0uTQAB1XfOzMsLEn+o5TWbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=laWcBIOY; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="laWcBIOY"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb4ec17f5cso11462831fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793418; x=1730398218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=laWcBIOYx/O+KDUkMVg6p35D5/md1tCybtZwGOQ5ll2AU7HK1Gkbt039o9eRQHQK4j
         SqrlbwQVyWv+Z8tPLLrwvN1PTh7Yv4G12bKdrkMnRF3FNlwo0ONvxX9Pwi+R0zsL6Bi3
         n72J56p0HiMSVBv7sWnZZvPG3gDMob3Q9C/a4S7d5uS9tFn1noPSh+cVpa/ZpgpuCaIk
         f1iUyaHJPa1fZBVeEoo3j3PHdX0G4jkqdp6etU0laGzGIa7WHgBV0LnvNYZPlkkoQeuL
         mph7ALNrmrg1uDa01Zs97uFihdXYaAGUJlkK4N0B0Tmg1NZ/Og63sZ+2ST37XdQk65J4
         +Agg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793418; x=1730398218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=YePFGg4Hbm6w6TPJcQb5OgsPlsdRs+LUW0yAl2xGC1BWQs8n9XK9e8xkcqmDWAsuY0
         xrpmWBAb8FfBIcne91aCNU+Ii7UFz3LTwqAJnwlmhyXxsCso/WlL6qBtnunP3CcZMtuL
         O3FEDQ9JKmgaadlhNIdJdFvFilageC9mw5ZABvTSYR4whTRBcLAfAq8+1Fo5h4xoBJGN
         XkwQckdLCpVD8Jh1jp4PDqAD5UBjFWu/BtF7yJ4gYvyDPpMc6PYeSBqZlTE+DAMCqIfP
         mEZ/v4mieB9aCPLUOkccjddsvxFr5csJtz8b1baI4cqvZ/ZZesId+18GGmdR9s/RYkLv
         2V1g==
X-Gm-Message-State: AOJu0YyOzwtGNu4gTrabF2EF3y3+/BmO+71uUtC8aGFHv6PX+Xmz3QBc
	oYMVS5d1rNrch1Y3f9WZixOCF5KNdYeg7670nqhgovt+wC+fJqyP
X-Google-Smtp-Source: AGHT+IH7OGDEDzL2ux616XX/znrIqyduia9Lg7bEs9EoX1ITPYHBVASZOhA9u5af2CRT/7uUy05K2A==
X-Received: by 2002:a05:6512:b02:b0:539:e3d8:fa33 with SMTP id 2adb3069b0e04-53b1a38d08cmr4588139e87.54.1729793418165;
        Thu, 24 Oct 2024 11:10:18 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223efb24sm1422817e87.65.2024.10.24.11.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:05 +0300
Message-ID: <20241024181005.7551-1-vladimirputin693389@gmail.com>
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
