Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42535267B89;
	Tue,  8 Apr 2025 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116935; cv=none; b=BA07GjXDlgjOM2RX/L5DR5h/I4/9Lx+hPitEPXB3qyaEwt6MmI1nIvOB7iVhroRitCB5aj1VZXWBTIUC9uwyEcfBdu7C3XTeAega05e3l4r+VT4gzXHQyDgi4//8Ot8QxVmLxXH59sNpi7aDMfqp1rrQV85oRbvRLop1NBUWg4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116935; c=relaxed/simple;
	bh=x2EPWrgiYuGZXRQfnsSHW+0x+4P6DFlBuaM/QmRqe7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwaDftpmRUSsu0D4rRPB2qCa7zdmxAsqfedutWFjhMDwQzOpLc8r+ZL6TAaVMimF2oBXSAcdauqcmaPx/WmQE0i5oBY1dRhUHAVLx4fTv21AN8+BtonBos8k6fik/6MAM5GkxEdcmI41AFHbmn9kAXhDRhU3Br9mhVRaez1cu7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYuFZ8pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYuFZ8pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627F4C4CEE5;
	Tue,  8 Apr 2025 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116934;
	bh=x2EPWrgiYuGZXRQfnsSHW+0x+4P6DFlBuaM/QmRqe7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYuFZ8prY9IoOrvY2HtpfU2fS0Z61VTnKE/neUl1u4/4LKRXuvvHe6HgoJYJB7knT
	 4xVRlwBn+EHD+TVVEgstZhMA5mazxC0Rjsli3/YGvpjcyHEyp604vzIUOjZRt4ujMc
	 /rjObDG3WALuYrBteayRXfgZqUyIsg5Veh1oIW/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/423] spi: bcm2835: Restore native CS probing when pinctrl-bcm2835 is absent
Date: Tue,  8 Apr 2025 12:50:49 +0200
Message-ID: <20250408104853.338391196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5d621b94d5e3..5926e004d9a65 100644
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



