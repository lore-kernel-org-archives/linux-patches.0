Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94081634FB;
	Tue, 23 Jan 2024 01:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975036; cv=none; b=CRmqJK3WwUkMACJZbB/Pjh/jJi/Nq9mxR+3EaLy8bPPvMCMv+X+FloHa8By313Kgfo3YdaWe8odhtMiqiWhWirhfzvAmq7IY+GOQPsdvt8zW2VuGJc2PrM2Il+wOV7W3CobpMJwP5Wujg0G2ARlkTGTX6JmFvSzLvTGYR78tcDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975036; c=relaxed/simple;
	bh=YdFkNt9qDB4kBRJq02mMfnDCYRvS/w/aGX5AAoIhpFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXSdatxKzShgJpuMmg6REtRWiuo1bxYao/N5pOWP3GrZQtvO35Yj1+yKwMqFV9T5B3PPykQL2Bfnoyqr22KaiUzwF8AFP3nv3Rtar5IWlKYtA+7nmG8H3+AdwZRlSbGjpjVkQ5hiQs5OQ5ZYhd4pF3CzvwG+kfcLpa3zGRctqyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPV/TQ4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPV/TQ4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AB6C433C7;
	Tue, 23 Jan 2024 01:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975036;
	bh=YdFkNt9qDB4kBRJq02mMfnDCYRvS/w/aGX5AAoIhpFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPV/TQ4ehbuv5aSc9bKn02JmyBseXPEZ3q9x4CAtBM9hoy0vL3J3i4KjbYsFvT8Gc
	 gXwgU/bleMA6/+P5N/kSxNBljD62a6IE3Wfx+PA39kdXbbP+3M7NPAgOiVJg8ev9M4
	 nXcxWrRTy0A1q4ao5qQvO61IIx2lqhsT4TKwNNbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 334/374] net: phy: micrel: populate .soft_reset for KSZ9131
Date: Mon, 22 Jan 2024 15:59:50 -0800
Message-ID: <20240122235756.516596980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit e398822c4751017fe401f57409488f5948d12fb5 ]

The RZ/G3S SMARC Module has 2 KSZ9131 PHYs. In this setup, the KSZ9131 PHY
is used with the ravb Ethernet driver. It has been discovered that when
bringing the Ethernet interface down/up continuously, e.g., with the
following sh script:

$ while :; do ifconfig eth0 down; ifconfig eth0 up; done

the link speed and duplex are wrong after interrupting the bring down/up
operation even though the Ethernet interface is up. To recover from this
state the following configuration sequence is necessary (executed
manually):

$ ifconfig eth0 down
$ ifconfig eth0 up

The behavior has been identified also on the Microchip SAMA7G5-EK board
which runs the macb driver and uses the same PHY.

The order of PHY-related operations in ravb_open() is as follows:
ravb_open() ->
  ravb_phy_start() ->
    ravb_phy_init() ->
      of_phy_connect() ->
        phy_connect_direct() ->
	  phy_attach_direct() ->
	    phy_init_hw() ->
	      phydev->drv->soft_reset()
	      phydev->drv->config_init()
	      phydev->drv->config_intr()
	    phy_resume()
	      kszphy_resume()

The order of PHY-related operations in ravb_close is as follows:
ravb_close() ->
  phy_stop() ->
    phy_suspend() ->
      kszphy_suspend() ->
        genphy_suspend()
	  // set BMCR_PDOWN bit in MII_BMCR

In genphy_suspend() setting the BMCR_PDWN bit in MII_BMCR switches the PHY
to Software Power-Down (SPD) mode (according to the KSZ9131 datasheet).
Thus, when opening the interface after it has been  previously closed (via
ravb_close()), the phydev->drv->config_init() and
phydev->drv->config_intr() reach the KSZ9131 PHY driver via the
ksz9131_config_init() and kszphy_config_intr() functions.

KSZ9131 specifies that the MII management interface remains operational
during SPD (Software Power-Down), but (according to manual):
- Only access to the standard registers (0 through 31) is supported.
- Access to MMD address spaces other than MMD address space 1 is possible
  if the spd_clock_gate_override bit is set.
- Access to MMD address space 1 is not possible.

The spd_clock_gate_override bit is not used in the KSZ9131 driver.

ksz9131_config_init() configures RGMII delay, pad skews and LEDs by
accessesing MMD registers other than those in address space 1.

The datasheet for the KSZ9131 does not specify what happens if registers
from an unsupported address space are accessed while the PHY is in SPD.

To fix the issue the .soft_reset method has been instantiated for KSZ9131,
too. This resets the PHY to the default state before doing any
configurations to it, thus switching it out of SPD.

Fixes: bff5b4b37372 ("net: phy: micrel: add Microchip KSZ9131 initial driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 05a8985d7107..dc209ad8a0fe 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1728,6 +1728,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
+	.soft_reset	= genphy_soft_reset,
 	.config_init	= ksz9131_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-- 
2.43.0



