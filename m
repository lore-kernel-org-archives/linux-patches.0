Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF833FF1BD;
	Fri, 15 May 2026 16:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861971; cv=none; b=fk+WMkiGzmNqx+HMLfEi27fWlJsd5nVkGa3twHNPBAW5Nd3FZqvYCI7ItpmVrtcMToJ3Uv2v1jBwyBM2twxGHbos7mkxsF1Wx+Um2xlrKIeDQpxHvAcL7dGwv7Wvut6BKhThTGd+e8CZ2Od7sRPOWjyNwpAceq8jDaMK0FcypBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861971; c=relaxed/simple;
	bh=E9ZMFXU/empI8QWU869agazVk1loX88Gi+tb0jmkwu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTEOmVF78KqCgOZOgr3h9XR6jeYAgDDrKVOZZf4+CK2EhLlfR2/RMBKZtQXN36sATkHqJU9b3AKgGQQb59UYPJUfGj76+VPEZIzWHYzPgTuoB4PZogzGEdcdae5D6psY2YlMYDeUcObcvmtCUb/N9QRpPDgz83UUGwqh4Q+bM+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlnIH6pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlnIH6pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88358C2BCB0;
	Fri, 15 May 2026 16:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861970;
	bh=E9ZMFXU/empI8QWU869agazVk1loX88Gi+tb0jmkwu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlnIH6pO8oYnoiShS0ay7qLMr2H5JOUyhRJVvSxCcZDHv3xNqpNjstG/wFmXQ8WfK
	 NnBwgQ7w/3Ttyd+AfVjzSHgUsswgOXo0NrKIkYDiAd+l+a5QHIUMSv/hvVHDDhjXlx
	 t+mK37h9VA3SLBFBCBJG+DHYt2ZQgPLSf6Tf/T+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 021/188] arm64: dts: lx2160a-cex7/lx2162a-sr-som: fix usd-cd & gpio pinmux
Date: Fri, 15 May 2026 17:47:18 +0200
Message-ID: <20260515154657.767329011@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Josua Mayer <josua@solid-run.com>

commit 70008aee892bbb5c2969bbe9e5778fc081b14bd2 upstream.

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

For example, on the LX2162A Clearfog, RCWSR12 is initialized to
0x08000006. When any i2c pinmux is applied, it clears all other fields.
This inadvertently disables SD card-detect (IIC2_PMUX) and some GPIOs
(SDHC1_DIR_PMUX):

LX2162-CF RCWSR12: 0b0000100000000000 0000000000000110
IIC2_PMUX              |||   |||   || |   |||   |||XXX : I2C/GPIO/CD-WP
SDHC1_DIR_PMUX         XXX   |||   || |   |||   |||    : SDHC/GPIO/SPI

Reverting the commit in question was considered but bus recovery is an
important feature.

Instead add pinmux nodes for those pins that were unintentionally
reconfigured on SolidRun LX2160A Clearfog-CX and LX2162A Clearfog
boards.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi         |    7 +++
 arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi |    2 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi              |   24 ++++++++++++
 arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts      |    2 +
 arch/arm64/boot/dts/freescale/fsl-lx2162a-sr-som.dtsi       |    7 +++
 5 files changed, 42 insertions(+)

--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
@@ -162,6 +162,8 @@
 };
 
 &fspi {
+	pinctrl-names = "default";
+	pinctrl-0 = <&fspi_data74_pins>, <&fspi_data30_pins>, <&fspi_dqs_sck_cs10_pins>;
 	status = "okay";
 
 	flash@0 {
@@ -177,6 +179,11 @@
 	};
 };
 
+&pinmux_i2crv {
+	pinctrl-names = "default";
+	pinctrl-0 = <&gpio0_14_12_pins>;
+};
+
 &usb0 {
 	status = "okay";
 };
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -89,6 +89,8 @@
 };
 
 &esdhc0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&esdhc0_cd_wp_pins>, <&esdhc0_cmd_data30_clk_vsel_pins>;
 	sd-uhs-sdr104;
 	sd-uhs-sdr50;
 	sd-uhs-sdr25;
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1717,6 +1717,10 @@
 				pinctrl-single,bits = <0x0 0x1 0x7>;
 			};
 
+			esdhc0_cd_wp_pins: iic2-sdhc-pins {
+				pinctrl-single,bits = <0x0 0x6 0x7>;
+			};
+
 			i2c2_scl: i2c2-scl-pins {
 				pinctrl-single,bits = <0x0 0 (0x7 << 3)>;
 			};
@@ -1749,6 +1753,26 @@
 				pinctrl-single,bits = <0x0 (0x1 << 12) (0x7 << 12)>;
 			};
 
+			fspi_data74_pins: xspi1-data74-pins {
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 15)>;
+			};
+
+			fspi_data30_pins: xspi1-data30-pins {
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 18)>;
+			};
+
+			fspi_dqs_sck_cs10_pins: xspi1-base-pins {
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 21)>;
+			};
+
+			esdhc0_cmd_data30_clk_vsel_pins: sdhc1-base-sdhc-vsel-pins {
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 24)>;
+			};
+
+			gpio0_14_12_pins: sdhc1-dir-gpio-pins {
+				pinctrl-single,bits = <0x0 (0x1 << 27) (0x7 << 27)>;
+			};
+
 			i2c6_scl: i2c6-scl-pins {
 				pinctrl-single,bits = <0x4 0x2 0x7>;
 			};
--- a/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
@@ -223,6 +223,8 @@
 };
 
 &esdhc0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&esdhc0_cd_wp_pins>, <&esdhc0_cmd_data30_clk_vsel_pins>;
 	sd-uhs-sdr104;
 	sd-uhs-sdr50;
 	sd-uhs-sdr25;
--- a/arch/arm64/boot/dts/freescale/fsl-lx2162a-sr-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2162a-sr-som.dtsi
@@ -30,6 +30,8 @@
 };
 
 &fspi {
+	pinctrl-names = "default";
+	pinctrl-0 = <&fspi_data74_pins>, <&fspi_data30_pins>, <&fspi_dqs_sck_cs10_pins>;
 	status = "okay";
 
 	flash@0 {
@@ -80,3 +82,8 @@
 		reg = <0x6f>;
 	};
 };
+
+&pinmux_i2crv {
+	pinctrl-names = "default";
+	pinctrl-0 = <&gpio0_14_12_pins>;
+};


