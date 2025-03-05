Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52C61A5BB7;
	Wed,  5 Mar 2025 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198229; cv=none; b=BmtNxaIbRYZ3VDHp8gTLx8ZlVJK3pWe9SCjy7pnRWdjPHm7FCAAYmmDtUAAd0dUoJbikdYn7pe+oEdXeKQ2haNIlNHgpR1eYoUeSRv9OlnmAhJPK9U0RuAgEyV7yxrLZZWzXtIQjPOovFj3Itmiz4ZJcNBXuz4mZq4XHooK7pDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198229; c=relaxed/simple;
	bh=7sfTGDax39TT3x+0O0+tWH9YIUDXOBIzCI0q/7SG6Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfhHPB9CRZYIos9dcCmIywo7FKIRpzWfx+ftjMYKtBZB0kf6W9tsjdkgIRKZS9ps1EhHL4CErTu3wFRMMZbBmsW+lu11Kr9tt7GESMTAIkvNVYMqaC8/ZsoDnwoe9EsILjfRzQtq7yh0vkFsfWDgVwSFV/rGkSJqwVUtf4QHt6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3UGYzVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3UGYzVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDC7C4CEE0;
	Wed,  5 Mar 2025 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198229;
	bh=7sfTGDax39TT3x+0O0+tWH9YIUDXOBIzCI0q/7SG6Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3UGYzVsKkhgxcpwAC/4AVLE9ZXJ/rA2pKf7COi6d/k2BxyMCVc4UPqtToOU65Os3
	 wL+qqHbvdQfrB1OXMM1OIvM1zjirOPOXVAxvPxCvwC24+zQa/RXtbgVuq4rpRKnXod
	 1jB9GmD7aAC2b+iJByt42lWp/nyJUPMy+J6zMw20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Andy Shevchenko <andy@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 107/150] i2c: ls2x: Fix frequency division register access
Date: Wed,  5 Mar 2025 18:48:56 +0100
Message-ID: <20250305174508.112909451@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit 71c49ee9bb41e1709abac7e2eb05f9193222e580 upstream.

According to the chip manual, the I2C register access type of
Loongson-2K2000/LS7A is "B", so we can only access registers in byte
form (readb()/writeb()).

Although Loongson-2K0500/Loongson-2K1000 do not have similar
constraints, register accesses in byte form also behave correctly.

Also, in hardware, the frequency division registers are defined as two
separate registers (high 8-bit and low 8-bit), so we just access them
directly as bytes.

Fixes: 015e61f0bffd ("i2c: ls2x: Add driver for Loongson-2K/LS7A I2C controller")
Co-developed-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Cc: stable@vger.kernel.org # v6.3+
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250220125612.1910990-1-zhoubinbin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-ls2x.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-ls2x.c
+++ b/drivers/i2c/busses/i2c-ls2x.c
@@ -10,6 +10,7 @@
  * Rewritten for mainline by Binbin Zhou <zhoubinbin@loongson.cn>
  */
 
+#include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/completion.h>
 #include <linux/device.h>
@@ -26,7 +27,8 @@
 #include <linux/units.h>
 
 /* I2C Registers */
-#define I2C_LS2X_PRER		0x0 /* Freq Division Register(16 bits) */
+#define I2C_LS2X_PRER_LO	0x0 /* Freq Division Low Byte Register */
+#define I2C_LS2X_PRER_HI	0x1 /* Freq Division High Byte Register */
 #define I2C_LS2X_CTR		0x2 /* Control Register */
 #define I2C_LS2X_TXR		0x3 /* Transport Data Register */
 #define I2C_LS2X_RXR		0x3 /* Receive Data Register */
@@ -93,6 +95,7 @@ static irqreturn_t ls2x_i2c_isr(int this
  */
 static void ls2x_i2c_adjust_bus_speed(struct ls2x_i2c_priv *priv)
 {
+	u16 val;
 	struct i2c_timings *t = &priv->i2c_t;
 	struct device *dev = priv->adapter.dev.parent;
 	u32 acpi_speed = i2c_acpi_find_bus_speed(dev);
@@ -104,9 +107,14 @@ static void ls2x_i2c_adjust_bus_speed(st
 	else
 		t->bus_freq_hz = LS2X_I2C_FREQ_STD;
 
-	/* Calculate and set i2c frequency. */
-	writew(LS2X_I2C_PCLK_FREQ / (5 * t->bus_freq_hz) - 1,
-	       priv->base + I2C_LS2X_PRER);
+	/*
+	 * According to the chip manual, we can only access the registers as bytes,
+	 * otherwise the high bits will be truncated.
+	 * So set the I2C frequency with a sequential writeb() instead of writew().
+	 */
+	val = LS2X_I2C_PCLK_FREQ / (5 * t->bus_freq_hz) - 1;
+	writeb(FIELD_GET(GENMASK(7, 0), val), priv->base + I2C_LS2X_PRER_LO);
+	writeb(FIELD_GET(GENMASK(15, 8), val), priv->base + I2C_LS2X_PRER_HI);
 }
 
 static void ls2x_i2c_init(struct ls2x_i2c_priv *priv)


