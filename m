Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE26B280021;
	Tue, 27 May 2025 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368322; cv=none; b=fwmEJgWNl7sQ7aq0ehGG7j0uIZ/EGKE9boLFJkQigdMU8p7P9RS7cYXCe8/eGIVOrtqIrxit1Jzf1AsQ4COwNeRYuEqN6S4LhsCGdYxsNWbleBbzecMJ/bzGWcMgGYQov/X75dlewKBz48AxDe3gpOZtfqjuR/w12Vi54OVcELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368322; c=relaxed/simple;
	bh=NWC/SQz66fvMC0Ga3KTldamZlHOMxS2vBGGVDpiu/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzuyI9ZsNwfXk6ieu62b0gU8WdBbXkPZc+86CYZbT7mg42Ku5M9fezm6/Xu6JzqIbVKd/V1YRk4/qXqTBwZgSn5YtddmrX7V4kbK2W+zxNgZ96xKU6dBmCK2bSczJG1+GD/AqO8wWm2VGhaPQuviWGM5vz8b09WwmoqxpYBdZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOI16WpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOI16WpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF5EC4CEE9;
	Tue, 27 May 2025 17:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368322;
	bh=NWC/SQz66fvMC0Ga3KTldamZlHOMxS2vBGGVDpiu/FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOI16WpGGrizVwXmIFCuwGqEJ9EKkxBhFMacbpkO59vuSAYILKWcfQUbgEfDe513s
	 IA8KcqSvYnI42Dw9mmGKV7D//UkAQhgroPyzuLSLI+Kgko+ESVm9q/9yWY5c+Y54KF
	 GVgxqkcCwWINhANL24WeH4Kv0sN0OJ1PFzC0nus8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 643/783] drm/amdkfd: Fix pasid value leak
Date: Tue, 27 May 2025 18:27:20 +0200
Message-ID: <20250527162539.326318651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 10e08943caedfb4b0b95933d248503a6f6b9fef6 ]

Curret kfd does not allocate pasid values, instead uses pasid value for each
vm from graphic driver. So should not prevent graphic driver from releasing
pasid values since the values are allocated by graphic driver, not kfd driver
anymore. This patch does not stop graphic driver release pasid values.

Fixes: 8544374c0f82 ("drm/amdkfd: Have kfd driver use same PASID values from graphic driver")
Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  2 --
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 21 -------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c        | 14 -------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h        |  1 -
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |  5 +----
 5 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index a160ffe80b3de..55d5399676951 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -303,8 +303,6 @@ int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct amdgpu_device *adev,
 					struct amdgpu_vm *avm,
 					void **process_info,
 					struct dma_fence **ef);
-void amdgpu_amdkfd_gpuvm_release_process_vm(struct amdgpu_device *adev,
-					void *drm_priv);
 uint64_t amdgpu_amdkfd_gpuvm_get_process_page_dir(void *drm_priv);
 size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 					uint8_t xcp_id);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 0c8129f8d3635..b3c8eae460425 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1578,27 +1578,6 @@ void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
 	}
 }
 
-void amdgpu_amdkfd_gpuvm_release_process_vm(struct amdgpu_device *adev,
-					    void *drm_priv)
-{
-	struct amdgpu_vm *avm;
-
-	if (WARN_ON(!adev || !drm_priv))
-		return;
-
-	avm = drm_priv_to_vm(drm_priv);
-
-	pr_debug("Releasing process vm %p\n", avm);
-
-	/* The original pasid of amdgpu vm has already been
-	 * released during making a amdgpu vm to a compute vm
-	 * The current pasid is managed by kfd and will be
-	 * released on kfd process destroy. Set amdgpu pasid
-	 * to 0 to avoid duplicate release.
-	 */
-	amdgpu_vm_release_compute(adev, avm);
-}
-
 uint64_t amdgpu_amdkfd_gpuvm_get_process_page_dir(void *drm_priv)
 {
 	struct amdgpu_vm *avm = drm_priv_to_vm(drm_priv);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index f0d675c0fc69c..21be10d46cf9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2687,20 +2687,6 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 	return r;
 }
 
-/**
- * amdgpu_vm_release_compute - release a compute vm
- * @adev: amdgpu_device pointer
- * @vm: a vm turned into compute vm by calling amdgpu_vm_make_compute
- *
- * This is a correspondant of amdgpu_vm_make_compute. It decouples compute
- * pasid from vm. Compute should stop use of vm after this call.
- */
-void amdgpu_vm_release_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm)
-{
-	amdgpu_vm_set_pasid(adev, vm, 0);
-	vm->is_compute_context = false;
-}
-
 static int amdgpu_vm_stats_is_zero(struct amdgpu_vm *vm)
 {
 	for (int i = 0; i < __AMDGPU_PL_NUM; ++i) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
index 5010a3107bf89..f3ad687125ad6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -489,7 +489,6 @@ int amdgpu_vm_set_pasid(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 long amdgpu_vm_wait_idle(struct amdgpu_vm *vm, long timeout);
 int amdgpu_vm_init(struct amdgpu_device *adev, struct amdgpu_vm *vm, int32_t xcp_id);
 int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm);
-void amdgpu_vm_release_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm);
 void amdgpu_vm_fini(struct amdgpu_device *adev, struct amdgpu_vm *vm);
 int amdgpu_vm_lock_pd(struct amdgpu_vm *vm, struct drm_exec *exec,
 		      unsigned int num_fences);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 3f411922534b3..7c0c24732481e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1059,11 +1059,8 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 		kfd_process_device_destroy_cwsr_dgpu(pdd);
 		kfd_process_device_destroy_ib_mem(pdd);
 
-		if (pdd->drm_file) {
-			amdgpu_amdkfd_gpuvm_release_process_vm(
-					pdd->dev->adev, pdd->drm_priv);
+		if (pdd->drm_file)
 			fput(pdd->drm_file);
-		}
 
 		if (pdd->qpd.cwsr_kaddr && !pdd->qpd.cwsr_base)
 			free_pages((unsigned long)pdd->qpd.cwsr_kaddr,
-- 
2.39.5



