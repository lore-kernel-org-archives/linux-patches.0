Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224BB2472AF;
	Mon, 23 Jun 2025 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686165; cv=none; b=UtSNhUBBWZfAgyjBKhprkYoiY4lZQihvTtt3o4a+UHEvVHaB8JalLpvpU3+T1o1FgCwQRk2ya80JF1GUAvo3lir242OLWrc1AoOBVPebV2ExX34HqSaj2bC6oeSHzLk2kFmQkDj+PFcu3EMNmJhUfesrsyOzOGNdJrrVQi8ljes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686165; c=relaxed/simple;
	bh=boR85Lsc4hJkBYzAH6fdPasHHRhii75bmUCLXr3qaaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi0Z6cUyQh6GQFADbtpKlZ/akdNm+WgaRbsGb5pbUtA/icapU6j26lpfhO/RPx14KVOHp4O1foa/144QjVXkXAIG6hiLKQeH52JnJ+F7XWC+pgrcQiQwzoupYr3TQfLJfHUt55K+HrF3B6q/8X7l62/p5TMlZDxrLUPjItVVd50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnchsSAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnchsSAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3D7C4CEF0;
	Mon, 23 Jun 2025 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686165;
	bh=boR85Lsc4hJkBYzAH6fdPasHHRhii75bmUCLXr3qaaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnchsSAeC4s54rFylC2Sq3DWbBXtn5UagnehVavpKSFOzgVRHgiZau4XRG2yQZvb2
	 MHu7Nw52+Rw+iPTrRVRhw6g1G4TpVhVGNZwh0Qa1qXetYFGJBaVXHn+iMvsqsKRbT+
	 iXHDKyjtQA80meA/GOgSlmT3Xg1jHkWw0l939iKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Skvortsov <victor.skvortsov@amd.com>,
	Zhigang Luo <Zhigang.luo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 307/592] drm/amdgpu: Add indirect L1_TLB_CNTL reg programming for VFs
Date: Mon, 23 Jun 2025 15:04:25 +0200
Message-ID: <20250623130707.706288705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Skvortsov <victor.skvortsov@amd.com>

[ Upstream commit 0c6e39ce6da20104900b11bad64464a12fb47320 ]

VFs on some IP versions are unable to access this register directly.

This register must be programmed before PSP ring is setup,
so use PSP VF mailbox directly. PSP will broadcast the register
value to all VF assigned instances.

Signed-off-by: Victor Skvortsov <victor.skvortsov@amd.com>
Reviewed-by: Zhigang Luo <Zhigang.luo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h     | 10 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h    | 12 +++-
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h |  9 +--
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c     | 63 ++++++++++++++++-----
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c      | 20 +++++++
 5 files changed, 93 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index 8d5acc415d386..dcf5e8e0b9e3e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -107,6 +107,7 @@ enum psp_reg_prog_id {
 	PSP_REG_IH_RB_CNTL        = 0,  /* register IH_RB_CNTL */
 	PSP_REG_IH_RB_CNTL_RING1  = 1,  /* register IH_RB_CNTL_RING1 */
 	PSP_REG_IH_RB_CNTL_RING2  = 2,  /* register IH_RB_CNTL_RING2 */
+	PSP_REG_MMHUB_L1_TLB_CNTL = 25,
 	PSP_REG_LAST
 };
 
@@ -142,6 +143,8 @@ struct psp_funcs {
 	bool (*get_ras_capability)(struct psp_context *psp);
 	bool (*is_aux_sos_load_required)(struct psp_context *psp);
 	bool (*is_reload_needed)(struct psp_context *psp);
+	int (*reg_program_no_ring)(struct psp_context *psp, uint32_t val,
+				   enum psp_reg_prog_id id);
 };
 
 struct ta_funcs {
@@ -475,6 +478,10 @@ struct amdgpu_psp_funcs {
 #define psp_is_aux_sos_load_required(psp) \
 	((psp)->funcs->is_aux_sos_load_required ? (psp)->funcs->is_aux_sos_load_required((psp)) : 0)
 
+#define psp_reg_program_no_ring(psp, val, id) \
+	((psp)->funcs->reg_program_no_ring ? \
+	(psp)->funcs->reg_program_no_ring((psp), val, id) : -EINVAL)
+
 extern const struct amd_ip_funcs psp_ip_funcs;
 
 extern const struct amdgpu_ip_block_version psp_v3_1_ip_block;
@@ -569,5 +576,8 @@ bool amdgpu_psp_get_ras_capability(struct psp_context *psp);
 int psp_config_sq_perfmon(struct psp_context *psp, uint32_t xcp_id,
 	bool core_override_enable, bool reg_override_enable, bool perfmon_override_enable);
 bool amdgpu_psp_tos_reload_needed(struct amdgpu_device *adev);
+int amdgpu_psp_reg_program_no_ring(struct psp_context *psp, uint32_t val,
+				   enum psp_reg_prog_id id);
+
 
 #endif
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index df03dba67ab89..b6ec6b7969f0c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -146,11 +146,13 @@ enum AMDGIM_FEATURE_FLAG {
 
 enum AMDGIM_REG_ACCESS_FLAG {
 	/* Use PSP to program IH_RB_CNTL */
-	AMDGIM_FEATURE_IH_REG_PSP_EN     = (1 << 0),
+	AMDGIM_FEATURE_IH_REG_PSP_EN      = (1 << 0),
 	/* Use RLC to program MMHUB regs */
-	AMDGIM_FEATURE_MMHUB_REG_RLC_EN  = (1 << 1),
+	AMDGIM_FEATURE_MMHUB_REG_RLC_EN   = (1 << 1),
 	/* Use RLC to program GC regs */
-	AMDGIM_FEATURE_GC_REG_RLC_EN     = (1 << 2),
+	AMDGIM_FEATURE_GC_REG_RLC_EN      = (1 << 2),
+	/* Use PSP to program L1_TLB_CNTL*/
+	AMDGIM_FEATURE_L1_TLB_CNTL_PSP_EN = (1 << 3),
 };
 
 struct amdgim_pf2vf_info_v1 {
@@ -330,6 +332,10 @@ struct amdgpu_video_codec_info;
 (amdgpu_sriov_vf((adev)) && \
 	((adev)->virt.reg_access & (AMDGIM_FEATURE_GC_REG_RLC_EN)))
 
+#define amdgpu_sriov_reg_indirect_l1_tlb_cntl(adev) \
+(amdgpu_sriov_vf((adev)) && \
+	((adev)->virt.reg_access & (AMDGIM_FEATURE_L1_TLB_CNTL_PSP_EN)))
+
 #define amdgpu_sriov_rlcg_error_report_enabled(adev) \
         (amdgpu_sriov_reg_indirect_mmhub(adev) || amdgpu_sriov_reg_indirect_gc(adev))
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
index d6ac2652f0ac2..bea724981309c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
@@ -109,10 +109,11 @@ union amd_sriov_msg_feature_flags {
 
 union amd_sriov_reg_access_flags {
 	struct {
-		uint32_t vf_reg_access_ih	: 1;
-		uint32_t vf_reg_access_mmhub	: 1;
-		uint32_t vf_reg_access_gc	: 1;
-		uint32_t reserved		: 29;
+		uint32_t vf_reg_access_ih		: 1;
+		uint32_t vf_reg_access_mmhub		: 1;
+		uint32_t vf_reg_access_gc		: 1;
+		uint32_t vf_reg_access_l1_tlb_cntl	: 1;
+		uint32_t reserved			: 28;
 	} flags;
 	uint32_t all;
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
index 84cde1239ee45..4a43c9ab95a2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
@@ -30,6 +30,7 @@
 #include "soc15_common.h"
 #include "soc15.h"
 #include "amdgpu_ras.h"
+#include "amdgpu_psp.h"
 
 #define regVM_L2_CNTL3_DEFAULT	0x80100007
 #define regVM_L2_CNTL4_DEFAULT	0x000000c1
@@ -192,10 +193,8 @@ static void mmhub_v1_8_init_tlb_regs(struct amdgpu_device *adev)
 	uint32_t tmp, inst_mask;
 	int i;
 
-	/* Setup TLB control */
-	inst_mask = adev->aid_mask;
-	for_each_inst(i, inst_mask) {
-		tmp = RREG32_SOC15(MMHUB, i, regMC_VM_MX_L1_TLB_CNTL);
+	if (amdgpu_sriov_reg_indirect_l1_tlb_cntl(adev)) {
+		tmp = RREG32_SOC15(MMHUB, 0, regMC_VM_MX_L1_TLB_CNTL);
 
 		tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ENABLE_L1_TLB,
 				    1);
@@ -209,7 +208,26 @@ static void mmhub_v1_8_init_tlb_regs(struct amdgpu_device *adev)
 				    MTYPE, MTYPE_UC);/* XXX for emulation. */
 		tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ATC_EN, 1);
 
-		WREG32_SOC15(MMHUB, i, regMC_VM_MX_L1_TLB_CNTL, tmp);
+		psp_reg_program_no_ring(&adev->psp, tmp, PSP_REG_MMHUB_L1_TLB_CNTL);
+	} else {
+		inst_mask = adev->aid_mask;
+		for_each_inst(i, inst_mask) {
+			tmp = RREG32_SOC15(MMHUB, i, regMC_VM_MX_L1_TLB_CNTL);
+
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ENABLE_L1_TLB,
+					    1);
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
+					    SYSTEM_ACCESS_MODE, 3);
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
+					    ENABLE_ADVANCED_DRIVER_MODEL, 1);
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
+					    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
+					    MTYPE, MTYPE_UC);/* XXX for emulation. */
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ATC_EN, 1);
+
+			WREG32_SOC15(MMHUB, i, regMC_VM_MX_L1_TLB_CNTL, tmp);
+		}
 	}
 }
 
@@ -454,6 +472,30 @@ static int mmhub_v1_8_gart_enable(struct amdgpu_device *adev)
 	return 0;
 }
 
+static void mmhub_v1_8_disable_l1_tlb(struct amdgpu_device *adev)
+{
+	u32 tmp;
+	u32 i, inst_mask;
+
+	if (amdgpu_sriov_reg_indirect_l1_tlb_cntl(adev)) {
+		tmp = RREG32_SOC15(MMHUB, 0, regMC_VM_MX_L1_TLB_CNTL);
+		tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ENABLE_L1_TLB, 0);
+		tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
+				    ENABLE_ADVANCED_DRIVER_MODEL, 0);
+		psp_reg_program_no_ring(&adev->psp, tmp, PSP_REG_MMHUB_L1_TLB_CNTL);
+	} else {
+		inst_mask = adev->aid_mask;
+		for_each_inst(i, inst_mask) {
+			tmp = RREG32_SOC15(MMHUB, i, regMC_VM_MX_L1_TLB_CNTL);
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ENABLE_L1_TLB,
+					    0);
+			tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
+					    ENABLE_ADVANCED_DRIVER_MODEL, 0);
+			WREG32_SOC15(MMHUB, i, regMC_VM_MX_L1_TLB_CNTL, tmp);
+		}
+	}
+}
+
 static void mmhub_v1_8_gart_disable(struct amdgpu_device *adev)
 {
 	struct amdgpu_vmhub *hub;
@@ -467,15 +509,6 @@ static void mmhub_v1_8_gart_disable(struct amdgpu_device *adev)
 		for (i = 0; i < 16; i++)
 			WREG32_SOC15_OFFSET(MMHUB, j, regVM_CONTEXT0_CNTL,
 					    i * hub->ctx_distance, 0);
-
-		/* Setup TLB control */
-		tmp = RREG32_SOC15(MMHUB, j, regMC_VM_MX_L1_TLB_CNTL);
-		tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ENABLE_L1_TLB,
-				    0);
-		tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
-				    ENABLE_ADVANCED_DRIVER_MODEL, 0);
-		WREG32_SOC15(MMHUB, j, regMC_VM_MX_L1_TLB_CNTL, tmp);
-
 		if (!amdgpu_sriov_vf(adev)) {
 			/* Setup L2 cache */
 			tmp = RREG32_SOC15(MMHUB, j, regVM_L2_CNTL);
@@ -485,6 +518,8 @@ static void mmhub_v1_8_gart_disable(struct amdgpu_device *adev)
 			WREG32_SOC15(MMHUB, j, regVM_L2_CNTL3, 0);
 		}
 	}
+
+	mmhub_v1_8_disable_l1_tlb(adev);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index afdf8ce3b4c59..f5f616ab20e70 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -858,6 +858,25 @@ static bool psp_v13_0_is_reload_needed(struct psp_context *psp)
 	return false;
 }
 
+static int psp_v13_0_reg_program_no_ring(struct psp_context *psp, uint32_t val,
+					 enum psp_reg_prog_id id)
+{
+	struct amdgpu_device *adev = psp->adev;
+	int ret = -EOPNOTSUPP;
+
+	/* PSP will broadcast the value to all instances */
+	if (amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_101, GFX_CTRL_CMD_ID_GBR_IH_SET);
+		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_102, id);
+		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_103, val);
+
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
+	}
+
+	return ret;
+}
+
 static const struct psp_funcs psp_v13_0_funcs = {
 	.init_microcode = psp_v13_0_init_microcode,
 	.wait_for_bootloader = psp_v13_0_wait_for_bootloader_steady_state,
@@ -884,6 +903,7 @@ static const struct psp_funcs psp_v13_0_funcs = {
 	.get_ras_capability = psp_v13_0_get_ras_capability,
 	.is_aux_sos_load_required = psp_v13_0_is_aux_sos_load_required,
 	.is_reload_needed = psp_v13_0_is_reload_needed,
+	.reg_program_no_ring = psp_v13_0_reg_program_no_ring,
 };
 
 void psp_v13_0_set_psp_funcs(struct psp_context *psp)
-- 
2.39.5



