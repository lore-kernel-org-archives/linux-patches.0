Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBC01F75BE;
	Tue, 17 Dec 2024 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456427; cv=none; b=gMiooQdDgYyvLTLKnMqIAahw2iLBXOSMh7PcehY6eTgvgaUU9XlbgZuNktBvqsRYUmNqel2bM1elSO2osIJLJW6kIrA2NQydNTK8XJpNr/DONgNU1Pw9YsQ1rAeJzOXnKZd1kfmNuTXuMuFCnzy9Se1UQ4IRrbKWIiPr7Hd9fOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456427; c=relaxed/simple;
	bh=FSGCHCu3T0oPaPSuSXo3p1WqKY+cGqugUT3s121V++k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5aNZ7b+vfaoHV73wcm3D2XPTp9C4upmNZBAytIij21Wjzo+Y4i6TCUrHhFkfsnDRIGa0+tjBm83pRpLiXB59qrmzEUZq1GLXgvqXUipL5P0XXS3sSphIM+98Eb1p71yHSc1PyZLiqcF04paZcxwTsiB0XGrKTS7ZDbJSx0Vzfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb/SZAKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb/SZAKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC60FC4CED3;
	Tue, 17 Dec 2024 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456427;
	bh=FSGCHCu3T0oPaPSuSXo3p1WqKY+cGqugUT3s121V++k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb/SZAKE3sCYZd7jcScu28hcndZvkIlC2roIjkb9Zux509WYzhAF/amjjc61t4Rtl
	 8TrO7rQvmaJFWPmyDVIOII5m6+wknpYcYVRjFwSgIboEphhcao/+yiZQIc6Vn7NU0J
	 nO4/gNKLpUgXJZ2tSpPk70pgJlL8lEDzv+PrVQDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 057/172] drm/amdkfd: pause autosuspend when creating pdd
Date: Tue, 17 Dec 2024 18:06:53 +0100
Message-ID: <20241217170548.640013540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.zhang@amd.com <Jesse.zhang@amd.com>

commit 438b39ac74e2a9dc0a5c9d653b7d8066877e86b1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |   15 +++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c              |   23 +-----------------
 2 files changed, 17 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -205,6 +205,21 @@ static int add_queue_mes(struct device_q
 	if (!down_read_trylock(&adev->reset_domain->sem))
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
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1076,7 +1076,8 @@ static void kfd_process_destroy_pdds(str
 
 		kfd_free_process_doorbells(pdd->dev->kfd, pdd);
 
-		if (pdd->dev->kfd->shared_resources.enable_mes)
+		if (pdd->dev->kfd->shared_resources.enable_mes &&
+			pdd->proc_ctx_cpu_ptr)
 			amdgpu_amdkfd_free_gtt_mem(pdd->dev->adev,
 						   &pdd->proc_ctx_bo);
 		/*
@@ -1610,7 +1611,6 @@ struct kfd_process_device *kfd_create_pr
 							struct kfd_process *p)
 {
 	struct kfd_process_device *pdd = NULL;
-	int retval = 0;
 
 	if (WARN_ON_ONCE(p->n_pdds >= MAX_GPU_INSTANCE))
 		return NULL;
@@ -1634,21 +1634,6 @@ struct kfd_process_device *kfd_create_pr
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
@@ -1660,10 +1645,6 @@ struct kfd_process_device *kfd_create_pr
 	idr_init(&pdd->alloc_idr);
 
 	return pdd;
-
-err_free_pdd:
-	kfree(pdd);
-	return NULL;
 }
 
 /**


