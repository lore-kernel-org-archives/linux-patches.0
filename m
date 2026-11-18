Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040736;
	b=hObIJ6lA3mzLvhcaZ4e0Mqn/kLWlyEgUwesp44jJKvc6nEksfuSdyJFKCIzh/IksaVKd
	 dycmgaHk+X1e6vPSzwnHcUfVL/to8S5I4caYw34tYy+x8oZ8RfmP0s+PPoM3dRrqaoJCI
	 c6PJlsf8jaSHqaczA/bF0SP8VrpiRJzUWWjQSJSgM43k3arVXQnxGO2xLGlfnGZuRqdbW
	 cWUch16IbNd5dMv8DAEVshdMc87lQwnQqonwXofnd52Igu3pfsXt5IZ2NbV3lApwBUrzo
	 0MpxX8GW5HfQUkZvndU5VNCspdg32ieOh3TZNdIeDIw69mO8N+wg7ESb94jmBGsMncA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HbxO3rT9kEhjfeHxk6TJhRRw/1XT+cvwtADdwv7Deew=;
	b=W23R2pnPSwYT47MdZV6nSP5IZKr3hG5SOwpDLXffWIA8lmdfjwG9npldJE4nCseUDn6q
	 7ZhZOZkzo7RwhKEoNNSDf97X3cT4AykBArkcfI8uWp2rkl7skzsYycygECNgNXZF8bdom
	 doQef3LPAZ97BtxmM24np+HCLoagtt+0DdWsWil9zitwqevxhpHJsRtfmHqb3jqGJ/3qk
	 /20sZQAIn0iaeGJBrFmISy6QpU7iWBiCCRtItGea7/RqSKHd7qUEaWSrLdziMi3jpNy7n
	 vjfnBAe1VsgYcZENXvUKQ/YgeGHiReWnPxKBgf6UikCJlcI7dHAIUDiu5IJlLChGE+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl18Quf0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D624606A325;
	Wed, 18 Nov 2026 22:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl18Quf0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7081F000C4;
	Wed, 18 Nov 2026 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040736;
	bh=HbxO3rT9kEhjfeHxk6TJhRRw/1XT+cvwtADdwv7Deew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl18Quf05LUIre3bbWbco90c/2PGvu/Uh30Yhk5bvXKvHiaOF1YWxTb5YAjgvk5cD
	 VyGeo+jGix2ohsDdQqcIy4IdFNY3+rx1J4d9jHAmHozwoIk2AFYjZ6E6nTZqhZAwGu
	 962ITcl6qCg7XjZFD28UQq36ap+S59ZljC3u2JYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2563/3318] power: supply: ab8500_charger: Recover inactive AB8505 charger
Date: Wed, 18 Nov 2026 15:53:05 +0100
Message-ID: <20261118150438.142347833@linuxfoundation.org>
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
index 5a79772394f65..e684ad777057d 100644
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -1239,12 +1239,9 @@ static void ab8500_chargalg_algorithm(struct ab8500_chargalg *di)
 
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
index a991207cc5183..d81cfff91b89e 100644
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
@@ -1865,6 +1866,9 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
 	int vset_uv, int iset_ua)
 {
 	u8 usbch_ctrl1 = 0;
+	u8 usbch_status1;
+	u8 usbch_status2;
+	bool reenable;
 	int ret = 0;
 
 	struct ab8500_charger *di = to_ab8500_charger_usb_device_info(charger);
@@ -1880,7 +1884,52 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
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



