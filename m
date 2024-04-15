Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5801274439;
	Mon, 15 Apr 2024 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191815; cv=none; b=pSG2GYmbpq2QptV+sr+Ryiuw8zxf15cR+0i+UH6tiI/82/w7dHika63cYa8PEF/6YBgpeU3w80NNPW7g90Vl6h2e7yPKc/28qMZPSPMa1PJo7O1NO3Yy+WnmKZPEPDS8bSqKKrMHFuS6wbKZ3Hs7NJuevG0Yz1aoT5RhL1F6ZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191815; c=relaxed/simple;
	bh=lt3TGb4S32lq0i/98tJzlbW5cKhLJQRJ6FDMap3Kp/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5FcF0IgwpA/kbAd2hqyNa6dtbpcpy7ykH8WmypJa3W0I7X0JzGS1li5tr8M/7lK4D9jnP5qWX1fXVZwSK/L85xUeArdpE9b40A+TxXzIZvdnvnFEZ3xFVZay53OESUBAswXBhVgnJHbS00WeGeVHcPthLOUoarWbBar4mDGPCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XVFIawT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XVFIawT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDECC113CC;
	Mon, 15 Apr 2024 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191815;
	bh=lt3TGb4S32lq0i/98tJzlbW5cKhLJQRJ6FDMap3Kp/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XVFIawT3sOPzsM+fZPxgOr03rxARuedEs5ck1nJR3i1qKnaxZfk1XE1YE+1pKqi6
	 XXa5FzkyZYrBSlfqM6ictccPjb737gTpPcrEuQfmhxuA22LGOgIzj/NrjDZ894Dfvz
	 /mXWO9WvQt8IW2xmR2KzmwbYlyaDttDlnE1SeVhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 096/122] arm64: dts: imx8-ss-dma: fix adc lpcg indices
Date: Mon, 15 Apr 2024 16:21:01 +0200
Message-ID: <20240415141956.253949420@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -282,8 +282,8 @@ dma_subsys: bus@5a000000 {
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
@@ -297,8 +297,8 @@ dma_subsys: bus@5a000000 {
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


