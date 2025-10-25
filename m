Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB0308F15;
	Sat, 25 Oct 2025 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409087; cv=none; b=SJN47hvVGUdOiWrhD9oc9CiDiP2EFMSXB0KGhfgL5Fibjs8C0u+wbGYilWZloLDyQ8i4Qo3w8rppi8iYAHlBd9MYP2krTH9NKE3ewa/lRLJiBJIX9c6ugAVyQTkSFTbMLk3P/Z4KmV5VWgjzqAHUcjHg683PKnHzyu4kp/fnqgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409087; c=relaxed/simple;
	bh=dtRqBps7HNYjOjd7L3qSxUDDs2O4Z5CyFLs4nFhe+tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwNgYZ01m7WnsPscYw9BwwNie7qiakOjLUhcJJR04/RFT+sjHoFoCM4nDMy/0JaAgSZ6jxWWI6IMbs+g2NGTWRIpHonrWvppnJxv2oUsct65Sl7iWJVBmPct+/1Qe4tSLuBHTKu0aoqSA2+JX6fJWJSyzto4bnMtRl/RXoacTiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyOzOI6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyOzOI6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9A9C4CEF5;
	Sat, 25 Oct 2025 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409084;
	bh=dtRqBps7HNYjOjd7L3qSxUDDs2O4Z5CyFLs4nFhe+tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyOzOI6QjC3qKxByz78um/XNs3zN8qPHSU/j82YQYe0qEMvNk6qkTNvLYjgrxvwJy
	 omMeKSVnY5JNVDT4VanX5XKrk+NXdHnliYJTCRbw7eQwKZ3xO9FsLaKuaK4CLcnT3/
	 LYAmLjFX+TSDA32Rmb5YB3p7BTOLQXj0VC/TpbyaNrkU7/SZag1tkGrH9PfWUExnWF
	 6eljRisJkoOHPNX41+VyBk4mYZRJ1j/8QepdW1/WvTBcZ5fkoaZWBmSqz/ceTMZqQF
	 3AJk3CeITh7Ubn8u/Q/eZ0mEVw8/0R5iD+zNHz49aFF8ZY2PgnODS48rjUDHU+oV62
	 mBeJJ4ahjUGuA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] net: phy: clear link parameters on admin link down
Date: Sat, 25 Oct 2025 11:57:07 -0400
Message-ID: <20251025160905.3857885-196-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- `_phy_state_machine()` now clears the runtime status fields (speed,
  duplex, master/slave, MDI-X, partner advertising) when transitioning a
  previously up PHY into `PHY_HALTED`, so administrative link-down stops
  reporting stale values to ethtool (`drivers/net/phy/phy.c:1551-1561`).
- These members are exactly what `phy_ethtool_ksettings_get()` surfaces
  to user space, so leaving them stale makes `ethtool link`/`ip link`
  misreport the link after an admin down; the new resets ensure the
  user-visible API reflects that the link is unknown/down
  (`drivers/net/phy/phy.c:273-296`).
- The change is careful to leave forced-mode configurations intact
  (`phydev->autoneg == AUTONEG_ENABLE` guard at
  `drivers/net/phy/phy.c:1552-1555`) and avoids touching hardware
  registers, which keeps the risk of behavioural regressions low.
- Master/slave state is only reset when the feature is supported, while
  diagnostics in `PHY_ERROR` still retain the last negotiated
  information thanks to the guarded fall-through
  (`drivers/net/phy/phy.c:1556-1569`).
- The touched fields are long-standing members of `struct phy_device`
  (`include/linux/phy.h:665-713`), so the patch is self-contained,
  architecture-neutral, and aligns with an earlier mainline fix that
  already clears EEE runtime flags on the same state transition.

 drivers/net/phy/phy.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e046dd858f151..02da4a203ddd4 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1548,6 +1548,19 @@ static enum phy_state_work _phy_state_machine(struct phy_device *phydev)
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

