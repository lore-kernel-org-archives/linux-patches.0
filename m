Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821E9359A8B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302439; cv=none; b=N29O6Bn4V5lNcEWK0f6vLeBs/J0JEWybHAYyVN4pQyNdjzwqMoTvDd7NSREr5A77tXZjzaWplUIXUoRre8DUySF7I4u6OUcQ9ptIVg2XiEe0DblNtRxoF9BOfTzN+XkgR9DRbQUSKQNyK4YzzkubQFXH099T07jCk0nD5QpWSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302439; c=relaxed/simple;
	bh=B32L9PFJTh1MX/2D5jmbSV6S90vZvZq+TXUDxsvdmzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHJAgBVIMOVXSLYIT2+9sli7CWnzEIlrpcGeJTnP9EtdGNgN5PYq6saCEbvhPunurLtGnKrw5H8eSbGWB36BTBp5ZvA+RkyQOUsdOCJxFMVadvQTMRtWAjcR9EfDPMBAFBmafnTob84rH2Cv9qKJdhSvc41Als9xGByQ4171Bus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4po2NvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4po2NvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA32C19423;
	Sat, 28 Feb 2026 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302439;
	bh=B32L9PFJTh1MX/2D5jmbSV6S90vZvZq+TXUDxsvdmzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4po2NvOrNZWBb9qACP2N+JIETazZnYZwWdJrrTEemcCvaWt0XrDBsVcK6/DsmMEP
	 oNSSNcxNYSAwtQgS7PXbTB2WaKU3jFb2oVzZMgqO9afrZWXXWYLapjxS3fyzxCFato
	 99m4BJjc56thgSL6ywqNPm5QoGg7FoChVoZMyPYxD0/4nkh3KDkiNpJKumTRpG1SKt
	 WmjVaLV8xL/DUI1/z09oOdxJ44d9oCwObxIFHSFM8UEMrDOLFf+qVGIJ0sSuPdovSX
	 rbhBLkoaVoHFeVRvZg+oKr8KC7jeuw0eK0K354Sy0W4XK3rioBbr1cWwH3W/nel2W7
	 Ojaoqyh6n/Beg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/232] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Sat, 28 Feb 2026 13:10:30 -0500
Message-ID: <20260228181127.1592657-177-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index fd3ff398d234a..f55f3380f17e5 100644
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

