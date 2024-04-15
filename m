Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C5B8004D;
	Mon, 15 Apr 2024 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191809; cv=none; b=WoSigKQZwwdz7nztHuZlnw5GiJ4EFQmMBEjLS13dm4kJqa0BF3qftvoDByi2vIDar0xnRmZ1F/zh0koA30sXFLAQtPAiR1czJqzWYoFuH6MLuF9HZbF8EccdvlJ5IzKR2hAM201j3fXOj2YDpRe1h5DRVFk9z3Q4idby0QIiJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191809; c=relaxed/simple;
	bh=iHzstWt4JeXSEQaGcWH9MwPfeWdPAqf2H0MMtcPsXVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMlwtUQnzMimBrOu/zlPoNodGsrU101VulqDveE2msNsLgk52WhD/YxJyIGnW4ZetghFzsa5g+BZ7wWPz/peMo7Cr31RBAAGpAVo/GXicomaWWo6P3J/VoUGZ7HplS0saY/V6yfhJYbupazYExKYSCItzoVp/jfaAsal67DBZ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ5VHjhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ5VHjhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEADFC2BD10;
	Mon, 15 Apr 2024 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191809;
	bh=iHzstWt4JeXSEQaGcWH9MwPfeWdPAqf2H0MMtcPsXVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ5VHjhbnHaQKc3i5gAiJsn3jMrLeF8FtBoRtt2lVV/mJcV4iqPYG7DN7rT/ZMJAi
	 h7ysASFbSLYT8EmZkjabI0j7VX5lUfacLFUa/E05mkQrwUlWMu0H7cacfGBQCKjEe7
	 ID6Gh+8fkdtY5wGL4juUaFd3cTY7j98qaUoQ7KbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 094/122] arm64: dts: imx8qm-ss-dma: fix can lpcg indices
Date: Mon, 15 Apr 2024 16:20:59 +0200
Message-ID: <20240415141956.194801057@linuxfoundation.org>
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
@@ -49,15 +49,15 @@
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


