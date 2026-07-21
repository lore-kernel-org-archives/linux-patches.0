Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A5646A5E3;
	Tue, 21 Jul 2026 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648956; cv=none; b=bzU/iVMFQux8kcINWKbzOHDTBlllw/qinkj0p238Pzc4cfz8hTdlY9bGSLO6T3IMFjmXdkp4vD9Yl8b7vccLdXHOS3P/zmCsB07cbw/RiroDVBHsHZu7EqSBRmD6xD8ohcPNWWEoPcS2qi9h31ft2XXpek77ICgpHibWM7IRXrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648956; c=relaxed/simple;
	bh=dsEHBQuyP/tJt3OwsszheSUBHqoc11b9ZP4V91aIqLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVPnKPSNYTNvoKB1N16B8ToNxHAGLCjI1JuJ7ZOtD6+2KROsKrB+XyCFj2GMl2ig5rrcmnNYCfhcbLRd1mga+m3OWwYaCsA1curt5a+4TSwy8YkPm3DOOAbudA2kgY6mm6lYgRQpMsQ15XZkxGQ9WqMyKFuq95A9zuWWpuM9v1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWiGPzgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWiGPzgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093A11F000E9;
	Tue, 21 Jul 2026 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648954;
	bh=rOxtVQkMfIau0F3guagzfOXpf0gQzK3o57Pf6toWIjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWiGPzgD5Vqq8iiZcaYC3uz4cb5J6gg7rtCsE6p9NJGrf/EiLOr0wTmDfl6d6TSUF
	 OTF3gBkk4ATArYpiaGN3HGvrmouWkTqm0F+G+3gLtUqValK6u0yDCmGp93MVMCLECK
	 bFqYUu4690RZMLdLr8KFfLpXHdXUX8Lw+PKP57aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0394/2077] arm64: dts: renesas: r8a78000: Fix GIC-720AE View 1 Redistributor description
Date: Tue, 21 Jul 2026 17:01:07 +0200
Message-ID: <20260721152602.005659326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 54613573ff1495b928e2841b257c081a58566901 ]

The Renesas R-Car X5H (R8A78000) SoC contains Arm CoreLink GIC-720AE
Generic Interrupt Controller with Multi View capability. Firmware has
access to configuration View 0, Linux kernel has access to View 1.

The Arm CoreLink GIC-720AE Generic Interrupt Controller Technical
Reference Manual, currently latest r2p1 [1], chapter "5. Programmers
model for GIC-720AE", subchapter "5.4 Redistributor registers
for control and physical LPIs summary", part "5.4.3 GICR_TYPER,
Redistributor Type Register", "Table 5-50: GICR_TYPER bit descriptions"
on page 200, clarifies register "GICR_TYPER" bit 4 "Last" behavior
in Multi View setup as follows:

    Last
    Last Redistributor:

    0 ... This Redistributor is not the last Redistributor on the chip.
    1 ... This Redistributor is the last Redistributor on the chip.
	  When GICD_CFGID.VIEW == 1, for views 1, 2, or 3 this bit
	  always returns 1.

On this SoC, GICD_CFGID.VIEW is 1 and the Linux kernel has access to
View 1, therefore Linux kernel GICv3 driver will interpret register
"GICR_TYPER" bit 4 "Last" = 1 in the first Redistributor in continuous
Redistributor page as that first Redistributor being the one and only
Redistributor and will stop processing the continuous Redistributor
page further. This will prevent the other Redistributors from being
recognized by the system and used for other PEs.

Because the hardware indicates that the continuous Redistributor page
is not continuous for View 1, 2, or 3, describe every Redistributor
separately in the DT. This makes all Redistributors for all cores
accessible in Linux.

[1] https://documentation-service.arm.com/static/69ef3c1cd35efd294e335c43
    Arm® CoreLink™ GIC-720AE Generic Interrupt Controller
    Revision: r2p1 / Issue 12 / 102666_0201_12_en

Fixes: 63500d12cf76 ("arm64: dts: renesas: Add R8A78000 SoC support")
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260514125328.20954-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a78000.dtsi | 36 +++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a78000.dtsi b/arch/arm64/boot/dts/renesas/r8a78000.dtsi
index 3ec1b53d278282..73be51787265c3 100644
--- a/arch/arm64/boot/dts/renesas/r8a78000.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a78000.dtsi
@@ -689,8 +689,40 @@ gic: interrupt-controller@39000000 {
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0 0x39000000 0 0x10000>,
-			      <0 0x39080000 0 0x800000>;
+			#redistributor-regions = <32>;
+			reg = <0x0 0x39000000 0x0 0x10000>,
+			      <0x0 0x39080000 0x0 0x40000>,
+			      <0x0 0x390c0000 0x0 0x40000>,
+			      <0x0 0x39100000 0x0 0x40000>,
+			      <0x0 0x39140000 0x0 0x40000>,
+			      <0x0 0x39180000 0x0 0x40000>,
+			      <0x0 0x391c0000 0x0 0x40000>,
+			      <0x0 0x39200000 0x0 0x40000>,
+			      <0x0 0x39240000 0x0 0x40000>,
+			      <0x0 0x39280000 0x0 0x40000>,
+			      <0x0 0x392c0000 0x0 0x40000>,
+			      <0x0 0x39300000 0x0 0x40000>,
+			      <0x0 0x39340000 0x0 0x40000>,
+			      <0x0 0x39380000 0x0 0x40000>,
+			      <0x0 0x393c0000 0x0 0x40000>,
+			      <0x0 0x39400000 0x0 0x40000>,
+			      <0x0 0x39440000 0x0 0x40000>,
+			      <0x0 0x39480000 0x0 0x40000>,
+			      <0x0 0x394c0000 0x0 0x40000>,
+			      <0x0 0x39500000 0x0 0x40000>,
+			      <0x0 0x39540000 0x0 0x40000>,
+			      <0x0 0x39580000 0x0 0x40000>,
+			      <0x0 0x395c0000 0x0 0x40000>,
+			      <0x0 0x39600000 0x0 0x40000>,
+			      <0x0 0x39640000 0x0 0x40000>,
+			      <0x0 0x39680000 0x0 0x40000>,
+			      <0x0 0x396c0000 0x0 0x40000>,
+			      <0x0 0x39700000 0x0 0x40000>,
+			      <0x0 0x39740000 0x0 0x40000>,
+			      <0x0 0x39780000 0x0 0x40000>,
+			      <0x0 0x397c0000 0x0 0x40000>,
+			      <0x0 0x39800000 0x0 0x40000>,
+			      <0x0 0x39840000 0x0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-- 
2.53.0



