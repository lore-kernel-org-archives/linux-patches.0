Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A334D1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23054C433C8;
	Mon, 11 Sep 2023 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442413;
	bh=A6hRF1hKYpmYX/XA+WklDT5WJ1ihei0aCma6IT1oiHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncUcRDumXc2Qfq2IWkgHpVse5SkCwqPBfasT6BffixQRVp3HZ9CYCSLDd9Aq2OumF
	 4CL2r28Dfd4keBnHwoGFrFLV5yYZ/bt8Q3c/8P+64UqXMDbIm6zaX6ClwH2D65a47C
	 AIpXCCMgO4Jy/ZvayFFr1b+UG2WxSJQ7aps7JnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 017/737] ASoC: nau8821: Add DMI quirk mechanism for active-high jack-detect
Date: Mon, 11 Sep 2023 15:37:56 +0200
Message-ID: <20230911134650.820950024@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

[ Upstream commit 1bc40efdaf4a0ccfdb10a1c8e4b458f4764e8e5f ]

Add a quirk mechanism to allow specifying that active-high jack-detection
should be used on platforms where this info is not available in devicetree.

And add an entry for the Positivo CW14Q01P-V2 to the DMI table, so that
jack-detection will work properly on this laptop.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Link: https://lore.kernel.org/r/20230719200241.4865-1-edson.drosdeck@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index fee970427a243..42de7588fdb68 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
@@ -25,6 +26,13 @@
 #include <sound/tlv.h>
 #include "nau8821.h"
 
+#define NAU8821_JD_ACTIVE_HIGH			BIT(0)
+
+static int nau8821_quirk;
+static int quirk_override = -1;
+module_param_named(quirk, quirk_override, uint, 0444);
+MODULE_PARM_DESC(quirk, "Board-specific quirk override");
+
 #define NAU_FREF_MAX 13500000
 #define NAU_FVCO_MAX 100000000
 #define NAU_FVCO_MIN 90000000
@@ -1792,6 +1800,33 @@ static int nau8821_setup_irq(struct nau8821 *nau8821)
 	return 0;
 }
 
+/* Please keep this list alphabetically sorted */
+static const struct dmi_system_id nau8821_quirk_table[] = {
+	{
+		/* Positivo CW14Q01P-V2 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Positivo Tecnologia SA"),
+			DMI_MATCH(DMI_BOARD_NAME, "CW14Q01P-V2"),
+		},
+		.driver_data = (void *)(NAU8821_JD_ACTIVE_HIGH),
+	},
+	{}
+};
+
+static void nau8821_check_quirks(void)
+{
+	const struct dmi_system_id *dmi_id;
+
+	if (quirk_override != -1) {
+		nau8821_quirk = quirk_override;
+		return;
+	}
+
+	dmi_id = dmi_first_match(nau8821_quirk_table);
+	if (dmi_id)
+		nau8821_quirk = (unsigned long)dmi_id->driver_data;
+}
+
 static int nau8821_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
@@ -1812,6 +1847,12 @@ static int nau8821_i2c_probe(struct i2c_client *i2c)
 
 	nau8821->dev = dev;
 	nau8821->irq = i2c->irq;
+
+	nau8821_check_quirks();
+
+	if (nau8821_quirk & NAU8821_JD_ACTIVE_HIGH)
+		nau8821->jkdet_polarity = 0;
+
 	nau8821_print_device_properties(nau8821);
 
 	nau8821_reset_chip(nau8821->regmap);
-- 
2.40.1



