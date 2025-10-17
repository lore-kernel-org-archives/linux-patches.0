Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C83A242935;
	Fri, 17 Oct 2025 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714562; cv=none; b=HCGtMmGG6aoa1RVJLzjUeTrmqqOEQBemzaB6Jj7ZR7JZWWIacG76wFZD5RprTwuHAjZW7x9Ax/OSeGiB6jrRJpyUELGgWlicL2tdUF3fXNQvEsouwrdPMo02Vggr5PBmfvVLt59Vhu5Bub/FBYg8PJKyyjUgQ1KtGJmvyKql5MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714562; c=relaxed/simple;
	bh=Y5CWZFZ1zEa6KBnUuawu8PlVHuS2fQ+hvH3URgDqHNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yaz/3LjON1OJ8smZywgIqK3l8W6+XGlaJMohY7VVGzG8d1OcF3JBm2OvVrnjIuzKPWY8nCXdtJqNWxCk3Q82vgP5e/otGsYtxTj1xHGrf7xedUvE6eJc6VmdXN9G/YBujUh41HGECnKsdKD21toIGXz50fUaEMPr4Fb4npzOvE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r31Zei+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r31Zei+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC06C4CEE7;
	Fri, 17 Oct 2025 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714562;
	bh=Y5CWZFZ1zEa6KBnUuawu8PlVHuS2fQ+hvH3URgDqHNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r31Zei+iJyuYfcN3TmmqFWj1GrC5VvCBps8S4c2gPqPFT4I16LdwyLe4/58Wkd6Zp
	 4EiVkXNSHlC6LTDnBZHOwwfApCZ7F4RSTfv5quu855taSwdViZUbasGvJQA5aM4oq1
	 73DfcPmvMu+FugKcKPWVSf52yLHheOfl7mZsrFMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 189/277] PCI: tegra194: Reset BARs when running in PCIe endpoint mode
Date: Fri, 17 Oct 2025 16:53:16 +0200
Message-ID: <20251017145154.022938839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 42f9c66a6d0cc45758dab77233c5460e1cf003df upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1954,6 +1954,15 @@ static irqreturn_t tegra_pcie_ep_pex_rst
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
 static int tegra_pcie_ep_raise_intx_irq(struct tegra_pcie_dw *pcie, u16 irq)
 {
 	/* Tegra194 supports only INTA */
@@ -2030,6 +2039,7 @@ tegra_pcie_ep_get_features(struct dw_pci
 }
 
 static const struct dw_pcie_ep_ops pcie_ep_ops = {
+	.init = tegra_pcie_ep_init,
 	.raise_irq = tegra_pcie_ep_raise_irq,
 	.get_features = tegra_pcie_ep_get_features,
 };


