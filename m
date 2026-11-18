Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049041;
	b=tdA9rwcA7Ps5qJzW0hJAsetZKKwBTahX20HES/AmEn3EWD20aGRZqnNp7+lt06P2ruKg
	 Kow1AEYOLb1whvitfAKlXzflnbbteBggMXhXHHsIUZpRY5GHkuhQSuu9eHwM2UkEMLGWH
	 FhEieCHX3phfDze3rHglnH68mwgz9eJmEZv6aw9zwW8qwlI0hL+X197h8Be7axJtOgO/k
	 N6SflVNrQRxfHuQzQfNaMmzoTygAUCT9O+CElqPTmEvyARPRff1Kr8+i9KkKa478yX9c3
	 WhSEDzoiyJ/JPFrKQ0dQlMCngF1QDTawZIsIRugW2bgHsT+e7uzXbiglym79BZqPLvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QPipqsJ1dL5erDT6r6ChMvIeucNoTe3yWUHbvLq8kOE=;
	b=ptn8qJEjA30fCX4zI/Gfgz2RouuNHYTPFxwPRyZTMkyykGckNVBNrz2xr38KLaPBwy1p
	 PNaaY7rU0JgnKjmfhjSXs0XJyepvSDTobjvTc+2pfB9VWeu7yath6qKpE3g16mO4783hu
	 KalwTbA5ewE6m1FPqzgvX+gPt48N36I0BcQk8FJTnDjdaJ5WxtQdpe9g+uYJtAscdx1u7
	 5UqK3813ImC97Mu77vZLi2F16Zryu69xBIXwA0Y07selpRftbm+xG2QVWqPEylbRKAV21
	 12Htqls54z0JpQ/JFrz8c6C1OsVPGumzARnB9EUiCAWzDgZw1DCbY+qQWxWm4K12gUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewIkXTHc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D13606A32C;
	Thu, 19 Nov 2026 00:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewIkXTHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA921F000C4;
	Thu, 19 Nov 2026 00:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049041;
	bh=QPipqsJ1dL5erDT6r6ChMvIeucNoTe3yWUHbvLq8kOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewIkXTHcOYeteKhDyXjDSYGl7W9SR05DEBIDKFGnkIGPmSg5fG3xVD52Nm2fI6vhr
	 peBIec0d/w3CbczoKnh6A5db7fQnOzuuMN3aCDrMb2gYxl/Q//a3ms/SKl1Yw3b3lW
	 fevPymeQBOeV7C20SFGbb1H9q1DzXybBsxHF+OzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2210/2857] power: supply: ab8500_charger: Respect AB8505 register layout
Date: Wed, 18 Nov 2026 15:54:04 +0100
Message-ID: <20261118150320.992399609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit dcecf527632297011153f088573689a1ad1de790 ]

Several AB8505 charger fields differ from AB8500. Its long VBUS
falling debounce is 300 ms rather than 100 ms, and its VBUS
overvoltage selector has a different encoding programmed through OTP.
Writing the AB8500 6.3 V value selects 9 V on AB8505.

AB8505 revision 3 also defines SwControlFallback as reserved,
correcting older documentation which led the driver to support
autopower there. Preserve the AB8505 overvoltage setting, wait for its
documented debounce, and reject the unsupported autopower setting.

Fixes: 0ed5107fa860 ("ab8500-charger: Do not touch VBUSOVV bits")
Fixes: b016322293c7 ("ab8500-charger: Add support for autopower on AB8505 and AB9540")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-9-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 87783c6a9782a..5cabedc69d8c2 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -52,7 +52,7 @@
 #define MAIN_CH_DET			0x01
 #define MAIN_CH_CV_ON			0x04
 #define USB_CH_CV_ON			0x08
-#define VBUS_DET_DBNC100		0x02
+#define VBUS_DET_DBNC_LONG		0x02
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
 #define DROP_COUNT_RESET		0x01
@@ -383,6 +383,10 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 	u8 bit;
 	int ret;
 
+	/* SwControlFallback is reserved and must remain clear on AB8505. */
+	if (is_ab8505(di->parent))
+		return;
+
 	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
 	if (is_ab8500(di->parent)) {
@@ -691,12 +695,16 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 
 	if (!probe) {
 		/*
-		 * AB8500 says VBUS_DET_DBNC1 & VBUS_DET_DBNC100
+		 * AB8500 says VBUS_DET_DBNC1 & VBUS_DET_DBNC_LONG
 		 * when disconnecting ACA even though no
 		 * charger was connected. Try waiting a little
-		 * longer than the 100 ms of VBUS_DET_DBNC100...
+		 * longer than its 100 ms debounce. AB8505 uses
+		 * a 300 ms falling debounce for the same bit.
 		 */
-		msleep(110);
+		if (is_ab8505(di->parent))
+			msleep(310);
+		else
+			msleep(110);
 	}
 	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
 		AB8500_CH_USBCH_STAT1_REG, &val);
@@ -707,7 +715,7 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 	dev_dbg(di->dev,
 		"%s AB8500_CH_USBCH_STAT1_REG %x\n", __func__,
 		val);
-	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC100))
+	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC_LONG))
 		result |= USB_PW_CONN;
 
 	return result;
@@ -3175,7 +3183,7 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		}
 	}
 
-	if (is_ab8505_2p0(di->parent))
+	if (is_ab8505(di->parent))
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER,
 			AB8500_USBCH_CTRL2_REG,
@@ -3524,11 +3532,14 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	di->bm = &ab8500_bm_data;
 
-	di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
-
 	/* get parent data */
 	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
+	di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
+	if (di->autopower_cfg && is_ab8505(di->parent)) {
+		dev_warn(dev, "autopower is not supported on AB8505\n");
+		di->autopower_cfg = false;
+	}
 
 	/* Get ADC channels */
 	if (!is_ab8505(di->parent)) {
-- 
2.53.0



