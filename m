Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1130F535;
	Wed,  3 Dec 2025 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776060; cv=none; b=Fk21uUX9HL4Arj7Sq5go+pJ8g0qK1wUxeOJGQ000tb17/F1617SQkaFTP8GnIy7dDrD26O4EPweUo5rr+2IsZHzWyB/1qld+Rw01ezIX4sXcZSk1UaFss5cNGbFZl5xwbLEereT8rxd5vbLycu5rNd9mZTgCcZRnSFQL9ajzBx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776060; c=relaxed/simple;
	bh=gsqPRCnbnpKkpkf/CYXL+p6FYzJoJ0J696RS3Bzqm8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2nVivI0rZ8w+fgsNCuYYrOVDjhmv+d0neiAWulTpWKJgM4h+QjrJYdNbdmmr4NpP6CQ/aG3SDmS1wB8b6zyjhQ6D916em7KYf6SvCWokVOiUOYfbhmIo1gYbF2D0yMAnozf//e9lDJTHbMkjSdfjR5n76dDUTVWK7+MJahwr7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmmKWUdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmmKWUdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B538AC4CEF5;
	Wed,  3 Dec 2025 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776060;
	bh=gsqPRCnbnpKkpkf/CYXL+p6FYzJoJ0J696RS3Bzqm8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmmKWUdi9rk2pTwA9M2BVCDmMeynqVnTgI30DjgQF3e/O9gdM5Tyb6naD7bs8rCWk
	 aCbMgeqxgvPWeiGkgYQjCR23h3j0Vv1nduVUodhA3qCqEwElh5heFdjs1AeScKHsM8
	 g49UaDufW7MonwucNM0068Rx6js01/o82YwkcFI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/300] net: phy: dp83867: Disable EEE support as not implemented
Date: Wed,  3 Dec 2025 16:23:49 +0100
Message-ID: <20251203152401.390045616@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -664,6 +664,12 @@ static int dp83867_config_init(struct ph
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


