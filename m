Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65972BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD00FC433EF;
	Tue,  7 Mar 2023 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212009;
	bh=yhoD0hcAEueAYHZg8WavMG3NNMxDtL11rfS33aaTbgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgkZGJdIgi1u2XLftKR/IqEGXhHt1gkCw7GVsAKF0654vzFMeyWkVLWBYPunvDUJs
	 TqKX8j8pQrRvh3Xg9hIkRp4Ipck5yGaNcAmNFGFAZAn27TFv0qjZhSVjHTUsv5LSmT
	 12yb+u2Q6U4PP52EYARAcBFqQkW2TQlDgva3rhfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/885] arm64: dts: mediatek: mt8195: Fix systimer 13 MHz clock description
Date: Tue,  7 Mar 2023 17:49:11 +0100
Message-Id: <20230307170002.395599684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 0f1c806b65d136a5fe0b88adad5ff1cb451fc401 ]

The systimer block derives its 13 MHz clock by dividing the main 26 MHz
oscillator clock by 2 internally, not through the TOPCKGEN clock
controller.

On the MT8195 this divider is set either by power-on-reset or by the
bootloader. The bootloader may then make the divider unconfigurable to,
but can be read out by, the operating system.

Making the systimer block take the 26 MHz clock directly requires
changing the implementations. As an ABI compatible fix, change the
input clock of the systimer block a fixed factor divide-by-2 clock
that takes the 26 MHz oscillator as its input.

Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221201084229.3464449-4-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 350d6c2ea622a..6dad8aaee436c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -244,6 +244,15 @@ sound: mt8195-sound {
 		status = "disabled";
 	};
 
+	clk13m: fixed-factor-clock-13m {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&clk26m>;
+		clock-div = <2>;
+		clock-mult = <1>;
+		clock-output-names = "clk13m";
+	};
+
 	clk26m: oscillator-26m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -701,7 +710,7 @@ systimer: timer@10017000 {
 				     "mediatek,mt6765-timer";
 			reg = <0 0x10017000 0 0x1000>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
-			clocks = <&topckgen CLK_TOP_CLK26M_D2>;
+			clocks = <&clk13m>;
 		};
 
 		pwrap: pwrap@10024000 {
-- 
2.39.2



