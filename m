Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D5114A99
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E32C433C8;
	Mon, 26 Jun 2023 18:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804356;
	bh=ZYGApEylCF+SC6ULFh+ZVTcwL8rOxJfB8prOZi2Q9/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyz0uODPD+HmMQcj17LWJz1SqTv4r5STBqQf/A3RKdmPJdbufEnbCtZ+WEMgKGMpt
	 1kKtYcnkk3XPt+TKb/SF8PwhhGAkga5U03vy7l7eWDdwOaIV0lRDuNIVxYy54JPjfq
	 CEESjkQqxB0MfIcEIeVYNKVie+tDaTjsDKFKEfts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <frattaroli.nicolas@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/170] arm64: dts: rockchip: fix nEXTRST on SOQuartz
Date: Mon, 26 Jun 2023 20:11:37 +0200
Message-ID: <20230626180806.305285237@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>

[ Upstream commit cf9ae4a0077496e8224d68fc88e3df13dd7e5f37 ]

In pre-production prototypes (of which I only know one person
having one, Peter Geis), GPIO0 pin A5 was tied to the SDMMC
power enable pin on the CM4 connector. On all production models,
this is not the case; instead, this pin is used for the nEXTRST
signal, and the SDMMC power enable pin is always pulled high.

Since everyone currently using the SOQuartz device trees will
want this change, it is made to the tree without splitting the
trees into two separate ones of which users will then inevitably
choose the wrong one.

This fixes USB and PCIe on a wide variety of CM4IO-compatible
boards which use the nEXTRST signal.

Fixes: 5859b5a9c3ac ("arm64: dts: rockchip: add SoQuartz CM4IO dts")
Signed-off-by: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
Link: https://lore.kernel.org/r/20230421152610.21688-1-frattaroli.nicolas@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3566-soquartz-cm4.dts | 18 +++++++-----
 .../boot/dts/rockchip/rk3566-soquartz.dtsi    | 29 +++++++++----------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-soquartz-cm4.dts b/arch/arm64/boot/dts/rockchip/rk3566-soquartz-cm4.dts
index e00568a6be5cc..6ba562b922e6c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-soquartz-cm4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-soquartz-cm4.dts
@@ -28,6 +28,16 @@
 		regulator-max-microvolt = <5000000>;
 		vin-supply = <&vcc12v_dcin>;
 	};
+
+	vcc_sd_pwr: vcc-sd-pwr-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "vcc_sd_pwr";
+		regulator-always-on;
+		regulator-boot-on;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		vin-supply = <&vcc3v3_sys>;
+	};
 };
 
 &gmac1 {
@@ -119,13 +129,7 @@
 };
 
 &sdmmc0 {
-	vmmc-supply = <&sdmmc_pwr>;
-	status = "okay";
-};
-
-&sdmmc_pwr {
-	regulator-min-microvolt = <3300000>;
-	regulator-max-microvolt = <3300000>;
+	vmmc-supply = <&vcc_sd_pwr>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
index 4ceb9a979f6ad..ba56ca2e66c8d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
@@ -92,16 +92,6 @@
 		regulator-max-microvolt = <3300000>;
 		vin-supply = <&vcc5v0_sys>;
 	};
-
-	sdmmc_pwr: sdmmc-pwr-regulator {
-		compatible = "regulator-fixed";
-		enable-active-high;
-		gpio = <&gpio0 RK_PA5 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sdmmc_pwr_h>;
-		regulator-name = "sdmmc_pwr";
-		status = "disabled";
-	};
 };
 
 &cpu0 {
@@ -143,6 +133,19 @@
 	status = "disabled";
 };
 
+&gpio0 {
+	nextrst-hog {
+		gpio-hog;
+		/*
+		 * GPIO_ACTIVE_LOW + output-low here means that the pin is set
+		 * to high, because output-low decides the value pre-inversion.
+		 */
+		gpios = <RK_PA5 GPIO_ACTIVE_LOW>;
+		line-name = "nEXTRST";
+		output-low;
+	};
+};
+
 &gpu {
 	mali-supply = <&vdd_gpu>;
 	status = "okay";
@@ -485,12 +488,6 @@
 			rockchip,pins = <2 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
-
-	sdmmc-pwr {
-		sdmmc_pwr_h: sdmmc-pwr-h {
-			rockchip,pins = <0 RK_PA5 RK_FUNC_GPIO &pcfg_pull_none>;
-		};
-	};
 };
 
 &pmu_io_domains {
-- 
2.39.2



