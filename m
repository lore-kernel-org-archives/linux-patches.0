Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870402F5B;
	Sat, 25 Oct 2025 16:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409300; cv=none; b=K7CpHwke4SneXxEXF5im6sDiZpYufMVI1RadyJaVjZTPTWLsTo2rW+Q4/tkAkpYXi9orC7y2u0Yoz5bRrnKEP7f38dEvKsjoGNBQncE+gg93kS8j5z8jPyAnDIGjJIHRuGCOmlhgPwW8H8xJ7nF2KXb9+y+0abLYFRICpuzGiZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409300; c=relaxed/simple;
	bh=Yf28+GELE5a4yFvMiNeRAsehsu8e7C/tvg7G40Uaafw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IM87egb3SHYhHvX+5ise6m46saFkWOjwSxfVF4pDsRcVLCEPrnC7lytfEkt9ZZF/BcH69s85/GyLhbRAtBkYw3I8lRRwIC2p9QNOpL0uqbN/izYmJ/rTSTgFQrORAvef9/+sNpbZ2mqpXtZf78ZhVKJ25LyNvXGOu4XNzh+XJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XR2I8cXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XR2I8cXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67977C2BCB4;
	Sat, 25 Oct 2025 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409300;
	bh=Yf28+GELE5a4yFvMiNeRAsehsu8e7C/tvg7G40Uaafw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR2I8cXh8Yr8QO0iyoXv6iE5d6LC5PYoDMHGrcKmUTWXbtZhBQ0dpx1UgzmjohNcx
	 VwJDm/l0K8c3CZzouS2VG3WAMCcDrZSv04+bhSiCyjnbD1en9THZEAVPLSyDVIrPam
	 vmwEi0QPgYPN9y3/zeY0/CZjRYTtXTefCaIMMLPpuDRPeHsY1HUoviWsIuvw4+Vj/2
	 bzvf/TA7aEn+hLXMmITm7Zcyb12hCaAKqVBl8SPiGXvxujwT0MdkppEImdSS3EHp62
	 hwfDqF4PTSeaq0eXN08FiXtw47rWBnrcX0XgVE4QqA762wNYwQwPHylQ9Fd++ZaEzS
	 u4iOr6bPkRjug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	woojung.huh@microchip.com,
	UNGLinuxDriver@microchip.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] net: dsa: microchip: Set SPI as bus interface during reset for KSZ8463
Date: Sat, 25 Oct 2025 11:58:19 -0400
Message-ID: <20251025160905.3857885-268-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES: This change is a small, self‑contained bug fix that protects
KSZ8463 boards from booting with the wrong host interface when the
hardware strap resistors are missing or weak.

- `drivers/net/dsa/microchip/ksz_common.c:5355` introduces
  `ksz8463_configure_straps_spi()`, which momentarily drives the
  `straps-rxd` GPIOs (if present) to the required low/high levels before
  reset, guaranteeing the switch samples “SPI” on the bus-strap pins.
  Without this, floating pins can leave the device in a non-SPI mode and
  make the switch unreachable.
- The new code path is gated tightly: it runs only for
  `microchip,ksz8463` devices that already provide a `reset-gpios` line,
  and it bails out harmlessly when the optional strap GPIOs aren’t
  described, so existing DTs keep working unchanged.
- After toggling reset, `drivers/net/dsa/microchip/ksz_common.c:5408`
  calls `ksz8463_release_straps_spi()` to restore the default pinctrl
  state; `pinctrl_select_default_state()` safely no-ops when no pinctrl
  data exist (`drivers/pinctrl/core.c:1637`), so there’s no regression
  risk for existing boards.
- The fix relies only on long-standing GPIO/pinctrl helpers, adds no
  architectural churn, and doesn’t touch other chips or subsystems; it
  simply lets boards that already wire the strap pins to GPIOs recover
  from a real hardware failure mode.

Given the user-visible failure it resolves and its low risk profile,
this commit is a good candidate for the stable series. Recommend
backporting alongside the corresponding DT binding update so board
descriptions can supply the new strap GPIOs and “reset” pinmux state
when needed.

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

