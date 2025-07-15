Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765C82ECE8D;
	Tue, 15 Jul 2025 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587179; cv=none; b=jy6+hS2WxDJs9M7e04jV0n+Ic7DmG46/AsVqGH76bi8+4qyg69b/EWAPvg3baDpluJbvRUx2MWShmLrm0VsOKCIIQikARV1Bu+C7KOdvwC4wSAliRGa4BR1tFqfWQeZrMEDIVM0PXRbZMYnmupLE1Wv/oTjGzHdlwo/KZL+E7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587179; c=relaxed/simple;
	bh=CwrnpYVnDQM6oFF00Sts2hUNSRkcXbGq2tzwzCUdAOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rl23rjoHxu1unOGqx7b8LGMsBiDYiGv1E616UyC5lqlqqdXIv1ed86BRUYdup1RF8/HeeWHM7k3MNmMGggEi3IGZ0HY4ZLnBV7qeDiY8b2maRBo9YfjkpsbuWFdHx7N1pf1ag55Alg/+fBWyLRgFH6VI7wZSjOCdZ2iS4v7uWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdZRZIFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdZRZIFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0F9C4CEE3;
	Tue, 15 Jul 2025 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587179;
	bh=CwrnpYVnDQM6oFF00Sts2hUNSRkcXbGq2tzwzCUdAOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdZRZIFNolShIQGHqlBN0clvCFgrvR8rTQ+tTCShl9RwFsxpeNN+DBYpcD8mFDJcm
	 wvDXTPhaNhk7GIYxON6bW2Pdq+kHIw/UQXv27g/wHbjEGZEk2ine7GqHQJSfb5wD/b
	 JskuQeyKljkLtcKUkgRcs++TT54rHWsscC4jbP9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 155/192] net: phy: microchip: limit 100M workaround to link-down events on LAN88xx
Date: Tue, 15 Jul 2025 15:14:10 +0200
Message-ID: <20250715130821.135488063@linuxfoundation.org>
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

[ Upstream commit dd4360c0e8504f2f7639c7f5d07c93cfd6a98333 ]

Restrict the 100Mbit forced-mode workaround to link-down transitions
only, to prevent repeated link reset cycles in certain configurations.

The workaround was originally introduced to improve signal reliability
when switching cables between long and short distances. It temporarily
forces the PHY into 10 Mbps before returning to 100 Mbps.

However, when used with autonegotiating link partners (e.g., Intel i350),
executing this workaround on every link change can confuse the partner
and cause constant renegotiation loops. This results in repeated link
down/up transitions and the PHY never reaching a stable state.

Limit the workaround to only run during the PHY_NOLINK state. This ensures
it is triggered only once per link drop, avoiding disruptive toggling
while still preserving its intended effect.

Note: I am not able to reproduce the original issue that this workaround
addresses. I can only confirm that 100 Mbit mode works correctly in my
test setup. Based on code inspection, I assume the workaround aims to
reset some internal state machine or signal block by toggling speeds.
However, a PHY reset is already performed earlier in the function via
phy_init_hw(), which may achieve a similar effect. Without a reproducer,
I conservatively keep the workaround but restrict its conditions.

Fixes: e57cf3639c32 ("net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250709130753.3994461-3-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 5d1ca285d95ba..55822d36889c3 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -332,7 +332,7 @@ static void lan88xx_link_change_notify(struct phy_device *phydev)
 	 * As workaround, set to 10 before setting to 100
 	 * at forced 100 F/H mode.
 	 */
-	if (!phydev->autoneg && phydev->speed == 100) {
+	if (phydev->state == PHY_NOLINK && !phydev->autoneg && phydev->speed == 100) {
 		/* disable phy interrupt */
 		temp = phy_read(phydev, LAN88XX_INT_MASK);
 		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-- 
2.39.5



