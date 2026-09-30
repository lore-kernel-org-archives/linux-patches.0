Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F338E51C33F;
	Wed, 30 Sep 2026 18:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792839; cv=none; b=HX3JzXTS/c8Y176hGB8MwyGSyBu3An7BpNvujiiOHlxVSKDOcHrfO09j8jplZ7Q2LTUlQT7kp70mf3zHR4EQmUiVr0EFhkf116BZ3NLRHywrYdwIIAQry58K5Y9/7M3GpI7OhD+W2397y54l3+QQt58UYVd0VWVmjTkdXWABVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792839; c=relaxed/simple;
	bh=8I1lVdAY+t17qKd8L3JIaCS1T6MMnVVxI3nyWRcMJnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkIo5RAnd3B7mVUoW7fJktx4i1h7XG7SCV9qYL61URCQ7Ujh59aqJpVSBrAeA94tbUExKpv9dGpBd3YYme5feHp3VECbIP3F5fRzE/XOr/lCzybdT6R8O3QZvtKhMHcaOXV0D1a8yDBLxFCcrfsuBzQr7vw3m0ydksXvnrjgdmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpJHDWEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpJHDWEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8E61F000FF;
	Wed, 30 Sep 2026 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792837;
	bh=Vd1ifGz73KHejsee56MUbZRAzSJaA0I82w0SYSK0d8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpJHDWEXAxbu/TiG5PedkUJtT/HU/oSSH5RJb7roy8xx4HFaK+StM53VMN5MSMpUX
	 1UZAiEcHLuV7qBPu0xmR/YQspD7GvH6LEOCk/wfy/CVIjY/XhAAoB/EbULY9iKrQ3p
	 7aoivJ4JMQsrABeiaGd0bhWSWbaup5GeGBYC07wA=
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
Subject: [PATCH 6.18 044/395] pinctrl: sunxi: A523: fix voltage withstand encoding
Date: Wed, 30 Sep 2026 17:25:06 +0200
Message-ID: <20260930152341.585924001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 93e396041456a..6099ae93e1536 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -699,6 +699,7 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 {
 	unsigned short bank;
 	unsigned long flags;
+	bool inverted = false;
 	u32 val, reg;
 	int uV;
 
@@ -737,6 +738,9 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 		reg &= ~IO_BIAS_MASK;
 		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
 		return 0;
+	case BIAS_VOLTAGE_PIO_POW_MODE_CTL_INV:
+		inverted = true;
+		fallthrough;
 	case BIAS_VOLTAGE_PIO_POW_MODE_CTL:
 		val = uV > 1800000 && uV <= 2500000 ? BIT(bank) : 0;
 
@@ -751,6 +755,8 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 		fallthrough;
 	case BIAS_VOLTAGE_PIO_POW_MODE_SEL:
 		val = uV <= 1800000 ? 1 : 0;
+		if (inverted)
+			val = !val;
 
 		raw_spin_lock_irqsave(&pctl->lock, flags);
 		reg = readl(pctl->membase + pctl->pow_mod_sel_offset);
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index ad26e4de16a85..418c0508eb18a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -114,8 +114,10 @@ enum sunxi_desc_bias_voltage {
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



