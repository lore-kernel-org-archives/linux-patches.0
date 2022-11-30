Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3120279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC428C433D6;
	Wed, 30 Nov 2022 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834064;
	bh=ySM7WMAUi+iHkTm/tXD90O6rNr2qYnNWawf/pNYiTtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v815capHdHqtLiMxagaCWC2Y+yNMDjBI40tE8aamRkZltCf/eoWXihItqV8TkVRez
	 cKM71rB41GeLFdaENr7BoC7mNEUbXENsl/O3IT33xEKjdaelz/qCb714xgPH5hhfHF
	 i5vCgpb5miXpRnHryqPsech5R4gZ3XJYnPLZO/3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 078/289] net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
Date: Wed, 30 Nov 2022 19:21:03 +0100
Message-Id: <20221130180545.911253179@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 24deec6b9e4a051635f75777844ffc184644fec9 ]

You'd think people know that the internal 100BASE-TX PHY on the SJA1110
responds only to clause 22 MDIO transactions, but they don't :)

When a clause 45 transaction is attempted, sja1105_base_tx_mdio_read()
and sja1105_base_tx_mdio_write() don't expect "reg" to contain bit 30
set (MII_ADDR_C45) and pack this value into the SPI transaction buffer.

But the field in the SPI buffer has a width smaller than 30 bits, so we
see this confusing message from the packing() API rather than a proper
rejection of C45 transactions:

Call trace:
 dump_stack+0x1c/0x38
 sja1105_pack+0xbc/0xc0 [sja1105]
 sja1105_xfer+0x114/0x2b0 [sja1105]
 sja1105_xfer_u32+0x44/0xf4 [sja1105]
 sja1105_base_tx_mdio_read+0x44/0x7c [sja1105]
 mdiobus_read+0x44/0x80
 get_phy_c45_ids+0x70/0x234
 get_phy_device+0x68/0x15c
 fwnode_mdiobus_register_phy+0x74/0x240
 of_mdiobus_register+0x13c/0x380
 sja1105_mdiobus_register+0x368/0x490 [sja1105]
 sja1105_setup+0x94/0x119c [sja1105]
Cannot store 401d2405 inside bits 24-4 (would truncate)

Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 215dd17ca790..4059fcc8c832 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -256,6 +256,9 @@ static int sja1105_base_tx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	u32 tmp;
 	int rc;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	rc = sja1105_xfer_u32(priv, SPI_READ, regs->mdio_100base_tx + reg,
 			      &tmp, NULL);
 	if (rc < 0)
@@ -272,6 +275,9 @@ static int sja1105_base_tx_mdio_write(struct mii_bus *bus, int phy, int reg,
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 tmp = val;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->mdio_100base_tx + reg,
 				&tmp, NULL);
 }
-- 
2.35.1



