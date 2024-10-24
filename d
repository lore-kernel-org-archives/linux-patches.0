Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E1D1F5831
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793411; cv=none; b=GFtUiDG9TNKuioTX0Faz6Q+afL0szarALmQXwwad5xwTTFmfJRv72s7rREKEkaOctxd7j3gBcK+P74NcWLxoqlqXiaeJCSFolJzb8yjQZeiMDX7TSrs9EnPZwVNI3JuksWJTKkDVYYqCqKhvxWBB5SVuQuqUI8ym9mavkb+Ub4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793411; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCgC71uKWUTOvQ+otYAN6tjIX2IsN34UW0bt34LAEcrZKBDU9kFhiLipZoxBH9x05TI6apKU24SnfYRlOJ/kX8H5smXH1gW18wWMQGEehu+rRbK1VZi/nyghBcqn48jwdI3bAuTaI5kgfaM8ND9D5fv/E2Gno9qhw8G8gzpv1FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEJH/M68; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEJH/M68"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539e3f35268so1550609e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793408; x=1730398208; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=XEJH/M68B+4+ne3A/FIB+xti+aFGJGOH/ogVbHFHlNBIKNT9VmASMpLogD+nrNIE/2
         CTkRl5dZ9OyltYOPUqGlOmMBNiBwYd0bT4kaJ6XLwwuGHOTOMXSzrRlIBsOMYkb8uqNc
         YZFQlltS475Pue+Ff6hrhFknImWduUrtserPHAlVLeiXoMHbRUfnu6wY8Ly/TNKVije9
         FidFDumkHjNctN0Hknta3bKZk5LuQG9nyZn6rQJ/68S3dV9b74k1eRYAgDNMD4j0jNNK
         CEU+y+U1ChFdYrWpNBizosNnK6BA60cTNB3HFWVJTb2UDNO1hm2ieb9oNTLOItvJ7O53
         cg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793408; x=1730398208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=EeyCfF8ADFR6T13e6U0JbfAJTZEZI1hYLPd0DwIREUMeCNUkPrivGVy+PWLa7ug8Br
         E7Zlsxs+ulRafmHDHKGU4oLb2x1UZCH9eXFpN3IUSmfCfY7TKVZGfuAE6Si083EvCdIk
         igOeqPfqq2V4F806K0no39RC8MjrlsldYUJJGv4oq5BiWTDGFvSSrC0tRoI0Zwd5aZky
         JcpWILG+5fT4JWhpC4mDjmW4NmwdxUtYuwigHeF80qzbgcBPBECratVvGl49FKZQ6/YC
         WgLwhBVnTlJ8NyhYr0enjuHorKH8wSAGfbFSB3XXeN83mBYsN1pkaei9WJ6mVyJ7Fq5j
         qvEg==
X-Gm-Message-State: AOJu0YxtBnpndRxR55AEy/6FpGGNkxo8IOfTsSZ75gywa9YkdXipP2W8
	1QUHSMxgK27VuENOCK99LTA2uasbDCn3HAxQRHB10bKn8KP4j0NyDmqGAjpn
X-Google-Smtp-Source: AGHT+IE2k+DB25nk9m4AeqZ5oem5izsKL+esFw5Xd3lyG7411nBMaaPNsmNq1c3eimMU53CnRP3BvQ==
X-Received: by 2002:a05:6512:318c:b0:539:93e8:7eca with SMTP id 2adb3069b0e04-53b1a321d31mr4125613e87.35.1729793407775;
        Thu, 24 Oct 2024 11:10:07 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224481besm1437356e87.303.2024.10.24.11.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:54 +0300
Message-ID: <20241024180954.5986-1-vladimirputin693389@gmail.com>
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
