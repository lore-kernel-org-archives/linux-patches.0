Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C72F2C54;
	Tue, 15 Jul 2025 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587915; cv=none; b=Fae7cABPGiMo7SPPr0WbLBWUuKSHLYOivGc6y8oU9PoCpznfsyzP+Icm8MVAsPcRq7wemwurJ2+D6+JcS/IUBEo3gjxTkJeiEK5QK7DmyTgx59xlR85eEmnhMhOl6mLGdA4MYB5xsyQhU015t1lWQsSYF71QzN4dFS3rha2rzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587915; c=relaxed/simple;
	bh=0cS7Qvtka5M1gD+Tzk+1y/r74bbeIBU5CMyQTH/9P+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlzgoUCR7oGu6nNk0SJvj0PRS7p1tlQEIi06O1/ZSc/GY9x/YuFxFPa5/Ic9gdvGPyKSgeEuCgbHc6XDQMwLRsGZiR7MLObzlJX1420bSE0RyBnwpmOzIvGCCEfbcVzgtlvVoWy71/gCmr7iGZzxVyVIzQU9TC71J0KLpxxHmV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrGVKHGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrGVKHGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61919C4CEF1;
	Tue, 15 Jul 2025 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587915;
	bh=0cS7Qvtka5M1gD+Tzk+1y/r74bbeIBU5CMyQTH/9P+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrGVKHGgpwBkFsDvSWznbh5j9vMntLkhKAxtXSyfxOS/hnGcgoZsdV0Rnd+dcrNXq
	 7mezVhaV4YggGFYCgLqGq3LWlcAPSNRW4yGwgLWAKFgNMz1DilqfsDINaNYWrIsh3E
	 WqXRR7XZadUdQZdGcV5A0RLrCgF/MbNg7mM/N2VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/208] net: phy: microchip: limit 100M workaround to link-down events on LAN88xx
Date: Tue, 15 Jul 2025 15:14:59 +0200
Message-ID: <20250715130818.559109743@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 375bbd60b38af..e6ad7d29a0559 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -335,7 +335,7 @@ static void lan88xx_link_change_notify(struct phy_device *phydev)
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



