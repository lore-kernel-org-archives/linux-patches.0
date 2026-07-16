Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06A41F5EC;
	Thu, 16 Jul 2026 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209304; cv=none; b=IqhuXTYylqbxAJ5u2Z+Qf034Cuo28oXWOJ3hw2/mDJ6uO3JHoDmjILNUYsEDiJuQe+57ahW9D+E23/8e/zXmXFThytodPrNUIme80Nvq1KKxWMZxDyAfN3YYUV/g/YZQcPXrZvQmsdqwBdj1cfFNdr5GEfFIXXPobKCppxTqgO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209304; c=relaxed/simple;
	bh=UF5EucKlcHTrCZFgSHKLMrfRWB+RLB6QL0zkUs9SDsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbDMvnWMQsw098MHIYCvtDKp8I3OY8uWIpNfzuJaEzJc59ucrTtgIkiw37zqs5c31ZZOXm+PmZjWqzWeCJOwCtdOp9qc2NwjVpwidk9bWBblzq4SDUL9oR0BfT8fQU5DjmcSoNE2O/AlYixUtLPqb6AUbBBBTiNVOUGiYuQxQAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xf9Z3oIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xf9Z3oIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994471F000E9;
	Thu, 16 Jul 2026 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209303;
	bh=HSKgLqu0mJvyu8gB4C6T2mB/uqK4H4XPGQ0+KBbP/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xf9Z3oIrpCZN1MJNd0d8ZEQ6pjchAIu17rHhMajixBHwvMFEMApR+FnlSi7rgxgZ9
	 bM25mq7n8dhZPKNnpF0Km+x/b+iRTbPLJ7UsChkUToszXWv6wVxPejdnbtyLsjWCkx
	 1viPZNUwCVTjdY60iwBbB928lx1IeEBn/QqQ6+04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.1 135/518] PCI: imx6: Assert ref_clk_en after reference clock stabilizes on i.MX95
Date: Thu, 16 Jul 2026 15:26:43 +0200
Message-ID: <20260716133050.809561592@linuxfoundation.org>
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

commit 9dda3f83ba677b9cc2613cecd9120123000ae50f upstream.

According to the PHY Databook Common Block Signals section, the
ref_clk_en signal must remain de-asserted until the reference clock is
running at the appropriate frequency. Once the clock is stable,
ref_clk_en can be asserted. For lower power states where the reference
clock to the PHY is disabled, ref_clk_en should also be de-asserted.

Move the ref_clk_en bit manipulation into imx95_pcie_enable_ref_clk()
to ensure the reference clock stabilizes before ref_clk_en is asserted
and before the PHY reset is de-asserted. This aligns with the timing
requirements specified in the PHY documentation.

Fixes: d8574ce57d76 ("PCI: imx6: Add external reference clock input mode support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260518072715.3166514-3-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -268,8 +268,6 @@ static int imx95_pcie_select_ref_clk_src
 
 static int imx95_pcie_init_phy(struct imx_pcie *imx_pcie)
 {
-	bool ext = imx_pcie->enable_ext_refclk;
-
 	/*
 	 * ERR051624: The Controller Without Vaux Cannot Exit L23 Ready
 	 * Through Beacon or PERST# De-assertion
@@ -288,10 +286,6 @@ static int imx95_pcie_init_phy(struct im
 			IMX95_PCIE_PHY_CR_PARA_SEL,
 			IMX95_PCIE_PHY_CR_PARA_SEL);
 
-	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_0,
-			   IMX95_PCIE_REF_CLKEN,
-			   ext ? 0 : IMX95_PCIE_REF_CLKEN);
-
 	return 0;
 }
 
@@ -740,7 +734,29 @@ static void imx95_pcie_clkreq_override(s
 
 static int imx95_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 {
+	bool ext = imx_pcie->enable_ext_refclk;
+
 	imx95_pcie_clkreq_override(imx_pcie, enable);
+	/*
+	 * The ref_clk_en signal must remain de-asserted until the
+	 * reference clock is running at appropriate frequency, at which
+	 * point this bit can be asserted. For lower power states where
+	 * the reference clock to the PHY is disabled, it may also be
+	 * de-asserted.
+	 * +------------------- -+--------+----------------+
+	 * | External clock mode | Enable | PCIE_REF_CLKEN |
+	 * +---------------------+--------+----------------+
+	 * | TRUE                | X      | 1b'0           |
+	 * +---------------------+--------+----------------+
+	 * | FALSE               | TRUE   | 1b'1           |
+	 * +---------------------+--------+----------------+
+	 * | FALSE               | FALSE  | 1b'0           |
+	 * +---------------------+--------+----------------+
+	 */
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_0,
+			   IMX95_PCIE_REF_CLKEN,
+			   ext || !enable ? 0 : IMX95_PCIE_REF_CLKEN);
+
 	return 0;
 }
 


