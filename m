Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9128165F08;
	Tue,  8 Oct 2024 12:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390057; cv=none; b=ClxUcB30uqMXBJLgVaZ4B1wD2v2aPKr7cBhQNcPj3RL7AGRNRWEUOpBFkx5+OIO2oN1LRD2Bs4UJq45mrU+Y6MK6FRmRiRUN346UuR8oXMdPxq/rkFXjCJhYXj/Rh9UDs4rBjKmq/RTBouqwNCABnGaYvpgcIQsry2JEe6/RN7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390057; c=relaxed/simple;
	bh=lD2iVPM3ElkXbK0izAnutaGxjtrCZVPE8+wcP4TkoNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3tpQRQ7FIy+wRXPmaa5MJS15xRbviFmKzNMSIJICIphH8/ua6jC0HZqsnAKXGI+G4m1QtZgtRapQmo9856/Qxfiyiu9bbjlmZbktTDs6kLJw6NLvECbhhyMkGpSvvd27rocBm2Jcuz/lMNNNU8+03euZY9mtg0f5nhTNNO7XOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmnZ7WEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmnZ7WEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B726C4CECD;
	Tue,  8 Oct 2024 12:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390057;
	bh=lD2iVPM3ElkXbK0izAnutaGxjtrCZVPE8+wcP4TkoNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmnZ7WEsa1VlqVyDFlVWvxo8lSrI4FLhNGVD7Qs3+6MhjvpZopIr7T6rC0ZJHtMmO
	 L3TccqmqjtkovhEwiT75Le4+nVAVOsoXLCaFQyrgW33xvtPi5xzE7SalQ/DdR0AvGj
	 ImgNhhP568IINyBVxk1r6/PuVfFE7OQhv01dTLfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 177/482] drm/amdkfd: amdkfd_free_gtt_mem clear the correct pointer
Date: Tue,  8 Oct 2024 14:04:00 +0200
Message-ID: <20241008115655.270093670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit c86ad39140bbcb9dc75a10046c2221f657e8083b ]

Pass pointer reference to amdgpu_bo_unref to clear the correct pointer,
otherwise amdgpu_bo_unref clear the local variable, the original pointer
not set to NULL, this could cause use-after-free bug.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         | 14 +++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  4 ++--
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  2 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index e3738d4172458..26ecca3e8e900 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -360,15 +360,15 @@ int amdgpu_amdkfd_alloc_gtt_mem(struct amdgpu_device *adev, size_t size,
 	return r;
 }
 
-void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void *mem_obj)
+void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void **mem_obj)
 {
-	struct amdgpu_bo *bo = (struct amdgpu_bo *) mem_obj;
+	struct amdgpu_bo **bo = (struct amdgpu_bo **) mem_obj;
 
-	amdgpu_bo_reserve(bo, true);
-	amdgpu_bo_kunmap(bo);
-	amdgpu_bo_unpin(bo);
-	amdgpu_bo_unreserve(bo);
-	amdgpu_bo_unref(&(bo));
+	amdgpu_bo_reserve(*bo, true);
+	amdgpu_bo_kunmap(*bo);
+	amdgpu_bo_unpin(*bo);
+	amdgpu_bo_unreserve(*bo);
+	amdgpu_bo_unref(bo);
 }
 
 int amdgpu_amdkfd_alloc_gws(struct amdgpu_device *adev, size_t size,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 1de021ebdd467..ee16d8a9ba559 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -233,7 +233,7 @@ int amdgpu_amdkfd_bo_validate_and_fence(struct amdgpu_bo *bo,
 int amdgpu_amdkfd_alloc_gtt_mem(struct amdgpu_device *adev, size_t size,
 				void **mem_obj, uint64_t *gpu_addr,
 				void **cpu_ptr, bool mqd_gfx9);
-void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void *mem_obj);
+void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void **mem_obj);
 int amdgpu_amdkfd_alloc_gws(struct amdgpu_device *adev, size_t size,
 				void **mem_obj);
 void amdgpu_amdkfd_free_gws(struct amdgpu_device *adev, void *mem_obj);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index fdf171ad4a3c6..4f260adce8c46 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -423,7 +423,7 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 
 err_create_queue:
 	if (wptr_bo)
-		amdgpu_amdkfd_free_gtt_mem(dev->adev, wptr_bo);
+		amdgpu_amdkfd_free_gtt_mem(dev->adev, (void **)&wptr_bo);
 err_wptr_map_gart:
 err_bind_process:
 err_pdd:
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index afc57df421cd9..3343079f28c90 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -863,7 +863,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 kfd_doorbell_error:
 	kfd_gtt_sa_fini(kfd);
 kfd_gtt_sa_init_error:
-	amdgpu_amdkfd_free_gtt_mem(kfd->adev, kfd->gtt_mem);
+	amdgpu_amdkfd_free_gtt_mem(kfd->adev, &kfd->gtt_mem);
 alloc_gtt_mem_failure:
 	dev_err(kfd_device,
 		"device %x:%x NOT added due to errors\n",
@@ -881,7 +881,7 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 		kfd_doorbell_fini(kfd);
 		ida_destroy(&kfd->doorbell_ida);
 		kfd_gtt_sa_fini(kfd);
-		amdgpu_amdkfd_free_gtt_mem(kfd->adev, kfd->gtt_mem);
+		amdgpu_amdkfd_free_gtt_mem(kfd->adev, &kfd->gtt_mem);
 	}
 
 	kfree(kfd);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index c08b6ee252898..dbef9eac2694f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2633,7 +2633,7 @@ static void deallocate_hiq_sdma_mqd(struct kfd_node *dev,
 {
 	WARN(!mqd, "No hiq sdma mqd trunk to free");
 
-	amdgpu_amdkfd_free_gtt_mem(dev->adev, mqd->gtt_mem);
+	amdgpu_amdkfd_free_gtt_mem(dev->adev, &mqd->gtt_mem);
 }
 
 void device_queue_manager_uninit(struct device_queue_manager *dqm)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
index 8746a61a852dc..d501fd2222dc3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
@@ -223,7 +223,7 @@ void kfd_free_mqd_cp(struct mqd_manager *mm, void *mqd,
 	      struct kfd_mem_obj *mqd_mem_obj)
 {
 	if (mqd_mem_obj->gtt_mem) {
-		amdgpu_amdkfd_free_gtt_mem(mm->dev->adev, mqd_mem_obj->gtt_mem);
+		amdgpu_amdkfd_free_gtt_mem(mm->dev->adev, &mqd_mem_obj->gtt_mem);
 		kfree(mqd_mem_obj);
 	} else {
 		kfd_gtt_sa_free(mm->dev, mqd_mem_obj);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 451bb058cc620..66150ea8e64d8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1048,7 +1048,7 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 
 		if (pdd->dev->kfd->shared_resources.enable_mes)
 			amdgpu_amdkfd_free_gtt_mem(pdd->dev->adev,
-						   pdd->proc_ctx_bo);
+						   &pdd->proc_ctx_bo);
 		/*
 		 * before destroying pdd, make sure to report availability
 		 * for auto suspend
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index a5bdc3258ae54..c97b4fc44859d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -201,9 +201,9 @@ static void pqm_clean_queue_resource(struct process_queue_manager *pqm,
 	}
 
 	if (dev->kfd->shared_resources.enable_mes) {
-		amdgpu_amdkfd_free_gtt_mem(dev->adev, pqn->q->gang_ctx_bo);
+		amdgpu_amdkfd_free_gtt_mem(dev->adev, &pqn->q->gang_ctx_bo);
 		if (pqn->q->wptr_bo)
-			amdgpu_amdkfd_free_gtt_mem(dev->adev, pqn->q->wptr_bo);
+			amdgpu_amdkfd_free_gtt_mem(dev->adev, (void **)&pqn->q->wptr_bo);
 	}
 }
 
-- 
2.43.0



