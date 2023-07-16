Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB5A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61FCC433C8;
	Sun, 16 Jul 2023 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538172;
	bh=KtVhGJhDVd3HVCDUKdnIWJHxpAUglmwaN93GfO5MUrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szkY0PLxfVdrBIGaqppc59hHIC/Q6U5+qDODtB9Rzgq9xhshNq6MdbjzGkNLMuPMY
	 adrPACAMUkCPI8Kz5I+dsqUm1yim17tu0IiQurKTTJTPxZU0VknmNi6pF5OaYqNY4a
	 AIgwE36WCltB7BhQF7Z9uHvEjU3RJ5XpKq5cjRHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 357/800] ARM: dts: stm32: Fix audio routing on STM32MP15xx DHCOM PDK2
Date: Sun, 16 Jul 2023 21:43:30 +0200
Message-ID: <20230716194957.370752397@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit e3f2778b1b6ced649bffdc7cbb05b80bb92f2108 ]

The audio routing flow is not correct, the flow should be from source
(second element in the pair) to sink (first element in the pair). The
flow now is from "HP_OUT" to "Playback", where "Playback" is source
and "HP_OUT" is sink, i.e. the direction is swapped and there is no
direct link between the two either.

Fill in the correct routing, where "HP_OUT" supplies the "Headphone Jack",
"Line In Jack" supplies "LINE_IN" input, "Microphone Jack" supplies "MIC_IN"
input and "Mic Bias" supplies "Microphone Jack".

Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 4709677151aac..46b87a27d8b37 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -137,10 +137,13 @@ reg_panel_supply: regulator-panel-supply {
 
 	sound {
 		compatible = "audio-graph-card";
-		routing =
-			"MIC_IN", "Capture",
-			"Capture", "Mic Bias",
-			"Playback", "HP_OUT";
+		widgets = "Headphone", "Headphone Jack",
+			  "Line", "Line In Jack",
+			  "Microphone", "Microphone Jack";
+		routing = "Headphone Jack", "HP_OUT",
+			  "LINE_IN", "Line In Jack",
+			  "MIC_IN", "Microphone Jack",
+			  "Microphone Jack", "Mic Bias";
 		dais = <&sai2a_port &sai2b_port>;
 		status = "okay";
 	};
-- 
2.39.2



