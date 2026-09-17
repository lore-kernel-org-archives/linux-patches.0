Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB74D4EFFD9;
	Thu, 17 Sep 2026 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660138; cv=none; b=LYy295q0RKg23+/mBmwIyEsGs8Lib9ccdT6bYZJNSzws8oeOVWHep9MVHlX3h6jV6vzxlS+PFFGQqjeyyrOdhEhzTb9y2sClPj8WXbruCrHkcqeSUr9k6LkKkIX6JQHkpbxqktXaZkzGMFN6AqyCWEnAcWsNFrq/xZ8aDgjDoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660138; c=relaxed/simple;
	bh=NRvZAdJrbgzhVcRrMbvUf3WVSOTa1z0Cjqon9REA4Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ikEaJDyhAipak3onRYOnjTTFUdOyBqmV8gQj5ylASWYQkocv75jt0GB1C8WO3/gC6JuX/JwUBMMksWIqBjVvCAGHIbnsi2Q8T0QkRfAawyDKJGFSo+r0pitaH8YHItAMu5jHqbJBCfnUlQt3eS2Vokcd3TCJ92TNkYcLehvoht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8zzLKkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8zzLKkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03741F000FF;
	Thu, 17 Sep 2026 15:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660130;
	bh=r6cEDgW1wzqmoapvTe7MUz1MKTaPe/yTf3Uh+fnPtT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8zzLKkdQzSLMpUaNj8OmtEWiots1WaVthIe84IZoUwSK6XCqAj/cOC/f4kd68S/P
	 GcvgcbSVjLI/nGyfsC5Q4zffI5DODSqSqkoMz393wUSFPU+bryXyW7MOyIv2IBZ9am
	 hLRXG91m1UfKFSu03WpV88pV4P3VsGd9N/uhi698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 488/733] drm/amdgpu: skip the VMID 0 flush for VRAM
Date: Thu, 17 Sep 2026 16:13:16 +0100
Message-ID: <20260917151404.205291542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 87ceb8cba73d0b3c4025ff42495bccd8164acaed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -190,6 +190,8 @@ amdgpu_ttm_job_submit(struct amdgpu_devi
  * @tmz: if we should setup a TMZ enabled mapping
  * @size: in number of bytes to map, out number of bytes mapped
  * @addr: resulting address inside the MC address space
+ * @vm_needs_flush: out, set true if a GART window was programmed (VMID 0 flush
+ *		    needed) or false for a direct address
  *
  * Setup one of the GART windows to access a specific piece of memory or return
  * the physical address for local memory.
@@ -199,7 +201,8 @@ static int amdgpu_ttm_map_buffer(struct
 				 struct ttm_resource *mem,
 				 struct amdgpu_res_cursor *mm_cur,
 				 unsigned int window,
-				 bool tmz, uint64_t *size, uint64_t *addr)
+				 bool tmz, uint64_t *size, uint64_t *addr,
+				 bool *vm_needs_flush)
 {
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->bdev);
 	unsigned int offset, num_pages, num_dw, num_bytes;
@@ -220,9 +223,12 @@ static int amdgpu_ttm_map_buffer(struct
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
@@ -322,6 +328,7 @@ static int amdgpu_ttm_copy_mem_to_mem(st
 	while (src_mm.remaining) {
 		uint64_t from, to, cur_size, tiling_flags;
 		uint32_t num_type, data_format, max_com, write_compress_disable;
+		bool src_vm_flush, dst_vm_flush;
 		struct dma_fence *next;
 
 		/* Never copy more than 256MiB at once to avoid a timeout */
@@ -329,12 +336,12 @@ static int amdgpu_ttm_copy_mem_to_mem(st
 
 		/* Map src to window 0 and dst to window 1. */
 		r = amdgpu_ttm_map_buffer(entity, src->bo, src->mem, &src_mm,
-					  0, tmz, &cur_size, &from);
+					  0, tmz, &cur_size, &from, &src_vm_flush);
 		if (r)
 			goto error;
 
 		r = amdgpu_ttm_map_buffer(entity, dst->bo, dst->mem, &dst_mm,
-					  1, tmz, &cur_size, &to);
+					  1, tmz, &cur_size, &to, &dst_vm_flush);
 		if (r)
 			goto error;
 
@@ -362,7 +369,7 @@ static int amdgpu_ttm_copy_mem_to_mem(st
 		}
 
 		r = amdgpu_copy_buffer(adev, entity, from, to, cur_size, resv,
-				       &next, true, copy_flags);
+				       &next, src_vm_flush || dst_vm_flush, copy_flags);
 		if (r)
 			goto error;
 
@@ -2580,6 +2587,7 @@ int amdgpu_ttm_clear_buffer(struct amdgp
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 	struct dma_fence *fence = NULL;
 	struct amdgpu_res_cursor dst;
+	bool vm_needs_flush = false;
 	int r;
 
 	if (!entity)
@@ -2601,13 +2609,13 @@ int amdgpu_ttm_clear_buffer(struct amdgp
 		cur_size = min(dst.size, 256ULL << 20);
 
 		r = amdgpu_ttm_map_buffer(entity, &bo->tbo, bo->tbo.resource, &dst,
-					  0, false, &cur_size, &to);
+					  0, false, &cur_size, &to, &vm_needs_flush);
 		if (r)
 			goto error;
 
 		r = amdgpu_ttm_fill_mem(adev, entity,
 					0, to, cur_size, resv,
-					&next, true, k_job_id);
+					&next, vm_needs_flush, k_job_id);
 		if (r)
 			goto error;
 


