Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7015D1F4711;
	Tue,  3 Dec 2024 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236734; cv=none; b=t8eYnIHiOiHegtXzWHiROWOHpW36iS25eNwhGOZE3ojpHhY+Rw6qH83DxMXoUA79PkYP8cciaG75SKsvQoNh61uhoP3jbvSeQzLqDOY8On3yx3jjTaCySlgrBVO0g0G7+pUSfyFlv9fEX3nzif2ltOf7e92aPB2EqlT+sEbc69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236734; c=relaxed/simple;
	bh=hA7zEwO88XNaySpAo4S/GmpjRg0LSqx79DILYU8mZ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVGCKmeGSZvmt1xorAACnoqvjMsSkJcjWpC7GyPfEAVcsCI+9Fe0TfZ/4dUme5iFY1j4T2m8jzQlFK/nKiaztjZqNh6NtkYdHkkpQsNd0h+6BrLlbKqsLTHCExEDhhTWOSIc9KVwjCasdntQCkBMd3yWElRexxYamgVp/0IBvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXdJeAHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXdJeAHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F0AC4CECF;
	Tue,  3 Dec 2024 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236734;
	bh=hA7zEwO88XNaySpAo4S/GmpjRg0LSqx79DILYU8mZ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXdJeAHgZ+8yCAnCloAd59QF8c/surj9hCIewYz+3EXXIhqe2/2ZI5ZjMVrtcyQjb
	 NKDWHtAARJcclMcVuKEPEKo6fI4QwJhlEKnQOVb0gPlVtfoqwilQyLxATyq3Fu7Ve7
	 ZYrfCTGNy/Y8Y2eCEhmvcUMldvcH6d2sw7/0+ZaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/138] fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()
Date: Tue,  3 Dec 2024 15:31:40 +0100
Message-ID: <20241203141926.277422588@linuxfoundation.org>
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
index c8ba3aeb32778..d4ef70b178859 100644
--- a/drivers/video/fbdev/sh7760fb.c
+++ b/drivers/video/fbdev/sh7760fb.c
@@ -412,12 +412,11 @@ static int sh7760fb_alloc_mem(struct fb_info *info)
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



