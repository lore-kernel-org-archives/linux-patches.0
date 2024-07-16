Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1843195B27;
	Tue, 16 Jul 2024 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144845; cv=none; b=DUtoZ8xcDp4n3rBhGKTKZJWftv4HDxeRSTMPJGZwYHTIYZ6Crh9Z0Z6NSEKxFYNYiuzE5nKyVr5IMPjjGF8fqfc+XuT7zdfrDHiGrhBJcLFxiFO7Mn9zEB5UtxZWDZsLaCMPPXeXMPZyMhbM8mlkgZcjiqxkTX3C0yhpF15FmIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144845; c=relaxed/simple;
	bh=LngKvyXmXrOBriqumPujPUD0//LkRiPRPf2DS6+3PtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrdZkC+2QLHc1oZpmFNgViAimr+64VmhoCewcjK7r1LuEK0TrqPb/9HSHlI5hvhr78dp5vJXhiERcjG3ycWzj7mtBmZ2PQreY+gwAH3UgsquYcICUhb8i9jovL0jTPj2YqLf078OQKFpwESVxG2NwlRWXEY/4wO9EntdOknuVAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcsEhOHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcsEhOHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96BDC116B1;
	Tue, 16 Jul 2024 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144845;
	bh=LngKvyXmXrOBriqumPujPUD0//LkRiPRPf2DS6+3PtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcsEhOHd20gE3F2OIOvNK7GZGZ3TB6LUvWRkLXbvATsr4NEasXGVU2fsR80g3FguB
	 G3fPHzNpEF+DN2Pb+BzwE/KQrnPaKMQOi3YmAx2rmII32e6pRuDmiaeY9hdutwN1+T
	 n06AhIwdp9XsmP7cJDTkjbmZdPFTG6HFCy4QYdvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 015/143] dsa: lan9303: Fix mapping between DSA port number and PHY address
Date: Tue, 16 Jul 2024 17:30:11 +0200
Message-ID: <20240716152756.575531368@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 0005b2dc43f96b93fc5b0850d7ca3f7aeac9129c ]

The 'phy' parameter supplied to lan9303_phy_read/_write was sometimes a
DSA port number and sometimes a PHY address. This isn't a problem as
long as they are equal.  But if the external phy_addr_sel_strap pin is
wired to 'high', the PHY addresses change from 0-1-2 to 1-2-3 (CPU,
slave0, slave1).  In this case, lan9303_phy_read/_write must translate
between DSA port numbers and the corresponding PHY address.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20240703145718.19951-1-ceggers@arri.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 666b4d766c005..1f7000f90bb78 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1048,31 +1048,31 @@ static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(lan9303_mib);
 }
 
-static int lan9303_phy_read(struct dsa_switch *ds, int phy, int regnum)
+static int lan9303_phy_read(struct dsa_switch *ds, int port, int regnum)
 {
 	struct lan9303 *chip = ds->priv;
 	int phy_base = chip->phy_addr_base;
 
-	if (phy == phy_base)
+	if (port == 0)
 		return lan9303_virt_phy_reg_read(chip, regnum);
-	if (phy > phy_base + 2)
+	if (port > 2)
 		return -ENODEV;
 
-	return chip->ops->phy_read(chip, phy, regnum);
+	return chip->ops->phy_read(chip, phy_base + port, regnum);
 }
 
-static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
+static int lan9303_phy_write(struct dsa_switch *ds, int port, int regnum,
 			     u16 val)
 {
 	struct lan9303 *chip = ds->priv;
 	int phy_base = chip->phy_addr_base;
 
-	if (phy == phy_base)
+	if (port == 0)
 		return lan9303_virt_phy_reg_write(chip, regnum, val);
-	if (phy > phy_base + 2)
+	if (port > 2)
 		return -ENODEV;
 
-	return chip->ops->phy_write(chip, phy, regnum, val);
+	return chip->ops->phy_write(chip, phy_base + port, regnum, val);
 }
 
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
@@ -1100,7 +1100,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 	vlan_vid_del(dsa_port_to_conduit(dp), htons(ETH_P_8021Q), port);
 
 	lan9303_disable_processing_port(chip, port);
-	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
+	lan9303_phy_write(ds, port, MII_BMCR, BMCR_PDOWN);
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
@@ -1375,8 +1375,6 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 
 static int lan9303_register_switch(struct lan9303 *chip)
 {
-	int base;
-
 	chip->ds = devm_kzalloc(chip->dev, sizeof(*chip->ds), GFP_KERNEL);
 	if (!chip->ds)
 		return -ENOMEM;
@@ -1386,8 +1384,7 @@ static int lan9303_register_switch(struct lan9303 *chip)
 	chip->ds->priv = chip;
 	chip->ds->ops = &lan9303_switch_ops;
 	chip->ds->phylink_mac_ops = &lan9303_phylink_mac_ops;
-	base = chip->phy_addr_base;
-	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1 + base, base);
+	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1, 0);
 
 	return dsa_register_switch(chip->ds);
 }
-- 
2.43.0



