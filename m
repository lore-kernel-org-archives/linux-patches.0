Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040733;
	b=g+v/VmC7/8KRNabm1uIqe699B6spN9yDlBBBn2d4aMKVsej1ztT1wrpT/9V0mvA9bdHX
	 GTgZAdTlotPydo/lejiAz1EY7KVy5zHS44t3vJWO8qkM1RhtQO8vAfwprnDm8MFVn7BGI
	 EqvTRIspbs9oTfeME7grV57s3rdyyZGOOuiYsV4x/s9pIb+rYZ5IvZlyPnBzMxWDWrr2V
	 lotjnNU1iRVkvkGUTyWnivx9g5ZXh/jgsAFvxEUFFX8mDShQ3x0dVtSj2cE0DTntGCCYP
	 ZfjIPA5uGsgMdDkX+qyjXoDrDuCV83jbFfDij78/sBrrZRkFw88wen/lV+ZzPva936A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jw0gTUqppmA2NvFWjcWM4KNVh2QyAN1W+dJmdssbtro=;
	b=nrTgLpDa/jAZ1V5PSR7PYAapgVx3cNMKGYEALyOE6FMjMK0vppeLE0JgPdtOYji6iUep
	 kHMp5sG8JsACU7Oq74JoreZd77YFIsACpkPnif3VH1Ljs5Lm6A2cyLIae0F00Nf76zVoA
	 1IyQCsFsUeLj17n8eYk5/FDNPSPGb5fDt4f7vZF/D/DBqAnvkZpCUVCkjiU0NDzSvQCoM
	 YMsXIt0S6cdCwmPnXjxnXh6y8tAsqOGxSTi1iV/rwXfKH2htGG+b/sfPNgMr2jfdkQGjq
	 5ItqPx9xBGH65nl6cxlMtb8k7QJd0AA34gjJEfl60WCyRMlaRZeZps3oj34I2sF+21w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VrkyRMSk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B57606A320;
	Wed, 18 Nov 2026 22:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VrkyRMSk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5831F000C4;
	Wed, 18 Nov 2026 22:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040733;
	bh=jw0gTUqppmA2NvFWjcWM4KNVh2QyAN1W+dJmdssbtro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrkyRMSkbNRHoDBQCRPbtoCe4QJ+iGOMuegI80jUjiwsLuduF6641qqLPiv0zf82v
	 +Y30+j1IVWEpBBi1OdYaws0rXBgc5m2AMMSouROu2u+0j+8UZdK1eKSR85bPPbOKkg
	 T6IKzW8ZR3kDWX9fazijDrepp6qU4V92fq1BKy9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2562/3318] power: supply: ab8500_charger: Retry AB8505 USB detection
Date: Wed, 18 Nov 2026 15:53:04 +0100
Message-ID: <20261118150438.114340063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 95fba2e3055df99ed19e7d6399101bac42b3e7d5 ]

AB8505 reports UsbLink1Status state 14 when the USB charger port is
not OK. The manual says that software can return the port detector to
the detection state by setting the self-clearing
ChargerCtrl.DropCountReset bit.

The Samsung-GT-S7710-Skomer, Samsung-SGH-I407-Kyle, and
Samsung-SGH-T599-Codina-TMO product trees are reference points for a
workaround that cycles the USB charger and retries detection three times
before rejecting VBUS. Only the Kyle tree writes 1 to DropCountReset;
the other two write 0 and therefore do not request the documented reset.

Add the same bounded recovery for AB8505, preserving the configured USB
charger control bits across each cycle. Keep the charger connected while
recovering, then report the fault and disconnect it if all three attempts
fail. Leave AB8500 behavior unchanged.

Fixes: d4337660d069 ("ab8500-charger: Add AB8505_USB_LINK_STATUS")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-12-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 114 ++++++++++++++++++++++++--
 1 file changed, 109 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index fb7ef9a36d127..a991207cc5183 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -99,6 +99,8 @@
 
 #define CHARGER_STATUS_POLL 10 /* in ms */
 
+#define AB8505_USB_CHARGER_NOT_OK_RETRIES	3
+
 #define CHG_WD_INTERVAL			(60 * HZ)
 
 #define AB8500_SW_CONTROL_FALLBACK	0x03
@@ -261,6 +263,8 @@ struct ab8500_charger_max_usb_in_curr {
  * @is_aca_rid:		Incicate if accessory is ACA type
  * @current_stepping_sessions:
  *			Counter for current stepping sessions
+ * @usb_charger_not_ok_retries:
+ *			Number of AB8505 USB charger recovery attempts
  * @parent:		Pointer to the struct ab8500
  * @adc_main_charger_v	ADC channel for main charger voltage
  * @adc_main_charger_c	ADC channel for main charger current
@@ -314,6 +318,7 @@ struct ab8500_charger {
 	int invalid_charger_detect_state;
 	int is_aca_rid;
 	atomic_t current_stepping_sessions;
+	unsigned int usb_charger_not_ok_retries;
 	struct ab8500 *parent;
 	struct iio_channel *adc_main_charger_v;
 	struct iio_channel *adc_main_charger_c;
@@ -473,6 +478,9 @@ static void ab8500_power_supply_changed(struct ab8500_charger *di,
 static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 	bool connected)
 {
+	if (!connected && !di->vbus_detected)
+		di->usb_charger_not_ok_retries = 0;
+
 	if (connected != di->usb.charger_connected) {
 		dev_dbg(di->dev, "USB connected:%i\n", connected);
 		di->usb.charger_connected = connected;
@@ -784,10 +792,19 @@ static int ab8505_charger_max_usb_curr(struct ab8500_charger *di,
 		ret = -ENXIO;
 		break;
 	case AB8505_USB_STAT_CHARGER_NOT_OK:
-		di->flags.vbus_collapse = true;
-		dev_err(di->dev, "USB Type - VBUS has collapsed\n");
 		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
-		ret = -ENXIO;
+		if (di->usb_charger_not_ok_retries <
+		    AB8505_USB_CHARGER_NOT_OK_RETRIES) {
+			dev_warn(di->dev,
+				 "USB Type - VBUS has collapsed, retrying\n");
+			queue_delayed_work(di->charger_wq,
+					   &di->check_usbchgnotok_work, 0);
+			ret = -EAGAIN;
+		} else {
+			dev_err(di->dev,
+				"USB Type - VBUS recovery failed\n");
+			ret = -ENXIO;
+		}
 		break;
 	case AB8505_USB_STAT_RESERVED_5:
 	case AB8505_USB_STAT_RESERVED_6:
@@ -2576,6 +2593,48 @@ static void ab8500_charger_usb_state_changed_work(struct work_struct *work)
 	}
 }
 
+static int ab8505_charger_retry_usb_detection(struct ab8500_charger *di)
+{
+	u8 usbch_ctrl1;
+	bool usb_enabled;
+	int restore_ret;
+	int ret;
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
+						AB8500_USBCH_CTRL1_REG,
+						&usbch_ctrl1);
+	if (ret < 0)
+		return ret;
+
+	usb_enabled = usbch_ctrl1 & USB_CH_ENA;
+	if (usb_enabled) {
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+								 AB8500_CHARGER,
+								 AB8500_USBCH_CTRL1_REG,
+								 USB_CH_ENA, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(di->dev,
+							 AB8500_CHARGER,
+							 AB8500_CHARGER_CTRL,
+							 DROP_COUNT_RESET,
+							 DROP_COUNT_RESET);
+
+	if (usb_enabled) {
+		restore_ret = abx500_mask_and_set_register_interruptible(di->dev,
+									 AB8500_CHARGER,
+									 AB8500_USBCH_CTRL1_REG,
+									 USB_CH_ENA,
+									 USB_CH_ENA);
+		if (restore_ret < 0)
+			return restore_ret;
+	}
+
+	return ret;
+}
+
 /**
  * ab8500_charger_check_usbchargernotok_work() - check USB chg not ok status
  * @work:	pointer to the work_struct structure
@@ -2585,7 +2644,10 @@ static void ab8500_charger_usb_state_changed_work(struct work_struct *work)
 static void ab8500_charger_check_usbchargernotok_work(struct work_struct *work)
 {
 	int ret;
+	u8 link_status = 0;
 	u8 reg_value;
+	bool charger_not_ok;
+	bool prev_collapse;
 	bool prev_status;
 
 	struct ab8500_charger *di = container_of(work,
@@ -2598,19 +2660,61 @@ static void ab8500_charger_check_usbchargernotok_work(struct work_struct *work)
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 		return;
 	}
+	charger_not_ok = reg_value & VBUS_CH_NOK;
+	if (is_ab8505(di->parent)) {
+		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+							AB8500_USB_LINK1_STAT_REG,
+							&link_status);
+		if (ret < 0) {
+			dev_err(di->dev, "%s USB link status read failed\n",
+				__func__);
+			return;
+		}
+
+		link_status = (link_status & AB8505_USB_LINK_STATUS) >>
+			USB_LINK_STATUS_SHIFT;
+		charger_not_ok |=
+			link_status == AB8505_USB_STAT_CHARGER_NOT_OK;
+	}
+
 	prev_status = di->flags.usbchargernotok;
+	prev_collapse = di->flags.vbus_collapse;
+
+	if (is_ab8505(di->parent) &&
+	    link_status == AB8505_USB_STAT_CHARGER_NOT_OK &&
+	    di->usb_charger_not_ok_retries <
+	    AB8505_USB_CHARGER_NOT_OK_RETRIES) {
+		di->usb_charger_not_ok_retries++;
+		di->flags.usbchargernotok = false;
+		di->flags.vbus_collapse = true;
+		dev_warn(di->dev, "Retrying USB charger detection (%u/%u)\n",
+			 di->usb_charger_not_ok_retries,
+			 AB8505_USB_CHARGER_NOT_OK_RETRIES);
 
-	if (reg_value & VBUS_CH_NOK) {
+		ret = ab8505_charger_retry_usb_detection(di);
+		if (ret < 0)
+			dev_err(di->dev, "USB charger retry failed: %d\n", ret);
+
+		queue_delayed_work(di->charger_wq,
+				   &di->check_usbchgnotok_work, HZ);
+	} else if (charger_not_ok) {
 		di->flags.usbchargernotok = true;
+		if (is_ab8505(di->parent) &&
+		    link_status == AB8505_USB_STAT_CHARGER_NOT_OK) {
+			di->flags.vbus_collapse = false;
+			ab8500_charger_set_usb_connected(di, false);
+		}
 		/* Check again in 1sec */
 		queue_delayed_work(di->charger_wq,
 			&di->check_usbchgnotok_work, HZ);
 	} else {
 		di->flags.usbchargernotok = false;
 		di->flags.vbus_collapse = false;
+		di->usb_charger_not_ok_retries = 0;
 	}
 
-	if (prev_status != di->flags.usbchargernotok)
+	if (prev_status != di->flags.usbchargernotok ||
+	    prev_collapse != di->flags.vbus_collapse)
 		ab8500_power_supply_changed(di, di->usb_chg.psy);
 }
 
-- 
2.53.0



