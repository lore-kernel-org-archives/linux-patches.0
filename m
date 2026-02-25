Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B790311C35;
	Wed, 25 Feb 2026 06:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002696; cv=none; b=dU4Wd8ahD2A4klcvXCAOu8mS+29Tjxkqd4xSE/aYLi3dIMPWCONYzM1a8boIReyLQYfV/8zJYmee+p6Ut3qGgXSEpAieGWW85sabl6x7X8YfLwMEIeiAhf5YI9pq8gFcsyh1Z53vhUIo6QihbNRqnyC2K+G2XAfAGo9gPTyrX/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002696; c=relaxed/simple;
	bh=Yb3H5FVHM4Vlwlhpj3esGeV5Jqy3R8hAyrbkdeUA8kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcdW2HNmgFnat7izp+IHE2CP3NKIg/ALcksSsS+xhG8ketUN1Iiq4kcphZqak+V1mMSEU8Sl6pfBuqNbMjZT6DRgodvlIFe5i1r65/+aZeeWw7OFIKhZ2cOE5WnSU6HnZxU7mdt2CG8bBbCjylPan1I+pIJ/ughZILWCBzeM3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdRLELrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdRLELrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16298C116D0;
	Wed, 25 Feb 2026 06:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002696;
	bh=Yb3H5FVHM4Vlwlhpj3esGeV5Jqy3R8hAyrbkdeUA8kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdRLELrlV1uHnF/PjJ6Kvb8NNSZ8nja07IKBg3YVfI4SI0nHXAI+PuKZCTOj6ztKG
	 NzQX4e5j+vL2V0xs7VEH9l+2Rp2jMqH2WD9ykJl/Iqe5M6aiE+21A8gVMf2r8HonxO
	 Gl0ceZuX6+Xe0j7U0hwyhkKVKZSn/xaOI+V6JreE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje@dujemihanovic.xyz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 492/641] leds: expresswire: Fix chip state breakage
Date: Tue, 24 Feb 2026 17:23:38 -0800
Message-ID: <20260225012400.437371460@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duje Mihanović <duje@dujemihanovic.xyz>

[ Upstream commit f4b830a5371914239756b0599e5dc9d4c328e387 ]

It is possible to put the KTD2801 chip in an unknown/undefined state by
changing the brightness very rapidly (for example, with a brightness
slider). When this happens, the brightness is stuck on max and cannot be
changed until the chip is power cycled.

Fix this by disabling interrupts while talking to the chip. While at it,
make expresswire_power_off() use fsleep() and also unexport some
functions meant to be internal.

Fixes: 1368d06dd2c9 ("leds: Introduce ExpressWire library")
Tested-by: Karel Balej <balejk@matfyz.cz>
Signed-off-by: Duje Mihanović <duje@dujemihanovic.xyz>
Link: https://patch.msgid.link/20251217-expresswire-fix-v2-1-4a02b10acd96@dujemihanovic.xyz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-expresswire.c  | 24 +++++++++++++++++-------
 include/linux/leds-expresswire.h |  3 ---
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-expresswire.c b/drivers/leds/leds-expresswire.c
index bb69be228a6d3..25c6b159a6ee9 100644
--- a/drivers/leds/leds-expresswire.c
+++ b/drivers/leds/leds-expresswire.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/gpio/consumer.h>
+#include <linux/irqflags.h>
 #include <linux/types.h>
 
 #include <linux/leds-expresswire.h>
@@ -16,37 +17,41 @@
 void expresswire_power_off(struct expresswire_common_props *props)
 {
 	gpiod_set_value_cansleep(props->ctrl_gpio, 0);
-	usleep_range(props->timing.poweroff_us, props->timing.poweroff_us * 2);
+	fsleep(props->timing.poweroff_us);
 }
 EXPORT_SYMBOL_NS_GPL(expresswire_power_off, "EXPRESSWIRE");
 
 void expresswire_enable(struct expresswire_common_props *props)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
+
 	gpiod_set_value(props->ctrl_gpio, 1);
 	udelay(props->timing.detect_delay_us);
 	gpiod_set_value(props->ctrl_gpio, 0);
 	udelay(props->timing.detect_us);
 	gpiod_set_value(props->ctrl_gpio, 1);
+
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_NS_GPL(expresswire_enable, "EXPRESSWIRE");
 
-void expresswire_start(struct expresswire_common_props *props)
+static void expresswire_start(struct expresswire_common_props *props)
 {
 	gpiod_set_value(props->ctrl_gpio, 1);
 	udelay(props->timing.data_start_us);
 }
-EXPORT_SYMBOL_NS_GPL(expresswire_start, "EXPRESSWIRE");
 
-void expresswire_end(struct expresswire_common_props *props)
+static void expresswire_end(struct expresswire_common_props *props)
 {
 	gpiod_set_value(props->ctrl_gpio, 0);
 	udelay(props->timing.end_of_data_low_us);
 	gpiod_set_value(props->ctrl_gpio, 1);
 	udelay(props->timing.end_of_data_high_us);
 }
-EXPORT_SYMBOL_NS_GPL(expresswire_end, "EXPRESSWIRE");
 
-void expresswire_set_bit(struct expresswire_common_props *props, bool bit)
+static void expresswire_set_bit(struct expresswire_common_props *props, bool bit)
 {
 	if (bit) {
 		gpiod_set_value(props->ctrl_gpio, 0);
@@ -60,13 +65,18 @@ void expresswire_set_bit(struct expresswire_common_props *props, bool bit)
 		udelay(props->timing.short_bitset_us);
 	}
 }
-EXPORT_SYMBOL_NS_GPL(expresswire_set_bit, "EXPRESSWIRE");
 
 void expresswire_write_u8(struct expresswire_common_props *props, u8 val)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
+
 	expresswire_start(props);
 	for (int i = 7; i >= 0; i--)
 		expresswire_set_bit(props, val & BIT(i));
 	expresswire_end(props);
+
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_NS_GPL(expresswire_write_u8, "EXPRESSWIRE");
diff --git a/include/linux/leds-expresswire.h b/include/linux/leds-expresswire.h
index a422921f4159f..7f8c4795f69fa 100644
--- a/include/linux/leds-expresswire.h
+++ b/include/linux/leds-expresswire.h
@@ -30,9 +30,6 @@ struct expresswire_common_props {
 
 void expresswire_power_off(struct expresswire_common_props *props);
 void expresswire_enable(struct expresswire_common_props *props);
-void expresswire_start(struct expresswire_common_props *props);
-void expresswire_end(struct expresswire_common_props *props);
-void expresswire_set_bit(struct expresswire_common_props *props, bool bit);
 void expresswire_write_u8(struct expresswire_common_props *props, u8 val);
 
 #endif /* _LEDS_EXPRESSWIRE_H */
-- 
2.51.0



