Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10122384CED;
	Sat, 17 Oct 2026 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254344; cv=none; b=fL5bjkvT1nN5b5nl9Z5AV+WxzvdKRaEulWVDPAGJ5P1O+1ziAv8+hMUkkIYLNm9JxsesnFo5qMamTBAnPrSp4hm/+sPZ5N7EHmJpTwWMevFDubLbVxpDAoXbBy8gAnll6ldDxUkLvt5DfYeD3YQSxxEJae3eiKG1FvUg178zFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254344; c=relaxed/simple;
	bh=rFS1ZLf/3jHIjaA1NV212VFJLNwEGvJSIsfwG+ze6Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc6F+oIYDpIXArapxSpU4NYVaLLL2iD/hXjA1OH21eP1aCH2ps0Z6i8hIXT8j5v7wgfq22RPlDRF9UhO/9zzMqNSQoWx/D5Ljg4/mifKdKC+02jZMEC+VVtsWigZdWB1TYwvHFBnQvHapUCdqv25MLsEqOTY8H5ckyDyX0WHZe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss5fVjey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss5fVjey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB0C1F000C4;
	Sat, 17 Oct 2026 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254343;
	bh=jKwPJbgRNLoJE52X2uJG4josyaA/Xnh7dx3fKv6ovnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ss5fVjeycD9VmbMPTll+n1Vtm4Hieh/S+EYCFmjO2r+8zO2umRWQHEvq+lm13w2dK
	 tWrgSd5h1iJgacDZTnZdJWPSEZ4IXrpIjJUOVYwvttFULy7zDzTL3ObaeJwkJ1W0CL
	 Gx3MHVBxonR62GiZrTLeBZNPY/QXFxrpXZ/8wIcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/869] drm/amdkfd: clamp v9 CRIU control stack checkpoint copy to BO size
Date: Sat, 17 Oct 2026 17:54:15 +0200
Message-ID: <20261017160047.748465960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 426ffae6ecc7ec77d32bf8be065c21a1b881b084 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 6a69988b2d4fc..194a1c79cf042 100644
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
@@ -375,20 +376,26 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 static void get_checkpoint_info(struct mqd_manager *mm, void *mqd, u32 *ctl_stack_size)
 {
 	struct v9_mqd *m = get_mqd(mqd);
+	struct kfd_topology_device *topo_dev = kfd_topology_device_by_id(mm->dev->id);
+	u32 bo_size = topo_dev ? ALIGN(topo_dev->node_props.ctl_stack_size, PAGE_SIZE) : 0;
 
-	*ctl_stack_size = m->cp_hqd_cntl_stack_size;
+	*ctl_stack_size = min_t(u32, m->cp_hqd_cntl_stack_size, bo_size);
 }
 
 static void checkpoint_mqd(struct mqd_manager *mm, void *mqd, void *mqd_dst, void *ctl_stack_dst)
 {
 	struct v9_mqd *m;
+	struct kfd_topology_device *topo_dev = kfd_topology_device_by_id(mm->dev->id);
+	u32 bo_size = topo_dev ? ALIGN(topo_dev->node_props.ctl_stack_size, PAGE_SIZE) : 0;
+	u32 ctl_stack_copy_size;
 	/* Control stack is located one page after MQD. */
 	void *ctl_stack = (void *)((uintptr_t)mqd + PAGE_SIZE);
 
 	m = get_mqd(mqd);
+	ctl_stack_copy_size = min_t(u32, m->cp_hqd_cntl_stack_size, bo_size);
 
 	memcpy(mqd_dst, m, sizeof(struct v9_mqd));
-	memcpy(ctl_stack_dst, ctl_stack, m->cp_hqd_cntl_stack_size);
+	memcpy(ctl_stack_dst, ctl_stack, ctl_stack_copy_size);
 }
 
 static void restore_mqd(struct mqd_manager *mm, void **mqd,
-- 
2.53.0



