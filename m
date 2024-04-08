Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101EA81741;
	Mon,  8 Apr 2024 13:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582647; cv=none; b=KnVhM/yfOgwFvtzJKpzon0pIyP0onl8MYwvPnpZvsKRuF9I5CnekX1v0IQHB9XL9pg2GCb3ffTuoO/0Gx6HsDV0k6WjgyhMU8n4A6clL0D1+nbEDgDoBPpkrTfuPZPdFuAdW3rDBFPMV+gXQsxYvQTQUQapr0q8+hEmehPY3Ldo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582647; c=relaxed/simple;
	bh=XSlTcuegJI/BQZdFpj1QO8UtMaux801wXGIDR52qFQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hd8dMmYMVDttgCetisugzOJnNiWG2yJlPDkec9Qd3dWnUW4gFXju4becad/QDHhWx8hgLRYDu8rj4eKR4HQTam/GKk8Q1aAivsQgDU0A4AgR1pyIjO2D5HmPTY7Dn2DYrzOUtR/op4uODNn9j7k6lpYSp+YT4Az5yuXOk5pCaik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uec3cwzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uec3cwzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A83FC433F1;
	Mon,  8 Apr 2024 13:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582646;
	bh=XSlTcuegJI/BQZdFpj1QO8UtMaux801wXGIDR52qFQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uec3cwzzr7k9fKJbrEQML7CtAMpTW/gMHmVDsXvWqO74yGLglyqi5QT4ZuPt56cga
	 mbsOmzDntc8qh61n3NUay40hAI3twfkE/CCtEnsTX+LKRDqdXuS8WTUlenYGKdhaTv
	 LyXt+EDQt8WIipMOdVXKJsGM2Av9Ch4V7DVWr45Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	John Ernberg <john.ernberg@actia.se>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 109/252] net: fec: Set mac_managed_pm during probe
Date: Mon,  8 Apr 2024 14:56:48 +0200
Message-ID: <20240408125310.023644817@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit cbc17e7802f5de37c7c262204baadfad3f7f99e5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2381,8 +2381,6 @@ static int fec_enet_mii_probe(struct net
 	fep->link = 0;
 	fep->full_duplex = 0;
 
-	phy_dev->mac_managed_pm = true;
-
 	phy_attached_info(phy_dev);
 
 	return 0;
@@ -2394,10 +2392,12 @@ static int fec_enet_mii_init(struct plat
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
@@ -2511,6 +2511,13 @@ static int fec_enet_mii_init(struct plat
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


