Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EE23B19DE;
	Fri,  9 Oct 2026 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556428; cv=none; b=rBYIJWFxLANLFaOoXKKhYwXmHlmwaJRhoenYJhq3gp+oSkQy4aeGKmGRc+xMyh1nLdSIrtp//bRvpl3OooKz48DuKADe5NeJ0e2BfJw63KQitrCyHQXpKOuKqY7krdFl9ep5p4YzsXN79GwgJeB3pOBzktQ55q1XCFNFbnYAQUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556428; c=relaxed/simple;
	bh=MPRcAclE5lZnbm5owGlZnvfqKkUOGNiIPAADdVWBsjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSfg6jnrJ94NJeNPGQBCWwxaWj+ObFfpQeFHgWMV5gq8FxZgfp9zSVDfbMxV+NDKdiuALXlt+uYr9IkfpSA2WS8fen/or9HWIrp462V4RzBQBsM+BTz/hFK/51ibd1tasVMLCVSzbOWbl7mqW3GJb5n5aw0V0ZF30yKY8Z/d/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gu1ovSPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gu1ovSPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F9F1F000FF;
	Fri,  9 Oct 2026 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556427;
	bh=9Lz1BE/jBOBz2C89rfZliKJBPLWA4WxOiZR7DzTYTCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gu1ovSPTcY2O94o5Om9seWPAZZcB/CdlI1Qzc/ll54APTYZoUTR8kxHGKBwGe53yn
	 pEnDg3zLno9gFbDyrTnMNEDPl8UcFsLF6e5MFHQfwNyMR0KZRmFXLC5tfcC/4y2DBL
	 BYTlBNTpO+w8Pcn/ovCIUFUfuZiFS9skPmW2sGGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhao Chen <yongzhao.derek@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 143/428] net: phy: qcom: at803x: Fix IPQ5018 short-cable DAC values
Date: Fri,  9 Oct 2026 16:08:00 +0200
Message-ID: <20261009140949.317927555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongzhao Chen <yongzhao.derek@gmail.com>

[ Upstream commit 20f3599d85b416fd292a199364cb1248dcd9c780 ]

When "qcom,dac-preset-short-cable" is set, ipq5018_config_init()
programs the MDAC (MMD1 0x8100) and EDAC (debug 0x4380) fields. Both
fields occupy bits 15:8 (IPQ5018_PHY_DAC_MASK), but the value 0x10 is
passed unshifted as the set argument of phy_modify_mmd() and
at803x_debug_reg_mask(). Neither helper shifts or masks that argument,
so both fields are cleared to 0x00 instead of being set to 0x10, and
bit 4 of the low byte, which is outside the field, is set.

Use FIELD_PREP() to place the value in the field. This matches the
vendor SDK, which clears bits 15:8 and ORs in the value shifted left
by 8.

On a Redmi AX5400 board, where the IPQ5018 internal PHY connects to a
QCA8337 switch PHY without a cable, MDAC and EDAC read 0x6868 and
0x7800 before the write. With this change they read back 0x1068 and
0x1000, with the low byte preserved. Without it, the same writes would
leave 0x0078 and 0x0010.

No in-tree DTS sets this property yet, but it is documented in
qca,ar803x.yaml and used by several IPQ5018 boards in OpenWrt.

Fixes: d46502279a11 ("net: phy: qcom: at803x: Add Qualcomm IPQ5018 Internal PHY support")
Signed-off-by: Yongzhao Chen <yongzhao.derek@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260927155136.2489-1-yongzhao.derek@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/at803x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/qcom/at803x.c b/drivers/net/phy/qcom/at803x.c
index ba4dc07752b60..61bd4972d59fc 100644
--- a/drivers/net/phy/qcom/at803x.c
+++ b/drivers/net/phy/qcom/at803x.c
@@ -1051,11 +1051,15 @@ static int ipq5018_config_init(struct phy_device *phydev)
 	if (priv->set_short_cable_dac) {
 		/* setting MDAC (Multi-level Digital-to-Analog Converter) in MMD1 */
 		phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, IPQ5018_PHY_MMD1_MDAC,
-			       IPQ5018_PHY_DAC_MASK, IPQ5018_PHY_MMD1_MDAC_VAL);
+			       IPQ5018_PHY_DAC_MASK,
+			       FIELD_PREP(IPQ5018_PHY_DAC_MASK,
+					  IPQ5018_PHY_MMD1_MDAC_VAL));
 
 		/* setting EDAC (Error-detection and Correction) in debug register */
 		at803x_debug_reg_mask(phydev, IPQ5018_PHY_DEBUG_EDAC,
-				      IPQ5018_PHY_DAC_MASK, IPQ5018_PHY_DEBUG_EDAC_VAL);
+				      IPQ5018_PHY_DAC_MASK,
+				      FIELD_PREP(IPQ5018_PHY_DAC_MASK,
+						 IPQ5018_PHY_DEBUG_EDAC_VAL));
 	}
 
 	return 0;
-- 
2.53.0



