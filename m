Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CE7214210;
	Tue, 11 Nov 2025 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824136; cv=none; b=My3pN3gmPpI/JfXiFgwaWbNs5EoqOkZ7dt1Cc6mKyIgmZfGpAyZT0XEm2L37LNaQE8UXS68GoDDvJ/doCY3XO5m+IQ+F0kNapP299BjMfM1Ti/fHcxXLrXtVhDl7gjNlaJHP6Lb3Mvk2gPLz4GWDL3bc8JIcy0567VwXgBdd670=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824136; c=relaxed/simple;
	bh=rZzU+lPMGoSSS/N+yQacbxD2VpimDeeVlUPszSZuXVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVDq2DHsv+TOjfGsI2ib8bzHD4FFKK4yThaF3mHwhNMW3E0JoIKzdIxYoylUHAWoOsuJ0gbzSAtO7SSp2R98crD/kqixPAePZ8gxdZevI0g7TcmbLSIjEei1LhuB65kMdwLYK8+ZRhcx+TgS5K5SJJwd05sHZcS22alF5PRD6RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIU1oF0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIU1oF0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F0C4CEFB;
	Tue, 11 Nov 2025 01:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824136;
	bh=rZzU+lPMGoSSS/N+yQacbxD2VpimDeeVlUPszSZuXVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIU1oF0XylF7kOTGz++PQIHCky/Oy3MrKKnRDQxa5WC91+htC/P1370Fk3LnMODce
	 deodahnE0iC8+YH7GFTPsEy0TMYyUm6dJcW0hWLw0vJe4NvkLCQn6A6CgN39llBAxC
	 l9eaDssJCcm43acw3/YwzGrqbnmscpZQDwKEeHoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 394/565] net: phy: clear link parameters on admin link down
Date: Tue, 11 Nov 2025 09:44:10 +0900
Message-ID: <20251111004535.736266718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 60f887b1290b43a4f5a3497982a725687b193fa4 ]

When a PHY is halted (e.g. `ip link set dev lan2 down`), several
fields in struct phy_device may still reflect the last active
connection. This leads to ethtool showing stale values even though
the link is down.

Reset selected fields in _phy_state_machine() when transitioning
to PHY_HALTED and the link was previously up:

- speed/duplex -> UNKNOWN, but only in autoneg mode (in forced mode
  these fields carry configuration, not status)
- master_slave_state -> UNKNOWN if previously supported
- mdix -> INVALID (state only, same meaning as "unknown")
- lp_advertising -> always cleared

The cleanup is skipped if the PHY is in PHY_ERROR state, so the
last values remain available for diagnostics.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250917094751.2101285-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index c9cfdc33fc5f1..707a6ff5242bd 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1477,6 +1477,19 @@ static enum phy_state_work _phy_state_machine(struct phy_device *phydev)
 		}
 		break;
 	case PHY_HALTED:
+		if (phydev->link) {
+			if (phydev->autoneg == AUTONEG_ENABLE) {
+				phydev->speed = SPEED_UNKNOWN;
+				phydev->duplex = DUPLEX_UNKNOWN;
+			}
+			if (phydev->master_slave_state !=
+						MASTER_SLAVE_STATE_UNSUPPORTED)
+				phydev->master_slave_state =
+						MASTER_SLAVE_STATE_UNKNOWN;
+			phydev->mdix = ETH_TP_MDI_INVALID;
+			linkmode_zero(phydev->lp_advertising);
+		}
+		fallthrough;
 	case PHY_ERROR:
 		if (phydev->link) {
 			phydev->link = 0;
-- 
2.51.0



