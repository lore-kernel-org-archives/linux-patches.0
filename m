Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4691CCEE7;
	Tue, 20 May 2025 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750147; cv=none; b=dm0bD06iFWFRzcTaf9fNoMdt1uh4/Jto0celYZeV3WlELH6Z+743VaDYY/qkUQOKWYVvjc13Zb6PfERckAYkkxiDl2AxlIrFpMphLQ0eQStF6/Aqxn1I02x6bpsRLBRc9357Nmzj15ximhMRULRbyu/aUzMClpr/MDBdXH/Ntzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750147; c=relaxed/simple;
	bh=kOFZRY7FLQmF/hknFne3tU3aZyfJN5TvINqlb29VEgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNRN2uK2Zn1r2Ze2YcokJlujV65P6VknKPtPkQ70f21J+cyoywiQe4q81eqo1ShZMy+cFE0H/KsZmL/34S8gyu+26lElnjU/KcfHZ4VcEaz4FVaPAR6BNBZ+mfRNl/181vk1pLcKgHrNCYzJEM1TaA7pzGTAXZdQQ7c0Qe6+Fyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnu8PXxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnu8PXxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31F8C4CEE9;
	Tue, 20 May 2025 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750147;
	bh=kOFZRY7FLQmF/hknFne3tU3aZyfJN5TvINqlb29VEgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnu8PXxwkJ8rZezYKlt/7b+ABWIWj4IjWeFVXt7gjgstHJH6bbi9k9oPdIzt3aTDp
	 3JGVO5IVWF6VLpkB1m/PBemlmpCTC7qKcMTNrIL09+Dias+DFy6PDmqyrZ4xeXCyWJ
	 YXwHTQ84BVkEw2xu/29X+EROalT0vORBgRisWPAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/143] drm/xe: Save CTX_TIMESTAMP mmio value instead of LRC value
Date: Tue, 20 May 2025 15:50:12 +0200
Message-ID: <20250520125812.299217889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 66c8f7b435bddb7d8577ac8a57e175a6cb147227 ]

For determining actual job execution time, save the current value of the
CTX_TIMESTAMP register rather than the value saved in LRC since the
current register value is the closest to the start time of the job.

v2: Define MI_STORE_REGISTER_MEM to fix compile error
v3: Place MI_STORE_REGISTER_MEM sorted by MI_INSTR (Lucas)

Fixes: 65921374c48f ("drm/xe: Emit ctx timestamp copy in ring ops")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250509161159.2173069-6-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 38b14233e5deff51db8faec287b4acd227152246)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/instructions/xe_mi_commands.h | 4 ++++
 drivers/gpu/drm/xe/xe_lrc.c                      | 2 +-
 drivers/gpu/drm/xe/xe_ring_ops.c                 | 7 ++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/instructions/xe_mi_commands.h b/drivers/gpu/drm/xe/instructions/xe_mi_commands.h
index 10ec2920d31b3..d4033278be9fc 100644
--- a/drivers/gpu/drm/xe/instructions/xe_mi_commands.h
+++ b/drivers/gpu/drm/xe/instructions/xe_mi_commands.h
@@ -47,6 +47,10 @@
 #define   MI_LRI_FORCE_POSTED		REG_BIT(12)
 #define   MI_LRI_LEN(x)			(((x) & 0xff) + 1)
 
+#define MI_STORE_REGISTER_MEM		(__MI_INSTR(0x24) | XE_INSTR_NUM_DW(4))
+#define   MI_SRM_USE_GGTT		REG_BIT(22)
+#define   MI_SRM_ADD_CS_OFFSET		REG_BIT(19)
+
 #define MI_FLUSH_DW			__MI_INSTR(0x26)
 #define   MI_FLUSH_DW_STORE_INDEX	REG_BIT(21)
 #define   MI_INVALIDATE_TLB		REG_BIT(18)
diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index aec7db39c061e..2d4e38b3bab19 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -694,7 +694,7 @@ static inline u32 __xe_lrc_start_seqno_offset(struct xe_lrc *lrc)
 
 static u32 __xe_lrc_ctx_job_timestamp_offset(struct xe_lrc *lrc)
 {
-	/* The start seqno is stored in the driver-defined portion of PPHWSP */
+	/* This is stored in the driver-defined portion of PPHWSP */
 	return xe_lrc_pphwsp_offset(lrc) + LRC_CTX_JOB_TIMESTAMP_OFFSET;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index 9f327f27c0726..fb31e09acb519 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -229,13 +229,10 @@ static u32 get_ppgtt_flag(struct xe_sched_job *job)
 
 static int emit_copy_timestamp(struct xe_lrc *lrc, u32 *dw, int i)
 {
-	dw[i++] = MI_COPY_MEM_MEM | MI_COPY_MEM_MEM_SRC_GGTT |
-		MI_COPY_MEM_MEM_DST_GGTT;
+	dw[i++] = MI_STORE_REGISTER_MEM | MI_SRM_USE_GGTT | MI_SRM_ADD_CS_OFFSET;
+	dw[i++] = RING_CTX_TIMESTAMP(0).addr;
 	dw[i++] = xe_lrc_ctx_job_timestamp_ggtt_addr(lrc);
 	dw[i++] = 0;
-	dw[i++] = xe_lrc_ctx_timestamp_ggtt_addr(lrc);
-	dw[i++] = 0;
-	dw[i++] = MI_NOOP;
 
 	return i;
 }
-- 
2.39.5



