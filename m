Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758083418E;
	Fri, 24 Nov 2023 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRC9hUM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0131CC433C7;
	Fri, 24 Nov 2023 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853598;
	bh=/footT9qhJIeqSYNc/fdB7tt+vpqAojgbP6FJkMTUS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRC9hUM/Vc/DCadCLAfOWSjTu940lQNJHo6oEPHE31SQw1PX3Bx4ldKml+Yrloe0I
	 CcrheBrvuOkqZb/U6xXhK7nWWpg/ym+H09M1YLew/qc/lPVjpxsElmhWOwMDyrj2uP
	 y/WMECJVPE9+vcB/b4AFPfvkN1Zy8fRI3YdiYNjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Andi Shyti <andi.shyti@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Linus Walleij <linus.walleij@linaro.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 253/297] Revert "i2c: pxa: move to generic GPIO recovery"
Date: Fri, 24 Nov 2023 17:54:55 +0000
Message-ID: <20231124172009.025282162@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

commit 7b211c7671212cad0b83603c674838c7e824d845 upstream.

This reverts commit 0b01392c18b9993a584f36ace1d61118772ad0ca.

Conversion of PXA to generic I2C recovery, makes the I2C bus completely
lock up if recovery pinctrl is present in the DT and I2C recovery is
enabled.

So, until the generic I2C recovery can also work with PXA lets revert
to have working I2C and I2C recovery again.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: stable@vger.kernel.org # 5.11+
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-pxa.c |   76 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 8 deletions(-)

--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -264,6 +264,9 @@ struct pxa_i2c {
 	u32			hs_mask;
 
 	struct i2c_bus_recovery_info recovery;
+	struct pinctrl		*pinctrl;
+	struct pinctrl_state	*pinctrl_default;
+	struct pinctrl_state	*pinctrl_recovery;
 };
 
 #define _IBMR(i2c)	((i2c)->reg_ibmr)
@@ -1302,12 +1305,13 @@ static void i2c_pxa_prepare_recovery(str
 	 */
 	gpiod_set_value(i2c->recovery.scl_gpiod, ibmr & IBMR_SCLS);
 	gpiod_set_value(i2c->recovery.sda_gpiod, ibmr & IBMR_SDAS);
+
+	WARN_ON(pinctrl_select_state(i2c->pinctrl, i2c->pinctrl_recovery));
 }
 
 static void i2c_pxa_unprepare_recovery(struct i2c_adapter *adap)
 {
 	struct pxa_i2c *i2c = adap->algo_data;
-	struct i2c_bus_recovery_info *bri = adap->bus_recovery_info;
 	u32 isr;
 
 	/*
@@ -1321,7 +1325,7 @@ static void i2c_pxa_unprepare_recovery(s
 		i2c_pxa_do_reset(i2c);
 	}
 
-	WARN_ON(pinctrl_select_state(bri->pinctrl, bri->pins_default));
+	WARN_ON(pinctrl_select_state(i2c->pinctrl, i2c->pinctrl_default));
 
 	dev_dbg(&i2c->adap.dev, "recovery: IBMR 0x%08x ISR 0x%08x\n",
 	        readl(_IBMR(i2c)), readl(_ISR(i2c)));
@@ -1343,20 +1347,76 @@ static int i2c_pxa_init_recovery(struct
 	if (IS_ENABLED(CONFIG_I2C_PXA_SLAVE))
 		return 0;
 
-	bri->pinctrl = devm_pinctrl_get(dev);
-	if (PTR_ERR(bri->pinctrl) == -ENODEV) {
-		bri->pinctrl = NULL;
+	i2c->pinctrl = devm_pinctrl_get(dev);
+	if (PTR_ERR(i2c->pinctrl) == -ENODEV)
+		i2c->pinctrl = NULL;
+	if (IS_ERR(i2c->pinctrl))
+		return PTR_ERR(i2c->pinctrl);
+
+	if (!i2c->pinctrl)
+		return 0;
+
+	i2c->pinctrl_default = pinctrl_lookup_state(i2c->pinctrl,
+						    PINCTRL_STATE_DEFAULT);
+	i2c->pinctrl_recovery = pinctrl_lookup_state(i2c->pinctrl, "recovery");
+
+	if (IS_ERR(i2c->pinctrl_default) || IS_ERR(i2c->pinctrl_recovery)) {
+		dev_info(dev, "missing pinmux recovery information: %ld %ld\n",
+			 PTR_ERR(i2c->pinctrl_default),
+			 PTR_ERR(i2c->pinctrl_recovery));
+		return 0;
+	}
+
+	/*
+	 * Claiming GPIOs can influence the pinmux state, and may glitch the
+	 * I2C bus. Do this carefully.
+	 */
+	bri->scl_gpiod = devm_gpiod_get(dev, "scl", GPIOD_OUT_HIGH_OPEN_DRAIN);
+	if (bri->scl_gpiod == ERR_PTR(-EPROBE_DEFER))
+		return -EPROBE_DEFER;
+	if (IS_ERR(bri->scl_gpiod)) {
+		dev_info(dev, "missing scl gpio recovery information: %pe\n",
+			 bri->scl_gpiod);
+		return 0;
+	}
+
+	/*
+	 * We have SCL. Pull SCL low and wait a bit so that SDA glitches
+	 * have no effect.
+	 */
+	gpiod_direction_output(bri->scl_gpiod, 0);
+	udelay(10);
+	bri->sda_gpiod = devm_gpiod_get(dev, "sda", GPIOD_OUT_HIGH_OPEN_DRAIN);
+
+	/* Wait a bit in case of a SDA glitch, and then release SCL. */
+	udelay(10);
+	gpiod_direction_output(bri->scl_gpiod, 1);
+
+	if (bri->sda_gpiod == ERR_PTR(-EPROBE_DEFER))
+		return -EPROBE_DEFER;
+
+	if (IS_ERR(bri->sda_gpiod)) {
+		dev_info(dev, "missing sda gpio recovery information: %pe\n",
+			 bri->sda_gpiod);
 		return 0;
 	}
-	if (IS_ERR(bri->pinctrl))
-		return PTR_ERR(bri->pinctrl);
 
 	bri->prepare_recovery = i2c_pxa_prepare_recovery;
 	bri->unprepare_recovery = i2c_pxa_unprepare_recovery;
+	bri->recover_bus = i2c_generic_scl_recovery;
 
 	i2c->adap.bus_recovery_info = bri;
 
-	return 0;
+	/*
+	 * Claiming GPIOs can change the pinmux state, which confuses the
+	 * pinctrl since pinctrl's idea of the current setting is unaffected
+	 * by the pinmux change caused by claiming the GPIO. Work around that
+	 * by switching pinctrl to the GPIO state here. We do it this way to
+	 * avoid glitching the I2C bus.
+	 */
+	pinctrl_select_state(i2c->pinctrl, i2c->pinctrl_recovery);
+
+	return pinctrl_select_state(i2c->pinctrl, i2c->pinctrl_default);
 }
 
 static int i2c_pxa_probe(struct platform_device *dev)


