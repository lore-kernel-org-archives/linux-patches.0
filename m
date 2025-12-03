Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F59342146;
	Wed,  3 Dec 2025 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777440; cv=none; b=D026eVQiQB4bHLZTlcNB/BHLEfwKpESpSi1hCKyumq62fjdPtVzyOXfaN6zneZh78rN/qORrqB4O782smFh+0kz2LqO3LJgS0DrQ+CMoeEXHOP+/22ydcPytnLrl/y9WO8o6SUPt3ukOIdNEE/nIWOeiN8B4INGuLm+31qyZCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777440; c=relaxed/simple;
	bh=2UFYytGWtNTPf4Ic18WDJunAuZHKSxi6LuPDGcYFogw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFxTrh3wngU83omPVLcNclOrIU3Wa1bHnGYLS42+kt6JdpS4SxbPaZON+CbeWXh61VjDL2t14M2kdH8+FoI6cAWML+gsgxwKm9wqmmHqbqBGD6491Fsqe8CiIF6lb/aIACMRNd1JjasBCLY4sLEVVQkhDpIAIyGwziJB9Ofs88s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he0aUnHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he0aUnHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6369FC4CEF5;
	Wed,  3 Dec 2025 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777439;
	bh=2UFYytGWtNTPf4Ic18WDJunAuZHKSxi6LuPDGcYFogw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=he0aUnHTn7oBf6VMcszp5fZXmcUVCGAFs0dqZEnoLsY3S2El20BaKyCNkAQjFxX67
	 AQBtPgS90BWCTVz/ZlARXUpqkCPvVQFpcWmQzbwZEgRYLxrebNe1B0B1ilDSl+MBnh
	 LtsGCxkilqIQB149PnltLdWjYR0fu/sEf3aacBZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/392] net: phy: dp83867: Disable EEE support as not implemented
Date: Wed,  3 Dec 2025 16:23:08 +0100
Message-ID: <20251203152415.507418793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 84a905290cb4c3d9a71a9e3b2f2e02e031e7512f ]

While the DP83867 PHYs report EEE capability through their feature
registers, the actual hardware does not support EEE (see Links).
When the connected MAC enables EEE, it causes link instability and
communication failures.

The issue is reproducible with a iMX8MP and relevant stmmac ethernet port.
Since the introduction of phylink-managed EEE support in the stmmac driver,
EEE is now enabled by default, leading to issues on systems using the
DP83867 PHY.

Call phy_disable_eee during phy initialization to prevent EEE from being
enabled on DP83867 PHYs.

Link: https://e2e.ti.com/support/interface-group/interface/f/interface-forum/1445244/dp83867ir-dp83867-disable-eee-lpi
Link: https://e2e.ti.com/support/interface-group/interface/f/interface-forum/658638/dp83867ir-eee-energy-efficient-ethernet
Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Cc: stable@vger.kernel.org
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251023144857.529566-1-ghidoliemanuele@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ replaced phy_disable_eee() call with direct eee_broken_modes assignment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83867.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -674,6 +674,12 @@ static int dp83867_config_init(struct ph
 			return ret;
 	}
 
+	/* Although the DP83867 reports EEE capability through the
+	 * MDIO_PCS_EEE_ABLE and MDIO_AN_EEE_ADV registers, the feature
+	 * is not actually implemented in hardware.
+	 */
+	phydev->eee_broken_modes = MDIO_EEE_100TX | MDIO_EEE_1000T;
+
 	if (phy_interface_is_rgmii(phydev) ||
 	    phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 		val = phy_read(phydev, MII_DP83867_PHYCTRL);


