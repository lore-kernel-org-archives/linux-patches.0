Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC450313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301102; cv=none; b=KwhzeLxgcbWUPfwCx+a/hdvlDz4r+rNUXXU4QikmajzxYK9KK/RMfe4TqqvH6IqKd6rM9UVeCHzY4q1BkFIGesCnc4i2SRH6XfRU6Fy1eFR9VX8fMASVRy3nI5AmI7CgWC4IpeycVecfyS9hBCjumXkwVOo4p3JdxBz1V/rIhlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301102; c=relaxed/simple;
	bh=vGkaU8DRRlH5wnHokma/+c94Vb7tTBWsHsJNxRH2A+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbmolknTvs3VtGIIBwXQCVORE+ldXSLHLOnoy+VwjQGsW26rsi8+br39iObgEesDZ6mirx4iHgk0ed+NnyijwsL2i1kHsvzJOGVQ/gAHxJTw79T/Gw0RN8liDfeUHouS0KocR+Hmc+MK4lApemfxhyqTb1KfXNYOrgNfW3nVWjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQVR+71T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQVR+71T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7F2C19423;
	Sat, 28 Feb 2026 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301102;
	bh=vGkaU8DRRlH5wnHokma/+c94Vb7tTBWsHsJNxRH2A+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQVR+71TUXrMhchRVzIHc/knpaV9QryBRaxcfxsW1xID3k/mz8a3W8/W5VdStNpwp
	 sl4FUWZKkWjkiib8BX1jl9huwWbW3BeOVqIzebNmZhZRey8klmagprk6mm2NswRIM1
	 H/C5zL3T/VGKR+Y57/wQ6gAth0o/BeU8smBkosvW3THx8DUICZLYv9W6HJ6d1plA0f
	 16Dks9aywp32W7uVtZHrLMlwVKl2qLieuDITjTs2nFx73FaKRtterWGRS91A2wxNKr
	 6xzgSEuBTYh28DIeGNeg91+AFQwhtiOcgUBzTKIWbUe5F2OweZbhREzx30nmYWwk2c
	 jyWXdap8v6NAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/752] PCI: imx6: Add CLKREQ# override to enable REFCLK for i.MX95 PCIe
Date: Sat, 28 Feb 2026 12:39:26 -0500
Message-ID: <20260228174750.1542406-255-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 27a064aba2da6bc58fc36a6b8e889187ae3bf89d ]

The CLKREQ# is an open drain, active low signal that is driven low by
the card to request reference clock. It's an optional signal added in
PCIe CEM r4.0, sec 2. Thus, this signal wouldn't be driven low if it's
not exposed on the slot.

On the i.MX95 EVK board, REFCLK to the host and endpoint is gated by this
CLKREQ# signal. So if the CLKREQ# signal is not driven by the endpoint, it
will gate the REFCLK to host too, leading to operational failure.

Hence, enable the REFCLK on this SoC by enabling the CLKREQ# override using
imx95_pcie_clkreq_override() helper during probe. This override should only
be cleared when the CLKREQ# signal is exposed on the slot.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251015030428.2980427-11-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 4668fc9648bff..34f8f69ddfae9 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -52,6 +52,8 @@
 #define IMX95_PCIE_REF_CLKEN			BIT(23)
 #define IMX95_PCIE_PHY_CR_PARA_SEL		BIT(9)
 #define IMX95_PCIE_SS_RW_REG_1			0xf4
+#define IMX95_PCIE_CLKREQ_OVERRIDE_EN		BIT(8)
+#define IMX95_PCIE_CLKREQ_OVERRIDE_VAL		BIT(9)
 #define IMX95_PCIE_SYS_AUX_PWR_DET		BIT(31)
 
 #define IMX95_PE0_GEN_CTRL_1			0x1050
@@ -706,6 +708,22 @@ static int imx7d_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 	return 0;
 }
 
+static void imx95_pcie_clkreq_override(struct imx_pcie *imx_pcie, bool enable)
+{
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_1,
+			   IMX95_PCIE_CLKREQ_OVERRIDE_EN,
+			   enable ? IMX95_PCIE_CLKREQ_OVERRIDE_EN : 0);
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_1,
+			   IMX95_PCIE_CLKREQ_OVERRIDE_VAL,
+			   enable ? IMX95_PCIE_CLKREQ_OVERRIDE_VAL : 0);
+}
+
+static int imx95_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
+{
+	imx95_pcie_clkreq_override(imx_pcie, enable);
+	return 0;
+}
+
 static int imx_pcie_clk_enable(struct imx_pcie *imx_pcie)
 {
 	struct dw_pcie *pci = imx_pcie->pci;
@@ -1913,6 +1931,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 		.core_reset = imx95_pcie_core_reset,
 		.init_phy = imx95_pcie_init_phy,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,
+		.enable_ref_clk = imx95_pcie_enable_ref_clk,
 	},
 	[IMX8MQ_EP] = {
 		.variant = IMX8MQ_EP,
@@ -1969,6 +1988,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 		.core_reset = imx95_pcie_core_reset,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,
 		.epc_features = &imx95_pcie_epc_features,
+		.enable_ref_clk = imx95_pcie_enable_ref_clk,
 		.mode = DW_PCIE_EP_TYPE,
 	},
 };
-- 
2.51.0

