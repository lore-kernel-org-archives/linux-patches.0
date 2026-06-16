Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DAE44CAF5;
	Tue, 16 Jun 2026 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626388; cv=none; b=tzJS2DPBX8FGXUDz5SAGyof5JkVa6skeeIy+RdK6H1p8BJBeKr8C9HfsYZ3wfRUg2QbXHy9eNqswaTULYaa/MJ0aLJh7d1oVWt8eZIJnf8/ZyLYKIpRNS5sB/NdNt1DMteScvMcmR4FQmSydna9+CeFbw6QVAxsoGmbV5j7YQ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626388; c=relaxed/simple;
	bh=17FBKuKtAlOk6l2TuFyk0G9UtBaVuVG1y5XORlRV4DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qbxs7zBbHev+tzszUVB0yurc0doNIeyAUfPXYSu42XDSGETpgOOdGg7QgZOPoS5+HW0DivkuYfAjnBaerLpA52Fcq2gQFghwYnECKZ9JOAG+1pwCJxAGiL/1e8/P6S1ZESsFQaE31JXR6EKA4GxeQQ4DIaVc9N631TaT74UzGLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytcTQHj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytcTQHj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FB41F000E9;
	Tue, 16 Jun 2026 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626387;
	bh=OauDdvesdxsRGltZvTHaNTw7Ue8RUBeA9NA4BsqWEj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytcTQHj1JiAfP4A3wajWX2YAszvqWeCBUzTEYmjVb3jQlmd4M2E58yJl0ByrNs5w6
	 eB1GY0gyjnV6QWNjcy5wtIkwQaj5QkIv6+QLqY2ea9hfWCCeRSNRLq+nROQPsq6R/P
	 IiYDID2YM84g7YTQqBAwcM4V7A5w/FeOcaxzBucM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <andrew.martin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 284/325] drm/amdkfd: Fix buffer overflow in SDMA queue checkpoint/restore on GFX11
Date: Tue, 16 Jun 2026 20:31:20 +0530
Message-ID: <20260616145112.891041026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Martin <andrew.martin@amd.com>

commit 352ea59028ea48a6fff77f19ae28f98f71946a80 upstream.

The v11 MQD manager incorrectly assigned the CP-compute variants of
checkpoint_mqd/restore_mqd for KFD_MQD_TYPE_SDMA queues. These functions
use sizeof(struct v11_compute_mqd) (2048 bytes) instead of sizeof(struct
v11_sdma_mqd) (512 bytes), causing a 1536-byte overflow.

During CRIU checkpoint of an SDMA queue on Navi3x:
- checkpoint_mqd() reads 2048 bytes from a 512-byte SDMA MQD buffer,
  leaking 1536 bytes of adjacent GTT memory to userspace

During CRIU restore:
- restore_mqd() writes 2048 bytes into a 512-byte SDMA MQD buffer,
  corrupting 1536 bytes of adjacent GTT memory (often the ring buffer
  or neighboring MQDs)

This is a copy-paste regression unique to v11. All other ASIC backends
(cik, vi, v9, v10, v12) correctly use the SDMA-specific variants.

Add checkpoint_mqd_sdma() and restore_mqd_sdma() functions that properly
handle the smaller v11_sdma_mqd structure, matching the pattern used in
other MQD managers.

Fixes: cc009e613de6 ("drm/amdkfd: Add KFD support for soc21 v3")
Assisted-by: Claude:Sonnet 4-5
Signed-off-by: Andrew Martin <andrew.martin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6fa41db7ffdec97d62433adf03b7b9b759af8c2c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c |   49 +++++++++++++++++++----
 1 file changed, 41 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -334,8 +334,7 @@ static void checkpoint_mqd(struct mqd_ma
 
 static void restore_mqd(struct mqd_manager *mm, void **mqd,
 			struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
-			struct queue_properties *qp,
-			const void *mqd_src,
+			struct queue_properties *qp, const void *mqd_src,
 			const void *ctl_stack_src, const u32 ctl_stack_size)
 {
 	uint64_t addr;
@@ -351,14 +350,48 @@ static void restore_mqd(struct mqd_manag
 		*gart_addr = addr;
 
 	m->cp_hqd_pq_doorbell_control =
-		qp->doorbell_off <<
-			CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_OFFSET__SHIFT;
-	pr_debug("cp_hqd_pq_doorbell_control 0x%x\n",
-			m->cp_hqd_pq_doorbell_control);
+		qp->doorbell_off << CP_HQD_PQ_DOORBELL_CONTROL__DOORBELL_OFFSET__SHIFT;
+	pr_debug("cp_hqd_pq_doorbell_control 0x%x\n", m->cp_hqd_pq_doorbell_control);
 
 	qp->is_active = 0;
 }
 
+static void checkpoint_mqd_sdma(struct mqd_manager *mm,
+				void *mqd,
+				void *mqd_dst,
+				void *ctl_stack_dst)
+{
+	struct v11_sdma_mqd *m;
+
+	m = get_sdma_mqd(mqd);
+
+	memcpy(mqd_dst, m, sizeof(struct v11_sdma_mqd));
+}
+
+static void restore_mqd_sdma(struct mqd_manager *mm, void **mqd,
+			     struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
+			     struct queue_properties *qp,
+			     const void *mqd_src,
+			     const void *ctl_stack_src,
+			     const u32 ctl_stack_size)
+{
+	uint64_t addr;
+	struct v11_sdma_mqd *m;
+
+	m = (struct v11_sdma_mqd *) mqd_mem_obj->cpu_ptr;
+	addr = mqd_mem_obj->gpu_addr;
+
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
 
 static void init_mqd_hiq(struct mqd_manager *mm, void **mqd,
 			struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
@@ -543,8 +576,8 @@ struct mqd_manager *mqd_manager_init_v11
 		mqd->update_mqd = update_mqd_sdma;
 		mqd->destroy_mqd = kfd_destroy_mqd_sdma;
 		mqd->is_occupied = kfd_is_occupied_sdma;
-		mqd->checkpoint_mqd = checkpoint_mqd;
-		mqd->restore_mqd = restore_mqd;
+		mqd->checkpoint_mqd = checkpoint_mqd_sdma;
+		mqd->restore_mqd = restore_mqd_sdma;
 		mqd->mqd_size = sizeof(struct v11_sdma_mqd);
 		mqd->mqd_stride = kfd_mqd_stride;
 #if defined(CONFIG_DEBUG_FS)


