Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D6E350A2A;
	Tue, 21 Oct 2025 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076688; cv=none; b=F9cV+xq+sVg2S/RwZ203sfrO56wq6Oywm7IMVcyZdgFKSTNFZERAHNH8EIMkfvp+xJ8DORKN/YM2Y+ajQaVzOCzF4Dtxev+df/sbRoxBgPX2DgORejDbdjKgtHjPKLQL3P67g3VnSfu8zTm/0R/48mVCIq0uiScZIYpHXkSwAfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076688; c=relaxed/simple;
	bh=bF7KF6r5cEHNwHKAfOLySKqPgzrCw8bTQtOohrUIdT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofEgO7Fmf3KlXrbn1tUSLTuuHUhqdf+59o5wJT6NGSAg8/H0Hjfim3lvd/SoVOZ9RbCuuON5m/+QeiCm8JJBUSlLKibCltpIWGD7k4ykFP/HqE8dbPoap8G/2AB6IAQZERk64P6oAaxk+EfZamTBtpCfgjtasQ7aR98VfTgfVVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVm3dNBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVm3dNBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5BDC4CEF1;
	Tue, 21 Oct 2025 19:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076686;
	bh=bF7KF6r5cEHNwHKAfOLySKqPgzrCw8bTQtOohrUIdT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVm3dNBet3HIKUWEVXN6xdcbO/xY4iAdvLNj28xYU0tSh0y2N0rTT8VZKaWQ7qGEa
	 YO4poFOLb91AwrJLGcEDxhJpLG64f3X90KFYROOtFkgWQwnE+AqnjPFm+ClAzTbHbc
	 HPWbgYoKqz1aoJEmomphPUL1SrLd7aZ+zSgLmzEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/105] PCI: tegra194: Reset BARs when running in PCIe endpoint mode
Date: Tue, 21 Oct 2025 21:51:54 +0200
Message-ID: <20251021195024.148049140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 42f9c66a6d0cc45758dab77233c5460e1cf003df ]

Tegra already defines all BARs except BAR0 as BAR_RESERVED.  This is
sufficient for pci-epf-test to not allocate backing memory and to not call
set_bar() for those BARs. However, marking a BAR as BAR_RESERVED does not
mean that the BAR gets disabled.

The host side driver, pci_endpoint_test, simply does an ioremap for all
enabled BARs and will run tests against all enabled BARs, so it will run
tests against the BARs marked as BAR_RESERVED.

After running the BAR tests (which will write to all enabled BARs), the
inbound address translation is broken. This is because the tegra controller
exposes the ATU Port Logic Structure in BAR4, so when BAR4 is written, the
inbound address translation settings get overwritten.

To avoid this, implement the dw_pcie_ep_ops .init() callback and start off
by disabling all BARs (pci-epf-test will later enable/configure BARs that
are not defined as BAR_RESERVED).

This matches the behavior of other PCIe endpoint drivers: dra7xx, imx6,
layerscape-ep, artpec6, dw-rockchip, qcom-ep, rcar-gen4, and uniphier-ep.

With this, the PCI endpoint kselftest test case CONSECUTIVE_BAR_TEST (which
was specifically made to detect address translation issues) passes.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250922140822.519796-7-cassel@kernel.org
[ changed .init field to .ep_init in pcie_ep_ops struct ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1963,6 +1963,15 @@ static irqreturn_t tegra_pcie_ep_pex_rst
 	return IRQ_HANDLED;
 }
 
+static void tegra_pcie_ep_init(struct dw_pcie_ep *ep)
+{
+	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
+	enum pci_barno bar;
+
+	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++)
+		dw_pcie_ep_reset_bar(pci, bar);
+};
+
 static int tegra_pcie_ep_raise_legacy_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
 	/* Tegra194 supports only INTA */
@@ -2036,6 +2045,7 @@ tegra_pcie_ep_get_features(struct dw_pci
 }
 
 static const struct dw_pcie_ep_ops pcie_ep_ops = {
+	.ep_init = tegra_pcie_ep_init,
 	.raise_irq = tegra_pcie_ep_raise_irq,
 	.get_features = tegra_pcie_ep_get_features,
 };


