Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857171F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7EDC433C8;
	Fri, 21 Jul 2023 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965791;
	bh=7/UNODC6QqytK2XtO1GR5CwVgbeQ7QWuiIlkWDJvCuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmIAfsETKZJUUA8eFvCaYTKMMOR7EW6Puut+LetKNx4ARUniLC4dUNg3T2NMxC8en
	 CDcQazlwaBAPKxACDaj85nQQTUEXJ2G4CfPtTVBHLlBpu/314eOntMjTuEfdpcefu8
	 qRHCW9+3VZedGdtzDjpQeXrK3TaeLpAn7konwUEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/532] arm64: dts: microchip: sparx5: do not use PSCI on reference boards
Date: Fri, 21 Jul 2023 18:00:20 +0200
Message-ID: <20230721160620.810249972@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 70be83708c925b3f72c508e4756e48ad2330c830 ]

PSCI is not implemented on SparX-5 at all, there is no ATF and U-boot that
is shipped does not implement it as well.

I have tried flashing the latest BSP 2022.12 U-boot which did not work.
After contacting Microchip, they confirmed that there is no ATF for the
SoC nor PSCI implementation which is unfortunate in 2023.

So, disable PSCI as otherwise kernel crashes as soon as it tries probing
PSCI with, and the crash is only visible if earlycon is used.

Since PSCI is not implemented, switch core bringup to use spin-tables
which are implemented in the vendor U-boot and actually work.

Tested on PCB134 with eMMC (VSC5640EV).

Fixes: 6694aee00a4b ("arm64: dts: sparx5: Add basic cpu support")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Link: https://lore.kernel.org/r/20230221105039.316819-1-robert.marko@sartura.hr
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi            |  2 +-
 arch/arm64/boot/dts/microchip/sparx5_pcb_common.dtsi | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index 787ebcec121d6..a6405059636c3 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -61,7 +61,7 @@ arm-pmu {
 		interrupt-affinity = <&cpu0>, <&cpu1>;
 	};
 
-	psci {
+	psci: psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
 	};
diff --git a/arch/arm64/boot/dts/microchip/sparx5_pcb_common.dtsi b/arch/arm64/boot/dts/microchip/sparx5_pcb_common.dtsi
index 9d1a082de3e29..32bb76b3202a0 100644
--- a/arch/arm64/boot/dts/microchip/sparx5_pcb_common.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5_pcb_common.dtsi
@@ -6,6 +6,18 @@
 /dts-v1/;
 #include "sparx5.dtsi"
 
+&psci {
+	status = "disabled";
+};
+
+&cpu0 {
+	enable-method = "spin-table";
+};
+
+&cpu1 {
+	enable-method = "spin-table";
+};
+
 &uart0 {
 	status = "okay";
 };
-- 
2.39.2



