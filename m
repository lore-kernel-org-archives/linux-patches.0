Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AECC21D5BE;
	Tue, 20 May 2025 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750658; cv=none; b=e2oLcStOsRF2ja6EN3cZ2as+UJWqk0qg1CpuElhRG7eNtoqpe9mHC6HmNENk2j1K5MwfYdfNijGst0+Y3z/tvhjFei2UH4PELpfgnHCkQ0E0bJ3VdwZyB/cYXpJ9W9LLGSHrV5Zc30N8O3e97FKRzSeqtGKsXhPE90E65R875BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750658; c=relaxed/simple;
	bh=K7MOZd7mVAfUDBv79tdR90Zuj6cu+Lv4R0RGeS0a8Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaQx6ZQI6YnySgdYI02kc6wU48TlAo2R0EKRpDFfBfhz93fMqdHjSZWqURnKK0LV3vICLYZl67VKftuf+bPPCVE/sCtX4Z4osDINFV/LnTKo5GvsQD2krtZoOUV4HviBRqIl3fQZ0kIV7UVqhjTzneYTZePB/3huYi3MlnV6Z1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed/OLBpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed/OLBpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D77DC4CEEA;
	Tue, 20 May 2025 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750658;
	bh=K7MOZd7mVAfUDBv79tdR90Zuj6cu+Lv4R0RGeS0a8Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed/OLBppxB6CT0vxcB1+Ub/NxqbNfSnblUAaV5oVa6G8UjzMmMorBs9uCMdu0WyOr
	 MqtZifu8HvRBX0E55xXTuavFO0UxFkDrpNfU9WOqCC6NnDL8qCavOm8xShtfxgsYd7
	 wTNQLPW8dwd34Gq2wwdSse0oqeJVkHPNTucxCXqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 049/145] drm/xe: Save CTX_TIMESTAMP mmio value instead of LRC value
Date: Tue, 20 May 2025 15:50:19 +0200
Message-ID: <20250520125812.498345804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index bbb9ffbf63672..2a953c4f7d5dd 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -684,7 +684,7 @@ static inline u32 __xe_lrc_start_seqno_offset(struct xe_lrc *lrc)
 
 static u32 __xe_lrc_ctx_job_timestamp_offset(struct xe_lrc *lrc)
 {
-	/* The start seqno is stored in the driver-defined portion of PPHWSP */
+	/* This is stored in the driver-defined portion of PPHWSP */
 	return xe_lrc_pphwsp_offset(lrc) + LRC_CTX_JOB_TIMESTAMP_OFFSET;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index 8d1fb33d923f4..3493177947680 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -234,13 +234,10 @@ static u32 get_ppgtt_flag(struct xe_sched_job *job)
 
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



