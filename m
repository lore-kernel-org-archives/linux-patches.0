Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88A78676;
	Mon, 15 Apr 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191812; cv=none; b=CWxhuSI9r5d3cE/CQ1e1chW4FxArZ1DKbgSxjEgsMmI9swUGSz3iPQ+d/BMp7KBGz0YiEzsiRjzGeNGJlx3OvTmR9sEfoGxBh4RZk0sLHZXZIQxOdgaQMmt4DJjhRaSYMNUv6bjcI3B4t6xMSi5ipIMzOyow60fuQc7JFJreCJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191812; c=relaxed/simple;
	bh=u+vkjYjAudQ7w4GfP6pfIhbkmBlj9dQdqaDOK2KxMS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl9I/vSuuLHFgpMCpeN85AcGeWD1cGRVMcCTp/a1FFHnXdoskAy9UfE1Uqf2OSB/Kn2v4ev7cg/Yb5qoPzhxLKgIG8up5QFxxThWlT87JmzuRCemAgAscuJLP2RTFskv4Htem9koBP3b3NHoIyLzIzpz4+mDxrITqhleq9pRRD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgrNGQr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgrNGQr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCD5C113CC;
	Mon, 15 Apr 2024 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191812;
	bh=u+vkjYjAudQ7w4GfP6pfIhbkmBlj9dQdqaDOK2KxMS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgrNGQr5CAIENNkJuymuUE4SSgiF7kMScUq+a4Jrthtk2RnK/j/hwAclNuIwwtues
	 1JGZZX7XE/2bwVEEmZeyA3h+RnU0WmHnDcdTjw/V8I0kt3mg8CY8qkl/Iwg9/k7EHX
	 WYl8mr8h0qNkXoB7PZo1TaV+G2mz1fahoxK/5KVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 095/122] arm64: dts: imx8-ss-dma: fix can lpcg indices
Date: Mon, 15 Apr 2024 16:21:00 +0200
Message-ID: <20240415141956.224250345@linuxfoundation.org>
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

commit 0893392334b5dffdf616a53679c6a2942c46391b upstream.

can0_lpcg: clock-controller@5acd0000 {
	...						   Col1  Col2
	clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>, // 0    0
		 <&dma_ipg_clk>,			  // 1    4
		 <&dma_ipg_clk>;			  // 2    5
        clock-indices = <IMX_LPCG_CLK_0>,
			<IMX_LPCG_CLK_4>,
			<IMX_LPCG_CLK_5>;
}

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

flexcan1: can@5a8d0000 {
	clocks = <&can0_lpcg 1>, <&can0_lpcg 0>;
			     ^^		     ^^
Should be:
	clocks = <&can0_lpcg IMX_LPCG_CLK_4>, <&can0_lpcg IMX_LPCG_CLK_0>;
};

Arg0 is divided by 4 in lpcg driver. flexcan driver get IMX_SC_PM_CLK_PER
by <&can0_lpcg 1> and <&can0_lpcg 0>. Although function can work, code
logic is wrong. Fix it by using correct clock indices.

Cc: stable@vger.kernel.org
Fixes: 5e7d5b023e03 ("arm64: dts: imx8qxp: add flexcan in adma")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -311,8 +311,8 @@ dma_subsys: bus@5a000000 {
 		reg = <0x5a8d0000 0x10000>;
 		interrupts = <GIC_SPI 235 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&can0_lpcg 1>,
-			 <&can0_lpcg 0>;
+		clocks = <&can0_lpcg IMX_LPCG_CLK_4>,
+			 <&can0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <40000000>;
@@ -332,8 +332,8 @@ dma_subsys: bus@5a000000 {
 		 * CAN1 shares CAN0's clock and to enable CAN0's clock it
 		 * has to be powered on.
 		 */
-		clocks = <&can0_lpcg 1>,
-			 <&can0_lpcg 0>;
+		clocks = <&can0_lpcg IMX_LPCG_CLK_4>,
+			 <&can0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <40000000>;
@@ -353,8 +353,8 @@ dma_subsys: bus@5a000000 {
 		 * CAN2 shares CAN0's clock and to enable CAN0's clock it
 		 * has to be powered on.
 		 */
-		clocks = <&can0_lpcg 1>,
-			 <&can0_lpcg 0>;
+		clocks = <&can0_lpcg IMX_LPCG_CLK_4>,
+			 <&can0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <40000000>;


