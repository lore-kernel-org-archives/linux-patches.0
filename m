Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD4153800;
	Tue,  3 Dec 2024 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240942; cv=none; b=GtXRuaZDVjOaEAwm3PNCcMYwOadL4NjBnXH82Ih7SoOrLjD1c7sjaMRr4I37FM5bVvUResOBV4nxrlbNJCNC5dINbWCJbwJ2E03lCDoH85i3YJ1v5cqSsYitgCwxr8GYYYfHVChYFKnugJIOJkeM9LMasoINqR2cGCDPGIb4rOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240942; c=relaxed/simple;
	bh=pIBVjTzuRx/ZawJF0ypHRope5VOdStqmeRFaW6MPiks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1ppzNoIRTJ0RzTU3TKng2kv637Y+mZzHUMSJXvjAjBu1dkWoqudYsHb+Dx535ATEyRu++MdzdO2K7flMQUVg6UFbDd66N5UNE4qN0OREdc9iKRRcgFef/eFvG97sU3Shk0w2opw2yZSCFgKHVWvsnoFusa5NG/+TPWyntQzmOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkEgXvtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkEgXvtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBF8C4CECF;
	Tue,  3 Dec 2024 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240942;
	bh=pIBVjTzuRx/ZawJF0ypHRope5VOdStqmeRFaW6MPiks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkEgXvtP4nRafIdOeKW+g00c1WPt8I1OqZShHsOYNDvmNQ4uWC69cymZt9kjubolQ
	 +DkWFD08aSgOA9W0DqXCSnkjnAB2ARevj5/uNU+fQBClr4Ho0P4M/j+kKWPsdkoTe9
	 /GJ0W10jWHUHdLsdG8UUjXqZhiEomcBzYsi0bvU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/826] drm/etnaviv: Request pages from DMA32 zone on addressing_limited
Date: Tue,  3 Dec 2024 15:40:08 +0100
Message-ID: <20241203144754.732887287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6500f3999c5fa..19ec67a5a918e 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -538,6 +538,16 @@ static int etnaviv_bind(struct device *dev)
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
index 7c7f97793ddd0..5e753dd42f721 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -839,14 +839,6 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
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



