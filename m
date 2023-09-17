Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA37B7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B0C433C7;
	Sun, 17 Sep 2023 20:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981978;
	bh=1EMf7Qomu9t4ueLqMPO2Ft6BKmRVpN0i64ntiAdEPws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpyUzHLUNqnCzJvcyTp6Qu0UfHgK4zG8NkHFhWBL4GKJAig9RenzO+nbao72UKDsk
	 AL8EUua8c5lrUUNY8MIKQn99tpIi2uZnl2/5AQJLCGNH8TqQN5yHRXJg9ZXAsDX3Ki
	 Pg0s/3Ngj9if2L0Z6PLiRZj4403Txc7R48d/Sqbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/511] arm64: dts: qcom: sm8250-edo: Rectify gpio-keys
Date: Sun, 17 Sep 2023 21:09:21 +0200
Message-ID: <20230917191117.099624850@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit a422c6a91a667b309ca1a6c08b30dbfcf7d4e866 ]

Set up the corresponding GPIOs properly and add the leftover hardware
buttons to mark this piece of the puzzle complete.

Fixes: 46e14907c716 ("arm64: dts: qcom: sm8250-edo: Add hardware keys")
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230614-topic-edo_pinsgpiopmic-v2-4-6f90bba54c53@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/sm8250-sony-xperia-edo-pdx206.dts    | 10 ++++
 .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi | 54 ++++++++++++++++---
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo-pdx206.dts b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo-pdx206.dts
index 9b6228f7010b5..b0f4ecc911144 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo-pdx206.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo-pdx206.dts
@@ -19,6 +19,8 @@ &framebuffer {
 };
 
 &gpio_keys {
+	pinctrl-0 = <&focus_n &snapshot_n &vol_down_n &g_assist_n>;
+
 	g-assist-key {
 		label = "Google Assistant Key";
 		linux,code = <KEY_LEFTMETA>;
@@ -47,6 +49,14 @@ &pm8150_gpios {
 			  "SP_ARI_PWR_ALARM",
 			  "NC",
 			  "NC"; /* GPIO_10 */
+
+	g_assist_n: g-assist-n-state {
+		pins = "gpio6";
+		function = "normal";
+		power-source = <1>;
+		bias-pull-up;
+		input-enable;
+	};
 };
 
 &pm8150b_gpios {
diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index b093f2a02a9cb..60c62fbc2650d 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -51,12 +51,26 @@ framebuffer: framebuffer@9c000000 {
 	gpio_keys: gpio-keys {
 		compatible = "gpio-keys";
 
-		/*
-		 * Camera focus (light press) and camera snapshot (full press)
-		 * seem not to work properly.. Adding the former one stalls the CPU
-		 * and the latter kills the volume down key for whatever reason. In any
-		 * case, they are both on &pm8150b_gpios: camera focus(2), camera snapshot(1).
-		 */
+		pinctrl-0 = <&focus_n &snapshot_n &vol_down_n>;
+		pinctrl-names = "default";
+
+		key-camera-focus {
+			label = "Camera Focus";
+			linux,code = <KEY_CAMERA_FOCUS>;
+			gpios = <&pm8150b_gpios 2 GPIO_ACTIVE_LOW>;
+			debounce-interval = <15>;
+			linux,can-disable;
+			gpio-key,wakeup;
+		};
+
+		key-camera-snapshot {
+			label = "Camera Snapshot";
+			linux,code = <KEY_CAMERA>;
+			gpios = <&pm8150b_gpios 1 GPIO_ACTIVE_LOW>;
+			debounce-interval = <15>;
+			linux,can-disable;
+			gpio-key,wakeup;
+		};
 
 		vol-down {
 			label = "Volume Down";
@@ -518,6 +532,34 @@ &pcie2_phy {
 	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
+&pm8150_gpios {
+	vol_down_n: vol-down-n-state {
+		pins = "gpio1";
+		function = "normal";
+		power-source = <0>;
+		bias-pull-up;
+		input-enable;
+	};
+};
+
+&pm8150b_gpios {
+	snapshot_n: snapshot-n-state {
+		pins = "gpio1";
+		function = "normal";
+		power-source = <0>;
+		bias-pull-up;
+		input-enable;
+	};
+
+	focus_n: focus-n-state {
+		pins = "gpio2";
+		function = "normal";
+		power-source = <0>;
+		bias-pull-up;
+		input-enable;
+	};
+};
+
 &pon_pwrkey {
 	status = "okay";
 };
-- 
2.40.1



