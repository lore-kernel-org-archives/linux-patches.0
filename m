Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C153351FA6;
	Fri, 21 Nov 2025 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732820; cv=none; b=C7iMEw1znIp4uagQvgrJ7P36gBEy0gq96UftE0b0zAvY6u2bjzjQ/khHR+MhWA7FM/7VUYvPXtreUMabQpyfT1F3RKmBcYeNXJ1vOAM8wTQAxn3QzxzoNZWhs341s0Z8XkjJl4TrZtbvMK19zqb7KC02kyuPOv9DkTMKldsGc+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732820; c=relaxed/simple;
	bh=edq9AjZxs7i0hMHNJpGX7AszfcoBakMVhRm2GtKDrhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1a9K/tMbAu5UCMEYpl6JKunGfqLDFHYKziU7R1ChJZgfXubiM230mCw03eWtZpfGQg2ijW/gL09Ty6+k5COhmY3c699sIVU9f5BAIjAJ+rW/tbCfXL8B/eGiprE2YjbfgZuhYTqbJalumKKFIk3XSJkTQFcQCtOTkC/NULBQos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShlFM+r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShlFM+r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4927BC4CEF1;
	Fri, 21 Nov 2025 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732819;
	bh=edq9AjZxs7i0hMHNJpGX7AszfcoBakMVhRm2GtKDrhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShlFM+r4UozmGuGZOHVYS46Xj+9MApuLZWcPc6M0FeOB8uvzTiy4eK9iJ8i/kreBL
	 Hxvv63i5wc++l3jG9V7ycuhUiwiGsrovoAhaFzIv+MqslrEn6q8Jc3e2SksMkwrN1H
	 W36GqT585WkVieq4swbfSvRYIfK4aZaWG/kcj+N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/529] net: phy: clear link parameters on admin link down
Date: Fri, 21 Nov 2025 14:09:14 +0100
Message-ID: <20251121130240.094487729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df54c137c5f5f..cf171bdd667aa 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1482,6 +1482,19 @@ void phy_state_machine(struct work_struct *work)
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



