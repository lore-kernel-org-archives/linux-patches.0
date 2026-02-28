Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC633AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302747; cv=none; b=oIUHnkpNVjJC59gzq9E1lqYCnuwJat25UOqXkJEZop+FiVAad1p8e14LkT8qiHUj+JEiE7h9ibmafx/ub29dSx4COwHW8rFsUJ996MpK26ytPn9bSFH24daDXYhGcWWeyl/THcWAgG1aHI8hAnYSQXe4Euv5O/pANQuaDE+Z7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302747; c=relaxed/simple;
	bh=k1oheUIR7E0MJ/UsBSmsbkCKqljoOvBgxuJAFkVzAWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXXCEY1P+m+N919ZeaMtBuDcRTseu4iEcZgfwXqiSxeAcS5pE3tpcOF/PObucZZAevo6BUQENQ5+oXmuvVKEAI8/BEVmxSlTAhrvxKOk2GuUIw/9XBHt6z705IzJQNw1FEDUehL5/utVWkhjGKQCMw0Juo7lbggYcmywEAgVHkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kl1n5vZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kl1n5vZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F19C2BC87;
	Sat, 28 Feb 2026 18:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302747;
	bh=k1oheUIR7E0MJ/UsBSmsbkCKqljoOvBgxuJAFkVzAWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl1n5vZ6B3hYdFPzwr+uLUDU+Va68Nqhv1qj4bXDDPH3k9zGclIHpgc6crAMi86Lx
	 ziR0F90PKOI4f1ybsAJsI3OlZkNkhFFpa14l5jYLqpxWDUkZP9erJbR0WsyzKZ7jJ+
	 uevxCOrpMxu5a6KZvsrHXTcTkp5lMVs0JPVy/+WKPY0Ny1LDXW5lfpAv40NVrp0k+u
	 yfz2iPRCS+pVRyk9Y1J+y/jEFvwMIK4d2wYaQ0QL/OF/SrPZL5mbsGB9ihbpSQYbUT
	 CvJaiPleLeKoC47oMm6I6/lKJunOvHWUMHwnqKnzy13FwQ486sJYJNc2MPq9W6j+nB
	 zK1VEgWPlBetw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/147] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Sat, 28 Feb 2026 13:17:02 -0500
Message-ID: <20260228181736.1605592-114-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 80f54111baec1..ec1d86f253904 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1732,8 +1732,10 @@ static int au1200fb_drv_probe(struct platform_device *dev)
 
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

