Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C64A18DF6B;
	Wed,  5 Feb 2025 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767285; cv=none; b=FpFAuFTErn+DfR3hlJJgLeF9e/LI7nCDujH9dKCtUlxt185CUAzOYhEuXwaTdV178FrykiGl/pWIStuE6aG4ZB+9qr/ts0ocGniLwYdV5N1Iia/x2p3xnBNbPHVnR2dZS3SIbQ9eW+iwetaVKSeSVgkng52gmmgfSnqpAnB94cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767285; c=relaxed/simple;
	bh=QZYoznYxIgp6ZzhJB8qjEofATLa51EBDQ5IcbO8JIr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWxS4vI6F6Ce1WTJwMgeLqFUR+WCgILq4UmxUSNYmyXTMCA0h3rrCVfBjZdx1dYcVlGY5uUg9okm3vmXVz2vjKIuByxXGb//yVAHlx6QbppLMxsDqgnSezjK5/0ev1HbGjKjrXwfVQvX3hrB6ojUmnOGJHhF39jQA7vSucA4Wnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvgJFrWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvgJFrWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF147C4CED1;
	Wed,  5 Feb 2025 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767285;
	bh=QZYoznYxIgp6ZzhJB8qjEofATLa51EBDQ5IcbO8JIr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvgJFrWRqFM7ffQg6lTh4XMwqfbGUEAqqhb/BabUfQkBn0iH652u+U5Stsjk7Zq/N
	 W3xhtO5RfWY2SXsRtxfKUJCMO/mey8RNlT7yoNPiT8CxQYL97yoyzAGn+DnGo4770Z
	 iM2SVBelLFLL9cKV84VF+AYg7f+i1rXR8x6iORAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daire McNamara <daire.mcnamara@microchip.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/590] PCI: microchip: Set inbound address translation for coherent or non-coherent mode
Date: Wed,  5 Feb 2025 14:43:09 +0100
Message-ID: <20250205134511.872387860@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daire McNamara <daire.mcnamara@microchip.com>

[ Upstream commit 1390a33b3d04fdf6ba4e3e7082107a12027fc188 ]

On Microchip PolarFire SoC the PCIe Root Port can be behind one of three
general purpose Fabric Interface Controller (FIC) buses that encapsulates
an AXI-S bus. Depending on which FIC(s) the Root Port is connected through
to CPU space, and what address translation is done by that FIC, the Root
Port driver's inbound address translation may vary.

For all current supported designs and all future expected designs, inbound
address translation done by a FIC on PolarFire SoC varies depending on
whether PolarFire SoC is operating in coherent DMA mode or noncoherent DMA
mode.

The setup of the outbound address translation tables in the Root Port
driver only needs to handle these two cases.

Setup the inbound address translation tables to one of two address
translations, depending on whether the Root Port is being used with
coherent DMA or noncoherent DMA.

Link: https://lore.kernel.org/r/20241011140043.1250030-3-daire.mcnamara@microchip.com
Fixes: 6f15a9c9f941 ("PCI: microchip: Add Microchip PolarFire PCIe controller driver")
Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>
[bhelgaas: adapt for ac7f53b7e728 ("PCI: microchip: Add support for using
either Root Port 1 or 2")]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/plda/pcie-microchip-host.c | 96 +++++++++++++++++++
 drivers/pci/controller/plda/pcie-plda-host.c  | 17 +++-
 drivers/pci/controller/plda/pcie-plda.h       |  6 +-
 3 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/plda/pcie-microchip-host.c b/drivers/pci/controller/plda/pcie-microchip-host.c
index 6630cacef3010..3fdfffdf02700 100644
--- a/drivers/pci/controller/plda/pcie-microchip-host.c
+++ b/drivers/pci/controller/plda/pcie-microchip-host.c
@@ -7,20 +7,27 @@
  * Author: Daire McNamara <daire.mcnamara@microchip.com>
  */
 
+#include <linux/align.h>
+#include <linux/bits.h>
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of_address.h>
 #include <linux/of_pci.h>
 #include <linux/pci-ecam.h>
 #include <linux/platform_device.h>
+#include <linux/wordpart.h>
 
 #include "../../pci.h"
 #include "pcie-plda.h"
 
+#define MC_MAX_NUM_INBOUND_WINDOWS		8
+#define MPFS_NC_BOUNCE_ADDR			0x80000000
+
 /* PCIe Bridge Phy and Controller Phy offsets */
 #define MC_PCIE1_BRIDGE_ADDR			0x00008000u
 #define MC_PCIE1_CTRL_ADDR			0x0000a000u
@@ -607,6 +614,91 @@ static void mc_disable_interrupts(struct mc_pcie *port)
 	writel_relaxed(GENMASK(31, 0), port->bridge_base_addr + ISTATUS_HOST);
 }
 
+static void mc_pcie_setup_inbound_atr(struct mc_pcie *port, int window_index,
+				      u64 axi_addr, u64 pcie_addr, u64 size)
+{
+	u32 table_offset = window_index * ATR_ENTRY_SIZE;
+	void __iomem *table_addr = port->bridge_base_addr + table_offset;
+	u32 atr_sz;
+	u32 val;
+
+	atr_sz = ilog2(size) - 1;
+
+	val = ALIGN_DOWN(lower_32_bits(pcie_addr), SZ_4K);
+	val |= FIELD_PREP(ATR_SIZE_MASK, atr_sz);
+	val |= ATR_IMPL_ENABLE;
+
+	writel(val, table_addr + ATR0_PCIE_WIN0_SRCADDR_PARAM);
+
+	writel(upper_32_bits(pcie_addr), table_addr + ATR0_PCIE_WIN0_SRC_ADDR);
+
+	writel(lower_32_bits(axi_addr), table_addr + ATR0_PCIE_WIN0_TRSL_ADDR_LSB);
+	writel(upper_32_bits(axi_addr), table_addr + ATR0_PCIE_WIN0_TRSL_ADDR_UDW);
+
+	writel(TRSL_ID_AXI4_MASTER_0, table_addr + ATR0_PCIE_WIN0_TRSL_PARAM);
+}
+
+static int mc_pcie_setup_inbound_ranges(struct platform_device *pdev,
+					struct mc_pcie *port)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *dn = dev->of_node;
+	struct of_range_parser parser;
+	struct of_range range;
+	int atr_index = 0;
+
+	/*
+	 * MPFS PCIe Root Port is 32-bit only, behind a Fabric Interface
+	 * Controller FPGA logic block which contains the AXI-S interface.
+	 *
+	 * From the point of view of the PCIe Root Port, there are only two
+	 * supported Root Port configurations:
+	 *
+	 * Configuration 1: for use with fully coherent designs; supports a
+	 * window from 0x0 (CPU space) to specified PCIe space.
+	 *
+	 * Configuration 2: for use with non-coherent designs; supports two
+	 * 1 GB windows to CPU space; one mapping CPU space 0 to PCIe space
+	 * 0x80000000 and a second mapping CPU space 0x40000000 to PCIe
+	 * space 0xc0000000. This cfg needs two windows because of how the
+	 * MSI space is allocated in the AXI-S range on MPFS.
+	 *
+	 * The FIC interface outside the PCIe block *must* complete the
+	 * inbound address translation as per MCHP MPFS FPGA design
+	 * guidelines.
+	 */
+	if (device_property_read_bool(dev, "dma-noncoherent")) {
+		/*
+		 * Always need same two tables in this case.  Need two tables
+		 * due to hardware interactions between address and size.
+		 */
+		mc_pcie_setup_inbound_atr(port, 0, 0,
+					  MPFS_NC_BOUNCE_ADDR, SZ_1G);
+		mc_pcie_setup_inbound_atr(port, 1, SZ_1G,
+					  MPFS_NC_BOUNCE_ADDR + SZ_1G, SZ_1G);
+	} else {
+		/* Find any DMA ranges */
+		if (of_pci_dma_range_parser_init(&parser, dn)) {
+			/* No DMA range property - setup default */
+			mc_pcie_setup_inbound_atr(port, 0, 0, 0, SZ_4G);
+			return 0;
+		}
+
+		for_each_of_range(&parser, &range) {
+			if (atr_index >= MC_MAX_NUM_INBOUND_WINDOWS) {
+				dev_err(dev, "too many inbound ranges; %d available tables\n",
+					MC_MAX_NUM_INBOUND_WINDOWS);
+				return -EINVAL;
+			}
+			mc_pcie_setup_inbound_atr(port, atr_index, 0,
+						  range.pci_addr, range.size);
+			atr_index++;
+		}
+	}
+
+	return 0;
+}
+
 static int mc_platform_init(struct pci_config_window *cfg)
 {
 	struct device *dev = cfg->parent;
@@ -627,6 +719,10 @@ static int mc_platform_init(struct pci_config_window *cfg)
 	if (ret)
 		return ret;
 
+	ret = mc_pcie_setup_inbound_ranges(pdev, port);
+	if (ret)
+		return ret;
+
 	port->plda.event_ops = &mc_event_ops;
 	port->plda.event_irq_chip = &mc_event_irq_chip;
 	port->plda.events_bitmap = GENMASK(NUM_EVENTS - 1, 0);
diff --git a/drivers/pci/controller/plda/pcie-plda-host.c b/drivers/pci/controller/plda/pcie-plda-host.c
index 8533dc618d45f..4153214ca4103 100644
--- a/drivers/pci/controller/plda/pcie-plda-host.c
+++ b/drivers/pci/controller/plda/pcie-plda-host.c
@@ -8,11 +8,14 @@
  * Author: Daire McNamara <daire.mcnamara@microchip.com>
  */
 
+#include <linux/align.h>
+#include <linux/bitfield.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
 #include <linux/pci_regs.h>
 #include <linux/pci-ecam.h>
+#include <linux/wordpart.h>
 
 #include "pcie-plda.h"
 
@@ -502,8 +505,9 @@ void plda_pcie_setup_window(void __iomem *bridge_base_addr, u32 index,
 	writel(val, bridge_base_addr + (index * ATR_ENTRY_SIZE) +
 	       ATR0_AXI4_SLV0_TRSL_PARAM);
 
-	val = lower_32_bits(axi_addr) | (atr_sz << ATR_SIZE_SHIFT) |
-			    ATR_IMPL_ENABLE;
+	val = ALIGN_DOWN(lower_32_bits(axi_addr), SZ_4K);
+	val |= FIELD_PREP(ATR_SIZE_MASK, atr_sz);
+	val |= ATR_IMPL_ENABLE;
 	writel(val, bridge_base_addr + (index * ATR_ENTRY_SIZE) +
 	       ATR0_AXI4_SLV0_SRCADDR_PARAM);
 
@@ -518,13 +522,20 @@ void plda_pcie_setup_window(void __iomem *bridge_base_addr, u32 index,
 	val = upper_32_bits(pci_addr);
 	writel(val, bridge_base_addr + (index * ATR_ENTRY_SIZE) +
 	       ATR0_AXI4_SLV0_TRSL_ADDR_UDW);
+}
+EXPORT_SYMBOL_GPL(plda_pcie_setup_window);
+
+void plda_pcie_setup_inbound_address_translation(struct plda_pcie_rp *port)
+{
+	void __iomem *bridge_base_addr = port->bridge_addr;
+	u32 val;
 
 	val = readl(bridge_base_addr + ATR0_PCIE_WIN0_SRCADDR_PARAM);
 	val |= (ATR0_PCIE_ATR_SIZE << ATR0_PCIE_ATR_SIZE_SHIFT);
 	writel(val, bridge_base_addr + ATR0_PCIE_WIN0_SRCADDR_PARAM);
 	writel(0, bridge_base_addr + ATR0_PCIE_WIN0_SRC_ADDR);
 }
-EXPORT_SYMBOL_GPL(plda_pcie_setup_window);
+EXPORT_SYMBOL_GPL(plda_pcie_setup_inbound_address_translation);
 
 int plda_pcie_setup_iomems(struct pci_host_bridge *bridge,
 			   struct plda_pcie_rp *port)
diff --git a/drivers/pci/controller/plda/pcie-plda.h b/drivers/pci/controller/plda/pcie-plda.h
index 0e7dc0d8e5ba1..61ece26065ea0 100644
--- a/drivers/pci/controller/plda/pcie-plda.h
+++ b/drivers/pci/controller/plda/pcie-plda.h
@@ -89,14 +89,15 @@
 
 /* PCIe AXI slave table init defines */
 #define ATR0_AXI4_SLV0_SRCADDR_PARAM		0x800u
-#define  ATR_SIZE_SHIFT				1
-#define  ATR_IMPL_ENABLE			1
+#define  ATR_SIZE_MASK				GENMASK(6, 1)
+#define  ATR_IMPL_ENABLE			BIT(0)
 #define ATR0_AXI4_SLV0_SRC_ADDR			0x804u
 #define ATR0_AXI4_SLV0_TRSL_ADDR_LSB		0x808u
 #define ATR0_AXI4_SLV0_TRSL_ADDR_UDW		0x80cu
 #define ATR0_AXI4_SLV0_TRSL_PARAM		0x810u
 #define  PCIE_TX_RX_INTERFACE			0x00000000u
 #define  PCIE_CONFIG_INTERFACE			0x00000001u
+#define  TRSL_ID_AXI4_MASTER_0			0x00000004u
 
 #define CONFIG_SPACE_ADDR_OFFSET		0x1000u
 
@@ -204,6 +205,7 @@ int plda_init_interrupts(struct platform_device *pdev,
 void plda_pcie_setup_window(void __iomem *bridge_base_addr, u32 index,
 			    phys_addr_t axi_addr, phys_addr_t pci_addr,
 			    size_t size);
+void plda_pcie_setup_inbound_address_translation(struct plda_pcie_rp *port);
 int plda_pcie_setup_iomems(struct pci_host_bridge *bridge,
 			   struct plda_pcie_rp *port);
 int plda_pcie_host_init(struct plda_pcie_rp *port, struct pci_ops *ops,
-- 
2.39.5



