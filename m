Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A88415F0C;
	Tue, 21 Jul 2026 18:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657535; cv=none; b=dGeJwzalZsrDbKj5C0M64WCj3XH7TVszw8wCksFocjOgBab7SOzcZwdYKWHocsd4EbwRDzRPXYk6aq0AtAEQ4qZaVhfeQwMkkBRd2s54/Va68QTlHtdWKrGW8jYVmcjVmGraRR2QtbRQDEIiOoDHUhv3QeZLeyc3HGByNlDgcs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657535; c=relaxed/simple;
	bh=NEWVOxkTG7Fepd4/Ye97QytQJkRUyX1/YDJnmq9gGCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9Zc9DrW5SSpMFNwAvtIG2i+iiW+MAvYduQjIdR4omMkpxlgErggg8q0pao527KDJEdbi6dfQDAnwj4ZnFsuEdIpvwsP565nYxFdqkdoqwOy30Ft9mSa9Wb/LXhjrI6kM40eYVFDDtpq8PYzi2+NDtffKEATUy2cPgsWdE57LFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvl3PLVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvl3PLVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89C21F000E9;
	Tue, 21 Jul 2026 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657534;
	bh=lBv9dt6SJrIQdhQOgwVlqCVsVDXd8vjEiPmYH9ygYps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvl3PLVpvoKVw6GLOdKVryJTuBp7RBfGF+9pSc/blT9kSVIAjB1q3Wgp5rlZ4gPCb
	 /gWvlqUTp4BlX8EVYhmYjKBY4kPIRM1YmVQNPM70jg3VBlhAvggDUwfvbmBihqJpkg
	 E4GC9DI9aD3PXLUji+R8tWw5gxdg66xh4wCG3K/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0802/1611] drm/amdkfd: Avoid double-unpin of DOORBELL/MMIO BOs on free
Date: Tue, 21 Jul 2026 17:15:18 +0200
Message-ID: <20260721152533.424763031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit 3f0cc1735273a57c5116710cf0202e12152f59cc ]

amdgpu_amdkfd_gpuvm_free_memory_of_gpu() unpinned DOORBELL and MMIO
remap BOs (which are pinned at allocation time) before checking whether
the BO is still mapped to the GPU. When the BO is still mapped, the
function returns -EBUSY and leaves the BO alive, but it has already
been unpinned. The BO is then unpinned again when it is finally freed
during process teardown, triggering a ttm_bo_unpin() underflow warning:

  WARNING: CPU: 18 PID: 15066 at ttm/ttm_bo.c:650 amdttm_bo_unpin+0x6d/0x80 [amdttm]
  Workqueue: kfd_process_wq kfd_process_wq_release [amdgpu]
  RIP: 0010:amdttm_bo_unpin+0x6d/0x80 [amdttm]
  Call Trace:
   amdgpu_bo_unpin+0x1a/0x90 [amdgpu]
   amdgpu_amdkfd_gpuvm_unpin_bo+0x31/0xb0 [amdgpu]
   amdgpu_amdkfd_gpuvm_free_memory_of_gpu+0x3bf/0x460 [amdgpu]
   kfd_process_free_outstanding_kfd_bos+0xd4/0x170 [amdgpu]
   kfd_process_wq_release+0x109/0x1b0 [amdgpu]
   process_one_work+0x1e2/0x3b0
   worker_thread+0x50/0x3a0
   kthread+0xdd/0x100
   ret_from_fork+0x29/0x50

Move the unpin after the mapped_to_gpu_memory check so it only happens
once we are committed to freeing the BO.

Fixes: d25e35bc26c3 ("drm/amdgpu: Pin MMIO/DOORBELL BO's in GTT  domain")
Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 927c5b2defb9b09856444d94bebfd056a002bd75)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 0ab85d0a6a43e2..285c35545ebbfb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1896,13 +1896,6 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 
 	mutex_lock(&mem->lock);
 
-	/* Unpin MMIO/DOORBELL BO's that were pinned during allocation */
-	if (mem->alloc_flags &
-	    (KFD_IOC_ALLOC_MEM_FLAGS_DOORBELL |
-	     KFD_IOC_ALLOC_MEM_FLAGS_MMIO_REMAP)) {
-		amdgpu_amdkfd_gpuvm_unpin_bo(mem->bo);
-	}
-
 	mapped_to_gpu_memory = mem->mapped_to_gpu_memory;
 	is_imported = mem->is_imported;
 	mutex_unlock(&mem->lock);
@@ -1916,6 +1909,15 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 		return -EBUSY;
 	}
 
+	/* At this point the BO is guaranteed to be freed, so unpin the
+	 * MMIO/DOORBELL BOs that were pinned during allocation.
+	 */
+	if (mem->alloc_flags &
+	    (KFD_IOC_ALLOC_MEM_FLAGS_DOORBELL |
+	     KFD_IOC_ALLOC_MEM_FLAGS_MMIO_REMAP)) {
+		amdgpu_amdkfd_gpuvm_unpin_bo(mem->bo);
+	}
+
 	/* Make sure restore workers don't access the BO any more */
 	mutex_lock(&process_info->lock);
 	list_del(&mem->validate_list);
-- 
2.53.0



