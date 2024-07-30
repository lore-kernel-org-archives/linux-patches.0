Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9631E29A2;
	Tue, 30 Jul 2024 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355773; cv=none; b=BpfYi8CnQr9nEEdhbfThuOCnVX+YPF6WBi8m+YsCMvZTK/8tcITv8WCvsXqq7j/M0W7+AVPUSh+kETIHA1f19WoCfZLup51s9K2o9h0TaJTMalxJQTt/E85PEpLa3E+jima437Izhh9CRqfDb0nA8kYVCZ1Kvaopu8bDx7/sOhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355773; c=relaxed/simple;
	bh=D4AN8OKjHKEFnx1512l1V38ujZVvLXMGiHC8GLJrHZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Os74S1wAf87iegjUgE0orgf4z8RYxIRn1D2WpcQ92VUsM0qKXIxEXKuOmtjyDuFhlmqlEftpohiXhFNfbMCZzKbqXDhzp41JE7PisuPU7iAFHPOyeEcS23ChlpJUwLHjrXa9AoSkB5WpTuZDnaLzYO/YHF2JHiiSVbwJeCxlIaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0F/DYg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0F/DYg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CE8C32782;
	Tue, 30 Jul 2024 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355773;
	bh=D4AN8OKjHKEFnx1512l1V38ujZVvLXMGiHC8GLJrHZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0F/DYg8x1mF2RT0K4iiNfdhDdgrFfZfVV83fn8Xm/Ne3fM+z+O1S7yAD4DSR6j1C
	 xnXck3SUbjOIU1M+s0PStesZidpBqNLwt/lEkxrijz9my8cGddUR8JyWzsfOMbO5lH
	 yq1VI1LsqHXQyymV06a6kocrI81OJBdPMuPVcP6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/809] arm64: dts: qcom: sc7180-trogdor: Disable pwmleds node where unused
Date: Tue, 30 Jul 2024 17:39:23 +0200
Message-ID: <20240730151728.074369354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 99e94768c890c7522af020ff0e5e5317b2d046d9 ]

Currently the keyboard backlight is described in the common
sc7180-trogdor dtsi as an led node below a pwmleds node, and the led
node is set to disabled. Only the boards that have a keyboard backlight
enable it.

However, since the parent pwmleds node is still enabled everywhere, even
on boards that don't have keyboard backlight it is probed and fails,
resulting in an error:

  leds_pwm pwmleds: probe with driver leds_pwm failed with error -22

as well as a failure in the DT kselftest:

  not ok 45 /pwmleds

Fix this by controlling the status of the parent pwmleds node instead of
the child led, based on the presence of keyboard backlight. This is what
is done on sc7280 already.

While at it add a missing blank line before the child node to follow the
coding style.

Fixes: 7ec3e67307f8 ("arm64: dts: qcom: sc7180-trogdor: add initial trogdor and lazor dt")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240614-sc7180-pwmleds-probe-v1-1-e2c3f1b42a43@collabora.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-kb.dts   | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-lte.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-kb.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-lte.dts | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts   | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts   | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi              | 5 +++--
 9 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-kb.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-kb.dts
index 919bfaea6189c..340cb119d0a0d 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-kb.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-kb.dts
@@ -12,6 +12,6 @@ / {
 	compatible = "google,lazor-rev1-sku2", "google,lazor-rev2-sku2", "qcom,sc7180";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-lte.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-lte.dts
index eb20157f6af98..d45e60e3eb9eb 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-lte.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1-lte.dts
@@ -17,6 +17,6 @@ &ap_sar_sensor_i2c {
 	status = "okay";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-kb.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-kb.dts
index 45d34718a1bce..e906ce877b8cd 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-kb.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-kb.dts
@@ -18,6 +18,6 @@ / {
 	compatible = "google,lazor-sku2", "qcom,sc7180";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-lte.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-lte.dts
index 79028d0dd1b0c..4b9ee15b09f6b 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-lte.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r10-lte.dts
@@ -22,6 +22,6 @@ &ap_sar_sensor_i2c {
 	status = "okay";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts
index 3459b81c56283..a960553f39946 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts
@@ -21,6 +21,6 @@ / {
 		"qcom,sc7180";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts
index ff8f47da109d8..82bd9ed7e21a9 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts
@@ -25,6 +25,6 @@ &ap_sar_sensor_i2c {
 	status = "okay";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts
index faf527972977a..6278c1715d3fd 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts
@@ -18,6 +18,6 @@ / {
 	compatible = "google,lazor-rev9-sku2", "qcom,sc7180";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts
index d737fd0637fbc..0ec1697ae2c97 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts
@@ -22,6 +22,6 @@ &ap_sar_sensor_i2c {
 	status = "okay";
 };
 
-&keyboard_backlight {
+&pwmleds {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 8513be2971201..098a8b4c793e6 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -359,10 +359,11 @@ max98360a: audio-codec-0 {
 		#sound-dai-cells = <0>;
 	};
 
-	pwmleds {
+	pwmleds: pwmleds {
 		compatible = "pwm-leds";
+		status = "disabled";
+
 		keyboard_backlight: led-0 {
-			status = "disabled";
 			label = "cros_ec::kbd_backlight";
 			function = LED_FUNCTION_KBD_BACKLIGHT;
 			pwms = <&cros_ec_pwm 0>;
-- 
2.43.0



