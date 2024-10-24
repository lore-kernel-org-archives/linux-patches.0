Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674E52003C7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=MwgQy+rEbjfB34X0KHWygP4tIgYnFq3wO3FKjGsqWCVC+krmJ76riUriIcWPL8NuWr+IPehquUWXU0XhxdU27CzipBlncUaNlIpLy4GQayfM+HfxqQdPekFcS1ZeZQntniOTGdpZl6+fEbtRbNI8hJKuZ7K+TaOhdn9UrNjhwJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu/LN8pC0g/XaDAe9qdCZLQn98Jk608D3PXVKBNg2jVqq5KSsVdytH4r1V+nSjTXOHPuc9Os4C8HJpxpsWUpajMrAa/2BARO2kwpl0yHdTUlSyrhRu11z0PUNXDuoC/pN4WSeI0h9t8DAMsotEXVu0/+fi2z6Sg8FiAMDDTxLtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVJHzh9B; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVJHzh9B"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53a097aa3daso1094942e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=HVJHzh9BlCl34Oj2JXbxBC4T1on4zKw3Dvm4NcpWSMxN0U/zuTR5kM4WvFscnU69Yw
         tclRy5kxSrKWa8h3rqBMRaFMEMivTFVfdgRN6WxOlhzp4FCiRreZU5ycp5dcLwFZid5T
         7UdOIbrlhvXCARHwISMrGpMa255FjJ4t4Eh2UYap9cwN86Mjgy8sp6uL9i7KChuE+3tX
         WASsDdAYp8x4qlR86Is5PnCk25cbkMFldUJ4j39JInUdUl8JsMR4V+XOobJNRRjuW7f1
         O5jvDEC9+oGhZE8J0j8j69BY9agbgZ9+QCYEtXRnhkp+SOoWCKqiSzxCrU9nwDX4oOUE
         UdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=l0B5PpZ4g5fXQucdZCSTsLWfke/xxjlvsSxq+U6jqza+FRSnjkkD0141UepKnl0NFs
         bl9L9NwNT+y1ABYHEgo7n8zymkOrVZvnbtVnztsSwU5kJvjZP8FcaSC57mub1t/EpYT5
         IUIVZc1pE7gVod2Ep8En6mGWDMCdq5519acbynJBZdHrYqWoKxT+zS0RWf15yv/xjXJs
         qSM8+GuVBA8B1ZQ+46Lxm1hfcn7oYonQhE0y3kDjizSGESONN5T5rXzu1MTYjOh95ZPJ
         Nis924TW/eWOosz0YC65919ufMvIqd+Tc+3nfcie9ISu0BeW2ECglL5nckXy/y5zsx1E
         XGhg==
X-Gm-Message-State: AOJu0YxyfcWPM/A31PLEP7ou9ByvjmksIt0l8INzdmHjE2nHzO+a8jJI
	96uKlSRRIwxLhRph0hTc25ZRRJkzrPsP/uvsEAocceiIxKS98w6w
X-Google-Smtp-Source: AGHT+IE9HuzigrzeWrUQK6wKoxLHEAQcCmjEbmYvDx4xEYNPhh4iHTdEEnY3Ey6j+zgt5RIHU0n+wA==
X-Received: by 2002:a05:6512:a86:b0:539:8bde:eb90 with SMTP id 2adb3069b0e04-53b1a31136dmr4310067e87.32.1729793387474;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223eff63sm1424446e87.92.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:43 +0300
Message-ID: <20241024180943.3711-1-vladimirputin693389@gmail.com>
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
