Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5BEAD0;
	Fri, 15 Nov 2024 06:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653295; cv=none; b=rmo0F/fH6wub5S1+kPmfhGaEjb40ksNKUFVXUAYtMIbe9PLjlB9+WHKGUrB3M+tIujS/6hfZH/mHG6ICJBTdWuZPR31OduaPSjWw2PWlTbzuJXycKRlpAaoA4jD5Ym+Nle3B94je8LXxg9JdUfjKmbbKa/VgRNVCaXzE8i6dDgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653295; c=relaxed/simple;
	bh=ABAg4xhNy54k98nmqOLid28oKCegm1gMGevX4VpH+vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DILuTOla7S+E+nxDzCfqgdNf84rpn9uQJu7apsnPjh3qBEzD1hhc05bXRztOWyQ8hQ/LdtPWEjWkZc1iL+auZ8bMmOURd/SDXaODNpqZByiRsqSA6i627uj0Tvj4erj33aoKWuzNIFwU9zaNuLvTKj2zlOnhGzMdVyIaKYoXdcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmBx0zB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmBx0zB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ED9C4CECF;
	Fri, 15 Nov 2024 06:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653295;
	bh=ABAg4xhNy54k98nmqOLid28oKCegm1gMGevX4VpH+vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmBx0zB0zbbxTfD5VAtJH0oNOo55Mx/CEfGJFAk7Z7EjEFvHuF78yVIhuNVH9m5+b
	 ZUsQgvj+BpQ3ea6aMxDmzBGs03m4ikXTP7xTcONL1KovBDF3eZc+hqo1aypIe2AwXo
	 QGLzwZO8Si7l0mxcabbyMaBcYW2TkyqZgrDGR7OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 27/63] drm/amdkfd: Accounting pdd vram_usage for svm
Date: Fri, 15 Nov 2024 07:37:50 +0100
Message-ID: <20241115063726.900156661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 68d26c10ef503175df3142db6fcd75dd94860592 ]

Process device data pdd->vram_usage is read by rocm-smi via sysfs, this
is currently missing the svm_bo usage accounting, so "rocm-smi
--showpids" per process VRAM usage report is incorrect.

Add pdd->vram_usage accounting when svm_bo allocation and release,
change to atomic64_t type because it is updated outside process mutex
now.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 98c0b0efcc11f2a5ddf3ce33af1e48eedf808b04)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |  6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |  4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c     | 26 ++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 546b02f2241a6..5953bc5f31192 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1170,7 +1170,7 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 
 		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
 			size >>= 1;
-		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + PAGE_ALIGN(size));
+		atomic64_add(PAGE_ALIGN(size), &pdd->vram_usage);
 	}
 
 	mutex_unlock(&p->mutex);
@@ -1241,7 +1241,7 @@ static int kfd_ioctl_free_memory_of_gpu(struct file *filep,
 		kfd_process_device_remove_obj_handle(
 			pdd, GET_IDR_HANDLE(args->handle));
 
-	WRITE_ONCE(pdd->vram_usage, pdd->vram_usage - size);
+	atomic64_sub(size, &pdd->vram_usage);
 
 err_unlock:
 err_pdd:
@@ -2346,7 +2346,7 @@ static int criu_restore_memory_of_gpu(struct kfd_process_device *pdd,
 	} else if (bo_bucket->alloc_flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM) {
 		bo_bucket->restored_offset = offset;
 		/* Update the VRAM usage count */
-		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + bo_bucket->size);
+		atomic64_add(bo_bucket->size, &pdd->vram_usage);
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 2b3ec92981e8f..f35741fade911 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -766,7 +766,7 @@ struct kfd_process_device {
 	enum kfd_pdd_bound bound;
 
 	/* VRAM usage */
-	uint64_t vram_usage;
+	atomic64_t vram_usage;
 	struct attribute attr_vram;
 	char vram_filename[MAX_SYSFS_FILENAME_LEN];
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index e44892109f71b..8343b3e4de7b5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -306,7 +306,7 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 	} else if (strncmp(attr->name, "vram_", 5) == 0) {
 		struct kfd_process_device *pdd = container_of(attr, struct kfd_process_device,
 							      attr_vram);
-		return snprintf(buffer, PAGE_SIZE, "%llu\n", READ_ONCE(pdd->vram_usage));
+		return snprintf(buffer, PAGE_SIZE, "%llu\n", atomic64_read(&pdd->vram_usage));
 	} else if (strncmp(attr->name, "sdma_", 5) == 0) {
 		struct kfd_process_device *pdd = container_of(attr, struct kfd_process_device,
 							      attr_sdma);
@@ -1599,7 +1599,7 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_node *dev,
 	pdd->bound = PDD_UNBOUND;
 	pdd->already_dequeued = false;
 	pdd->runtime_inuse = false;
-	pdd->vram_usage = 0;
+	atomic64_set(&pdd->vram_usage, 0);
 	pdd->sdma_past_activity_counter = 0;
 	pdd->user_gpu_id = dev->id;
 	atomic64_set(&pdd->evict_duration_counter, 0);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index bd9c2921e0dcc..7d00d89586a10 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -404,6 +404,27 @@ static void svm_range_bo_release(struct kref *kref)
 		spin_lock(&svm_bo->list_lock);
 	}
 	spin_unlock(&svm_bo->list_lock);
+
+	if (mmget_not_zero(svm_bo->eviction_fence->mm)) {
+		struct kfd_process_device *pdd;
+		struct kfd_process *p;
+		struct mm_struct *mm;
+
+		mm = svm_bo->eviction_fence->mm;
+		/*
+		 * The forked child process takes svm_bo device pages ref, svm_bo could be
+		 * released after parent process is gone.
+		 */
+		p = kfd_lookup_process_by_mm(mm);
+		if (p) {
+			pdd = kfd_get_process_device_data(svm_bo->node, p);
+			if (pdd)
+				atomic64_sub(amdgpu_bo_size(svm_bo->bo), &pdd->vram_usage);
+			kfd_unref_process(p);
+		}
+		mmput(mm);
+	}
+
 	if (!dma_fence_is_signaled(&svm_bo->eviction_fence->base))
 		/* We're not in the eviction worker. Signal the fence. */
 		dma_fence_signal(&svm_bo->eviction_fence->base);
@@ -531,6 +552,7 @@ int
 svm_range_vram_node_new(struct kfd_node *node, struct svm_range *prange,
 			bool clear)
 {
+	struct kfd_process_device *pdd;
 	struct amdgpu_bo_param bp;
 	struct svm_range_bo *svm_bo;
 	struct amdgpu_bo_user *ubo;
@@ -622,6 +644,10 @@ svm_range_vram_node_new(struct kfd_node *node, struct svm_range *prange,
 	list_add(&prange->svm_bo_list, &svm_bo->range_list);
 	spin_unlock(&svm_bo->list_lock);
 
+	pdd = svm_range_get_pdd_by_node(prange, node);
+	if (pdd)
+		atomic64_add(amdgpu_bo_size(bo), &pdd->vram_usage);
+
 	return 0;
 
 reserve_bo_failed:
-- 
2.43.0



