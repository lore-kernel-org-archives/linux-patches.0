Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204BB1BD9D0;
	Wed, 20 May 2026 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295776; cv=none; b=QkaTSq3CEXdV+LOg4S5ileTD/HbIrDH43T1n7e2H7SH7g39qi/OEWYQsVJZrR3ecOdzN/qeTayUHO3KUos2qRfnvys6uux7HvRY/6ALaRchk7HHevZx8h2uiRkMXtroKTuOG8C/KsgGlYbnNuC0q9mzYi+HbmWbTg9CfQx7hbFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295776; c=relaxed/simple;
	bh=a+Ztmp4uY/q0hwGb+kIPqI/HlbE48O4HUrlupCUQ1hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiRp3eLXAIomVJYuxECxrl6Bi3W2K6+kilVqd4O2LnrovJCx8l49oTfSsu2GcpUx3bTd/5NaFZPtl5Xpzsb3w2Q1l3XsEwWIE2j3lBTiTH7I+TeZ/RJ85tYsda27gap9J6n7bSj8hMaFCThKOUXXcdB6emjMwERwnmaP4UB1zNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1dWXcFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1dWXcFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032E81F00893;
	Wed, 20 May 2026 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295774;
	bh=5bLD9f3si4NBTQZGelKkrFZZS/5AD1VZGc0cMV55UMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1dWXcFhljBr+pvG2WJO5Z4PhS3EGxaNRCXLOYntQTxJ8vx2GG801uHVCeiLRsMcD
	 tEvc2hy47XtC1FI5DieXXPThhMOAbjF7+uR9nN8Y18ULDECAky47CU0zAwlqOYzzyS
	 m7PPM4j6fbHiCHtB1LCMwo0oYoygFboClP5nIqVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0546/1146] arm64: dts: lx2160a: complete pinmux for rcwsr12 configuration word
Date: Wed, 20 May 2026 18:13:16 +0200
Message-ID: <20260520162200.537255792@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 284ad7064aaa1badde022785cd925af29c696b21 ]

Commit 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to
support bus recovery") introduced pinmux nodes for lx2160 i2c
interfaces, allowing runtime change between i2c and gpio functions
implementing bus recovery.

However, the dynamic configuration area (overwrite MUX) used by the
pinctrl-single driver initially reads as zero and does not reflect the
actual hardware state set by the Reset Configuration Word (RCW) at
power-on.

Because multiple groups of pins are configured from a single 32-bit
register, the first write from the pinctrl driver unintentionally clears
all other bits to zero.

Add description for all bits of RCWSR12 register, allowing boards to
explicitly define and restore their intended hardware state.

This includes i2c, gpio, flextimer, spi, can and sdhc functions.

Other configuration words, i.e. RCWSR13 & RCWSR14 may be added in the
future for boards setting non-zero values there.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index d266bf96e2c6a..479982948ee53 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1721,6 +1721,7 @@ pinmux_i2crv: pinmux@70010012c {
 			pinctrl-single,register-width = <32>;
 			pinctrl-single,function-mask = <0x7>;
 
+			/* RCWSR12 */
 			i2c1_pins: iic2-i2c-pins {
 				pinctrl-single,bits = <0x0 0x0 0x7>;
 			};
@@ -1729,6 +1730,10 @@ gpio0_31_30_pins: iic2-gpio-pins {
 				pinctrl-single,bits = <0x0 0x1 0x7>;
 			};
 
+			ftm0_ch10_pins: iic2-ftm-pins {
+				pinctrl-single,bits = <0x0 0x2 0x7>;
+			};
+
 			esdhc0_cd_wp_pins: iic2-sdhc-pins {
 				pinctrl-single,bits = <0x0 0x6 0x7>;
 			};
@@ -1741,6 +1746,14 @@ gpio0_29_28_pins: iic3-gpio-pins {
 				pinctrl-single,bits = <0x0 (0x1 << 3) (0x7 << 3)>;
 			};
 
+			can0_pins: iic3-can-pins {
+				pinctrl-single,bits = <0x0 (0x2 << 3) (0x7 << 3)>;
+			};
+
+			event65_pins: iic3-event-pins {
+				pinctrl-single,bits = <0x0 (0x6 << 3) (0x7 << 3)>;
+			};
+
 			i2c3_pins: iic4-i2c-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 6)>;
 			};
@@ -1749,6 +1762,14 @@ gpio0_27_26_pins: iic4-gpio-pins {
 				pinctrl-single,bits = <0x0 (0x1 << 6) (0x7 << 6)>;
 			};
 
+			can1_pins: iic4-can-pins {
+				pinctrl-single,bits = <0x0 (0x2 << 6) (0x7 << 6)>;
+			};
+
+			event87_pins: iic4-event-pins {
+				pinctrl-single,bits = <0x0 (0x6 << 6) (0x7 << 6)>;
+			};
+
 			i2c4_pins: iic5-i2c-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 9)>;
 			};
@@ -1757,6 +1778,14 @@ gpio0_25_24_pins: iic5-gpio-pins {
 				pinctrl-single,bits = <0x0 (0x1 << 9) (0x7 << 9)>;
 			};
 
+			esdhc0_clksync_pins: iic5-sdhc-clk-pins {
+				pinctrl-single,bits = <0x0 (0x2 << 9) (0x7 << 9)>;
+			};
+
+			dspi2_miso_mosi_pins: iic5-spi3-pins {
+				pinctrl-single,bits = <0x3 (0x2 << 9) (0x7 << 9)>;
+			};
+
 			i2c5_pins: iic6-i2c-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 12)>;
 			};
@@ -1765,26 +1794,71 @@ gpio0_23_22_pins: iic6-gpio-pins {
 				pinctrl-single,bits = <0x0 (0x1 << 12) (0x7 << 12)>;
 			};
 
+			esdhc1_clksync_pins: iic6-sdhc-clk-pins {
+				pinctrl-single,bits = <0x0 (0x2 << 12) (0x7 << 12)>;
+			};
+
 			fspi_data74_pins: xspi1-data74-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 15)>;
 			};
 
+			gpio1_31_28_pins: xspi1-data74-gpio-pins {
+				pinctrl-single,bits = <0x0 0x1 (0x7 << 15)>;
+			};
+
 			fspi_data30_pins: xspi1-data30-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 18)>;
 			};
 
+			gpio1_27_24_pins: xspi1-data30-gpio-pins {
+				pinctrl-single,bits = <0x0 0x1 (0x7 << 18)>;
+			};
+
 			fspi_dqs_sck_cs10_pins: xspi1-base-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 21)>;
 			};
 
+			gpio1_23_20_pins: xspi1-base-gpio-pins {
+				pinctrl-single,bits = <0x0 0x1 (0x7 << 21)>;
+			};
+
 			esdhc0_cmd_data30_clk_vsel_pins: sdhc1-base-sdhc-vsel-pins {
 				pinctrl-single,bits = <0x0 0x0 (0x7 << 24)>;
 			};
 
+			gpio0_21_15_pins: sdhc1-base-gpio-pins {
+				pinctrl-single,bits = <0x0 (0x1 << 24) (0x7 << 24)>;
+			};
+
+			dspi0_pins: sdhc1-base-spi1-pins {
+				pinctrl-single,bits = <0x0 (0x2 << 24) (0x7 << 24)>;
+			};
+
+			esdhc0_cmd_data30_clk_dspi2_cs0_pins: sdhc1-base-sdhc-spi3-pins {
+				pinctrl-single,bits = <0x0 (0x3 << 24) (0x7 << 24)>;
+			};
+
+			esdhc0_cmd_data30_clk_data4_pins: sdhc1-base-sdhc-data4-pins {
+				pinctrl-single,bits = <0x0 (0x4 << 24) (0x7 << 24)>;
+			};
+
+			esdhc0_dir_pins: sdhc1-dir-pins {
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 27)>;
+			};
+
 			gpio0_14_12_pins: sdhc1-dir-gpio-pins {
 				pinctrl-single,bits = <0x0 (0x1 << 27) (0x7 << 27)>;
 			};
 
+			dspi2_cs31_pins: sdhc1-dir-spi3-pins {
+				pinctrl-single,bits = <0x0 (0x3 << 27) (0x7 << 27)>;
+			};
+
+			esdhc0_data75_pins: sdhc1-dir-sdhc-pins {
+				pinctrl-single,bits = <0x0 (0x4 << 27) (0x7 << 27)>;
+			};
+
+			/* RCWSR13 */
 			gpio1_18_15_pins: iic8-iic7-gpio-pins {
 				pinctrl-single,bits = <0x4 0x1 0x7>;
 			};
@@ -1793,6 +1867,7 @@ i2c6_i2c7_pins: iic8-iic7-i2c-pins {
 				pinctrl-single,bits = <0x4 0x2 0x7>;
 			};
 
+			/* RCWSR14 */
 			i2c0_pins: iic1-i2c-pins {
 				pinctrl-single,bits = <0x8 0x0 (0x1 << 10)>;
 			};
-- 
2.53.0



