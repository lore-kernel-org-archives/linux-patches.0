Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004C17461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1B4C433CA;
	Sun, 17 Sep 2023 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980770;
	bh=a3zfshZf8Mw7R9+rH07tiItsV8flDmggDS89HwgVNTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13YsuYhJaknuxWgctDvuFJglIgOyztJ/GmY+BcvxtFZn8T4stZ1widPUAFHx/vcRv
	 2fFifboL2eEMEmVwlHkmtLhp4k3i4F3If/oOO0aE9ruG9NNCaCeAcK4ujSbAC2/rDj
	 S/S8xIwwwhcE5pkdlQceMQwI1BmnP99QStl5YM6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 263/285] net: dsa: sja1105: serialize sja1105_port_mcast_flood() with other FDB accesses
Date: Sun, 17 Sep 2023 21:14:23 +0200
Message-ID: <20230917191100.334119354@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ea32690daf4fa525dc5a4d164bd00ed8c756e1c6 ]

sja1105_fdb_add() runs from the dsa_owq, and sja1105_port_mcast_flood()
runs from switchdev_deferred_process_work(). Prior to the blamed commit,
they used to be indirectly serialized through the rtnl_lock(), which
no longer holds true because dsa_owq dropped that.

So, it is now possible that we traverse the static config BLK_IDX_L2_LOOKUP
elements concurrently compared to when we change them, in
sja1105_static_fdb_change(). That is not ideal, since it might result in
data corruption.

Introduce a mutex which serializes accesses to the hardware FDB and to
the static config elements for the L2 Address Lookup table.

I can't find a good reason to add locking around sja1105_fdb_dump().
I'll add it later if needed.

Fixes: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105.h      |  2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 56 ++++++++++++++++++++------
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 0617d5ccd3ff1..8c66d3bf61f02 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -266,6 +266,8 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	/* Serializes accesses to the FDB */
+	struct mutex fdb_lock;
 	/* PTP two-step TX timestamp ID, and its serialization lock */
 	spinlock_t ts_id_lock;
 	u8 ts_id;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ba65a95b0c372..79927191ac623 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1805,6 +1805,7 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
+	int rc;
 
 	if (!vid) {
 		switch (db.type) {
@@ -1819,12 +1820,16 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 		}
 	}
 
-	return priv->info->fdb_add_cmd(ds, port, addr, vid);
+	mutex_lock(&priv->fdb_lock);
+	rc = priv->info->fdb_add_cmd(ds, port, addr, vid);
+	mutex_unlock(&priv->fdb_lock);
+
+	return rc;
 }
 
-static int sja1105_fdb_del(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid,
-			   struct dsa_db db)
+static int __sja1105_fdb_del(struct dsa_switch *ds, int port,
+			     const unsigned char *addr, u16 vid,
+			     struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1844,6 +1849,20 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
 }
 
+static int sja1105_fdb_del(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	mutex_lock(&priv->fdb_lock);
+	rc = __sja1105_fdb_del(ds, port, addr, vid, db);
+	mutex_unlock(&priv->fdb_lock);
+
+	return rc;
+}
+
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			    dsa_fdb_dump_cb_t *cb, void *data)
 {
@@ -1906,6 +1925,8 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 	};
 	int i;
 
+	mutex_lock(&priv->fdb_lock);
+
 	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
 		struct sja1105_l2_lookup_entry l2_lookup = {0};
 		u8 macaddr[ETH_ALEN];
@@ -1919,7 +1940,7 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 		if (rc) {
 			dev_err(ds->dev, "Failed to read FDB: %pe\n",
 				ERR_PTR(rc));
-			return;
+			break;
 		}
 
 		if (!(l2_lookup.destports & BIT(port)))
@@ -1931,14 +1952,16 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
+		rc = __sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
 		if (rc) {
 			dev_err(ds->dev,
 				"Failed to delete FDB entry %pM vid %lld: %pe\n",
 				macaddr, l2_lookup.vlanid, ERR_PTR(rc));
-			return;
+			break;
 		}
 	}
+
+	mutex_unlock(&priv->fdb_lock);
 }
 
 static int sja1105_mdb_add(struct dsa_switch *ds, int port,
@@ -2962,7 +2985,9 @@ static int sja1105_port_mcast_flood(struct sja1105_private *priv, int to,
 {
 	struct sja1105_l2_lookup_entry *l2_lookup;
 	struct sja1105_table *table;
-	int match;
+	int match, rc;
+
+	mutex_lock(&priv->fdb_lock);
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
 	l2_lookup = table->entries;
@@ -2975,7 +3000,8 @@ static int sja1105_port_mcast_flood(struct sja1105_private *priv, int to,
 	if (match == table->entry_count) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Could not find FDB entry for unknown multicast");
-		return -ENOSPC;
+		rc = -ENOSPC;
+		goto out;
 	}
 
 	if (flags.val & BR_MCAST_FLOOD)
@@ -2983,10 +3009,13 @@ static int sja1105_port_mcast_flood(struct sja1105_private *priv, int to,
 	else
 		l2_lookup[match].destports &= ~BIT(to);
 
-	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
-					    l2_lookup[match].index,
-					    &l2_lookup[match],
-					    true);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					  l2_lookup[match].index,
+					  &l2_lookup[match], true);
+out:
+	mutex_unlock(&priv->fdb_lock);
+
+	return rc;
 }
 
 static int sja1105_port_pre_bridge_flags(struct dsa_switch *ds, int port,
@@ -3356,6 +3385,7 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->dynamic_config_lock);
 	mutex_init(&priv->mgmt_lock);
+	mutex_init(&priv->fdb_lock);
 	spin_lock_init(&priv->ts_id_lock);
 
 	rc = sja1105_parse_dt(priv);
-- 
2.40.1



