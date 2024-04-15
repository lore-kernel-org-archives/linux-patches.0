Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF8E78C76;
	Mon, 15 Apr 2024 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191465; cv=none; b=C98IC+2AAbCxu/DTna7ssUu9WtkY12M1riHXkl5weSs/Rd6y+1RdQXuMRMGq6dZxpwcImh3kI8Hu4M5X5ILDJ0XNB6ugyhCovgCchvZUnWcUdbre5rXbiXCsRiPd+nulmiXNSiC/nbK/K+BgOFPpk5dCAzF/CwgkHh1LTUcIlOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191465; c=relaxed/simple;
	bh=h+vGp156q2RtwoputzFVL7FRuGWWZY3HQs1FEkZgB0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBsDusfznwZZpACEbPMLmJF7XmQH/MRDKNjjNILnC/WhpDVrcJiTrP8Pj3x8nk6l6Wg9eYLfqoef1RoMDwmPF0KOnClwl4/nJjl+YZrZHq8K+HVYF+xRJ10iP15A3pSJcrcRew+kMyY2nZE2m+d8jy6BE8iJbHdmXumT82guoIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvEuvVGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvEuvVGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5C5C113CC;
	Mon, 15 Apr 2024 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191465;
	bh=h+vGp156q2RtwoputzFVL7FRuGWWZY3HQs1FEkZgB0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvEuvVGA/Uhb/u8ayApM4WA5RFpKzgMU4aryJBFN1rXgdWt2H75T2tG+LPNMm2XPZ
	 +pP9Gth430SKaQ8qVCn5E9Xk1kVIceZRoIz7EDqCxHqNnsTxLhvPjGASPB4Jm3hR3k
	 rXyzMLXcgXMh/TeTGlENRLkCmY6kOW6Dgf3tk1Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 134/172] arm64: dts: imx8-ss-dma: fix adc lpcg indices
Date: Mon, 15 Apr 2024 16:20:33 +0200
Message-ID: <20240415142004.447964613@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 81975080f14167610976e968e8016e92d836266f upstream.

adc0_lpcg: clock-controller@5ac80000 {
	...						    Col1   Col2
	clocks = <&clk IMX_SC_R_ADC_0 IMX_SC_PM_CLK_PER>, // 0      0
		 <&dma_ipg_clk>;			  // 1      4
	clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_4>;
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

adc0: adc@5a880000 {
	clocks = <&adc0_lpcg 0>, <&adc0_lpcg 1>;
			     ^^              ^^
	clocks = <&adc0_lpcg IMX_LPCG_CLK_0>, <&adc0_lpcg IMX_LPCG_CLK_4>;

Arg0 is divided by 4 in lpcg driver. So adc get IMX_SC_PM_CLK_PER by
<&adc0_lpcg 0>, <&adc0_lpcg 1>. Although function can work, code logic is
wrong. Fix it by using correct indices.

Cc: stable@vger.kernel.org
Fixes: 1db044b25d2e ("arm64: dts: imx8dxl: add adc0 support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -377,8 +377,8 @@ dma_subsys: bus@5a000000 {
 		reg = <0x5a880000 0x10000>;
 		interrupts = <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&adc0_lpcg 0>,
-			 <&adc0_lpcg 1>;
+		clocks = <&adc0_lpcg IMX_LPCG_CLK_0>,
+			 <&adc0_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_ADC_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
@@ -392,8 +392,8 @@ dma_subsys: bus@5a000000 {
 		reg = <0x5a890000 0x10000>;
 		interrupts = <GIC_SPI 241 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&adc1_lpcg 0>,
-			 <&adc1_lpcg 1>;
+		clocks = <&adc1_lpcg IMX_LPCG_CLK_0>,
+			 <&adc1_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_ADC_1 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;


