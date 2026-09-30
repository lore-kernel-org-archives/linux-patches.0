Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764CF5218B2;
	Wed, 30 Sep 2026 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789714; cv=none; b=JfWqShNodUcbya5ZQGVak3NEJmYMfIu8HHST8xY2ti0jlCv3CcfimI5cDmGBehLsGFwZ3sAMbd2xEKHCh90MSapfg1taa1MU7bJKUk34yE4KaWC4MuHF3+rByAKP3X0gj53Hq1IfhAgq2NMsNaiNe+spHsLwqUJS7pkCzrSYAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789714; c=relaxed/simple;
	bh=orCe9chQfG1stY09q8Y/LG1lm3piJW28Nd88icvVPuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS1soCIvBIJE9/TmQsF15cAQb3cQ9xZPruytCQ/v/AlhZb/3nBoGCztfzUHCpyFSbes/xv0MGW2shB0zbNqsEdRIdTDqzpQsdZRkXQTCMmWeLKQl3b54SHaZYNOIyQWp/uTWIJwAm9lpo3XCVhuWKFMKeFPMYVJrh7We/WM1UFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxldKpMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxldKpMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3C61F00898;
	Wed, 30 Sep 2026 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789712;
	bh=khPa8pfeuPl8GOr9ZxKgBWVnJyxa8rxy0xSw1Ld3ODM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxldKpMum2mpSWf6f2ZOrotWocYMfxRA8owLEfsZ5X/3TNOkxeenpYiZ5iPsYcJM0
	 tjItKXLpC8nqZKsI8Rt6m0kGB05iKlp+dXbBo1qt4878C3jBJe4p98BExuH1Kvk3k5
	 vTbAlsGABr2tHHz1FOGE5mdD6onzblZO2Wsdi/kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Kevin Xie <kevin.xie@starfivetech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 573/877] PCI: starfive: Use regulator APIs to control the 3v3 power supply of PCIe slots
Date: Wed, 30 Sep 2026 17:24:44 +0200
Message-ID: <20260930152427.006002471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 05a75df4182e301a1b0059606f77b65c74deaa9b ]

The driver has been using the "enable-gpios" property to control the 3v3
power supply of PCIe slots. But it is not documented in the dt-bindings and
also using GPIO APIs is not a standard way to control PCIe slot power, so
use the documented "vpcie3v3-supply" property and regulator APIs to control
the slot supply.

This change will break the DTs which used "enable-gpio" or "enable-gpios"
property under the controller node. Since these properties were not defined
in the bindings, it is safe to switch to "vpcie3v3-supply". Any out-of-tree
DTS impacted by this change should migrate to "vpcie3v3-supply" instead.

Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Kevin Xie <kevin.xie@starfivetech.com>
Link: https://patch.msgid.link/20251218102149.28062-1-hal.feng@starfivetech.com
Stable-dep-of: 22877a061f81 ("PCI: starfive: Fix resource leaks on error paths in host_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/plda/pcie-starfive.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -55,7 +55,7 @@ struct starfive_jh7110_pcie {
 	struct reset_control *resets;
 	struct clk_bulk_data *clks;
 	struct regmap *reg_syscon;
-	struct gpio_desc *power_gpio;
+	struct regulator *vpcie3v3;
 	struct gpio_desc *reset_gpio;
 	struct phy *phy;
 
@@ -153,11 +153,13 @@ static int starfive_pcie_parse_dt(struct
 		return dev_err_probe(dev, PTR_ERR(pcie->reset_gpio),
 				     "failed to get perst-gpio\n");
 
-	pcie->power_gpio = devm_gpiod_get_optional(dev, "enable",
-						   GPIOD_OUT_LOW);
-	if (IS_ERR(pcie->power_gpio))
-		return dev_err_probe(dev, PTR_ERR(pcie->power_gpio),
-				     "failed to get power-gpio\n");
+	pcie->vpcie3v3 = devm_regulator_get_optional(dev, "vpcie3v3");
+	if (IS_ERR(pcie->vpcie3v3)) {
+		if (PTR_ERR(pcie->vpcie3v3) != -ENODEV)
+			return dev_err_probe(dev, PTR_ERR(pcie->vpcie3v3),
+					     "failed to get vpcie3v3 regulator\n");
+		pcie->vpcie3v3 = NULL;
+	}
 
 	return 0;
 }
@@ -270,8 +272,8 @@ static void starfive_pcie_host_deinit(st
 		container_of(plda, struct starfive_jh7110_pcie, plda);
 
 	starfive_pcie_clk_rst_deinit(pcie);
-	if (pcie->power_gpio)
-		gpiod_set_value_cansleep(pcie->power_gpio, 0);
+	if (pcie->vpcie3v3)
+		regulator_disable(pcie->vpcie3v3);
 	starfive_pcie_disable_phy(pcie);
 }
 
@@ -304,8 +306,11 @@ static int starfive_pcie_host_init(struc
 	if (ret)
 		return ret;
 
-	if (pcie->power_gpio)
-		gpiod_set_value_cansleep(pcie->power_gpio, 1);
+	if (pcie->vpcie3v3) {
+		ret = regulator_enable(pcie->vpcie3v3);
+		if (ret)
+			dev_err_probe(dev, ret, "failed to enable vpcie3v3 regulator\n");
+	}
 
 	if (pcie->reset_gpio)
 		gpiod_set_value_cansleep(pcie->reset_gpio, 1);


