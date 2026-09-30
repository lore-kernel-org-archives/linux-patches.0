Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA30502D5A;
	Wed, 30 Sep 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792292; cv=none; b=CGXfD1L1QWRjDRwqB3aITaDbQ9U8ebpWStmX6HPIpihpN9+uVTWRYgyziED8lOuetP6zJe7tYOIY4lizZKcFlYRb9RKJEJYU5l4h3PFyw9xiNleSy3o6BV+Wc+0gwd75BDNg9x6sXWqOszddZVvSjjXPm1MisIXYRbNJfkchnz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792292; c=relaxed/simple;
	bh=2QoDAN+hGh/wRBkvctGlUuzMcLYB2UfurQAJesgM1wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWwwmGUqlg1g98M286tNuxlbkmG2uOBhLKujx5BiMDyekX2QcvmNj2viobyxourfMUFfS/tkAREDcx3amL3heLs40cPTspElPT+rHjNiib20tIFhl/ZRpflY/7tjIpt4t/Ai4CixV3lcVZAb8Dz2VMNC80yjEExzcZOT453f07Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhZ9hfxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhZ9hfxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714421F000FF;
	Wed, 30 Sep 2026 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792291;
	bh=g+EZfas4OshAeV7UEM2VFi5bfkmtsT8IAGMjRYGYhsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhZ9hfxfoULm9SYZFZOttjBq4Xj7Rn5BkROROu35Cfk3WqXAC9RUugvp44hMbzKrQ
	 df9utDKtk87fvYIkrdhtlbxEmr/xcXpyRenFKQGwRcg7AMD5p1i3xZir8DLOBaW4Cd
	 3lD+ca3GqQWOHzZOOuj3/3td1bbupyfKm2mbscCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 601/752] HID: amd_sfh: Move common macros and structures
Date: Wed, 30 Sep 2026 17:27:51 +0200
Message-ID: <20260930152411.289468385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 6947f312e5055f64cbcf227fb8c0ab9648473794 ]

Introduce common macros and structures to support multiple generations
of AMD SOCs, move them to amd_sfh_common.h.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 65bcc5f89704 ("HID: amd_sfh: Validate PCI BAR size before mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_common.h | 59 ++++++++++++++++++++++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h   | 42 +----------------
 2 files changed, 60 insertions(+), 41 deletions(-)
 create mode 100644 drivers/hid/amd-sfh-hid/amd_sfh_common.h

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
new file mode 100644
index 0000000000000..40da53d5efd04
--- /dev/null
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * AMD MP2 common macros and structures
+ *
+ * Copyright (c) 2022, Advanced Micro Devices, Inc.
+ * All Rights Reserved.
+ *
+ * Author: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
+ */
+#ifndef AMD_SFH_COMMON_H
+#define AMD_SFH_COMMON_H
+
+#include <linux/pci.h>
+#include "amd_sfh_hid.h"
+
+#define PCI_DEVICE_ID_AMD_MP2		0x15E4
+
+#define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
+#define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
+
+#define SENSOR_ENABLED			4
+#define SENSOR_DISABLED			5
+
+#define AMD_SFH_IDLE_LOOP		200
+
+enum cmd_id {
+	NO_OP,
+	ENABLE_SENSOR,
+	DISABLE_SENSOR,
+	STOP_ALL_SENSORS = 8,
+};
+
+struct amd_mp2_sensor_info {
+	u8 sensor_idx;
+	u32 period;
+	dma_addr_t dma_address;
+};
+
+struct amd_mp2_dev {
+	struct pci_dev *pdev;
+	struct amdtp_cl_data *cl_data;
+	void __iomem *mmio;
+	const struct amd_mp2_ops *mp2_ops;
+	struct amd_input_data in_data;
+	/* mp2 active control status */
+	u32 mp2_acs;
+};
+
+struct amd_mp2_ops {
+	void (*start)(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info);
+	void (*stop)(struct amd_mp2_dev *privdata, u16 sensor_idx);
+	void (*stop_all)(struct amd_mp2_dev *privdata);
+	int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
+	void (*clear_intr)(struct amd_mp2_dev *privdata);
+	int (*init_intr)(struct amd_mp2_dev *privdata);
+	int (*discovery_status)(struct amd_mp2_dev *privdata);
+};
+
+#endif
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 90f39bfe8050e..fd6c7a322d47c 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -9,35 +9,20 @@
 #ifndef PCIE_MP2_AMD_H
 #define PCIE_MP2_AMD_H
 
-#include <linux/pci.h>
-#include "amd_sfh_hid.h"
-
-#define PCI_DEVICE_ID_AMD_MP2	0x15E4
-
-#define ENABLE_SENSOR		1
-#define DISABLE_SENSOR		2
-#define STOP_ALL_SENSORS	8
+#include "amd_sfh_common.h"
 
 /* MP2 C2P Message Registers */
 #define AMD_C2P_MSG0	0x10500
 #define AMD_C2P_MSG1	0x10504
 #define AMD_C2P_MSG2	0x10508
 
-#define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
-#define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
-
 /* MP2 P2C Message Registers */
 #define AMD_P2C_MSG3	0x1068C /* Supported Sensors info */
 
 #define V2_STATUS	0x2
 
-#define SENSOR_ENABLED     4
-#define SENSOR_DISABLED    5
-
 #define HPD_IDX		16
 
-#define AMD_SFH_IDLE_LOOP	200
-
 #define SENSOR_DISCOVERY_STATUS_MASK		GENMASK(5, 3)
 #define SENSOR_DISCOVERY_STATUS_SHIFT		3
 
@@ -95,22 +80,6 @@ enum sensor_idx {
 	als_idx = 19
 };
 
-struct amd_mp2_dev {
-	struct pci_dev *pdev;
-	struct amdtp_cl_data *cl_data;
-	void __iomem *mmio;
-	const struct amd_mp2_ops *mp2_ops;
-	struct amd_input_data in_data;
-	/* mp2 active control status */
-	u32 mp2_acs;
-};
-
-struct amd_mp2_sensor_info {
-	u8 sensor_idx;
-	u32 period;
-	dma_addr_t dma_address;
-};
-
 enum mem_use_type {
 	USE_DRAM,
 	USE_C2P_REG,
@@ -138,13 +107,4 @@ u32 amd_sfh_wait_for_response(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
 void amd_mp2_suspend(struct amd_mp2_dev *mp2);
 void amd_mp2_resume(struct amd_mp2_dev *mp2);
 
-struct amd_mp2_ops {
-	 void (*start)(struct amd_mp2_dev *privdata, struct amd_mp2_sensor_info info);
-	 void (*stop)(struct amd_mp2_dev *privdata, u16 sensor_idx);
-	 void (*stop_all)(struct amd_mp2_dev *privdata);
-	 int (*response)(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_sts);
-	 void (*clear_intr)(struct amd_mp2_dev *privdata);
-	 int (*init_intr)(struct amd_mp2_dev *privdata);
-	 int (*discovery_status)(struct amd_mp2_dev *privdata);
-};
 #endif
-- 
2.53.0



