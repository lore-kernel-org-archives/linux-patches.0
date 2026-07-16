Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EA8423775;
	Thu, 16 Jul 2026 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209299; cv=none; b=bukcyu9a1YCH6ftxOu3zly4Fz8vxHolRwyN9cm8G3x/tev0b2jPqqfSfjd8xaG+aycPizTvfLhYyTF/dmS+Tp6BgQO6MrqqdgH44NME3iJjbcZHItArIB0B9mFIWI91dWgofX394QuhRPcbJLQjbX0SeqLn/Si6Vu62PQ8NYURo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209299; c=relaxed/simple;
	bh=+RF8KK0xQ+AFLPaOz3BxtMqhq0UvJ6R2IvqTN4aMGXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp2gTMISOmo3u6+hO7c5JADAwAlVTTfHBTm0iYTjProVpvj75EdFLn5ZAEBABYwUNNSzNaBcHeR04eD+ZTs96Fj+r0IvuteuJKGbOytWqfoTQigW+58y1gZZ/92xKzwLocvjqoegN15r2Gxs2lMQjsTevV4GTqxCdgJEoWC5L4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1Srke5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1Srke5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587281F000E9;
	Thu, 16 Jul 2026 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209297;
	bh=Hd0niZy5NeHWHrgTCtYXzjTNK7V7Jk3wtpVK22Y2Om0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1Srke5IN74uY7iJF7+o5J6mQhkhO7vc9SUrXuAWCibtQYVJsn+DfU2fK5quf4PjW
	 /GkHpOWkM4GSQPQ63eUqB4oynWie4KlI5WY9mP+Budyb9KBbC+5V2UcMYgdZMb4Hjg
	 1Qa39WYzSkW9udPe+tLMVNlE1ON8t48lcgYCWSzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 7.1 133/518] PCI: imx6: Configure REF_USE_PAD before PHY reset for i.MX95
Date: Thu, 16 Jul 2026 15:26:41 +0200
Message-ID: <20260716133050.766456816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit 0c26b1c34d12d4debfb5363cc0be6cdf68e87ba2 upstream.

According to the i.MX95 PCIe PHY Databook, the ref_use_pad signal in the
Common Block Signals section selects the reference clock source connected
to the PHY pads. Per the specification, any change to this input must be
followed by a PHY reset assertion to take effect.

Move the REF_USE_PAD configuration before the PHY reset toggle to comply
with the required initialization sequence.

Fixes: 47f54a902dcd ("PCI: imx6: Toggle the core reset for i.MX95 PCIe")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: renamed the callback and helper to match the usecase]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260518072715.3166514-2-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -137,6 +137,7 @@ struct imx_pcie_drvdata {
 	const u32 mode_off[IMX_PCIE_MAX_INSTANCES];
 	const u32 mode_mask[IMX_PCIE_MAX_INSTANCES];
 	const struct pci_epc_features *epc_features;
+	int (*select_ref_clk_src)(struct imx_pcie *pcie);
 	int (*init_phy)(struct imx_pcie *pcie);
 	int (*enable_ref_clk)(struct imx_pcie *pcie, bool enable);
 	int (*core_reset)(struct imx_pcie *pcie, bool assert);
@@ -247,6 +248,24 @@ static unsigned int imx_pcie_grp_offset(
 	return imx_pcie->controller_id == 1 ? IOMUXC_GPR16 : IOMUXC_GPR14;
 }
 
+static int imx95_pcie_select_ref_clk_src(struct imx_pcie *imx_pcie)
+{
+	bool ext = imx_pcie->enable_ext_refclk;
+
+	/*
+	 * Regarding the Signal Descriptions of i.MX95 PCIe PHY, ref_use_pad is
+	 * used to select reference clock connected to a pair of pads.
+	 *
+	 * Any change in this input must be followed by phy_reset assertion.
+	 */
+
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_PHY_GEN_CTRL,
+			   IMX95_PCIE_REF_USE_PAD,
+			   ext ? IMX95_PCIE_REF_USE_PAD : 0);
+
+	return 0;
+}
+
 static int imx95_pcie_init_phy(struct imx_pcie *imx_pcie)
 {
 	bool ext = imx_pcie->enable_ext_refclk;
@@ -269,9 +288,6 @@ static int imx95_pcie_init_phy(struct im
 			IMX95_PCIE_PHY_CR_PARA_SEL,
 			IMX95_PCIE_PHY_CR_PARA_SEL);
 
-	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_PHY_GEN_CTRL,
-			   IMX95_PCIE_REF_USE_PAD,
-			   ext ? IMX95_PCIE_REF_USE_PAD : 0);
 	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_0,
 			   IMX95_PCIE_REF_CLKEN,
 			   ext ? 0 : IMX95_PCIE_REF_CLKEN);
@@ -1256,6 +1272,9 @@ static int imx_pcie_host_init(struct dw_
 		pp->bridge->disable_device = imx_pcie_disable_device;
 	}
 
+	if (imx_pcie->drvdata->select_ref_clk_src)
+		imx_pcie->drvdata->select_ref_clk_src(imx_pcie);
+
 	imx_pcie_assert_core_reset(imx_pcie);
 	imx_pcie_assert_perst(imx_pcie, true);
 
@@ -1967,6 +1986,7 @@ static const struct imx_pcie_drvdata drv
 		.mode_mask[0] = IMX95_PCIE_DEVICE_TYPE,
 		.core_reset = imx95_pcie_core_reset,
 		.init_phy = imx95_pcie_init_phy,
+		.select_ref_clk_src = imx95_pcie_select_ref_clk_src,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,
 		.enable_ref_clk = imx95_pcie_enable_ref_clk,
 		.clr_clkreq_override = imx95_pcie_clr_clkreq_override,
@@ -2022,6 +2042,7 @@ static const struct imx_pcie_drvdata drv
 		.ltssm_mask = IMX95_PCIE_LTSSM_EN,
 		.mode_off[0]  = IMX95_PE0_GEN_CTRL_1,
 		.mode_mask[0] = IMX95_PCIE_DEVICE_TYPE,
+		.select_ref_clk_src = imx95_pcie_select_ref_clk_src,
 		.init_phy = imx95_pcie_init_phy,
 		.core_reset = imx95_pcie_core_reset,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,


