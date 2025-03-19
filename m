Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EB61C9B62;
	Wed, 19 Mar 2025 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394845; cv=none; b=FOX0KGddoGTKHTMgm9eL4G0AGzxQwBAIF3+mIicdfyQih1c0BYPT/8/+xGAzAm9KPKBnnasYj5qOTf///edOwuulWikBdsVPc/eCji4G3lSXxThnr7pc5URpKfNxeWWtVOSzY6rk+HkbOOZdkMokiZm82sBjFroEL+VrPpqFLmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394845; c=relaxed/simple;
	bh=7DKU34DyeSIRYCXEZjwmdpPC+4BQLUxfW/2v4UNKarw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK11IZhEQXEC0XfSjDkEK47CJ+icM3rrEilFyq21fWlAK7Wh/iRg55FEg6kk6aPfv0NhPvNaEzMrfXBtfFenGWx4hTa+O1/kT4IBZ/a0KHUwnGbhYSH9fsX8grQ+gB0EqlL8cOSBZk0ChQgntFbAlSrzyHF3AZNw2KCskCuKg8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWwbHxW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWwbHxW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE71C4CEE9;
	Wed, 19 Mar 2025 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394845;
	bh=7DKU34DyeSIRYCXEZjwmdpPC+4BQLUxfW/2v4UNKarw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWwbHxW+t0E2otviJVTD6BdC8OEB3xRz6uV6GdK92nBw6/UFir2djEIHh7h5PQQEl
	 m/SfJ55OkTlO2/uFCKzpziQhR2yGrC9QXNUYE6ZEVsWMWnhocFa4lfbzXcG9Pi1xhr
	 urYPGu7XJXllaEPm8g9399UzJUwZImfZsP+mJmSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 022/241] net: dsa: mv88e6xxx: Verify after ATU Load ops
Date: Wed, 19 Mar 2025 07:28:12 -0700
Message-ID: <20250319143028.256640135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3a792f79270d9..d6e8398c07608 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2224,13 +2224,11 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
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
@@ -2241,7 +2239,7 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 	 * VLAN ID into the port's database used for VLAN-unaware bridging.
 	 */
 	if (vid == 0) {
-		fid = MV88E6XXX_FID_BRIDGED;
+		*fid = MV88E6XXX_FID_BRIDGED;
 	} else {
 		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 		if (err)
@@ -2251,14 +2249,39 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
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
 
@@ -2862,6 +2885,13 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
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
@@ -6596,6 +6626,13 @@ static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
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



