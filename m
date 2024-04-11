Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AEB146A70;
	Thu, 11 Apr 2024 10:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831615; cv=none; b=heiAezqdOieE2CsY8q6n3VKkXyxN2+/7oEbS26OnXMeFxW7w+iFWriLA6Ddv4D9qPfU2pbczR7Xurvb52MM50OQz6BaSYEccl6b7L9qg0xk26RfKy8Nr3sAZHgFE7aoZAt2yo+jFQJE1ggLHCXuHvBjItX0TBQo7PTuSomMuZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831615; c=relaxed/simple;
	bh=sYBQN6cihXMvigJ+v+vlhZfWMRU0ux88S46Um+vm6WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibN9GDZOxHggqU86jLpub8qAYEjGpynQvJ9VMvCaGocGZZeTGAGZ2OyGuJ0qxzJ36y1yNNNadipqZ9cdhCRTUIrIl8nh+CW6Q7Z4KDkWtb0nmhHy+V+K+PMmDmctcqHqbiDjzL5LYjnvIg/dCpc+zRRjtpWXkpfTZuxyK6Nercs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEhYA5l1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEhYA5l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA37C433F1;
	Thu, 11 Apr 2024 10:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831615;
	bh=sYBQN6cihXMvigJ+v+vlhZfWMRU0ux88S46Um+vm6WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEhYA5l1tyLiWfop+BxG7wtwyY93+KLjL6bql7EsMZQk3Ih4hLXAFHYRpkvjx4pqs
	 O5NrNQ0OwurBy5sx1MUsr7v8Pn8UCrTLFAqivHmfiLLBQ9STOWy1nbQpRkuEuyyTov
	 kSyQkyBL+OhsY7Pokftf3Ngg4P5kEDzy/YtygSBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sean V Kelley <sean.v.kelley@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/294] PCI/ERR: Cache RCEC EA Capability offset in pci_init_capabilities()
Date: Thu, 11 Apr 2024 11:53:44 +0200
Message-ID: <20240411095437.476324683@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean V Kelley <sean.v.kelley@intel.com>

[ Upstream commit 90655631988f8f501529e6de5f13614389717ead ]

Extend support for Root Complex Event Collectors by decoding and caching
the RCEC Endpoint Association Extended Capabilities when enumerating. Use
that cached information for later error source reporting. See PCIe r5.0,
sec 7.9.10.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://lore.kernel.org/r/20201121001036.8560-4-sean.v.kelley@intel.com
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h         | 17 +++++++++++
 drivers/pci/pcie/Makefile |  2 +-
 drivers/pci/pcie/rcec.c   | 59 +++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c       |  2 ++
 include/linux/pci.h       |  4 +++
 5 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pci/pcie/rcec.c

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 32fa07bfc448e..da40f29036d65 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -442,6 +442,15 @@ int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info);
 void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
 #endif	/* CONFIG_PCIEAER */
 
+#ifdef CONFIG_PCIEPORTBUS
+/* Cached RCEC Endpoint Association */
+struct rcec_ea {
+	u8		nextbusn;
+	u8		lastbusn;
+	u32		bitmap;
+};
+#endif
+
 #ifdef CONFIG_PCIE_DPC
 void pci_save_dpc_state(struct pci_dev *dev);
 void pci_restore_dpc_state(struct pci_dev *dev);
@@ -456,6 +465,14 @@ static inline void pci_dpc_init(struct pci_dev *pdev) {}
 static inline bool pci_dpc_recovered(struct pci_dev *pdev) { return false; }
 #endif
 
+#ifdef CONFIG_PCIEPORTBUS
+void pci_rcec_init(struct pci_dev *dev);
+void pci_rcec_exit(struct pci_dev *dev);
+#else
+static inline void pci_rcec_init(struct pci_dev *dev) {}
+static inline void pci_rcec_exit(struct pci_dev *dev) {}
+#endif
+
 #ifdef CONFIG_PCI_ATS
 /* Address Translation Service */
 void pci_ats_init(struct pci_dev *dev);
diff --git a/drivers/pci/pcie/Makefile b/drivers/pci/pcie/Makefile
index 9a7085668466f..b2980db88cc09 100644
--- a/drivers/pci/pcie/Makefile
+++ b/drivers/pci/pcie/Makefile
@@ -2,7 +2,7 @@
 #
 # Makefile for PCI Express features and port driver
 
-pcieportdrv-y			:= portdrv_core.o portdrv_pci.o err.o
+pcieportdrv-y			:= portdrv_core.o portdrv_pci.o err.o rcec.o
 
 obj-$(CONFIG_PCIEPORTBUS)	+= pcieportdrv.o
 
diff --git a/drivers/pci/pcie/rcec.c b/drivers/pci/pcie/rcec.c
new file mode 100644
index 0000000000000..038e9d706d5fd
--- /dev/null
+++ b/drivers/pci/pcie/rcec.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Root Complex Event Collector Support
+ *
+ * Authors:
+ *  Sean V Kelley <sean.v.kelley@intel.com>
+ *  Qiuxu Zhuo <qiuxu.zhuo@intel.com>
+ *
+ * Copyright (C) 2020 Intel Corp.
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+
+#include "../pci.h"
+
+void pci_rcec_init(struct pci_dev *dev)
+{
+	struct rcec_ea *rcec_ea;
+	u32 rcec, hdr, busn;
+	u8 ver;
+
+	/* Only for Root Complex Event Collectors */
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_RC_EC)
+		return;
+
+	rcec = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_RCEC);
+	if (!rcec)
+		return;
+
+	rcec_ea = kzalloc(sizeof(*rcec_ea), GFP_KERNEL);
+	if (!rcec_ea)
+		return;
+
+	pci_read_config_dword(dev, rcec + PCI_RCEC_RCIEP_BITMAP,
+			      &rcec_ea->bitmap);
+
+	/* Check whether RCEC BUSN register is present */
+	pci_read_config_dword(dev, rcec, &hdr);
+	ver = PCI_EXT_CAP_VER(hdr);
+	if (ver >= PCI_RCEC_BUSN_REG_VER) {
+		pci_read_config_dword(dev, rcec + PCI_RCEC_BUSN, &busn);
+		rcec_ea->nextbusn = PCI_RCEC_BUSN_NEXT(busn);
+		rcec_ea->lastbusn = PCI_RCEC_BUSN_LAST(busn);
+	} else {
+		/* Avoid later ver check by setting nextbusn */
+		rcec_ea->nextbusn = 0xff;
+		rcec_ea->lastbusn = 0x00;
+	}
+
+	dev->rcec_ea = rcec_ea;
+}
+
+void pci_rcec_exit(struct pci_dev *dev)
+{
+	kfree(dev->rcec_ea);
+	dev->rcec_ea = NULL;
+}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ece90a23936d2..ab106d2a99479 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2216,6 +2216,7 @@ static void pci_configure_device(struct pci_dev *dev)
 static void pci_release_capabilities(struct pci_dev *dev)
 {
 	pci_aer_exit(dev);
+	pci_rcec_exit(dev);
 	pci_vpd_release(dev);
 	pci_iov_release(dev);
 	pci_free_cap_save_buffers(dev);
@@ -2416,6 +2417,7 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	pci_ptm_init(dev);		/* Precision Time Measurement */
 	pci_aer_init(dev);		/* Advanced Error Reporting */
 	pci_dpc_init(dev);		/* Downstream Port Containment */
+	pci_rcec_init(dev);		/* Root Complex Event Collector */
 
 	pcie_report_downtraining(dev);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index bf46453475e31..1e3df93b39ca9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -306,6 +306,7 @@ struct pcie_link_state;
 struct pci_vpd;
 struct pci_sriov;
 struct pci_p2pdma;
+struct rcec_ea;
 
 /* The pci_dev structure describes PCI devices */
 struct pci_dev {
@@ -328,6 +329,9 @@ struct pci_dev {
 #ifdef CONFIG_PCIEAER
 	u16		aer_cap;	/* AER capability offset */
 	struct aer_stats *aer_stats;	/* AER stats for this device */
+#endif
+#ifdef CONFIG_PCIEPORTBUS
+	struct rcec_ea	*rcec_ea;	/* RCEC cached endpoint association */
 #endif
 	u8		pcie_cap;	/* PCIe capability offset */
 	u8		msi_cap;	/* MSI capability offset */
-- 
2.43.0



