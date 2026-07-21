Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5A5471259;
	Tue, 21 Jul 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657516; cv=none; b=HX1keXLaSYm0WxPdWvEymlGCiLHQdDQLfWMjQ6xaVEQkMNquMbzFLkRv//mwa5fi7AFpuVgVTgbvGWtMTw6ay4QVb4h7dnrFIN4MbFaesoeqvqJscDOAt74/+Jf+rc0e2VAOlmV833qe6Xawnze6SYfKIAqgwlQc9SBbtWa7tJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657516; c=relaxed/simple;
	bh=KvaLaHtPxA7f2pEJ1OIuEU7Y9kdCKSIvW1wvNM4ousA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwG5Vz1FwFtKSHYbns/EH6O9hdRfsJhgzpBnmQcGOMQLu2XvycHITaE5b7UTEcADDwFOa7tAmgkgDM1BL0go7iBRO3AHsmUhuX0+crcyPrEeROny3d3pCSASiQsQKmoCJlP1rncH4TaFLBPy/HOAt1k0xwsAEEaMTRSL36yXPwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVw9jivS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVw9jivS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AA61F00A3A;
	Tue, 21 Jul 2026 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657515;
	bh=MIzdwC1uyIVVkDpuAIPgx1LCwlYBJoY1Ld6s1nI4fT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVw9jivSZ69nbFMEQt9cvmCuwCay6NPP3pDQ5yCcs7bum2vFtyll5V/laFXs4IRqw
	 FTR6jYh3fv1OEjLBDa9lBqTjU3yIfHk/YTZ9ynZgAEKERxPR370w5fblGLcNMT+dzn
	 Rku8fcQc4pFycIHS9VUQDQ2iPpyrznoPdLvkB7AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0751/1611] i3c: mipi-i3c-hci: Allow for Multi-Bus Instances
Date: Tue, 21 Jul 2026 17:14:27 +0200
Message-ID: <20260721152532.266349540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b8460480f62e16751876a1f367dc14fb62867463 ]

Add support for MIPI I3C Host Controllers with the Multi-Bus Instance
capability.  These controllers can host multiple I3C buses (up to 15)
within a single hardware function (e.g., PCIe B/D/F), providing one
indepedent HCI register set and corresponding I3C bus controller logic
per bus.

A separate platform device will represent each instance, but it is
necessary to allow for shared resources.

Multi-bus instances share the same MMIO address space, but the ranges are
not guaranteed to be contiguous. To avoid overlapping mappings, pass
base_regs from the parent mapping to child devices.

Allow the IRQ to be shared among instances.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260106164416.67074-8-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 093eb8e73c90 ("i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c     | 21 +++++++++++++++++----
 include/linux/platform_data/mipi-i3c-hci.h | 15 +++++++++++++++
 2 files changed, 32 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/platform_data/mipi-i3c-hci.h

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 6d8a00486ba62b..75e6610cfd8129 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
+#include <linux/platform_data/mipi-i3c-hci.h>
 #include <linux/platform_device.h>
 
 #include "hci.h"
@@ -742,15 +743,27 @@ static int i3c_hci_init(struct i3c_hci *hci)
 
 static int i3c_hci_probe(struct platform_device *pdev)
 {
+	const struct mipi_i3c_hci_platform_data *pdata = pdev->dev.platform_data;
 	struct i3c_hci *hci;
 	int irq, ret;
 
 	hci = devm_kzalloc(&pdev->dev, sizeof(*hci), GFP_KERNEL);
 	if (!hci)
 		return -ENOMEM;
-	hci->base_regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(hci->base_regs))
-		return PTR_ERR(hci->base_regs);
+
+	/*
+	 * Multi-bus instances share the same MMIO address range, but not
+	 * necessarily in separate contiguous sub-ranges. To avoid overlapping
+	 * mappings, provide base_regs from the parent mapping.
+	 */
+	if (pdata)
+		hci->base_regs = pdata->base_regs;
+
+	if (!hci->base_regs) {
+		hci->base_regs = devm_platform_ioremap_resource(pdev, 0);
+		if (IS_ERR(hci->base_regs))
+			return PTR_ERR(hci->base_regs);
+	}
 
 	platform_set_drvdata(pdev, hci);
 	/* temporary for dev_printk's, to be replaced in i3c_master_register */
@@ -764,7 +777,7 @@ static int i3c_hci_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, irq, i3c_hci_irq_handler,
-			       0, NULL, hci);
+			       IRQF_SHARED, NULL, hci);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/platform_data/mipi-i3c-hci.h b/include/linux/platform_data/mipi-i3c-hci.h
new file mode 100644
index 00000000000000..ab7395f455f942
--- /dev/null
+++ b/include/linux/platform_data/mipi-i3c-hci.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef INCLUDE_PLATFORM_DATA_MIPI_I3C_HCI_H
+#define INCLUDE_PLATFORM_DATA_MIPI_I3C_HCI_H
+
+#include <linux/compiler_types.h>
+
+/**
+ * struct mipi_i3c_hci_platform_data - Platform-dependent data for mipi_i3c_hci
+ * @base_regs: Register set base address (to support multi-bus instances)
+ */
+struct mipi_i3c_hci_platform_data {
+	void __iomem *base_regs;
+};
+
+#endif
-- 
2.53.0



