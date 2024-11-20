Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62D61A9B5A;
	Wed, 20 Nov 2024 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107560; cv=none; b=hRx4pZ/3ylEZJ6oFoNovGJMwbhyXnmaX5BK5oBQAZwirMKKKL6HarXUq6TcaXieCy10EUiKYVE1kUwj49XnrteYXOIQ/0qymOXGi6zGe3DE7dTRAIJibwkibdCdjC/9b0VqFiXQBG60CnEdQEjBa2Ox9tZ6OBz4JCVCb6DBQ+i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107560; c=relaxed/simple;
	bh=vH7C79dM5seNM7fCWPZTV1Dc7UC0PUv8WdPRF32gXIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGueFJLXXL2JbRwro4owhiKn1C5XRV6SKa23dJwJXEpGk5WLtF41IT21AmNzqOwpUVh7ajqA3gOi7iYDbSDVBYrRaqrWtQf8JgmAttd/vkiGcmfu20MxERDld5wSyoy7KPj/kHd+BfglG8nSFAyF1snSMQpWmmpAIZPlEpu3OGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVEF5l7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVEF5l7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50A5C4CED2;
	Wed, 20 Nov 2024 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107560;
	bh=vH7C79dM5seNM7fCWPZTV1Dc7UC0PUv8WdPRF32gXIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVEF5l7qySQyalG1jQ/54Bl1E2YbQt91fMZnQMwTvBSg0kHfiZyDg/vtg8v7QUruR
	 p0+nIunGpFpbTgl/DOuuXe/sxFtiO5hfo1XUPHoxkPgIcndD3XZoWNVUiNRGlHjuyC
	 N7Q5GOSrCo1QFyc+/qdMHG2PtiZA9FpexM3bgJQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 103/107] drm/xe: Restore system memory GGTT mappings
Date: Wed, 20 Nov 2024 13:57:18 +0100
Message-ID: <20241120125632.055445412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit dd886a63d6e2ce5c16e662c07547c067ad7d91f5 ]

GGTT mappings reside on the device and this state is lost during suspend
/ d3cold thus this state must be restored resume regardless if the BO is
in system memory or VRAM.

v2:
 - Unnecessary parentheses around bo->placements[0] (Checkpatch)

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241031182257.2949579-1-matthew.brost@intel.com
(cherry picked from commit a19d1db9a3fa89fabd7c83544b84f393ee9b851f)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 46f1f4b0f3c2 ("drm/xe: improve hibernation on igpu")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c       | 14 +++++++++++---
 drivers/gpu/drm/xe/xe_bo_evict.c |  1 -
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index e147ef1d0578f..c096e5c06f726 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -869,8 +869,8 @@ int xe_bo_evict_pinned(struct xe_bo *bo)
 	if (WARN_ON(!xe_bo_is_pinned(bo)))
 		return -EINVAL;
 
-	if (WARN_ON(!xe_bo_is_vram(bo)))
-		return -EINVAL;
+	if (!xe_bo_is_vram(bo))
+		return 0;
 
 	ret = ttm_bo_mem_space(&bo->ttm, &placement, &new_mem, &ctx);
 	if (ret)
@@ -920,6 +920,7 @@ int xe_bo_restore_pinned(struct xe_bo *bo)
 		.interruptible = false,
 	};
 	struct ttm_resource *new_mem;
+	struct ttm_place *place = &bo->placements[0];
 	int ret;
 
 	xe_bo_assert_held(bo);
@@ -933,6 +934,9 @@ int xe_bo_restore_pinned(struct xe_bo *bo)
 	if (WARN_ON(xe_bo_is_vram(bo) || !bo->ttm.ttm))
 		return -EINVAL;
 
+	if (!mem_type_is_vram(place->mem_type))
+		return 0;
+
 	ret = ttm_bo_mem_space(&bo->ttm, &bo->placement, &new_mem, &ctx);
 	if (ret)
 		return ret;
@@ -1740,7 +1744,10 @@ int xe_bo_pin(struct xe_bo *bo)
 			place->fpfn = (xe_bo_addr(bo, 0, PAGE_SIZE) -
 				       vram_region_gpu_offset(bo->ttm.resource)) >> PAGE_SHIFT;
 			place->lpfn = place->fpfn + (bo->size >> PAGE_SHIFT);
+		}
 
+		if (mem_type_is_vram(place->mem_type) ||
+		    bo->flags & XE_BO_FLAG_GGTT) {
 			spin_lock(&xe->pinned.lock);
 			list_add_tail(&bo->pinned_link, &xe->pinned.kernel_bo_present);
 			spin_unlock(&xe->pinned.lock);
@@ -1801,7 +1808,8 @@ void xe_bo_unpin(struct xe_bo *bo)
 	    bo->flags & XE_BO_FLAG_INTERNAL_TEST)) {
 		struct ttm_place *place = &(bo->placements[0]);
 
-		if (mem_type_is_vram(place->mem_type)) {
+		if (mem_type_is_vram(place->mem_type) ||
+		    bo->flags & XE_BO_FLAG_GGTT) {
 			spin_lock(&xe->pinned.lock);
 			xe_assert(xe, !list_empty(&bo->pinned_link));
 			list_del_init(&bo->pinned_link);
diff --git a/drivers/gpu/drm/xe/xe_bo_evict.c b/drivers/gpu/drm/xe/xe_bo_evict.c
index c202197efbe05..ef1950ab2c1d8 100644
--- a/drivers/gpu/drm/xe/xe_bo_evict.c
+++ b/drivers/gpu/drm/xe/xe_bo_evict.c
@@ -170,7 +170,6 @@ int xe_bo_restore_kernel(struct xe_device *xe)
 		 * should setup the iosys map.
 		 */
 		xe_assert(xe, !iosys_map_is_null(&bo->vmap));
-		xe_assert(xe, xe_bo_is_vram(bo));
 
 		xe_bo_put(bo);
 
-- 
2.43.0



