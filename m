Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21B15696E;
	Thu, 12 Dec 2024 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025250; cv=none; b=uYNYRNWQZRx4BfBvfZk1oyJIYLwZ2wEYZX3szIXlGxCJdrug7w9bQqea4S4ENUvGywUBG24dE7gn6nwwIoE2ti/ZREEWsd+wb0lh7qRxp6r988U7DBiP20MYMEFbIMNM84nV9iOTN/TZ5+LOiceGNe/7YOptu6PQXQ+t+yi2rwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025250; c=relaxed/simple;
	bh=KMC8OXdcf/YAPkL7z/mRsIqLn8aPYhON4bPtVOMlYiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHdPSiRO7mV7JOMtmpyrpfp9X0jzxy4ny7N++peHx0Hd8SPOSy90uU8eYIIc1twGXmG0YiYk2VVqHmmzpfvuLFUrYW44+MhlFMwIEcACjpVKyiOLRiPBvR18UDLTgwqEp3Ewpia5y3q9aEOUlaFqzhAyDtHoo/olz73zBvf17z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEN7XO4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEN7XO4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D3AC4CECE;
	Thu, 12 Dec 2024 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025249;
	bh=KMC8OXdcf/YAPkL7z/mRsIqLn8aPYhON4bPtVOMlYiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEN7XO4eqWloerFaWl/lMIgSCEpTqAanzI0UpQCxSNK2zaixLMvj74ABUcvTJx/Os
	 5x9GytSv5KmafdJEHik1TCq6vYDoUeKKjBfH/8WZ0BO5u+lhhH9WZnixBcx9JPqAyX
	 NSBcx1N1yasQL50u+zDD9OFen5oB/kX4H7Ba+YFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/321] fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()
Date: Thu, 12 Dec 2024 16:00:23 +0100
Message-ID: <20241212144234.136398378@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit f89d17ae2ac42931be2a0153fecbf8533280c927 ]

When information such as info->screen_base is not ready, calling
sh7760fb_free_mem() does not release memory correctly. Call
dma_free_coherent() instead.

Fixes: 4a25e41831ee ("video: sh7760fb: SH7760/SH7763 LCDC framebuffer driver")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh7760fb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/sh7760fb.c b/drivers/video/fbdev/sh7760fb.c
index ac65163f40325..e83232bbd7ff8 100644
--- a/drivers/video/fbdev/sh7760fb.c
+++ b/drivers/video/fbdev/sh7760fb.c
@@ -409,12 +409,11 @@ static int sh7760fb_alloc_mem(struct fb_info *info)
 		vram = PAGE_SIZE;
 
 	fbmem = dma_alloc_coherent(info->device, vram, &par->fbdma, GFP_KERNEL);
-
 	if (!fbmem)
 		return -ENOMEM;
 
 	if ((par->fbdma & SH7760FB_DMA_MASK) != SH7760FB_DMA_MASK) {
-		sh7760fb_free_mem(info);
+		dma_free_coherent(info->device, vram, fbmem, par->fbdma);
 		dev_err(info->device, "kernel gave me memory at 0x%08lx, which is"
 			"unusable for the LCDC\n", (unsigned long)par->fbdma);
 		return -ENOMEM;
-- 
2.43.0



