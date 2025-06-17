Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0FA2EE298;
	Tue, 17 Jun 2025 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177885; cv=none; b=Q+sea/6he+39p6taWWyaxgk1l6JbEsKaNq2TZqzEIG7UYphJT2QBGeTPXYFrPvp9cFq0w/KbPUmHjIZZgCWPKihDFlWxxLa5SsvisnlkXp8ghekF+OcnwzGNHJkkGqI3JKMjnYV/DoPdfIiV2y2U16pUKuO5dPkr4stYYyYCqyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177885; c=relaxed/simple;
	bh=CO6stB7WdKHyLODPZLj2Ocv07tlYvwMmevsOiMAAyKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfXeTBe01Gw8V8a4iXeEBKKTraY0G3s4aE5J2CxZvrkzkc6x47Qy8EYE+aoB6nkpsEOh8DAQyyl0qDF9HLQC+v9T837PGzqv4ubRV/ghuk6RlfTaeOI2GTv0y/3BzAvsxzOp8GnUexrCz6sa4NGj4sT/uq9XB9ye4ARJho53iSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbaKvuV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbaKvuV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BCDC4CEE3;
	Tue, 17 Jun 2025 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177884;
	bh=CO6stB7WdKHyLODPZLj2Ocv07tlYvwMmevsOiMAAyKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbaKvuV8K8L/3Ly0Zv0dXyyPIZpgxFMoJfggqBkpHmQFdo67LgKtmtvXjEpk240Hr
	 iq5OwTTxdDtmRwRh7TSBek283u4qa5CWlHfBNDxIB06gFh9g7SNHJWIUuW99ZG0Y4S
	 2/CsCnrFa9T21kUpy20h4ef9dDNnZTHyP//OFkVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/512] arm64: dts: qcom: x1e80100: Add GPU cooling
Date: Tue, 17 Jun 2025 17:26:16 +0200
Message-ID: <20250617152436.190969680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 5ba21fa11f473c9827f378ace8c9f983de9e0287 ]

Unlike the CPU, the GPU does not throttle its speed automatically when it
reaches high temperatures. With certain high GPU loads it is possible to
reach the critical hardware shutdown temperature of 120°C, endangering the
hardware and making it impossible to run certain applications.

Set up GPU cooling similar to the ACPI tables, by throttling the GPU speed
when reaching 95°C and polling every 200ms.

Cc: stable@vger.kernel.org
Fixes: 721e38301b79 ("arm64: dts: qcom: x1e80100: Add gpu support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250219-x1e80100-thermal-fixes-v1-3-d110e44ac3f9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 169 +++++++++++++------------
 1 file changed, 89 insertions(+), 80 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index edfea03366b46..5082ecb32089b 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -20,6 +20,7 @@
 #include <dt-bindings/soc/qcom,gpr.h>
 #include <dt-bindings/soc/qcom,rpmh-rsc.h>
 #include <dt-bindings/sound/qcom,q6dsp-lpass-ports.h>
+#include <dt-bindings/thermal/thermal.h>
 
 / {
 	interrupt-parent = <&intc>;
@@ -7316,24 +7317,25 @@ nsp3-critical {
 		};
 
 		gpuss-0-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 5>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss0_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss0_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7342,24 +7344,25 @@ trip-point2 {
 		};
 
 		gpuss-1-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 6>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss1_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss1_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7368,24 +7371,25 @@ trip-point2 {
 		};
 
 		gpuss-2-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 7>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss2_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss2_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7394,24 +7398,25 @@ trip-point2 {
 		};
 
 		gpuss-3-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 8>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss3_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss3_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7420,24 +7425,25 @@ trip-point2 {
 		};
 
 		gpuss-4-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 9>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss4_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss4_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7446,24 +7452,25 @@ trip-point2 {
 		};
 
 		gpuss-5-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 10>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss5_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss5_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7472,24 +7479,25 @@ trip-point2 {
 		};
 
 		gpuss-6-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 11>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss6_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss6_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
@@ -7498,24 +7506,25 @@ trip-point2 {
 		};
 
 		gpuss-7-thermal {
-			polling-delay-passive = <10>;
+			polling-delay-passive = <200>;
 
 			thermal-sensors = <&tsens3 12>;
 
-			trips {
-				trip-point0 {
-					temperature = <85000>;
-					hysteresis = <1000>;
-					type = "passive";
+			cooling-maps {
+				map0 {
+					trip = <&gpuss7_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
+			};
 
-				trip-point1 {
-					temperature = <90000>;
+			trips {
+				gpuss7_alert0: trip-point0 {
+					temperature = <95000>;
 					hysteresis = <1000>;
-					type = "hot";
+					type = "passive";
 				};
 
-				trip-point2 {
+				gpu-critical {
 					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
-- 
2.39.5



