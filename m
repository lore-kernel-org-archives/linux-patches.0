Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EEB387590;
	Tue, 10 Mar 2026 11:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141954; cv=none; b=igT6+ujUdd3o66WUzyohEGF00Bu8MpV1vKhIKTkLaTEIQcfg4RVEMJvp49asxXQKbli2v8MZLcv5t8ntL1yIcW+H86WYyhVcSXQoKxhts1p2QCiGqKL4FtdwIRbDXwrmAyAs+wnzjMYCA42r28ShYFpoIjEOXfdDqB+C9eg8tYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141954; c=relaxed/simple;
	bh=i1sB3LQs6Ti6c2Tzf4w72R7Va0eF1F3mGnlOxDegHHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXpGyf1kDrFLTJyvwLftChEteEswzQJvpG1zUIWxz6XugJsnR8YMm9y/V4qwXUdoBK7yk4sfa6f0nhWAqT64fw1xKntQbMzHGc9Z8CPQ8OBU+xBSgpuhgE0C6Uv6S2jqKtXcvFLEGJPSNmnjXnTPTcy6c2+eV44krLXageLPlxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRvqWgsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRvqWgsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42348C19423;
	Tue, 10 Mar 2026 11:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141954;
	bh=i1sB3LQs6Ti6c2Tzf4w72R7Va0eF1F3mGnlOxDegHHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRvqWgsqL6fiuEI9O6rkh22Dj1CRHjdbS7y3GerBnHJ7jCleQctxZD5tgaiWxFCf8
	 b1GmLzsQX1kFWOIKQHOsN0Y3vGcF6xq6DDICo+dqxaavBrSU6v6lkMvImWcZj+Atn/
	 p0RqNeujoBQGDW3iyujazBQRErT5gAPTRT7vLPKZB37fWbAqHB2VpGJxyxsRErJKym
	 CT9N0D3yDYtiorxA0Fsz/PQAEXrQHKpeZolsp6b94fhpbp2ASQYvkv18aVO+//jY3k
	 cUhuhnrvsE/EV/hJ5L0kn5I8I4JxVP4fyMzv1OVB8x4dSsqLLzmXZk1I3cLqjLrWMw
	 3z2JhsN6LKyhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/314] PCI: dwc: Advertise L1 PM Substates only if driver requests it
Date: Tue, 10 Mar 2026 07:15:37 -0400
Message-ID: <5d7657e1cac400811d0e7155d9cb9d02bd1c4896.1773141555.git.sashal@kernel.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a00bba406b5a682764ecb507e580ca8159196aa3 ]

L1 PM Substates require the CLKREQ# signal and may also require
device-specific support.  If CLKREQ# is not supported or driver support is
lacking, enabling L1.1 or L1.2 may cause errors when accessing devices,
e.g.,

  nvme nvme0: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS=0x10

If the kernel is built with CONFIG_PCIEASPM_POWER_SUPERSAVE=y or users
enable L1.x via sysfs, users may trip over these errors even if L1
Substates haven't been enabled by firmware or the driver.

To prevent such errors, disable advertising the L1 PM Substates unless the
driver sets "dw_pcie.l1ss_support" to indicate that it knows CLKREQ# is
present and any device-specific configuration has been done.

Set "dw_pcie.l1ss_support" in tegra194 (if DT includes the
"supports-clkreq' property) and qcom (for cfg_2_7_0, cfg_1_9_0, cfg_1_34_0,
and cfg_sc8280xp controllers) so they can continue to use L1 Substates.

Based on Niklas's patch:
https://patch.msgid.link/20251017163252.598812-2-cassel@kernel.org

[bhelgaas: drop hiding for endpoints]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251118214312.2598220-2-helgaas@kernel.org
Stable-dep-of: 180c3cfe3678 ("Revert "PCI: dw-rockchip: Enumerate endpoints based on dll_link_up IRQ"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-host.c |  2 ++
 drivers/pci/controller/dwc/pcie-designware.c  | 24 +++++++++++++++++++
 drivers/pci/controller/dwc/pcie-designware.h  |  2 ++
 drivers/pci/controller/dwc/pcie-qcom.c        |  2 ++
 drivers/pci/controller/dwc/pcie-tegra194.c    |  3 +++
 5 files changed, 33 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 925d5f818f12b..894bf23529df5 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1081,6 +1081,8 @@ int dw_pcie_setup_rc(struct dw_pcie_rp *pp)
 		PCI_COMMAND_MASTER | PCI_COMMAND_SERR;
 	dw_pcie_writel_dbi(pci, PCI_COMMAND, val);
 
+	dw_pcie_hide_unsupported_l1ss(pci);
+
 	dw_pcie_config_presets(pp);
 	/*
 	 * If the platform provides its own child bus config accesses, it means
diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 06eca858eb1b3..75fc8b767fccf 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -1083,6 +1083,30 @@ void dw_pcie_edma_remove(struct dw_pcie *pci)
 	dw_edma_remove(&pci->edma);
 }
 
+void dw_pcie_hide_unsupported_l1ss(struct dw_pcie *pci)
+{
+	u16 l1ss;
+	u32 l1ss_cap;
+
+	if (pci->l1ss_support)
+		return;
+
+	l1ss = dw_pcie_find_ext_capability(pci, PCI_EXT_CAP_ID_L1SS);
+	if (!l1ss)
+		return;
+
+	/*
+	 * Unless the driver claims "l1ss_support", don't advertise L1 PM
+	 * Substates because they require CLKREQ# and possibly other
+	 * device-specific configuration.
+	 */
+	l1ss_cap = dw_pcie_readl_dbi(pci, l1ss + PCI_L1SS_CAP);
+	l1ss_cap &= ~(PCI_L1SS_CAP_PCIPM_L1_1 | PCI_L1SS_CAP_ASPM_L1_1 |
+		      PCI_L1SS_CAP_PCIPM_L1_2 | PCI_L1SS_CAP_ASPM_L1_2 |
+		      PCI_L1SS_CAP_L1_PM_SS);
+	dw_pcie_writel_dbi(pci, l1ss + PCI_L1SS_CAP, l1ss_cap);
+}
+
 void dw_pcie_setup(struct dw_pcie *pci)
 {
 	u32 val;
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 96e89046614da..82336a204569f 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -516,6 +516,7 @@ struct dw_pcie {
 	int			max_link_speed;
 	u8			n_fts[2];
 	struct dw_edma_chip	edma;
+	bool			l1ss_support;	/* L1 PM Substates support */
 	struct clk_bulk_data	app_clks[DW_PCIE_NUM_APP_CLKS];
 	struct clk_bulk_data	core_clks[DW_PCIE_NUM_CORE_CLKS];
 	struct reset_control_bulk_data	app_rsts[DW_PCIE_NUM_APP_RSTS];
@@ -573,6 +574,7 @@ int dw_pcie_prog_ep_inbound_atu(struct dw_pcie *pci, u8 func_no, int index,
 				int type, u64 parent_bus_addr,
 				u8 bar, size_t size);
 void dw_pcie_disable_atu(struct dw_pcie *pci, u32 dir, int index);
+void dw_pcie_hide_unsupported_l1ss(struct dw_pcie *pci);
 void dw_pcie_setup(struct dw_pcie *pci);
 void dw_pcie_iatu_detect(struct dw_pcie *pci);
 int dw_pcie_edma_detect(struct dw_pcie *pci);
diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 5311cd5d96372..789cc0e3c10da 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1005,6 +1005,8 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 	val &= ~REQ_NOT_ENTR_L1;
 	writel(val, pcie->parf + PARF_PM_CTRL);
 
+	pci->l1ss_support = true;
+
 	val = readl(pcie->parf + PARF_AXI_MSTR_WR_ADDR_HALT_V2);
 	val |= EN;
 	writel(val, pcie->parf + PARF_AXI_MSTR_WR_ADDR_HALT_V2);
diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 10e74458e667b..3934757baa30c 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -703,6 +703,9 @@ static void init_host_aspm(struct tegra_pcie_dw *pcie)
 	val |= (pcie->aspm_pwr_on_t << 19);
 	dw_pcie_writel_dbi(pci, pcie->cfg_link_cap_l1sub, val);
 
+	if (pcie->supports_clkreq)
+		pci->l1ss_support = true;
+
 	/* Program L0s and L1 entrance latencies */
 	val = dw_pcie_readl_dbi(pci, PCIE_PORT_AFR);
 	val &= ~PORT_AFR_L0S_ENTRANCE_LAT_MASK;
-- 
2.51.0

