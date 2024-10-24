Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2CA1FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793426; cv=none; b=VIzSrF6l/PmfwTkQ/jjaLilBYETiL9NHLaT3iZXQQAdJx+tzasspkRiB1NZLcrMLeFLPhSG2fghqnPApowN3jcnAfn+ZYIPDL3cepse1z5gVyKYdhU529nS3s5mVq0ASkt0pn8rmbhbYWihaYQhdty6D3Tnk3M13lCUW/6tPKbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793426; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WImfihsov4DAMXrc4gQucxX1Rb3u7PTuDcKQYykanJ19qcEC60kEkjRVLxnS2CwGcV432ysCz+BL/8LgPQAhU9z141TvFTPDFtPUVS/XOWy7Ff4frD5bpvazimN3PlD7wWwgoXyQbsXM+Q5kJHaVQJkmHvpj1/EVphtWCFfpkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ojp3P6Hd; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ojp3P6Hd"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb443746b8so13076231fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793422; x=1730398222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Ojp3P6Hdec1qpjjMNpNo9cU1gXwRkTswNCPZe2ggvBMMkWgW3fs+ZTNz7dP69JxfpE
         LxYzPp2/CuqUQKpDuFrfYkLsV5Qm8VuJzKj75Y6L3UwHNjCgUestjs3HG7jNmBVfWm9w
         Urp0OehixIRl4rnn+GMJWipi8a0hTWEkcvPUo1RKeG3ZJAU91fMiKOwFo680XVHlJpvv
         xXOOFUbMe7wj+EQ3nDeZ5/UueWgkKD5Ki8mvt86eDJgsm5srSb60T2YN4sTtCyKyZe83
         r6SBcsSbGLu63LaJ4GK8kKBJHonWzAabiZWp4ZL8/EE98GisvLeb47yFkHnrwzcqqStL
         vMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793422; x=1730398222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Sx0x13Pqm4AcMzpGa2+xbzt4uyTQ5cLgKpEEkaaQkpgj1+BOTDPaJr4KEDk2JK2T4K
         W97bEy+8WxEIL056wHOVztPV8BSCYEAoRwBclGov8SkrwHKevHfZQb0oXYDV9qobx2mo
         h7YO15GOQzcQ0GpPwfl3DC1eyLjhDyfRPXLnfkXu25L4u9igDwnDz5kBSlu09aHvusSv
         UGWXxcTO8ZeHIGDTV42brJTioApsoQww7IK0SgmLYHaxKBZ5OZn2gD+XRez0+K34Fe6y
         JzT4kMCT9upAU0cnKuJR+s3NFPfKgXOPqJr4s1dyd0Zt2I2xCkcFhi+tnbUv1zs0VxQq
         mqGw==
X-Gm-Message-State: AOJu0Yxgf5bXG/T9FLockw98X2XYwj4kTIkoIz07hIQpXbvZJSG7GEce
	XfxHn2J8sWE2LcuiTkU9w2aHdUhgLXNElQGOJaAj1xppZSXkFaJE8trBIIKJ
X-Google-Smtp-Source: AGHT+IGpSeIRnOZVPlTmuB7SQVSUx0NVtMQKnFrFNBBo4lZuRNAMASArk0OM3Hip4zYcaqQtZenX0w==
X-Received: by 2002:a2e:6102:0:b0:2fb:3a92:d1a7 with SMTP id 38308e7fff4ca-2fca8264a6fmr16768971fa.33.1729793422376;
        Thu, 24 Oct 2024 11:10:22 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae100c3sm14335791fa.109.2024.10.24.11.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:18 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:10 +0300
Message-ID: <20241024181010.8426-1-vladimirputin693389@gmail.com>
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
