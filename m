Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D90762D2;
	Mon, 15 Apr 2024 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191531; cv=none; b=uhn0LZi8YFypNDJOhhWVpdOxHugPjTAeRAUD7CCZzJdf6+43niBCLM2Z40h/ZanA72JtHLmbJIwYw1FRYFWfwjw8JjVP5NQePIUKUPnJ2B+xrVTBMSn85ARsTWLbs7c2HETlfErVy9n7SzXEOVXEPRUKu4M67270Jvfw31rpxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191531; c=relaxed/simple;
	bh=4yZe8dlVhPdPzip/k/+q1PWHwpFHgK3noJ22XqsSXQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y23tusnpnW3oTkxYdQ5gQ3s9LfWAlcWcv8xYbzZshrE96eDsB6nnfJJ2cV/ecyaQUNruCeEFLtWMU2h3efWogHQm6W0mLCcAf4gKH4DzEe9l0CGienYer9msRLWiaTI/EEr0jrJhW3w+W9QynfsfVEAf847oG+RQgBLYZsPDYBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Brv+F3eV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Brv+F3eV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D46CC113CC;
	Mon, 15 Apr 2024 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191530;
	bh=4yZe8dlVhPdPzip/k/+q1PWHwpFHgK3noJ22XqsSXQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Brv+F3eVGt5S9pGw4PMIqZsdeDUx3CjjF7q9/EtP0M+O/WpfaWK81l0yu1N+dFNzF
	 3Kf4NchnLVyqgdJmJxaL3m79s188fStt/DvzLVo1VZAomq8xL3eLIw6LLYRhf5uhiC
	 G9FI9OohRTlrn+AQQUG5c5EYA70+4jiKe+W/Rgdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 136/172] arm64: dts: imx8-ss-dma: fix pwm lpcg indices
Date: Mon, 15 Apr 2024 16:20:35 +0200
Message-ID: <20240415142004.507145908@linuxfoundation.org>
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

commit 9055d87bce7276234173fa90e9702af31b3f5353 upstream.

adma_pwm_lpcg: clock-controller@5a590000 {
	...							 col1 col2
	clocks = <&clk IMX_SC_R_LCD_0_PWM_0 IMX_SC_PM_CLK_PER>,// 0   0
		 <&dma_ipg_clk>;                               // 1   4
	clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_4>;
        ...
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

adma_pwm: pwm@5a190000 {
	...
	clocks = <&adma_pwm_lpcg 1>, <&adma_pwm_lpcg 0>;
				 ^^		     ^^
Should be
	clocks = <&adma_pwm_lpcg IMX_LPCG_CLK_4>,
		 <&adma_pwm_lpcg IMX_LPCG_CLK_0>;
};

Arg0 will be divided by 4 in lcpg driver, so pwm will get IMX_SC_PM_CLK_PER
by <&adma_pwm_lpcg 1>, <&adma_pwm_lpcg 0>. Although function can work, code
logic is wrong. Fix it by use correct indices.

Cc: stable@vger.kernel.org
Fixes: f1d6a6b991ef ("arm64: dts: imx8qxp: add adma_pwm in adma")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -144,8 +144,8 @@ dma_subsys: bus@5a000000 {
 		compatible = "fsl,imx8qxp-pwm", "fsl,imx27-pwm";
 		reg = <0x5a190000 0x1000>;
 		interrupts = <GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&adma_pwm_lpcg 1>,
-			 <&adma_pwm_lpcg 0>;
+		clocks = <&adma_pwm_lpcg IMX_LPCG_CLK_4>,
+			 <&adma_pwm_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_LCD_0_PWM_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;


