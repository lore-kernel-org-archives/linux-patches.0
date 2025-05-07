Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274029A0;
	Wed,  7 May 2025 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644620; cv=none; b=AxNEhZRK6G3arSgf4Pfip4HeGQRtUsQpstRbtfDTsZTR7EM1SWQuH9yf7+7+HRUtwo1Ln+WATEn/4wUcKw3Lfk2fba1VPcK1x1sZzQWdZVopbY5pFzaUfpey8Erh8bSVYDyYppPsiV+cSTpovuf4xvrs6Bph3cGMA+cBDAkGVho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644620; c=relaxed/simple;
	bh=PRELH5o9NnMmpbnjxhlinkz1uPQgNphP5Xl4S2zCA4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiSsjVd/RZSR7dytITH2nA4OStlqnaZk1bY8iDBIDquqEmgOKA9fcOTYdlr+NgDHXs9oTh6EAMUHwwFkZAbkpwbB5MIxzxe1Lt/u2vbaopWAm62Wva9cgMv8W2onS59LeUt8U4Y2kg1VhiwQaiHgg/yoWUPIwOAU68I/E6PFdU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3dKKGiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3dKKGiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3A4C4CEE2;
	Wed,  7 May 2025 19:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644620;
	bh=PRELH5o9NnMmpbnjxhlinkz1uPQgNphP5Xl4S2zCA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3dKKGiMd6Ta5OsEsyd5Opl1STkFOyn8IyX6yRZWqKjKQnk/ooNndufUl0meRYWtM
	 GPQaJ5kPwWnufVcEVtBCD7unw3OI51VGbjBykHouSM8BH5klya7rvjhuI2rPlgOMob
	 NqHl4OZbkFdj/ly0jnRH0Zr+neiqbN2HI3nO3n4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/164] net: mdio: mux-meson-gxl: set reversed bit when using internal phy
Date: Wed,  7 May 2025 20:39:48 +0200
Message-ID: <20250507183825.144793246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Da Xue <da@libre.computer>

[ Upstream commit b23285e93bef729e67519a5209d5b7fde3b4af50 ]

This bit is necessary to receive packets from the internal PHY.
Without this bit set, no activity occurs on the interface.

Normally u-boot sets this bit, but if u-boot is compiled without
net support, the interface will be up but without any activity.
If bit is set once, it will work until the IP is powered down or reset.

The vendor SDK sets this bit along with the PHY_ID bits.

Signed-off-by: Da Xue <da@libre.computer>
Fixes: 9a24e1ff4326 ("net: mdio: add amlogic gxl mdio mux support")
Link: https://patch.msgid.link/20250425192009.1439508-1-da@libre.computer
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mux-meson-gxl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
index 89554021b5ccc..f9f02d3136492 100644
--- a/drivers/net/mdio/mdio-mux-meson-gxl.c
+++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
@@ -17,6 +17,7 @@
 #define  REG2_LEDACT		GENMASK(23, 22)
 #define  REG2_LEDLINK		GENMASK(25, 24)
 #define  REG2_DIV4SEL		BIT(27)
+#define  REG2_REVERSED		BIT(28)
 #define  REG2_ADCBYPASS		BIT(30)
 #define  REG2_CLKINSEL		BIT(31)
 #define ETH_REG3		0x4
@@ -65,7 +66,7 @@ static void gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
 	 * The only constraint is that it must match the one in
 	 * drivers/net/phy/meson-gxl.c to properly match the PHY.
 	 */
-	writel(FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
+	writel(REG2_REVERSED | FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
 	       priv->regs + ETH_REG2);
 
 	/* Enable the internal phy */
-- 
2.39.5



