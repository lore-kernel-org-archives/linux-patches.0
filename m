Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895F472551;
	Tue, 21 Jul 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659479; cv=none; b=Pb7W3mzsxBlIqu6GLMmQtGVXT3rtmKqYkXXM8Wv69gMcu3E6iaXDA8luAHUPbZVxQneb7BtdDEymjlSCuIzOExqMWnuM89N298A+ylG3TAZ2XEYGtAefVS30FN6fJwT4H3miXS+OaTfBZApeWsVqZWMoAIJRLrELWvXV9aym5og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659479; c=relaxed/simple;
	bh=9KWmX3uypkxTi+oY8XmfbGdzr3zWCj3obSbuQCKwEbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdDeV4l8TJg+bhKfbqgk71ZR0iCsTJ8nL+6HM8XbjJLOKBuXAblK8LNgMrZI/NSM9kSD2To2PzEq1pscbGikZjdmdWWfnoErHdd7S5y8usD2li/GyW3GUxC2f/OyJSW+ipLTvRwvr02S2ieIQaSV1Bk1J+qsSGBXwK5Yn9NTU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq4pof92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq4pof92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01F31F000E9;
	Tue, 21 Jul 2026 18:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659478;
	bh=WzPEfWy7eJxarY0drm/bxm8hiEqfRcGtMogd0XlnC4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sq4pof92lpBZvE3eUepaouh84WTj3qSelPv0QQEUFp2n1gN9ebUOtX70+IkSY+fLC
	 rGPwO/XOQPk1QJ/WwVBMku8h/to9ZDh6Mo5BxblYoyXFgVe4CAenctEyvD2C1JZ9cK
	 ZpVu8sJPqQW+MaPpUPWiVoHukqGbBYByI/n+6Wr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1529/1611] PCI: imx6: Fix reference clock source selection for i.MX95
Date: Tue, 21 Jul 2026 17:27:25 +0200
Message-ID: <20260721152549.836948150@linuxfoundation.org>
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

From: Franz Schnyder <franz.schnyder@toradex.com>

[ Upstream commit 88cc4cbe08bba27bb58888d25d336774aa0ccab1 ]

In the PCIe PHY init for the i.MX95, the reference clock source selection
uses a conditional instead of always passing the mask. This currently
breaks functionality if the internal refclk is used.

To fix this issue, always pass IMX95_PCIE_REF_USE_PAD as the mask and clear
bit if external refclk is not used. This essentially swaps the parameters.

Fixes: d8574ce57d76 ("PCI: imx6: Add external reference clock input mode support")
Signed-off-by: Franz Schnyder <franz.schnyder@toradex.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260325093118.684142-1-fra.schnyder@gmail.com
Stable-dep-of: 0c26b1c34d12 ("PCI: imx6: Configure REF_USE_PAD before PHY reset for i.MX95")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -150,6 +150,7 @@ struct imx_lut_data {
 struct imx_pcie {
 	struct dw_pcie		*pci;
 	struct gpio_desc	*reset_gpiod;
+	bool			enable_ext_refclk;
 	struct clk_bulk_data	*clks;
 	int			num_clks;
 	struct regmap		*iomuxc_gpr;
@@ -244,6 +245,8 @@ static unsigned int imx_pcie_grp_offset(
 
 static int imx95_pcie_init_phy(struct imx_pcie *imx_pcie)
 {
+	bool ext = imx_pcie->enable_ext_refclk;
+
 	/*
 	 * ERR051624: The Controller Without Vaux Cannot Exit L23 Ready
 	 * Through Beacon or PERST# De-assertion
@@ -262,13 +265,12 @@ static int imx95_pcie_init_phy(struct im
 			IMX95_PCIE_PHY_CR_PARA_SEL,
 			IMX95_PCIE_PHY_CR_PARA_SEL);
 
-	regmap_update_bits(imx_pcie->iomuxc_gpr,
-			   IMX95_PCIE_PHY_GEN_CTRL,
-			   IMX95_PCIE_REF_USE_PAD, 0);
-	regmap_update_bits(imx_pcie->iomuxc_gpr,
-			   IMX95_PCIE_SS_RW_REG_0,
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_PHY_GEN_CTRL,
+			   IMX95_PCIE_REF_USE_PAD,
+			   ext ? IMX95_PCIE_REF_USE_PAD : 0);
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_0,
 			   IMX95_PCIE_REF_CLKEN,
-			   IMX95_PCIE_REF_CLKEN);
+			   ext ? 0 : IMX95_PCIE_REF_CLKEN);
 
 	return 0;
 }


