Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025388;
	b=gSvZuLk/gK5rSjMudgYPMB1yjFxeN/g8IC+i31xI8Qk5Nd8Sj8zmb2kkZl0Eu2DCC3ap
	 ZnzM4DUuREkwOD0zehXjjNCBrWCHywShFnql71b0q90rFb69RTmKRBx5lJhGS4UUqkG5C
	 N1WEyvPRk1dg6xOA85Y/stNL8IyL6ghDpUmylsPp/NFHhpWcmD/dBY0x7VNy24TSSzwSb
	 wp2eRIdgFg0sSp3AwvGvEo+lyvuTI5JT25+dH94p2E0I5jDk28ouyEOKw5m2ESrDHKA3e
	 xsGEqIEmbXDRkvnft8jxxkMf8bpS/XQcxgIpHpAPEzpnYwI4hWwuH4hApebJuXns9ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kswwitvIYFHv+TaRyMux0aeQwhGy24lhZ8RllQ3blEg=;
	b=KUHT68OHScBwA44A3aAetM1kanpgXF8WLJ/d9beBenxS1gdNnzHtva4ojWUTN+aL+pc2
	 tLBvyFYVP3a+CtP0t7XTJKafpdbjQuZpWohMrgiyfeFJUTGU5DVh8Ro7tJmxQ0NmMAhQb
	 +aD2LN9zYwWPjd9lkuB0R947eX+RZdTJF/2O7PaeAIgo3YA7oINaEM/2ccIE2RWWxtSKX
	 +8VPehhwkV/tZo/5Yj3oVvgyZLjoxxB6dnrP6RBHV8wqxynYN86+TGasMzl1e1gbip/a6
	 e8yCh989xypwGziB3MOvfciJjRIeqZ7SSKmEQKeNf3gSVhYF4o5RGycd+r5k3rs0j7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLcX4jTm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C2A606A31C;
	Wed, 18 Nov 2026 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLcX4jTm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B061F000C4;
	Wed, 18 Nov 2026 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025388;
	bh=kswwitvIYFHv+TaRyMux0aeQwhGy24lhZ8RllQ3blEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLcX4jTm0jQ4TQjePujqm0+zAkQ5aTEt3TTpk7v1/AyODWOfnKt5H2vAuCM5oZZyJ
	 dSFt35RCef02hFLn8TMBqdqvV3UqXQ90yIfk6hCG/VHPtc/4k2YS28GEuTmP5Hs9vP
	 Mll6Admq6t1JwhcumDfUsRpe6NZmVxtR7DUNpzw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1060/2151] power: supply: ab8500_charger: Recover inactive AB8505 charger
Date: Wed, 18 Nov 2026 15:46:35 +0100
Message-ID: <20261118150200.914139313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 76bdf9d78245bb068207c23e9bf43d4b9bb201c3 ]

UsbChCtrl1.UsbChEna can remain set while UsbChStatus1.UsbChOn is
clear. The existing recovery only checks the control bit, so it considers
the charger enabled and leaves charging stopped.

The Samsung-GT-S7710-Skomer, Samsung-SGH-I407-Kyle, and
Samsung-SGH-T599-Codina-TMO product trees are reference points for
checking both bits and cycling the charger when they disagree.

Extend the USB charger check to detect this AB8505 state and enable the
check in the charging algorithm for AB8505. Only cycle the charger when
VBUS is debounced and no charger-not-OK, thermal, overvoltage, or
watchdog fault accounts for the inactive hardware.

Fixes: 4dcdf57773fd ("ab8500-bm: Quick re-attach charging behaviour")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-13-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_chargalg.c |  9 ++---
 drivers/power/supply/ab8500_charger.c  | 51 +++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/power/supply/ab8500_chargalg.c b/drivers/power/supply/ab8500_chargalg.c
index dc6c8b0dd1cfd..3826e8a008c7e 100644
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -1238,12 +1238,9 @@ static void ab8500_chargalg_algorithm(struct ab8500_chargalg *di)
 
 	charger_status = ab8500_chargalg_check_charger_connection(di);
 
-	if (is_ab8500(di->parent)) {
-		ret = ab8500_chargalg_check_charger_enable(di);
-		if (ret < 0)
-			dev_err(di->dev, "Checking charger is enabled error"
-					": Returned Value %d\n", ret);
-	}
+	ret = ab8500_chargalg_check_charger_enable(di);
+	if (ret < 0)
+		dev_err(di->dev, "Checking charger enable failed: %d\n", ret);
 
 	/*
 	 * First check if we have a charger connected.
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 1c4e4d0af48b2..30b819f6a13c3 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -52,6 +52,7 @@
 #define MAIN_CH_DET			0x01
 #define MAIN_CH_CV_ON			0x04
 #define USB_CH_CV_ON			0x08
+#define USB_CH_ON			0x04
 #define VBUS_DET_DBNC_LONG		0x02
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
@@ -1877,6 +1878,9 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
 	int vset_uv, int iset_ua)
 {
 	u8 usbch_ctrl1 = 0;
+	u8 usbch_status1;
+	u8 usbch_status2;
+	bool reenable;
 	int ret = 0;
 
 	struct ab8500_charger *di = to_ab8500_charger_usb_device_info(charger);
@@ -1892,7 +1896,52 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
 	}
 	dev_dbg(di->dev, "USB charger ctrl: 0x%02x\n", usbch_ctrl1);
 
-	if (!(usbch_ctrl1 & USB_CH_ENA)) {
+	reenable = !(usbch_ctrl1 & USB_CH_ENA);
+	if (is_ab8505(di->parent)) {
+		ret = abx500_get_register_interruptible(di->dev,
+							AB8500_CHARGER,
+							AB8500_CH_USBCH_STAT1_REG,
+							&usbch_status1);
+		if (ret < 0) {
+			dev_err(di->dev, "USB charger status read failed\n");
+			return ret;
+		}
+
+		if (!reenable && (usbch_status1 & USB_CH_ON))
+			return 0;
+
+		if (!(usbch_status1 & VBUS_DET_DBNC_LONG))
+			return 0;
+
+		ret = abx500_get_register_interruptible(di->dev,
+							AB8500_CHARGER,
+							AB8500_CH_USBCH_STAT2_REG,
+							&usbch_status2);
+		if (ret < 0) {
+			dev_err(di->dev, "USB charger fault status read failed\n");
+			return ret;
+		}
+
+		if ((usbch_status2 &
+		     (VBUS_CH_NOK | USB_CH_TH_PROT | VBUS_OVV_TH)) ||
+		    di->flags.usbchargernotok || di->flags.usb_thermal_prot ||
+		    di->flags.vbus_ovv || di->usb.wd_expired)
+			return 0;
+
+		if (!reenable) {
+			dev_info(di->dev,
+				 "USB charger enabled but inactive, cycling it\n");
+			ret = abx500_mask_and_set_register_interruptible(di->dev,
+									 AB8500_CHARGER,
+									 AB8500_USBCH_CTRL1_REG,
+									 USB_CH_ENA, 0);
+			if (ret < 0)
+				return ret;
+			reenable = true;
+		}
+	}
+
+	if (reenable) {
 		dev_info(di->dev, "Charging has been disabled abnormally and will be re-enabled\n");
 
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
-- 
2.53.0



