Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521F355F42;
	Wed, 30 Sep 2026 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786940; cv=none; b=qG6rNT1LpyJRqQxYlBhq6y8iUBDDx/BR44Mkz/QtDcpxx6ueWZT4p7XL7x4jVF69qcoksx242g5JoFw+/aUAOhBlD5qtz0oC1iZ9bcOYs93SEPbV20ZkbgGolEKMYS1isQH+OCe16L3ZUm2jYah1JFBD2wx1aJJ+K/rLX93bLKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786940; c=relaxed/simple;
	bh=WX6dt7pCfaMhnq0KLy+WBO+j7/2YATSNmiz91rj+OHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2Uc6ChYkFXzBRHRn+77jCplz7aaIXr2A2H+yX3YHQjfbUkrdZ2Z4cOsvngJ782GgJtOS/+hEw2xi8TVW87UBUkW6LxEVGVZEYkMx5+4DfzyPCGQbdK39wJBX247dXQS0C76PifUCgbBeQk+d/Kbsu/MRhlpjyL2KiivKaC7cMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpuFAf/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpuFAf/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0B11F000FF;
	Wed, 30 Sep 2026 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786938;
	bh=/c51o4GbYtb3WP9NWc6pHUzahpj398hfH3R9lIh822g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpuFAf/tRVD+0vEaCFQaAMKX2VOE7d9bu4Pd07fWq6UtRYcwjS1WUm0hkGbG7ScMc
	 HGDgsNjky/cUlFdWmIsinUUC00MIYGQTBOkrWE7p3v06ictyttK6VY83p22Gq5Gs3V
	 Y5XIh8lnCH0SvJ/HoCua0MAVtt1qeHYq2KvHC6W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Per Larsson <per@palvencia.se>,
	Juan Manuel Lopez Carrillo <juanmanuellopezcarrillo@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 053/457] pinctrl: sunxi: A523: fix voltage withstand encoding
Date: Wed, 30 Sep 2026 17:22:38 +0200
Message-ID: <20260930152347.180669077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit ef56085dfd1df3a53ecce8a4ff440cf6d67f430d ]

The Allwinner A523 uses the same GPIO voltage "withstand" programming
(setting the input level voltage thresholds) as the previous SoCs, but
for some odd reason inverts the encoding of 1.8V vs. 3.3V.

Add a new bias voltage type to note this difference, and select it for
the A523. At the same time also use the newer "CTL" version, which in
addition allows to turn off the withstand programming for I/O voltages
other than exact 1.8V or 3.3V (for instance for 2.5V sometimes used for
Ethernet PHYs). The A523 has that enable register, but didn't use it
so far.

This fixes eMMC and reportedly Ethernet operation on some A523 boards.

Fixes: 648be4cd9517 ("pinctrl: sunxi: Add support for the Allwinner A523")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Per Larsson <per@palvencia.se>
Tested-by: Juan Manuel Lopez Carrillo <juanmanuellopezcarrillo@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Tested-by: Chen-Yu Tsai <wens@kernel.org> # Fixes eMMC on Orange Pi 4A
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c   | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c         | 6 ++++++
 drivers/pinctrl/sunxi/pinctrl-sunxi.h         | 2 ++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c b/drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c
index 462aa1c4a5fa6..e27e4945def26 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c
@@ -26,7 +26,7 @@ static const u8 a523_r_irq_bank_muxes[SUNXI_PINCTRL_MAX_BANKS] =
 static struct sunxi_pinctrl_desc a523_r_pinctrl_data = {
 	.irq_banks = ARRAY_SIZE(a523_r_irq_bank_map),
 	.irq_bank_map = a523_r_irq_bank_map,
-	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_SEL,
+	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_CTL_INV,
 	.pin_base = PL_BASE,
 };
 
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c b/drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c
index b6f78f1f30ac4..88d8acd5bc245 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c
@@ -26,7 +26,7 @@ static const u8 a523_irq_bank_muxes[SUNXI_PINCTRL_MAX_BANKS] =
 static struct sunxi_pinctrl_desc a523_pinctrl_data = {
 	.irq_banks = ARRAY_SIZE(a523_irq_bank_map),
 	.irq_bank_map = a523_irq_bank_map,
-	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_SEL,
+	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_CTL_INV,
 };
 
 static int a523_pinctrl_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 25489beeb3125..7b33bcb7f840a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -728,6 +728,7 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 {
 	unsigned short bank;
 	unsigned long flags;
+	bool inverted = false;
 	u32 val, reg;
 	int uV;
 
@@ -766,6 +767,9 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 		reg &= ~IO_BIAS_MASK;
 		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
 		return 0;
+	case BIAS_VOLTAGE_PIO_POW_MODE_CTL_INV:
+		inverted = true;
+		fallthrough;
 	case BIAS_VOLTAGE_PIO_POW_MODE_CTL:
 		val = uV > 1800000 && uV <= 2500000 ? BIT(bank) : 0;
 
@@ -780,6 +784,8 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 		fallthrough;
 	case BIAS_VOLTAGE_PIO_POW_MODE_SEL:
 		val = uV <= 1800000 ? 1 : 0;
+		if (inverted)
+			val = !val;
 
 		raw_spin_lock_irqsave(&pctl->lock, flags);
 		reg = readl(pctl->membase + pctl->pow_mod_sel_offset);
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index 0daf7600e2fb0..b09df32a3073a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -116,8 +116,10 @@ enum sunxi_desc_bias_voltage {
 	 * Bias voltage is set through PIO_POW_MOD_SEL_REG
 	 * and PIO_POW_MOD_CTL_REG register, as seen on
 	 * A100 and D1 SoC, for example.
+	 * Some SoCs invert the encoding for 1.8V vs. 3.3V.
 	 */
 	BIAS_VOLTAGE_PIO_POW_MODE_CTL,
+	BIAS_VOLTAGE_PIO_POW_MODE_CTL_INV,
 };
 
 struct sunxi_desc_function {
-- 
2.53.0



