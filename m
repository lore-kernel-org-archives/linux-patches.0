Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19C350A2C;
	Tue, 21 Oct 2025 20:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076907; cv=none; b=RRsK5+MpOiUlS/byObqH8Fmh9+oBurJ8ITO6/DKdG64/wqi1x87tsP4AYeikD/3XqU53pHVI2rV1s17SPTUCKu4KsevL8P6X1+/rbwkGMTQAi1S6lVFa56RX5zTv+u7J1UkpHyOllOP/xIRDDVOpdXtQMXOEdQ+m1bEwVMTA/RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076907; c=relaxed/simple;
	bh=FfWW0DRBpPIJz9uif73rAsWoyStvM7tpizDjS87Ys9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oY2LzxR4dbGDq50t21kDAMj8gtBP41hgN/yR72tR6Ka9MW+H095jAS7O/qkbgrwgkMvx823ubSMAvQnyPosUUhPwFh6IBDagf2gv2YS4FRzGuDg1LUMS6ZCFwYs0TZgkhyO2L/6J0T5otLKn3lcCDvF1FxwULkkJoz0jK+9ZTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLk4KqAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLk4KqAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADFAC4CEF1;
	Tue, 21 Oct 2025 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076907;
	bh=FfWW0DRBpPIJz9uif73rAsWoyStvM7tpizDjS87Ys9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLk4KqAfhnXIh10Y6jcOtsOLu2x0bQIrDwprXHrtgffFCMVsanUUrhjeTCtH4Mb2k
	 9SaObUY61VvvuUwFaU4N1cnk0oYxj3xRe/iWsgoFBCyxOhHkD3oYxPtNg42KMDP4FF
	 wn1AmreQVwtp4Cy3viqZMXUXtIY+Ae/ozjyUcra0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/136] ASoC: nau8821: Add DMI quirk to bypass jack debounce circuit
Date: Tue, 21 Oct 2025 21:51:02 +0200
Message-ID: <20251021195037.749191237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 2b4eda7bf7d8a4e2f7575a98f55d8336dec0f302 ]

Stress testing the audio jack hotplug handling on a few Steam Deck units
revealed that the debounce circuit is responsible for having a negative
impact on the detection reliability, e.g. in some cases the ejection
interrupt is not fired, while in other instances it goes into a kind of
invalid state and generates a flood of misleading interrupts.

Add new entries to the DMI table introduced via commit 1bc40efdaf4a
("ASoC: nau8821: Add DMI quirk mechanism for active-high jack-detect")
and extend the quirk logic to allow bypassing the debounce circuit used
for jack detection on Valve Steam Deck LCD and OLED models.

While at it, rename existing NAU8821_JD_ACTIVE_HIGH quirk bitfield to
NAU8821_QUIRK_JD_ACTIVE_HIGH.  This should help improve code readability
by differentiating from similarly named register bits.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-4-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 56e769446eb30..bfb719ca4c2cf 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -26,7 +26,8 @@
 #include <sound/tlv.h>
 #include "nau8821.h"
 
-#define NAU8821_JD_ACTIVE_HIGH			BIT(0)
+#define NAU8821_QUIRK_JD_ACTIVE_HIGH			BIT(0)
+#define NAU8821_QUIRK_JD_DB_BYPASS			BIT(1)
 
 static int nau8821_quirk;
 static int quirk_override = -1;
@@ -1166,9 +1167,10 @@ static void nau8821_setup_inserted_irq(struct nau8821 *nau8821)
 	regmap_update_bits(regmap, NAU8821_R1D_I2S_PCM_CTRL2,
 		NAU8821_I2S_MS_MASK, NAU8821_I2S_MS_SLAVE);
 
-	/* Not bypass de-bounce circuit */
-	regmap_update_bits(regmap, NAU8821_R0D_JACK_DET_CTRL,
-		NAU8821_JACK_DET_DB_BYPASS, 0);
+	/* Do not bypass de-bounce circuit */
+	if (!(nau8821_quirk & NAU8821_QUIRK_JD_DB_BYPASS))
+		regmap_update_bits(regmap, NAU8821_R0D_JACK_DET_CTRL,
+				   NAU8821_JACK_DET_DB_BYPASS, 0);
 
 	regmap_update_bits(regmap, NAU8821_R0F_INTERRUPT_MASK,
 		NAU8821_IRQ_EJECT_EN, 0);
@@ -1863,7 +1865,23 @@ static const struct dmi_system_id nau8821_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Positivo Tecnologia SA"),
 			DMI_MATCH(DMI_BOARD_NAME, "CW14Q01P-V2"),
 		},
-		.driver_data = (void *)(NAU8821_JD_ACTIVE_HIGH),
+		.driver_data = (void *)(NAU8821_QUIRK_JD_ACTIVE_HIGH),
+	},
+	{
+		/* Valve Steam Deck LCD */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Jupiter"),
+		},
+		.driver_data = (void *)(NAU8821_QUIRK_JD_DB_BYPASS),
+	},
+	{
+		/* Valve Steam Deck OLED */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Galileo"),
+		},
+		.driver_data = (void *)(NAU8821_QUIRK_JD_DB_BYPASS),
 	},
 	{}
 };
@@ -1905,9 +1923,12 @@ static int nau8821_i2c_probe(struct i2c_client *i2c)
 
 	nau8821_check_quirks();
 
-	if (nau8821_quirk & NAU8821_JD_ACTIVE_HIGH)
+	if (nau8821_quirk & NAU8821_QUIRK_JD_ACTIVE_HIGH)
 		nau8821->jkdet_polarity = 0;
 
+	if (nau8821_quirk & NAU8821_QUIRK_JD_DB_BYPASS)
+		dev_dbg(dev, "Force bypassing jack detection debounce circuit\n");
+
 	nau8821_print_device_properties(nau8821);
 
 	nau8821_reset_chip(nau8821->regmap);
-- 
2.51.0



