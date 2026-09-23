Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3E651DAEC;
	Wed, 23 Sep 2026 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174027; cv=none; b=KXgTbck7DVwOlWRLxgofYM8M0kBbr4CNLXzpO/139OZb5G35KFAbRW2NQJXVusG9pXvdcU4XfqXa9EDbMsJP6W8h+sDWxwKUNaJd5W6VugI7zT3sHQVuoYTQrQ98dJ0SD79mHjSVplfXtRvBjMcYZg+BJDEmt9ir6+q43GXNNV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174027; c=relaxed/simple;
	bh=LOlUMLczm3H6VKR+LB6959/Xz60KyQHarcTmzNFtIJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lq/Y7V6i4/IffBF3WSAehgLiAk7sTagb9sQjcZY9+xab7LIa2h/OpnEa62Z8MQ/hl/qIQpnWO8xDr8LVYU3Cr5QkCE8qP84hWhFZLjtCvF/CDwyLkdvdcmy41PdaNMgHXgY3AfFdkdFg1H0fRHXs/9sV6jdHIBF9Zj3udalyzKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ3SQ/F8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ3SQ/F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2773B1F000FF;
	Wed, 23 Sep 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174025;
	bh=Lx42piZz4BZb5IOXd+YEyoIzfrVaf0sNCg06rjg79ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJ3SQ/F8wL3xkn2/2ErERndKA3RiUU5R0x5IhXSzCSb721bY1UQeQb4Q5mHgI/mlV
	 tIE7IINmA7ngiq2htJUmiO7wVG3pdhIMoRFeEXKckYKUdOvWEYFSXBwvfpBhmVyYHX
	 KP7tlWtcNoShZni20A0sdkQ1cNbj+fNaDyYOUwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 412/438] drm/amdkfd: implement restore_mqd callbacks for GFX12/12.1
Date: Wed, 23 Sep 2026 16:07:13 +0200
Message-ID: <20260923140655.588022326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>

commit 5f28bb1c2cd9dcdb76a20d61b3ea069b85893c59 upstream.

kfd_mqd_manager_v12.c (GFX 12.0) and kfd_mqd_manager_v12_1.c (GFX 12.1)
do not implement restore_mqd callbacks, leaving the function pointers
NULL and causing CRIU restore to return -EOPNOTSUPP on GFX12.

Implement restore_mqd for both compute and SDMA queues in
kfd_mqd_manager_v12.c and kfd_mqd_manager_v12_1.c, modeled after the
GFX 11 implementation with the following improvements:
- update cp_mqd_base_addr_lo/hi to the newly allocated MQD address,
  fixing a pre-existing gap shared with v11 where the in-MQD copy
  still pointed at the old checkpoint-time address after restore
- memset the full allocation before memcpy for compute queues to avoid
  stale data in the GTT sub-allocator tail; SDMA MQDs use sizeof(*m)
  since they are packed at mqd_size stride in a shared BO

checkpoint_mqd registration is deferred to a follow-up patch that also
implements get_checkpoint_info, so that checkpoint and restore are
enabled together as a complete and testable unit.

Note: GFX12.1 restore handles XCC0 only. Multi-XCC CRIU restore is
currently unreachable due to a separate validation issue in
kfd_criu_restore_queue(). A pr_warn_once() is emitted if a multi-XCC
device is encountered.

Signed-off-by: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b1f9601237d050f5df478464cf51bf1fff29a256)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    7 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c      |   59 +++++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c    |   68 ++++++++++++++++++
 3 files changed, 132 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -797,10 +797,12 @@ static int create_queue_nocpsch(struct d
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
 	if (qd && !mqd_mgr->restore_mqd) {
-		pr_debug("restore_mqd not implemented for this GPU\n");
+		pr_debug("restore_mqd not implemented for queue type %d\n",
+			 q->properties.type);
 		retval = -EOPNOTSUPP;
 		goto deallocate_vmid;
 	}
+
 	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE) {
 		retval = allocate_hqd(dqm, q);
 		if (retval)
@@ -2168,7 +2170,8 @@ static int create_queue_cpsch(struct dev
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
 	if (qd && !mqd_mgr->restore_mqd) {
-		pr_debug("restore_mqd not implemented for this GPU\n");
+		pr_debug("restore_mqd not implemented for queue type %d\n",
+			 q->properties.type);
 		retval = -EOPNOTSUPP;
 		goto out_deallocate_doorbell;
 	}
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -380,6 +380,63 @@ static int debugfs_show_mqd_sdma(struct
 
 #endif
 
+static void restore_mqd(struct mqd_manager *mm, void **mqd,
+			 struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+			 struct queue_properties *qp, const void *mqd_src,
+			 const void *ctl_stack_src, const u32 ctl_stack_size)
+{
+	u64 addr;
+	struct v12_compute_mqd *m;
+
+	m = (struct v12_compute_mqd *)mqd_mem_obj->cpu_ptr;
+	addr = mqd_mem_obj->gpu_addr;
+
+	memset(m, 0, AMDGPU_MQD_SIZE_ALIGN(mm->mqd_size));
+	memcpy(m, mqd_src, sizeof(*m));
+
+	/* Update MQD base address to the newly allocated location */
+	m->cp_mqd_base_addr_lo = lower_32_bits(addr);
+	m->cp_mqd_base_addr_hi = upper_32_bits(addr);
+
+	m->cp_hqd_pq_doorbell_control &=
+		~CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_OFFSET_MASK;
+	m->cp_hqd_pq_doorbell_control |=
+		qp->doorbell_off << CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_OFFSET__SHIFT;
+	pr_debug("cp_hqd_pq_doorbell_control 0x%x\n", m->cp_hqd_pq_doorbell_control);
+
+	*mqd = m;
+	if (gart_addr)
+		*gart_addr = addr;
+
+	qp->is_active = 0;
+}
+
+static void restore_mqd_sdma(struct mqd_manager *mm, void **mqd,
+			      struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+			      struct queue_properties *qp,
+			      const void *mqd_src,
+			      const void *ctl_stack_src,
+			      const u32 ctl_stack_size)
+{
+	u64 addr;
+	struct v12_sdma_mqd *m;
+
+	m = (struct v12_sdma_mqd *)mqd_mem_obj->cpu_ptr;
+	addr = mqd_mem_obj->gpu_addr;
+
+	memset(m, 0, AMDGPU_MQD_SIZE_ALIGN(mm->mqd_size));
+	memcpy(m, mqd_src, sizeof(*m));
+
+	m->sdmax_rlcx_doorbell_offset =
+		qp->doorbell_off << SDMA0_QUEUE0_DOORBELL_OFFSET__OFFSET__SHIFT;
+
+	*mqd = m;
+	if (gart_addr)
+		*gart_addr = addr;
+
+	qp->is_active = 0;
+}
+
 struct mqd_manager *mqd_manager_init_v12(enum KFD_MQD_TYPE type,
 		struct kfd_node *dev)
 {
@@ -407,6 +464,7 @@ struct mqd_manager *mqd_manager_init_v12
 		mqd->mqd_size = sizeof(struct v12_compute_mqd);
 		mqd->get_wave_state = get_wave_state;
 		mqd->mqd_stride = kfd_mqd_stride;
+		mqd->restore_mqd = restore_mqd;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd;
 #endif
@@ -453,6 +511,7 @@ struct mqd_manager *mqd_manager_init_v12
 		mqd->is_occupied = kfd_is_occupied_sdma;
 		mqd->mqd_size = sizeof(struct v12_sdma_mqd);
 		mqd->mqd_stride = kfd_mqd_stride;
+		mqd->restore_mqd = restore_mqd_sdma;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd_sdma;
 #endif
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
@@ -641,6 +641,72 @@ static int debugfs_show_mqd_sdma(struct
 
 #endif
 
+static void restore_mqd_v12_1(struct mqd_manager *mm, void **mqd,
+			       struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+			       struct queue_properties *qp, const void *mqd_src,
+			       const void *ctl_stack_src, const u32 ctl_stack_size)
+{
+	u64 addr;
+	struct v12_1_compute_mqd *m;
+
+	/*
+	 * GFX12.1 is multi-XCC capable but this restore handles XCC0 only.
+	 * Multi-XCC CRIU restore is currently unreachable because
+	 * kfd_criu_restore_queue() validates against unscaled mqd_size.
+	 */
+	if (NUM_XCC(mm->dev->xcc_mask) > 1)
+		pr_warn_once("GFX12.1 multi-XCC CRIU restore not fully supported\n");
+
+	m = (struct v12_1_compute_mqd *)mqd_mem_obj->cpu_ptr;
+	addr = mqd_mem_obj->gpu_addr;
+
+	memset(m, 0, AMDGPU_MQD_SIZE_ALIGN(mm->mqd_size) *
+		     NUM_XCC(mm->dev->xcc_mask));
+	memcpy(m, mqd_src, sizeof(*m));
+
+	/* Update MQD base address to the newly allocated location */
+	m->cp_mqd_base_addr_lo = lower_32_bits(addr);
+	m->cp_mqd_base_addr_hi = upper_32_bits(addr);
+
+	m->cp_hqd_pq_doorbell_control &=
+		~CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_OFFSET_MASK;
+	m->cp_hqd_pq_doorbell_control |=
+		qp->doorbell_off << CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_OFFSET__SHIFT;
+	pr_debug("cp_hqd_pq_doorbell_control 0x%x\n", m->cp_hqd_pq_doorbell_control);
+
+	*mqd = m;
+	if (gart_addr)
+		*gart_addr = addr;
+
+	qp->is_active = 0;
+}
+
+static void restore_mqd_sdma_v12_1(struct mqd_manager *mm, void **mqd,
+				    struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+				    struct queue_properties *qp,
+				    const void *mqd_src,
+				    const void *ctl_stack_src,
+				    const u32 ctl_stack_size)
+{
+	u64 addr;
+	struct v12_sdma_mqd *m;
+
+	m = (struct v12_sdma_mqd *)mqd_mem_obj->cpu_ptr;
+	addr = mqd_mem_obj->gpu_addr;
+
+	memset(m, 0, AMDGPU_MQD_SIZE_ALIGN(mm->mqd_size));
+	memcpy(m, mqd_src, sizeof(*m));
+
+	m->sdmax_rlcx_doorbell_offset =
+		qp->doorbell_off << SDMA0_SDMA_QUEUE0_DOORBELL_OFFSET__OFFSET__SHIFT;
+
+	*mqd = m;
+	if (gart_addr)
+		*gart_addr = addr;
+
+	qp->is_active = 0;
+}
+
 struct mqd_manager *mqd_manager_init_v12_1(enum KFD_MQD_TYPE type,
 		struct kfd_node *dev)
 {
@@ -668,6 +734,7 @@ struct mqd_manager *mqd_manager_init_v12
 		mqd->mqd_size = sizeof(struct v12_1_compute_mqd);
 		mqd->get_wave_state = get_wave_state_v12_1;
 		mqd->mqd_stride = kfd_mqd_stride;
+		mqd->restore_mqd = restore_mqd_v12_1;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd;
 #endif
@@ -714,6 +781,7 @@ struct mqd_manager *mqd_manager_init_v12
 		mqd->is_occupied = kfd_is_occupied_sdma;
 		mqd->mqd_size = sizeof(struct v12_sdma_mqd);
 		mqd->mqd_stride = kfd_mqd_stride;
+		mqd->restore_mqd = restore_mqd_sdma_v12_1;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd_sdma;
 #endif


