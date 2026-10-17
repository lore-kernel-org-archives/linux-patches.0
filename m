Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA9E3ADBA4;
	Sat, 17 Oct 2026 16:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255288; cv=none; b=sHMGlECS31ws6QSDiuX7Zd7LpKaVRzOWxV2jHKi0wXecX1EUtt7QKyJMU0GAiCAqmsAMNFqCynjL4o1iD9ywBz81sdFDhgwRWyKq0r7XyX0vG1Mn/xS18CVs9TwNHEymVN3UfCx7OhaCHgc6xuAZKExtgnKgUmAl5pqukGK248o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255288; c=relaxed/simple;
	bh=VyrOiv8vMSi4dys8gAak7faqikNU/xiEzsva1yAd69Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nozBdy7kOr1zfgGncUeX997MQqfaLK8uSoJkX4Is5+Ud/GK5bWVf2lKz6MUrU19BejnxE3E6zNVyQIK9B4R3dd3oDZJTL8jzdDXIetsgAMlOsEIDmq46WqF7XdMlYeKys3k8/r6dFzwZehi182PSVz/PA7Twv6VucyrcfeNDQHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8gEopem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8gEopem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933DD1F000C4;
	Sat, 17 Oct 2026 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255287;
	bh=31r/l1f37ZSzvY+JWr7rKC+Dfc0TwW6r3DUlTbs0hqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8gEopemupPqjoY1jlYkKdj0UlfJh4cds0MX8kiugvp/8I59z+QhMvq+/MTCNSe3C
	 Ss51RbVwLBLykVJDPNrx8g/frTJxhruG05hgiBfdsSv+vVdVIPIfXSngWw6k3i6yXf
	 xRPiE8PYRWz4NDZtaprz5jhomeRe15lY4pyB0EpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Skvortsov <victor.skvortsov@amd.com>,
	Zhigang Luo <zhigang.luo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 726/869] drm/amdgpu: Update SRIOV Exchange Headers for RAS Telemetry Support
Date: Sat, 17 Oct 2026 17:59:27 +0200
Message-ID: <20261017160055.565794598@linuxfoundation.org>
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

From: Victor Skvortsov <victor.skvortsov@amd.com>

[ Upstream commit 60c58d72afb81d2dc3f52f638eff5197511ac114 ]

The SRIOV PF/VF Data exchange is extended by 64KB for VF RAS Telemetry data.
Add Host RAS Telemetry enable capabilities bitfields.
Add a new VF msg REQ_RAS_ERROR_COUNT, the host response data will be populated
in the RAS Telemetry region.

Signed-off-by: Victor Skvortsov <victor.skvortsov@amd.com>
Reviewed-by: Zhigang Luo <zhigang.luo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e3829992dd9f ("drm/amdgpu/ras: add ras_suspend callback and use it for cp_ecc_error_irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h | 131 +++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.h       |   3 +
 2 files changed, 115 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
index 6e9eeaeb3de1d..b4f9c2f4e92cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
@@ -28,17 +28,21 @@
 #define AMD_SRIOV_MSG_VBIOS_SIZE_KB	     64
 #define AMD_SRIOV_MSG_DATAEXCHANGE_OFFSET_KB AMD_SRIOV_MSG_VBIOS_SIZE_KB
 #define AMD_SRIOV_MSG_DATAEXCHANGE_SIZE_KB   4
-
+#define AMD_SRIOV_MSG_TMR_OFFSET_KB	     2048
+#define AMD_SRIOV_MSG_BAD_PAGE_SIZE_KB	     2
+#define AMD_SRIOV_RAS_TELEMETRY_SIZE_KB	     64
 /*
  * layout
- * 0           64KB        65KB        66KB
- * |   VBIOS   |   PF2VF   |   VF2PF   |   Bad Page   | ...
- * |   64KB    |   1KB     |   1KB     |
+ * 0           64KB        65KB        66KB           68KB                   132KB
+ * |   VBIOS   |   PF2VF   |   VF2PF   |   Bad Page   | RAS Telemetry Region | ...
+ * |   64KB    |   1KB     |   1KB     |   2KB        | 64KB                 | ...
  */
+
 #define AMD_SRIOV_MSG_SIZE_KB                   1
 #define AMD_SRIOV_MSG_PF2VF_OFFSET_KB           AMD_SRIOV_MSG_DATAEXCHANGE_OFFSET_KB
 #define AMD_SRIOV_MSG_VF2PF_OFFSET_KB           (AMD_SRIOV_MSG_PF2VF_OFFSET_KB + AMD_SRIOV_MSG_SIZE_KB)
 #define AMD_SRIOV_MSG_BAD_PAGE_OFFSET_KB        (AMD_SRIOV_MSG_VF2PF_OFFSET_KB + AMD_SRIOV_MSG_SIZE_KB)
+#define AMD_SRIOV_MSG_RAS_TELEMETRY_OFFSET_KB   (AMD_SRIOV_MSG_BAD_PAGE_OFFSET_KB + AMD_SRIOV_MSG_BAD_PAGE_SIZE_KB)
 
 /*
  * PF2VF history log:
@@ -86,30 +90,59 @@ enum amd_sriov_ucode_engine_id {
 
 union amd_sriov_msg_feature_flags {
 	struct {
-		uint32_t error_log_collect : 1;
-		uint32_t host_load_ucodes  : 1;
-		uint32_t host_flr_vramlost : 1;
-		uint32_t mm_bw_management  : 1;
-		uint32_t pp_one_vf_mode    : 1;
-		uint32_t reg_indirect_acc  : 1;
-		uint32_t av1_support       : 1;
-		uint32_t vcn_rb_decouple   : 1;
-		uint32_t mes_info_enable   : 1;
-		uint32_t reserved          : 23;
+		uint32_t error_log_collect	: 1;
+		uint32_t host_load_ucodes	: 1;
+		uint32_t host_flr_vramlost	: 1;
+		uint32_t mm_bw_management	: 1;
+		uint32_t pp_one_vf_mode		: 1;
+		uint32_t reg_indirect_acc	: 1;
+		uint32_t av1_support		: 1;
+		uint32_t vcn_rb_decouple 	: 1;
+		uint32_t mes_info_dump_enable	: 1;
+		uint32_t ras_caps		: 1;
+		uint32_t ras_telemetry		: 1;
+		uint32_t reserved		: 21;
 	} flags;
 	uint32_t all;
 };
 
 union amd_sriov_reg_access_flags {
 	struct {
-		uint32_t vf_reg_access_ih 	 : 1;
-		uint32_t vf_reg_access_mmhub : 1;
-		uint32_t vf_reg_access_gc 	 : 1;
-		uint32_t reserved	         : 29;
+		uint32_t vf_reg_access_ih	: 1;
+		uint32_t vf_reg_access_mmhub	: 1;
+		uint32_t vf_reg_access_gc	: 1;
+		uint32_t reserved		: 29;
 	} flags;
 	uint32_t all;
 };
 
+union amd_sriov_ras_caps {
+	struct {
+		uint64_t block_umc			: 1;
+		uint64_t block_sdma			: 1;
+		uint64_t block_gfx			: 1;
+		uint64_t block_mmhub			: 1;
+		uint64_t block_athub			: 1;
+		uint64_t block_pcie_bif			: 1;
+		uint64_t block_hdp			: 1;
+		uint64_t block_xgmi_wafl		: 1;
+		uint64_t block_df			: 1;
+		uint64_t block_smn			: 1;
+		uint64_t block_sem			: 1;
+		uint64_t block_mp0			: 1;
+		uint64_t block_mp1			: 1;
+		uint64_t block_fuse			: 1;
+		uint64_t block_mca			: 1;
+		uint64_t block_vcn			: 1;
+		uint64_t block_jpeg			: 1;
+		uint64_t block_ih			: 1;
+		uint64_t block_mpio			: 1;
+		uint64_t poison_propogation_mode	: 1;
+		uint64_t reserved			: 44;
+	} bits;
+	uint64_t all;
+};
+
 union amd_sriov_msg_os_info {
 	struct {
 		uint32_t windows  : 1;
@@ -158,7 +191,7 @@ struct amd_sriov_msg_pf2vf_info_header {
 	uint32_t reserved[2];
 };
 
-#define AMD_SRIOV_MSG_PF2VF_INFO_FILLED_SIZE (49)
+#define AMD_SRIOV_MSG_PF2VF_INFO_FILLED_SIZE (55)
 struct amd_sriov_msg_pf2vf_info {
 	/* header contains size and version */
 	struct amd_sriov_msg_pf2vf_info_header header;
@@ -211,6 +244,12 @@ struct amd_sriov_msg_pf2vf_info {
 	uint32_t pcie_atomic_ops_support_flags;
 	/* Portion of GPU memory occupied by VF.  MAX value is 65535, but set to uint32_t to maintain alignment with reserved size */
 	uint32_t gpu_capacity;
+	/* vf bdf on host pci tree for debug only */
+	uint32_t bdf_on_host;
+	uint32_t more_bp;	//Reserved for future use.
+	union amd_sriov_ras_caps ras_en_caps;
+	union amd_sriov_ras_caps ras_telemetry_en_caps;
+
 	/* reserved */
 	uint32_t reserved[256 - AMD_SRIOV_MSG_PF2VF_INFO_FILLED_SIZE];
 } __packed;
@@ -283,8 +322,12 @@ enum amd_sriov_mailbox_request_message {
 	MB_REQ_MSG_REL_GPU_FINI_ACCESS,
 	MB_REQ_MSG_REQ_GPU_RESET_ACCESS,
 	MB_REQ_MSG_REQ_GPU_INIT_DATA,
+	MB_REQ_MSG_PSP_VF_CMD_RELAY,
 
 	MB_REQ_MSG_LOG_VF_ERROR = 200,
+	MB_REQ_MSG_READY_TO_RESET = 201,
+	MB_REQ_MSG_RAS_POISON = 202,
+	MB_REQ_RAS_ERROR_COUNT = 203,
 };
 
 /* mailbox message send from host to guest  */
@@ -297,10 +340,60 @@ enum amd_sriov_mailbox_response_message {
 	MB_RES_MSG_FAIL,
 	MB_RES_MSG_QUERY_ALIVE,
 	MB_RES_MSG_GPU_INIT_DATA_READY,
+	MB_RES_MSG_RAS_ERROR_COUNT_READY = 11,
 
 	MB_RES_MSG_TEXT_MESSAGE = 255
 };
 
+enum amd_sriov_ras_telemetry_gpu_block {
+	RAS_TELEMETRY_GPU_BLOCK_UMC		= 0,
+	RAS_TELEMETRY_GPU_BLOCK_SDMA		= 1,
+	RAS_TELEMETRY_GPU_BLOCK_GFX		= 2,
+	RAS_TELEMETRY_GPU_BLOCK_MMHUB		= 3,
+	RAS_TELEMETRY_GPU_BLOCK_ATHUB		= 4,
+	RAS_TELEMETRY_GPU_BLOCK_PCIE_BIF	= 5,
+	RAS_TELEMETRY_GPU_BLOCK_HDP		= 6,
+	RAS_TELEMETRY_GPU_BLOCK_XGMI_WAFL	= 7,
+	RAS_TELEMETRY_GPU_BLOCK_DF		= 8,
+	RAS_TELEMETRY_GPU_BLOCK_SMN		= 9,
+	RAS_TELEMETRY_GPU_BLOCK_SEM		= 10,
+	RAS_TELEMETRY_GPU_BLOCK_MP0		= 11,
+	RAS_TELEMETRY_GPU_BLOCK_MP1		= 12,
+	RAS_TELEMETRY_GPU_BLOCK_FUSE		= 13,
+	RAS_TELEMETRY_GPU_BLOCK_MCA		= 14,
+	RAS_TELEMETRY_GPU_BLOCK_VCN		= 15,
+	RAS_TELEMETRY_GPU_BLOCK_JPEG		= 16,
+	RAS_TELEMETRY_GPU_BLOCK_IH		= 17,
+	RAS_TELEMETRY_GPU_BLOCK_MPIO		= 18,
+	RAS_TELEMETRY_GPU_BLOCK_COUNT		= 19,
+};
+
+struct amd_sriov_ras_telemetry_header {
+	uint32_t checksum;
+	uint32_t used_size;
+	uint32_t reserved[2];
+};
+
+struct amd_sriov_ras_telemetry_error_count {
+	struct {
+		uint32_t ce_count;
+		uint32_t ue_count;
+		uint32_t de_count;
+		uint32_t ce_overflow_count;
+		uint32_t ue_overflow_count;
+		uint32_t de_overflow_count;
+		uint32_t reserved[6];
+	} block[RAS_TELEMETRY_GPU_BLOCK_COUNT];
+};
+
+struct amdsriov_ras_telemetry {
+	struct amd_sriov_ras_telemetry_header header;
+
+	union {
+		struct amd_sriov_ras_telemetry_error_count error_count;
+	} body;
+};
+
 /* version data stored in MAILBOX_MSGBUF_RCV_DW1 for future expansion */
 enum amd_sriov_gpu_init_data_version {
 	GPU_INIT_DATA_READY_V1 = 1,
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.h b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.h
index 1d099ffb3a5a2..9d61d76e1bf96 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.h
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.h
@@ -40,6 +40,7 @@ enum idh_request {
 	IDH_LOG_VF_ERROR	= 200,
 	IDH_READY_TO_RESET 	= 201,
 	IDH_RAS_POISON	= 202,
+	IDH_REQ_RAS_ERROR_COUNT = 203,
 };
 
 enum idh_event {
@@ -54,6 +55,8 @@ enum idh_event {
 	IDH_RAS_POISON_READY,
 	IDH_PF_SOFT_FLR_NOTIFICATION,
 	IDH_RAS_ERROR_DETECTED,
+	IDH_RAS_ERROR_COUNT_READY = 11,
+
 	IDH_TEXT_MESSAGE = 255,
 };
 
-- 
2.53.0



