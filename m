Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD21BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0A6C433C8;
	Mon, 19 Jun 2023 10:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172263;
	bh=iB0w+YAroKzDCm750u+E4FwTebo86LQPGM8HLpRqP/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYH8Uti9EPKzHb4jKAUJY6PAS2u6uqU+zYMw7npMCLagDWvXZOgXHsIUBKtnTQhRG
	 oniCmzXzHG5ZktJ8HzTM7aNSyZD4rcdPemcv6o+I89tKAsqJTXzMQg3isaAFHiXVWR
	 r0J4o2eTL7G4jWV2hiGwfT1/PjNGCHOr2Zd8hAF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Henning Schild <henning.schild@siemens.com>
Subject: [PATCH 5.10 88/89] drm/i915/gen11+: Only load DRAM information from pcode
Date: Mon, 19 Jun 2023 12:31:16 +0200
Message-ID: <20230619102142.299853583@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 5d0c938ec9cc96fc7b8abcff0ca8b2a084e9c90c ]

Up to now we were reading some DRAM information from MCHBAR register
and from pcode what is already not good but some GEN12(TGL-H and ADL-S)
platforms have MCHBAR DRAM information in different offsets.

This was notified to HW team that decided that the best alternative is
always apply the 16gb_dimm watermark adjustment for GEN12+ platforms
and read the remaning DRAM information needed to other display
programming from pcode.

So here moving the DRAM pcode function to intel_dram.c, removing
the duplicated fields from intel_qgv_info, setting and using
information from dram_info.

v2:
- bring back num_points to intel_qgv_info as num_qgv_point can be
overwritten in icl_get_qgv_points()
- add gen12_get_dram_info() and simplify gen11_get_dram_info()

Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210128164312.91160-2-jose.souza@intel.com
Signed-off-by: Henning Schild <henning.schild@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bw.c |   80 +++----------------------------
 drivers/gpu/drm/i915/i915_drv.c         |    5 +
 drivers/gpu/drm/i915/i915_drv.h         |    1 
 drivers/gpu/drm/i915/intel_dram.c       |   82 +++++++++++++++++++++++++++++++-
 4 files changed, 93 insertions(+), 75 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -20,76 +20,9 @@ struct intel_qgv_point {
 struct intel_qgv_info {
 	struct intel_qgv_point points[I915_NUM_QGV_POINTS];
 	u8 num_points;
-	u8 num_channels;
 	u8 t_bl;
-	enum intel_dram_type dram_type;
 };
 
-static int icl_pcode_read_mem_global_info(struct drm_i915_private *dev_priv,
-					  struct intel_qgv_info *qi)
-{
-	u32 val = 0;
-	int ret;
-
-	ret = sandybridge_pcode_read(dev_priv,
-				     ICL_PCODE_MEM_SUBSYSYSTEM_INFO |
-				     ICL_PCODE_MEM_SS_READ_GLOBAL_INFO,
-				     &val, NULL);
-	if (ret)
-		return ret;
-
-	if (IS_GEN(dev_priv, 12)) {
-		switch (val & 0xf) {
-		case 0:
-			qi->dram_type = INTEL_DRAM_DDR4;
-			break;
-		case 3:
-			qi->dram_type = INTEL_DRAM_LPDDR4;
-			break;
-		case 4:
-			qi->dram_type = INTEL_DRAM_DDR3;
-			break;
-		case 5:
-			qi->dram_type = INTEL_DRAM_LPDDR3;
-			break;
-		default:
-			MISSING_CASE(val & 0xf);
-			break;
-		}
-	} else if (IS_GEN(dev_priv, 11)) {
-		switch (val & 0xf) {
-		case 0:
-			qi->dram_type = INTEL_DRAM_DDR4;
-			break;
-		case 1:
-			qi->dram_type = INTEL_DRAM_DDR3;
-			break;
-		case 2:
-			qi->dram_type = INTEL_DRAM_LPDDR3;
-			break;
-		case 3:
-			qi->dram_type = INTEL_DRAM_LPDDR4;
-			break;
-		default:
-			MISSING_CASE(val & 0xf);
-			break;
-		}
-	} else {
-		MISSING_CASE(INTEL_GEN(dev_priv));
-		qi->dram_type = INTEL_DRAM_LPDDR3; /* Conservative default */
-	}
-
-	qi->num_channels = (val & 0xf0) >> 4;
-	qi->num_points = (val & 0xf00) >> 8;
-
-	if (IS_GEN(dev_priv, 12))
-		qi->t_bl = qi->dram_type == INTEL_DRAM_DDR4 ? 4 : 16;
-	else if (IS_GEN(dev_priv, 11))
-		qi->t_bl = qi->dram_type == INTEL_DRAM_DDR4 ? 4 : 8;
-
-	return 0;
-}
-
 static int icl_pcode_read_qgv_point_info(struct drm_i915_private *dev_priv,
 					 struct intel_qgv_point *sp,
 					 int point)
@@ -139,11 +72,15 @@ int icl_pcode_restrict_qgv_points(struct
 static int icl_get_qgv_points(struct drm_i915_private *dev_priv,
 			      struct intel_qgv_info *qi)
 {
+	const struct dram_info *dram_info = &dev_priv->dram_info;
 	int i, ret;
 
-	ret = icl_pcode_read_mem_global_info(dev_priv, qi);
-	if (ret)
-		return ret;
+	qi->num_points = dram_info->num_qgv_points;
+
+	if (IS_GEN(dev_priv, 12))
+		qi->t_bl = dev_priv->dram_info.type == INTEL_DRAM_DDR4 ? 4 : 16;
+	else if (IS_GEN(dev_priv, 11))
+		qi->t_bl = dev_priv->dram_info.type == INTEL_DRAM_DDR4 ? 4 : 8;
 
 	if (drm_WARN_ON(&dev_priv->drm,
 			qi->num_points > ARRAY_SIZE(qi->points)))
@@ -209,7 +146,7 @@ static int icl_get_bw_info(struct drm_i9
 {
 	struct intel_qgv_info qi = {};
 	bool is_y_tile = true; /* assume y tile may be used */
-	int num_channels;
+	int num_channels = dev_priv->dram_info.num_channels;
 	int deinterleave;
 	int ipqdepth, ipqdepthpch;
 	int dclk_max;
@@ -222,7 +159,6 @@ static int icl_get_bw_info(struct drm_i9
 			    "Failed to get memory subsystem information, ignoring bandwidth limits");
 		return ret;
 	}
-	num_channels = qi.num_channels;
 
 	deinterleave = DIV_ROUND_UP(num_channels, is_y_tile ? 4 : 2);
 	dclk_max = icl_sagv_max_dclk(&qi);
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -609,14 +609,15 @@ static int i915_driver_hw_probe(struct d
 		goto err_msi;
 
 	intel_opregion_setup(dev_priv);
+
+	intel_pcode_init(dev_priv);
+
 	/*
 	 * Fill the dram structure to get the system raw bandwidth and
 	 * dram info. This will be used for memory latency calculation.
 	 */
 	intel_dram_detect(dev_priv);
 
-	intel_pcode_init(dev_priv);
-
 	intel_bw_init_hw(dev_priv);
 
 	return 0;
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1148,6 +1148,7 @@ struct drm_i915_private {
 			INTEL_DRAM_LPDDR3,
 			INTEL_DRAM_LPDDR4
 		} type;
+		u8 num_qgv_points;
 	} dram_info;
 
 	struct intel_bw_info {
--- a/drivers/gpu/drm/i915/intel_dram.c
+++ b/drivers/gpu/drm/i915/intel_dram.c
@@ -5,6 +5,7 @@
 
 #include "i915_drv.h"
 #include "intel_dram.h"
+#include "intel_sideband.h"
 
 struct dram_dimm_info {
 	u8 size, width, ranks;
@@ -433,6 +434,81 @@ static int bxt_get_dram_info(struct drm_
 	return 0;
 }
 
+static int icl_pcode_read_mem_global_info(struct drm_i915_private *dev_priv)
+{
+	struct dram_info *dram_info = &dev_priv->dram_info;
+	u32 val = 0;
+	int ret;
+
+	ret = sandybridge_pcode_read(dev_priv,
+				     ICL_PCODE_MEM_SUBSYSYSTEM_INFO |
+				     ICL_PCODE_MEM_SS_READ_GLOBAL_INFO,
+				     &val, NULL);
+	if (ret)
+		return ret;
+
+	if (IS_GEN(dev_priv, 12)) {
+		switch (val & 0xf) {
+		case 0:
+			dram_info->type = INTEL_DRAM_DDR4;
+			break;
+		case 3:
+			dram_info->type = INTEL_DRAM_LPDDR4;
+			break;
+		case 4:
+			dram_info->type = INTEL_DRAM_DDR3;
+			break;
+		case 5:
+			dram_info->type = INTEL_DRAM_LPDDR3;
+			break;
+		default:
+			MISSING_CASE(val & 0xf);
+			return -1;
+		}
+	} else {
+		switch (val & 0xf) {
+		case 0:
+			dram_info->type = INTEL_DRAM_DDR4;
+			break;
+		case 1:
+			dram_info->type = INTEL_DRAM_DDR3;
+			break;
+		case 2:
+			dram_info->type = INTEL_DRAM_LPDDR3;
+			break;
+		case 3:
+			dram_info->type = INTEL_DRAM_LPDDR4;
+			break;
+		default:
+			MISSING_CASE(val & 0xf);
+			return -1;
+		}
+	}
+
+	dram_info->num_channels = (val & 0xf0) >> 4;
+	dram_info->num_qgv_points = (val & 0xf00) >> 8;
+
+	return 0;
+}
+
+static int gen11_get_dram_info(struct drm_i915_private *i915)
+{
+	int ret = skl_get_dram_info(i915);
+
+	if (ret)
+		return ret;
+
+	return icl_pcode_read_mem_global_info(i915);
+}
+
+static int gen12_get_dram_info(struct drm_i915_private *i915)
+{
+	/* Always needed for GEN12+ */
+	i915->dram_info.is_16gb_dimm = true;
+
+	return icl_pcode_read_mem_global_info(i915);
+}
+
 void intel_dram_detect(struct drm_i915_private *i915)
 {
 	struct dram_info *dram_info = &i915->dram_info;
@@ -448,7 +524,11 @@ void intel_dram_detect(struct drm_i915_p
 	if (INTEL_GEN(i915) < 9 || !HAS_DISPLAY(i915))
 		return;
 
-	if (IS_GEN9_LP(i915))
+	if (INTEL_GEN(i915) >= 12)
+		ret = gen12_get_dram_info(i915);
+	else if (INTEL_GEN(i915) >= 11)
+		ret = gen11_get_dram_info(i915);
+	else if (IS_GEN9_LP(i915))
 		ret = bxt_get_dram_info(i915);
 	else
 		ret = skl_get_dram_info(i915);


