Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C678470838;
	Mon, 23 Jun 2025 21:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712851; cv=none; b=MOIhdsenOrWS8n7a+cCam47sbnwZSdHunA8CnQ1D5Mlzxlu5iCe+9xe9gPVXDFoAxFQ0rb5YJaL7sd9vzmX9Q79JAfyVMwPJPe0WkbSRliqJr7SET9jzWjM3Z0Ki2KltMJbDYD9o528IA9VZuipZ5U3CMDW3QI46X4eEYZbYYBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712851; c=relaxed/simple;
	bh=sEQ1AuJZ7cHIfvj+zxbwP6jD8sFyMEPOwu88r4tsShU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOHA+tkC/10UH1mG1IwSMUOfJUdLmGlTsMRQbOu2R3GGAzUH0wtuy4Bd2DIVF0AWLNzUdMiHWYIRwD3OejGplSDUECzK/Xj401PQ8/ZGo08FTxGIInGop0iFzKfHlV6hx7XX9AyheoHTU1ATXfiLtUwy+/nUqnbDT7DwSz4fPlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dy8N4JyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dy8N4JyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60661C4CEEA;
	Mon, 23 Jun 2025 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712851;
	bh=sEQ1AuJZ7cHIfvj+zxbwP6jD8sFyMEPOwu88r4tsShU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dy8N4JyFjNbvRkTtfOblabB8hVJWxFwJQ/ktW+/MsT1Q1XYKRbJ2boyvDe5h2js6Y
	 Vy2IZS1HZziBXIIJsBKNF4pTFlN4NNzt41Qajt5y32wlZMt/UFQNdmhZnVkpseNdjk
	 o3jhS3M5YaqOtWRbX66fr9LxSjF8m5J1W4GbEIww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 297/592] drm/amd/display: Restructure DMI quirks
Date: Mon, 23 Jun 2025 15:04:15 +0200
Message-ID: <20250623130707.448721352@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit de6485e3df24170d71706d6f2c55a496443c3803 ]

[Why]
DMI quirks are relatively big code that makes amdgpu_dm 200 lines
larger.

[How]
Move DMI quirks into a dedicated source file and make all quirks
variables for `struct amdgpu_display_manager`.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/Makefile    |   1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 152 +--------------
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |   9 +
 .../amd/display/amdgpu_dm/amdgpu_dm_quirks.c  | 178 ++++++++++++++++++
 4 files changed, 191 insertions(+), 149 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile b/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile
index ab2a97e354da1..7329b8cc2576e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/Makefile
@@ -38,6 +38,7 @@ AMDGPUDM = \
 	amdgpu_dm_pp_smu.o \
 	amdgpu_dm_psr.o \
 	amdgpu_dm_replay.o \
+	amdgpu_dm_quirks.o \
 	amdgpu_dm_wb.o
 
 ifdef CONFIG_DRM_AMD_DC_FP
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d6214fc3921de..96118a0e1ffeb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -80,7 +80,6 @@
 #include <linux/power_supply.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
-#include <linux/dmi.h>
 #include <linux/sort.h>
 
 #include <drm/display/drm_dp_mst_helper.h>
@@ -1631,153 +1630,6 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
 	return false;
 }
 
-struct amdgpu_dm_quirks {
-	bool aux_hpd_discon;
-	bool support_edp0_on_dp1;
-};
-
-static struct amdgpu_dm_quirks quirk_entries = {
-	.aux_hpd_discon = false,
-	.support_edp0_on_dp1 = false
-};
-
-static int edp0_on_dp1_callback(const struct dmi_system_id *id)
-{
-	quirk_entries.support_edp0_on_dp1 = true;
-	return 0;
-}
-
-static int aux_hpd_discon_callback(const struct dmi_system_id *id)
-{
-	quirk_entries.aux_hpd_discon = true;
-	return 0;
-}
-
-static const struct dmi_system_id dmi_quirk_table[] = {
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
-		},
-	},
-	{
-		.callback = aux_hpd_discon_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite mt645 G8 Mobile Thin Client"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 645 14 inch G11 Notebook PC"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 665 16 inch G11 Notebook PC"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 445 14 inch G11 Notebook PC"),
-		},
-	},
-	{
-		.callback = edp0_on_dp1_callback,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 465 16 inch G11 Notebook PC"),
-		},
-	},
-	{}
-	/* TODO: refactor this from a fixed table to a dynamic option */
-};
-
-static void retrieve_dmi_info(struct amdgpu_display_manager *dm, struct dc_init_data *init_data)
-{
-	int dmi_id;
-	struct drm_device *dev = dm->ddev;
-
-	dm->aux_hpd_discon_quirk = false;
-	init_data->flags.support_edp0_on_dp1 = false;
-
-	dmi_id = dmi_check_system(dmi_quirk_table);
-
-	if (!dmi_id)
-		return;
-
-	if (quirk_entries.aux_hpd_discon) {
-		dm->aux_hpd_discon_quirk = true;
-		drm_info(dev, "aux_hpd_discon_quirk attached\n");
-	}
-	if (quirk_entries.support_edp0_on_dp1) {
-		init_data->flags.support_edp0_on_dp1 = true;
-		drm_info(dev, "support_edp0_on_dp1 attached\n");
-	}
-}
 
 void*
 dm_allocate_gpu_mem(
@@ -2064,7 +1916,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (amdgpu_ip_version(adev, DCE_HWIP, 0) >= IP_VERSION(3, 0, 0))
 		init_data.num_virtual_links = 1;
 
-	retrieve_dmi_info(&adev->dm, &init_data);
+	retrieve_dmi_info(&adev->dm);
+	if (adev->dm.edp0_on_dp1_quirk)
+		init_data.flags.support_edp0_on_dp1 = true;
 
 	if (adev->dm.bb_from_dmub)
 		init_data.bb_from_dmub = adev->dm.bb_from_dmub;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 385faaca6e26a..9e8c659c53c49 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -613,6 +613,13 @@ struct amdgpu_display_manager {
 	 */
 	bool aux_hpd_discon_quirk;
 
+	/**
+	 * @edp0_on_dp1_quirk:
+	 *
+	 * quirk for platforms that put edp0 on DP1.
+	 */
+	bool edp0_on_dp1_quirk;
+
 	/**
 	 * @dpia_aux_lock:
 	 *
@@ -1045,4 +1052,6 @@ void hdmi_cec_set_edid(struct amdgpu_dm_connector *aconnector);
 void hdmi_cec_unset_edid(struct amdgpu_dm_connector *aconnector);
 int amdgpu_dm_initialize_hdmi_connector(struct amdgpu_dm_connector *aconnector);
 
+void retrieve_dmi_info(struct amdgpu_display_manager *dm);
+
 #endif /* __AMDGPU_DM_H__ */
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c
new file mode 100644
index 0000000000000..1da07ebf9217c
--- /dev/null
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_quirks.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright 2025 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: AMD
+ *
+ */
+
+#include <linux/dmi.h>
+
+#include "amdgpu.h"
+#include "amdgpu_dm.h"
+
+struct amdgpu_dm_quirks {
+	bool aux_hpd_discon;
+	bool support_edp0_on_dp1;
+};
+
+static struct amdgpu_dm_quirks quirk_entries = {
+	.aux_hpd_discon = false,
+	.support_edp0_on_dp1 = false
+};
+
+static int edp0_on_dp1_callback(const struct dmi_system_id *id)
+{
+	quirk_entries.support_edp0_on_dp1 = true;
+	return 0;
+}
+
+static int aux_hpd_discon_callback(const struct dmi_system_id *id)
+{
+	quirk_entries.aux_hpd_discon = true;
+	return 0;
+}
+
+static const struct dmi_system_id dmi_quirk_table[] = {
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
+		},
+	},
+	{
+		.callback = aux_hpd_discon_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite mt645 G8 Mobile Thin Client"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 645 14 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 665 16 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 445 14 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 465 16 inch G11 Notebook PC"),
+		},
+	},
+	{}
+	/* TODO: refactor this from a fixed table to a dynamic option */
+};
+
+void retrieve_dmi_info(struct amdgpu_display_manager *dm)
+{
+	struct drm_device *dev = dm->ddev;
+	int dmi_id;
+
+	dm->aux_hpd_discon_quirk = false;
+	dm->edp0_on_dp1_quirk = false;
+
+	dmi_id = dmi_check_system(dmi_quirk_table);
+
+	if (!dmi_id)
+		return;
+
+	if (quirk_entries.aux_hpd_discon) {
+		dm->aux_hpd_discon_quirk = true;
+		drm_info(dev, "aux_hpd_discon_quirk attached\n");
+	}
+	if (quirk_entries.support_edp0_on_dp1) {
+		dm->edp0_on_dp1_quirk = true;
+		drm_info(dev, "support_edp0_on_dp1 attached\n");
+	}
+}
-- 
2.39.5



