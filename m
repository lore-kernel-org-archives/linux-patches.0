Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAAD499F0C;
	Wed,  9 Sep 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964700; cv=none; b=f4ultjs0jXWn5dILMqCZaAgTBAJMYaih7bblLQA19Q8bX+fy281MsqsTVjyJMtcOA5oj10n2u443iOXtjVeRlVPZgKSEqlkY/YuorJB/1jaO91e2ayvgeBSLTyWmXWuvLo4u5fvuenc/7rtLNeByczt4D5f2wj7tjNV/r1eq9vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964700; c=relaxed/simple;
	bh=HUqFuH8sdUs3Xx1ql3B4Po1opdn28UyQrBkjZrQJ0ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bb21CR5IFYiI9haRZnPD1ZQl6p1SE4/ey5CwbpMyjAQz6jdV/sIdogB14QnV9I+lt5KijlqovkfsVvHI2KcaCtAOQnwG4gaEmy6wR5+uy0pMyNj62fmSSdAbPcw9zw0JRvxNIN2IUXjaPPQDXe4miKi3gOP7g04rTADjCk061Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEL3wa0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEL3wa0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117321F00A3A;
	Wed,  9 Sep 2026 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964699;
	bh=c2MReSZEGdZjMgboL+kBY8AyQAiuVa1E0XWvCa3VRKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEL3wa0RujKDH9dxk5Sqb/aXFsxe1ncZsZv4vaWnau30sqCMnIaCbPuKkZM+L1piv
	 fm+bD9TTLLBdcRUQQOr9dGne1THeUkjlXcwHElEJPZwlDN4iFACJcP7K06ka/zJrQC
	 FfltT1O7gQx8fFQbGnu9aoD8gULhHV3ij7Flui1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Kevin Xie <kevin.xie@starfivetech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/583] PCI: starfive: Use regulator APIs to control the 3v3 power supply of PCIe slots
Date: Wed,  9 Sep 2026 15:43:17 +0200
Message-ID: <20260909134255.479580394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


