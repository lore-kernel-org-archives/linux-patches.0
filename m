Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C36258EF9;
	Wed, 25 Feb 2026 01:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983019; cv=none; b=E2pvIBF3CUE62CdHktjoW7TYGFE9+O1A0jkoboZxqV+vpCwBkX4kPSvx0m98TbJZu/cVaBsl1CVjL1s8HC3aBmEVEQpV2Zn/grJINs0bV1d/JsBgSKA0ewohsN19xNpbH91i+1GDMN7aOOSDHDH/8WV2ElAqkBtvFkTwHSAiC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983019; c=relaxed/simple;
	bh=VDnFCDO4jhRWR7lvn2Wed7OzfRiPDw2Mrr4TCWgrRcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE0jFSXU6VkJLNGjA/Y/2hGO+mtaNGU9yPCPmtoka9fDsB9C3JfwALjSmKMg6L9QTRNuslRIz/lyB8Lli0H3BR1yVUW1LX4UGPT7C4/EZ72vSeiNtezts/L7N5M2lR7otcHoXnPXmGZpYyGo8uvN+oE+Gzn5TiAAEdLA/gU3+XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BS8TgRMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BS8TgRMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB67C2BC86;
	Wed, 25 Feb 2026 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983018;
	bh=VDnFCDO4jhRWR7lvn2Wed7OzfRiPDw2Mrr4TCWgrRcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS8TgRMNy8bc0mmQuWvpPd7ZABLdz54jjKZhSSYpGfFFjlwSYG+Vj6xIM2WvfFxBX
	 NlUrmUg3zhq2OHLnOGNukIZanBZ59uGaIn3Y5/2xKb6lyLeJV8/WFabJm+x+EK65Nx
	 tXFXEgSC2TewPeTReq0ZwYottsL5oZFLfI0G9FNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 186/781] arm64: dts: imx95: Use GPU_CGC as core clock for GPU
Date: Tue, 24 Feb 2026 17:14:55 -0800
Message-ID: <20260225012404.209174240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit fc61fdfdc4dd03fa5cea784e1969ed3df049c6c8 ]

The i.MX95 imx-sm introduced new GPU_CGC clock since imx-sm commit
ca5e078833fa ("SM-128: Add clock management via CCM LPCG direct control")
which are downstream clock of GPU clock. These new GPU_CGC clock
gate the existing GPU clock. Currently, without clk_ignore_unused
on kernel command line, those new GPU_CGC clock are unused and the
kernel will disable them. This has no impact on i.MX95 A0/A1, but
does prevent GPU register access from working at all on i.MX95 B0.
The GPU_CGC clock are present on both i.MX95 A0/A1/B0, therefore
update the DT such, that the GPU core clock are the GPU_CGC clock.
When the panthor driver enables the GPU core clock, it enables both
the GPU_CGC as well as its parent GPU clock.

Fixes: 67934f248e64 ("arm64: dts: imx95: Describe Mali G310 GPU")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-clock.h | 1 +
 arch/arm64/boot/dts/freescale/imx95.dtsi    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-clock.h b/arch/arm64/boot/dts/freescale/imx95-clock.h
index e1f91203e7947..22311612e4403 100644
--- a/arch/arm64/boot/dts/freescale/imx95-clock.h
+++ b/arch/arm64/boot/dts/freescale/imx95-clock.h
@@ -183,5 +183,6 @@
 #define IMX95_CLK_SEL_A55P                 (IMX95_CCM_NUM_CLK_SRC + 123 + 7)
 #define IMX95_CLK_SEL_DRAM                 (IMX95_CCM_NUM_CLK_SRC + 123 + 8)
 #define IMX95_CLK_SEL_TEMPSENSE            (IMX95_CCM_NUM_CLK_SRC + 123 + 9)
+#define IMX95_CLK_GPU_CGC                  (IMX95_CCM_NUM_CLK_SRC + 123 + 10)
 
 #endif	/* __CLOCK_IMX95_H */
diff --git a/arch/arm64/boot/dts/freescale/imx95.dtsi b/arch/arm64/boot/dts/freescale/imx95.dtsi
index a4d8548175594..55e2da094c889 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -2164,7 +2164,7 @@ netc_emdio: mdio@0,0 {
 		gpu: gpu@4d900000 {
 			compatible = "nxp,imx95-mali", "arm,mali-valhall-csf";
 			reg = <0 0x4d900000 0 0x480000>;
-			clocks = <&scmi_clk IMX95_CLK_GPU>, <&scmi_clk IMX95_CLK_GPUAPB>;
+			clocks = <&scmi_clk IMX95_CLK_GPU_CGC>, <&scmi_clk IMX95_CLK_GPUAPB>;
 			clock-names = "core", "coregroup";
 			interrupts = <GIC_SPI 289 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 290 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.51.0



