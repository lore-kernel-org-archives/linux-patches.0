Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49442D12ED;
	Fri,  7 Aug 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115754; cv=none; b=c+oHnIweA0nujxaXFbu2cH8DzYVr6IMKPYaTzI6P44U0W16E/JktBnGVGOFKSsPyoDzX7IOBvHa+w+K5bSf4zYChDoAi+QwVGZ3AhKClMxSX+gaIWQhc8pPaMmnaTv98Em5JPrzdvx/7sp63m39XiCYeVeCUKNEu+AAoizkzycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115754; c=relaxed/simple;
	bh=jILM6mHOJ9uy/MsCzfS5HF+o+IocdgerHLdjkkk4MH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWHESqyelmFvr8fUEW8p2mwmRu+riY2Buhm3Ns+oCOMuo2yHKsGgqJ9pVlF08sdoWY1AUaKe+dT4YkFw2dGb8z1AtxOve9zRYFJQmahqYzVRYhy8XpEYPcCAaGh4HiYnAFvTRZOAz/E+jc5EJja/L8fh1HBCWWqqnEkE3LiZRkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X++p1qXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X++p1qXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF6A1F00A3D;
	Fri,  7 Aug 2026 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115752;
	bh=dFYGJ+32sIjugQZOYAkSjV0l6pJfybHB4LYwzrnYXwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X++p1qXA7qpUdLKF1MJ4CiGR2hwK84D8NEiTukl9YetUlvUm9A2fyn9PY5Sn/oDh+
	 uh+X8Catm1okRltwEax9i884DTLqEIsM1bURWNkvSV75ZEq0qYCtR4wjs2sy9HOv3a
	 86xt6PFm/imGQMn1lKlUgTo7q6AKupjtgmBEBkNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/396] drm/xe: add xe_migrate_resolve wrapper and is_vram_resolve support
Date: Fri,  7 Aug 2026 16:39:00 +0200
Message-ID: <20260807143432.476362963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit be97fd06458d66a53aefb6d9429db0df734c81c0 ]

Introduce an internal __xe_migrate_copy(..., is_vram_resolve) path and
expose a small wrapper xe_migrate_resolve() that calls it with
is_vram_resolve=true.

For resolve/decompression operations we must ensure the copy code uses
the compression PAT index when appropriate; this change centralizes that
behavior and allows callers to schedule a resolve (decompress) operation
via the migrate API.

v3: Fix kernel-doc warnings

v2: (Matt)
  - Simplify xe_migrate_resolve(), use single BO/resource;
    remove copy_only_ccs argument as it's always false.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260304123758.3050386-7-nitin.r.gote@intel.com
Stable-dep-of: 7bc597ce74ba ("drm/xe/vm: Fix BO prefetch with CONSULT_MEM_ADVISE_PREF_LOC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c |   90 ++++++++++++++++++++++++++++------------
 drivers/gpu/drm/xe/xe_migrate.h |    4 +
 2 files changed, 67 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -765,31 +765,13 @@ static u32 xe_migrate_ccs_copy(struct xe
 	return flush_flags;
 }
 
-/**
- * xe_migrate_copy() - Copy content of TTM resources.
- * @m: The migration context.
- * @src_bo: The buffer object @src is currently bound to.
- * @dst_bo: If copying between resources created for the same bo, set this to
- * the same value as @src_bo. If copying between buffer objects, set it to
- * the buffer object @dst is currently bound to.
- * @src: The source TTM resource.
- * @dst: The dst TTM resource.
- * @copy_only_ccs: If true copy only CCS metadata
- *
- * Copies the contents of @src to @dst: On flat CCS devices,
- * the CCS metadata is copied as well if needed, or if not present,
- * the CCS metadata of @dst is cleared for security reasons.
- *
- * Return: Pointer to a dma_fence representing the last copy batch, or
- * an error pointer on failure. If there is a failure, any copy operation
- * started by the function call has been synced.
- */
-struct dma_fence *xe_migrate_copy(struct xe_migrate *m,
-				  struct xe_bo *src_bo,
-				  struct xe_bo *dst_bo,
-				  struct ttm_resource *src,
-				  struct ttm_resource *dst,
-				  bool copy_only_ccs)
+static struct dma_fence *__xe_migrate_copy(struct xe_migrate *m,
+					   struct xe_bo *src_bo,
+					   struct xe_bo *dst_bo,
+					   struct ttm_resource *src,
+					   struct ttm_resource *dst,
+					   bool copy_only_ccs,
+					   bool is_vram_resolve)
 {
 	struct xe_gt *gt = m->tile->primary_gt;
 	struct xe_device *xe = gt_to_xe(gt);
@@ -810,8 +792,15 @@ struct dma_fence *xe_migrate_copy(struct
 	bool copy_ccs = xe_device_has_flat_ccs(xe) &&
 		xe_bo_needs_ccs_pages(src_bo) && xe_bo_needs_ccs_pages(dst_bo);
 	bool copy_system_ccs = copy_ccs && (!src_is_vram || !dst_is_vram);
-	bool use_comp_pat = type_device && xe_device_has_flat_ccs(xe) &&
-		GRAPHICS_VER(xe) >= 20 && src_is_vram && !dst_is_vram;
+
+	/*
+	 * For decompression operation, always use the compression PAT index.
+	 * Otherwise, only use the compression PAT index for device memory
+	 * when copying from VRAM to system memory.
+	 */
+	bool use_comp_pat = is_vram_resolve || (type_device &&
+			    xe_device_has_flat_ccs(xe) &&
+			    GRAPHICS_VER(xe) >= 20 && src_is_vram && !dst_is_vram);
 
 	/* Copying CCS between two different BOs is not supported yet. */
 	if (XE_WARN_ON(copy_ccs && src_bo != dst_bo))
@@ -971,6 +960,53 @@ err_sync:
 }
 
 /**
+ * xe_migrate_copy() - Copy content of TTM resources.
+ * @m: The migration context.
+ * @src_bo: The buffer object @src is currently bound to.
+ * @dst_bo: If copying between resources created for the same bo, set this to
+ * the same value as @src_bo. If copying between buffer objects, set it to
+ * the buffer object @dst is currently bound to.
+ * @src: The source TTM resource.
+ * @dst: The dst TTM resource.
+ * @copy_only_ccs: If true copy only CCS metadata
+ *
+ * Copies the contents of @src to @dst: On flat CCS devices,
+ * the CCS metadata is copied as well if needed, or if not present,
+ * the CCS metadata of @dst is cleared for security reasons.
+ *
+ * Return: Pointer to a dma_fence representing the last copy batch, or
+ * an error pointer on failure. If there is a failure, any copy operation
+ * started by the function call has been synced.
+ */
+struct dma_fence *xe_migrate_copy(struct xe_migrate *m,
+				  struct xe_bo *src_bo,
+				  struct xe_bo *dst_bo,
+				  struct ttm_resource *src,
+				  struct ttm_resource *dst,
+				  bool copy_only_ccs)
+{
+	return __xe_migrate_copy(m, src_bo, dst_bo, src, dst, copy_only_ccs, false);
+}
+
+/**
+ * xe_migrate_resolve() - Resolve and decompress a buffer object if required.
+ * @m: The migrate context
+ * @bo: The buffer object to resolve
+ * @res: The reservation object
+ *
+ * Wrapper around __xe_migrate_copy() with is_vram_resolve set to true
+ * to trigger decompression if needed.
+ *
+ * Return: A dma_fence that signals on completion, or an ERR_PTR on failure.
+ */
+struct dma_fence *xe_migrate_resolve(struct xe_migrate *m,
+				     struct xe_bo *bo,
+				     struct ttm_resource *res)
+{
+	return __xe_migrate_copy(m, bo, bo, res, res, false, true);
+}
+
+/**
  * xe_migrate_lrc() - Get the LRC from migrate context.
  * @migrate: Migrate context.
  *
--- a/drivers/gpu/drm/xe/xe_migrate.h
+++ b/drivers/gpu/drm/xe/xe_migrate.h
@@ -127,6 +127,10 @@ struct dma_fence *xe_migrate_copy(struct
 				  struct ttm_resource *dst,
 				  bool copy_only_ccs);
 
+struct dma_fence *xe_migrate_resolve(struct xe_migrate *m,
+				     struct xe_bo *bo,
+				     struct ttm_resource *res);
+
 int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 			   struct xe_bo *src_bo,
 			   struct ttm_resource *new_mem,


