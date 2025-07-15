Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252172E338F;
	Tue, 15 Jul 2025 13:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586084; cv=none; b=i1V14lPbrKeZpj4k6CS7sEKKaTKVdt6u/YA9JKudZuduUb52ROJxNM+HNCsWCCgWrA7L+v6h+s9fbZpsZH9wCPDjAlMdMhJIZXqHUucfR+RmSR1m2SK4OEcZp4nzdq5kwHFGY6z1uH2OweyIKDGxyRhLYClCmGtB+RHgM/G68hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586084; c=relaxed/simple;
	bh=zOnBbp5rsUDLICaB81lPfGmFX+CramSE4HzI6WTiPa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDsYrOPig20BtPzI5D+TCR7enf/DTIiEl83yrIKVIqpNOjhQ5XuTngMcKs34ZHNHbmeC9Y8bVbvJf0Fy7Vl7vOGuRomJp8WoNy5yGTOziYsgq8FSqKQLtZ4B0MU8EcbzMnQ81NiF25UEVKRT4WNWniPddcsks2/lpRgsuFORrFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOI4NjeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOI4NjeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EA3C4CEE3;
	Tue, 15 Jul 2025 13:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586084;
	bh=zOnBbp5rsUDLICaB81lPfGmFX+CramSE4HzI6WTiPa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOI4NjeXKZotlCZYRzF3QAVqJekDMYqP43gxyW3Ana3l+PhXHRdf1ouYBywo0eUS3
	 O4ZBQGNCsd4ZWPkWbd1D7zNyyTg2rlx4CNqip4IxoIh2XuN+IyPxL4DdGCe3PLFntH
	 ymlIFO8za1MWOLLSdnkbgbl35r5SZnX3jMtXjsVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/77] net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap
Date: Tue, 15 Jul 2025 15:13:09 +0200
Message-ID: <20250715130752.105599366@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 36dcf6c7f445d..6d9069a53db1d 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -155,7 +155,8 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
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



