Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC972336A7;
	Thu, 12 Dec 2024 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019621; cv=none; b=sSTnsScjPxurFwBV6dxtzX+jhuKMjSla3KbdjihwxBkhycBsuCI/+Ex4rurUWyYVVAQF61HrNU7M1IwZ6t2YM+1dOdyX/WRw4wqt42IFmB/kltl5dBR1AKosCvQucnJtZI9yyiFTRA3q54gCJrLEMuSkuHM80vB1IuF5CQrNTxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019621; c=relaxed/simple;
	bh=PYcon676aJZWBYm9H3Q6VYcIuLDrxO/07OTEJ50u9x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vtso5GK+HkoqT1jc5XkS+WHQw2tTWG3OJzApW5GouD0emAM/AcB9qkmCSj6kIPECHmS4o0BLN4MZfINln/z51yYiZIpGxRt+MIt3yuXqVRwKlfQie67xzLxglbUJNpYnOFSOo7a6AZc7+PxZK83rsOOtgekOE7kqjQ3hv/dd5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYiMoJhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYiMoJhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC88C4CECE;
	Thu, 12 Dec 2024 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019620;
	bh=PYcon676aJZWBYm9H3Q6VYcIuLDrxO/07OTEJ50u9x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYiMoJhWjdaXKq/qVHgrwW9R4WxhaIDEG+1T2HlmA++aiAqVBZWgUV2m3HT5i0Ssp
	 cGGB2inusncyP7ovsgKmpUDgixiAoXRwCZ8K00C3EuelQt441tbH1Ov03+QfF4UkOE
	 Gm8JekswYQX4FsEK7zdsEsqfTaIb7sd9g33Jovqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/772] fbdev/sh7760fb: Alloc DMA memory from hardware device
Date: Thu, 12 Dec 2024 15:53:18 +0100
Message-ID: <20241212144400.372879244@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



