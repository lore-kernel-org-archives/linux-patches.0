Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACF344607D;
	Tue, 21 Jul 2026 19:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660907; cv=none; b=BmgXXU5TJhF/83fbwxZqZ1t4xckIzteeoy+KcHWzqoEhmiZBo3FNKEAkshT9ozsIkFQU3uYeyE8HpPrIhbaSWhZvxNazSf3qx6kwxqHfqdkFTjupusdk3uudUab1M3+w0RQ5EubPhOg/7gWpn0dFrkIHzEdUvkiaM/0IDIouzNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660907; c=relaxed/simple;
	bh=IT2JNViFxs9iG2oA77bHwH5fA7mVJgxFTiD/AhxzNnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goxdtbu+LAAaBnBbfBUmqYlkUfNk+EloDb25aH+4lbJk4AjRMxdJp0YMOmJtGdEjDzn1p/RuTj9hU8O95ak1ZTHSlN/ufS5/bSEIFH80eGUw/LYpNutIEmQiAqpZLbZs1ibWM+IPROcP277HN6+XIgptUlHuqn4RE2IAhBhkAks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tzlzgQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tzlzgQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2601F000E9;
	Tue, 21 Jul 2026 19:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660906;
	bh=R1HkCGp4k0/xeHSVSnt6hr/d8FuxUUCH/eKjGCvGTpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tzlzgQ5QORa1nvqVyP0GTnwaWMbeht0x4Z5c/kB0cQr0uEVZwKUxZ9tZM6SGd3ZC
	 E/jmwXDDraI2qzCjzRGsIQLCYC3gVHmoDKy9uErMpjymw1W0CFnBMtc6YYeXhr12Cf
	 WIcp/nzKylDlqEjbXb2GtnChfw+h87ifa/BsQhTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1103/2077] drm/amdkfd: Avoid double-unpin of DOORBELL/MMIO BOs on free
Date: Tue, 21 Jul 2026 17:12:56 +0200
Message-ID: <20260721152618.835284234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 72a5a29e63f6da..abc31948896924 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1914,13 +1914,6 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 
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
@@ -1934,6 +1927,15 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
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
 	if (!list_empty(&mem->validate_list))
-- 
2.53.0



