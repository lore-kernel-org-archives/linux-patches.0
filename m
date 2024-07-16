Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63A11DA4D;
	Tue, 16 Jul 2024 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145570; cv=none; b=E78PX0wb3oIvdhn6Izh6muyKcme/qCAEATa+1qUVEobkgie937fvM/5ocyz86xTeSuzuf5w3/eJJS+e2HetoBJG0xC4YN04LsIJO6xHuqzV63edt2HugtXVKITQkHBFjM6JVcRr52sXE6GWK0090dgVagM/7gKW0l77k5Kd9ieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145570; c=relaxed/simple;
	bh=5Cu4JB6aGzXNr8sRaWlH0eVLi07ZbthO3rUCTLKNIls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1PLQ+8kpmAOYRWp/WfUINdAVRAeiDcANFkQjSmYXaJczT8MHfLqBp3KlML25leaQFHqVQlHUJ/EM4ydBYofi6mA/s6uITyJ0KClJ8OGYD0UeY7vIi/atyehDT8UXTt+vOlVSc25WmNmFiEQLUyyhkeDr+377+LO3SekgAAGWT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sD1SmBuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sD1SmBuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6907C116B1;
	Tue, 16 Jul 2024 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145570;
	bh=5Cu4JB6aGzXNr8sRaWlH0eVLi07ZbthO3rUCTLKNIls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD1SmBuY5mMyNs2MJxAWoYrIiPncKUjMxFclEuu+vCEqFb6ln335I3xrUS1DFJylm
	 a8e/Ewar33QUQ/A8YaGGKWpuxJyY1FXqf9m7r1e+8dybHgguOQiQe/SIF1YqwGzoGk
	 RgODApnOpO70Up2aeyp8A6oIfHJEHeze0fVMAlnw=
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
Subject: [PATCH 6.6 013/121] dsa: lan9303: Fix mapping between DSA port number and PHY address
Date: Tue, 16 Jul 2024 17:31:15 +0200
Message-ID: <20240716152751.831607687@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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
index ee67adeb2cdbf..24ef219e6f565 100644
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
 	vlan_vid_del(dsa_port_to_master(dp), htons(ETH_P_8021Q), port);
 
 	lan9303_disable_processing_port(chip, port);
-	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
+	lan9303_phy_write(ds, port, MII_BMCR, BMCR_PDOWN);
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
@@ -1355,8 +1355,6 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 
 static int lan9303_register_switch(struct lan9303 *chip)
 {
-	int base;
-
 	chip->ds = devm_kzalloc(chip->dev, sizeof(*chip->ds), GFP_KERNEL);
 	if (!chip->ds)
 		return -ENOMEM;
@@ -1365,8 +1363,7 @@ static int lan9303_register_switch(struct lan9303 *chip)
 	chip->ds->num_ports = LAN9303_NUM_PORTS;
 	chip->ds->priv = chip;
 	chip->ds->ops = &lan9303_switch_ops;
-	base = chip->phy_addr_base;
-	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1 + base, base);
+	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1, 0);
 
 	return dsa_register_switch(chip->ds);
 }
-- 
2.43.0



