Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3382566;
	Tue, 15 Jul 2025 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585820; cv=none; b=qtjSCO011EhqMNxKciQpSjGbS0a8pPFZ7DB6q271jauobjaLJm33JVQs6ASwSJ2TNnne8d0qFp/syMoi8M4Zz0TDNXY89bAu3R0cxU2Ny646bFEqli4oLR2n5L5ByBbiWZX9Wnp+k5NGaOoE+yVBNsS/JmbQxTowHjliWqXP6mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585820; c=relaxed/simple;
	bh=diXtkfvgq7nB15JI+kan0Ak7hPFvx8cocrkKowgJAss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzFQgo9ShUUyQ+bRAjMz0vFlApxq9Bmn1kt0XgADuF8ufzcG692VfVh7IHHt2ciQSvoxmJ0ZtZ5K6QjlGJSeUkBmPe5LrCwRio4ajRZ/nq6EYLuzeDHYjsyhGL27K7cWd9Gf28BQ5QtDrn7GnfbrPJfv+YKV70ivbrolOHZWwK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/7xslWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/7xslWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD3DC4CEE3;
	Tue, 15 Jul 2025 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585819;
	bh=diXtkfvgq7nB15JI+kan0Ak7hPFvx8cocrkKowgJAss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/7xslWTQExmGywFqmz+ZOqRFp3x1DI4eqz/sbz+aFMTRMS8nyEgRets9hXHIV8el
	 iFz78edGnxGpO3Tp7/1iECWCOqDp5nyvoic8RlHAnPCdVGX6EVn67K7ojDCTfKyckT
	 PvG2LtGOovsZP++OFuLEsWF9a2QuwipeK0fCBJUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/109] net: phy: smsc: Force predictable MDI-X state on LAN87xx
Date: Tue, 15 Jul 2025 15:12:36 +0200
Message-ID: <20250715130759.692194278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7f9c4649652b..1ce0ca8048ac6 100644
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
@@ -697,7 +724,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-	.config_init	= smsc_phy_config_init,
+	.config_init	= lan87xx_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 	.config_aneg	= lan87xx_config_aneg,
 
-- 
2.39.5



