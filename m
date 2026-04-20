Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167302E093A;
	Mon, 20 Apr 2026 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700233; cv=none; b=MLNO4yACJdh5otCoKS9Re407WX+5w9P2tMu8PMDZyAjEDIYtXhzx5J0oprJFNBn4m42Z13Ox8rDa4d2uglFgxEpTHLR6cIPeGSKLcENc1weD1pXjvGqbENOhpi/ks1TCZ7mhwXlSqc6Jbi6MprPdSdx8cbsjonB3ASeihJlC25s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700233; c=relaxed/simple;
	bh=SulAoS3p2GV4JUrHVditBDoQwVQmS67YH9AwOnVIP68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+i21ktQdGvD5R//dkAyouvjxW3txrDmE0GoyP6yTI9CW+BKdHWWSHQu/UZYx6RDsLPL1xR3YFPxE0UiIKLYDgh2nxCrHXYiL3IUTsqOkomalL2VzdVSsyfAZHJLpezG3RJPdCTS9TH8tcLDClH4n+u1UrVfJDqrHWTy6QZf0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FNSnR8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FNSnR8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F882C19425;
	Mon, 20 Apr 2026 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700233;
	bh=SulAoS3p2GV4JUrHVditBDoQwVQmS67YH9AwOnVIP68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FNSnR8nv2IT0bLwU9FhBr/6g28bT4p6don67/IDuDKYx42DOptS/5T36c1jwpwbC
	 x1rYjEuadocXK4zlSfE/sJL/MCFKbQPrwfKvGN2d+IEztUOQX82zGZmGUR6HhT3Yip
	 wTMqBQ4Nvn47o9a1kRXCmugeQFz9Iw9U5KHnCvPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 092/220] mshv: Fix infinite fault loop on permission-denied GPA intercepts
Date: Mon, 20 Apr 2026 17:40:33 +0200
Message-ID: <20260420153937.347380356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 16cbec24897624051b324aa3a85859c38ca65fde ]

Prevent infinite fault loops when guests access memory regions without
proper permissions. Currently, mshv_handle_gpa_intercept() attempts to
remap pages for all faults on movable memory regions, regardless of
whether the access type is permitted. When a guest writes to a read-only
region, the remap succeeds but the region remains read-only, causing
immediate re-fault and spinning the vCPU indefinitely.

Validate intercept access type against region permissions before
attempting remaps. Reject writes to non-writable regions and executes to
non-executable regions early, returning false to let the VMM handle the
intercept appropriately.

This also closes a potential DoS vector where malicious guests could
intentionally trigger these fault loops to consume host resources.

Fixes: b9a66cd5ccbb ("mshv: Add support for movable memory regions")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c | 15 ++++++++++++---
 include/hyperv/hvgdk_mini.h |  6 ++++++
 include/hyperv/hvhdk.h      |  4 ++--
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 45cf086ad430d..5611be36f6a8e 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -642,7 +642,7 @@ static bool mshv_handle_gpa_intercept(struct mshv_vp *vp)
 {
 	struct mshv_partition *p = vp->vp_partition;
 	struct mshv_mem_region *region;
-	bool ret;
+	bool ret = false;
 	u64 gfn;
 #if defined(CONFIG_X86_64)
 	struct hv_x64_memory_intercept_message *msg =
@@ -653,6 +653,8 @@ static bool mshv_handle_gpa_intercept(struct mshv_vp *vp)
 		(struct hv_arm64_memory_intercept_message *)
 		vp->vp_intercept_msg_page->u.payload;
 #endif
+	enum hv_intercept_access_type access_type =
+		msg->header.intercept_access_type;
 
 	gfn = HVPFN_DOWN(msg->guest_physical_address);
 
@@ -660,12 +662,19 @@ static bool mshv_handle_gpa_intercept(struct mshv_vp *vp)
 	if (!region)
 		return false;
 
+	if (access_type == HV_INTERCEPT_ACCESS_WRITE &&
+	    !(region->hv_map_flags & HV_MAP_GPA_WRITABLE))
+		goto put_region;
+
+	if (access_type == HV_INTERCEPT_ACCESS_EXECUTE &&
+	    !(region->hv_map_flags & HV_MAP_GPA_EXECUTABLE))
+		goto put_region;
+
 	/* Only movable memory ranges are supported for GPA intercepts */
 	if (region->type == MSHV_REGION_TYPE_MEM_MOVABLE)
 		ret = mshv_region_handle_gfn_fault(region, gfn);
-	else
-		ret = false;
 
+put_region:
 	mshv_region_put(region);
 
 	return ret;
diff --git a/include/hyperv/hvgdk_mini.h b/include/hyperv/hvgdk_mini.h
index 30fbbde81c5c4..9c523ee57a358 100644
--- a/include/hyperv/hvgdk_mini.h
+++ b/include/hyperv/hvgdk_mini.h
@@ -1528,4 +1528,10 @@ struct hv_mmio_write_input {
 	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
 } __packed;
 
+enum hv_intercept_access_type {
+	HV_INTERCEPT_ACCESS_READ	= 0,
+	HV_INTERCEPT_ACCESS_WRITE	= 1,
+	HV_INTERCEPT_ACCESS_EXECUTE	= 2
+};
+
 #endif /* _HV_HVGDK_MINI_H */
diff --git a/include/hyperv/hvhdk.h b/include/hyperv/hvhdk.h
index 08965970c17df..84ebe56f1f8db 100644
--- a/include/hyperv/hvhdk.h
+++ b/include/hyperv/hvhdk.h
@@ -770,7 +770,7 @@ struct hv_x64_intercept_message_header {
 	u32 vp_index;
 	u8 instruction_length:4;
 	u8 cr8:4; /* Only set for exo partitions */
-	u8 intercept_access_type;
+	u8 intercept_access_type; /* enum hv_intercept_access_type */
 	union hv_x64_vp_execution_state execution_state;
 	struct hv_x64_segment_register cs_segment;
 	u64 rip;
@@ -816,7 +816,7 @@ union hv_arm64_vp_execution_state {
 struct hv_arm64_intercept_message_header {
 	u32 vp_index;
 	u8 instruction_length;
-	u8 intercept_access_type;
+	u8 intercept_access_type; /* enum hv_intercept_access_type */
 	union hv_arm64_vp_execution_state execution_state;
 	u64 pc;
 	u64 cpsr;
-- 
2.53.0



