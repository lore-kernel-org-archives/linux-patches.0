Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BC33876A3;
	Tue, 10 Mar 2026 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141958; cv=none; b=a+/7ceMMS/MoxJibyruOgKI5pe32nSA7w4pxCnXiEaLVebhRdGqN18acz9sL23Fc/Nwmtkj0MbYkBzszSnj+J07kUNUB/A6wxd1j3gc/+nwXiQUCzKJZGlTiJ5HVWPMWRlIqC/QoIf0eCzwr+OeE5UajSrwKrGx0rS4HPtt0q7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141958; c=relaxed/simple;
	bh=WQEAKcHObtWo0nxTcsAvTDzSZ9HqzqxJ0xJvuGEvpAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l515QsHAue8EfrnE6WSYNj7X8l9g0DZRrkaA6zd6uMdqBeP/79RdzR0299+AdSm2H06ebPfODE62scWxzRsd2pxRwrV2AsfdonELmbnOs1DgxeQif+ti0ib8uR3wZJO+3Wk0xPoxKuMEi7LOlTwZPGXS20Mf+Zps1MZMA+VJN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nM8FuxKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nM8FuxKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A389AC19423;
	Tue, 10 Mar 2026 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141958;
	bh=WQEAKcHObtWo0nxTcsAvTDzSZ9HqzqxJ0xJvuGEvpAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nM8FuxKbfQ8PbkjzRG/CIt4kP+cpBfuhTsdTBgUpV37HXLwmzYn5JCpq89g53i3oE
	 MjtstjgNAh7CT1bMnFf93erl3tqbZ9ZTOODKEbZUgDcLFgCXWxBqonUJrYU0VtbP+0
	 ERDkFT4BjKbzyVYo/3xhTf8nuYap0RWnDoqZ2PmyMzRfR0t09kDp6/hmGLesRY2InG
	 khLhz68fLDJu75+4Nj5EPHwNf2mIe5NEziQmsEy96w1nK0IicbPNdB1MDglI5YhoKD
	 QIAUYjeiiGmOdktuA8fsn+hd7nvkRtkbgmpdpLgkI9GRO3O1r12DdSyRXuNDrUjWyU
	 IZg3bkCct26/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/314] Revert "PCI: dw-rockchip: Enumerate endpoints based on dll_link_up IRQ"
Date: Tue, 10 Mar 2026 07:15:41 -0400
Message-ID: <98ec7acd062c576010c47ea530d90c6f40a7fbe0.1773141555.git.sashal@kernel.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 180c3cfe36786d261a55da52a161f9e279b19a6f ]

This reverts commit 0e0b45ab5d770a748487ba0ae8f77d1fb0f0de3e.

While this fake hotplugging was a nice idea, it has shown that this feature
does not handle PCIe switches correctly:
pci_bus 0004:43: busn_res: can not insert [bus 43-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:43: busn_res: [bus 43-41] end is updated to 43
pci_bus 0004:43: busn_res: can not insert [bus 43] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:00.0: devices behind bridge are unusable because [bus 43] cannot be assigned for them
pci_bus 0004:44: busn_res: can not insert [bus 44-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:44: busn_res: [bus 44-41] end is updated to 44
pci_bus 0004:44: busn_res: can not insert [bus 44] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:02.0: devices behind bridge are unusable because [bus 44] cannot be assigned for them
pci_bus 0004:45: busn_res: can not insert [bus 45-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:45: busn_res: [bus 45-41] end is updated to 45
pci_bus 0004:45: busn_res: can not insert [bus 45] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:06.0: devices behind bridge are unusable because [bus 45] cannot be assigned for them
pci_bus 0004:46: busn_res: can not insert [bus 46-41] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci_bus 0004:46: busn_res: [bus 46-41] end is updated to 46
pci_bus 0004:46: busn_res: can not insert [bus 46] under [bus 42-41] (conflicts with (null) [bus 42-41])
pci 0004:42:0e.0: devices behind bridge are unusable because [bus 46] cannot be assigned for them
pci_bus 0004:42: busn_res: [bus 42-41] end is updated to 46
pci_bus 0004:42: busn_res: can not insert [bus 42-46] under [bus 41] (conflicts with (null) [bus 41])
pci 0004:41:00.0: devices behind bridge are unusable because [bus 42-46] cannot be assigned for them
pcieport 0004:40:00.0: bridge has subordinate 41 but max busn 46

During the initial scan, PCI core doesn't see the switch and since the Root
Port is not hot plug capable, the secondary bus number gets assigned as the
subordinate bus number. This means, the PCI core assumes that only one bus
will appear behind the Root Port since the Root Port is not hot plug
capable.

This works perfectly fine for PCIe endpoints connected to the Root Port,
since they don't extend the bus. However, if a PCIe switch is connected,
then there is a problem when the downstream busses starts showing up and
the PCI core doesn't extend the subordinate bus number and bridge resources
after initial scan during boot.

The long term plan is to migrate this driver to the upcoming pwrctrl APIs
that are supposed to handle this problem elegantly.

Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251222064207.3246632-10-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 59 +------------------
 1 file changed, 3 insertions(+), 56 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 0a5d1cfb88437..b5442ee2920e5 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -517,34 +517,6 @@ static const struct dw_pcie_ops dw_pcie_ops = {
 	.get_ltssm = rockchip_pcie_get_ltssm,
 };
 
-static irqreturn_t rockchip_pcie_rc_sys_irq_thread(int irq, void *arg)
-{
-	struct rockchip_pcie *rockchip = arg;
-	struct dw_pcie *pci = &rockchip->pci;
-	struct dw_pcie_rp *pp = &pci->pp;
-	struct device *dev = pci->dev;
-	u32 reg;
-
-	reg = rockchip_pcie_readl_apb(rockchip, PCIE_CLIENT_INTR_STATUS_MISC);
-	rockchip_pcie_writel_apb(rockchip, reg, PCIE_CLIENT_INTR_STATUS_MISC);
-
-	dev_dbg(dev, "PCIE_CLIENT_INTR_STATUS_MISC: %#x\n", reg);
-	dev_dbg(dev, "LTSSM_STATUS: %#x\n", rockchip_pcie_get_ltssm_reg(rockchip));
-
-	if (reg & PCIE_RDLH_LINK_UP_CHGED) {
-		if (rockchip_pcie_link_up(pci)) {
-			msleep(PCIE_RESET_CONFIG_WAIT_MS);
-			dev_dbg(dev, "Received Link up event. Starting enumeration!\n");
-			/* Rescan the bus to enumerate endpoint devices */
-			pci_lock_rescan_remove();
-			pci_rescan_bus(pp->bridge->bus);
-			pci_unlock_rescan_remove();
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
 static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 {
 	struct rockchip_pcie *rockchip = arg;
@@ -577,29 +549,14 @@ static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int rockchip_pcie_configure_rc(struct platform_device *pdev,
-				      struct rockchip_pcie *rockchip)
+static int rockchip_pcie_configure_rc(struct rockchip_pcie *rockchip)
 {
-	struct device *dev = &pdev->dev;
 	struct dw_pcie_rp *pp;
-	int irq, ret;
 	u32 val;
 
 	if (!IS_ENABLED(CONFIG_PCIE_ROCKCHIP_DW_HOST))
 		return -ENODEV;
 
-	irq = platform_get_irq_byname(pdev, "sys");
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(dev, irq, NULL,
-					rockchip_pcie_rc_sys_irq_thread,
-					IRQF_ONESHOT, "pcie-sys-rc", rockchip);
-	if (ret) {
-		dev_err(dev, "failed to request PCIe sys IRQ\n");
-		return ret;
-	}
-
 	/* LTSSM enable control mode */
 	val = FIELD_PREP_WM16(PCIE_LTSSM_ENABLE_ENHANCE, 1);
 	rockchip_pcie_writel_apb(rockchip, val, PCIE_CLIENT_HOT_RESET_CTRL);
@@ -611,17 +568,7 @@ static int rockchip_pcie_configure_rc(struct platform_device *pdev,
 	pp = &rockchip->pci.pp;
 	pp->ops = &rockchip_pcie_host_ops;
 
-	ret = dw_pcie_host_init(pp);
-	if (ret) {
-		dev_err(dev, "failed to initialize host\n");
-		return ret;
-	}
-
-	/* unmask DLL up/down indicator */
-	val = FIELD_PREP_WM16(PCIE_RDLH_LINK_UP_CHGED, 0);
-	rockchip_pcie_writel_apb(rockchip, val, PCIE_CLIENT_INTR_MASK_MISC);
-
-	return ret;
+	return dw_pcie_host_init(pp);
 }
 
 static int rockchip_pcie_configure_ep(struct platform_device *pdev,
@@ -747,7 +694,7 @@ static int rockchip_pcie_probe(struct platform_device *pdev)
 
 	switch (data->mode) {
 	case DW_PCIE_RC_TYPE:
-		ret = rockchip_pcie_configure_rc(pdev, rockchip);
+		ret = rockchip_pcie_configure_rc(rockchip);
 		if (ret)
 			goto deinit_clk;
 		break;
-- 
2.51.0

