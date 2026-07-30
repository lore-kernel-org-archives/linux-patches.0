Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8D443B6D1;
	Thu, 30 Jul 2026 14:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422410; cv=none; b=mJTEkMbzZMqT1Tx68Dv7yvD0KnHtQnmLKjwZgmjrvtsXSaPAMFRE670ZiUScL3gd0pWScTlGgCee55DKQk7dYtFSCq2SGaDOD5jgaqi5Ys+PsYydr88cxMFAS0zzhTz9aXpJqqAeThW8XVvAg3G6mGN1WpPpr2X/500MjxSRQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422410; c=relaxed/simple;
	bh=brJNUYj+lJrBci4mAXQVW0bCRU6mTg/1tPVrek41Oqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJiamGMg1c4i1L8GJnohcodTNZ3kR9CaLvwDwPK6VHbPdlhcpT1cdiDm6jfHjwkho8RPJJqC32HQ/DjeS9uRNPsPbUDd2i8lk7ZVRzGz4xi1F49qHdRlh22vxEOxsGD8IRUJmgiLoLD6obqNJmvhedwhEBT+K1sKKAwL4b0MtjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z95MJwer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z95MJwer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456DE1F000E9;
	Thu, 30 Jul 2026 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422408;
	bh=mXcpufP/luDVUOcXwsTs0Q+ai5CWc2Uau0w5yEkk+wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z95MJwerIdmG+tQgwlAh+9bU1nQdfVf3iHdHFfSBtKxehyvaEXc9jGBo13NThC47X
	 NKaL2Y3eVldeqJ9ePe6NERz8TK7vibBEjHRaasuvTfAOT3bXbHaZ8PsaTz/b5zHrua
	 Knddpcwyt927vuit4Sy5zl0URIWaU63jqhz+khI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 411/744] drm/amdkfd: clamp v9 CRIU control stack checkpoint copy to BO size
Date: Thu, 30 Jul 2026 16:11:24 +0200
Message-ID: <20260730141453.031875338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

commit 426ffae6ecc7ec77d32bf8be065c21a1b881b084 upstream.

CRIU checkpoint copies the MQD control stack using cp_hqd_cntl_stack_size
from hardware without bounding it to the allocated BO region. If the HW
field is larger than the queue's control stack allocation, memcpy reads
past the BO into adjacent GTT memory and can leak kernel data to userspace.

Store the page-aligned control stack BO size in mqd_manager and clamp
checkpoint copies and reported checkpoint sizes to
min(cp_hqd_cntl_stack_size, mm->ctl_stack_size). Apply the same bound
for multi-XCC v9.4.3 checkpoint layout.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Reviewed-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6c2abd0ec09e86c6323010673766f76050e28aa3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h    |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c |   25 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
@@ -127,6 +127,7 @@ struct mqd_manager {
 	struct mutex	mqd_mutex;
 	struct kfd_node	*dev;
 	uint32_t mqd_size;
+	uint32_t ctl_stack_size;
 };
 
 struct mqd_user_context_save_area_header {
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include "kfd_priv.h"
 #include "kfd_mqd_manager.h"
+#include "kfd_topology.h"
 #include "v9_structs.h"
 #include "gc/gc_9_0_offset.h"
 #include "gc/gc_9_0_sh_mask.h"
@@ -400,8 +401,11 @@ static int get_wave_state(struct mqd_man
 static int get_checkpoint_info(struct mqd_manager *mm, void *mqd, u32 *ctl_stack_size)
 {
 	struct v9_mqd *m = get_mqd(mqd);
+	u32 per_xcc_size;
 
-	if (check_mul_overflow(m->cp_hqd_cntl_stack_size, NUM_XCC(mm->dev->xcc_mask), ctl_stack_size))
+	per_xcc_size = min_t(u32, m->cp_hqd_cntl_stack_size, mm->ctl_stack_size);
+
+	if (check_mul_overflow(per_xcc_size, NUM_XCC(mm->dev->xcc_mask), ctl_stack_size))
 		return -EINVAL;
 
 	return 0;
@@ -410,13 +414,15 @@ static int get_checkpoint_info(struct mq
 static void checkpoint_mqd(struct mqd_manager *mm, void *mqd, void *mqd_dst, void *ctl_stack_dst)
 {
 	struct v9_mqd *m;
+	u32 ctl_stack_copy_size;
 	/* Control stack is located one page after MQD. */
 	void *ctl_stack = (void *)((uintptr_t)mqd + AMDGPU_GPU_PAGE_SIZE);
 
 	m = get_mqd(mqd);
+	ctl_stack_copy_size = min_t(u32, m->cp_hqd_cntl_stack_size, mm->ctl_stack_size);
 
 	memcpy(mqd_dst, m, sizeof(struct v9_mqd));
-	memcpy(ctl_stack_dst, ctl_stack, m->cp_hqd_cntl_stack_size);
+	memcpy(ctl_stack_dst, ctl_stack, ctl_stack_copy_size);
 }
 
 static void checkpoint_mqd_v9_4_3(struct mqd_manager *mm,
@@ -425,15 +431,19 @@ static void checkpoint_mqd_v9_4_3(struct
 								  void *ctl_stack_dst)
 {
 	struct v9_mqd *m;
+	u32 ctl_stack_stride;
 	int xcc;
 	uint64_t size = get_mqd(mqd)->cp_mqd_stride_size;
 
+	ctl_stack_stride = min_t(u32, get_mqd(mqd)->cp_hqd_cntl_stack_size,
+				 mm->ctl_stack_size);
+
 	for (xcc = 0; xcc < NUM_XCC(mm->dev->xcc_mask); xcc++) {
 		m = get_mqd(mqd + size * xcc);
 
 		checkpoint_mqd(mm, m,
 				(uint8_t *)mqd_dst + sizeof(*m) * xcc,
-				(uint8_t *)ctl_stack_dst + m->cp_hqd_cntl_stack_size * xcc);
+				(uint8_t *)ctl_stack_dst + ctl_stack_stride * xcc);
 	}
 }
 
@@ -987,6 +997,15 @@ struct mqd_manager *mqd_manager_init_v9(
 		mqd->is_occupied = kfd_is_occupied_cp;
 		mqd->get_checkpoint_info = get_checkpoint_info;
 		mqd->mqd_size = sizeof(struct v9_mqd);
+		if (dev->kfd->cwsr_enabled) {
+			struct kfd_topology_device *topo_dev;
+
+			topo_dev = kfd_topology_device_by_id(dev->id);
+			if (topo_dev)
+				mqd->ctl_stack_size =
+					ALIGN(topo_dev->node_props.ctl_stack_size,
+					      AMDGPU_GPU_PAGE_SIZE);
+		}
 		mqd->mqd_stride = mqd_stride_v9;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd;


