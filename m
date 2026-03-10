Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C9D3803CD;
	Tue, 10 Mar 2026 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141990; cv=none; b=cClOEz3Kpmy985jbOwEiJ6vXE3fdPK9LmidQAqyZEgTnk7JbRQ7UsFUeokTvi+yhDa1oMT77VbnVvEp28nHHJevPnlfnBMhpZPDB4bF86CHvnl8JIwVj1oh1eFwz5pHBi5sVqzgwkNA3P0pxLS7hQ7SrPzI8C96d0a79MLHoHaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141990; c=relaxed/simple;
	bh=PF/dx7yDKsTJsDSCnKUStTnl2doT3FBZiDyvveJ4sHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALn2dRp0DYjx+3HPOpkp+AGNfOjZ4yRte4NIMRd1t9rEenbjbJ3ohcONaKEd3kgLdJedpbGMIdadrL01OLztX+2JaKTRNK2a6xzC/kKQL7DW3ovAxZ3dD7K/70eqB70nINJ12QjQe1BSNALJQ9Rol+4Us++2RkdmU+tHlQiRK3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uor+L1L8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uor+L1L8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5D3C2BCB2;
	Tue, 10 Mar 2026 11:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141990;
	bh=PF/dx7yDKsTJsDSCnKUStTnl2doT3FBZiDyvveJ4sHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uor+L1L8jnBbpicF1h/fhiGg1NmNUefIH+xrx9wi0OPaL39MabO7248H8jcxEyrxy
	 1DxjQYDBg/Vuu5dYeZStpAmKMmjgmtl4kh5v3STUb1dVc5Nig5/3izCVSGMNg3NgwF
	 /znzADWCHfHCAVRh2CqPt237Su5FSpDT4jDf+8YlQROCOxakfUia7xjfUOhYeQIzqU
	 gev9NPAhmmelJ+LipFjQ3QswTGX0mCuUERM7JlPqnlcb98V1HH/Ngk0yeUy62iBh0Y
	 01d1lJqNJpYtUX/oEEnoeRy/rhcBNv1SOIhZ2+VwnvN9UiFLwIg+/Wmw0XANu4OXBI
	 yeteZu3Ozo3uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/314] PCI: dwc: ep: Fix resizable BAR support for multi-PF configurations
Date: Tue, 10 Mar 2026 07:16:14 -0400
Message-ID: <0d3912c7aa765d2e55725a31448e88cef683f906.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 43d67ec26b329f8aea34ba9dff23d69b84a8e564 ]

The resizable BAR support added by the commit 3a3d4cabe681 ("PCI: dwc: ep:
Allow EPF drivers to configure the size of Resizable BARs") incorrectly
configures the resizable BARs only for the first Physical Function (PF0)
in EP mode.

The resizable BAR configuration functions use generic dw_pcie_*_dbi()
operations instead of physical function specific dw_pcie_ep_*_dbi()
operations. This causes resizable BAR configuration to always target
PF0 regardless of the requested function number.

Additionally, dw_pcie_ep_init_non_sticky_registers() only initializes
resizable BAR registers for PF0, leaving other PFs unconfigured during
the execution of this function.

Fix this by using physical function specific configuration space access
operations throughout the resizable BAR code path and initializing
registers for all the physical functions that support resizable BARs.

Fixes: 3a3d4cabe681 ("PCI: dwc: ep: Allow EPF drivers to configure the size of Resizable BARs")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
[mani: added stable tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260130115516.515082-2-a-garg7@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 48 ++++++++++++-------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index b6cee9eaa1165..e2e18beb2951d 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -75,6 +75,13 @@ static u8 dw_pcie_ep_find_capability(struct dw_pcie_ep *ep, u8 func_no, u8 cap)
 				 cap, NULL, ep, func_no);
 }
 
+static u16 dw_pcie_ep_find_ext_capability(struct dw_pcie_ep *ep,
+					  u8 func_no, u8 cap)
+{
+	return PCI_FIND_NEXT_EXT_CAP(dw_pcie_ep_read_cfg, 0,
+				     cap, NULL, ep, func_no);
+}
+
 static int dw_pcie_ep_write_header(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 				   struct pci_epf_header *hdr)
 {
@@ -178,22 +185,22 @@ static void dw_pcie_ep_clear_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 	ep->bar_to_atu[bar] = 0;
 }
 
-static unsigned int dw_pcie_ep_get_rebar_offset(struct dw_pcie *pci,
+static unsigned int dw_pcie_ep_get_rebar_offset(struct dw_pcie_ep *ep, u8 func_no,
 						enum pci_barno bar)
 {
 	u32 reg, bar_index;
 	unsigned int offset, nbars;
 	int i;
 
-	offset = dw_pcie_find_ext_capability(pci, PCI_EXT_CAP_ID_REBAR);
+	offset = dw_pcie_ep_find_ext_capability(ep, func_no, PCI_EXT_CAP_ID_REBAR);
 	if (!offset)
 		return offset;
 
-	reg = dw_pcie_readl_dbi(pci, offset + PCI_REBAR_CTRL);
+	reg = dw_pcie_ep_readl_dbi(ep, func_no, offset + PCI_REBAR_CTRL);
 	nbars = FIELD_GET(PCI_REBAR_CTRL_NBAR_MASK, reg);
 
 	for (i = 0; i < nbars; i++, offset += PCI_REBAR_CTRL) {
-		reg = dw_pcie_readl_dbi(pci, offset + PCI_REBAR_CTRL);
+		reg = dw_pcie_ep_readl_dbi(ep, func_no, offset + PCI_REBAR_CTRL);
 		bar_index = FIELD_GET(PCI_REBAR_CTRL_BAR_IDX, reg);
 		if (bar_index == bar)
 			return offset;
@@ -214,7 +221,7 @@ static int dw_pcie_ep_set_bar_resizable(struct dw_pcie_ep *ep, u8 func_no,
 	u32 rebar_cap, rebar_ctrl;
 	int ret;
 
-	rebar_offset = dw_pcie_ep_get_rebar_offset(pci, bar);
+	rebar_offset = dw_pcie_ep_get_rebar_offset(ep, func_no, bar);
 	if (!rebar_offset)
 		return -EINVAL;
 
@@ -244,16 +251,16 @@ static int dw_pcie_ep_set_bar_resizable(struct dw_pcie_ep *ep, u8 func_no,
 	 * 1 MB to 128 TB. Bits 31:16 in PCI_REBAR_CTRL define "supported sizes"
 	 * bits for sizes 256 TB to 8 EB. Disallow sizes 256 TB to 8 EB.
 	 */
-	rebar_ctrl = dw_pcie_readl_dbi(pci, rebar_offset + PCI_REBAR_CTRL);
+	rebar_ctrl = dw_pcie_ep_readl_dbi(ep, func_no, rebar_offset + PCI_REBAR_CTRL);
 	rebar_ctrl &= ~GENMASK(31, 16);
-	dw_pcie_writel_dbi(pci, rebar_offset + PCI_REBAR_CTRL, rebar_ctrl);
+	dw_pcie_ep_writel_dbi(ep, func_no, rebar_offset + PCI_REBAR_CTRL, rebar_ctrl);
 
 	/*
 	 * The "selected size" (bits 13:8) in PCI_REBAR_CTRL are automatically
 	 * updated when writing PCI_REBAR_CAP, see "Figure 3-26 Resizable BAR
 	 * Example for 32-bit Memory BAR0" in DWC EP databook 5.96a.
 	 */
-	dw_pcie_writel_dbi(pci, rebar_offset + PCI_REBAR_CAP, rebar_cap);
+	dw_pcie_ep_writel_dbi(ep, func_no, rebar_offset + PCI_REBAR_CAP, rebar_cap);
 
 	dw_pcie_dbi_ro_wr_dis(pci);
 
@@ -799,20 +806,17 @@ void dw_pcie_ep_deinit(struct dw_pcie_ep *ep)
 }
 EXPORT_SYMBOL_GPL(dw_pcie_ep_deinit);
 
-static void dw_pcie_ep_init_non_sticky_registers(struct dw_pcie *pci)
+static void dw_pcie_ep_init_rebar_registers(struct dw_pcie_ep *ep, u8 func_no)
 {
-	struct dw_pcie_ep *ep = &pci->ep;
 	unsigned int offset;
 	unsigned int nbars;
 	enum pci_barno bar;
 	u32 reg, i, val;
 
-	offset = dw_pcie_find_ext_capability(pci, PCI_EXT_CAP_ID_REBAR);
-
-	dw_pcie_dbi_ro_wr_en(pci);
+	offset = dw_pcie_ep_find_ext_capability(ep, func_no, PCI_EXT_CAP_ID_REBAR);
 
 	if (offset) {
-		reg = dw_pcie_readl_dbi(pci, offset + PCI_REBAR_CTRL);
+		reg = dw_pcie_ep_readl_dbi(ep, func_no, offset + PCI_REBAR_CTRL);
 		nbars = FIELD_GET(PCI_REBAR_CTRL_NBAR_MASK, reg);
 
 		/*
@@ -833,16 +837,28 @@ static void dw_pcie_ep_init_non_sticky_registers(struct dw_pcie *pci)
 			 * the controller when RESBAR_CAP_REG is written, which
 			 * is why RESBAR_CAP_REG is written here.
 			 */
-			val = dw_pcie_readl_dbi(pci, offset + PCI_REBAR_CTRL);
+			val = dw_pcie_ep_readl_dbi(ep, func_no, offset + PCI_REBAR_CTRL);
 			bar = FIELD_GET(PCI_REBAR_CTRL_BAR_IDX, val);
 			if (ep->epf_bar[bar])
 				pci_epc_bar_size_to_rebar_cap(ep->epf_bar[bar]->size, &val);
 			else
 				val = BIT(4);
 
-			dw_pcie_writel_dbi(pci, offset + PCI_REBAR_CAP, val);
+			dw_pcie_ep_writel_dbi(ep, func_no, offset + PCI_REBAR_CAP, val);
 		}
 	}
+}
+
+static void dw_pcie_ep_init_non_sticky_registers(struct dw_pcie *pci)
+{
+	struct dw_pcie_ep *ep = &pci->ep;
+	u8 funcs = ep->epc->max_functions;
+	u8 func_no;
+
+	dw_pcie_dbi_ro_wr_en(pci);
+
+	for (func_no = 0; func_no < funcs; func_no++)
+		dw_pcie_ep_init_rebar_registers(ep, func_no);
 
 	dw_pcie_setup(pci);
 	dw_pcie_dbi_ro_wr_dis(pci);
-- 
2.51.0

