Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11A92DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301873; cv=none; b=Bmq93y21WxU07iIYdF+UVQwoN2Z2iLxZzyg6r0A/klGFSLsAga6MgvV78tMLp5EiFdELyLRJmotYMqZV5pIFCvrM3xwExwwSSrmm45LctU7jHr1AfBnX8duadr5K940M6B/LBCONwT3KF/jeAcs2ZhchHX/GxR8H18xK62FxbpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301873; c=relaxed/simple;
	bh=xlM85Jv7GPpcP2/RVIHEtr7pvV7yx/1xIFkhLyeOMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYEj+RtgupcAeox16fOK4i6bUGRxh+iNLt5sR7AkwFVEesOYwKyOgsfufrnDJKQiIWZxDMS92OaqSuE/jMHWq/Q7FhEo0nraV7UsJOoydGgnr7qgPcHnFurtI0Qd0hGfilTAbVPaLWG7f32BEGMi72epk5HiT5YSJvrEWUr0qLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpeSQcL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpeSQcL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C15EC19423;
	Sat, 28 Feb 2026 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301873;
	bh=xlM85Jv7GPpcP2/RVIHEtr7pvV7yx/1xIFkhLyeOMKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpeSQcL9HLi4U511gEUi/0JaGtSTmNBKx62S0rSA7X1uL0lV+L11ZCjYCO5Ki49XN
	 J1n5AplPrIUbO1hWppSo93mWCMtV2ljIMqug3M8xodA1DKuFUOD79OU4ltPMIB5fwS
	 n9ZRF1JIT4Nhv6hwVgOGMiBfUaVbngXt9mAdg5TTHn6K/+fm5qc4uT5dAUfqHOm8SL
	 4AByl+rFtFB81avVcy/uwkYNSPBSL0e0sXOofIuf9T0X0H0vuRCKm9rcWhfxawOYS6
	 DHQOOl8yjgGZCa9PthlU5wj6sGFPNRWezBI+G+konCAmL2+zyMv7LZIhfyvengwvJd
	 ooG+KlIjm0Jbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/385] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Sat, 28 Feb 2026 12:58:40 -0500
Message-ID: <20260228180011.1568201-298-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit ce4e25198a6aaaaf36248edf8daf3d744ec8e309 ]

In au1200fb_drv_probe(), when platform_get_irq fails(), it directly
returns from the function with an error code, which causes a memory
leak.

Replace it with a goto label to ensure proper cleanup.

Fixes: 4e88761f5f8c ("fbdev: au1200fb: Fix missing IRQ check in au1200fb_drv_probe")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1200fb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index ed770222660b5..685e629e7e164 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1724,8 +1724,10 @@ static int au1200fb_drv_probe(struct platform_device *dev)
 
 	/* Now hook interrupt too */
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto failed;
+	}
 
 	ret = request_irq(irq, au1200fb_handle_irq,
 			  IRQF_SHARED, "lcd", (void *)dev);
-- 
2.51.0

