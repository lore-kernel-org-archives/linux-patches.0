Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBB119E96D;
	Wed,  4 Feb 2026 15:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219087; cv=none; b=RyaGHdffxhFTAWx6xJDvwpEh0OAhORbvUIf5dnDxb8u4QN10A3SSrRzaBXryhBO69pZhV+nIHkjq2BZAPOmFXmwt+9uZNwJbM5g/J/KS2YhkJxFQ2l5W3p3dmE3V0Z5kwDcgH6S+V0+o/EtSrF2kccwHpR1LXH4ZhPS7jk+AP8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219087; c=relaxed/simple;
	bh=8hhas2UQSbpLOqL14Sp7IOBu0WtazTDRkOWWuYI7Yeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOyy9sAgCJzY9UKsnWFJX3cUJuzKT0atDf5FJfXu/7RJxnPbQqb6rwEvQ/7yTeRhxfcnI1CIPSIlYPbuJq5QY6uAE7jVQe34meKyh/QqnL55vm7cpZrPNHwMWWsW00mzROCIFl4SkR929vew/rqjFyVGxG5wKsFXRwhrRTB1vTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpdv4s2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpdv4s2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C273C4CEF7;
	Wed,  4 Feb 2026 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219087;
	bh=8hhas2UQSbpLOqL14Sp7IOBu0WtazTDRkOWWuYI7Yeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpdv4s2ITaFPhbc8ByV3DZF3hlFVA3MtTIsQiedQrOgB1DlwbRKYmqyygdJ/oKCBx
	 KacnpTF3C0VowO2pLcgK8mTGJUY5lAHWx2WKK9gyn0hLQMrBdq3xzQPEXqB8m6jaNr
	 9iWd0K+TXgjIrlEeqgDTxM8Djun6LbCKKgWsexxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/122] net: phy: micrel: fix clk warning when removing the driver
Date: Wed,  4 Feb 2026 15:40:12 +0100
Message-ID: <20260204143852.946702344@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 01c87c9b77020..bc19880107ae4 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2541,11 +2541,21 @@ static int kszphy_probe(struct phy_device *phydev)
 
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
@@ -2563,13 +2573,12 @@ static int kszphy_probe(struct phy_device *phydev)
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



