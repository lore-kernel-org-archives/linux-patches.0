Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71927217F40;
	Thu, 12 Dec 2024 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015839; cv=none; b=SR5fgL/n/PdFgkKp1bZYbkvhVqEZf9kKHIMxzqW0ciJ/sjXVdR8Kz53HDFQu9Si7IlTCHN0jgkYDTdVx0c+e6PUY0D0Gq4xOFCcQ5UclPe1WQZcIdQkYfkcv8hIYNlr7aBjYestPhOEmHGorY991S39HgQEN3piCET/ifE/pNBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015839; c=relaxed/simple;
	bh=ZvC3dIcTVTA9Gf2knXMsoBhsilCMFrZoe+tBQRivK0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0xCjTp1D+ZMxiU4NvKT3tYiiQk0+rN2YxBwWStwMyx6eGSi9DBZBjSUEnUs8ZllVKPgrJ3CMxNUYJTFBRwXvapFADGHS64iDQ3CfnxrTCWU15wwlt7SHe47dv1k0UM3DqgYki8iujrtJcBxpYiK22wMO6NALKD5PtKONihxAso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSmq1Y8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSmq1Y8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985DDC4CECE;
	Thu, 12 Dec 2024 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015839;
	bh=ZvC3dIcTVTA9Gf2knXMsoBhsilCMFrZoe+tBQRivK0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSmq1Y8uUXfQLeidhyNB3940vwT1u9Z8xC2rephvBKeKKIUKQ039kJ8WNkiAcRaha
	 7wUoDRsZch8VjtHBx1h2MS/96Ma9PZzBT4j9ZAvIPJ/BpdD7F6azD5PeYKgspQ0AnP
	 uXy57Uvoxh0WHHd22u2yZORfBUhmJeokEjkSZJIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/466] net: phy: microchip: Reset LAN88xx PHY to ensure clean link state on LAN7800/7850
Date: Thu, 12 Dec 2024 15:53:18 +0100
Message-ID: <20241212144307.838350073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit ccb989e4d1efe0dd81b28c437443532d80d9ecee ]

Fix outdated MII_LPA data in the LAN88xx PHY, which is used in LAN7800
and LAN7850 USB Ethernet controllers. Due to a hardware limitation, the
PHY cannot reliably update link status after parallel detection when the
link partner does not support auto-negotiation. To mitigate this, add a
PHY reset in `lan88xx_link_change_notify()` when `phydev->state` is
`PHY_NOLINK`, ensuring the PHY starts in a clean state and reports
accurate fixed link parallel detection results.

Fixes: 792aec47d59d9 ("add microchip LAN88xx phy driver")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241125084050.414352-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index d3273bc0da4a1..691969a4910f2 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -351,6 +351,22 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 static void lan88xx_link_change_notify(struct phy_device *phydev)
 {
 	int temp;
+	int ret;
+
+	/* Reset PHY to ensure MII_LPA provides up-to-date information. This
+	 * issue is reproducible only after parallel detection, as described
+	 * in IEEE 802.3-2022, Section 28.2.3.1 ("Parallel detection function"),
+	 * where the link partner does not support auto-negotiation.
+	 */
+	if (phydev->state == PHY_NOLINK) {
+		ret = phy_init_hw(phydev);
+		if (ret < 0)
+			goto link_change_notify_failed;
+
+		ret = _phy_start_aneg(phydev);
+		if (ret < 0)
+			goto link_change_notify_failed;
+	}
 
 	/* At forced 100 F/H mode, chip may fail to set mode correctly
 	 * when cable is switched between long(~50+m) and short one.
@@ -377,6 +393,11 @@ static void lan88xx_link_change_notify(struct phy_device *phydev)
 		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
 		phy_write(phydev, LAN88XX_INT_MASK, temp);
 	}
+
+	return;
+
+link_change_notify_failed:
+	phydev_err(phydev, "Link change process failed %pe\n", ERR_PTR(ret));
 }
 
 /**
-- 
2.43.0



