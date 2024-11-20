Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE581BC076;
	Wed, 20 Nov 2024 12:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107562; cv=none; b=OkZxoBX3GJ+rpJahVO8ksctYHuOBPJh7GgCSIGnjuaSQ4V0bhSb3ELjw3Kp9PlhPxU0I3SxLaOvzStOERgVCQHPjavM3+nEYdApABXeg9y56ANrsVvXTZiUeN6Fwma8lK01aRTL9B6HjcQPbLHFcEIYq7ePgwSoPFJJiUqPUjIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107562; c=relaxed/simple;
	bh=ocfPMPVI6I0d+xpVC1N/Vko+kYWwyab77faojR4iSek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz5vsBrYyqln5jYs3IOPmpfkD13JxSkJbFJ7mLI8lAWyyUweRauzmq/Nwj1U3kL5ZtZUoLTCwcvJmnMLO43CRTK/rJx9OzgILoShzOZ0aFB3Z5vfzYBnovn9SXayHroNSFBcD6THefA+05fpL5nD4h4zrk+3sr91ujWBUJe9uuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqcIdmGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqcIdmGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84113C4CED8;
	Wed, 20 Nov 2024 12:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107561;
	bh=ocfPMPVI6I0d+xpVC1N/Vko+kYWwyab77faojR4iSek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqcIdmGkFZT9AKoE7y5GevJ23cOVesNujwwpdOH9+40R6y+AkXtDTH7poD0AoC6zd
	 aYhT8m3BSwZHlvc1N1tYtiGCjn4OiS9X5OZBcY31JWwXTCqw/+MghhHntDZulhxzlP
	 H1J73ERDgvR6Rb6VI4w+md+OBLtoNV483LPfNQR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 104/107] drm/xe: improve hibernation on igpu
Date: Wed, 20 Nov 2024 13:57:19 +0100
Message-ID: <20241120125632.078645187@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 46f1f4b0f3c2a2dff9887de7c66ccc7ef482bd83 ]

The GGTT looks to be stored inside stolen memory on igpu which is not
treated as normal RAM.  The core kernel skips this memory range when
creating the hibernation image, therefore when coming back from
hibernation the GGTT programming is lost. This seems to cause issues
with broken resume where GuC FW fails to load:

[drm] *ERROR* GT0: load failed: status = 0x400000A0, time = 10ms, freq = 1250MHz (req 1300MHz), done = -1
[drm] *ERROR* GT0: load failed: status: Reset = 0, BootROM = 0x50, UKernel = 0x00, MIA = 0x00, Auth = 0x01
[drm] *ERROR* GT0: firmware signature verification failed
[drm] *ERROR* CRITICAL: Xe has declared device 0000:00:02.0 as wedged.

Current GGTT users are kernel internal and tracked as pinned, so it
should be possible to hook into the existing save/restore logic that we
use for dgpu, where the actual evict is skipped but on restore we
importantly restore the GGTT programming.  This has been confirmed to
fix hibernation on at least ADL and MTL, though likely all igpu
platforms are affected.

This also means we have a hole in our testing, where the existing s4
tests only really test the driver hooks, and don't go as far as actually
rebooting and restoring from the hibernation image and in turn powering
down RAM (and therefore losing the contents of stolen).

v2 (Brost)
 - Remove extra newline and drop unnecessary parentheses.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3275
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241101170156.213490-2-matthew.auld@intel.com
(cherry picked from commit f2a6b8e396666d97ada8e8759dfb6a69d8df6380)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c       | 37 ++++++++++++++------------------
 drivers/gpu/drm/xe/xe_bo_evict.c |  6 ------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index c096e5c06f726..9a01babe679c9 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -931,7 +931,10 @@ int xe_bo_restore_pinned(struct xe_bo *bo)
 	if (WARN_ON(!xe_bo_is_pinned(bo)))
 		return -EINVAL;
 
-	if (WARN_ON(xe_bo_is_vram(bo) || !bo->ttm.ttm))
+	if (WARN_ON(xe_bo_is_vram(bo)))
+		return -EINVAL;
+
+	if (WARN_ON(!bo->ttm.ttm && !xe_bo_is_stolen(bo)))
 		return -EINVAL;
 
 	if (!mem_type_is_vram(place->mem_type))
@@ -1706,6 +1709,7 @@ int xe_bo_pin_external(struct xe_bo *bo)
 
 int xe_bo_pin(struct xe_bo *bo)
 {
+	struct ttm_place *place = &bo->placements[0];
 	struct xe_device *xe = xe_bo_device(bo);
 	int err;
 
@@ -1736,8 +1740,6 @@ int xe_bo_pin(struct xe_bo *bo)
 	 */
 	if (IS_DGFX(xe) && !(IS_ENABLED(CONFIG_DRM_XE_DEBUG) &&
 	    bo->flags & XE_BO_FLAG_INTERNAL_TEST)) {
-		struct ttm_place *place = &(bo->placements[0]);
-
 		if (mem_type_is_vram(place->mem_type)) {
 			xe_assert(xe, place->flags & TTM_PL_FLAG_CONTIGUOUS);
 
@@ -1745,13 +1747,12 @@ int xe_bo_pin(struct xe_bo *bo)
 				       vram_region_gpu_offset(bo->ttm.resource)) >> PAGE_SHIFT;
 			place->lpfn = place->fpfn + (bo->size >> PAGE_SHIFT);
 		}
+	}
 
-		if (mem_type_is_vram(place->mem_type) ||
-		    bo->flags & XE_BO_FLAG_GGTT) {
-			spin_lock(&xe->pinned.lock);
-			list_add_tail(&bo->pinned_link, &xe->pinned.kernel_bo_present);
-			spin_unlock(&xe->pinned.lock);
-		}
+	if (mem_type_is_vram(place->mem_type) || bo->flags & XE_BO_FLAG_GGTT) {
+		spin_lock(&xe->pinned.lock);
+		list_add_tail(&bo->pinned_link, &xe->pinned.kernel_bo_present);
+		spin_unlock(&xe->pinned.lock);
 	}
 
 	ttm_bo_pin(&bo->ttm);
@@ -1799,24 +1800,18 @@ void xe_bo_unpin_external(struct xe_bo *bo)
 
 void xe_bo_unpin(struct xe_bo *bo)
 {
+	struct ttm_place *place = &bo->placements[0];
 	struct xe_device *xe = xe_bo_device(bo);
 
 	xe_assert(xe, !bo->ttm.base.import_attach);
 	xe_assert(xe, xe_bo_is_pinned(bo));
 
-	if (IS_DGFX(xe) && !(IS_ENABLED(CONFIG_DRM_XE_DEBUG) &&
-	    bo->flags & XE_BO_FLAG_INTERNAL_TEST)) {
-		struct ttm_place *place = &(bo->placements[0]);
-
-		if (mem_type_is_vram(place->mem_type) ||
-		    bo->flags & XE_BO_FLAG_GGTT) {
-			spin_lock(&xe->pinned.lock);
-			xe_assert(xe, !list_empty(&bo->pinned_link));
-			list_del_init(&bo->pinned_link);
-			spin_unlock(&xe->pinned.lock);
-		}
+	if (mem_type_is_vram(place->mem_type) || bo->flags & XE_BO_FLAG_GGTT) {
+		spin_lock(&xe->pinned.lock);
+		xe_assert(xe, !list_empty(&bo->pinned_link));
+		list_del_init(&bo->pinned_link);
+		spin_unlock(&xe->pinned.lock);
 	}
-
 	ttm_bo_unpin(&bo->ttm);
 }
 
diff --git a/drivers/gpu/drm/xe/xe_bo_evict.c b/drivers/gpu/drm/xe/xe_bo_evict.c
index ef1950ab2c1d8..8fb2be0610035 100644
--- a/drivers/gpu/drm/xe/xe_bo_evict.c
+++ b/drivers/gpu/drm/xe/xe_bo_evict.c
@@ -34,9 +34,6 @@ int xe_bo_evict_all(struct xe_device *xe)
 	u8 id;
 	int ret;
 
-	if (!IS_DGFX(xe))
-		return 0;
-
 	/* User memory */
 	for (mem_type = XE_PL_TT; mem_type <= XE_PL_VRAM1; ++mem_type) {
 		struct ttm_resource_manager *man =
@@ -136,9 +133,6 @@ int xe_bo_restore_kernel(struct xe_device *xe)
 	struct xe_bo *bo;
 	int ret;
 
-	if (!IS_DGFX(xe))
-		return 0;
-
 	spin_lock(&xe->pinned.lock);
 	for (;;) {
 		bo = list_first_entry_or_null(&xe->pinned.evicted,
-- 
2.43.0



