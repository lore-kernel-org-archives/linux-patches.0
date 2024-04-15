Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3928D7A705;
	Mon, 15 Apr 2024 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191498; cv=none; b=GfaRWwT+/v0vn+ie/ELk7loXStEjpXglRvCN0/l5F2naa/ADQLk0azAfETpP9znxMGsU0mn6dRK796IsnozmKh4SAOUPxXFvqOIMMBcs4UjnCuaKBOjWNe1ZM9/CBDwJT1yB5GQnmNYPxkZEf/kdUp+mkrHyoKb7S8KvNR+zebg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191498; c=relaxed/simple;
	bh=GiBz9udlZwzlGHCuOQsO+L3740Na3E2X3SF2079tCBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgZyzDlcpi6qbvK9PKXoTJcat5P98e5cWInzPQYIFZ7UchvUlGK07lDF5q9BwvrKwBxvcjBmm0Am+IYP7lqfU1gVW9qpFe1ib6QhStFCE3UlNZZqWHZvpmYaYA6Rbs4lMORZmf50Nf+hOkZs029EvTm5DBivxkJXCuqGjDhbZlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2cpAkd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2cpAkd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC83FC113CC;
	Mon, 15 Apr 2024 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191498;
	bh=GiBz9udlZwzlGHCuOQsO+L3740Na3E2X3SF2079tCBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2cpAkd5DmqzHOPsxZrPhIuQOHRSkxSspGSuug0TjDZ5fxQkn+WGggPg+S0XTF8LC
	 qQe1PSVoUQXZDFJqEbKTBQzGUZPqHjI6XRZCx3+/wybVa1SrsosbOA+1gCxrHToog3
	 cdWtRnb1X7ZVJDDk8eWaJQW1A++Zt/RcOskrFCNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 135/172] arm64: dts: imx8-ss-conn: fix usb lpcg indices
Date: Mon, 15 Apr 2024 16:20:34 +0200
Message-ID: <20240415142004.477732740@linuxfoundation.org>
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


