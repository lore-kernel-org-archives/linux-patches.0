Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D382561AE;
	Tue, 15 Jul 2025 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587283; cv=none; b=mlLq4holxkrifWBNr/PEb0AVF53SWtV3mBonTCEwWC5xac6IdqkFtuEiy/s+SKC+i8ZOvzzcMUk9JHkaxwWAWvJZwgcPo52EX2Rc28+++InNOdbhgx2OZKniJhyYq5C2Baxgg5Qggm0xiNNUxPU8nighlebEIrqeovAPo05HMUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587283; c=relaxed/simple;
	bh=A/rxr6PrC72lSGxn5hPRHdKrAqAJH7YJPtYKMlw+XuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCu4CswPwSBKnVARAhM4yb6q7oZNZdo1Oq2QyhkL9B0vWU7xoRmpVnJPYzOTU37IsBu0Ti6PBrBwfvyW0EMixRsBtXuuAiHwSwBENHcapFSUgezh/dt3xLmh8/9uD2fehKXkN/22aEdOddEogG7OdeyjlKJvir89BuMM+giEnYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9nrrhOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9nrrhOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B01C4CEE3;
	Tue, 15 Jul 2025 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587283;
	bh=A/rxr6PrC72lSGxn5hPRHdKrAqAJH7YJPtYKMlw+XuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9nrrhOwdhA+9HYjeR2JgXZ60CkUcAwgt7EcuWky7OPmYjhiaUabL9vQSRrJzTEGG
	 D+6kbktARc0KbMBW/voluukATbiyFe/nIn7GstBFeU2jWe4sLDUiDmsVRnzd0k0qAJ
	 ApewYkDzrg2uGCQJQTrtbDSS4k9qPnuyUkNsJYKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/88] net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap
Date: Tue, 15 Jul 2025 15:13:48 +0200
Message-ID: <20250715130754.999650393@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit a141af8eb2272ab0f677a7f2653874840bc9b214 ]

Correct the Auto-MDIX configuration to ensure userspace settings are
respected when the feature is disabled by the AUTOMDIX_EN hardware strap.

The LAN9500 PHY allows its default MDI-X mode to be configured via a
hardware strap. If this strap sets the default to "MDI-X off", the
driver was previously unable to enable Auto-MDIX from userspace.

When handling the ETH_TP_MDI_AUTO case, the driver would set the
SPECIAL_CTRL_STS_AMDIX_ENABLE_ bit but neglected to set the required
SPECIAL_CTRL_STS_OVRRD_AMDIX_ bit. Without the override flag, the PHY
falls back to its hardware strap default, ignoring the software request.

This patch corrects the behavior by also setting the override bit when
enabling Auto-MDIX. This ensures that the userspace configuration takes
precedence over the hardware strap, allowing Auto-MDIX to be enabled
correctly in all scenarios.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Andre Edich <andre.edich@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250703114941.3243890-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index df2c5435c5c49..8726619466858 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -148,7 +148,8 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 			SPECIAL_CTRL_STS_AMDIX_STATE_;
 		break;
 	case ETH_TP_MDI_AUTO:
-		val = SPECIAL_CTRL_STS_AMDIX_ENABLE_;
+		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
+			SPECIAL_CTRL_STS_AMDIX_ENABLE_;
 		break;
 	default:
 		return genphy_config_aneg(phydev);
-- 
2.39.5



