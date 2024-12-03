Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073611F427B;
	Tue,  3 Dec 2024 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236541; cv=none; b=aq8xZeqfdOGWg2PYHfwR0nID6g27bVdIs5YQzhUHK5nPNltG/z1djLKJA/jQhWK9cLD68iAr53U+53+hd6AIMGggIYCvXmFBNWjerAhnBcfNcuSdUJRIealTQBzhg+6xuiRvnW5RFixsNuSspuJ9DcXFwn4ouB1Nz/fVf5ED9As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236541; c=relaxed/simple;
	bh=wYZ8BWOqB83jOvJ6yk7ZvQoWa3qJDq39l75yOSqEOTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maMZaOmlL5xo0NJ48XqqI9u3jt0WzFsXYBd84leRLy6NNmkyKq35yjMF2Gz7Xn/PrSwR1XmVo9gluKlXR0QYKVeUM+3gelVUrwLPU0id4pyDxJfBh9H5cnFcbnOISCOUKGIBEnbPfGW6rEAbHkaRbrmJ2wwoEPq+yyKoG40wBQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmeH5yST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmeH5yST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C6DC4CECF;
	Tue,  3 Dec 2024 14:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236540;
	bh=wYZ8BWOqB83jOvJ6yk7ZvQoWa3qJDq39l75yOSqEOTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmeH5ySTZpSB+wOjW3uQJZ6eSXTySihpwCkwWzotKNeW1wzxc/Bt1ZgVlb9tV4mPO
	 W3IS91aouhKE+z/ckqbUEJklf664eaG9+OWl7jQ+PbQkReltnRoFOmthvCqKYYobCC
	 LbrAYegGMyPWSZXqpmxj9VFtx4sGTh3HMKkmp/7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/138] drm/etnaviv: consolidate hardware fence handling in etnaviv_gpu
Date: Tue,  3 Dec 2024 15:31:18 +0100
Message-ID: <20241203141925.434749998@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 3283ee771c88bdf28d427b7ff0831a13213a812c ]

This is the only place in the driver that should have to deal with
the raw hardware fences. To avoid any further confusion, consolidate
the fence handling in this file and remove any traces of this from
the header files.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Stable-dep-of: 37dc4737447a ("drm/etnaviv: hold GPU lock across perfmon sampling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.h | 11 -----------
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |  8 +++++++-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h |  5 -----
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.h b/drivers/gpu/drm/etnaviv/etnaviv_drv.h
index b2930d1fe97c0..51b7bdf5748bc 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.h
@@ -108,17 +108,6 @@ static inline size_t size_vstruct(size_t nelem, size_t elem_size, size_t base)
 	return base + nelem * elem_size;
 }
 
-/* returns true if fence a comes after fence b */
-static inline bool fence_after(u32 a, u32 b)
-{
-	return (s32)(a - b) > 0;
-}
-
-static inline bool fence_after_eq(u32 a, u32 b)
-{
-	return (s32)(a - b) >= 0;
-}
-
 /*
  * Etnaviv timeouts are specified wrt CLOCK_MONOTONIC, not jiffies.
  * We need to calculate the timeout in terms of number of jiffies
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 37ae15dc4fc6d..0ec4dc4cab1c4 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1038,7 +1038,7 @@ static bool etnaviv_fence_signaled(struct dma_fence *fence)
 {
 	struct etnaviv_fence *f = to_etnaviv_fence(fence);
 
-	return fence_completed(f->gpu, f->base.seqno);
+	return (s32)(f->gpu->completed_fence - f->base.seqno) >= 0;
 }
 
 static void etnaviv_fence_release(struct dma_fence *fence)
@@ -1077,6 +1077,12 @@ static struct dma_fence *etnaviv_gpu_fence_alloc(struct etnaviv_gpu *gpu)
 	return &f->base;
 }
 
+/* returns true if fence a comes after fence b */
+static inline bool fence_after(u32 a, u32 b)
+{
+	return (s32)(a - b) > 0;
+}
+
 /*
  * event management:
  */
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 039e0509af6ab..939a415b7a9b2 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -162,11 +162,6 @@ static inline u32 gpu_read(struct etnaviv_gpu *gpu, u32 reg)
 	return readl(gpu->mmio + reg);
 }
 
-static inline bool fence_completed(struct etnaviv_gpu *gpu, u32 fence)
-{
-	return fence_after_eq(gpu->completed_fence, fence);
-}
-
 int etnaviv_gpu_get_param(struct etnaviv_gpu *gpu, u32 param, u64 *value);
 
 int etnaviv_gpu_init(struct etnaviv_gpu *gpu);
-- 
2.43.0



