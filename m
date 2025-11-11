Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E97346A16;
	Tue, 11 Nov 2025 01:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824214; cv=none; b=goRTF7GDEaVDloPEOAQfSAZWIwBYPDc4O/q6xyVdJslwFt2Q5NDSek7az0if1TEcz/EHNUUQRkO6f28PL3QgqRQ1HnMKXcF/Gwagk8EnyDQR1eaW+ikPCBEKhwCODLu1JqztnXF43kKaee+Wx1Cm8VCkxfPWmNpFpw4j0xBRtTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824214; c=relaxed/simple;
	bh=18vP2UBUI1oZqlSVcyaP71FNlsh1scRvejeIbAama+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQOkV1tuHDHTKdrp4C62YSuGfqBnLqmrWf1l8QS0eNS3RUHi1NXpAUp/VAHrRJWhKTp3Nu4NKPt8Wz7y2aoMqWMXJE/EVjetbKT9YYkKLj/W6+66svWunbNb5VmbAdMA6xijq9FikfK/B2p5WOxKqm1j0s9cUM6GpEOnBzx2CZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNJvGH2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNJvGH2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72348C116D0;
	Tue, 11 Nov 2025 01:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824214;
	bh=18vP2UBUI1oZqlSVcyaP71FNlsh1scRvejeIbAama+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNJvGH2vbdGdxGtKutQZuHbabqNLJ+fi85Iug3xasY1MsoIz0SDx5gX0DHT8yb01G
	 TBgsHd8pKAAuqjOR7i+5rRcykUy/VqqAwuiY1jadQwv4xCrItRQeYo3xpSfZzl7Czo
	 7EIozTDHFrHyoxU8mchwHafC9FWO8pkrbu0OOhxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/565] net: dsa: microchip: Set SPI as bus interface during reset for KSZ8463
Date: Tue, 11 Nov 2025 09:44:28 +0900
Message-ID: <20251111004536.137622191@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 0a34fd6887fc0..1da2310442fc5 100644
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
@@ -4715,6 +4716,38 @@ static int ksz_parse_drive_strength(struct ksz_device *dev)
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
@@ -4730,10 +4763,22 @@ int ksz_switch_register(struct ksz_device *dev)
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



