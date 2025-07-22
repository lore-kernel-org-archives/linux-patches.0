Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6731A2C25;
	Tue, 22 Jul 2025 14:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193009; cv=none; b=GtVa7lsRHw6QIb8Y8LAKlMnHy9A6uAooyP18NuXcuMphYx55ywnKHohGHPXjeRR/o6rnOGxqDR8/AML3oAASHiQ2vAoiPUL5g6wbY7FCNmox6PEF3nnKQWaSv2A2OZDXmP33X8UM2ru4Nwl/L215839R/HCsxiYqOgVGWIRsDUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193009; c=relaxed/simple;
	bh=3NZUBpciBJ4lu/UveIJnRgERyCJu0Vkv0rJVxxxHs7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qz9+WKOtry+KvFMLebBJFXSkFyf0wH6KLgw3Bgplyvl2M3qEu+YZwUyjscav7vgQbpRRRnd+Kkxl+rFvsT6zSuO6fAGuvFvaV6OXejKb1JeFNZ6G+cLqxwIXksD91VgVIqDzAEiG+vuy1qO1gn4r6/0mmAHGB68G7LTwrQSpAPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlvltWYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlvltWYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB667C4CEF1;
	Tue, 22 Jul 2025 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193009;
	bh=3NZUBpciBJ4lu/UveIJnRgERyCJu0Vkv0rJVxxxHs7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlvltWYfU69AeHutFZ4SbBGyV5a5153t4JoZYjRPk40TPQ1bUuhEEQ42DfGRovfyS
	 75iYhK+eHfTitlswIF9EbX+2bJf7f/iTdNl9SYQb9hPPUWRB+uwVQOnvj3JoLZeMHo
	 uT5Un6k/CBs9Kd+tENLZxh+Too4/JIuzbmKO2le4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/158] drm/xe/pf: Sanitize VF scratch registers on FLR
Date: Tue, 22 Jul 2025 15:45:07 +0200
Message-ID: <20250722134345.326577398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 13a48a0fa52352f9fe58e2e1927670dcfea64c3a ]

Some VF accessible registers (like GuC scratch registers) must be
explicitly reset during the FLR. While this is today done by the GuC
firmware, according to the design, this should be responsibility of
the PF driver, as future platforms may require more registers to be
reset. Likewise GuC, the PF can access VFs registers by adding some
platform specific offset to the original register address.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902192953.1792-1-michal.wajdeczko@intel.com
Stable-dep-of: 81dccec448d2 ("drm/xe/pf: Prepare to stop SR-IOV support prior GT reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c         | 52 +++++++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf.h         |  1 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c |  3 +-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index 905f409db74b0..919d960165d51 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -5,8 +5,10 @@
 
 #include <drm/drm_managed.h>
 
+#include "regs/xe_guc_regs.h"
 #include "regs/xe_regs.h"
 
+#include "xe_gt.h"
 #include "xe_gt_sriov_pf.h"
 #include "xe_gt_sriov_pf_config.h"
 #include "xe_gt_sriov_pf_control.h"
@@ -89,6 +91,56 @@ void xe_gt_sriov_pf_init_hw(struct xe_gt *gt)
 	xe_gt_sriov_pf_service_update(gt);
 }
 
+static u32 pf_get_vf_regs_stride(struct xe_device *xe)
+{
+	return GRAPHICS_VERx100(xe) > 1200 ? 0x400 : 0x1000;
+}
+
+static struct xe_reg xe_reg_vf_to_pf(struct xe_reg vf_reg, unsigned int vfid, u32 stride)
+{
+	struct xe_reg pf_reg = vf_reg;
+
+	pf_reg.vf = 0;
+	pf_reg.addr += stride * vfid;
+
+	return pf_reg;
+}
+
+static void pf_clear_vf_scratch_regs(struct xe_gt *gt, unsigned int vfid)
+{
+	u32 stride = pf_get_vf_regs_stride(gt_to_xe(gt));
+	struct xe_reg scratch;
+	int n, count;
+
+	if (xe_gt_is_media_type(gt)) {
+		count = MED_VF_SW_FLAG_COUNT;
+		for (n = 0; n < count; n++) {
+			scratch = xe_reg_vf_to_pf(MED_VF_SW_FLAG(n), vfid, stride);
+			xe_mmio_write32(gt, scratch, 0);
+		}
+	} else {
+		count = VF_SW_FLAG_COUNT;
+		for (n = 0; n < count; n++) {
+			scratch = xe_reg_vf_to_pf(VF_SW_FLAG(n), vfid, stride);
+			xe_mmio_write32(gt, scratch, 0);
+		}
+	}
+}
+
+/**
+ * xe_gt_sriov_pf_sanitize_hw() - Reset hardware state related to a VF.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier
+ *
+ * This function can only be called on PF.
+ */
+void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+
+	pf_clear_vf_scratch_regs(gt, vfid);
+}
+
 /**
  * xe_gt_sriov_pf_restart - Restart SR-IOV support after a GT reset.
  * @gt: the &xe_gt
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
index f0cb726a6919f..96fab779a906f 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
@@ -11,6 +11,7 @@ struct xe_gt;
 #ifdef CONFIG_PCI_IOV
 int xe_gt_sriov_pf_init_early(struct xe_gt *gt);
 void xe_gt_sriov_pf_init_hw(struct xe_gt *gt);
+void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid);
 void xe_gt_sriov_pf_restart(struct xe_gt *gt);
 #else
 static inline int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
index 02f7328bd6cea..b4fd5a81aff1f 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
@@ -9,6 +9,7 @@
 
 #include "xe_device.h"
 #include "xe_gt.h"
+#include "xe_gt_sriov_pf.h"
 #include "xe_gt_sriov_pf_config.h"
 #include "xe_gt_sriov_pf_control.h"
 #include "xe_gt_sriov_pf_helpers.h"
@@ -1008,7 +1009,7 @@ static bool pf_exit_vf_flr_reset_mmio(struct xe_gt *gt, unsigned int vfid)
 	if (!pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_FLR_RESET_MMIO))
 		return false;
 
-	/* XXX: placeholder */
+	xe_gt_sriov_pf_sanitize_hw(gt, vfid);
 
 	pf_enter_vf_flr_send_finish(gt, vfid);
 	return true;
-- 
2.39.5



