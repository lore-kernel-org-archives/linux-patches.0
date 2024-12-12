Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB18D22A81A;
	Thu, 12 Dec 2024 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022223; cv=none; b=S2cnb+T9sqM5Hk+0Y8B3r+PPdtyiYWkzwWtRP8gHdkzHLAnGOMZpcpN2Kt61er8O2PB/1dlygm8WqjWcpISB/m0vfZQHcvGp6GD0MIHT4GsRdyjrrV0ICe/sojbi7SkWTF8QTTYC1TIi/aCeyed23qqynys83D7p5PJzaE0+WZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022223; c=relaxed/simple;
	bh=S+1Aatn++lCWCj9J2taKbXbHLlWD3HY9ZaM4aq3NvUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSaF9Vw8XZOiHAbTDwkmol+hUVvCfaN764twoawiEGDGivEwzWox0zHG3z+CZ5CQ8BlmLI9z8lOudbGwOdoszXekQW19IUd3Q8NDoMlxu8XNtlUJDLroimsDuIwHZXFWC0WmVAbW8TAxFEsjhg0IJ+wRBYPiywx84TD2tyl9zq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWpMh87N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWpMh87N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194CDC4CECE;
	Thu, 12 Dec 2024 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022223;
	bh=S+1Aatn++lCWCj9J2taKbXbHLlWD3HY9ZaM4aq3NvUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWpMh87NvO2jd3Mpbjg+8sM5LQ8wTU35gv5DF9rZdQPd/+54d2vX6jUZs2ejxW+RH
	 9OicVrCwrJZudEjaGfZqOmCNVMM7W+5+eJysfwMhg3v+ABQTHQYA4R5A7e/Fwpmfyb
	 qiJx4l7wT0kdthTc98k5NYiZDKcecBsgFP0xB8JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/565] drm/etnaviv: Request pages from DMA32 zone on addressing_limited
Date: Thu, 12 Dec 2024 15:56:16 +0100
Message-ID: <20241212144318.628483079@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 13c96ac9a3f0f1c7ba1ff0656ea508e7fa065e7e ]

Remove __GFP_HIGHMEM when requesting a page from DMA32 zone,
and since all vivante GPUs in the system will share the same
DMA constraints, move the check of whether to get a page from
DMA32 to etnaviv_bind().

Fixes: b72af445cd38 ("drm/etnaviv: request pages from DMA32 zone when needed")
Suggested-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.c | 10 ++++++++++
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |  8 --------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index c45e5158fdff9..a547af3cf2e10 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -519,6 +519,16 @@ static int etnaviv_bind(struct device *dev)
 	priv->num_gpus = 0;
 	priv->shm_gfp_mask = GFP_HIGHUSER | __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
+	/*
+	 * If the GPU is part of a system with DMA addressing limitations,
+	 * request pages for our SHM backend buffers from the DMA32 zone to
+	 * hopefully avoid performance killing SWIOTLB bounce buffering.
+	 */
+	if (dma_addressing_limited(dev)) {
+		priv->shm_gfp_mask |= GFP_DMA32;
+		priv->shm_gfp_mask &= ~__GFP_HIGHMEM;
+	}
+
 	priv->cmdbuf_suballoc = etnaviv_cmdbuf_suballoc_new(drm->dev);
 	if (IS_ERR(priv->cmdbuf_suballoc)) {
 		dev_err(drm->dev, "Failed to create cmdbuf suballocator\n");
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index e8ff70be449ac..123c8263d27fd 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -798,14 +798,6 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 	if (ret)
 		goto fail;
 
-	/*
-	 * If the GPU is part of a system with DMA addressing limitations,
-	 * request pages for our SHM backend buffers from the DMA32 zone to
-	 * hopefully avoid performance killing SWIOTLB bounce buffering.
-	 */
-	if (dma_addressing_limited(gpu->dev))
-		priv->shm_gfp_mask |= GFP_DMA32;
-
 	/* Create buffer: */
 	ret = etnaviv_cmdbuf_init(priv->cmdbuf_suballoc, &gpu->buffer,
 				  PAGE_SIZE);
-- 
2.43.0



