Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B5216E30;
	Tue,  8 Apr 2025 11:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112364; cv=none; b=JvNIK7ndsN3DitZCUPBXXjldef/G6XFRZjKWo/dOZDNQnrtsJ/VSeCG65hcgWdv43tVk7uJ0NDUO0uLC2WFnAuGLxGhBb2hhtwYnNgh/oRUwsbld2cBVyUr08+y3AiQD3YS3dsg9Uojc+C4vS1+op9uyVCLeqd/XRQY33Nz+mD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112364; c=relaxed/simple;
	bh=wQ53JbhdLuKr8sbohWq1ymb73Ift7QeG3d/Fp6dd/XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm1AW3zQx6K2kN65ProeNb3omZ8NBfS6xSbzFxY47T7tf2Ve6SgY55JpzzITyVf0FGnllQmAYlrYzGMButrtk8DHK1rDWjCEqvWTJCpNdaye296WH2bvBCAPMzQx/sLY66XlGaAQ73ltLSYXso3mpMlKW6RYy6xRobWhd7XqOOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmi5VGP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmi5VGP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08429C4CEE5;
	Tue,  8 Apr 2025 11:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112364;
	bh=wQ53JbhdLuKr8sbohWq1ymb73Ift7QeG3d/Fp6dd/XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmi5VGP74zyPnkcH4gLkTFYUr3Jh1rUZ2vZFxzECpp3x8n5KzLSvu2OvJE9KpFEvS
	 dILSd8g3qgPEafQ55B0bQbfF2qoRph/sBRskAbahPY7IUdsqXtGZpRUEEcgn21FBl8
	 8ymizH73NduH6qmcfvBcnpIS3vKWUAqnJ0tmlFTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/279] net: dsa: mv88e6xxx: Verify after ATU Load ops
Date: Tue,  8 Apr 2025 12:46:32 +0200
Message-ID: <20250408104826.622530110@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joseph Huang <Joseph.Huang@garmin.com>

[ Upstream commit dc5340c3133a3ebe54853fd299116149e528cfaa ]

ATU Load operations could fail silently if there's not enough space
on the device to hold the new entry. When this happens, the symptom
depends on the unknown flood settings. If unknown multicast flood is
disabled, the multicast packets are dropped when the ATU table is
full. If unknown multicast flood is enabled, the multicast packets
will be flooded to all ports. Either way, IGMP snooping is broken
when the ATU Load operation fails silently.

Do a Read-After-Write verification after each fdb/mdb add operation
to make sure that the operation was really successful, and return
-ENOSPC otherwise.

Fixes: defb05b9b9b4 ("net: dsa: mv88e6xxx: Add support for fdb_add, fdb_del, and fdb_getnext")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250306172306.3859214-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 59 ++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2a55ecceab8c6..07a3f12e02dd1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1775,13 +1775,11 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 	return err;
 }
 
-static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
-					const unsigned char *addr, u16 vid,
-					u8 state)
+static int mv88e6xxx_port_db_get(struct mv88e6xxx_chip *chip,
+				 const unsigned char *addr, u16 vid,
+				 u16 *fid, struct mv88e6xxx_atu_entry *entry)
 {
-	struct mv88e6xxx_atu_entry entry;
 	struct mv88e6xxx_vtu_entry vlan;
-	u16 fid;
 	int err;
 
 	/* Ports have two private address databases: one for when the port is
@@ -1792,7 +1790,7 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 	 * VLAN ID into the port's database used for VLAN-unaware bridging.
 	 */
 	if (vid == 0) {
-		fid = MV88E6XXX_FID_BRIDGED;
+		*fid = MV88E6XXX_FID_BRIDGED;
 	} else {
 		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 		if (err)
@@ -1802,14 +1800,39 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		if (!vlan.valid)
 			return -EOPNOTSUPP;
 
-		fid = vlan.fid;
+		*fid = vlan.fid;
 	}
 
-	entry.state = 0;
-	ether_addr_copy(entry.mac, addr);
-	eth_addr_dec(entry.mac);
+	entry->state = 0;
+	ether_addr_copy(entry->mac, addr);
+	eth_addr_dec(entry->mac);
+
+	return mv88e6xxx_g1_atu_getnext(chip, *fid, entry);
+}
+
+static bool mv88e6xxx_port_db_find(struct mv88e6xxx_chip *chip,
+				   const unsigned char *addr, u16 vid)
+{
+	struct mv88e6xxx_atu_entry entry;
+	u16 fid;
+	int err;
 
-	err = mv88e6xxx_g1_atu_getnext(chip, fid, &entry);
+	err = mv88e6xxx_port_db_get(chip, addr, vid, &fid, &entry);
+	if (err)
+		return false;
+
+	return entry.state && ether_addr_equal(entry.mac, addr);
+}
+
+static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
+					const unsigned char *addr, u16 vid,
+					u8 state)
+{
+	struct mv88e6xxx_atu_entry entry;
+	u16 fid;
+	int err;
+
+	err = mv88e6xxx_port_db_get(chip, addr, vid, &fid, &entry);
 	if (err)
 		return err;
 
@@ -2324,6 +2347,13 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
+	if (err)
+		goto out;
+
+	if (!mv88e6xxx_port_db_find(chip, addr, vid))
+		err = -ENOSPC;
+
+out:
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -5878,6 +5908,13 @@ static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC);
+	if (err)
+		goto out;
+
+	if (!mv88e6xxx_port_db_find(chip, mdb->addr, mdb->vid))
+		err = -ENOSPC;
+
+out:
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
-- 
2.39.5



