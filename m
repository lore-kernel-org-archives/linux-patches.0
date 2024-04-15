Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872C480BFE;
	Mon, 15 Apr 2024 14:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191536; cv=none; b=Lx5GuI2htN30DOH4p3UhYmAd0KyNfnx5IxugX6zCBg5ZQYdhpt4c9CVZXPj7CRn6umsS0ywOzkcgCvuPd477XQjYPaJj71yW66DqpU8z+cOrZZ10baTMhohOsdOrCMmQjmjt1VWsHv42eQgVPWHK72JXSe5Qom7xl8+vKmgm3xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191536; c=relaxed/simple;
	bh=LUd5/0+JreaGis0BdfeTlIBmlF/qQ7sIWgR67JwdrU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKJjwd8OuS/9NJmg19I3/Wy6FLx1Conf201CsloTlZeNsZiAP/+kSztuVksgDkIKreWfqgLlaox+3VkQdI+UI8WL0HygvAy3miCAEjaVKq+cKbzA/v+qN0LPsqFiJUygU/DjtQbeMMP34JuKb49pUYwmr06N0bqGF7frWKwm7iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kiILADv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kiILADv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7BEC113CC;
	Mon, 15 Apr 2024 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191536;
	bh=LUd5/0+JreaGis0BdfeTlIBmlF/qQ7sIWgR67JwdrU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kiILADv+wqTvPcXLk+0zsA9skndwHy9bPz5NxhOgvg5jnr7Ie5Jtcp1eD60UAAle
	 G+EsQ3bcpDo0Uzkm/S7SykpyO1Dd9Blkod4JOv9vSPgYODZOcKj3D3F6HBbEJN1c7E
	 x7OsGekcLTLfWVdlNlVdKe/WnZj1wkkCnOFguiY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 137/172] arm64: dts: imx8-ss-lsio: fix pwm lpcg indices
Date: Mon, 15 Apr 2024 16:20:36 +0200
Message-ID: <20240415142004.536555376@linuxfoundation.org>
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

commit 1d86c2b3946e69d6b0b93568d312aae6247847c0 upstream.

lpcg's arg0 should use clock indices instead of index.

pwm0_lpcg: clock-controller@5d400000 {
	...                                                // Col1  Col2
	clocks = <&clk IMX_SC_R_PWM_0 IMX_SC_PM_CLK_PER>,  // 0     0
		 <&clk IMX_SC_R_PWM_0 IMX_SC_PM_CLK_PER>,  // 1     1
		 <&clk IMX_SC_R_PWM_0 IMX_SC_PM_CLK_PER>,  // 2     4
		 <&lsio_bus_clk>,                          // 3     5
		 <&clk IMX_SC_R_PWM_0 IMX_SC_PM_CLK_PER>;  // 4     6
	clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_1>,
			<IMX_LPCG_CLK_4>, <IMX_LPCG_CLK_5>,
			<IMX_LPCG_CLK_6>;
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

pwm1 {
	....
	clocks = <&pwm1_lpcg 4>, <&pwm1_lpcg 1>;
                             ^^              ^^
should be:

	clocks = <&pwm1_lpcg IMX_LPCG_CLK_6>, <&pwm1_lpcg IMX_LPCG_CLK_1>;
};

Arg0 is divided by 4 in lpcg driver, so index 0 and 1 will be get by pwm
driver, which are same as IMX_LPCG_CLK_6 and IMX_LPCG_CLK_1. Even it can
work, but code logic is wrong. Fixed it by use correct indices.

Cc: stable@vger.kernel.org
Fixes: 23fa99b205ea ("arm64: dts: freescale: imx8-ss-lsio: add support for lsio_pwm0-3")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
@@ -25,8 +25,8 @@ lsio_subsys: bus@5d000000 {
 		compatible = "fsl,imx27-pwm";
 		reg = <0x5d000000 0x10000>;
 		clock-names = "ipg", "per";
-		clocks = <&pwm0_lpcg 4>,
-			 <&pwm0_lpcg 1>;
+		clocks = <&pwm0_lpcg IMX_LPCG_CLK_6>,
+			 <&pwm0_lpcg IMX_LPCG_CLK_1>;
 		assigned-clocks = <&clk IMX_SC_R_PWM_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <3>;
@@ -38,8 +38,8 @@ lsio_subsys: bus@5d000000 {
 		compatible = "fsl,imx27-pwm";
 		reg = <0x5d010000 0x10000>;
 		clock-names = "ipg", "per";
-		clocks = <&pwm1_lpcg 4>,
-			 <&pwm1_lpcg 1>;
+		clocks = <&pwm1_lpcg IMX_LPCG_CLK_6>,
+			 <&pwm1_lpcg IMX_LPCG_CLK_1>;
 		assigned-clocks = <&clk IMX_SC_R_PWM_1 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <3>;
@@ -51,8 +51,8 @@ lsio_subsys: bus@5d000000 {
 		compatible = "fsl,imx27-pwm";
 		reg = <0x5d020000 0x10000>;
 		clock-names = "ipg", "per";
-		clocks = <&pwm2_lpcg 4>,
-			 <&pwm2_lpcg 1>;
+		clocks = <&pwm2_lpcg IMX_LPCG_CLK_6>,
+			 <&pwm2_lpcg IMX_LPCG_CLK_1>;
 		assigned-clocks = <&clk IMX_SC_R_PWM_2 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <3>;
@@ -64,8 +64,8 @@ lsio_subsys: bus@5d000000 {
 		compatible = "fsl,imx27-pwm";
 		reg = <0x5d030000 0x10000>;
 		clock-names = "ipg", "per";
-		clocks = <&pwm3_lpcg 4>,
-			 <&pwm3_lpcg 1>;
+		clocks = <&pwm3_lpcg IMX_LPCG_CLK_6>,
+			 <&pwm3_lpcg IMX_LPCG_CLK_1>;
 		assigned-clocks = <&clk IMX_SC_R_PWM_3 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <3>;


