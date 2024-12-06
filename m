Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2042B53A7;
	Fri,  6 Dec 2024 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497548; cv=none; b=EXdMONqlWHB7LFqUgbpD1e+0CSSxy0PYL5iN8brpFX5yFGo6M0uA5N7F2iEVqq8bx1phurP9wxSVYWXAlFWwvAfgk/rLGeKDZyP04DUW8GR1QTuVDbNylPqLEshznKh+OY5kkjN2rLVb8Gr1O+jaxABhIifVESBD8lCiHlqT6y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497548; c=relaxed/simple;
	bh=U8QKatCew93vzkjkPxhxu8WztQ5Tl5FlBnC8T/wCKPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5V7CFgrxnNJxrHA/A1Uao/bmWckWlBSXfPzpAPGN2eAimxbAdqky+6BhIbIQK59ZMhu+OG4jRb0ZeXYmJ/rqCTqPZsj3/g1eKyU+nJsBp4a8e62r2d4aUX6zQn25Xl1MeWfLtlVbSJ/GJPs8Yz88BIJXAcZB2H9R9mbarZ2A+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9Gdt0hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9Gdt0hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E85C4CED1;
	Fri,  6 Dec 2024 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497547;
	bh=U8QKatCew93vzkjkPxhxu8WztQ5Tl5FlBnC8T/wCKPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9Gdt0hGM4ZyBWpjtAOe+x8Odi8piQeQzgcc5gQ6NIG7/GTBA58TjA0P3V3W8Adm3
	 AJ0ECHp6Xq8O3tzsXKRDQsJsBUbS6FMIdJROTXREFkv7xfRLHjsv2fwLJ5T7/3VdDB
	 9QovuCI3ASKkDbAiRGGd2bbP2pZUw6yK2od5FPqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/676] fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()
Date: Fri,  6 Dec 2024 15:32:22 +0100
Message-ID: <20241206143705.961701202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08a4943dc5418..d0ee5fec647ad 100644
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



