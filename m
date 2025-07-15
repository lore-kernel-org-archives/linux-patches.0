Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A6137923;
	Tue, 15 Jul 2025 13:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585817; cv=none; b=Rqhg2TseHGngTtHoveGjl9jAXRqvYMaeW25mF3cO1H0G8T+5JZgjhmaNN2Cq0YeTT7u6fZmnK+B71zmS8dEBuwRnRhKPsBeXa2GgiaE+8G+hbKPpP3Gd3YJDQqPs17gAkI5KyT1usrMtceQLVHDbUsuKNtvhQr6TC7FPZZ5fhJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585817; c=relaxed/simple;
	bh=TRH+Kt9ld09981792TzKffyBwOPjWv2/K69A1xaKFh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7sfTxKjOwsp8NGUyyF3CC0vLEdSE4tu7FshRl7j+5FG8DwVTshgi0Igj4HziJqzXP+4n6yrVUgqjx68in8j22WSSAg2XoyFF/bC41CJ+DEy77rHG7lScMGWo8P7FIulEos5CbXHKAwaMdEaqA0Qcg0Yaw/QGbULXoLS9cwkp9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nlBOR0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nlBOR0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC21C4CEE3;
	Tue, 15 Jul 2025 13:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585816;
	bh=TRH+Kt9ld09981792TzKffyBwOPjWv2/K69A1xaKFh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nlBOR0rqx0wlPrqmbp1B2WJfbvhy8qzXMDT5gxQ6U2A33vuswSZRteTF17aVHjJJ
	 0w1P/T9SXgzXH9buZaTUGZuhg+CxGesLL9jAAX3KibvEjAGpVzony/P2F59mPuGnHo
	 7I0GLifVCqZHDbWdE7eFHfc4QjGqgrUhheY+/Gwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andre Edich <andre.edich@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/109] net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap
Date: Tue, 15 Jul 2025 15:12:35 +0200
Message-ID: <20250715130759.651714434@linuxfoundation.org>
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
index c88edb19d2e71..b7f9c4649652b 100644
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



