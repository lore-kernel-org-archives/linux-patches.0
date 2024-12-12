Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD1E1487CD;
	Thu, 12 Dec 2024 17:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023938; cv=none; b=Xel2vQvrYe+klnFGdxw+lj/rijookXyAH83lFjFT3IjnXVB7auvmNAlYEMVLBWY4AVao/bSulsCfvilhrdG7+IKoeM96IJ3zYhQkLHM3uEPevhqjCKpZoGGnRNdDzCL+qZrezCrbrVejXeyAH5CzgafBNF+NjFN3/QDftRbYlKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023938; c=relaxed/simple;
	bh=61698ppP8qy5rcMN0Ky2TyMzRjkWgIlkqZSceWL+T/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6RtTCz044JKi6QACGlOuTz739Pu1+XLo5g7YZurHyqpjiJOQZAm7iWWU7Z1E8LSOFp4mVE0cM5ylg76OldHaT6q/YqDzLc0mjV146FgyWX3QtgMdN45HYXNFsQvN9anDa51wj3SOrX8UkAcBD2YrHzn8gqJEqaH+i/Le7u4lMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lN84yBn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lN84yBn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED3DC4CECE;
	Thu, 12 Dec 2024 17:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023938;
	bh=61698ppP8qy5rcMN0Ky2TyMzRjkWgIlkqZSceWL+T/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN84yBn9YQyJ/0SHqMD0a6EgO6QIvvfkM6K3QFII/JPr+aDh5h5F8HDcpl/lwd3L9
	 Pte3OgwMLU70tp/CCOOdQ12j4J7pTzsRl9bCYF6H+3ucxoJPmbvAwRLZNhurWtmt8n
	 gaPxhcN6AkdCbkD9htgCWYwdqMEEKfdSrM8lHHGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/459] drm/etnaviv: rework linear window offset calculation
Date: Thu, 12 Dec 2024 15:57:51 +0100
Message-ID: <20241212144258.767117707@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 4bfdd2aa67fbfba09d7c32a4c7fd4c5eb1052bce ]

The current calculation based on the required_dma mask can be significantly
off, so that the linear window only overlaps a small part of the DRAM
address space. This can lead to the command buffer being unmappable, which
is obviously bad.

Rework the linear window offset calculation to be based on the command buffer
physical address, making sure that the command buffer is always mappable.

Tested-by: Primoz Fiser <primoz.fiser@norik.com>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Stable-dep-of: 13c96ac9a3f0 ("drm/etnaviv: Request pages from DMA32 zone on addressing_limited")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 52 +++++++++++++--------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index f3281d56b1d82..8baa59fb32f2d 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -27,10 +27,6 @@
 #include "state_hi.xml.h"
 #include "cmdstream.xml.h"
 
-#ifndef PHYS_OFFSET
-#define PHYS_OFFSET 0
-#endif
-
 static const struct platform_device_id gpu_ids[] = {
 	{ .name = "etnaviv-gpu,2d" },
 	{ },
@@ -741,6 +737,7 @@ static void etnaviv_gpu_hw_init(struct etnaviv_gpu *gpu)
 int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 {
 	struct etnaviv_drm_private *priv = gpu->drm->dev_private;
+	dma_addr_t cmdbuf_paddr;
 	int ret, i;
 
 	ret = pm_runtime_get_sync(gpu->dev);
@@ -783,28 +780,6 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 	if (ret)
 		goto fail;
 
-	/*
-	 * Set the GPU linear window to be at the end of the DMA window, where
-	 * the CMA area is likely to reside. This ensures that we are able to
-	 * map the command buffers while having the linear window overlap as
-	 * much RAM as possible, so we can optimize mappings for other buffers.
-	 *
-	 * For 3D cores only do this if MC2.0 is present, as with MC1.0 it leads
-	 * to different views of the memory on the individual engines.
-	 */
-	if (!(gpu->identity.features & chipFeatures_PIPE_3D) ||
-	    (gpu->identity.minor_features0 & chipMinorFeatures0_MC20)) {
-		u32 dma_mask = (u32)dma_get_required_mask(gpu->dev);
-		if (dma_mask < PHYS_OFFSET + SZ_2G)
-			priv->mmu_global->memory_base = PHYS_OFFSET;
-		else
-			priv->mmu_global->memory_base = dma_mask - SZ_2G + 1;
-	} else if (PHYS_OFFSET >= SZ_2G) {
-		dev_info(gpu->dev, "Need to move linear window on MC1.0, disabling TS\n");
-		priv->mmu_global->memory_base = PHYS_OFFSET;
-		gpu->identity.features &= ~chipFeatures_FAST_CLEAR;
-	}
-
 	/*
 	 * If the GPU is part of a system with DMA addressing limitations,
 	 * request pages for our SHM backend buffers from the DMA32 zone to
@@ -821,6 +796,31 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 		goto fail;
 	}
 
+	/*
+	 * Set the GPU linear window to cover the cmdbuf region, as the GPU
+	 * won't be able to start execution otherwise. The alignment to 128M is
+	 * chosen arbitrarily but helps in debugging, as the MMU offset
+	 * calculations are much more straight forward this way.
+	 *
+	 * On MC1.0 cores the linear window offset is ignored by the TS engine,
+	 * leading to inconsistent memory views. Avoid using the offset on those
+	 * cores if possible, otherwise disable the TS feature.
+	 */
+	cmdbuf_paddr = ALIGN_DOWN(etnaviv_cmdbuf_get_pa(&gpu->buffer), SZ_128M);
+
+	if (!(gpu->identity.features & chipFeatures_PIPE_3D) ||
+	    (gpu->identity.minor_features0 & chipMinorFeatures0_MC20)) {
+		if (cmdbuf_paddr >= SZ_2G)
+			priv->mmu_global->memory_base = SZ_2G;
+		else
+			priv->mmu_global->memory_base = cmdbuf_paddr;
+	} else if (cmdbuf_paddr + SZ_128M >= SZ_2G) {
+		dev_info(gpu->dev,
+			 "Need to move linear window on MC1.0, disabling TS\n");
+		gpu->identity.features &= ~chipFeatures_FAST_CLEAR;
+		priv->mmu_global->memory_base = SZ_2G;
+	}
+
 	/* Setup event management */
 	spin_lock_init(&gpu->event_spinlock);
 	init_completion(&gpu->event_free);
-- 
2.43.0



