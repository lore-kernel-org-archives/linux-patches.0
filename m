Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5608E82D7A;
	Mon,  8 Apr 2024 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582139; cv=none; b=VqELO4NrhU97inn0BWKtRrMoOMB7Zb8cb1N+km7FMWK3FzWW42VFJ8AlgUoAl5bqOaxXCHs5iD8Xkf2JSdcuhEsoanilHRBhieqK2JuQsoh/Cb82b+a7gU8mVdc9v1hF1sfCGt6q2w2kAAKHxfbP7lBinzABKAMkwW7c//X6h3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582139; c=relaxed/simple;
	bh=lbjA8vsWh+2m4JtnE/EkO7ZQ+q/5KnIOuqaEUvtLGRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EitPTu5prcXdYgfjmqpiDuIgqtQ/SwlkfVzJGKRP1gJzjdIuVKtMk3lAjJDYfbVwM8m1Rh450ZcsXli3zvKn72uWsrbg6rW/dgrwKDFCgjF2u/Q4brS1SUdroGwaSfiAMB0Wkr3tD55Tjo391i9phfdEfEVRW3VfpZtqw3jsQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vajLjT3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vajLjT3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CEDC433C7;
	Mon,  8 Apr 2024 13:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582139;
	bh=lbjA8vsWh+2m4JtnE/EkO7ZQ+q/5KnIOuqaEUvtLGRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vajLjT3P7XX+DsHWnzOW8KELeEWTJFedqutfQoHTMNLYMI8XmP8JRlM66FW3zDWT4
	 M8/e3n969+/QzMH279tG1adNdSCu2DdOUf6q0k5g8f68MRj0AEx5NGSOb5neNGM/1K
	 zbIgH4HZpItBSkrX60zYtCW/E8BNJNuoHA3XigW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	John Ernberg <john.ernberg@actia.se>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/138] net: fec: Set mac_managed_pm during probe
Date: Mon,  8 Apr 2024 14:58:15 +0200
Message-ID: <20240408125258.745559134@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit cbc17e7802f5de37c7c262204baadfad3f7f99e5 ]

Setting mac_managed_pm during interface up is too late.

In situations where the link is not brought up yet and the system suspends
the regular PHY power management will run. Since the FEC ETHEREN control
bit is cleared (automatically) on suspend the controller is off in resume.
When the regular PHY power management resume path runs in this context it
will write to the MII_DATA register but nothing will be transmitted on the
MDIO bus.

This can be observed by the following log:

    fec 5b040000.ethernet eth0: MDIO read timeout
    Microchip LAN87xx T1 5b040000.ethernet-1:04: PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0xc8 returns -110
    Microchip LAN87xx T1 5b040000.ethernet-1:04: PM: failed to resume: error -110

The data written will however remain in the MII_DATA register.

When the link later is set to administrative up it will trigger a call to
fec_restart() which will restore the MII_SPEED register. This triggers the
quirk explained in f166f890c8f0 ("net: ethernet: fec: Replace interrupt
driven MDIO with polled IO") causing an extra MII_EVENT.

This extra event desynchronizes all the MDIO register reads, causing them
to complete too early. Leading all reads to read as 0 because
fec_enet_mdio_wait() returns too early.

When a Microchip LAN8700R PHY is connected to the FEC, the 0 reads causes
the PHY to be initialized incorrectly and the PHY will not transmit any
ethernet signal in this state. It cannot be brought out of this state
without a power cycle of the PHY.

Fixes: 557d5dc83f68 ("net: fec: use mac-managed PHY PM")
Closes: https://lore.kernel.org/netdev/1f45bdbe-eab1-4e59-8f24-add177590d27@actia.se/
Signed-off-by: Wei Fang <wei.fang@nxp.com>
[jernberg: commit message]
Signed-off-by: John Ernberg <john.ernberg@actia.se>
Link: https://lore.kernel.org/r/20240328155909.59613-2-john.ernberg@actia.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 51eb30c20c7cf..ebff14b0837d9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2236,8 +2236,6 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
-	phy_dev->mac_managed_pm = true;
-
 	phy_attached_info(phy_dev);
 
 	return 0;
@@ -2249,10 +2247,12 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	bool suppress_preamble = false;
+	struct phy_device *phydev;
 	struct device_node *node;
 	int err = -ENXIO;
 	u32 mii_speed, holdtime;
 	u32 bus_freq;
+	int addr;
 
 	/*
 	 * The i.MX28 dual fec interfaces are not equal.
@@ -2362,6 +2362,13 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		goto err_out_free_mdiobus;
 	of_node_put(node);
 
+	/* find all the PHY devices on the bus and set mac_managed_pm to true */
+	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+		phydev = mdiobus_get_phy(fep->mii_bus, addr);
+		if (phydev)
+			phydev->mac_managed_pm = true;
+	}
+
 	mii_cnt++;
 
 	/* save fec0 mii_bus */
-- 
2.43.0



