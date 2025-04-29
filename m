Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BED6253956;
	Tue, 29 Apr 2025 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950267; cv=none; b=vGAb8x57xliqtPnYGr/WNzblps7NelWk2knFeGCgA2uJsBu/3hU58ulFGlHGlvvOOOVdPLgLG7jiZwHs5IPZGeSApHhag5ehkQoNoYwrQQLwwacURJLqjaDC0QZlB5h40pqWr2aq9+UDPOSDAo+vgoWj7/ykEgIiZB+SW2PpthE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950267; c=relaxed/simple;
	bh=M4C08HLFNNc+IsH7C/bJzt8HkeKeb6SNszPiPy0jOgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaV44TTZt69V1+ixo7W5QwlQa/0vxNNz4AnJlNYKJrMRagiw7y1duopiPwjV/SgphIvCM+Z91mewfWSw3PWNRyvN0ZEV52vDL/OIaA8XogZeaDJku1TFZQ5IDghqzG/WiOvreljHrOFBpFznmEt3VcLA3jnmMYDA1IyzMZSYyvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+8OQlpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+8OQlpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9211C4CEE3;
	Tue, 29 Apr 2025 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950267;
	bh=M4C08HLFNNc+IsH7C/bJzt8HkeKeb6SNszPiPy0jOgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+8OQlpXDtWJ+NmE3M2Cb7OiE0MurxfQdjKAfaqSBdU78pnic7VAFwI7IugiZLBOg
	 AvbchepQJm5aW95+mVJbJKoIrTSuBzINeMtpnZmZw/Xrf7Amc/nOi6PjVtgOJiLa1s
	 F7MYOEp2whzbh8EAEYE7bhYLAERC5RQDI4wgNq84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/204] s390/pci: Support mmap() of PCI resources except for ISM devices
Date: Tue, 29 Apr 2025 18:42:09 +0200
Message-ID: <20250429161101.093967565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit aa9f168d55dc47c0de564f7dfe0e90467c9fee71 ]

So far s390 does not allow mmap() of PCI resources to user-space via the
usual mechanisms, though it does use it for RDMA. For the PCI sysfs
resource files and /proc/bus/pci it defines neither HAVE_PCI_MMAP nor
ARCH_GENERIC_PCI_MMAP_RESOURCE. For vfio-pci s390 previously relied on
disabled VFIO_PCI_MMAP and now relies on setting pdev->non_mappable_bars
for all devices.

This is partly because access to mapped PCI resources from user-space
requires special PCI load/store memory-I/O (MIO) instructions, or the
special MMIO syscalls when these are not available. Still, such access is
possible and useful not just for RDMA, in fact not being able to mmap() PCI
resources has previously caused extra work when testing devices.

One thing that doesn't work with PCI resources mapped to user-space though
is the s390 specific virtual ISM device. Not only because the BAR size of
256 TiB prevents mapping the whole BAR but also because access requires use
of the legacy PCI instructions which are not accessible to user-space on
systems with the newer MIO PCI instructions.

Now with the pdev->non_mappable_bars flag ISM can be excluded from mapping
its resources while making this functionality available for all other PCI
devices. To this end introduce a minimal implementation of PCI_QUIRKS and
use that to set pdev->non_mappable_bars for ISM devices only. Then also set
ARCH_GENERIC_PCI_MMAP_RESOURCE to take advantage of the generic
implementation of pci_mmap_resource_range() enabling only the newer sysfs
mmap() interface. This follows the recommendation in
Documentation/PCI/sysfs-pci.rst.

Link: https://lore.kernel.org/r/20250226-vfio_pci_mmap-v7-3-c5c0f1d26efd@linux.ibm.com
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig           |  4 +---
 arch/s390/include/asm/pci.h |  3 +++
 arch/s390/pci/Makefile      |  2 +-
 arch/s390/pci/pci_fixup.c   | 23 +++++++++++++++++++++++
 drivers/s390/net/ism_drv.c  |  1 -
 include/linux/pci_ids.h     |  1 +
 6 files changed, 29 insertions(+), 5 deletions(-)
 create mode 100644 arch/s390/pci/pci_fixup.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bd4782f23f66d..0882016af57c0 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -38,9 +38,6 @@ config AUDIT_ARCH
 config NO_IOPORT_MAP
 	def_bool y
 
-config PCI_QUIRKS
-	def_bool n
-
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
@@ -229,6 +226,7 @@ config S390
 	select PCI_DOMAINS		if PCI
 	select PCI_MSI			if PCI
 	select PCI_MSI_ARCH_FALLBACKS	if PCI_MSI
+	select PCI_QUIRKS		if PCI
 	select SPARSE_IRQ
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index b248694e00247..211c69cd1f9c9 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -11,6 +11,9 @@
 #include <asm/pci_insn.h>
 #include <asm/sclp.h>
 
+#define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
+#define arch_can_pci_mmap_wc()		1
+
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
 
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index eeef68901a15c..2f8dd3f688391 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -5,5 +5,5 @@
 
 obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
 			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
-			   pci_bus.o pci_kvm_hook.o pci_report.o
+			   pci_bus.o pci_kvm_hook.o pci_report.o pci_fixup.o
 obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
diff --git a/arch/s390/pci/pci_fixup.c b/arch/s390/pci/pci_fixup.c
new file mode 100644
index 0000000000000..35688b6450983
--- /dev/null
+++ b/arch/s390/pci/pci_fixup.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Exceptions for specific devices,
+ *
+ * Copyright IBM Corp. 2025
+ *
+ * Author(s):
+ *   Niklas Schnelle <schnelle@linux.ibm.com>
+ */
+#include <linux/pci.h>
+
+static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
+{
+	/*
+	 * ISM's BAR is special. Drivers written for ISM know
+	 * how to handle this but others need to be aware of their
+	 * special nature e.g. to prevent attempts to mmap() it.
+	 */
+	pdev->non_mappable_bars = 1;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IBM,
+			PCI_DEVICE_ID_IBM_ISM,
+			zpci_ism_bar_no_mmap);
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index af0d90beba638..390ebd4d7f3bc 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -20,7 +20,6 @@
 MODULE_DESCRIPTION("ISM driver for s390");
 MODULE_LICENSE("GPL");
 
-#define PCI_DEVICE_ID_IBM_ISM 0x04ED
 #define DRV_NAME "ism"
 
 static const struct pci_device_id ism_device_table[] = {
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3dce2be622e74..dcb9d5ac06937 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,6 +517,7 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_DEVICE_ID_IBM_ISM		0x04ed
 
 #define PCI_SUBVENDOR_ID_IBM		0x1014
 #define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4
-- 
2.39.5



