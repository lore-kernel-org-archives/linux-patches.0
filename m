Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CA91C57BF;
	Tue, 27 Aug 2024 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772449; cv=none; b=bkpg2kZKFSgilqtofmcDQpHZPUoY5rHt25RXx+44/6wtWk5HzeVl01IlxJLUBS/wGPi5tzGyGpKUkNjcpelgi6jQxw0D9WLOGdaSePeM6Zw45MTAXyCNlDxojYoSVAmmK4vjyZgXGrrGcut3Gfl1kz2U6to1/qzC15dPD8RKFLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772449; c=relaxed/simple;
	bh=GCmwnawkoidqEsbdcz9sb6u3A794npnm300DXmaATfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDuCU5ecsebeOxyP8dmSl53cr4lzs6IRbP5SbMaLEh4gSllWY80fOLZGdt3TLdUOiHQmC4f1GoE04AL5ATgVugCeNCUDTSFBionqfYSKUP9kQxQNIFdB+Gx0/66AVSk0eV93yrPUzAAymPznX9OD/5xc+Dt5zwfExGX+OYiCOcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nH6/Tehk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nH6/Tehk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB6CC61047;
	Tue, 27 Aug 2024 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772449;
	bh=GCmwnawkoidqEsbdcz9sb6u3A794npnm300DXmaATfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nH6/TehkuoLI1Z8eLMqPhpYqXtzwJ4SMd3dlmHqv4WM0WJKcyS88tgVVHxyteuQZO
	 1TYlF6s+4XAhJk7JgVj4L1H4IkjlTRWfIX9S2H1oF78v0Yta+LzmEsL9bKZ9/q1MAf
	 YjVApZU7slsHsnRudUcp5JUOPaTljBZJrTLQOPc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/321] drm/amdkfd: reserve the BO before validating it
Date: Tue, 27 Aug 2024 16:38:47 +0200
Message-ID: <20240827143846.569526586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <Lang.Yu@amd.com>

[ Upstream commit 0c93bd49576677ae1a18817d5ec000ef031d5187 ]

Fix a warning.

v2: Avoid unmapping attachment repeatedly when ERESTARTSYS.

v3: Lock the BO before accessing ttm->sg to avoid race conditions.(Felix)

[   41.708711] WARNING: CPU: 0 PID: 1463 at drivers/gpu/drm/ttm/ttm_bo.c:846 ttm_bo_validate+0x146/0x1b0 [ttm]
[   41.708989] Call Trace:
[   41.708992]  <TASK>
[   41.708996]  ? show_regs+0x6c/0x80
[   41.709000]  ? ttm_bo_validate+0x146/0x1b0 [ttm]
[   41.709008]  ? __warn+0x93/0x190
[   41.709014]  ? ttm_bo_validate+0x146/0x1b0 [ttm]
[   41.709024]  ? report_bug+0x1f9/0x210
[   41.709035]  ? handle_bug+0x46/0x80
[   41.709041]  ? exc_invalid_op+0x1d/0x80
[   41.709048]  ? asm_exc_invalid_op+0x1f/0x30
[   41.709057]  ? amdgpu_amdkfd_gpuvm_dmaunmap_mem+0x2c/0x80 [amdgpu]
[   41.709185]  ? ttm_bo_validate+0x146/0x1b0 [ttm]
[   41.709197]  ? amdgpu_amdkfd_gpuvm_dmaunmap_mem+0x2c/0x80 [amdgpu]
[   41.709337]  ? srso_alias_return_thunk+0x5/0x7f
[   41.709346]  kfd_mem_dmaunmap_attachment+0x9e/0x1e0 [amdgpu]
[   41.709467]  amdgpu_amdkfd_gpuvm_dmaunmap_mem+0x56/0x80 [amdgpu]
[   41.709586]  kfd_ioctl_unmap_memory_from_gpu+0x1b7/0x300 [amdgpu]
[   41.709710]  kfd_ioctl+0x1ec/0x650 [amdgpu]
[   41.709822]  ? __pfx_kfd_ioctl_unmap_memory_from_gpu+0x10/0x10 [amdgpu]
[   41.709945]  ? srso_alias_return_thunk+0x5/0x7f
[   41.709949]  ? tomoyo_file_ioctl+0x20/0x30
[   41.709959]  __x64_sys_ioctl+0x9c/0xd0
[   41.709967]  do_syscall_64+0x3f/0x90
[   41.709973]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: 101b8104307e ("drm/amdkfd: Move dma unmapping after TLB flush")
Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  2 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 20 ++++++++++++++++---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      |  4 +++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 585d608c10e8e..4b694886715cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -286,7 +286,7 @@ int amdgpu_amdkfd_gpuvm_map_memory_to_gpu(struct amdgpu_device *adev,
 					  struct kgd_mem *mem, void *drm_priv);
 int amdgpu_amdkfd_gpuvm_unmap_memory_from_gpu(
 		struct amdgpu_device *adev, struct kgd_mem *mem, void *drm_priv);
-void amdgpu_amdkfd_gpuvm_dmaunmap_mem(struct kgd_mem *mem, void *drm_priv);
+int amdgpu_amdkfd_gpuvm_dmaunmap_mem(struct kgd_mem *mem, void *drm_priv);
 int amdgpu_amdkfd_gpuvm_sync_memory(
 		struct amdgpu_device *adev, struct kgd_mem *mem, bool intr);
 int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 3e7f4d8dc9d13..d486f5dc052e4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2025,21 +2025,35 @@ int amdgpu_amdkfd_gpuvm_map_memory_to_gpu(
 	return ret;
 }
 
-void amdgpu_amdkfd_gpuvm_dmaunmap_mem(struct kgd_mem *mem, void *drm_priv)
+int amdgpu_amdkfd_gpuvm_dmaunmap_mem(struct kgd_mem *mem, void *drm_priv)
 {
 	struct kfd_mem_attachment *entry;
 	struct amdgpu_vm *vm;
+	int ret;
 
 	vm = drm_priv_to_vm(drm_priv);
 
 	mutex_lock(&mem->lock);
 
+	ret = amdgpu_bo_reserve(mem->bo, true);
+	if (ret)
+		goto out;
+
 	list_for_each_entry(entry, &mem->attachments, list) {
-		if (entry->bo_va->base.vm == vm)
-			kfd_mem_dmaunmap_attachment(mem, entry);
+		if (entry->bo_va->base.vm != vm)
+			continue;
+		if (entry->bo_va->base.bo->tbo.ttm &&
+		    !entry->bo_va->base.bo->tbo.ttm->sg)
+			continue;
+
+		kfd_mem_dmaunmap_attachment(mem, entry);
 	}
 
+	amdgpu_bo_unreserve(mem->bo);
+out:
 	mutex_unlock(&mem->lock);
+
+	return ret;
 }
 
 int amdgpu_amdkfd_gpuvm_unmap_memory_from_gpu(
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 2b21ce967e766..e3cd66c4d95d8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1410,7 +1410,9 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 			kfd_flush_tlb(peer_pdd, TLB_FLUSH_HEAVYWEIGHT);
 
 		/* Remove dma mapping after tlb flush to avoid IO_PAGE_FAULT */
-		amdgpu_amdkfd_gpuvm_dmaunmap_mem(mem, peer_pdd->drm_priv);
+		err = amdgpu_amdkfd_gpuvm_dmaunmap_mem(mem, peer_pdd->drm_priv);
+		if (err)
+			goto sync_memory_failed;
 	}
 
 	mutex_unlock(&p->mutex);
-- 
2.43.0



