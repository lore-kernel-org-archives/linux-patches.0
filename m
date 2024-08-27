Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E225B44C8C;
	Tue, 27 Aug 2024 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770027; cv=none; b=VXsb+q8vvs9xuSy0RjYek5RChkmCsZca6XWrqfBFw1P6YwmAFP9YCqcAiLgoNPzjvyThNyV+UulbnjCcKDh1YdRuydcwdRJRKpDxXdlklugp/91gXSuVsw3Bavs2XjGGU+RRd7pPtKUeRvTq+58o04VePsQMYWlnRy2Jnx6hXPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770027; c=relaxed/simple;
	bh=IE1fy+OECrWa+Kj8U2UdsSqd5vmycfDxDoC9JRw4TqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wkt1AglbvKiDkqJm4X3+Z5wF8Xz7mO5CqFVsoZHUe4ZtU/92+Mh+qBY/dYP8jS0vl2unSWdaxFnzNo213Lz2If+JW29qp3NyMMlfVctqbYAUgTApPQrqi5WPYemR+SXQCwEGhcTOOe7tDE03h9er/h22hkarQzStUniO99cmLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/lKSI2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/lKSI2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BD8C6106D;
	Tue, 27 Aug 2024 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770026;
	bh=IE1fy+OECrWa+Kj8U2UdsSqd5vmycfDxDoC9JRw4TqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/lKSI2ANPBfqeJ6iHCnjE+06CqqlTzi9yOekoHgahaDC4Giv4Q03dkle/9wfzoR0
	 MqAFTf9v1c9y3xqcEm0wjCEyej65uTlUKE5FLLIND1lL5kzpOkWSz0A7/gesRJv8bK
	 5PXL1Y+jmF69k+WDaamtTKSM14y/gL0+Rk1oaPys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/341] drm/amdkfd: Move dma unmapping after TLB flush
Date: Tue, 27 Aug 2024 16:35:36 +0200
Message-ID: <20240827143847.405052919@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 101b8104307eac734f2dfa4d3511430b0b631c73 ]

Otherwise GPU may access the stale mapping and generate IOMMU
IO_PAGE_FAULT.

Move this to inside p->mutex to prevent multiple threads mapping and
unmapping concurrently race condition.

After kfd_mem_dmaunmap_attachment is removed from unmap_bo_from_gpuvm,
kfd_mem_dmaunmap_attachment is called if failed to map to GPUs, and
before free the mem attachment in case failed to unmap from GPUs.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  1 +
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 26 ++++++++++++++++---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 20 ++++++++------
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 2fe9860725bd9..5e4fb33b97351 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -303,6 +303,7 @@ int amdgpu_amdkfd_gpuvm_map_memory_to_gpu(struct amdgpu_device *adev,
 					  struct kgd_mem *mem, void *drm_priv);
 int amdgpu_amdkfd_gpuvm_unmap_memory_from_gpu(
 		struct amdgpu_device *adev, struct kgd_mem *mem, void *drm_priv);
+void amdgpu_amdkfd_gpuvm_dmaunmap_mem(struct kgd_mem *mem, void *drm_priv);
 int amdgpu_amdkfd_gpuvm_sync_memory(
 		struct amdgpu_device *adev, struct kgd_mem *mem, bool intr);
 int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 62c1dc9510a41..c2d1d57a6c668 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -733,7 +733,7 @@ kfd_mem_dmaunmap_sg_bo(struct kgd_mem *mem,
 	enum dma_data_direction dir;
 
 	if (unlikely(!ttm->sg)) {
-		pr_err("SG Table of BO is UNEXPECTEDLY NULL");
+		pr_debug("SG Table of BO is NULL");
 		return;
 	}
 
@@ -1202,8 +1202,6 @@ static void unmap_bo_from_gpuvm(struct kgd_mem *mem,
 	amdgpu_vm_clear_freed(adev, vm, &bo_va->last_pt_update);
 
 	amdgpu_sync_fence(sync, bo_va->last_pt_update);
-
-	kfd_mem_dmaunmap_attachment(mem, entry);
 }
 
 static int update_gpuvm_pte(struct kgd_mem *mem,
@@ -1258,6 +1256,7 @@ static int map_bo_to_gpuvm(struct kgd_mem *mem,
 
 update_gpuvm_pte_failed:
 	unmap_bo_from_gpuvm(mem, entry, sync);
+	kfd_mem_dmaunmap_attachment(mem, entry);
 	return ret;
 }
 
@@ -1862,8 +1861,10 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 		mem->va + bo_size * (1 + mem->aql_queue));
 
 	/* Remove from VM internal data structures */
-	list_for_each_entry_safe(entry, tmp, &mem->attachments, list)
+	list_for_each_entry_safe(entry, tmp, &mem->attachments, list) {
+		kfd_mem_dmaunmap_attachment(mem, entry);
 		kfd_mem_detach(entry);
+	}
 
 	ret = unreserve_bo_and_vms(&ctx, false, false);
 
@@ -2037,6 +2038,23 @@ int amdgpu_amdkfd_gpuvm_map_memory_to_gpu(
 	return ret;
 }
 
+void amdgpu_amdkfd_gpuvm_dmaunmap_mem(struct kgd_mem *mem, void *drm_priv)
+{
+	struct kfd_mem_attachment *entry;
+	struct amdgpu_vm *vm;
+
+	vm = drm_priv_to_vm(drm_priv);
+
+	mutex_lock(&mem->lock);
+
+	list_for_each_entry(entry, &mem->attachments, list) {
+		if (entry->bo_va->base.vm == vm)
+			kfd_mem_dmaunmap_attachment(mem, entry);
+	}
+
+	mutex_unlock(&mem->lock);
+}
+
 int amdgpu_amdkfd_gpuvm_unmap_memory_from_gpu(
 		struct amdgpu_device *adev, struct kgd_mem *mem, void *drm_priv)
 {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index d33ba4fe9ad5b..045280c2b607c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1432,17 +1432,21 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 			goto sync_memory_failed;
 		}
 	}
-	mutex_unlock(&p->mutex);
 
-	if (flush_tlb) {
-		/* Flush TLBs after waiting for the page table updates to complete */
-		for (i = 0; i < args->n_devices; i++) {
-			peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
-			if (WARN_ON_ONCE(!peer_pdd))
-				continue;
+	/* Flush TLBs after waiting for the page table updates to complete */
+	for (i = 0; i < args->n_devices; i++) {
+		peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
+		if (WARN_ON_ONCE(!peer_pdd))
+			continue;
+		if (flush_tlb)
 			kfd_flush_tlb(peer_pdd, TLB_FLUSH_HEAVYWEIGHT);
-		}
+
+		/* Remove dma mapping after tlb flush to avoid IO_PAGE_FAULT */
+		amdgpu_amdkfd_gpuvm_dmaunmap_mem(mem, peer_pdd->drm_priv);
 	}
+
+	mutex_unlock(&p->mutex);
+
 	kfree(devices_arr);
 
 	return 0;
-- 
2.43.0



