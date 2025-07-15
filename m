Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332719F420;
	Tue, 15 Jul 2025 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585430; cv=none; b=cq6nq5IltDH/dgZYch1h9vPYx0FcRvdY06xkjrpdxSQXgNb+6X972lrnfBtUm9JDwQNVZKxQ9rIeUnQ7cPNPwqJMen4cONqMh5NEv/TyLY/DutKfYlbhIFgH5KOuLSu+cP/T9ABxFo17WOrndP+kljS3NsZUbzIsnIJwXg3Xarg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585430; c=relaxed/simple;
	bh=YxtUF5IhwwxS8pvs2Y3upleyRoPK9fXRTWnhcY+/P7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEhYtBRHUOjosTqmagst5W9gPYDxuLTDuTA6dyWUuiYu1gEAcrygsIv+8Wsxu53FpfSoCe7hQ+y4x/1mose2lLfbdbKHXtIKbYvNMtB/aHTojKv6WXf0VkeVQ7tDTXZ/B7MBScnQh1V/4ufelP2QxRLwcNeudpe4i2CNqlKYaTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHrJs56U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHrJs56U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E13C4CEE3;
	Tue, 15 Jul 2025 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585430;
	bh=YxtUF5IhwwxS8pvs2Y3upleyRoPK9fXRTWnhcY+/P7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHrJs56U0QWi73Y67OiHaTKyeUf4XnSthlWTN8F6/kJfg0pgD21Qrfjc51JnWO3UX
	 iELPuceSYfSXkRV1gmil7GzJvo9DRsN63dB+85DpacNbSRcFbxHn62SkCUNkmTtd6O
	 l9l96FIcyp7SkVZxepNfExxg2Ew9vGehqeQMK5rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/163] net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap
Date: Tue, 15 Jul 2025 15:11:45 +0200
Message-ID: <20250715130810.246139327@linuxfoundation.org>
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
index 150aea7c9c367..871b7d42cdae7 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -167,7 +167,8 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
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



