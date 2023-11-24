Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9FE381D8;
	Fri, 24 Nov 2023 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcQbCKVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D848C433C8;
	Fri, 24 Nov 2023 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849100;
	bh=t5Pc+39jyOvtlcdMC5uS5mgDj9AVZmZZSxsUj0ut9UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcQbCKVKWE81WbF8aR1L5pPn1SLaEYDU5mcm0ptixQqVpXmy25JbSIsqZLOtQ7s+c
	 AnZ21rNVowKVPVt0PXF8m1suXPiB/w8NzMNo++vXFY4UA6xmw6Rddw7yI1DawupiGt
	 w76N/mThg/ed8jzTgQjrmtfAQYPujoT77HMQ7O+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/530] drm/amdkfd: ratelimited SQ interrupt messages
Date: Fri, 24 Nov 2023 17:43:33 +0000
Message-ID: <20231124172029.490889693@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 37fb87910724f21a1f27a75743d4f9accdee77fb ]

No functional change. Use ratelimited version of pr_ to avoid
overflowing of dmesg buffer

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c | 6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c | 6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c  | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c
index c7991e07b6be5..a7697ec8188e0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c
@@ -268,7 +268,7 @@ static void event_interrupt_wq_v10(struct kfd_node *dev,
 						SQ_INTERRUPT_WORD_WAVE_CTXID1, ENCODING);
 			switch (encoding) {
 			case SQ_INTERRUPT_WORD_ENCODING_AUTO:
-				pr_debug(
+				pr_debug_ratelimited(
 					"sq_intr: auto, se %d, ttrace %d, wlt %d, ttrac_buf0_full %d, ttrac_buf1_full %d, ttrace_utc_err %d\n",
 					REG_GET_FIELD(context_id1, SQ_INTERRUPT_WORD_AUTO_CTXID1,
 							SE_ID),
@@ -284,7 +284,7 @@ static void event_interrupt_wq_v10(struct kfd_node *dev,
 							THREAD_TRACE_UTC_ERROR));
 				break;
 			case SQ_INTERRUPT_WORD_ENCODING_INST:
-				pr_debug("sq_intr: inst, se %d, data 0x%x, sa %d, priv %d, wave_id %d, simd_id %d, wgp_id %d\n",
+				pr_debug_ratelimited("sq_intr: inst, se %d, data 0x%x, sa %d, priv %d, wave_id %d, simd_id %d, wgp_id %d\n",
 					REG_GET_FIELD(context_id1, SQ_INTERRUPT_WORD_WAVE_CTXID1,
 							SE_ID),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID0,
@@ -310,7 +310,7 @@ static void event_interrupt_wq_v10(struct kfd_node *dev,
 			case SQ_INTERRUPT_WORD_ENCODING_ERROR:
 				sq_intr_err_type = REG_GET_FIELD(context_id0, KFD_CTXID0,
 								ERR_TYPE);
-				pr_warn("sq_intr: error, se %d, data 0x%x, sa %d, priv %d, wave_id %d, simd_id %d, wgp_id %d, err_type %d\n",
+				pr_warn_ratelimited("sq_intr: error, se %d, data 0x%x, sa %d, priv %d, wave_id %d, simd_id %d, wgp_id %d, err_type %d\n",
 					REG_GET_FIELD(context_id1, SQ_INTERRUPT_WORD_WAVE_CTXID1,
 							SE_ID),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID0,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c
index f933bd231fb9c..2a65792fd1162 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c
@@ -150,7 +150,7 @@ enum SQ_INTERRUPT_ERROR_TYPE {
 
 static void print_sq_intr_info_auto(uint32_t context_id0, uint32_t context_id1)
 {
-	pr_debug(
+	pr_debug_ratelimited(
 		"sq_intr: auto, ttrace %d, wlt %d, ttrace_buf_full %d, reg_tms %d, cmd_tms %d, host_cmd_ovf %d, host_reg_ovf %d, immed_ovf %d, ttrace_utc_err %d\n",
 		REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_AUTO_CTXID0, THREAD_TRACE),
 		REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_AUTO_CTXID0, WLT),
@@ -165,7 +165,7 @@ static void print_sq_intr_info_auto(uint32_t context_id0, uint32_t context_id1)
 
 static void print_sq_intr_info_inst(uint32_t context_id0, uint32_t context_id1)
 {
-	pr_debug(
+	pr_debug_ratelimited(
 		"sq_intr: inst, data 0x%08x, sh %d, priv %d, wave_id %d, simd_id %d, wgp_id %d\n",
 		REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID0, DATA),
 		REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID0, SH_ID),
@@ -177,7 +177,7 @@ static void print_sq_intr_info_inst(uint32_t context_id0, uint32_t context_id1)
 
 static void print_sq_intr_info_error(uint32_t context_id0, uint32_t context_id1)
 {
-	pr_warn(
+	pr_warn_ratelimited(
 		"sq_intr: error, detail 0x%08x, type %d, sh %d, priv %d, wave_id %d, simd_id %d, wgp_id %d\n",
 		REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_ERROR_CTXID0, DETAIL),
 		REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_ERROR_CTXID0, TYPE),
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
index 830396b1c3b14..27cdaea405017 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
@@ -333,7 +333,7 @@ static void event_interrupt_wq_v9(struct kfd_node *dev,
 			encoding = REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, ENCODING);
 			switch (encoding) {
 			case SQ_INTERRUPT_WORD_ENCODING_AUTO:
-				pr_debug(
+				pr_debug_ratelimited(
 					"sq_intr: auto, se %d, ttrace %d, wlt %d, ttrac_buf_full %d, reg_tms %d, cmd_tms %d, host_cmd_ovf %d, host_reg_ovf %d, immed_ovf %d, ttrace_utc_err %d\n",
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_AUTO_CTXID, SE_ID),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_AUTO_CTXID, THREAD_TRACE),
@@ -347,7 +347,7 @@ static void event_interrupt_wq_v9(struct kfd_node *dev,
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_AUTO_CTXID, THREAD_TRACE_UTC_ERROR));
 				break;
 			case SQ_INTERRUPT_WORD_ENCODING_INST:
-				pr_debug("sq_intr: inst, se %d, data 0x%x, sh %d, priv %d, wave_id %d, simd_id %d, cu_id %d, intr_data 0x%x\n",
+				pr_debug_ratelimited("sq_intr: inst, se %d, data 0x%x, sh %d, priv %d, wave_id %d, simd_id %d, cu_id %d, intr_data 0x%x\n",
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, SE_ID),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, DATA),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, SH_ID),
@@ -366,7 +366,7 @@ static void event_interrupt_wq_v9(struct kfd_node *dev,
 				break;
 			case SQ_INTERRUPT_WORD_ENCODING_ERROR:
 				sq_intr_err = REG_GET_FIELD(sq_int_data, KFD_SQ_INT_DATA, ERR_TYPE);
-				pr_warn("sq_intr: error, se %d, data 0x%x, sh %d, priv %d, wave_id %d, simd_id %d, cu_id %d, err_type %d\n",
+				pr_warn_ratelimited("sq_intr: error, se %d, data 0x%x, sh %d, priv %d, wave_id %d, simd_id %d, cu_id %d, err_type %d\n",
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, SE_ID),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, DATA),
 					REG_GET_FIELD(context_id0, SQ_INTERRUPT_WORD_WAVE_CTXID, SH_ID),
-- 
2.42.0



