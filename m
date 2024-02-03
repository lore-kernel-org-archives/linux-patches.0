Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA02FC11;
	Sat,  3 Feb 2024 04:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933389; cv=none; b=Alsbsa6GE7EbZjxLW0xohNolriObbp+EP4WtKO+3zlQFmPAWm/KqSMv3Dz6nhmY6ZDT1N/nlUV2hIBLv1zd+3VRUSJVJubmFatcJYuthiPIiLReWwZrUcU2xpu+z9OC7rIKqFkpuy5Z4KbSZyHKpINRXrtMqLQnOkfQSbmDfDIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933389; c=relaxed/simple;
	bh=LpGTut7xVwxQCv4xyCrF3bU5ZAq/sacciMwUIr6Ju7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kABvyleSLc0GEcX1W/mDZ47akRRYUbUR/yki36HMCU2+gtFlogGhGef87lT7rw/lgMacOQ1rIKBWOUDOfuwl7nK/DP7Dq8/QfxgrlUvTy9Q5ehSnrQNZJArmziJgQTypCLF/JQCpeoBfj9Wnc0T8dmEW5yjtuKELktl1KdDFelU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNTDiQlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNTDiQlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056C7C433C7;
	Sat,  3 Feb 2024 04:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933389;
	bh=LpGTut7xVwxQCv4xyCrF3bU5ZAq/sacciMwUIr6Ju7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNTDiQlE3/3wtJX4CrEDgEF+xfs4/ehzhnV9rofS7HnlPD8e7fBN/kK4/2UoW1/8T
	 zwU/PrAfvaOvfjTl90BBOq6XcmdkqYA1k2Vw0iqeQtB5QTjndi2jVeo4yIxOc/r8m5
	 wVLpLe06DIFDSCeKNMm4RuidDbuiLBIq/BZHwlt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/219] net: dsa: qca8k: put MDIO bus OF node on qca8k_mdio_register() failure
Date: Fri,  2 Feb 2024 20:04:36 -0800
Message-ID: <20240203035331.902500417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 68e1010cda7967cfca9c8650ee1f4efcae54ab90 ]

of_get_child_by_name() gives us an OF node with an elevated refcount,
which should be dropped when we're done with it. This is so that,
if (of_node_check_flag(node, OF_DYNAMIC)) is true, the node's memory can
eventually be freed.

There are 2 distinct paths to be considered in qca8k_mdio_register():

- devm_of_mdiobus_register() succeeds: since commit 3b73a7b8ec38 ("net:
  mdio_bus: add refcounting for fwnodes to mdiobus"), the MDIO core
  treats this well.

- devm_of_mdiobus_register() or anything up to that point fails: it is
  the duty of the qca8k driver to release the OF node.

This change addresses the second case by making sure that the OF node
reference is not leaked.

The "mdio" node may be NULL, but of_node_put(NULL) is safe.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1e94ba1031ec..7c3c90c9edbe 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -842,10 +842,15 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 	struct dsa_switch *ds = priv->ds;
 	struct device_node *mdio;
 	struct mii_bus *bus;
+	int err;
+
+	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
 
 	bus = devm_mdiobus_alloc(ds->dev);
-	if (!bus)
-		return -ENOMEM;
+	if (!bus) {
+		err = -ENOMEM;
+		goto out_put_node;
+	}
 
 	bus->priv = (void *)priv;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d.%d",
@@ -855,12 +860,12 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 	ds->slave_mii_bus = bus;
 
 	/* Check if the devicetree declare the port:phy mapping */
-	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
 	if (of_device_is_available(mdio)) {
 		bus->name = "qca8k slave mii";
 		bus->read = qca8k_internal_mdio_read;
 		bus->write = qca8k_internal_mdio_write;
-		return devm_of_mdiobus_register(priv->dev, bus, mdio);
+		err = devm_of_mdiobus_register(priv->dev, bus, mdio);
+		goto out_put_node;
 	}
 
 	/* If a mapping can't be found the legacy mapping is used,
@@ -869,7 +874,13 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 	bus->name = "qca8k-legacy slave mii";
 	bus->read = qca8k_legacy_mdio_read;
 	bus->write = qca8k_legacy_mdio_write;
-	return devm_mdiobus_register(priv->dev, bus);
+
+	err = devm_mdiobus_register(priv->dev, bus);
+
+out_put_node:
+	of_node_put(mdio);
+
+	return err;
 }
 
 static int
-- 
2.43.0



