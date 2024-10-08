Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB01D54D1;
	Tue,  8 Oct 2024 12:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391831; cv=none; b=UWHYrPdsVlkPNOUxAHpA0gJCBK8vzLEVnhhWekbKbQwpqo0Uq8DrTu1wDXuO8jjFAjgKJh8qSdvzDTy3HBOOCoKonTYB7VxP+PiAmyHfZuBlyYuaXLm7Q2ZmGUrI1+Qop7SDSznrScTG4zkoOZgdXbnabl/dxgT7d1nls9EMEXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391831; c=relaxed/simple;
	bh=66ABoS6fM6PjsE66djZZxWVfzl0Kv+Ak6QnkcwO7sJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuCF5p1oQZ32lxyc207p/nBBbEK/EQKZ0aJUJHpj3JyF8OZrok/YYetIE3Ctpz1Y5Ec8ck0lcbAsCa4FtSMgQSx2O5sGDmTgI+mNCHoodFstOik003XuFMYrLYIj631dgS869RqjTi9xEbBOuFMB5gjDtYswYM2EjtCGJ4fFHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZI1ziMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZI1ziMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20290C4CEC7;
	Tue,  8 Oct 2024 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391831;
	bh=66ABoS6fM6PjsE66djZZxWVfzl0Kv+Ak6QnkcwO7sJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZI1ziMO32xejcRSLUwXrE03ja7iQbG7/dVhnEDN+M9wJQAKZ7iTkTmgNpzK46ttV
	 QAysPAJnA322MWWo1Q8wuEama6nQHfpXxCT/TNpwlVdKUZhz5Vo4InLxqc5qChkCyV
	 hg7d7328ZA2hWiZRVXJdKsWC+te1yq0/3Pdw/7FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 208/558] drm/amdkfd: amdkfd_free_gtt_mem clear the correct pointer
Date: Tue,  8 Oct 2024 14:03:58 +0200
Message-ID: <20241008115710.528594001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 03205e3c37463..c272461d70a9a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -364,15 +364,15 @@ int amdgpu_amdkfd_alloc_gtt_mem(struct amdgpu_device *adev, size_t size,
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
index e7bb1ca358014..8b4108a23636a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -235,7 +235,7 @@ int amdgpu_amdkfd_bo_validate_and_fence(struct amdgpu_bo *bo,
 int amdgpu_amdkfd_alloc_gtt_mem(struct amdgpu_device *adev, size_t size,
 				void **mem_obj, uint64_t *gpu_addr,
 				void **cpu_ptr, bool mqd_gfx9);
-void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void *mem_obj);
+void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void **mem_obj);
 int amdgpu_amdkfd_alloc_gws(struct amdgpu_device *adev, size_t size,
 				void **mem_obj);
 void amdgpu_amdkfd_free_gws(struct amdgpu_device *adev, void *mem_obj);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 32e5db509560e..546b02f2241a6 100644
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
index f4d20adaa0689..6619028dd58ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -907,7 +907,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 kfd_doorbell_error:
 	kfd_gtt_sa_fini(kfd);
 kfd_gtt_sa_init_error:
-	amdgpu_amdkfd_free_gtt_mem(kfd->adev, kfd->gtt_mem);
+	amdgpu_amdkfd_free_gtt_mem(kfd->adev, &kfd->gtt_mem);
 alloc_gtt_mem_failure:
 	dev_err(kfd_device,
 		"device %x:%x NOT added due to errors\n",
@@ -925,7 +925,7 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 		kfd_doorbell_fini(kfd);
 		ida_destroy(&kfd->doorbell_ida);
 		kfd_gtt_sa_fini(kfd);
-		amdgpu_amdkfd_free_gtt_mem(kfd->adev, kfd->gtt_mem);
+		amdgpu_amdkfd_free_gtt_mem(kfd->adev, &kfd->gtt_mem);
 	}
 
 	kfree(kfd);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4f48507418d2f..420444eb8e982 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2621,7 +2621,7 @@ static void deallocate_hiq_sdma_mqd(struct kfd_node *dev,
 {
 	WARN(!mqd, "No hiq sdma mqd trunk to free");
 
-	amdgpu_amdkfd_free_gtt_mem(dev->adev, mqd->gtt_mem);
+	amdgpu_amdkfd_free_gtt_mem(dev->adev, &mqd->gtt_mem);
 }
 
 void device_queue_manager_uninit(struct device_queue_manager *dqm)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
index 50a81da43ce19..d9ae854b69084 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
@@ -225,7 +225,7 @@ void kfd_free_mqd_cp(struct mqd_manager *mm, void *mqd,
 	      struct kfd_mem_obj *mqd_mem_obj)
 {
 	if (mqd_mem_obj->gtt_mem) {
-		amdgpu_amdkfd_free_gtt_mem(mm->dev->adev, mqd_mem_obj->gtt_mem);
+		amdgpu_amdkfd_free_gtt_mem(mm->dev->adev, &mqd_mem_obj->gtt_mem);
 		kfree(mqd_mem_obj);
 	} else {
 		kfd_gtt_sa_free(mm->dev, mqd_mem_obj);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 17e42161b0151..9e29b92eb523d 100644
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
index 21f5a1fb3bf88..36f0460cbffe6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -204,9 +204,9 @@ static void pqm_clean_queue_resource(struct process_queue_manager *pqm,
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



