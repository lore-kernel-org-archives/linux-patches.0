Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E342E3380;
	Tue, 15 Jul 2025 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586762; cv=none; b=kHT/rfKO8PgxTnC4mhH9kFe3SgwWz6p/Pib5nSN5yXjMLHw2UG/f6C9PbAy77puOpeJVjeNEmCnR6uk3L3C3BDFWgSB540x9Uhu2TwuXO2Vyl5vfxdz6qnJQXWpNlpgPQgsv9gJ711iAIV/7FUR8/iFhaw6sSdm1CAZn5PzWQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586762; c=relaxed/simple;
	bh=bx0lx9CS1oHeoARKQoQy9YnY0nHbUNj4jAil8eT+hKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMDVQ6hJUlO04/wQib61CLYA6AAyV8yqAYwhdBJOQkL4oTsvLbYFYgYwKn/3MrU1Ixfc0jO8iC0/53A4/sExKg68hxulrI1GiJUKI0r0rVjSJy+HLfcoK+nW549NR0i5ooF2i+gOwzOav/ij22sud83gvIswpvfL93368bDjm6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD819+4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD819+4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C648C4CEE3;
	Tue, 15 Jul 2025 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586761;
	bh=bx0lx9CS1oHeoARKQoQy9YnY0nHbUNj4jAil8eT+hKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD819+4qr/pGRPy/cWR85/JLgbJ6usRNmvyjOlJ3vALZzdzvXLefmTX7Pp3lDiyFi
	 17bc1Qj2i8tkTqxDrReZmPuk8H+SKnwDOltsD2I2xokl04OmJDqCxbsvC0fiW15ZUa
	 TeK9E+8b33lNQXFZ9URsLih5MOsnCKba5ctLaEa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 039/192] net: phy: smsc: Force predictable MDI-X state on LAN87xx
Date: Tue, 15 Jul 2025 15:12:14 +0200
Message-ID: <20250715130816.423410374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 0713e55533c88a20edb53eea6517dc56786a0078 ]

Override the hardware strap configuration for MDI-X mode to ensure a
predictable initial state for the driver. The initial mode of the LAN87xx
PHY is determined by the AUTOMDIX_EN strap pin, but the driver has no
documented way to read its latched status.

This unpredictability means the driver cannot know if the PHY has
initialized with Auto-MDIX enabled or disabled, preventing it from
providing a reliable interface to the user.

This patch introduces a `config_init` hook that forces the PHY into a
known state by explicitly enabling Auto-MDIX.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Andre Edich <andre.edich@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250703114941.3243890-3-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index adf12d7108b5c..ad9a3d91bb8ae 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -262,6 +262,33 @@ int lan87xx_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(lan87xx_read_status);
 
+static int lan87xx_phy_config_init(struct phy_device *phydev)
+{
+	int rc;
+
+	/* The LAN87xx PHY's initial MDI-X mode is determined by the AUTOMDIX_EN
+	 * hardware strap, but the driver cannot read the strap's status. This
+	 * creates an unpredictable initial state.
+	 *
+	 * To ensure consistent and reliable behavior across all boards,
+	 * override the strap configuration on initialization and force the PHY
+	 * into a known state with Auto-MDIX enabled, which is the expected
+	 * default for modern hardware.
+	 */
+	rc = phy_modify(phydev, SPECIAL_CTRL_STS,
+			SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
+			SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
+			SPECIAL_CTRL_STS_AMDIX_STATE_,
+			SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
+			SPECIAL_CTRL_STS_AMDIX_ENABLE_);
+	if (rc < 0)
+		return rc;
+
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
+	return smsc_phy_config_init(phydev);
+}
+
 static int lan874x_phy_config_init(struct phy_device *phydev)
 {
 	u16 val;
@@ -696,7 +723,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-	.config_init	= smsc_phy_config_init,
+	.config_init	= lan87xx_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 	.config_aneg	= lan87xx_config_aneg,
 
-- 
2.39.5



