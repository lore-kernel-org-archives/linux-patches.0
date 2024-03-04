Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF981200D4;
	Mon,  4 Mar 2024 21:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588562; cv=none; b=L5sRq8YicJbGElSCy0tPi/vjVKzg0kRwluym7pmK+/3z4poEV6gUJ6n4S/BDIaCGLHoJ73DDDuGHrreGcJLYrbpCVuBzEIdjDuOTiCYA7wP6/53KFO9fWojBzx71RMhSJsCjtt0yHPTHlGZKNImeb7GAKkORJ/UHxUR2Ph3xyoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588562; c=relaxed/simple;
	bh=RPOAnwBOKlnpmNFuUaCStGiEW82rYN87j/KibdMBOuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhGil6Q63fPePV1qhV/YoSHTdRv6eRRLjJFzjepFyQdbO+EPXTHdXdnVs/s8VMLpdHiMyJxGlUCyMWP0SJ4B/9APsJsilxFADfTZUEX6/w2UPlc+WgIuHXnt53UDqUok3DIg43WWhKnazLDrwrm2nQqAu25ojQX18R9eca2ie8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+Brq4Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+Brq4Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B567C433F1;
	Mon,  4 Mar 2024 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588562;
	bh=RPOAnwBOKlnpmNFuUaCStGiEW82rYN87j/KibdMBOuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+Brq4FjgX9Szt122FOVR6vcpmtbl+bih5cpBYONCqHBBmsNk0H+H4M4auXJASdKC
	 fRUgJnGse1FRYqSmJm/bMpvx/dG437kyf+JJPvD75GEPyYPwLtDK57nSqYILnmSguI
	 6MPeu5zVmgQgy1GUAgpPDb10QvwRn3MZztDQMTjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaowei Bao <xiaowei.bao@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/215] PCI: layerscape: Add the endpoint linkup notifier support
Date: Mon,  4 Mar 2024 21:21:14 +0000
Message-ID: <20240304211557.374314189@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 061cbfab09fb35898f2907d42f936cf9ae271d93 ]

Layerscape has PME interrupt, which can be used as linkup notifier.  Set
CFG_READY bit of PEX_PF0_CONFIG to enable accesses from root complex when
linkup detected.

Link: https://lore.kernel.org/r/20230515151049.2797105-1-Frank.Li@nxp.com
Signed-off-by: Xiaowei Bao <xiaowei.bao@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pci-layerscape-ep.c    | 100 +++++++++++++++++-
 1 file changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-layerscape-ep.c b/drivers/pci/controller/dwc/pci-layerscape-ep.c
index ad99707b3b994..5b27554e071a1 100644
--- a/drivers/pci/controller/dwc/pci-layerscape-ep.c
+++ b/drivers/pci/controller/dwc/pci-layerscape-ep.c
@@ -18,6 +18,20 @@
 
 #include "pcie-designware.h"
 
+#define PEX_PF0_CONFIG			0xC0014
+#define PEX_PF0_CFG_READY		BIT(0)
+
+/* PEX PFa PCIE PME and message interrupt registers*/
+#define PEX_PF0_PME_MES_DR		0xC0020
+#define PEX_PF0_PME_MES_DR_LUD		BIT(7)
+#define PEX_PF0_PME_MES_DR_LDD		BIT(9)
+#define PEX_PF0_PME_MES_DR_HRD		BIT(10)
+
+#define PEX_PF0_PME_MES_IER		0xC0028
+#define PEX_PF0_PME_MES_IER_LUDIE	BIT(7)
+#define PEX_PF0_PME_MES_IER_LDDIE	BIT(9)
+#define PEX_PF0_PME_MES_IER_HRDIE	BIT(10)
+
 #define to_ls_pcie_ep(x)	dev_get_drvdata((x)->dev)
 
 struct ls_pcie_ep_drvdata {
@@ -30,8 +44,84 @@ struct ls_pcie_ep {
 	struct dw_pcie			*pci;
 	struct pci_epc_features		*ls_epc;
 	const struct ls_pcie_ep_drvdata *drvdata;
+	int				irq;
+	bool				big_endian;
 };
 
+static u32 ls_lut_readl(struct ls_pcie_ep *pcie, u32 offset)
+{
+	struct dw_pcie *pci = pcie->pci;
+
+	if (pcie->big_endian)
+		return ioread32be(pci->dbi_base + offset);
+	else
+		return ioread32(pci->dbi_base + offset);
+}
+
+static void ls_lut_writel(struct ls_pcie_ep *pcie, u32 offset, u32 value)
+{
+	struct dw_pcie *pci = pcie->pci;
+
+	if (pcie->big_endian)
+		iowrite32be(value, pci->dbi_base + offset);
+	else
+		iowrite32(value, pci->dbi_base + offset);
+}
+
+static irqreturn_t ls_pcie_ep_event_handler(int irq, void *dev_id)
+{
+	struct ls_pcie_ep *pcie = dev_id;
+	struct dw_pcie *pci = pcie->pci;
+	u32 val, cfg;
+
+	val = ls_lut_readl(pcie, PEX_PF0_PME_MES_DR);
+	ls_lut_writel(pcie, PEX_PF0_PME_MES_DR, val);
+
+	if (!val)
+		return IRQ_NONE;
+
+	if (val & PEX_PF0_PME_MES_DR_LUD) {
+		cfg = ls_lut_readl(pcie, PEX_PF0_CONFIG);
+		cfg |= PEX_PF0_CFG_READY;
+		ls_lut_writel(pcie, PEX_PF0_CONFIG, cfg);
+		dw_pcie_ep_linkup(&pci->ep);
+
+		dev_dbg(pci->dev, "Link up\n");
+	} else if (val & PEX_PF0_PME_MES_DR_LDD) {
+		dev_dbg(pci->dev, "Link down\n");
+	} else if (val & PEX_PF0_PME_MES_DR_HRD) {
+		dev_dbg(pci->dev, "Hot reset\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int ls_pcie_ep_interrupt_init(struct ls_pcie_ep *pcie,
+				     struct platform_device *pdev)
+{
+	u32 val;
+	int ret;
+
+	pcie->irq = platform_get_irq_byname(pdev, "pme");
+	if (pcie->irq < 0)
+		return pcie->irq;
+
+	ret = devm_request_irq(&pdev->dev, pcie->irq, ls_pcie_ep_event_handler,
+			       IRQF_SHARED, pdev->name, pcie);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't register PCIe IRQ\n");
+		return ret;
+	}
+
+	/* Enable interrupts */
+	val = ls_lut_readl(pcie, PEX_PF0_PME_MES_IER);
+	val |=  PEX_PF0_PME_MES_IER_LDDIE | PEX_PF0_PME_MES_IER_HRDIE |
+		PEX_PF0_PME_MES_IER_LUDIE;
+	ls_lut_writel(pcie, PEX_PF0_PME_MES_IER, val);
+
+	return 0;
+}
+
 static const struct pci_epc_features*
 ls_pcie_ep_get_features(struct dw_pcie_ep *ep)
 {
@@ -124,6 +214,7 @@ static int __init ls_pcie_ep_probe(struct platform_device *pdev)
 	struct ls_pcie_ep *pcie;
 	struct pci_epc_features *ls_epc;
 	struct resource *dbi_base;
+	int ret;
 
 	pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
 	if (!pcie)
@@ -143,6 +234,7 @@ static int __init ls_pcie_ep_probe(struct platform_device *pdev)
 	pci->ops = pcie->drvdata->dw_pcie_ops;
 
 	ls_epc->bar_fixed_64bit = (1 << BAR_2) | (1 << BAR_4);
+	ls_epc->linkup_notifier = true;
 
 	pcie->pci = pci;
 	pcie->ls_epc = ls_epc;
@@ -154,9 +246,15 @@ static int __init ls_pcie_ep_probe(struct platform_device *pdev)
 
 	pci->ep.ops = &ls_pcie_ep_ops;
 
+	pcie->big_endian = of_property_read_bool(dev->of_node, "big-endian");
+
 	platform_set_drvdata(pdev, pcie);
 
-	return dw_pcie_ep_init(&pci->ep);
+	ret = dw_pcie_ep_init(&pci->ep);
+	if (ret)
+		return ret;
+
+	return ls_pcie_ep_interrupt_init(pcie, pdev);
 }
 
 static struct platform_driver ls_pcie_ep_driver = {
-- 
2.43.0



