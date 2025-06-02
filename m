Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A689D1E3772;
	Mon,  2 Jun 2025 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876593; cv=none; b=AdN44DnldM7IG42iqUqhKOMRJ2wDIUkJH7W4PoOcfx23GAVxsOd0wdFoK0cxlzK75JyN2JJjvGUP2ueMOqklo0mmMOW2B1K0Ics3gfsd46fM7KnKBmmt3s5vcBKtzntQptwr7/6p+94eCyrFzD9IPoZlHQXHBXRmWh226FzDFdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876593; c=relaxed/simple;
	bh=ArbNSIPq475ScAyD3x0VaTvPxkga703x1DPKqq2FvnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPsGBLxQb+OdmpcFgGlwZcLqLxXs4fzwUlgYD02mwfrYM1BI8H6/Im+jhqw8+qJyLYdWkrmLdX77F9UhVCuhGinbyQpG5lGyNh/GU0Ntfg2mYIT1ASRuQ5Fj9r6HXnQPtbcqJv3+xb+PsQJYuWX8lLVzyQZtc60l/LpWmqu9NvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMVxRH6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMVxRH6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14672C4CEEB;
	Mon,  2 Jun 2025 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876593;
	bh=ArbNSIPq475ScAyD3x0VaTvPxkga703x1DPKqq2FvnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMVxRH6hqNCimDUeHQRbBoB072bYr3pj70PDuh35PTy1MStxTZjHoCfdFKBBXh1rk
	 q0ZLX6GqQhOgXnL9hEkP8PQbCEtkfsocQbiNV1llSZUKRVLY3QYAGyv0VuFKsF2Tbv
	 9AQCkNhqT/hze3BRLPgz9VIfuv50WEFD5oduAZb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/325] phy: renesas: rcar-gen3-usb2: Add support to initialize the bus
Date: Mon,  2 Jun 2025 15:44:41 +0200
Message-ID: <20250602134319.947200760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3824e338b61e5..d13083f60d897 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -21,12 +21,14 @@
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
@@ -42,6 +44,10 @@
 #define USB2_INT_ENABLE_USBH_INTB_EN	BIT(2)	/* For EHCI */
 #define USB2_INT_ENABLE_USBH_INTA_EN	BIT(1)	/* For OHCI */
 
+/* AHB_BUS_CTR */
+#define USB2_AHB_BUS_CTR_MBL_MASK	GENMASK(1, 0)
+#define USB2_AHB_BUS_CTR_MBL_INCR4	2
+
 /* USBCTR */
 #define USB2_USBCTR_DIRPD	BIT(2)
 #define USB2_USBCTR_PLL_RST	BIT(1)
@@ -112,6 +118,7 @@ struct rcar_gen3_chan {
 	struct extcon_dev *extcon;
 	struct rcar_gen3_phy rphys[NUM_OF_PHYS];
 	struct regulator *vbus;
+	struct reset_control *rstc;
 	struct work_struct work;
 	struct mutex lock;	/* protects rphys[...].powered */
 	enum usb_dr_mode dr_mode;
@@ -126,6 +133,7 @@ struct rcar_gen3_chan {
 struct rcar_gen3_phy_drv_data {
 	const struct phy_ops *phy_usb2_ops;
 	bool no_adp_ctrl;
+	bool init_bus;
 };
 
 /*
@@ -647,6 +655,35 @@ static enum usb_dr_mode rcar_gen3_get_dr_mode(struct device_node *np)
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
@@ -700,6 +737,15 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
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
@@ -727,9 +773,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 		channel->vbus = NULL;
 	}
 
-	platform_set_drvdata(pdev, channel);
-	channel->dev = dev;
-
 	provider = devm_of_phy_provider_register(dev, rcar_gen3_phy_usb2_xlate);
 	if (IS_ERR(provider)) {
 		dev_err(dev, "Failed to register PHY provider\n");
@@ -756,6 +799,7 @@ static int rcar_gen3_phy_usb2_remove(struct platform_device *pdev)
 	if (channel->is_otg_channel)
 		device_remove_file(&pdev->dev, &dev_attr_role);
 
+	reset_control_assert(channel->rstc);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
2.39.5



