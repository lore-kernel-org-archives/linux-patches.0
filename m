Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E262E1734;
	Tue, 15 Jul 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585667; cv=none; b=OR3dE0DKkB6oHrsMPGHhbrKppgnLk4CKETjBE9yET4iCBEz6S6hYLxiyx6RSKTiThrV19Uej/LlOlXucHmyZfgX0rgkC7ERZ6TNnF8+HyzV8jLrR0UKphkdqdN9VBpWsA+fGBAxBk/tFvQwQncTp1GJreTqgwXzwJ4lBldsAuaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585667; c=relaxed/simple;
	bh=/J20ZSQZpsQySrOeeiZM4FT2/yytU/IiMq1dR7odv/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pw+t9mdG5C9Mdc5CLJVqVKTWi7Qynp29z3Ifm/fzg9HPz9a1H0h0lvt2jpr89C0oaUDAiZz4DLprUodrwkj9+KWumeiP1N8FyE2EOOdBaCy6vmrfnvCBuA8kbBzJdNsAMJ83N8hDpd4jtim+lEcPM+7/xCpLFkrW+Vo8huMTfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+7N0LAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+7N0LAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13826C4CEF1;
	Tue, 15 Jul 2025 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585667;
	bh=/J20ZSQZpsQySrOeeiZM4FT2/yytU/IiMq1dR7odv/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+7N0LAPlTj6BUX2mrVYVHYSmPCEhxIwD5sGnS1mUvF48OA6mf3QO+Vm8LQ83TCQK
	 MpHBQNgq8ufrLvf0NGlQrjp5s5Rb2kEJb8UZX4MQAhWCdI9pEr+78hoR4tu8OC8ww1
	 /Y5uu6ZUGJrMtLycKNfHqT46kF2RYAUuFtbptqfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/163] net: phy: microchip: Use genphy_soft_reset() to purge stale LPA bits
Date: Tue, 15 Jul 2025 15:13:15 +0200
Message-ID: <20250715130813.939372537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit b4517c363e0e005c7f81ae3be199eec68e87f122 ]

Enable .soft_reset for the LAN88xx PHY driver by assigning
genphy_soft_reset() to ensure that the phylib core performs a proper
soft reset during reconfiguration.

Previously, the driver left .soft_reset unimplemented, so calls to
phy_init_hw() (e.g., from lan88xx_link_change_notify()) did not fully
reset the PHY. As a result, stale contents in the Link Partner Ability
(LPA) register could persist, causing the PHY to incorrectly report
that the link partner advertised autonegotiation even when it did not.

Using genphy_soft_reset() guarantees a clean reset of the PHY and
corrects the false autoneg reporting in these scenarios.

Fixes: ccb989e4d1ef ("net: phy: microchip: Reset LAN88xx PHY to ensure clean link state on LAN7800/7850")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250709130753.3994461-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index e3a5961dced9b..c9b6ede7ac6ac 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -486,6 +486,7 @@ static struct phy_driver microchip_phy_driver[] = {
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
 	.link_change_notify = lan88xx_link_change_notify,
+	.soft_reset	= genphy_soft_reset,
 
 	/* Interrupt handling is broken, do not define related
 	 * functions to force polling.
-- 
2.39.5



