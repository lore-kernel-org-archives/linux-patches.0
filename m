Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C80D17BB16;
	Tue,  3 Dec 2024 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236731; cv=none; b=lYQpYRHzADAU1ELHpOTcmj8L/LwilVbTvobAnExf1lcyHMux50d1kFiI80CkgNM3awyymaVIEojooMGdUCLrkf8d7o62UoOh2dBHSxAhgP7SVuGQHOIbxmWkjbeuJ6qIltGS142VLNTq1YgQoODyJgv62SVPbJQ2bLj7wuOEOSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236731; c=relaxed/simple;
	bh=Y2VP4nktkZt2UMWRkhncT3ZPNv8Ryfs8SjwnMOaEoG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svi9VPR9ZLeFXsnrw6GEz3+gCbnnoxWR+xfToOA+z/eMUO7F1X8GsdR6i2H+HDyMw3sMtXR+vZtJ1FsAEx4DHa4zeg6E/MLgzfa/r3oUUAsIgHdG6Wu0jh7RkIAYpRSuAt+T6jb0E1vdLUjYRGx9Hm63qtLyufj0erXf6CAJrJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZmeEFrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZmeEFrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC21C4CECF;
	Tue,  3 Dec 2024 14:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236730;
	bh=Y2VP4nktkZt2UMWRkhncT3ZPNv8Ryfs8SjwnMOaEoG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZmeEFrOVh3rLVxiQxG8ouAueGK1fx7VdEwa89GjJJQh5XlPqGGFqo3tnbGnGmlvY
	 EVrMeGCIDL9lXpDagY118iOE6gjFVHoy/nNtrbSYopsNQwBnklkbg2GX86c2delLer
	 +X3pzwKZLxeP84RTdIq8l9mlOdN9bUp7M8BqawqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/138] fbdev/sh7760fb: Alloc DMA memory from hardware device
Date: Tue,  3 Dec 2024 15:31:39 +0100
Message-ID: <20241203141926.238443412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 96de91d766230..c8ba3aeb32778 100644
--- a/drivers/video/fbdev/sh7760fb.c
+++ b/drivers/video/fbdev/sh7760fb.c
@@ -362,7 +362,7 @@ static void sh7760fb_free_mem(struct fb_info *info)
 	if (!info->screen_base)
 		return;
 
-	dma_free_coherent(info->dev, info->screen_size,
+	dma_free_coherent(info->device, info->screen_size,
 			  info->screen_base, par->fbdma);
 
 	par->fbdma = 0;
@@ -411,14 +411,14 @@ static int sh7760fb_alloc_mem(struct fb_info *info)
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
@@ -489,7 +489,7 @@ static int sh7760fb_probe(struct platform_device *pdev)
 
 	ret = sh7760fb_alloc_mem(info);
 	if (ret) {
-		dev_dbg(info->dev, "framebuffer memory allocation failed!\n");
+		dev_dbg(info->device, "framebuffer memory allocation failed!\n");
 		goto out_unmap;
 	}
 
-- 
2.43.0



