Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF445107D;
	Tue, 16 Jun 2026 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624526; cv=none; b=MU3MMIgV4TjR3K6dGxHitGkwceZy4ZUF3zaBb4r5k7NBElObH8LTE+cMf+9krBBxAaVKOZDPsbnd1FFwWe448nXzrkAagASNxfzRhZH1+D9GvKVP/JFHuQ/EjYE49ySS6u2ajK48Pmt2gDXzOTujEEj1aU/Rea4bXhZyAVxxuWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624526; c=relaxed/simple;
	bh=2UwTMCcefVmsKnU9uryUbQIZK3Kv/twe3OvpKn1K/6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5hGbIwXBsbc79CK2/JyGl5WP0nl+MdUNMA7L8qWrXRqL7qyDMhcd7z3kSNXi0yYEdOGkf5NgTO8Pm8L3FMMiqVMj69IbTAxBPfECAzNVzIth8t/KYBaZtJsrK4x1WsuwAugy/TC6cClu+9/G3YWS7kzOhwTihMRfsh52cF+TC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wniR7lM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wniR7lM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4B61F000E9;
	Tue, 16 Jun 2026 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624524;
	bh=AqxbF55NUW6arnm5/OkxLiMsck4cmKH3KgTHOB/ZHpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wniR7lM5GUHgx7h7wRjVCdf0UaKHOkdDaOXQMNqWiJ5ZX0Kv5qNrsBnVbU7aKxqyB
	 P/jY0HD7ZRl59DtaGcbP5mBm0+vpfKr0UlsvCUns4SbhT2/dwCUSyOauWqIL6c+nU8
	 v29gyrBrnjrqPxPNKQ2aTzPisOOXfv8zaS2YPdRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <andrew.martin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 336/378] drm/amdkfd: Fix buffer overflow in SDMA queue checkpoint/restore on GFX11
Date: Tue, 16 Jun 2026 20:29:27 +0530
Message-ID: <20260616145127.900277952@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,8 +320,7 @@ static void checkpoint_mqd(struct mqd_ma
 
 static void restore_mqd(struct mqd_manager *mm, void **mqd,
 			struct kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
-			struct queue_properties *qp,
-			const void *mqd_src,
+			struct queue_properties *qp, const void *mqd_src,
 			const void *ctl_stack_src, const u32 ctl_stack_size)
 {
 	uint64_t addr;
@@ -337,14 +336,48 @@ static void restore_mqd(struct mqd_manag
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
@@ -529,8 +562,8 @@ struct mqd_manager *mqd_manager_init_v11
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


