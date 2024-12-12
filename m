Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC17223C5E;
	Thu, 12 Dec 2024 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022417; cv=none; b=kr9+jG6+hZXuwUUTkjYJz1kCfiVgrwpwM6RJX6vJiQ0jG8qZVBLCGeoW5Zi1TyAbim0yR+CrXnsFAb3RPiOQAWN8YDubajJDNXciyTbEkfry12+LfnflNlMxysuMWv0aAuG4phJ3o2Cov54s+Qmm5/w8NOogazCeEdK491Y4pqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022417; c=relaxed/simple;
	bh=h4gepbRE9aUtQPPNhjmrkhc57c6H6bOLCahiaeb7ey0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzQFWQ8Lnkuz+ZelHh+QlWtASyCVlhXmrt5arTE+QWmoOCjvMcupO9wPkymT9KcS4OI/KfRhBOLGvG6wHE29HdDU3E8TOM7orFrU2eK8xWkVsTGkiflb8QsJXw6TYJz1FcilooxFaFyLoeDu90sXUFTeD+7++un6UjIXv3hvMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC/4wNU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC/4wNU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E30DC4CECE;
	Thu, 12 Dec 2024 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022417;
	bh=h4gepbRE9aUtQPPNhjmrkhc57c6H6bOLCahiaeb7ey0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC/4wNU8kSpMvLU3/LbukE5rCN+AG5FlPPDZ7vN4oco9UN8Lf+Ti4Z9sE1gwO1iP3
	 t0ah2FEVRS7x+4KKGo7VUOw4+DZI8edWW+5Dcem+5L5WaF84d6RFCcxtaf1enBBdsr
	 tD2M5PQpMFevC3H7wFoEEVwXRzWwhJgdO7lh1q+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/565] fbdev/sh7760fb: Alloc DMA memory from hardware device
Date: Thu, 12 Dec 2024 15:57:10 +0100
Message-ID: <20241212144320.773065060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 8404e56f4bc1d1a65bfc98450ba3dae5e653dda1 ]

Pass the hardware device to the DMA helpers dma_alloc_coherent() and
dma_free_coherent(). The fbdev device that is currently being used is
a software device and does not provide DMA memory. Also update the
related dev_*() output statements similarly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230613110953.24176-28-tzimmermann@suse.de
Stable-dep-of: f89d17ae2ac4 ("fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh7760fb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/sh7760fb.c b/drivers/video/fbdev/sh7760fb.c
index 5978a89212322..6adf048c1bae8 100644
--- a/drivers/video/fbdev/sh7760fb.c
+++ b/drivers/video/fbdev/sh7760fb.c
@@ -359,7 +359,7 @@ static void sh7760fb_free_mem(struct fb_info *info)
 	if (!info->screen_base)
 		return;
 
-	dma_free_coherent(info->dev, info->screen_size,
+	dma_free_coherent(info->device, info->screen_size,
 			  info->screen_base, par->fbdma);
 
 	par->fbdma = 0;
@@ -408,14 +408,14 @@ static int sh7760fb_alloc_mem(struct fb_info *info)
 	if (vram < PAGE_SIZE)
 		vram = PAGE_SIZE;
 
-	fbmem = dma_alloc_coherent(info->dev, vram, &par->fbdma, GFP_KERNEL);
+	fbmem = dma_alloc_coherent(info->device, vram, &par->fbdma, GFP_KERNEL);
 
 	if (!fbmem)
 		return -ENOMEM;
 
 	if ((par->fbdma & SH7760FB_DMA_MASK) != SH7760FB_DMA_MASK) {
 		sh7760fb_free_mem(info);
-		dev_err(info->dev, "kernel gave me memory at 0x%08lx, which is"
+		dev_err(info->device, "kernel gave me memory at 0x%08lx, which is"
 			"unusable for the LCDC\n", (unsigned long)par->fbdma);
 		return -ENOMEM;
 	}
@@ -486,7 +486,7 @@ static int sh7760fb_probe(struct platform_device *pdev)
 
 	ret = sh7760fb_alloc_mem(info);
 	if (ret) {
-		dev_dbg(info->dev, "framebuffer memory allocation failed!\n");
+		dev_dbg(info->device, "framebuffer memory allocation failed!\n");
 		goto out_unmap;
 	}
 
-- 
2.43.0



