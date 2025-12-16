Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC0F34D3BF;
	Tue, 16 Dec 2025 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885338; cv=none; b=e7XnlkXQKpqS0gav9PxnzkRGvuymDkPFZB/6Opka6n4HMWm1stnkPTBOFV74rxmqC+OU9iHNkad/VEjYOJQhLFLLYj1CignJS7diZeuAzMz5md8bTU9H/vcZn9zh0K/2RDO+K28eX4DC9qubR3Kfr7vBBvjWYSXYOMtJvPB7wx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885338; c=relaxed/simple;
	bh=nD5jOU6hX2SjA0QzMFSfANHvBrkFtGbTcRARFyclmTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K71Mww6MhhV+L6P3fA7B+TQmE8WFsh66Z0jDp5PwCvk86jU+KIaQpk8i/8I8E9oxjts+XJLJC7gwnexmCaxk8kToTN8PuDbSV6I6MlyVvhcJwm6GRqozlc3cdfRdpX2WL/5iz2kxxIZqLpPanZrpsFmoV5hhvBONApjZjowlosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHogBx2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHogBx2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E58FC4CEF5;
	Tue, 16 Dec 2025 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885338;
	bh=nD5jOU6hX2SjA0QzMFSfANHvBrkFtGbTcRARFyclmTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHogBx2YxNv5ie9VqZKf/KIZEkg/Ma2xfwRiehsjKeKCPBVOdxMJudEguEbWA+g7K
	 tDArpd0Tsp8573AArDLbQEzLezoZmV6f4i+kVYmGS0NjeD6+u5Np2O0G/BPJSbFmxY
	 GDgziywIqpiUOBEjFOuWrO7lBUe3YJdDm39pMWS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 110/507] drm/amdgpu: add userq object va track helpers
Date: Tue, 16 Dec 2025 12:09:11 +0100
Message-ID: <20251216111349.521140280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 5cfa33fabf01f2cc0af6b1feed6e65cb81806a37 ]

Add the userq object virtual address list_add() helpers
for tracking the userq obj va address usage.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a0559012a18a ("drm/amdgpu/userq: fix SDMA and compute validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c  | 44 ++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h  | 12 ++++--
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c | 16 ++++----
 4 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
index c316920f34509..1e1ee4a0cd0d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
@@ -96,6 +96,7 @@ struct amdgpu_bo_va {
 	 * if non-zero, cannot unmap from GPU because user queues may still access it
 	 */
 	unsigned int			queue_refcount;
+	atomic_t			userq_va_mapped;
 };
 
 struct amdgpu_bo {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index a0fb13172e8b4..0b9269aaabde5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -44,10 +44,29 @@ u32 amdgpu_userq_get_supported_ip_mask(struct amdgpu_device *adev)
 	return userq_ip_mask;
 }
 
-int amdgpu_userq_input_va_validate(struct amdgpu_vm *vm, u64 addr,
-				   u64 expected_size)
+static int amdgpu_userq_buffer_va_list_add(struct amdgpu_usermode_queue *queue,
+					   struct amdgpu_bo_va_mapping *va_map, u64 addr)
+{
+	struct amdgpu_userq_va_cursor *va_cursor;
+	struct userq_va_list;
+
+	va_cursor = kzalloc(sizeof(*va_cursor), GFP_KERNEL);
+	if (!va_cursor)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&va_cursor->list);
+	va_cursor->gpu_addr = addr;
+	atomic_set(&va_map->bo_va->userq_va_mapped, 1);
+	list_add(&va_cursor->list, &queue->userq_va_list);
+
+	return 0;
+}
+
+int amdgpu_userq_input_va_validate(struct amdgpu_usermode_queue *queue,
+				   u64 addr, u64 expected_size)
 {
 	struct amdgpu_bo_va_mapping *va_map;
+	struct amdgpu_vm *vm = queue->vm;
 	u64 user_addr;
 	u64 size;
 	int r = 0;
@@ -67,6 +86,7 @@ int amdgpu_userq_input_va_validate(struct amdgpu_vm *vm, u64 addr,
 	/* Only validate the userq whether resident in the VM mapping range */
 	if (user_addr >= va_map->start  &&
 	    va_map->last - user_addr + 1 >= size) {
+		amdgpu_userq_buffer_va_list_add(queue, va_map, user_addr);
 		amdgpu_bo_unreserve(vm->root.bo);
 		return 0;
 	}
@@ -142,6 +162,7 @@ amdgpu_userq_cleanup(struct amdgpu_userq_mgr *uq_mgr,
 	uq_funcs->mqd_destroy(uq_mgr, queue);
 	amdgpu_userq_fence_driver_free(queue);
 	idr_remove(&uq_mgr->userq_idr, queue_id);
+	list_del(&queue->userq_va_list);
 	kfree(queue);
 }
 
@@ -473,14 +494,7 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 		goto unlock;
 	}
 
-	/* Validate the userq virtual address.*/
-	if (amdgpu_userq_input_va_validate(&fpriv->vm, args->in.queue_va, args->in.queue_size) ||
-	    amdgpu_userq_input_va_validate(&fpriv->vm, args->in.rptr_va, AMDGPU_GPU_PAGE_SIZE) ||
-	    amdgpu_userq_input_va_validate(&fpriv->vm, args->in.wptr_va, AMDGPU_GPU_PAGE_SIZE)) {
-		r = -EINVAL;
-		kfree(queue);
-		goto unlock;
-	}
+	INIT_LIST_HEAD(&queue->userq_va_list);
 	queue->doorbell_handle = args->in.doorbell_handle;
 	queue->queue_type = args->in.ip_type;
 	queue->vm = &fpriv->vm;
@@ -491,6 +505,15 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 	db_info.db_obj = &queue->db_obj;
 	db_info.doorbell_offset = args->in.doorbell_offset;
 
+	/* Validate the userq virtual address.*/
+	if (amdgpu_userq_input_va_validate(queue, args->in.queue_va, args->in.queue_size) ||
+	    amdgpu_userq_input_va_validate(queue, args->in.rptr_va, AMDGPU_GPU_PAGE_SIZE) ||
+	    amdgpu_userq_input_va_validate(queue, args->in.wptr_va, AMDGPU_GPU_PAGE_SIZE)) {
+		r = -EINVAL;
+		kfree(queue);
+		goto unlock;
+	}
+
 	/* Convert relative doorbell offset into absolute doorbell index */
 	index = amdgpu_userq_get_doorbell_index(uq_mgr, &db_info, filp);
 	if (index == (uint64_t)-EINVAL) {
@@ -516,7 +539,6 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 		goto unlock;
 	}
 
-
 	qid = idr_alloc(&uq_mgr->userq_idr, queue, 1, AMDGPU_MAX_USERQ_COUNT, GFP_KERNEL);
 	if (qid < 0) {
 		drm_file_err(uq_mgr->file, "Failed to allocate a queue id\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
index 8603c31320f11..17ac12893ef9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.h
@@ -47,6 +47,11 @@ struct amdgpu_userq_obj {
 	struct amdgpu_bo *obj;
 };
 
+struct amdgpu_userq_va_cursor {
+	u64			gpu_addr;
+	struct list_head	list;
+};
+
 struct amdgpu_usermode_queue {
 	int			queue_type;
 	enum amdgpu_userq_state state;
@@ -66,6 +71,8 @@ struct amdgpu_usermode_queue {
 	u32			xcp_id;
 	int			priority;
 	struct dentry		*debugfs_queue;
+
+	struct list_head	userq_va_list;
 };
 
 struct amdgpu_userq_funcs {
@@ -132,7 +139,6 @@ int amdgpu_userq_stop_sched_for_enforce_isolation(struct amdgpu_device *adev,
 						  u32 idx);
 int amdgpu_userq_start_sched_for_enforce_isolation(struct amdgpu_device *adev,
 						   u32 idx);
-
-int amdgpu_userq_input_va_validate(struct amdgpu_vm *vm, u64 addr,
-				   u64 expected_size);
+int amdgpu_userq_input_va_validate(struct amdgpu_usermode_queue *queue,
+				   u64 addr, u64 expected_size);
 #endif
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
index ef54d211214f4..00dd5f37f4374 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -250,8 +250,9 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 			goto free_mqd;
 		}
 
-		if (amdgpu_userq_input_va_validate(queue->vm, compute_mqd->eop_va,
-		    max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE)))
+		r = amdgpu_userq_input_va_validate(queue, compute_mqd->eop_va,
+						   max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE));
+		if (r)
 			goto free_mqd;
 
 		userq_props->eop_gpu_addr = compute_mqd->eop_va;
@@ -282,8 +283,9 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 		userq_props->tmz_queue =
 			mqd_user->flags & AMDGPU_USERQ_CREATE_FLAGS_QUEUE_SECURE;
 
-		if (amdgpu_userq_input_va_validate(queue->vm, mqd_gfx_v11->shadow_va,
-		    shadow_info.shadow_size))
+		r = amdgpu_userq_input_va_validate(queue, mqd_gfx_v11->shadow_va,
+						   shadow_info.shadow_size);
+		if (r)
 			goto free_mqd;
 
 		kfree(mqd_gfx_v11);
@@ -302,9 +304,9 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 			r = -ENOMEM;
 			goto free_mqd;
 		}
-
-		if (amdgpu_userq_input_va_validate(queue->vm, mqd_sdma_v11->csa_va,
-		    shadow_info.csa_size))
+		r = amdgpu_userq_input_va_validate(queue, mqd_sdma_v11->csa_va,
+						   shadow_info.csa_size);
+		if (r)
 			goto free_mqd;
 
 		userq_props->csa_addr = mqd_sdma_v11->csa_va;
-- 
2.51.0



