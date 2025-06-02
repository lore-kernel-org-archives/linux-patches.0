Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0F320F07C;
	Mon,  2 Jun 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873134; cv=none; b=Z+Hz4ueQF2dZpCn34k8Ph4PtCZTNj/8EOF6aJIkM6hiX899Z4uxw5zWpZV/jFFEscaS5qPgIpF3PrcyVkIzRZ+Ok09lOSk4rkMuJAshxqmL9YaxsgFdjvqAid8pe9i/YrkOUGL5FZ9k2OY7+ivbSV10XXHTfv6bKgue5vPLbbaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873134; c=relaxed/simple;
	bh=A6n1IRx97fYxNFoCyEkHcBhcADRLemk6tI4arEFNG+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmcnL4r2P06k97PEz9Rhbdk42tVcGQwwAUdsOgVfdkuKyEokXf7PcmC07fWLW1LHEoz4GAlqUewGYvKP/Qc3IEJcFL8Z98U3QF6syUBhOWC+D+xKt3UI6l0La0SnSWAae3sWqVzaGbKFsyXIVsxhosD20yi93oLEuqtOxoK342I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa3G7Uxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa3G7Uxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A21C4CEEB;
	Mon,  2 Jun 2025 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873133;
	bh=A6n1IRx97fYxNFoCyEkHcBhcADRLemk6tI4arEFNG+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pa3G7UxljM1WNN55NRnK9B+S/aL4ZTLEf00Qo6PKjJhFc7k9X6LpWim0IqnMV7luN
	 H3B5r5dTsKpRP7X6rYDrFNrF1oPggl3HiIuvqCsj5kwmb3dnxh4VPW8e91g4Tm7BzW
	 Z8XNCBiMTpzcFwmX+WpUY0HtxYsGjLfnmUl4n614=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/444] phy: renesas: rcar-gen3-usb2: Add support to initialize the bus
Date: Mon,  2 Jun 2025 15:41:12 +0200
Message-ID: <20250602134341.249566530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 4eae16375357a2a7e8501be5469532f7636064b3 ]

The Renesas RZ/G3S need to initialize the USB BUS before transferring data
due to hardware limitation. As the register that need to be touched for
this is in the address space of the USB PHY, and the UBS PHY need to be
initialized before any other USB drivers handling data transfer, add
support to initialize the USB BUS.

As the USB PHY is probed before any other USB drivers that enables
clocks and de-assert the reset signals and the BUS initialization is done
in the probe phase, we need to add code to de-assert reset signal and
runtime resume the device (which enables its clocks) before accessing
the registers.

As the reset signals are not required by the USB PHY driver for the other
USB PHY hardware variants, the reset signals and runtime PM was handled
only in the function that initialize the USB BUS.

The PHY initialization was done right after runtime PM enable to have
all in place when the PHYs are registered.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20240822152801.602318-11-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 9ce71e85b29e ("phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 50 ++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index aa578be2bcb6d..d2bbf6c6ed5e0 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -19,12 +19,14 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
+#include <linux/reset.h>
 #include <linux/string.h>
 #include <linux/usb/of.h>
 #include <linux/workqueue.h>
 
 /******* USB2.0 Host registers (original offset is +0x200) *******/
 #define USB2_INT_ENABLE		0x000
+#define USB2_AHB_BUS_CTR	0x008
 #define USB2_USBCTR		0x00c
 #define USB2_SPD_RSM_TIMSET	0x10c
 #define USB2_OC_TIMSET		0x110
@@ -40,6 +42,10 @@
 #define USB2_INT_ENABLE_USBH_INTB_EN	BIT(2)	/* For EHCI */
 #define USB2_INT_ENABLE_USBH_INTA_EN	BIT(1)	/* For OHCI */
 
+/* AHB_BUS_CTR */
+#define USB2_AHB_BUS_CTR_MBL_MASK	GENMASK(1, 0)
+#define USB2_AHB_BUS_CTR_MBL_INCR4	2
+
 /* USBCTR */
 #define USB2_USBCTR_DIRPD	BIT(2)
 #define USB2_USBCTR_PLL_RST	BIT(1)
@@ -110,6 +116,7 @@ struct rcar_gen3_chan {
 	struct extcon_dev *extcon;
 	struct rcar_gen3_phy rphys[NUM_OF_PHYS];
 	struct regulator *vbus;
+	struct reset_control *rstc;
 	struct work_struct work;
 	struct mutex lock;	/* protects rphys[...].powered */
 	enum usb_dr_mode dr_mode;
@@ -124,6 +131,7 @@ struct rcar_gen3_chan {
 struct rcar_gen3_phy_drv_data {
 	const struct phy_ops *phy_usb2_ops;
 	bool no_adp_ctrl;
+	bool init_bus;
 };
 
 /*
@@ -645,6 +653,35 @@ static enum usb_dr_mode rcar_gen3_get_dr_mode(struct device_node *np)
 	return candidate;
 }
 
+static int rcar_gen3_phy_usb2_init_bus(struct rcar_gen3_chan *channel)
+{
+	struct device *dev = channel->dev;
+	int ret;
+	u32 val;
+
+	channel->rstc = devm_reset_control_array_get_shared(dev);
+	if (IS_ERR(channel->rstc))
+		return PTR_ERR(channel->rstc);
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret)
+		return ret;
+
+	ret = reset_control_deassert(channel->rstc);
+	if (ret)
+		goto rpm_put;
+
+	val = readl(channel->base + USB2_AHB_BUS_CTR);
+	val &= ~USB2_AHB_BUS_CTR_MBL_MASK;
+	val |= USB2_AHB_BUS_CTR_MBL_INCR4;
+	writel(val, channel->base + USB2_AHB_BUS_CTR);
+
+rpm_put:
+	pm_runtime_put(dev);
+
+	return ret;
+}
+
 static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 {
 	const struct rcar_gen3_phy_drv_data *phy_data;
@@ -698,6 +735,15 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 		goto error;
 	}
 
+	platform_set_drvdata(pdev, channel);
+	channel->dev = dev;
+
+	if (phy_data->init_bus) {
+		ret = rcar_gen3_phy_usb2_init_bus(channel);
+		if (ret)
+			goto error;
+	}
+
 	channel->soc_no_adp_ctrl = phy_data->no_adp_ctrl;
 	if (phy_data->no_adp_ctrl)
 		channel->obint_enable_bits = USB2_OBINT_IDCHG_EN;
@@ -725,9 +771,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 		channel->vbus = NULL;
 	}
 
-	platform_set_drvdata(pdev, channel);
-	channel->dev = dev;
-
 	provider = devm_of_phy_provider_register(dev, rcar_gen3_phy_usb2_xlate);
 	if (IS_ERR(provider)) {
 		dev_err(dev, "Failed to register PHY provider\n");
@@ -754,6 +797,7 @@ static void rcar_gen3_phy_usb2_remove(struct platform_device *pdev)
 	if (channel->is_otg_channel)
 		device_remove_file(&pdev->dev, &dev_attr_role);
 
+	reset_control_assert(channel->rstc);
 	pm_runtime_disable(&pdev->dev);
 };
 
-- 
2.39.5



