Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC6E81AC6;
	Mon, 15 Apr 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191818; cv=none; b=Z4DyiKnqPB6gDXVMJqon1ctSSZS1WnDUWaxL8NfYb7b4oYvzAFzMZWfuFYZH0wUBY/gub80TWULaqCmeTWGyJSlXmlQcOYg+k9JKu12PWwBU5tOOj9oVJoEfB/KqlmeFwotnMsFTH/quhYmFQKmrvc6HJ5odxPSu3k43HFPVZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191818; c=relaxed/simple;
	bh=nYIZLm6qv+SWigRHuJA/n9VpgUswnDbQCtvJZG7rsZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0Y53VGKSwPIXMeTdyNHLxZSJ2FysD9jo/pjUBpCzwh6wHKrEWPMOrC0gmDAGIQ/gXztY8lkSNGv1//t+N79kRRJvIMOb3PcyefIVKsdbmOd4gTjTzbcswqyXbuzqTSTNrloBK5Ieg8ej8r9Y6WAJNMEVOPIk9h75WAa1SXA/Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPzX3Mu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPzX3Mu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C901DC113CC;
	Mon, 15 Apr 2024 14:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191818;
	bh=nYIZLm6qv+SWigRHuJA/n9VpgUswnDbQCtvJZG7rsZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPzX3Mu/KoTjdPiualN+JwiV2ytjigNHwZpkVYPkKS9YsVHbhev/eauAlAFDP8PRz
	 0t3b5UHFstyCmof9a1uKeipX3WsHspie7VCEJ1F2iwNvxusV4zCeMlgYVEohmoBDyX
	 OpVi1K6uPlrswBi+Kgsy0MRVI3e2FGel+Y3kxQhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 097/122] arm64: dts: imx8-ss-conn: fix usb lpcg indices
Date: Mon, 15 Apr 2024 16:21:02 +0200
Message-ID: <20240415141956.282504415@linuxfoundation.org>
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

commit 808e7716edcdb39d3498b9f567ef6017858b49aa upstream.

usb2_lpcg: clock-controller@5b270000 {
	...                                                    Col1  Col2
	clocks = <&conn_ahb_clk>, <&conn_ipg_clk>;           // 0     6
	clock-indices = <IMX_LPCG_CLK_6>, <IMX_LPCG_CLK_7>;  // 0     7
        ...
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

usbotg1: usb@5b0d0000 {
	...
	clocks = <&usb2_lpcg 0>;
			     ^^
Should be:
	clocks = <&usb2_lpcg IMX_LPCG_CLK_6>;
};

usbphy1: usbphy@5b100000 {
	clocks = <&usb2_lpcg 1>;
			     ^^
SHould be:
	clocks = <&usb2_lpcg IMX_LPCG_CLK_7>;
};

Arg0 is divided by 4 in lpcg driver. So lpcg will do dummy enable. Fix it
by use correct clock indices.

Cc: stable@vger.kernel.org
Fixes: 8065fc937f0f ("arm64: dts: imx8dxl: add usb1 and usb2 support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
@@ -41,7 +41,7 @@ conn_subsys: bus@5b000000 {
 		interrupts = <GIC_SPI 267 IRQ_TYPE_LEVEL_HIGH>;
 		fsl,usbphy = <&usbphy1>;
 		fsl,usbmisc = <&usbmisc1 0>;
-		clocks = <&usb2_lpcg 0>;
+		clocks = <&usb2_lpcg IMX_LPCG_CLK_6>;
 		ahb-burst-config = <0x0>;
 		tx-burst-size-dword = <0x10>;
 		rx-burst-size-dword = <0x10>;
@@ -58,7 +58,7 @@ conn_subsys: bus@5b000000 {
 	usbphy1: usbphy@5b100000 {
 		compatible = "fsl,imx7ulp-usbphy";
 		reg = <0x5b100000 0x1000>;
-		clocks = <&usb2_lpcg 1>;
+		clocks = <&usb2_lpcg IMX_LPCG_CLK_7>;
 		power-domains = <&pd IMX_SC_R_USB_0_PHY>;
 		status = "disabled";
 	};


