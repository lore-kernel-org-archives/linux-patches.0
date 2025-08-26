Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7579B239573;
	Tue, 26 Aug 2025 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207530; cv=none; b=Rz5prbO7cbAPXbUhoXHi8m3pHV29jb4J+wShs/NnhILYXlZqZzzDEfXl25GOnbsmGtNNg4MiXOenPPvcgot3rCTV5cdmljNZNGLz7N/TLd+nfwY9U8QtsDPqsCkrl/Op2O45T5WJD1AdA2kLgioC08EdYQft/Po2dYCCvJpX6Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207530; c=relaxed/simple;
	bh=jeKgRXRa01X5lTfIM/CSlwpJFJLsw86xE3g7MRQpMeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP/d7TGpwR5cRsLXCI9l99nAb9XeY2OFQQq64c5wJbXy1wI4hpdQLVIC9RwRxJQ7kC0Gc9eeCfmfxQNbWh/PIQcT8qYeSp8PQOcCbaqvpm2dxxHTupKKxxlUSgHmaAxf37M/HsZ/S5CZw3f8orHPaZ9qjb7XMvjCmAsPdywVASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgPFUDVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgPFUDVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09462C4CEF1;
	Tue, 26 Aug 2025 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207530;
	bh=jeKgRXRa01X5lTfIM/CSlwpJFJLsw86xE3g7MRQpMeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgPFUDVFXPoQyMfGiNaRrPVfI6STwpj+72w2zSigZwv/lybCBLXdADBPxu3P+ZTmN
	 IQNrt7xNKDouVmZmrJZXbrNKL0zhQi9aweHjPQgYwijJVxDqTFSov9kSsHoPryEA7S
	 w8Ym3DfjnDA19PSi6KZgfm9Z1mhW03/7YJsfw/O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <David.YatSin@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 186/457] drm/amdkfd: Fix checkpoint-restore on multi-xcc
Date: Tue, 26 Aug 2025 13:07:50 +0200
Message-ID: <20250826110941.968684699@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yat Sin <David.YatSin@amd.com>

commit f6c0f3d24478a0792e50a64c2eba9f34d65519f2 upstream.

GPUs with multi-xcc have multiple MQDs per queue. This patch saves and
restores all the MQDs within the partition.

Signed-off-by: David Yat Sin <David.YatSin@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a578f2a58c3ab38f0643b1b6e7534af860233cb1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c        |   61 ++++++++++++++---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   20 ++++-
 3 files changed, 67 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2716,7 +2716,7 @@ static void get_queue_checkpoint_info(st
 
 	dqm_lock(dqm);
 	mqd_mgr = dqm->mqd_mgrs[mqd_type];
-	*mqd_size = mqd_mgr->mqd_size;
+	*mqd_size = mqd_mgr->mqd_size * NUM_XCC(mqd_mgr->dev->xcc_mask);
 	*ctl_stack_size = 0;
 
 	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE && mqd_mgr->get_checkpoint_info)
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -373,7 +373,7 @@ static void get_checkpoint_info(struct m
 {
 	struct v9_mqd *m = get_mqd(mqd);
 
-	*ctl_stack_size = m->cp_hqd_cntl_stack_size;
+	*ctl_stack_size = m->cp_hqd_cntl_stack_size * NUM_XCC(mm->dev->xcc_mask);
 }
 
 static void checkpoint_mqd(struct mqd_manager *mm, void *mqd, void *mqd_dst, void *ctl_stack_dst)
@@ -388,6 +388,24 @@ static void checkpoint_mqd(struct mqd_ma
 	memcpy(ctl_stack_dst, ctl_stack, m->cp_hqd_cntl_stack_size);
 }
 
+static void checkpoint_mqd_v9_4_3(struct mqd_manager *mm,
+								  void *mqd,
+								  void *mqd_dst,
+								  void *ctl_stack_dst)
+{
+	struct v9_mqd *m;
+	int xcc;
+	uint64_t size = get_mqd(mqd)->cp_mqd_stride_size;
+
+	for (xcc = 0; xcc < NUM_XCC(mm->dev->xcc_mask); xcc++) {
+		m = get_mqd(mqd + size * xcc);
+
+		checkpoint_mqd(mm, m,
+				(uint8_t *)mqd_dst + sizeof(*m) * xcc,
+				(uint8_t *)ctl_stack_dst + m->cp_hqd_cntl_stack_size * xcc);
+	}
+}
+
 static void restore_mqd(struct mqd_manager *mm, void **mqd,
 			struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
 			struct queue_properties *qp,
@@ -764,13 +782,35 @@ static void restore_mqd_v9_4_3(struct mq
 			const void *mqd_src,
 			const void *ctl_stack_src, u32 ctl_stack_size)
 {
-	restore_mqd(mm, mqd, mqd_mem_obj, gart_addr, qp, mqd_src, ctl_stack_src, ctl_stack_size);
-	if (amdgpu_sriov_multi_vf_mode(mm->dev->adev)) {
-		struct v9_mqd *m;
+	struct kfd_mem_obj xcc_mqd_mem_obj;
+	u32 mqd_ctl_stack_size;
+	struct v9_mqd *m;
+	u32 num_xcc;
+	int xcc;
 
-		m = (struct v9_mqd *) mqd_mem_obj->cpu_ptr;
-		m->cp_hqd_pq_doorbell_control |= 1 <<
-				CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_MODE__SHIFT;
+	uint64_t offset = mm->mqd_stride(mm, qp);
+
+	mm->dev->dqm->current_logical_xcc_start++;
+
+	num_xcc = NUM_XCC(mm->dev->xcc_mask);
+	mqd_ctl_stack_size = ctl_stack_size / num_xcc;
+
+	memset(&xcc_mqd_mem_obj, 0x0, sizeof(struct kfd_mem_obj));
+
+	/* Set the MQD pointer and gart address to XCC0 MQD */
+	*mqd = mqd_mem_obj->cpu_ptr;
+	if (gart_addr)
+		*gart_addr = mqd_mem_obj->gpu_addr;
+
+	for (xcc = 0; xcc < num_xcc; xcc++) {
+		get_xcc_mqd(mqd_mem_obj, &xcc_mqd_mem_obj, offset * xcc);
+		restore_mqd(mm, (void **)&m,
+					&xcc_mqd_mem_obj,
+					NULL,
+					qp,
+					(uint8_t *)mqd_src + xcc * sizeof(*m),
+					(uint8_t *)ctl_stack_src + xcc *  mqd_ctl_stack_size,
+					mqd_ctl_stack_size);
 	}
 }
 static int destroy_mqd_v9_4_3(struct mqd_manager *mm, void *mqd,
@@ -906,7 +946,6 @@ struct mqd_manager *mqd_manager_init_v9(
 		mqd->free_mqd = kfd_free_mqd_cp;
 		mqd->is_occupied = kfd_is_occupied_cp;
 		mqd->get_checkpoint_info = get_checkpoint_info;
-		mqd->checkpoint_mqd = checkpoint_mqd;
 		mqd->mqd_size = sizeof(struct v9_mqd);
 		mqd->mqd_stride = mqd_stride_v9;
 #if defined(CONFIG_DEBUG_FS)
@@ -918,16 +957,18 @@ struct mqd_manager *mqd_manager_init_v9(
 			mqd->init_mqd = init_mqd_v9_4_3;
 			mqd->load_mqd = load_mqd_v9_4_3;
 			mqd->update_mqd = update_mqd_v9_4_3;
-			mqd->restore_mqd = restore_mqd_v9_4_3;
 			mqd->destroy_mqd = destroy_mqd_v9_4_3;
 			mqd->get_wave_state = get_wave_state_v9_4_3;
+			mqd->checkpoint_mqd = checkpoint_mqd_v9_4_3;
+			mqd->restore_mqd = restore_mqd_v9_4_3;
 		} else {
 			mqd->init_mqd = init_mqd;
 			mqd->load_mqd = load_mqd;
 			mqd->update_mqd = update_mqd;
-			mqd->restore_mqd = restore_mqd;
 			mqd->destroy_mqd = kfd_destroy_mqd_cp;
 			mqd->get_wave_state = get_wave_state;
+			mqd->checkpoint_mqd = checkpoint_mqd;
+			mqd->restore_mqd = restore_mqd;
 		}
 		break;
 	case KFD_MQD_TYPE_HIQ:
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -914,7 +914,10 @@ static int criu_checkpoint_queues_device
 
 		q_data = (struct kfd_criu_queue_priv_data *)q_private_data;
 
-		/* data stored in this order: priv_data, mqd, ctl_stack */
+		/*
+		 * data stored in this order:
+		 * priv_data, mqd[xcc0], mqd[xcc1],..., ctl_stack[xcc0], ctl_stack[xcc1]...
+		 */
 		q_data->mqd_size = mqd_size;
 		q_data->ctl_stack_size = ctl_stack_size;
 
@@ -963,7 +966,7 @@ int kfd_criu_checkpoint_queues(struct kf
 }
 
 static void set_queue_properties_from_criu(struct queue_properties *qp,
-					  struct kfd_criu_queue_priv_data *q_data)
+					  struct kfd_criu_queue_priv_data *q_data, uint32_t num_xcc)
 {
 	qp->is_interop = false;
 	qp->queue_percent = q_data->q_percent;
@@ -976,7 +979,11 @@ static void set_queue_properties_from_cr
 	qp->eop_ring_buffer_size = q_data->eop_ring_buffer_size;
 	qp->ctx_save_restore_area_address = q_data->ctx_save_restore_area_address;
 	qp->ctx_save_restore_area_size = q_data->ctx_save_restore_area_size;
-	qp->ctl_stack_size = q_data->ctl_stack_size;
+	if (q_data->type == KFD_QUEUE_TYPE_COMPUTE)
+		qp->ctl_stack_size = q_data->ctl_stack_size / num_xcc;
+	else
+		qp->ctl_stack_size = q_data->ctl_stack_size;
+
 	qp->type = q_data->type;
 	qp->format = q_data->format;
 }
@@ -1036,12 +1043,15 @@ int kfd_criu_restore_queue(struct kfd_pr
 		goto exit;
 	}
 
-	/* data stored in this order: mqd, ctl_stack */
+	/*
+	 * data stored in this order:
+	 * mqd[xcc0], mqd[xcc1],..., ctl_stack[xcc0], ctl_stack[xcc1]...
+	 */
 	mqd = q_extra_data;
 	ctl_stack = mqd + q_data->mqd_size;
 
 	memset(&qp, 0, sizeof(qp));
-	set_queue_properties_from_criu(&qp, q_data);
+	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->adev->gfx.xcc_mask));
 
 	print_queue_properties(&qp);
 


