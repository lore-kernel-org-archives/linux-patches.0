Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E936C227BB6;
	Tue,  8 Apr 2025 11:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111922; cv=none; b=ll6U8g3nauj5eUpIFBDsM+NiCTeiVZGCCBhavxasfP3TR7bNzE13Rc36GlUMXPQEKST74OQYs9GkjYGSEy2G1NuzgSd02DGh/wS0Phmp2pyvZUFapB1a5pn6pds39t6nFAhJ/M3JFUB8Q0W0l8QM3wA/QOEmMQBeC5d8AIXXGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111922; c=relaxed/simple;
	bh=Fsv/c2E5sKHeoGWB3ODgvJfIiBO30FGTNHvb8o0Pyk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EopHiO+c7GEP5s/9kzjPB28SRkqn1DJZUEVQJZxi9BCLYFfryv7d59KuV33q/aHuzCg2WBaTeIK/6igji3GB+ITMWBBy+MTd2arepE5nmBUAkKrdWGfkbciVWfraUKCbCtDH5eSeNJfNlNCon4bzsCDQatc/yYMdwwYGHXAKvmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiW0AJ36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiW0AJ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739F4C4CEEA;
	Tue,  8 Apr 2025 11:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111921;
	bh=Fsv/c2E5sKHeoGWB3ODgvJfIiBO30FGTNHvb8o0Pyk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiW0AJ36mQi03NcmgmweihK612aWG9pnzIuIcYm9uWuCvu/HUT7uD3cL5+RpaVpGr
	 Q9apU7ZxZ4Kr0KJhM05IYmxbSwb8EnjqBOfmO8J6EEBF6GqFnaAlGesghuFSRuwjRP
	 M38ikrqsGDAhMPKnVJQ70C+ijebQ6B/AbFbRQWm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 610/731] spi: bcm2835: Restore native CS probing when pinctrl-bcm2835 is absent
Date: Tue,  8 Apr 2025 12:48:27 +0200
Message-ID: <20250408104928.460520880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit e19c1272c80a5ecce387c1b0c3b995f4edf9c525 ]

The lookup table forces the use of the "pinctrl-bcm2835" GPIO chip
provider and essentially assumes that there is going to be such a
provider, and if not, we will fail to set-up the SPI device.

While this is true on Raspberry Pi based systems (2835/36/37, 2711,
2712), this is not true on 7712/77122 Broadcom STB systems which use the
SPI driver, but not the GPIO driver.

There used to be an early check:

       chip = gpiochip_find("pinctrl-bcm2835", chip_match_name);
       if (!chip)
               return 0;

which would accomplish that nicely, bring something similar back by
checking for the compatible strings matched by the pinctrl-bcm2835.c
driver, if there is no Device Tree node matching those compatible
strings, then we won't find any GPIO provider registered by the
"pinctrl-bcm2835" driver.

Fixes: 21f252cd29f0 ("spi: bcm2835: reduce the abuse of the GPIO API")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250401233603.2938955-1-florian.fainelli@broadcom.com
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 06a81727d74dd..77de5a07639af 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1226,7 +1226,12 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	struct bcm2835_spi *bs = spi_controller_get_devdata(ctlr);
 	struct bcm2835_spidev *target = spi_get_ctldata(spi);
 	struct gpiod_lookup_table *lookup __free(kfree) = NULL;
-	int ret;
+	const char *pinctrl_compats[] = {
+		"brcm,bcm2835-gpio",
+		"brcm,bcm2711-gpio",
+		"brcm,bcm7211-gpio",
+	};
+	int ret, i;
 	u32 cs;
 
 	if (!target) {
@@ -1291,6 +1296,14 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 		goto err_cleanup;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(pinctrl_compats); i++) {
+		if (of_find_compatible_node(NULL, NULL, pinctrl_compats[i]))
+			break;
+	}
+
+	if (i == ARRAY_SIZE(pinctrl_compats))
+		return 0;
+
 	/*
 	 * TODO: The code below is a slightly better alternative to the utter
 	 * abuse of the GPIO API that I found here before. It creates a
-- 
2.39.5



