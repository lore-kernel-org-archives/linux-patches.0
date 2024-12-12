Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293D223E71;
	Thu, 12 Dec 2024 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019624; cv=none; b=oYAv/Blh53DQZIM1BMCrFXiwAArjnNUYuI+kS4ocoy9ZDdqHlvrhWoimXSfbsUCU1RCwgP5/oTG4IelcSYTqu6wTz1iM3mOLKiBgeY/gKz9O5C2wtJewJaKdfcIWc7obp/IIDPW6t48h1ZkFMnAU6a5uZaAjbySr2IjKCPiYbK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019624; c=relaxed/simple;
	bh=FN2O969cVFomAMxihUl+tBmlN6E7kKt7iMIVfyskqSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhGzU8j7cgQBHrKxA6htbOAYxtHNH9RWC7hXWie1K5ZPamTi6U6B+FxKV/zw4Fps2xT29G4obAWMYV4/NanicEmc83CU7X7AONdS5IK5m68AlEsOoA2aitmEBRJ1lxAd+onseeeEf8XKBh07fHqDjaYkBztFO5+EksAmQW6BE/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MB9Rse7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB9Rse7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFE1C4CECE;
	Thu, 12 Dec 2024 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019624;
	bh=FN2O969cVFomAMxihUl+tBmlN6E7kKt7iMIVfyskqSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MB9Rse7mBMBAge27IbdwcnCsTOB6hWgEUYfhSCZSaHK0Fh5OWYYozwoSobSNnj2VL
	 eubWHSr4yO3VNDfAhqkVo/qHhAxXs20z5By4YMr7eXGbBpuW0HuGDjjcfnSV52KQgh
	 jx0N0qkFF1aWmCTqM7IC13tcjwxD/Xc/16qH/Oy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/772] fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()
Date: Thu, 12 Dec 2024 15:53:19 +0100
Message-ID: <20241212144400.414721658@linuxfoundation.org>
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
index 6adf048c1bae8..62e28d315d815 100644
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



