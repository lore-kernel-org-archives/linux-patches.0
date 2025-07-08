Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F452E54A0;
	Tue,  8 Jul 2025 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993007; cv=none; b=QHcB7rOKAWIo7JXeI0Z+FGnBTyL2htMbD27/0JUfnFNsr60BJ+LcbEqu4ITzvfXUaE9jQDhacxAPF1mOuvHm0bN0G9IrIpsYun4sraFC8SdBhmPIcobRhGGZO6sUWDDaP1fEXadS4u7vQgoRL33ciAgiaZjHJ00anU78FyNE3NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993007; c=relaxed/simple;
	bh=pSQ/lxZe+S9FXdfSXLHMXMU2wxAHG8c6FX+MnzZMj9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2stn8EXIbAE8yLlvUEXpsptEd07QB+wkNiGE//k5HhwL7EOzCTKgz5wg/nFnM4c0ynAP2N6b3a3BL0PFuaiLwWHvGmT6fccz3gC4PmlxElQyC+mT7IXxu8+nXltMLK8Jn+zVclewCZsn8/kpCVzYze6DjNmTpDanP6OW1mtOVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeeUf3rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeeUf3rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C9FC4CEF6;
	Tue,  8 Jul 2025 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993007;
	bh=pSQ/lxZe+S9FXdfSXLHMXMU2wxAHG8c6FX+MnzZMj9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeeUf3rnuLsR2nWc29o6Yc9Ri/blo42FB/O2Xj+2oxb+uKfFRYnJqE3Z/c6cC6TxQ
	 jHNZsId3B8i/nZuCkkgl0FpqFQ55k/Ykk2LsPMe3ogVhcyjOaEgf4IGK3Wwz+n9qJ3
	 czd/cn8EQkJwN5qM972ueGtxdnp4RsorUJkVVhvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/232] drm/xe: add interface to request physical alignment for buffer objects
Date: Tue,  8 Jul 2025 18:22:31 +0200
Message-ID: <20250708162245.493543139@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

[ Upstream commit 3ad86ae1da97d0091f673f08846848714f6dd745 ]

Add xe_bo_create_pin_map_at_aligned() which augment
xe_bo_create_pin_map_at() with alignment parameter allowing to pass
required alignemnt if it differ from default.

Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241009151947.2240099-2-juhapekka.heikkila@gmail.com
Stable-dep-of: f16873f42a06 ("drm/xe: move DPT l2 flush to a more sensible place")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../compat-i915-headers/gem/i915_gem_stolen.h |  2 +-
 drivers/gpu/drm/xe/xe_bo.c                    | 29 +++++++++++++++----
 drivers/gpu/drm/xe/xe_bo.h                    |  8 ++++-
 drivers/gpu/drm/xe/xe_bo_types.h              |  5 ++++
 drivers/gpu/drm/xe/xe_ggtt.c                  |  2 +-
 5 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/xe/compat-i915-headers/gem/i915_gem_stolen.h b/drivers/gpu/drm/xe/compat-i915-headers/gem/i915_gem_stolen.h
index cb6c7598824be..9c4cf050059ac 100644
--- a/drivers/gpu/drm/xe/compat-i915-headers/gem/i915_gem_stolen.h
+++ b/drivers/gpu/drm/xe/compat-i915-headers/gem/i915_gem_stolen.h
@@ -29,7 +29,7 @@ static inline int i915_gem_stolen_insert_node_in_range(struct xe_device *xe,
 
 	bo = xe_bo_create_locked_range(xe, xe_device_get_root_tile(xe),
 				       NULL, size, start, end,
-				       ttm_bo_type_kernel, flags);
+				       ttm_bo_type_kernel, flags, 0);
 	if (IS_ERR(bo)) {
 		err = PTR_ERR(bo);
 		bo = NULL;
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 8acc4640f0a28..c92953c08d682 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1454,7 +1454,8 @@ static struct xe_bo *
 __xe_bo_create_locked(struct xe_device *xe,
 		      struct xe_tile *tile, struct xe_vm *vm,
 		      size_t size, u64 start, u64 end,
-		      u16 cpu_caching, enum ttm_bo_type type, u32 flags)
+		      u16 cpu_caching, enum ttm_bo_type type, u32 flags,
+		      u64 alignment)
 {
 	struct xe_bo *bo = NULL;
 	int err;
@@ -1483,6 +1484,8 @@ __xe_bo_create_locked(struct xe_device *xe,
 	if (IS_ERR(bo))
 		return bo;
 
+	bo->min_align = alignment;
+
 	/*
 	 * Note that instead of taking a reference no the drm_gpuvm_resv_bo(),
 	 * to ensure the shared resv doesn't disappear under the bo, the bo
@@ -1523,16 +1526,18 @@ struct xe_bo *
 xe_bo_create_locked_range(struct xe_device *xe,
 			  struct xe_tile *tile, struct xe_vm *vm,
 			  size_t size, u64 start, u64 end,
-			  enum ttm_bo_type type, u32 flags)
+			  enum ttm_bo_type type, u32 flags, u64 alignment)
 {
-	return __xe_bo_create_locked(xe, tile, vm, size, start, end, 0, type, flags);
+	return __xe_bo_create_locked(xe, tile, vm, size, start, end, 0, type,
+				     flags, alignment);
 }
 
 struct xe_bo *xe_bo_create_locked(struct xe_device *xe, struct xe_tile *tile,
 				  struct xe_vm *vm, size_t size,
 				  enum ttm_bo_type type, u32 flags)
 {
-	return __xe_bo_create_locked(xe, tile, vm, size, 0, ~0ULL, 0, type, flags);
+	return __xe_bo_create_locked(xe, tile, vm, size, 0, ~0ULL, 0, type,
+				     flags, 0);
 }
 
 struct xe_bo *xe_bo_create_user(struct xe_device *xe, struct xe_tile *tile,
@@ -1542,7 +1547,7 @@ struct xe_bo *xe_bo_create_user(struct xe_device *xe, struct xe_tile *tile,
 {
 	struct xe_bo *bo = __xe_bo_create_locked(xe, tile, vm, size, 0, ~0ULL,
 						 cpu_caching, ttm_bo_type_device,
-						 flags | XE_BO_FLAG_USER);
+						 flags | XE_BO_FLAG_USER, 0);
 	if (!IS_ERR(bo))
 		xe_bo_unlock_vm_held(bo);
 
@@ -1565,6 +1570,17 @@ struct xe_bo *xe_bo_create_pin_map_at(struct xe_device *xe, struct xe_tile *tile
 				      struct xe_vm *vm,
 				      size_t size, u64 offset,
 				      enum ttm_bo_type type, u32 flags)
+{
+	return xe_bo_create_pin_map_at_aligned(xe, tile, vm, size, offset,
+					       type, flags, 0);
+}
+
+struct xe_bo *xe_bo_create_pin_map_at_aligned(struct xe_device *xe,
+					      struct xe_tile *tile,
+					      struct xe_vm *vm,
+					      size_t size, u64 offset,
+					      enum ttm_bo_type type, u32 flags,
+					      u64 alignment)
 {
 	struct xe_bo *bo;
 	int err;
@@ -1576,7 +1592,8 @@ struct xe_bo *xe_bo_create_pin_map_at(struct xe_device *xe, struct xe_tile *tile
 		flags |= XE_BO_FLAG_GGTT;
 
 	bo = xe_bo_create_locked_range(xe, tile, vm, size, start, end, type,
-				       flags | XE_BO_FLAG_NEEDS_CPU_ACCESS);
+				       flags | XE_BO_FLAG_NEEDS_CPU_ACCESS,
+				       alignment);
 	if (IS_ERR(bo))
 		return bo;
 
diff --git a/drivers/gpu/drm/xe/xe_bo.h b/drivers/gpu/drm/xe/xe_bo.h
index d22269a230aa1..704f5068d0d0a 100644
--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -77,7 +77,7 @@ struct xe_bo *
 xe_bo_create_locked_range(struct xe_device *xe,
 			  struct xe_tile *tile, struct xe_vm *vm,
 			  size_t size, u64 start, u64 end,
-			  enum ttm_bo_type type, u32 flags);
+			  enum ttm_bo_type type, u32 flags, u64 alignment);
 struct xe_bo *xe_bo_create_locked(struct xe_device *xe, struct xe_tile *tile,
 				  struct xe_vm *vm, size_t size,
 				  enum ttm_bo_type type, u32 flags);
@@ -94,6 +94,12 @@ struct xe_bo *xe_bo_create_pin_map(struct xe_device *xe, struct xe_tile *tile,
 struct xe_bo *xe_bo_create_pin_map_at(struct xe_device *xe, struct xe_tile *tile,
 				      struct xe_vm *vm, size_t size, u64 offset,
 				      enum ttm_bo_type type, u32 flags);
+struct xe_bo *xe_bo_create_pin_map_at_aligned(struct xe_device *xe,
+					      struct xe_tile *tile,
+					      struct xe_vm *vm,
+					      size_t size, u64 offset,
+					      enum ttm_bo_type type, u32 flags,
+					      u64 alignment);
 struct xe_bo *xe_bo_create_from_data(struct xe_device *xe, struct xe_tile *tile,
 				     const void *data, size_t size,
 				     enum ttm_bo_type type, u32 flags);
diff --git a/drivers/gpu/drm/xe/xe_bo_types.h b/drivers/gpu/drm/xe/xe_bo_types.h
index 2ed558ac2264a..35372c46edfa5 100644
--- a/drivers/gpu/drm/xe/xe_bo_types.h
+++ b/drivers/gpu/drm/xe/xe_bo_types.h
@@ -76,6 +76,11 @@ struct xe_bo {
 
 	/** @vram_userfault_link: Link into @mem_access.vram_userfault.list */
 		struct list_head vram_userfault_link;
+
+	/** @min_align: minimum alignment needed for this BO if different
+	 * from default
+	 */
+	u64 min_align;
 };
 
 #define intel_bo_to_drm_bo(bo) (&(bo)->ttm.base)
diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index e9820126feb96..9cb5760006a1c 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -620,7 +620,7 @@ static int __xe_ggtt_insert_bo_at(struct xe_ggtt *ggtt, struct xe_bo *bo,
 				  u64 start, u64 end)
 {
 	int err;
-	u64 alignment = XE_PAGE_SIZE;
+	u64 alignment = bo->min_align > 0 ? bo->min_align : XE_PAGE_SIZE;
 
 	if (xe_bo_is_vram(bo) && ggtt->flags & XE_GGTT_FLAGS_64K)
 		alignment = SZ_64K;
-- 
2.39.5



