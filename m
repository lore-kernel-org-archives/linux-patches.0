Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ACF10A35;
	Mon,  4 Mar 2024 21:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588565; cv=none; b=ArFFWmhT0dmYJ5XCYiIMqa6Ac0TVt+xYXzCUmRSJyIzuQp8ZcyKh6sFEbASO9a49hFfw4HGyPJqinIaBaoNTRMX2+I1fqA2aMe9Uu7005bjL3hPNY1rNvdYIFQ6wucE/siTFg3VkOIb2RlQnEavQmsM0iGGlLv6Oag3OHYMTVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588565; c=relaxed/simple;
	bh=cMvXeMxi+1Ny7eKpZgMxL/Ri0w+GdZ6H4+PEg//PlxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpuS2IEHQRh07gQeTuzBMs+mi52Xl6Ru/REUN2sYJVPQbRmMyiqfO/a1Sz0vYzNIjui1/I19XVlAVgE5wcgRhFYfIoVwwTjnKRv1BLqpZboJWxW+D7e681nqA7TgpSkQYlk/laI88U2oODLwWBKkD/W3fX7WeNwZX5M73DVaWr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCWSrVfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCWSrVfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BE8C433F1;
	Mon,  4 Mar 2024 21:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588565;
	bh=cMvXeMxi+1Ny7eKpZgMxL/Ri0w+GdZ6H4+PEg//PlxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCWSrVfuOiQ5BhBRvQZJ14DdjH1qcfRebtyi2X5FDlQtv0MhMroAZPDX/VXlI99Jz
	 pfABFNZB/KQZwWGUOXPIgPDQhKtuKWm2UCLX3iuuHuJaYGK06V+/FQ9aXu1RExVQGa
	 8xI0nw1RxQSKtkiVQkTQzjxDWeUpR6vfbnqXAos8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaowei Bao <xiaowei.bao@nxp.com>,
	Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/215] PCI: layerscape: Add workaround for lost link capabilities during reset
Date: Mon,  4 Mar 2024 21:21:15 +0000
Message-ID: <20240304211557.406756063@linuxfoundation.org>
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

From: Xiaowei Bao <xiaowei.bao@nxp.com>

[ Upstream commit 17cf8661ee0f065c08152e611a568dd1fb0285f1 ]

The endpoint controller loses the Maximum Link Width and Supported Link Speed
value from the Link Capabilities Register - initially configured by the Reset
Configuration Word (RCW) - during a link-down or hot reset event.

Address this issue in the endpoint event handler.

Link: https://lore.kernel.org/r/20230720135834.1977616-2-Frank.Li@nxp.com
Fixes: a805770d8a22 ("PCI: layerscape: Add EP mode support")
Signed-off-by: Xiaowei Bao <xiaowei.bao@nxp.com>
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pci-layerscape-ep.c    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-layerscape-ep.c b/drivers/pci/controller/dwc/pci-layerscape-ep.c
index 5b27554e071a1..dd7d74fecc48e 100644
--- a/drivers/pci/controller/dwc/pci-layerscape-ep.c
+++ b/drivers/pci/controller/dwc/pci-layerscape-ep.c
@@ -45,6 +45,7 @@ struct ls_pcie_ep {
 	struct pci_epc_features		*ls_epc;
 	const struct ls_pcie_ep_drvdata *drvdata;
 	int				irq;
+	u32				lnkcap;
 	bool				big_endian;
 };
 
@@ -73,6 +74,7 @@ static irqreturn_t ls_pcie_ep_event_handler(int irq, void *dev_id)
 	struct ls_pcie_ep *pcie = dev_id;
 	struct dw_pcie *pci = pcie->pci;
 	u32 val, cfg;
+	u8 offset;
 
 	val = ls_lut_readl(pcie, PEX_PF0_PME_MES_DR);
 	ls_lut_writel(pcie, PEX_PF0_PME_MES_DR, val);
@@ -81,6 +83,19 @@ static irqreturn_t ls_pcie_ep_event_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	if (val & PEX_PF0_PME_MES_DR_LUD) {
+
+		offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+
+		/*
+		 * The values of the Maximum Link Width and Supported Link
+		 * Speed from the Link Capabilities Register will be lost
+		 * during link down or hot reset. Restore initial value
+		 * that configured by the Reset Configuration Word (RCW).
+		 */
+		dw_pcie_dbi_ro_wr_en(pci);
+		dw_pcie_writel_dbi(pci, offset + PCI_EXP_LNKCAP, pcie->lnkcap);
+		dw_pcie_dbi_ro_wr_dis(pci);
+
 		cfg = ls_lut_readl(pcie, PEX_PF0_CONFIG);
 		cfg |= PEX_PF0_CFG_READY;
 		ls_lut_writel(pcie, PEX_PF0_CONFIG, cfg);
@@ -214,6 +229,7 @@ static int __init ls_pcie_ep_probe(struct platform_device *pdev)
 	struct ls_pcie_ep *pcie;
 	struct pci_epc_features *ls_epc;
 	struct resource *dbi_base;
+	u8 offset;
 	int ret;
 
 	pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
@@ -250,6 +266,9 @@ static int __init ls_pcie_ep_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcie);
 
+	offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+	pcie->lnkcap = dw_pcie_readl_dbi(pci, offset + PCI_EXP_LNKCAP);
+
 	ret = dw_pcie_ep_init(&pci->ep);
 	if (ret)
 		return ret;
-- 
2.43.0



