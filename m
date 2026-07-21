Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF773BA232;
	Tue, 21 Jul 2026 21:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669487; cv=none; b=Zor1S7ehS1OpJwMqbC6FR+YWCeIbfcA4fGp0iC7GA/+UiAG7827hmAlvqMEmB0I3L5GwdDMw4iaq2O7PK/XT1/ry7Za4Ra8yXD4A2CoYJbb7vEwQe1B4jBn4dLCJLAtV/+xIOxnsN3RoEM3d1sCXib/vEADnbL7Xi4Uieo+pfoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669487; c=relaxed/simple;
	bh=vXaTHpIYotOPjrOy6SnSweESDlcq2yZ4RAXfheGKi/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuTdqRVJBXGTS9gw0AiRl29bGKMeu9awEFwBNtY7lgHY1rDGI91n5MqbJNH2uaexLyBIODqiW2yioorUwHYNIMa0iFe4eW8/+mMsNnXpCGySTsPKOwnYEUBLJuYB8SSm/KfDVkbWU+X3FRBhs5HozAHFrlhdkYL8e138mUk5EgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khNgaWdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khNgaWdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6DD1F000E9;
	Tue, 21 Jul 2026 21:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669486;
	bh=9UlSppM7nPsNKjgu3xDXq1GVVlMS1J3niXz11yv4dB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khNgaWdvZQU26elnrVhsoHKwgy4QOvOeoef9XJvN4f55SpZ4KQFLTLpE3UjS4QGKP
	 IBa1VLiSeiIH8yunTssx2fUJNoGHJtwH01OHy+BFZaAjvfTgqJoyuVzt+Zk6v6YE//
	 tjRwTKuWZ/6wvXj9YGTtxRElN/KP2m71/1qtGjKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0574/1067] drm/amdkfd: Avoid double-unpin of DOORBELL/MMIO BOs on free
Date: Tue, 21 Jul 2026 17:19:35 +0200
Message-ID: <20260721152437.444590741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d7b1e1bdd7f479..aaeb915a776d01 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1812,13 +1812,6 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 
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
@@ -1832,6 +1825,15 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
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
 	bo_list_entry = &mem->validate_list;
 	mutex_lock(&process_info->lock);
-- 
2.53.0



