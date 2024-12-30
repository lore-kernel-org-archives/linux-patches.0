Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3D715E8B;
	Mon, 30 Dec 2024 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573911; cv=none; b=TsNwIBPx6XB6lwVnwmvYgDr6CSDio0aZl7J2HLnYStLgU0xpwLUY1psHh39pTfsUL/hyGZez5pNDDr4VdspB36cH7P2l4qs0u0CiJ7UC/+aF5Fx5NaDSqtd+WiM6JAMAzmABKS1B+n/wxW2va+AoFsLd1hcKOkjZM/imW0nJicI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573911; c=relaxed/simple;
	bh=V1uarwE8A0tlsQUEdVaM6Rpu2TiiS+uSsME8GVRcuhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMqYbJMx6X0rNDefiDKDSwFvoQxJFlgcePlybKG6ZuXPIJVbE10Rg9nWYL0bHg6c+5shiRgRI4OsrTHmE1e+OvNDSJ3GzjwjGGae2P7hqphgxBUuXuQCuUIL/YwbJ9BzjAMTORdGpdmqDLJqoymkWvb5iIHe+6dRT1lXGiEGW8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3aw12zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3aw12zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45891C4CED0;
	Mon, 30 Dec 2024 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573911;
	bh=V1uarwE8A0tlsQUEdVaM6Rpu2TiiS+uSsME8GVRcuhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3aw12zHrQk6BGnR+R+Y582hGNhfRXXPNseCfk/VWpTV/4DysQl/zZFONhOPfqZrj
	 yGUTa4ME1vAV9bQvfSJHFsQeFw3+eWJ4hSBIcG3bmQ7ww1vuqmtRxX29t7W5ueP/R5
	 cDPvCXMPowDBOTnVn5qSeym+4d0SmvRYq5qCVUpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 71/86] drm/amdkfd: pause autosuspend when creating pdd
Date: Mon, 30 Dec 2024 16:43:19 +0100
Message-ID: <20241230154214.412434784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.zhang@amd.com <Jesse.zhang@amd.com>

[ Upstream commit 438b39ac74e2a9dc0a5c9d653b7d8066877e86b1 ]

When using MES creating a pdd will require talking to the GPU to
setup the relevant context. The code here forgot to wake up the GPU
in case it was in suspend, this causes KVM to EFAULT for passthrough
GPU for example. This issue can be masked if the GPU was woken up by
other things (e.g. opening the KMS node) first and have not yet gone to sleep.

v4: do the allocation of proc_ctx_bo in a lazy fashion
when the first queue is created in a process (Felix)

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Yunxiang Li <Yunxiang.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 15 ++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      | 23 ++-----------------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4d9a406925e1..43fa260ddbce 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -197,6 +197,21 @@ static int add_queue_mes(struct device_queue_manager *dqm, struct queue *q,
 	if (dqm->is_hws_hang)
 		return -EIO;
 
+	if (!pdd->proc_ctx_cpu_ptr) {
+		r = amdgpu_amdkfd_alloc_gtt_mem(adev,
+				AMDGPU_MES_PROC_CTX_SIZE,
+				&pdd->proc_ctx_bo,
+				&pdd->proc_ctx_gpu_addr,
+				&pdd->proc_ctx_cpu_ptr,
+				false);
+		if (r) {
+			dev_err(adev->dev,
+				"failed to allocate process context bo\n");
+			return r;
+		}
+		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
+	}
+
 	memset(&queue_input, 0x0, sizeof(struct mes_add_queue_input));
 	queue_input.process_id = qpd->pqm->process->pasid;
 	queue_input.page_table_base_addr =  qpd->page_table_base;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 577bdb6a9640..64346c71c62a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1046,7 +1046,8 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 
 		kfd_free_process_doorbells(pdd->dev->kfd, pdd);
 
-		if (pdd->dev->kfd->shared_resources.enable_mes)
+		if (pdd->dev->kfd->shared_resources.enable_mes &&
+			pdd->proc_ctx_cpu_ptr)
 			amdgpu_amdkfd_free_gtt_mem(pdd->dev->adev,
 						   &pdd->proc_ctx_bo);
 		/*
@@ -1572,7 +1573,6 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_node *dev,
 							struct kfd_process *p)
 {
 	struct kfd_process_device *pdd = NULL;
-	int retval = 0;
 
 	if (WARN_ON_ONCE(p->n_pdds >= MAX_GPU_INSTANCE))
 		return NULL;
@@ -1596,21 +1596,6 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_node *dev,
 	pdd->user_gpu_id = dev->id;
 	atomic64_set(&pdd->evict_duration_counter, 0);
 
-	if (dev->kfd->shared_resources.enable_mes) {
-		retval = amdgpu_amdkfd_alloc_gtt_mem(dev->adev,
-						AMDGPU_MES_PROC_CTX_SIZE,
-						&pdd->proc_ctx_bo,
-						&pdd->proc_ctx_gpu_addr,
-						&pdd->proc_ctx_cpu_ptr,
-						false);
-		if (retval) {
-			dev_err(dev->adev->dev,
-				"failed to allocate process context bo\n");
-			goto err_free_pdd;
-		}
-		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
-	}
-
 	p->pdds[p->n_pdds++] = pdd;
 	if (kfd_dbg_is_per_vmid_supported(pdd->dev))
 		pdd->spi_dbg_override = pdd->dev->kfd2kgd->disable_debug_trap(
@@ -1622,10 +1607,6 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_node *dev,
 	idr_init(&pdd->alloc_idr);
 
 	return pdd;
-
-err_free_pdd:
-	kfree(pdd);
-	return NULL;
 }
 
 /**
-- 
2.39.5



