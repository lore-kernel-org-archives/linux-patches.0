Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557511171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB598C433C8;
	Mon, 21 Aug 2023 20:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648105;
	bh=NmoTW0J84GvS2IUU+fe+3NMZHdfB4Ej9FUDZW83GHag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAEvnPTFUYgd3sEeudsdUtjA82Sp8MUfvuvgy/ZnwVaGt7VxW4vwFfnY01az91Jz0
	 g7YjiAI600S4SUE1pg5TF6zjfbM4ba6nEFJSIbmlsfUa6D354LRBlNFyPcDgiRbyjI
	 Pj3813dNX2FxQEUciyniJRh3VSKrGTzTgxEP1s8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 056/234] usb: chipidea: imx: turn off vbus comparator when suspend
Date: Mon, 21 Aug 2023 21:40:19 +0200
Message-ID: <20230821194131.234841263@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 0ac37fbdad7087bbcbbe246a602c248ccfd954ea ]

As we use bvalid for vbus wakeup source, to save power when
suspend, turn off the vbus comparator for imx7d and imx8mm.

Below is this bit description from RM of iMX8MM
"VBUS Valid Comparator Enable:

This signal controls the USB OTG PHY VBUS Valid comparator which
indicates whether the voltage on the USB_OTG*_VBUS pin is below
the VBUS Valid threshold. The VBUS Valid threshold is nominally
4.75V on this USB PHY. The VBUS Valid threshold can be adjusted
using the USBNC_OTGn_PHY_CFG1[OTGTUNE0] bit field. Status of the
VBUS Valid comparator, when it is enabled, is reported on the
USBNC_OTGn_PHY_STATUS[VBUS_VLD] bit.
When OTGDISABLE0 (USBNC_USB_OTGx_PHY_CFG2[10])is set to 1'b0 and
DRVVBUS0 is set to 1'b1, the Bandgap circuitry and VBUS Valid
comparator are powered, even in Suspend or Sleep mode.
DRVVBUS0 should be reset to 1'b0 when the internal VBUS Valid comparator
is not required, to reduce quiescent current in Suspend or Sleep mode.
 - 0 The VBUS Valid comparator is disabled
  - 1 The VBUS Valid comparator is enabled"

Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Message-ID: <20230517081907.3410465-2-xu.yang_2@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/usbmisc_imx.c | 35 ++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/usb/chipidea/usbmisc_imx.c b/drivers/usb/chipidea/usbmisc_imx.c
index c57c1a71a5132..0938e274ba3a8 100644
--- a/drivers/usb/chipidea/usbmisc_imx.c
+++ b/drivers/usb/chipidea/usbmisc_imx.c
@@ -152,6 +152,7 @@ struct usbmisc_ops {
 	int (*charger_detection)(struct imx_usbmisc_data *data);
 	/* It's called when system resume from usb power lost */
 	int (*power_lost_check)(struct imx_usbmisc_data *data);
+	void (*vbus_comparator_on)(struct imx_usbmisc_data *data, bool on);
 };
 
 struct imx_usbmisc {
@@ -875,6 +876,33 @@ static int imx7d_charger_detection(struct imx_usbmisc_data *data)
 	return ret;
 }
 
+static void usbmisc_imx7d_vbus_comparator_on(struct imx_usbmisc_data *data,
+					     bool on)
+{
+	unsigned long flags;
+	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
+	u32 val;
+
+	if (data->hsic)
+		return;
+
+	spin_lock_irqsave(&usbmisc->lock, flags);
+	/*
+	 * Disable VBUS valid comparator when in suspend mode,
+	 * when OTG is disabled and DRVVBUS0 is asserted case
+	 * the Bandgap circuitry and VBUS Valid comparator are
+	 * still powered, even in Suspend or Sleep mode.
+	 */
+	val = readl(usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
+	if (on)
+		val |= MX7D_USB_OTG_PHY_CFG2_DRVVBUS0;
+	else
+		val &= ~MX7D_USB_OTG_PHY_CFG2_DRVVBUS0;
+
+	writel(val, usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
+	spin_unlock_irqrestore(&usbmisc->lock, flags);
+}
+
 static int usbmisc_imx7ulp_init(struct imx_usbmisc_data *data)
 {
 	struct imx_usbmisc *usbmisc = dev_get_drvdata(data->dev);
@@ -1018,6 +1046,7 @@ static const struct usbmisc_ops imx7d_usbmisc_ops = {
 	.set_wakeup = usbmisc_imx7d_set_wakeup,
 	.charger_detection = imx7d_charger_detection,
 	.power_lost_check = usbmisc_imx7d_power_lost_check,
+	.vbus_comparator_on = usbmisc_imx7d_vbus_comparator_on,
 };
 
 static const struct usbmisc_ops imx7ulp_usbmisc_ops = {
@@ -1132,6 +1161,9 @@ int imx_usbmisc_suspend(struct imx_usbmisc_data *data, bool wakeup)
 
 	usbmisc = dev_get_drvdata(data->dev);
 
+	if (usbmisc->ops->vbus_comparator_on)
+		usbmisc->ops->vbus_comparator_on(data, false);
+
 	if (wakeup && usbmisc->ops->set_wakeup)
 		ret = usbmisc->ops->set_wakeup(data, true);
 	if (ret) {
@@ -1185,6 +1217,9 @@ int imx_usbmisc_resume(struct imx_usbmisc_data *data, bool wakeup)
 		goto hsic_set_clk_fail;
 	}
 
+	if (usbmisc->ops->vbus_comparator_on)
+		usbmisc->ops->vbus_comparator_on(data, true);
+
 	return 0;
 
 hsic_set_clk_fail:
-- 
2.40.1



