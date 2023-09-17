Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B446FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B77C433CB;
	Sun, 17 Sep 2023 20:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982339;
	bh=OeETpE/humoNwsNobUE+h0OL+zP4oG7SEFdiOKa+qkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDa+l+URV+paznBvyP5Fk6OLF8Yeo+1QmHEcfFqWnrvXIwvW9eotnxaCDZ2fVuSJq
	 oSxetOJzQmoIEhcprUWXQqn0S9bKarBJqrEOFZnyVRTXTFcmv6QtiZlgT4j42tdjqy
	 n41cKeNY9r6Vtienn3qNGLlQcZU5x9WXmtawxyGo=
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
Subject: [PATCH 5.15 222/511] PCI: layerscape: Add workaround for lost link capabilities during reset
Date: Sun, 17 Sep 2023 21:10:49 +0200
Message-ID: <20230917191119.171464882@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
2.40.1



