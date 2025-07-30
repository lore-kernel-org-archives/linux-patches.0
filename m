Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A132C20E6;
	Wed, 30 Jul 2025 09:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868646; cv=none; b=mloPa67bjKUFBEGhRylQU9mTRZ4pWl4EZWN97oyKlfNzglwhhCmTC6CCHWOtmKq95CHJhhs4JquwK+HO/81LvT7Z06FDERL1QryyDiWAAhpI/IxSpv1fKx6qKG9tilVQSag8lFa2IYeRwYVaLaoY/tIjgja+xZ7ZCbeNr1m/8es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868646; c=relaxed/simple;
	bh=jVrS//YrL49cA3jq/hYiicEMTgVmCLFKZSIjNX9QUAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LF65lc5/vSK0Ly31pIWW/7R5d3+wcUv/M6BLUsP2A/CxfusBDY4HjrQLd2xAzx9ARDpYImpxFn5AgI7pIH9QCkoRfrVUv/P9C/VQVbG8ka327MypUaAf28xvcvjV2Q3N8S1hiZIDtBE+aLvxVn6xcKnTF64Cw61wRTGMVoihRpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqhuRl01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqhuRl01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C63C4CEE7;
	Wed, 30 Jul 2025 09:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868646;
	bh=jVrS//YrL49cA3jq/hYiicEMTgVmCLFKZSIjNX9QUAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqhuRl013am4rUZ+Io8FtAM6Ij1VZM8FcxmdzJrmq/cizhNYgJmvZWpWUU4sJlbn1
	 Qc1yClbAC8YoaeI/KbiCQwxZ16uMlG4s5PszOYxyaQ7ixP5z9ILBgk4HBkZUUyc+hO
	 LSFKt62bTUbOJ4gNIubUnpPeTHzyWYphcbD1mxt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Auld <matthew.auld@intel.com>
Subject: [PATCH 6.12 041/117] drm/amdgpu: Reset the clear flag in buddy during resume
Date: Wed, 30 Jul 2025 11:35:10 +0200
Message-ID: <20250730093235.161097871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 95a16160ca1d75c66bf7a1c5e0bcaffb18e7c7fc upstream.

- Added a handler in DRM buddy manager to reset the cleared
  flag for the blocks in the freelist.

- This is necessary because, upon resuming, the VRAM becomes
  cluttered with BIOS data, yet the VRAM backend manager
  believes that everything has been cleared.

v2:
  - Add lock before accessing drm_buddy_clear_reset_blocks()(Matthew Auld)
  - Force merge the two dirty blocks.(Matthew Auld)
  - Add a new unit test case for this issue.(Matthew Auld)
  - Having this function being able to flip the state either way would be
    good. (Matthew Brost)

v3(Matthew Auld):
  - Do merge step first to avoid the use of extra reset flag.

Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: stable@vger.kernel.org
Fixes: a68c7eaa7a8f ("drm/amdgpu: Enable clear page functionality")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3812
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250716075125.240637-2-Arunpravin.PaneerSelvam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c   |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h      |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |   17 ++++++++++
 drivers/gpu/drm/drm_buddy.c                  |   43 +++++++++++++++++++++++++++
 include/drm/drm_buddy.h                      |    2 +
 5 files changed, 65 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4954,6 +4954,8 @@ exit:
 		dev->dev->power.disable_depth--;
 #endif
 	}
+
+	amdgpu_vram_mgr_clear_reset_blocks(adev);
 	adev->in_suspend = false;
 
 	if (adev->enable_mes)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -153,6 +153,7 @@ int amdgpu_vram_mgr_reserve_range(struct
 				  uint64_t start, uint64_t size);
 int amdgpu_vram_mgr_query_page_status(struct amdgpu_vram_mgr *mgr,
 				      uint64_t start);
+void amdgpu_vram_mgr_clear_reset_blocks(struct amdgpu_device *adev);
 
 bool amdgpu_res_cpu_visible(struct amdgpu_device *adev,
 			    struct ttm_resource *res);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -783,6 +783,23 @@ uint64_t amdgpu_vram_mgr_vis_usage(struc
 }
 
 /**
+ * amdgpu_vram_mgr_clear_reset_blocks - reset clear blocks
+ *
+ * @adev: amdgpu device pointer
+ *
+ * Reset the cleared drm buddy blocks.
+ */
+void amdgpu_vram_mgr_clear_reset_blocks(struct amdgpu_device *adev)
+{
+	struct amdgpu_vram_mgr *mgr = &adev->mman.vram_mgr;
+	struct drm_buddy *mm = &mgr->mm;
+
+	mutex_lock(&mgr->lock);
+	drm_buddy_reset_clear(mm, false);
+	mutex_unlock(&mgr->lock);
+}
+
+/**
  * amdgpu_vram_mgr_intersects - test each drm buddy block for intersection
  *
  * @man: TTM memory type manager
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -401,6 +401,49 @@ drm_get_buddy(struct drm_buddy_block *bl
 EXPORT_SYMBOL(drm_get_buddy);
 
 /**
+ * drm_buddy_reset_clear - reset blocks clear state
+ *
+ * @mm: DRM buddy manager
+ * @is_clear: blocks clear state
+ *
+ * Reset the clear state based on @is_clear value for each block
+ * in the freelist.
+ */
+void drm_buddy_reset_clear(struct drm_buddy *mm, bool is_clear)
+{
+	u64 root_size, size, start;
+	unsigned int order;
+	int i;
+
+	size = mm->size;
+	for (i = 0; i < mm->n_roots; ++i) {
+		order = ilog2(size) - ilog2(mm->chunk_size);
+		start = drm_buddy_block_offset(mm->roots[i]);
+		__force_merge(mm, start, start + size, order);
+
+		root_size = mm->chunk_size << order;
+		size -= root_size;
+	}
+
+	for (i = 0; i <= mm->max_order; ++i) {
+		struct drm_buddy_block *block;
+
+		list_for_each_entry_reverse(block, &mm->free_list[i], link) {
+			if (is_clear != drm_buddy_block_is_clear(block)) {
+				if (is_clear) {
+					mark_cleared(block);
+					mm->clear_avail += drm_buddy_block_size(mm, block);
+				} else {
+					clear_reset(block);
+					mm->clear_avail -= drm_buddy_block_size(mm, block);
+				}
+			}
+		}
+	}
+}
+EXPORT_SYMBOL(drm_buddy_reset_clear);
+
+/**
  * drm_buddy_free_block - free a block
  *
  * @mm: DRM buddy manager
--- a/include/drm/drm_buddy.h
+++ b/include/drm/drm_buddy.h
@@ -160,6 +160,8 @@ int drm_buddy_block_trim(struct drm_budd
 			 u64 new_size,
 			 struct list_head *blocks);
 
+void drm_buddy_reset_clear(struct drm_buddy *mm, bool is_clear);
+
 void drm_buddy_free_block(struct drm_buddy *mm, struct drm_buddy_block *block);
 
 void drm_buddy_free_list(struct drm_buddy *mm,


