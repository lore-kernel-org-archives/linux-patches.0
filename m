Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA280BFE;
	Mon, 15 Apr 2024 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191539; cv=none; b=SSxAn8HBcFYErXdr61buhDvou7wVSHguBri4yQcMYeNKyJNUis5dOHweC4jSejBN+kiIcGnfHqYQjs324V2h2ZqF3oIoCSSzHdPtwYH8Pew57OAR8mScTNG6GDA2egMr50jvoMFtx5Fs0ib5Osggtd1Lu574gIPWVVR8pmvH1vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191539; c=relaxed/simple;
	bh=Px7iyvek2R5hegyfRXVLm9B0mHrZCdwKYbRaKTy2Yww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBqRHpFTT0nqEFSBzfUuIi3oNoTF9XA35IlQQDz9UOxhFu2qihunynfzkrBDonYwSGDENuIXsOmggK1XDCkNZPeGXR/OPKBzGXQqITvgkOgs/+bQ2wctypnoPKlANiA7EOZ484JNavu1jvlERQCDgK01tHYn8iGEkbLgUPSLO3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tti8sUFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tti8sUFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E729CC113CC;
	Mon, 15 Apr 2024 14:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191539;
	bh=Px7iyvek2R5hegyfRXVLm9B0mHrZCdwKYbRaKTy2Yww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tti8sUFN6AReviJmv+Dyym2W9Udm0vMrqlT/zuzVJhB+04A2Dj6vkzNeJEcwPoMqX
	 cKQcaGwxR1XiYiGgYVp6ln/1dbCJtHn3PH5AnpFh5qAAzeVH0mISryXbisFyN01a3x
	 jr21zAP9SX2a0G9Yip67giUdnzxXhZBf7JGXH/Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 138/172] arm64: dts: imx8-ss-dma: fix spi lpcg indices
Date: Mon, 15 Apr 2024 16:20:37 +0200
Message-ID: <20240415142004.565688097@linuxfoundation.org>
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

commit f72b544a514c07d34a0d9d5380f5905b3731e647 upstream.

spi0_lpcg: clock-controller@5a400000 {
	...                                                  Col0   Col1
	clocks = <&clk IMX_SC_R_SPI_0 IMX_SC_PM_CLK_PER>,//   0      1
		 <&dma_ipg_clk>;                         //   1      4
	clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_4>;
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

lpspi0: spi@5a000000 {
	...
	clocks = <&spi0_lpcg 0>, <&spi0_lpcg 1>;
			     ^		     ^
Should be:
	clocks = <&spi0_lpcg IMX_LPCG_CLK_0>, <&spi0_lpcg IMX_LPCG_CLK_4>;
};

Arg0 is divided by 4 in lpcg driver. <&spi0_lpcg 0> and <&spi0_lpcg 1> are
IMX_SC_PM_CLK_PER. Although code can work, code logic is wrong. It should
use IMX_LPCG_CLK_0 and IMX_LPCG_CLK_4 for lpcg arg0.

Cc: stable@vger.kernel.org
Fixes: c4098885e790 ("arm64: dts: imx8dxl: add lpspi support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -27,8 +27,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi0_lpcg 0>,
-			 <&spi0_lpcg 1>;
+		clocks = <&spi0_lpcg IMX_LPCG_CLK_0>,
+			 <&spi0_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;
@@ -43,8 +43,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi1_lpcg 0>,
-			 <&spi1_lpcg 1>;
+		clocks = <&spi1_lpcg IMX_LPCG_CLK_0>,
+			 <&spi1_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_1 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;
@@ -59,8 +59,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 338 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi2_lpcg 0>,
-			 <&spi2_lpcg 1>;
+		clocks = <&spi2_lpcg IMX_LPCG_CLK_0>,
+			 <&spi2_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_2 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;
@@ -75,8 +75,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 339 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi3_lpcg 0>,
-			 <&spi3_lpcg 1>;
+		clocks = <&spi3_lpcg IMX_LPCG_CLK_0>,
+			 <&spi3_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_3 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;


