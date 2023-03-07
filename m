Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C1BBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778B0C433EF;
	Tue,  7 Mar 2023 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212002;
	bh=M0MQry2eoLCSbLJHYRQsI8LrAhcseTEw6sNaxphHjds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WBcFbWOFEyfvDvIqv9so347UKRIRoNdr/VqKjJldbChK4tXuYm/FATfZH/6WHqGH
	 YKNluLkdbbabSm2rumf6oYfX37xaqfrrQxuCXCYvn4e4zyQHK01rvRAPviqbjXojet
	 E9DOd+1LwsUjJCZWt53pbnbaG3VLT2vdCSblezkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/885] arm64: dts: mediatek: mt8183: Fix systimer 13 MHz clock description
Date: Tue,  7 Mar 2023 17:49:09 +0100
Message-Id: <20230307170002.304979205@linuxfoundation.org>
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

[ Upstream commit ce8a06b5bac75ccce99c0cf91b96b767d64f28a7 ]

The systimer block derives its 13 MHz clock by dividing the main 26 MHz
oscillator clock by 2 internally, not through the TOPCKGEN clock
controller.

On the MT8183 this divider is set either by power-on-reset or by the
bootloader. The bootloader may then make the divider unconfigurable to,
but can be read out by, the operating system.

Making the systimer block take the 26 MHz clock directly requires
changing the implementations. As an ABI compatible fix, change the
input clock of the systimer block a fixed factor divide-by-2 clock
that takes the 26 MHz oscillator as its input.

Fixes: 5bc8e2875ffb ("arm64: dts: mt8183: add systimer0 device node")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221201084229.3464449-2-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 402136bfd5350..268a1f28af8ce 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -585,6 +585,15 @@ psci {
 		method = "smc";
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
 	clk26m: oscillator {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -968,8 +977,7 @@ systimer: timer@10017000 {
 				     "mediatek,mt6765-timer";
 			reg = <0 0x10017000 0 0x1000>;
 			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&topckgen CLK_TOP_CLK13M>;
-			clock-names = "clk13m";
+			clocks = <&clk13m>;
 		};
 
 		iommu: iommu@10205000 {
-- 
2.39.2



