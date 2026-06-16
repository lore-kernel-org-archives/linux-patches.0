Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518F43D504;
	Tue, 16 Jun 2026 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622813; cv=none; b=Yr0pgOCdYvyBoBB3teMUm7mgjSqriCuDFAQLhsHBtQgpPCx3cSPkgE9oYl+LpXV06rwzrZJkqqUJ1Ux7OmUPaGsfqDAw75v05nyAgwZi7fWfWL5KDhU+MjHTybq+2lxNrZQgff1FnhSkB+ddrzAkD0vh+jDIYjQLxmqY07zbbgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622813; c=relaxed/simple;
	bh=zED4gQP4LQZabVXQSeBmFAwbTjZcjhfVF0tyWczA68Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1AOjPA6i454vKB8HITD7EDZs2+YQfjDDii0dZ0j1QmnNd2UV9jazLaLtHuzi1AleWFhxuBaz/2L0Eqt1MXylsrKK6zdKJIP7ZSUH2KzgEqnICxGDBrPWa3f0QxDmr7YyTgch0+wqk/xaG4sZlB/vb5zdPQvHvb2xRjuqlzljv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk6VDIbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk6VDIbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B771F000E9;
	Tue, 16 Jun 2026 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622811;
	bh=7SQghOQRWnLLwOKnTexFVqoiTZkUKJ4d7tGYe9AmifA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk6VDIbQBYLysHSoS//MUFGRETDf9kabLQvM0E4wv+fRHjhPBQ2rn808I1HZrnNIw
	 2UHDHUOwROSo28fNK9IlOkWZQcLQFnI73eQCI4wvB3EaMOM2ZJGyv/2ggakU9abxXd
	 ieyNh20lb0kiHX0qgRghuNQRK1dalkDr57Xrhkz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 010/378] ARM: dts: microchip: sam9x7: fix GMAC clock configuration
Date: Tue, 16 Jun 2026 20:24:01 +0530
Message-ID: <20260616145110.331382326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



