Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B6A2773EE;
	Mon, 23 Mar 2026 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278625; cv=none; b=r1jnfbod/zozpDe/tgE8ua9M1KCpyPxPvlIH+5nbcM9m9CGAmk15Ag0hdXvxHmx/7pTAGLZ66lMC5oqMKEQ8zajAbl/IwKWWqOgocKX4iBJSmIzk0S6PUQVXblxaKScRuy6EXDgUNNqasioNiEBNEVoEfHWX8vaGzqb8A2wNv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278625; c=relaxed/simple;
	bh=TrVkD5ij3mCV4XbfyP7HF4lOaqQHQEVP7j8lDlpDAko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdqOHU0h/49W3y/eMfOVaCvf9VT0dPakWay5y+9BUaGbGa56SkWpZixamnMTkO77QMbX2+87TO65kL5TRshppNaQ4L2P/Th7LuE5qT2lH9mCcdnXZhZ5y4dqQMoJRGZp6zVy/N2rylRzOVXRZE58ZREV+KpAHSKW3VSq4p6cryY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM4xt0ID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM4xt0ID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEE2C4CEF7;
	Mon, 23 Mar 2026 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278625;
	bh=TrVkD5ij3mCV4XbfyP7HF4lOaqQHQEVP7j8lDlpDAko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM4xt0IDeANI4iXv1c2u9Gl3HluJSJS7s6wusE+zKP6WzDArSIo+vHIk8I5LYn/5X
	 vEeQzqEtXPko4HUrBPGEq+UtaUR6Vsk17StB46BV27/7LN4jGi15gY5+WfdhdZ72hz
	 HLRW56kW07O21W+Q2l9J4EwqQo1h/WwCKyHTdVSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ripple <john.ripple@keysight.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.6 365/567] drm/bridge: ti-sn65dsi86: Add support for DisplayPort mode with HPD
Date: Mon, 23 Mar 2026 14:44:45 +0100
Message-ID: <20260323134542.849772502@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: John Ripple <john.ripple@keysight.com>

commit 9133bc3f0564890218cbba6cc7e81ebc0841a6f1 upstream.

Add support for DisplayPort to the bridge, which entails the following:
- Get and use an interrupt for HPD;
- Properly clear all status bits in the interrupt handler;

Signed-off-by: John Ripple <john.ripple@keysight.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250915174543.2564994-1-john.ripple@keysight.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c |  112 ++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -106,10 +106,21 @@
 #define SN_PWM_EN_INV_REG			0xA5
 #define  SN_PWM_INV_MASK			BIT(0)
 #define  SN_PWM_EN_MASK				BIT(1)
+
+#define SN_IRQ_EN_REG				0xE0
+#define  IRQ_EN					BIT(0)
+
+#define SN_IRQ_EVENTS_EN_REG			0xE6
+#define  HPD_INSERTION_EN			BIT(1)
+#define  HPD_REMOVAL_EN				BIT(2)
+
 #define SN_AUX_CMD_STATUS_REG			0xF4
 #define  AUX_IRQ_STATUS_AUX_RPLY_TOUT		BIT(3)
 #define  AUX_IRQ_STATUS_AUX_SHORT		BIT(5)
 #define  AUX_IRQ_STATUS_NAT_I2C_FAIL		BIT(6)
+#define SN_IRQ_STATUS_REG			0xF5
+#define  HPD_REMOVAL_STATUS			BIT(2)
+#define  HPD_INSERTION_STATUS			BIT(1)
 
 #define MIN_DSI_CLK_FREQ_MHZ	40
 
@@ -152,7 +163,9 @@
  * @ln_assign:    Value to program to the LN_ASSIGN register.
  * @ln_polrs:     Value for the 4-bit LN_POLRS field of SN_ENH_FRAME_REG.
  * @comms_enabled: If true then communication over the aux channel is enabled.
+ * @hpd_enabled:   If true then HPD events are enabled.
  * @comms_mutex:   Protects modification of comms_enabled.
+ * @hpd_mutex:     Protects modification of hpd_enabled.
  *
  * @gchip:        If we expose our GPIOs, this is used.
  * @gchip_output: A cache of whether we've set GPIOs to output.  This
@@ -190,7 +203,9 @@ struct ti_sn65dsi86 {
 	u8				ln_assign;
 	u8				ln_polrs;
 	bool				comms_enabled;
+	bool				hpd_enabled;
 	struct mutex			comms_mutex;
+	struct mutex			hpd_mutex;
 
 #if defined(CONFIG_OF_GPIO)
 	struct gpio_chip		gchip;
@@ -221,6 +236,23 @@ static const struct regmap_config ti_sn6
 	.max_register = 0xFF,
 };
 
+static int ti_sn65dsi86_read_u8(struct ti_sn65dsi86 *pdata, unsigned int reg,
+				u8 *val)
+{
+	int ret;
+	unsigned int reg_val;
+
+	ret = regmap_read(pdata->regmap, reg, &reg_val);
+	if (ret) {
+		dev_err(pdata->dev, "fail to read raw reg %#x: %d\n",
+			reg, ret);
+		return ret;
+	}
+	*val = (u8)reg_val;
+
+	return 0;
+}
+
 static int __maybe_unused ti_sn65dsi86_read_u16(struct ti_sn65dsi86 *pdata,
 						unsigned int reg, u16 *val)
 {
@@ -362,6 +394,7 @@ static void ti_sn65dsi86_disable_comms(s
 static int __maybe_unused ti_sn65dsi86_resume(struct device *dev)
 {
 	struct ti_sn65dsi86 *pdata = dev_get_drvdata(dev);
+	const struct i2c_client *client = to_i2c_client(pdata->dev);
 	int ret;
 
 	ret = regulator_bulk_enable(SN_REGULATOR_SUPPLY_NUM, pdata->supplies);
@@ -396,6 +429,13 @@ static int __maybe_unused ti_sn65dsi86_r
 	if (pdata->refclk)
 		ti_sn65dsi86_enable_comms(pdata);
 
+	if (client->irq) {
+		ret = regmap_update_bits(pdata->regmap, SN_IRQ_EN_REG, IRQ_EN,
+					 IRQ_EN);
+		if (ret)
+			dev_err(pdata->dev, "Failed to enable IRQ events: %d\n", ret);
+	}
+
 	return ret;
 }
 
@@ -1223,6 +1263,8 @@ static void ti_sn65dsi86_debugfs_init(st
 static void ti_sn_bridge_hpd_enable(struct drm_bridge *bridge)
 {
 	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
+	const struct i2c_client *client = to_i2c_client(pdata->dev);
+	int ret;
 
 	/*
 	 * Device needs to be powered on before reading the HPD state
@@ -1231,11 +1273,35 @@ static void ti_sn_bridge_hpd_enable(stru
 	 */
 
 	pm_runtime_get_sync(pdata->dev);
+
+	mutex_lock(&pdata->hpd_mutex);
+	pdata->hpd_enabled = true;
+	mutex_unlock(&pdata->hpd_mutex);
+
+	if (client->irq) {
+		ret = regmap_set_bits(pdata->regmap, SN_IRQ_EVENTS_EN_REG,
+				      HPD_REMOVAL_EN | HPD_INSERTION_EN);
+		if (ret)
+			dev_err(pdata->dev, "Failed to enable HPD events: %d\n", ret);
+	}
 }
 
 static void ti_sn_bridge_hpd_disable(struct drm_bridge *bridge)
 {
 	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
+	const struct i2c_client *client = to_i2c_client(pdata->dev);
+	int ret;
+
+	if (client->irq) {
+		ret = regmap_clear_bits(pdata->regmap, SN_IRQ_EVENTS_EN_REG,
+					HPD_REMOVAL_EN | HPD_INSERTION_EN);
+		if (ret)
+			dev_err(pdata->dev, "Failed to disable HPD events: %d\n", ret);
+	}
+
+	mutex_lock(&pdata->hpd_mutex);
+	pdata->hpd_enabled = false;
+	mutex_unlock(&pdata->hpd_mutex);
 
 	pm_runtime_put_autosuspend(pdata->dev);
 }
@@ -1321,6 +1387,41 @@ static int ti_sn_bridge_parse_dsi_host(s
 	return 0;
 }
 
+static irqreturn_t ti_sn_bridge_interrupt(int irq, void *private)
+{
+	struct ti_sn65dsi86 *pdata = private;
+	struct drm_device *dev = pdata->bridge.dev;
+	u8 status;
+	int ret;
+	bool hpd_event;
+
+	ret = ti_sn65dsi86_read_u8(pdata, SN_IRQ_STATUS_REG, &status);
+	if (ret) {
+		dev_err(pdata->dev, "Failed to read IRQ status: %d\n", ret);
+		return IRQ_NONE;
+	}
+
+	hpd_event = status & (HPD_REMOVAL_STATUS | HPD_INSERTION_STATUS);
+
+	dev_dbg(pdata->dev, "(SN_IRQ_STATUS_REG = %#x)\n", status);
+	if (!status)
+		return IRQ_NONE;
+
+	ret = regmap_write(pdata->regmap, SN_IRQ_STATUS_REG, status);
+	if (ret) {
+		dev_err(pdata->dev, "Failed to clear IRQ status: %d\n", ret);
+		return IRQ_NONE;
+	}
+
+	/* Only send the HPD event if we are bound with a device. */
+	mutex_lock(&pdata->hpd_mutex);
+	if (pdata->hpd_enabled && hpd_event)
+		drm_kms_helper_hotplug_event(dev);
+	mutex_unlock(&pdata->hpd_mutex);
+
+	return IRQ_HANDLED;
+}
+
 static int ti_sn_bridge_probe(struct auxiliary_device *adev,
 			      const struct auxiliary_device_id *id)
 {
@@ -1951,6 +2052,7 @@ static int ti_sn65dsi86_probe(struct i2c
 	dev_set_drvdata(dev, pdata);
 	pdata->dev = dev;
 
+	mutex_init(&pdata->hpd_mutex);
 	mutex_init(&pdata->comms_mutex);
 
 	pdata->regmap = devm_regmap_init_i2c(client,
@@ -1981,6 +2083,16 @@ static int ti_sn65dsi86_probe(struct i2c
 	if (ret)
 		return ret;
 
+	if (client->irq) {
+		ret = devm_request_threaded_irq(pdata->dev, client->irq, NULL,
+						ti_sn_bridge_interrupt,
+						IRQF_ONESHOT,
+						dev_name(pdata->dev), pdata);
+
+		if (ret)
+			return dev_err_probe(dev, ret, "failed to request interrupt\n");
+	}
+
 	/*
 	 * Break ourselves up into a collection of aux devices. The only real
 	 * motiviation here is to solve the chicken-and-egg problem of probe


