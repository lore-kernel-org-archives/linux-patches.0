Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6106188CDC;
	Tue, 10 Sep 2024 09:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961071; cv=none; b=WXXKJpK+IfEeh3Ke4fJQKBmTgP15sMwQE13UYCyr9NuDp//CyvutoFM4YdBDY6i6QAZ1xZgKbtBTNL6xmrlhBBRL/DEu3MzliZSwKbJX2EFThExW2wtRv6kYo1OMiDMtYmhrsI6N0Cy0C/wA6ODy912awY6uRu3JXqkpjT3ZXBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961071; c=relaxed/simple;
	bh=JG/rSPYNep1R1JRSpCD3CVIhzox73Xql3f5DNWDlFPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJTmId6rRVaQc+MLgsm7QD0esWPAJVahsFZ6zIqrfUd2/Jb6+DX+h6wLyH+FLNMoL3M2RyQp3BasCPbY2Txpp/fMkDkvBqXLd9p4CppjhSjn0ylFPTvq0FtLNL903VfVqsK+XXrXvm1jgNXKMfjpJ4CtaXDUmoRwD5PuT1+F55w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ki1l44ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ki1l44ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C28C4CEC3;
	Tue, 10 Sep 2024 09:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961071;
	bh=JG/rSPYNep1R1JRSpCD3CVIhzox73Xql3f5DNWDlFPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ki1l44ZB4J+o75YTTKtmSCMo3Z9Wp8c6VDjRaJ0Gm2haPF/XMHRJqg6/G2GtuxNEv
	 ebo7Lf13U5ajXKmM+Qm/tgMWT0SrKyPqmJcvbzUTesm/Td3TGsILkwRd6lSTt99sSG
	 CRdA2bp1Vc6BYf3/cZuXWOx1kuf3wpijm6FlixDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@mellanox.com>,
	Petr Machata <petrm@mellanox.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/96] bridge: switchdev: Allow clearing FDB entry offload indication
Date: Tue, 10 Sep 2024 11:31:46 +0200
Message-ID: <20240910092543.483233713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit e9ba0fbc7dd23a74e77960c98c988f59a1ff75aa ]

Currently, an FDB entry only ceases being offloaded when it is deleted.
This changes with VxLAN encapsulation.

Devices capable of performing VxLAN encapsulation usually have only one
FDB table, unlike the software data path which has two - one in the
bridge driver and another in the VxLAN driver.

Therefore, bridge FDB entries pointing to a VxLAN device are only
offloaded if there is a corresponding entry in the VxLAN FDB.

Allow clearing the offload indication in case the corresponding entry
was deleted from the VxLAN FDB.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 9 +++++----
 drivers/net/ethernet/rocker/rocker_main.c                | 1 +
 include/net/switchdev.h                                  | 3 ++-
 net/bridge/br.c                                          | 4 ++--
 net/bridge/br_fdb.c                                      | 4 ++--
 net/bridge/br_private.h                                  | 2 +-
 net/bridge/br_switchdev.c                                | 9 ++++++---
 net/dsa/slave.c                                          | 1 +
 8 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 8d556eb37b7a..c0c73b76f6c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2072,12 +2072,13 @@ void mlxsw_sp_port_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 static void
 mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 			    const char *mac, u16 vid,
-			    struct net_device *dev)
+			    struct net_device *dev, bool offloaded)
 {
 	struct switchdev_notifier_fdb_info info;
 
 	info.addr = mac;
 	info.vid = vid;
+	info.offloaded = offloaded;
 	call_switchdev_notifiers(type, dev, &info.info);
 }
 
@@ -2129,7 +2130,7 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	if (!do_notification)
 		return;
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE : SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding);
 
 	return;
 
@@ -2189,7 +2190,7 @@ static void mlxsw_sp_fdb_notify_mac_lag_process(struct mlxsw_sp *mlxsw_sp,
 	if (!do_notification)
 		return;
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE : SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding);
 
 	return;
 
@@ -2294,7 +2295,7 @@ static void mlxsw_sp_switchdev_event_work(struct work_struct *work)
 			break;
 		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
 					    fdb_info->addr,
-					    fdb_info->vid, dev);
+					    fdb_info->vid, dev, true);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index b13ab4eee4c7..7d81de57b6f4 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2728,6 +2728,7 @@ rocker_fdb_offload_notify(struct rocker_port *rocker_port,
 
 	info.addr = recv_info->addr;
 	info.vid = recv_info->vid;
+	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
 				 rocker_port->dev, &info.info);
 }
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index d574ce63bf22..435bb79925b2 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -155,7 +155,8 @@ struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
 	const unsigned char *addr;
 	u16 vid;
-	bool added_by_user;
+	u8 added_by_user:1,
+	   offloaded:1;
 };
 
 static inline struct net_device *
diff --git a/net/bridge/br.c b/net/bridge/br.c
index b0a0b82e2d91..a175f5557873 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -151,7 +151,7 @@ static int br_switchdev_event(struct notifier_block *unused,
 			break;
 		}
 		br_fdb_offloaded_set(br, p, fdb_info->addr,
-				     fdb_info->vid);
+				     fdb_info->vid, true);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
 		fdb_info = ptr;
@@ -163,7 +163,7 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_OFFLOADED:
 		fdb_info = ptr;
 		br_fdb_offloaded_set(br, p, fdb_info->addr,
-				     fdb_info->vid);
+				     fdb_info->vid, fdb_info->offloaded);
 		break;
 	}
 
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 1714f4e91fca..a659e7c4ee43 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1156,7 +1156,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 }
 
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
-			  const unsigned char *addr, u16 vid)
+			  const unsigned char *addr, u16 vid, bool offloaded)
 {
 	struct net_bridge_fdb_entry *fdb;
 
@@ -1164,7 +1164,7 @@ void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 
 	fdb = br_fdb_find(br, addr, vid);
 	if (fdb)
-		fdb->offloaded = 1;
+		fdb->offloaded = offloaded;
 
 	spin_unlock_bh(&br->hash_lock);
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4e0c6f9d9c16..f5e258ca3043 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -565,7 +565,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
-			  const unsigned char *addr, u16 vid);
+			  const unsigned char *addr, u16 vid, bool offloaded);
 
 /* br_forward.c */
 enum br_pkt_type {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index d77f807420c4..b993df770675 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -103,7 +103,7 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 static void
 br_switchdev_fdb_call_notifiers(bool adding, const unsigned char *mac,
 				u16 vid, struct net_device *dev,
-				bool added_by_user)
+				bool added_by_user, bool offloaded)
 {
 	struct switchdev_notifier_fdb_info info;
 	unsigned long notifier_type;
@@ -111,6 +111,7 @@ br_switchdev_fdb_call_notifiers(bool adding, const unsigned char *mac,
 	info.addr = mac;
 	info.vid = vid;
 	info.added_by_user = added_by_user;
+	info.offloaded = offloaded;
 	notifier_type = adding ? SWITCHDEV_FDB_ADD_TO_DEVICE : SWITCHDEV_FDB_DEL_TO_DEVICE;
 	call_switchdev_notifiers(notifier_type, dev, &info.info);
 }
@@ -126,13 +127,15 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		br_switchdev_fdb_call_notifiers(false, fdb->key.addr.addr,
 						fdb->key.vlan_id,
 						fdb->dst->dev,
-						fdb->added_by_user);
+						fdb->added_by_user,
+						fdb->offloaded);
 		break;
 	case RTM_NEWNEIGH:
 		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
 						fdb->key.vlan_id,
 						fdb->dst->dev,
-						fdb->added_by_user);
+						fdb->added_by_user,
+						fdb->offloaded);
 		break;
 	}
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f7c122357a96..9b74e439809f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1464,6 +1464,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 			netdev_dbg(dev, "fdb add failed err=%d\n", err);
 			break;
 		}
+		fdb_info->offloaded = true;
 		call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev,
 					 &fdb_info->info);
 		break;
-- 
2.43.0



