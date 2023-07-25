Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CC31D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CD3C433C7;
	Tue, 25 Jul 2023 11:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283032;
	bh=Tbj9u8UCOaLLl0kuDCjiDvd7rn9B952oUvP8dPyUxfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEofg6Ilktpyfd5PWVgC62eMytw16HuzYikgrGGRxAhr3mM9hER+jkk+RuVWLe77w
	 mnK6q0Inzm+RcFzkbg7kke1ep67vjywvbpfEstG8YPH/pjNMavDK09dnXfrUWGTNvN
	 hKjZadRV7gtth5TpxeCiab3SWK6TXEpLFbuYR/C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Vladimir Oltean <olteanv@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/183] net: dsa: microchip: ksz8: Separate static MAC table operations for code reuse
Date: Tue, 25 Jul 2023 12:45:42 +0200
Message-ID: <20230725104512.077748789@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit f6636ff69ec4f2c94a5ee1d032b21cfe1e0a5678 ]

Move static MAC table operations to separate functions in order to reuse
the code for add/del_fdb. This is needed to address kernel warnings
caused by the lack of fdb add function support in the current driver.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 4bdf79d686b4 ("net: dsa: microchip: correct KSZ8795 static MAC table access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 34 +++++++++++++++++++----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 22250ae222b5b..38fd9b8e0287a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -926,8 +926,8 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	return ret;
 }
 
-int ksz8_mdb_add(struct ksz_device *dev, int port,
-		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+static int ksz8_add_sta_mac(struct ksz_device *dev, int port,
+			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
 	int index;
@@ -937,8 +937,8 @@ int ksz8_mdb_add(struct ksz_device *dev, int port,
 	for (index = 0; index < dev->info->num_statics; index++) {
 		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
-			    alu.fid == mdb->vid)
+			if (!memcmp(alu.mac, addr, ETH_ALEN) &&
+			    alu.fid == vid)
 				break;
 		/* Remember the first empty entry. */
 		} else if (!empty) {
@@ -954,23 +954,23 @@ int ksz8_mdb_add(struct ksz_device *dev, int port,
 	if (index == dev->info->num_statics) {
 		index = empty - 1;
 		memset(&alu, 0, sizeof(alu));
-		memcpy(alu.mac, mdb->addr, ETH_ALEN);
+		memcpy(alu.mac, addr, ETH_ALEN);
 		alu.is_static = true;
 	}
 	alu.port_forward |= BIT(port);
-	if (mdb->vid) {
+	if (vid) {
 		alu.is_use_fid = true;
 
 		/* Need a way to map VID to FID. */
-		alu.fid = mdb->vid;
+		alu.fid = vid;
 	}
 	ksz8_w_sta_mac_table(dev, index, &alu);
 
 	return 0;
 }
 
-int ksz8_mdb_del(struct ksz_device *dev, int port,
-		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
+			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
 	int index;
@@ -978,8 +978,8 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
 	for (index = 0; index < dev->info->num_statics; index++) {
 		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
-			    alu.fid == mdb->vid)
+			if (!memcmp(alu.mac, addr, ETH_ALEN) &&
+			    alu.fid == vid)
 				break;
 		}
 	}
@@ -998,6 +998,18 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
+int ksz8_mdb_add(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+{
+	return ksz8_add_sta_mac(dev, port, mdb->addr, mdb->vid);
+}
+
+int ksz8_mdb_del(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+{
+	return ksz8_del_sta_mac(dev, port, mdb->addr, mdb->vid);
+}
+
 int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 			     struct netlink_ext_ack *extack)
 {
-- 
2.39.2



