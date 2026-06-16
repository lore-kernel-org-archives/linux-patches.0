Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923A1364024;
	Tue, 16 Jun 2026 15:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624885; cv=none; b=PX6eDSPJcQAgNfZX3IYapJjYqaSQJtEvlRjiYnXHbIMUH7G8XSErdVc1RWiJ33TnYjcnG365GQvN5RMYNNaSAFsB8QNoSnnvkeAH5tcBjgC7FHmnPxAzc2Hjs4X9SBTPka0cQ95ySMgYoBNEw9FkvbJPFKTebHeW6PrAjGx481o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624885; c=relaxed/simple;
	bh=+MYX331hxcBhbYxKQvlZqAz9jyVOGKw8eqPG9Mir7wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9CUfcsuqaIesFG+r0D41fIR0Wss2SESk7hZPnTd6w2tltKV7ioxnPmJOqfsTdh+MrAKdo7wgbd9XqS7JZSru71IjPgCAqgjuBVl0+KmKZ9YulXhPRQF3MvKinPsgA2oZIgoWsmCQdwEHgiZw8bcMk5BecBSvSLkV7ZxMhOaAFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxEGqgAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxEGqgAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8FD1F000E9;
	Tue, 16 Jun 2026 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624884;
	bh=hVSTsMSx4KHVpzpMyF4c0KmtOWdvJE/S8y3m5vNATog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxEGqgAgP8Xi68NYNWKmPQIZxBth/2WdFEEm0gaIr3mKqK95OnrFnaxBbtpSU+aXS
	 1Zr4pYzGZIS4hD1Z/1v0JhJu+UTRA8tNhRgbEtXM9/Gy5A2Yd9Qy2BdS+rfa/dwVE6
	 zhiV65P0y4THaFlaa1Lwc5ttNxne8fimEIR7g6BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/325] ARM: dts: microchip: sam9x7: fix GMAC clock configuration
Date: Tue, 16 Jun 2026 20:26:49 +0530
Message-ID: <20260616145058.467502421@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 765aaba18413a66f6c8fe8416336ca9b3dd98a79 ]

The GMAC node incorrectly listed four clocks, including a separate tx_clk
and a TSU GCK clock sourced from ID 67. According to the SAM9X7 clocking
scheme, the GMAC uses only three clocks: HCLK, PCLK, and the TSU GCK
derived from the GMAC peripheral clock (ID 24).

Remove the unused tx_clk, update the clock-names accordingly, and correct
the assigned clock to use GCK 24 instead of GCK 67. This aligns the device
tree with the actual hardware clock topology and prevents misconfiguration
of the GMAC clock tree.

[root@SAM9X75 ~]$ cat /sys/kernel/debug/clk/clk_summary | grep gmac

gmac_gclk      1       1        1        266666666   0          0     50000      Y         f802c000.ethernet           tsu_clk
                                                                                           f802c000.ethernet           tsu_clk
gmac_clk       2       2        0        266666666   0          0     50000      Y         f802c000.ethernet           hclk
                                                                                           f802c000.ethernet           pclk

Fixes: 41af45af8bc3 ("ARM: dts: at91: sam9x7: add device tree for SoC")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Link: https://lore.kernel.org/r/20260309075329.1528-5-mihai.sain@microchip.com
[claudiu.beznea: massaged the patch description]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/sam9x7.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/microchip/sam9x7.dtsi b/arch/arm/boot/dts/microchip/sam9x7.dtsi
index d242d7a934d0fa..c680a5033b6b4e 100644
--- a/arch/arm/boot/dts/microchip/sam9x7.dtsi
+++ b/arch/arm/boot/dts/microchip/sam9x7.dtsi
@@ -990,9 +990,9 @@ gmac: ethernet@f802c000 {
 				     <62 IRQ_TYPE_LEVEL_HIGH 3>,	/* Queue 3 */
 				     <63 IRQ_TYPE_LEVEL_HIGH 3>,	/* Queue 4 */
 				     <64 IRQ_TYPE_LEVEL_HIGH 3>;	/* Queue 5 */
-			clocks = <&pmc PMC_TYPE_PERIPHERAL 24>, <&pmc PMC_TYPE_PERIPHERAL 24>, <&pmc PMC_TYPE_GCK 24>, <&pmc PMC_TYPE_GCK 67>;
-			clock-names = "hclk", "pclk", "tx_clk", "tsu_clk";
-			assigned-clocks = <&pmc PMC_TYPE_GCK 67>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 24>, <&pmc PMC_TYPE_PERIPHERAL 24>, <&pmc PMC_TYPE_GCK 24>;
+			clock-names = "hclk", "pclk", "tsu_clk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 24>;
 			assigned-clock-rates = <266666666>;
 			status = "disabled";
 		};
-- 
2.53.0



