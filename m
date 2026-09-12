Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA832ECD1D;
	Sat, 12 Sep 2026 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224973; cv=none; b=dur+5PEfxdv0Ch9nsUbhAZFd5Fbr7Kh/vB78S/TtrnsDe+uh7G4YcZoKmMy1f2XZj+yAPppfIfApk8iZjRrJVRt0l0u01c5ssk6hvtSe1lMtDOmhhaLf24HR4DO1eH4aHzOhq41wcOrt2ohm1mki1mWt3DzH73G/oHroY6GNozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224973; c=relaxed/simple;
	bh=pthgFT9e08utnnIyuOv3JQ/N7oVX4ATHmtqjBj7Twdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l21HA9TrW8YEqpGOFs+ettJC5ywMFuyKwqtIwlwJXasTIUr6PDEMNliYJyDJyDMXIyCj8rNa8RFvVFf3Ykc3GkpG2YXzXyQKzOBP2uNYgmExYYr4cJBuP+NMXBBPbi2XJUOKW5mVpGQMmfCEr1e1AXpLhZZGYNVEOu2SP5rCwYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khA1LB/o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khA1LB/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145CE1F000FF;
	Sat, 12 Sep 2026 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224972;
	bh=qsAVj4SZxxyKTZczUgskbmO7cnsVxzOKKFxLKW9aP9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khA1LB/oe3xcOAzK+VqJQskm2VN6MNhT0dfwSu8DbBt4dCEl+bq3wZnqmkanWSX1V
	 2Yc9Us0dcjqbyK0hyM3hf/UBcVRhIIVOnRc0zhB2GNJ44zwHtCwAqlKKCBJvCcRKUT
	 vFWWqpy1LXsVNVed/Jg0guchl4CpOxCoiX9/ZeQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1104/1424] phy: qcom: sgmii-eth: vote for both voltage rails with correct current loads
Date: Sat, 12 Sep 2026 08:58:56 +0200
Message-ID: <20260912065632.028189076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit 4f81684a1d1018d7d0e5579f08d95e7701279358 ]

The SerDes PHY has two voltage supply rails, vdda-0p9 and vdda-1p2,
that must both be enabled for calibration to succeed. Without them:

  qcom-dwmac-sgmii-phy 8909000.phy: QSERDES_COM_C_READY_STATUS timed-out
  qcom-ethqos 23040000.ethernet eth0: __stmmac_open: Serdes powerup failed

The driver relied solely on the PHY framework's implicit enable of
'phy-supply', which only voted for a single rail and set no current
load. Use devm_regulator_bulk_get_const() to acquire both supplies and
set the peak current loads (46 mA for vdda-0p9, 15 mA for vdda-1p2)
as required by the hardware.

Fixes: 601d06277007 ("phy: qcom: add the SGMII SerDes PHY driver")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-2-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-sgmii-eth.c | 37 ++++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
index 43ff0c5551e3b..9a2a6d0c15423 100644
--- a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
+++ b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
@@ -10,6 +10,7 @@
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 
 #define QSERDES_QMP_PLL					0x0
 #define QSERDES_COM_BIN_VCOCAL_CMP_CODE1_MODE0		(QSERDES_QMP_PLL + 0x1ac)
@@ -104,7 +105,15 @@
 #define QSERDES_PCS_SGMIIPHY_READY			BIT(7)
 #define QSERDES_COM_C_PLL_LOCKED			BIT(1)
 
+static const struct regulator_bulk_data qcom_dwmac_sgmii_phy_vregs[] = {
+	{ .supply = "vdda-0p9", .init_load_uA = 46000 },
+	{ .supply = "vdda-1p2", .init_load_uA = 15000 },
+};
+
+#define QCOM_SGMII_NUM_SUPPLIES		ARRAY_SIZE(qcom_dwmac_sgmii_phy_vregs)
+
 struct qcom_dwmac_sgmii_phy_data {
+	struct regulator_bulk_data *vregs;
 	struct regmap *regmap;
 	struct clk *refclk;
 	int speed;
@@ -348,13 +357,24 @@ static int qcom_dwmac_sgmii_phy_power_on(struct phy *phy)
 	struct qcom_dwmac_sgmii_phy_data *data = phy_get_drvdata(phy);
 	int ret;
 
-	ret = clk_prepare_enable(data->refclk);
-	if (ret < 0)
+	ret = regulator_bulk_enable(QCOM_SGMII_NUM_SUPPLIES, data->vregs);
+	if (ret)
 		return ret;
 
+	ret = clk_prepare_enable(data->refclk);
+	if (ret)
+		goto err_disable_regulators;
+
 	ret = qcom_dwmac_sgmii_phy_calibrate(phy);
-	if (ret < 0)
-		clk_disable_unprepare(data->refclk);
+	if (ret)
+		goto err_disable_clk;
+
+	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(data->refclk);
+err_disable_regulators:
+	regulator_bulk_disable(QCOM_SGMII_NUM_SUPPLIES, data->vregs);
 
 	return ret;
 }
@@ -371,6 +391,8 @@ static int qcom_dwmac_sgmii_phy_power_off(struct phy *phy)
 
 	clk_disable_unprepare(data->refclk);
 
+	regulator_bulk_disable(QCOM_SGMII_NUM_SUPPLIES, data->vregs);
+
 	return 0;
 }
 
@@ -410,6 +432,7 @@ static int qcom_dwmac_sgmii_phy_probe(struct platform_device *pdev)
 	struct phy_provider *provider;
 	void __iomem *base;
 	struct phy *phy;
+	int ret;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -434,6 +457,12 @@ static int qcom_dwmac_sgmii_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(data->refclk))
 		return PTR_ERR(data->refclk);
 
+	ret = devm_regulator_bulk_get_const(dev, QCOM_SGMII_NUM_SUPPLIES,
+					    qcom_dwmac_sgmii_phy_vregs,
+					    &data->vregs);
+	if (ret)
+		return ret;
+
 	provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (IS_ERR(provider))
 		return PTR_ERR(provider);
-- 
2.53.0



