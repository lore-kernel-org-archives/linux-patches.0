Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24939248881;
	Wed, 25 Feb 2026 01:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983497; cv=none; b=c8KI1PHOKm3BllTWuN/+r9amfUNGMRqgNiyN1wLx6X4WsG2hq1+17C1OroSfan3LXZHczh7GarjngF0kP8v0u+5rU+GNZZb/5ZuJ+b74FDGeSWqStHrBepfxGXB38s1ssonK01vIEunTT5P6SiN9xvYrr0LU3GebQ/fwlQuO4+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983497; c=relaxed/simple;
	bh=AKCVT1wsjpMmC9qkEvTs7fNZDBKlQXfWVORcxxEZYmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWz4NFog5iHvEZFklbfo20Fqwz60cqkeDy7SGvWvi9qCRgo4qrvAzXaIEEjBUPlLZxXPWsh5uZeH/scW+q6GTSsxVW72F1o4YHu4IDi/+EwOetAI22PovQQNRYnRQ9x4nZIXhV14gdvqqUnLVfCRKNkzpLaNlbxW1aV72Hk5H+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOUcwhcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOUcwhcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2158C116D0;
	Wed, 25 Feb 2026 01:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983497;
	bh=AKCVT1wsjpMmC9qkEvTs7fNZDBKlQXfWVORcxxEZYmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOUcwhcwsSyKRObLfYbJBimJm+PfFaFGrBZjSpzYWZV/YNSwodYNeVZ23a4zifRzg
	 Bl74bV5sOBN4280Zzm248QztgWjg3ODUxCOGGp1klA8qggjIJ0ui5/59zB4Ps9UTEJ
	 qWF/XIjie9bIuahdDkoFkMH09aP1/m6b8nFpECaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje@dujemihanovic.xyz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 606/781] leds: expresswire: Fix chip state breakage
Date: Tue, 24 Feb 2026 17:21:55 -0800
Message-ID: <20260225012414.658529619@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



