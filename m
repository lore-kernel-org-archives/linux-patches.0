Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA0FAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED8C433EF;
	Wed,  4 Jan 2023 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849635;
	bh=aCTicPl6v7OZpBEkZoMn6pOqXaaLcziMCxw1jF72AjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZn8euVHPAjb3Nz/IKxaXkVDfA7XPb0Rx/xiezSM687uZiRdINRT3Bzy9bH9xSNxH
	 0DXX/zJfVhv2KR30dfP76uj71XLhVSeoIuCFzSeDkrT1ASEcUOIm8HvTA+Vp5tKH+r
	 inqYV/BfzCkYNsSfndVXrAuleSjO4k7WmGmaFaj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.0 168/177] drm/i915/ttm: consider CCS for backup objects
Date: Wed,  4 Jan 2023 17:07:39 +0100
Message-Id: <20230104160512.768654928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Auld <matthew.auld@intel.com>

commit ad0fca2dceeab8fdd8e1135f4b4ef2dc46c2ead9 upstream.

It seems we can have one or more framebuffers that are still pinned when
suspending lmem, in such a case we end up creating a shmem backup
object, instead of evicting the object directly, but this will skip
copying the CCS aux state, since we don't allocate the extra storage for
the CCS pages as part of the ttm_tt construction. Since we can already
deal with pinned objects just fine, it doesn't seem too nasty to just
extend to support dealing with the CCS aux state, if the object is a
pinned framebuffer. This fixes display corruption (like in gnome-shell)
seen on DG2 when returning from suspend.

Fixes: da0595ae91da ("drm/i915/migrate: Evict and restore the flatccs capable lmem obj")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: <stable@vger.kernel.org> # v5.19+
Tested-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221212171958.82593-2-matthew.auld@intel.com
(cherry picked from commit 95df9cc24bee8a09d39c62bcef4319b984814e18)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c       |    3 +++
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |   10 ++++++----
 drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c       |   18 +++++++++++++++++-
 3 files changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -726,6 +726,9 @@ bool i915_gem_object_needs_ccs_pages(str
 	if (!HAS_FLAT_CCS(to_i915(obj->base.dev)))
 		return false;
 
+	if (obj->flags & I915_BO_ALLOC_CCS_AUX)
+		return true;
+
 	for (i = 0; i < obj->mm.n_placements; i++) {
 		/* Compression is not allowed for the objects with smem placement */
 		if (obj->mm.placements[i]->type == INTEL_MEMORY_SYSTEM)
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -325,16 +325,18 @@ struct drm_i915_gem_object {
  * dealing with userspace objects the CPU fault handler is free to ignore this.
  */
 #define I915_BO_ALLOC_GPU_ONLY	  BIT(6)
+#define I915_BO_ALLOC_CCS_AUX	  BIT(7)
 #define I915_BO_ALLOC_FLAGS (I915_BO_ALLOC_CONTIGUOUS | \
 			     I915_BO_ALLOC_VOLATILE | \
 			     I915_BO_ALLOC_CPU_CLEAR | \
 			     I915_BO_ALLOC_USER | \
 			     I915_BO_ALLOC_PM_VOLATILE | \
 			     I915_BO_ALLOC_PM_EARLY | \
-			     I915_BO_ALLOC_GPU_ONLY)
-#define I915_BO_READONLY          BIT(7)
-#define I915_TILING_QUIRK_BIT     8 /* unknown swizzling; do not release! */
-#define I915_BO_PROTECTED         BIT(9)
+			     I915_BO_ALLOC_GPU_ONLY | \
+			     I915_BO_ALLOC_CCS_AUX)
+#define I915_BO_READONLY          BIT(8)
+#define I915_TILING_QUIRK_BIT     9 /* unknown swizzling; do not release! */
+#define I915_BO_PROTECTED         BIT(10)
 	/**
 	 * @mem_flags - Mutable placement-related flags
 	 *
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
@@ -50,6 +50,7 @@ static int i915_ttm_backup(struct i915_g
 		container_of(bo->bdev, typeof(*i915), bdev);
 	struct drm_i915_gem_object *backup;
 	struct ttm_operation_ctx ctx = {};
+	unsigned int flags;
 	int err = 0;
 
 	if (bo->resource->mem_type == I915_PL_SYSTEM || obj->ttm.backup)
@@ -65,7 +66,22 @@ static int i915_ttm_backup(struct i915_g
 	if (obj->flags & I915_BO_ALLOC_PM_VOLATILE)
 		return 0;
 
-	backup = i915_gem_object_create_shmem(i915, obj->base.size);
+	/*
+	 * It seems that we might have some framebuffers still pinned at this
+	 * stage, but for such objects we might also need to deal with the CCS
+	 * aux state. Make sure we force the save/restore of the CCS state,
+	 * otherwise we might observe display corruption, when returning from
+	 * suspend.
+	 */
+	flags = 0;
+	if (i915_gem_object_needs_ccs_pages(obj)) {
+		WARN_ON_ONCE(!i915_gem_object_is_framebuffer(obj));
+		WARN_ON_ONCE(!pm_apply->allow_gpu);
+
+		flags = I915_BO_ALLOC_CCS_AUX;
+	}
+	backup = i915_gem_object_create_region(i915->mm.regions[INTEL_REGION_SMEM],
+					       obj->base.size, 0, flags);
 	if (IS_ERR(backup))
 		return PTR_ERR(backup);
 


