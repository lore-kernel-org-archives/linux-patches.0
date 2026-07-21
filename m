Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6288476CF2;
	Tue, 21 Jul 2026 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659508; cv=none; b=GlQ1birH23k0YyXWwYPRzASfK9FWK+012HAVuNeSGD13pVzKp3zRZzgcgqd+VSVi0S5ZWk7EJczKLNDt4SjYZeI7UV5OMUrkSdreQE02DEeA/Gf4OkKYPjYFcWDEFJZ5h998U3izQ1pZFfHXqq0w4L3RONzhglljuk6lIUSTQz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659508; c=relaxed/simple;
	bh=IvFmAMuMfVciyYA4amC3RXt5pOUfUrk22Jl9Oj2G1Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsMo3zGkrZAKDzIk1JvQ8NZmVq4VOkSzYbppOtglMriUizqJmNzW2O/Y4/C5GiMtjjtzXxeMG/DkkRvkuXDA+bz+dFefVabi1ki3X38g7ACiwj9puEqBVX/LiC0npK/5q6SPhfh28X4OH2Tfz3YrwR6ccFAUkHAZVyRLGQAFTZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h410i6ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h410i6ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155F71F000E9;
	Tue, 21 Jul 2026 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659507;
	bh=6bVRyC/QoGHE6ppm+wtnMuEKQ8+SOIjGutJrhDvZkPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h410i6utOBPIVmftmPS9POIk8ClP07opSb6w8dMLqqIle6xIf1Sjl+M2WSUT6K2Rg
	 MgjaQfdjwqs3fDVCbieqAgwc5ossazrwSxibWShJ8+mtTb7e/TaNOyhOsMexROn1JQ
	 W3gTkwuMGDn3PFgHiu+6VyCEyj28Zoq8uImvC2fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1530/1611] PCI: imx6: Configure REF_USE_PAD before PHY reset for i.MX95
Date: Tue, 21 Jul 2026 17:27:26 +0200
Message-ID: <20260721152549.859499196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 0c26b1c34d12d4debfb5363cc0be6cdf68e87ba2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -135,6 +135,7 @@ struct imx_pcie_drvdata {
 	const u32 mode_off[IMX_PCIE_MAX_INSTANCES];
 	const u32 mode_mask[IMX_PCIE_MAX_INSTANCES];
 	const struct pci_epc_features *epc_features;
+	int (*select_ref_clk_src)(struct imx_pcie *pcie);
 	int (*init_phy)(struct imx_pcie *pcie);
 	int (*enable_ref_clk)(struct imx_pcie *pcie, bool enable);
 	int (*core_reset)(struct imx_pcie *pcie, bool assert);
@@ -243,6 +244,24 @@ static unsigned int imx_pcie_grp_offset(
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
@@ -265,9 +284,6 @@ static int imx95_pcie_init_phy(struct im
 			IMX95_PCIE_PHY_CR_PARA_SEL,
 			IMX95_PCIE_PHY_CR_PARA_SEL);
 
-	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_PHY_GEN_CTRL,
-			   IMX95_PCIE_REF_USE_PAD,
-			   ext ? IMX95_PCIE_REF_USE_PAD : 0);
 	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_0,
 			   IMX95_PCIE_REF_CLKEN,
 			   ext ? 0 : IMX95_PCIE_REF_CLKEN);
@@ -1232,6 +1248,9 @@ static int imx_pcie_host_init(struct dw_
 		pp->bridge->disable_device = imx_pcie_disable_device;
 	}
 
+	if (imx_pcie->drvdata->select_ref_clk_src)
+		imx_pcie->drvdata->select_ref_clk_src(imx_pcie);
+
 	imx_pcie_assert_core_reset(imx_pcie);
 
 	if (imx_pcie->drvdata->init_phy)
@@ -1932,6 +1951,7 @@ static const struct imx_pcie_drvdata drv
 		.mode_mask[0] = IMX95_PCIE_DEVICE_TYPE,
 		.core_reset = imx95_pcie_core_reset,
 		.init_phy = imx95_pcie_init_phy,
+		.select_ref_clk_src = imx95_pcie_select_ref_clk_src,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,
 		.enable_ref_clk = imx95_pcie_enable_ref_clk,
 	},
@@ -1986,6 +2006,7 @@ static const struct imx_pcie_drvdata drv
 		.ltssm_mask = IMX95_PCIE_LTSSM_EN,
 		.mode_off[0]  = IMX95_PE0_GEN_CTRL_1,
 		.mode_mask[0] = IMX95_PCIE_DEVICE_TYPE,
+		.select_ref_clk_src = imx95_pcie_select_ref_clk_src,
 		.init_phy = imx95_pcie_init_phy,
 		.core_reset = imx95_pcie_core_reset,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,


