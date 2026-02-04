Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101CB42189F;
	Wed,  4 Feb 2026 15:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218758; cv=none; b=SepYrN6lrgMPirriAyT9BTKTRasVAZvtdRnA/vu/krH1ajOUug0EwQEefYfnJCtkv5H5Lik/ESpERzzBodJRBQmckyCusv8ivLc24zN5U+LDWumN6nqt3PpX9tazheSqRbhz6fyFtlUAjeXpA/B/ljEQv0JZ7B9dIqvKQFBM7bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218758; c=relaxed/simple;
	bh=qXVa7UPaucZc6AQYQ45yFE/2Ats9LRPiWSCCZea3nBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFg/hz7J1Xbq4rSFe532oRL0aoBL4fCFyl2UdOV18dCzeIPXIv9SQtc+Ql5b//Y3HceXePXBd8r+d8LUEThSK/C+RNsQej/xknItT33Q7PUgV3UQn7sYjv/A2DNT53d7dIPPUq+tEqUhibVqeG14h0MPYkK1hXbOZHWTHqcPosk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhXINzIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhXINzIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FE9C4CEF7;
	Wed,  4 Feb 2026 15:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218757;
	bh=qXVa7UPaucZc6AQYQ45yFE/2Ats9LRPiWSCCZea3nBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhXINzIerWc5psoYaRzqM+qvlYXSCZEqtPdaAdqb/lmbgQCEorGt03C8qOXICO94c
	 rtoqMcApdagKDQQTrabqoK4ZYeRDZCXTLc5ETD1JtD1ZatNxA9p+sJWvb4mIIGb/xl
	 +iuigzITJRQRwp2xs6ngU8KbSrdlrZ9YuZJV+aHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 19/87] net: phy: micrel: fix clk warning when removing the driver
Date: Wed,  4 Feb 2026 15:40:17 +0100
Message-ID: <20260204143847.602335571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 2aa1545ba8d4801fba5be83a404e28014b80196a ]

Since the commit 25c6a5ab151f ("net: phy: micrel: Dynamically control
external clock of KSZ PHY"), the clock of Micrel PHY has been enabled
by phy_driver::resume() and disabled by phy_driver::suspend(). However,
devm_clk_get_optional_enabled() is used in kszphy_probe(), so the clock
will automatically be disabled when the device is unbound from the bus.
Therefore, this could cause the clock to be disabled twice, resulting
in clk driver warnings.

For example, this issue can be reproduced on i.MX6ULL platform, and we
can see the following logs when removing the FEC MAC drivers.

$ echo 2188000.ethernet > /sys/bus/platform/drivers/fec/unbind
$ echo 20b4000.ethernet > /sys/bus/platform/drivers/fec/unbind
[  109.758207] ------------[ cut here ]------------
[  109.758240] WARNING: drivers/clk/clk.c:1188 at clk_core_disable+0xb4/0xd0, CPU#0: sh/639
[  109.771011] enet2_ref already disabled
[  109.793359] Call trace:
[  109.822006]  clk_core_disable from clk_disable+0x28/0x34
[  109.827340]  clk_disable from clk_disable_unprepare+0xc/0x18
[  109.833029]  clk_disable_unprepare from devm_clk_release+0x1c/0x28
[  109.839241]  devm_clk_release from devres_release_all+0x98/0x100
[  109.845278]  devres_release_all from device_unbind_cleanup+0xc/0x70
[  109.851571]  device_unbind_cleanup from device_release_driver_internal+0x1a4/0x1f4
[  109.859170]  device_release_driver_internal from bus_remove_device+0xbc/0xe4
[  109.866243]  bus_remove_device from device_del+0x140/0x458
[  109.871757]  device_del from phy_mdio_device_remove+0xc/0x24
[  109.877452]  phy_mdio_device_remove from mdiobus_unregister+0x40/0xac
[  109.883918]  mdiobus_unregister from fec_enet_mii_remove+0x40/0x78
[  109.890125]  fec_enet_mii_remove from fec_drv_remove+0x4c/0x158
[  109.896076]  fec_drv_remove from device_release_driver_internal+0x17c/0x1f4
[  109.962748] WARNING: drivers/clk/clk.c:1047 at clk_core_unprepare+0xfc/0x13c, CPU#0: sh/639
[  109.975805] enet2_ref already unprepared
[  110.002866] Call trace:
[  110.031758]  clk_core_unprepare from clk_unprepare+0x24/0x2c
[  110.037440]  clk_unprepare from devm_clk_release+0x1c/0x28
[  110.042957]  devm_clk_release from devres_release_all+0x98/0x100
[  110.048989]  devres_release_all from device_unbind_cleanup+0xc/0x70
[  110.055280]  device_unbind_cleanup from device_release_driver_internal+0x1a4/0x1f4
[  110.062877]  device_release_driver_internal from bus_remove_device+0xbc/0xe4
[  110.069950]  bus_remove_device from device_del+0x140/0x458
[  110.075469]  device_del from phy_mdio_device_remove+0xc/0x24
[  110.081165]  phy_mdio_device_remove from mdiobus_unregister+0x40/0xac
[  110.087632]  mdiobus_unregister from fec_enet_mii_remove+0x40/0x78
[  110.093836]  fec_enet_mii_remove from fec_drv_remove+0x4c/0x158
[  110.099782]  fec_drv_remove from device_release_driver_internal+0x17c/0x1f4

After analyzing the process of removing the FEC driver, as shown below,
it can be seen that the clock was disabled twice by the PHY driver.

fec_drv_remove()
  --> fec_enet_close()
    --> phy_stop()
      --> phy_suspend()
        --> kszphy_suspend() #1 The clock is disabled
  --> fec_enet_mii_remove()
    --> mdiobus_unregister()
      --> phy_mdio_device_remove()
        --> device_del()
          --> devm_clk_release() #2 The clock is disabled again

Therefore, devm_clk_get_optional() is used to fix the above issue. And
to avoid the issue mentioned by the commit 985329462723 ("net: phy:
micrel: use devm_clk_get_optional_enabled for the rmii-ref clock"), the
clock is enabled by clk_prepare_enable() to get the correct clock rate.

Fixes: 25c6a5ab151f ("net: phy: micrel: Dynamically control external clock of KSZ PHY")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260126081544.983517-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 5e5a5010932c1..f0c068075322f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2268,11 +2268,21 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	kszphy_parse_led_mode(phydev);
 
-	clk = devm_clk_get_optional_enabled(&phydev->mdio.dev, "rmii-ref");
+	clk = devm_clk_get_optional(&phydev->mdio.dev, "rmii-ref");
 	/* NOTE: clk may be NULL if building without CONFIG_HAVE_CLK */
 	if (!IS_ERR_OR_NULL(clk)) {
-		unsigned long rate = clk_get_rate(clk);
 		bool rmii_ref_clk_sel_25_mhz;
+		unsigned long rate;
+		int err;
+
+		err = clk_prepare_enable(clk);
+		if (err) {
+			phydev_err(phydev, "Failed to enable rmii-ref clock\n");
+			return err;
+		}
+
+		rate = clk_get_rate(clk);
+		clk_disable_unprepare(clk);
 
 		if (type)
 			priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
@@ -2290,13 +2300,12 @@ static int kszphy_probe(struct phy_device *phydev)
 		}
 	} else if (!clk) {
 		/* unnamed clock from the generic ethernet-phy binding */
-		clk = devm_clk_get_optional_enabled(&phydev->mdio.dev, NULL);
+		clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
 	}
 
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	clk_disable_unprepare(clk);
 	priv->clk = clk;
 
 	if (ksz8041_fiber_mode(phydev))
-- 
2.51.0



