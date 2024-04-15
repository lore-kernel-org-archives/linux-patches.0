Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3F27581B;
	Mon, 15 Apr 2024 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191551; cv=none; b=mti6izSYfEzVSVhYnOpNF6b4xjLFOZtgQYz33L2iDaQEyMVqO0eIhfwdt1Sl5J+lVeUBJcLn7uul438CmNZpVUYkog7NOHk/sfo4nkl6bo0HcTdNhhmDhX35iz6D8YkQa0yQ60+TZesLSIIrsLPfXL6pNS0sBkpOpUrwYxZ9c1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191551; c=relaxed/simple;
	bh=BDLmlm8U65qv59bADBTj+upCTyn43H/elJcug7mIx0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io6rrEa1HXJgxliq8S0MjLKEZjUpuMkOMPzCwPuCDlinscp9rfmjDzmEu05QhL8EK49xunrnkK+Oi3BbfUAOLK2hfN3rXUfuTCoPHATCQaV2+3CdXhLnqgGWvdaJOKdCRvZznj8Aw/1CTJHC0K4rw/c10COw0Zmw8vHPdPippWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAMV+8q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAMV+8q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8670C113CC;
	Mon, 15 Apr 2024 14:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191551;
	bh=BDLmlm8U65qv59bADBTj+upCTyn43H/elJcug7mIx0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAMV+8q4FTJAga5VAj2/g54c8gerjIK2pPsTdvK3QQgB/3NKjfOuKpwICnPiTvRRw
	 KjPMwdPsWcQVIBNyKQzgQ7QmDnCVTxQdn3V37B7xnEhPS4JmbBMHrjSZYJVXE38vNE
	 NG3JxRH5U9Plf2ucBA+Wjd6gJJfSRm2Kf9XonMsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 132/172] arm64: dts: imx8qm-ss-dma: fix can lpcg indices
Date: Mon, 15 Apr 2024 16:20:31 +0200
Message-ID: <20240415142004.390017429@linuxfoundation.org>
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

commit 00b436182138310bb8d362b912b12a9df8f72ca3 upstream.

can1_lpcg: clock-controller@5ace0000 {
	...						    Col1   Col2
	clocks = <&clk IMX_SC_R_CAN_1 IMX_SC_PM_CLK_PER>,//  0       0
		 <&dma_ipg_clk>,			 //  1       4
		 <&dma_ipg_clk>;			 //  2       5
	clock-indices = <IMX_LPCG_CLK_0>,
			<IMX_LPCG_CLK_4>,
			<IMX_LPCG_CLK_5>;
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver

&flexcan2 {
	clocks = <&can1_lpcg 1>, <&can1_lpcg 0>;
			     ^^		     ^^
Should be:
	clocks = <&can1_lpcg IMX_LPCG_CLK_4>, <&can1_lpcg IMX_LPCG_CLK_0>;
};

Arg0 is divided by 4 in lpcg driver. So flexcan get IMX_SC_PM_CLK_PER by
<&can1_lpcg 1> and <&can1_lpcg 0>. Although function work, code logic is
wrong. Fix it by using correct clock indices.

Cc: stable@vger.kernel.org
Fixes: be85831de020 ("arm64: dts: imx8qm: add can node in devicetree")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi
@@ -127,15 +127,15 @@
 };
 
 &flexcan2 {
-	clocks = <&can1_lpcg 1>,
-		 <&can1_lpcg 0>;
+	clocks = <&can1_lpcg IMX_LPCG_CLK_4>,
+		 <&can1_lpcg IMX_LPCG_CLK_0>;
 	assigned-clocks = <&clk IMX_SC_R_CAN_1 IMX_SC_PM_CLK_PER>;
 	fsl,clk-source = /bits/ 8 <1>;
 };
 
 &flexcan3 {
-	clocks = <&can2_lpcg 1>,
-		 <&can2_lpcg 0>;
+	clocks = <&can2_lpcg IMX_LPCG_CLK_4>,
+		 <&can2_lpcg IMX_LPCG_CLK_0>;
 	assigned-clocks = <&clk IMX_SC_R_CAN_2 IMX_SC_PM_CLK_PER>;
 	fsl,clk-source = /bits/ 8 <1>;
 };


