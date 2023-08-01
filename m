Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28751F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7C7C433C9;
	Tue,  1 Aug 2023 09:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882458;
	bh=WZrPgYn4mK09p593yZiBJ+4I8iCmtgoH3isdPsOCeCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRO6Nl2gEEykalrOCU3/TXvXEpDR6IIJ5X+SetB+UtOtIr6iadk/UwDpOU9I9m8Xx
	 9PyIwNG8RUXUZLBZW1KlifqEe84tsgmA6ALpvHcccLPEsKdPAh+DM4deaotuXdffcK
	 suvDgJ9Y9+kmTt2vYa8Gljnm6QWw5e8hbYJJLHF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/228] net: phy: marvell10g: fix 88x3310 power up
Date: Tue,  1 Aug 2023 11:19:02 +0200
Message-ID: <20230801091925.885129616@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit c7b75bea853daeb64fc831dbf39a6bbabcc402ac ]

Clear MV_V2_PORT_CTRL_PWRDOWN bit to set power up for 88x3310 PHY,
it sometimes does not take effect immediately. And a read of this
register causes the bit not to clear. This will cause mv3310_reset()
to time out, which will fail the config initialization. So add a delay
before the next access.

Fixes: c9cc1c815d36 ("net: phy: marvell10g: place in powersave mode at probe")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell10g.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 383a9c9f36e54..057d294a273d8 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -328,6 +328,13 @@ static int mv3310_power_up(struct phy_device *phydev)
 	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
 				 MV_V2_PORT_CTRL_PWRDOWN);
 
+	/* Sometimes, the power down bit doesn't clear immediately, and
+	 * a read of this register causes the bit not to clear. Delay
+	 * 100us to allow the PHY to come out of power down mode before
+	 * the next access.
+	 */
+	udelay(100);
+
 	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 ||
 	    priv->firmware_ver < 0x00030000)
 		return ret;
-- 
2.39.2



