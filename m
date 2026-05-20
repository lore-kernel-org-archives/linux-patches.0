Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813B635DA78;
	Wed, 20 May 2026 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298200; cv=none; b=ANku1evlwpQyB/gXTTNXidFk4KsoGmna1s+nNVu+0POWDZKtdxVp2Q9N7Bl63Ufi44idUJaUmx4F+dH1Nk1dna8CCixTWy9LJ7BUCm22CWqxoSKBxaSSlnXqxDZX/DgJVUBoKithU7DPn8h6Vqvqk0Nc7U0qPc5hsTNENcFu5YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298200; c=relaxed/simple;
	bh=sPSYqvUyBFHa6gXTfE++bg8ZN3urgJV1+g9kbYeJ4D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERwlFXvWSCFAjXAJiZwf+kKvpuzT1tOE4NM7FbOh2gdLZiu6xCHSSbBBevPLma1vJsCAVHEgIwPKwXEzNokyQGnXduNoZi4XbpaUG6sRt4ePyKRP4rVYBUIA3Sds7QaWwhbx3R5qtiMrScetgRaRzvf1cg+6y2Fw6Zv5EKY7/Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQW0BwJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQW0BwJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB081F000E9;
	Wed, 20 May 2026 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298199;
	bh=MbtnRawjxDJI34JHMFmK/PdIM75e+cFOQ7KliaUztEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQW0BwJfKKkMPzgJkXNlHPMsGeTm2ImxaEHwzMbJJQvEu4qNkEIzl1tF21ZtRwmSX
	 ZbQAWrToafx86su9zoEecBZPc+baK1nnGhK/Zyb1/Ctyip2ygtFPMNksljw7GVOQse
	 f15LB6d4Zl/TOH5lWBVVqTrlCAIPczEqaZ9fErPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/957] PCI: tegra194: Dont force the device into the D0 state before L2
Date: Wed, 20 May 2026 18:13:24 +0200
Message-ID: <20260520162141.492777949@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 71d9f67701e1affc82d18ca88ae798c5361beddf ]

As per PCIe CEM r6.0, sec 2.3, the PCIe Endpoint device should be in D3cold
to assert WAKE# pin. The previous workaround that forced downstream devices
to D0 before taking the link to L2 cited PCIe r4.0, sec 5.2, "Link State
Power Management"; however, that spec does not explicitly require putting
the device into D0 and only indicates that power removal may be initiated
without transitioning to D3hot.

Remove the D0 workaround so that Endpoint devices can use wake
functionality (WAKE# from D3). With some Endpoints the link may not enter
L2 when they remain in D3, but the Root Port continues with the usual flow
after PME timeout, so there is no functional issue.

Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-5-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 41 ----------------------
 1 file changed, 41 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index b3a1161f49daf..112fd5ea5a0ab 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1287,44 +1287,6 @@ static int tegra_pcie_bpmp_set_pll_state(struct tegra_pcie_dw *pcie,
 	return 0;
 }
 
-static void tegra_pcie_downstream_dev_to_D0(struct tegra_pcie_dw *pcie)
-{
-	struct dw_pcie_rp *pp = &pcie->pci.pp;
-	struct pci_bus *child, *root_port_bus = NULL;
-	struct pci_dev *pdev;
-
-	/*
-	 * link doesn't go into L2 state with some of the endpoints with Tegra
-	 * if they are not in D0 state. So, need to make sure that immediate
-	 * downstream devices are in D0 state before sending PME_TurnOff to put
-	 * link into L2 state.
-	 * This is as per PCI Express Base r4.0 v1.0 September 27-2017,
-	 * 5.2 Link State Power Management (Page #428).
-	 */
-
-	list_for_each_entry(child, &pp->bridge->bus->children, node) {
-		if (child->parent == pp->bridge->bus) {
-			root_port_bus = child;
-			break;
-		}
-	}
-
-	if (!root_port_bus) {
-		dev_err(pcie->dev, "Failed to find downstream bus of Root Port\n");
-		return;
-	}
-
-	/* Bring downstream devices to D0 if they are not already in */
-	list_for_each_entry(pdev, &root_port_bus->devices, bus_list) {
-		if (PCI_SLOT(pdev->devfn) == 0) {
-			if (pci_set_power_state(pdev, PCI_D0))
-				dev_err(pcie->dev,
-					"Failed to transition %s to D0 state\n",
-					dev_name(&pdev->dev));
-		}
-	}
-}
-
 static int tegra_pcie_get_slot_regulators(struct tegra_pcie_dw *pcie)
 {
 	pcie->slot_ctl_3v3 = devm_regulator_get_optional(pcie->dev, "vpcie3v3");
@@ -1654,7 +1616,6 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
 
 static void tegra_pcie_deinit_controller(struct tegra_pcie_dw *pcie)
 {
-	tegra_pcie_downstream_dev_to_D0(pcie);
 	dw_pcie_host_deinit(&pcie->pci.pp);
 	tegra_pcie_dw_pme_turnoff(pcie);
 	tegra_pcie_unconfig_controller(pcie);
@@ -2370,7 +2331,6 @@ static int tegra_pcie_dw_suspend_noirq(struct device *dev)
 	if (!pcie->link_state)
 		return 0;
 
-	tegra_pcie_downstream_dev_to_D0(pcie);
 	tegra_pcie_dw_pme_turnoff(pcie);
 	tegra_pcie_unconfig_controller(pcie);
 
@@ -2444,7 +2404,6 @@ static void tegra_pcie_dw_shutdown(struct platform_device *pdev)
 			return;
 
 		debugfs_remove_recursive(pcie->debugfs);
-		tegra_pcie_downstream_dev_to_D0(pcie);
 
 		disable_irq(pcie->pci.pp.irq);
 		if (IS_ENABLED(CONFIG_PCI_MSI))
-- 
2.53.0



