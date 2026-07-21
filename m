Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2E5403B06;
	Tue, 21 Jul 2026 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655714; cv=none; b=l86pqZ3/PCCyyq9c1NAAy3rat+Yd8ZsJXVxdHrew4zjA7mojIehdm+MtuDegUnguuAESNldr+49odYZGXMCcqwL0iN04SzAkXmILTwhQ64H7h31arAXyhSOOWyOcA5jdgE9aK7AbOTd1NjNYsbvBD1qYbF1t2Ivdok065uhCWZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655714; c=relaxed/simple;
	bh=7gNp7ZI25QHJbylzZ931SDYGUrZWoR6mKZNy9z1x3aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gI+A3Wbl3twuL5u+FJW1g2KBLkiDwtW/Nx/s2VVzbMC7boDCxDvO56MjdqWnU87Wha+WXQUhIQlmS8Vy4jjA+xV9R/GdnFD0ptd/JIsUhIjiCB9QHCVkJHCF9VDEOQ0yTPl8G8nSLiw7HD8Ecv6gYg0Y8DSof/u/hJsxDX/m3+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKiPjZNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKiPjZNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023451F00A3A;
	Tue, 21 Jul 2026 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655712;
	bh=xgE+nyUpQIz+300OvioEAvV19Qq5k9LktFl3hlcLdmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKiPjZNX3IwJOv1NGfz8XJZ1CnCtP3tkO7xieoDOgFwx36qkfokZ/iYUzgXhq+i9n
	 auWYwRWxvtWeFwxf3/o6UkcM3yintEyNJYZH1497SvyL9A2wCz/uIkQ7SYjeDGOlC+
	 oq8QsJF0AxiagNAFjbn0o3jZoaaxb38EH1cdQbEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0114/1611] Revert "arm64: dts: imx8mm-kontron: Add support for reading SD_VSEL signal"
Date: Tue, 21 Jul 2026 17:03:50 +0200
Message-ID: <20260721152517.418366435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit aa907ee010e396c0c0d31d60495ace6e531ceec9 ]

This reverts commit 8472751c4d96b558d60d0f6aede6b24b64bcb3c9.

The board uses SDHC VSELECT to automatically switch between 1.8v and
3.3v. It does not use GPIO to control the PMIC SD_VSEL signal.
The original commit intends to read back SD_VSEL value from GPIO,
but it is wrong. When MUX is configured as SDHC VSELECT, it is
impossible to read back the value from GPIO controller. Setting SION
could only enable the input path for the mux function. It could not
redirect the input to GPIO.

And value "0x40000d0" is wrong, SION is BIT30, not BIT26.

Fixes: 8472751c4d96b ("arm64: dts: imx8mm-kontron: Add support for reading SD_VSEL signal")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-bl.dts    | 10 +++-------
 .../arm64/boot/dts/freescale/imx8mm-kontron-osm-s.dtsi |  7 +++----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-bl.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-bl.dts
index e756fe5db56b6a..dd59af0ebaae55 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-bl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-bl.dts
@@ -254,10 +254,6 @@ &pwm2 {
 	status = "okay";
 };
 
-&reg_nvcc_sd {
-	sd-vsel-gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
-};
-
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
@@ -466,7 +462,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d0
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d0
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d0
 			MX8MM_IOMUXC_SD2_CD_B_GPIO2_IO12		0x19
-			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x40000d0
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0xd0
 		>;
 	};
 
@@ -479,7 +475,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d4
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d4
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4
 			MX8MM_IOMUXC_SD2_CD_B_GPIO2_IO12		0x19
-			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x40000d0
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0xd0
 		>;
 	};
 
@@ -492,7 +488,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d6
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d6
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d6
 			MX8MM_IOMUXC_SD2_CD_B_GPIO2_IO12		0x19
-			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x40000d0
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0xd0
 		>;
 	};
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-osm-s.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-osm-s.dtsi
index 96987910609f1b..4fb13d8ecfd45a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-osm-s.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-osm-s.dtsi
@@ -342,7 +342,6 @@ reg_nvcc_sd: LDO5 {
 				regulator-name = "NVCC_SD (LDO5)";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
-				sd-vsel-gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
 			};
 		};
 	};
@@ -795,7 +794,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d0 /* SDIO_A_D1 */
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d0 /* SDIO_A_D2 */
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d0 /* SDIO_A_D3 */
 			MX8MM_IOMUXC_SD2_WP_USDHC2_WP			0x400000d6 /* SDIO_A_WP */
-			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x40000090
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x90
 		>;
 	};
 
@@ -808,7 +807,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d4 /* SDIO_A_D1 */
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d4 /* SDIO_A_D2 */
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4 /* SDIO_A_D3 */
 			MX8MM_IOMUXC_SD2_WP_USDHC2_WP			0x400000d6 /* SDIO_A_WP */
-			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x40000090
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x90
 		>;
 	};
 
@@ -821,7 +820,7 @@ MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d6 /* SDIO_A_D1 */
 			MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d6 /* SDIO_A_D2 */
 			MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d6 /* SDIO_A_D3 */
 			MX8MM_IOMUXC_SD2_WP_USDHC2_WP			0x400000d6 /* SDIO_A_WP */
-			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x40000090
+			MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x90
 		>;
 	};
 
-- 
2.53.0



