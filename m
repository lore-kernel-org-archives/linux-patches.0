Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE131D86FF;
	Tue, 11 Nov 2025 01:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825122; cv=none; b=M03MdAKaA5aMXg0QBTwr47LCC5+71ZmJAXWrQfQqVncMnvt5NmTnlWyNB/gPZt6PUF9PTwo90LlkWWyud/MT6GQ+ivsA0ZsCnD8LfpdEy6tNvyj/ADr33NFk7UNyOPDNJoJXIFeFYmqkb3QTfuq7ESWpLlCupaB5+RK3S5JWnsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825122; c=relaxed/simple;
	bh=Mas6mmOl7NWeQL3aU55SpBwpUTI1SdOKtmeglRe0Co0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw0C8ewb6Vqkq3FU9Cr+v+ikZT0XsKGXb6wplYlXKA/sRqAd4WKQhuOsl8unBSijpa8DcXiz+m04oJBKnmGHUzsYg9Fmb9xnYp4emvAzp1xTXV2Suw4t0XUxon+Nlakm9zGV4USlGU/MDu16lXeonLGyPajQXzmyQm2qUZUbvAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYXhrY+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYXhrY+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14557C116B1;
	Tue, 11 Nov 2025 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825122;
	bh=Mas6mmOl7NWeQL3aU55SpBwpUTI1SdOKtmeglRe0Co0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYXhrY+kY4hBzTOVs4olgtSm57xLXGSaLezSmzwb0lFWfg4Ho0SoaQ6kpWFthvD9m
	 oXqzvhVnYpbLc/o5RNLwoa5ekdjrjLsyEz7BMBKtEhGIKeIMLlR2LO70JkIHjA5u42
	 QZI50tmuQ+5Y32hVXjuqOrzPQEYsPwestoxx4TKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 617/849] net: dsa: microchip: Set SPI as bus interface during reset for KSZ8463
Date: Tue, 11 Nov 2025 09:43:07 +0900
Message-ID: <20251111004551.347512633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

[ Upstream commit a0b977a3d19368b235f2a6c06e800fb25452029b ]

At reset, the KSZ8463 uses a strap-based configuration to set SPI as
bus interface. SPI is the only bus supported by the driver. If the
required pull-ups/pull-downs are missing (by mistake or by design to
save power) the pins may float and the configuration can go wrong
preventing any communication with the switch.

Introduce a ksz8463_configure_straps_spi() function called during the
device reset. It relies on the 'straps-rxd-gpios' OF property and the
'reset' pinmux configuration to enforce SPI as bus interface.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20250918-ksz-strap-pins-v3-3-16662e881728@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 45 ++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9568cc391fe3e..a962055bfdbd8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -23,6 +23,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/micrel_phy.h>
+#include <linux/pinctrl/consumer.h>
 #include <net/dsa.h>
 #include <net/ieee8021q.h>
 #include <net/pkt_cls.h>
@@ -5345,6 +5346,38 @@ static int ksz_parse_drive_strength(struct ksz_device *dev)
 	return 0;
 }
 
+static int ksz8463_configure_straps_spi(struct ksz_device *dev)
+{
+	struct pinctrl *pinctrl;
+	struct gpio_desc *rxd0;
+	struct gpio_desc *rxd1;
+
+	rxd0 = devm_gpiod_get_index_optional(dev->dev, "straps-rxd", 0, GPIOD_OUT_LOW);
+	if (IS_ERR(rxd0))
+		return PTR_ERR(rxd0);
+
+	rxd1 = devm_gpiod_get_index_optional(dev->dev, "straps-rxd", 1, GPIOD_OUT_HIGH);
+	if (IS_ERR(rxd1))
+		return PTR_ERR(rxd1);
+
+	if (!rxd0 && !rxd1)
+		return 0;
+
+	if ((rxd0 && !rxd1) || (rxd1 && !rxd0))
+		return -EINVAL;
+
+	pinctrl = devm_pinctrl_get_select(dev->dev, "reset");
+	if (IS_ERR(pinctrl))
+		return PTR_ERR(pinctrl);
+
+	return 0;
+}
+
+static int ksz8463_release_straps_spi(struct ksz_device *dev)
+{
+	return pinctrl_select_default_state(dev->dev);
+}
+
 int ksz_switch_register(struct ksz_device *dev)
 {
 	const struct ksz_chip_data *info;
@@ -5360,10 +5393,22 @@ int ksz_switch_register(struct ksz_device *dev)
 		return PTR_ERR(dev->reset_gpio);
 
 	if (dev->reset_gpio) {
+		if (of_device_is_compatible(dev->dev->of_node, "microchip,ksz8463")) {
+			ret = ksz8463_configure_straps_spi(dev);
+			if (ret)
+				return ret;
+		}
+
 		gpiod_set_value_cansleep(dev->reset_gpio, 1);
 		usleep_range(10000, 12000);
 		gpiod_set_value_cansleep(dev->reset_gpio, 0);
 		msleep(100);
+
+		if (of_device_is_compatible(dev->dev->of_node, "microchip,ksz8463")) {
+			ret = ksz8463_release_straps_spi(dev);
+			if (ret)
+				return ret;
+		}
 	}
 
 	mutex_init(&dev->dev_mutex);
-- 
2.51.0



