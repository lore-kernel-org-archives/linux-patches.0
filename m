Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C049DBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C573C433EF;
	Tue,  7 Mar 2023 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208823;
	bh=WrR+gbN5Hy5FqweM/zeGgTr3GC8xajAinv/6ksQJyp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qsl8xwx11xGDZHlv94uu1hFDl/kKH6YREES92AcD7E0nxprn/h2xEQrzzkiJWgCWF
	 bx1nQWk/A+EJiPdK1jsnRLaWlyHSXQ6eVoNPOXsuMa2v/hsxmhKYkZkM0sZEkfGD59
	 48rwyNWqQ7S12qTq2VZVXz3eehXFDEugSGuXZ/H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0021/1001] arm64: dts: qcom: sm8350-sagami: Rectify GPIO keys
Date: Tue,  7 Mar 2023 17:46:33 +0100
Message-Id: <20230307170023.076105959@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit dcc7cd5c46ca5e7bb8e4910ed8259597439c7246 ]

With enough pins set properly, the hardware buttons now also work
like a charm.

Fixes: c2721b0c23d9 ("arm64: dts: qcom: Add support for Xperia 1 III / 5 III")
Tested-by: Marijn Suijten <marijn.suijten@somainline.org> # On Xperia 1 III and Xperia 5 III
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221229102712.983306-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/sm8350-sony-xperia-sagami.dtsi   | 66 ++++++++++++++++++-
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
index 41c4101ec8f08..8df6ccbedfae7 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
@@ -49,7 +49,35 @@ framebuffer: framebuffer@e1000000 {
 	gpio-keys {
 		compatible = "gpio-keys";
 
-		/* For reasons still unknown, GAssist key and Camera Focus/Shutter don't work.. */
+		pinctrl-names = "default";
+		pinctrl-0 = <&focus_n &snapshot_n &vol_down_n &g_assist_n>;
+
+		key-camera-focus {
+			label = "Camera Focus";
+			linux,code = <KEY_CAMERA_FOCUS>;
+			gpios = <&pm8350b_gpios 8 GPIO_ACTIVE_LOW>;
+			debounce-interval = <15>;
+			linux,can-disable;
+			wakeup-source;
+		};
+
+		key-camera-snapshot {
+			label = "Camera Snapshot";
+			linux,code = <KEY_CAMERA>;
+			gpios = <&pm8350b_gpios 5 GPIO_ACTIVE_LOW>;
+			debounce-interval = <15>;
+			linux,can-disable;
+			wakeup-source;
+		};
+
+		key-google-assist {
+			label = "Google Assistant Key";
+			gpios = <&pm8350_gpios 9 GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_LEFTMETA>;
+			debounce-interval = <15>;
+			linux,can-disable;
+			wakeup-source;
+		};
 
 		key-vol-down {
 			label = "Volume Down";
@@ -57,7 +85,7 @@ key-vol-down {
 			gpios = <&pmk8350_gpios 3 GPIO_ACTIVE_LOW>;
 			debounce-interval = <15>;
 			linux,can-disable;
-			gpio-key,wakeup;
+			wakeup-source;
 		};
 	};
 
@@ -545,6 +573,32 @@ &pm8350_gpios {
 			  "NC",
 			  "G_ASSIST_N",
 			  "PM8350_OPTION"; /* GPIO_10 */
+
+	g_assist_n: g-assist-n-state {
+		pins = "gpio9";
+		function = "normal";
+		power-source = <1>;
+		bias-pull-up;
+		input-enable;
+	};
+};
+
+&pm8350b_gpios {
+	snapshot_n: snapshot-n-state {
+		pins = "gpio5";
+		function = "normal";
+		power-source = <0>;
+		bias-pull-up;
+		input-enable;
+	};
+
+	focus_n: focus-n-state {
+		pins = "gpio8";
+		function = "normal";
+		power-source = <0>;
+		input-enable;
+		bias-pull-up;
+	};
 };
 
 &pmk8350_gpios {
@@ -552,6 +606,14 @@ &pmk8350_gpios {
 			  "NC",
 			  "VOL_DOWN_N",
 			  "PMK8350_OPTION";
+
+	vol_down_n: vol-down-n-state {
+		pins = "gpio3";
+		function = "normal";
+		power-source = <0>;
+		bias-pull-up;
+		input-enable;
+	};
 };
 
 &pmk8350_rtc {
-- 
2.39.2



