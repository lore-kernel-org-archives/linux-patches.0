Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B733ABD99;
	Sat, 17 Oct 2026 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255412; cv=none; b=VsKGvcrD7rfD8lZy4fJB1i3fKk60K25PoTqZhBgLmp78wDWc/W1qFE44dPKcFtzEfVB8hFW8CXlQnezXhK28qQDLsQfdgxHmN3FFNFYlfXN9E67Q6wb2RN8VfbxpqjuCBMt3XyK6xpA7hobj8hA/xy06paTp8tnCSAI3lmGkkpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255412; c=relaxed/simple;
	bh=GNjrfTMoqJMxmnkkCoxYTJgt1LtjjNOsPOxUnV0PsiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1VmSAL/6rs2HQ8nsCurnmBKEjKYEAn7mztGd1jB/l8PIEgzFd2PIQFcn5/R5SSNc4k8wUasY617SauiBI4X+htkQVTCicOHGMUfZl9HYLkX1/v2m6xsnZNT3LWdt6+MAUm38w+VMU85kv+9ECg0bh/hM4vwGoI/tBfyu+rPC0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5AeM2AJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5AeM2AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD9A1F000C4;
	Sat, 17 Oct 2026 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255410;
	bh=R3VNRsdoDxYBH9qKeg33vT7qVIEuynVuW/T6tfbFGlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5AeM2AJX85CIzZD5uJ66glBW+ya1u5+OCH0VJCLJwHshQtzLrJtadnLcPXBqs4ce
	 YMwxcRLLOyHyoQbHNMbTnT7HdJUkwo6GK4P5AO8qaFVzYqof70zqHZ468IlMa0058r
	 8CRVNuZ+/lByC/rzoK1AJhKntEmRGEi5iYI2P14c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 767/869] drm/amdgpu: skip the VMID 0 flush for VRAM
Date: Sat, 17 Oct 2026 18:00:08 +0200
Message-ID: <20261017160056.587692362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 87ceb8cba73d0b3c4025ff42495bccd8164acaed ]

Clear-on-release only runs on VRAM, which amdgpu_ttm_map_buffer() reaches
via its direct MC address without programming a GART window, yet the wipe
still forces a VMID 0 flush. On GFX11 (e.g. Navi33) that spurious SDMA
flush can wedge the engine; only flush when a GART window is actually used.

v2: Let amdgpu_ttm_map_buffer() return whether the VMID 0 flush is needed,
    and drive the clear and copy paths from that. (Christian)
v3: Make the vm_needs_flush output parameter mandatory instead of
    allowing NULL. (Christian)

Fixes: a68c7eaa7a8f ("drm/amdgpu: Enable clear page functionality")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5413
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a306e406e570b74318ff7d80e5b07b540ca1d3a9)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 60c5e8803f60c..93da39a5ce492 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -174,6 +174,8 @@ static void amdgpu_evict_flags(struct ttm_buffer_object *bo,
  * @tmz: if we should setup a TMZ enabled mapping
  * @size: in number of bytes to map, out number of bytes mapped
  * @addr: resulting address inside the MC address space
+ * @vm_needs_flush: out, set true if a GART window was programmed (VMID 0 flush
+ *		    needed) or false for a direct address
  *
  * Setup one of the GART windows to access a specific piece of memory or return
  * the physical address for local memory.
@@ -182,7 +184,8 @@ static int amdgpu_ttm_map_buffer(struct ttm_buffer_object *bo,
 				 struct ttm_resource *mem,
 				 struct amdgpu_res_cursor *mm_cur,
 				 unsigned int window, struct amdgpu_ring *ring,
-				 bool tmz, uint64_t *size, uint64_t *addr)
+				 bool tmz, uint64_t *size, uint64_t *addr,
+				 bool *vm_needs_flush)
 {
 	struct amdgpu_device *adev = ring->adev;
 	unsigned int offset, num_pages, num_dw, num_bytes;
@@ -203,9 +206,12 @@ static int amdgpu_ttm_map_buffer(struct ttm_buffer_object *bo,
 	if (!tmz && mem->start != AMDGPU_BO_INVALID_OFFSET) {
 		*addr = amdgpu_ttm_domain_start(adev, mem->mem_type) +
 			mm_cur->start;
+		*vm_needs_flush = false;
 		return 0;
 	}
 
+	/* A GART window is programmed below, so its VMID 0 TLB needs a flush */
+	*vm_needs_flush = true;
 
 	/*
 	 * If start begins at an offset inside the page, then adjust the size
@@ -314,6 +320,7 @@ int amdgpu_ttm_copy_mem_to_mem(struct amdgpu_device *adev,
 	while (src_mm.remaining) {
 		uint64_t from, to, cur_size, tiling_flags;
 		uint32_t num_type, data_format, max_com, write_compress_disable;
+		bool src_vm_flush, dst_vm_flush;
 		struct dma_fence *next;
 
 		/* Never copy more than 256MiB at once to avoid a timeout */
@@ -321,12 +328,12 @@ int amdgpu_ttm_copy_mem_to_mem(struct amdgpu_device *adev,
 
 		/* Map src to window 0 and dst to window 1. */
 		r = amdgpu_ttm_map_buffer(src->bo, src->mem, &src_mm,
-					  0, ring, tmz, &cur_size, &from);
+					  0, ring, tmz, &cur_size, &from, &src_vm_flush);
 		if (r)
 			goto error;
 
 		r = amdgpu_ttm_map_buffer(dst->bo, dst->mem, &dst_mm,
-					  1, ring, tmz, &cur_size, &to);
+					  1, ring, tmz, &cur_size, &to, &dst_vm_flush);
 		if (r)
 			goto error;
 
@@ -354,7 +361,7 @@ int amdgpu_ttm_copy_mem_to_mem(struct amdgpu_device *adev,
 		}
 
 		r = amdgpu_copy_buffer(ring, from, to, cur_size, resv,
-				       &next, false, true, copy_flags);
+				       &next, false, src_vm_flush || dst_vm_flush, copy_flags);
 		if (r)
 			goto error;
 
@@ -2311,6 +2318,7 @@ int amdgpu_ttm_clear_buffer(struct amdgpu_bo *bo,
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 	struct amdgpu_ring *ring = adev->mman.buffer_funcs_ring;
 	struct amdgpu_res_cursor cursor;
+	bool vm_needs_flush = false;
 	u64 addr;
 	int r = 0;
 
@@ -2338,12 +2346,12 @@ int amdgpu_ttm_clear_buffer(struct amdgpu_bo *bo,
 		size = min(cursor.size, 256ULL << 20);
 
 		r = amdgpu_ttm_map_buffer(&bo->tbo, bo->tbo.resource, &cursor,
-					  1, ring, false, &size, &addr);
+					  1, ring, false, &size, &addr, &vm_needs_flush);
 		if (r)
 			goto err;
 
 		r = amdgpu_ttm_fill_mem(ring, 0, addr, size, resv,
-					&next, true, true,
+					&next, vm_needs_flush, true,
 					AMDGPU_KERNEL_JOB_ID_TTM_CLEAR_BUFFER);
 		if (r)
 			goto err;
@@ -2370,6 +2378,7 @@ int amdgpu_fill_buffer(struct amdgpu_bo *bo,
 	struct amdgpu_ring *ring = adev->mman.buffer_funcs_ring;
 	struct dma_fence *fence = NULL;
 	struct amdgpu_res_cursor dst;
+	bool vm_needs_flush = false;
 	int r;
 
 	if (!adev->mman.buffer_funcs_enabled) {
@@ -2388,12 +2397,12 @@ int amdgpu_fill_buffer(struct amdgpu_bo *bo,
 		cur_size = min(dst.size, 256ULL << 20);
 
 		r = amdgpu_ttm_map_buffer(&bo->tbo, bo->tbo.resource, &dst,
-					  1, ring, false, &cur_size, &to);
+					  1, ring, false, &cur_size, &to, &vm_needs_flush);
 		if (r)
 			goto error;
 
 		r = amdgpu_ttm_fill_mem(ring, src_data, to, cur_size, resv,
-					&next, true, delayed, k_job_id);
+					&next, vm_needs_flush, delayed, k_job_id);
 		if (r)
 			goto error;
 
-- 
2.53.0



