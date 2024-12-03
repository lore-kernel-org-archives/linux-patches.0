Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ADD1F8913;
	Tue,  3 Dec 2024 15:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238681; cv=none; b=C439KTLQekke889IvuFrC1UQ0yhlk9tkXYHSngjCtHPgd8uOCcvCAoR+fedA+MdEqP7yV8rqH0LaVTe/Y6arNzKULjYXzl+uHml+1wJujZhFWHSknddgAzd3lcqlfo9RuXfYWSymgrPNEf5Xz+o/HhWEuRQCBGXs4xJHUwJKRcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238681; c=relaxed/simple;
	bh=Oy4TYKFYAgyrn37ieDBqwyVR5bHO3cYWjCzfEIi5/6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE/N9wREkcWe89m9QiRvsGa8phDRd6W+Zx5GVXA7Zd1yaFUm1eFzh0lBPrWO2f8+DYWcK1sVuwniSS2BuhKnnwK8uLJCH6jIaJOFbfHcm/EAk2sFtyggy5+E0pUrttOLkId4WINTO6wAp0PVw/DFaxJnteFZcope2EAbnWAO1mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV6oSDkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV6oSDkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE38C4CED6;
	Tue,  3 Dec 2024 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238681;
	bh=Oy4TYKFYAgyrn37ieDBqwyVR5bHO3cYWjCzfEIi5/6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV6oSDkjxv0C20s7BVFoIKyzGxw/LB476BxO3QhV1qPXXiATRewCT6yYxgUPSe/0p
	 Mktjji9oIAngRVw6M4RTGORUmVqNhtMmEwNVPbDyiOoenYgj9vfXyzd2ay1gemPUHx
	 eY+R8V6qoav6CvDckq/uV15OKmw9prUSxoJJznZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 361/817] Bluetooth: ISO: Do not emit LE PA Create Sync if previous is pending
Date: Tue,  3 Dec 2024 15:38:53 +0100
Message-ID: <20241203144009.924817457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 4a5e0ba68676b3a77298cf646cd2b39c94fbd2f5 ]

The Bluetooth Core spec does not allow a LE PA Create sync command to be
sent to Controller if another one is pending (Vol 4, Part E, page 2493).

In order to avoid this issue, the HCI_CONN_CREATE_PA_SYNC was added
to mark that the LE PA Create Sync command has been sent for a hcon.
Once the PA Sync Established event is received, the hcon flag is
erased and the next pending hcon is handled.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 07a9342b94a9 ("Bluetooth: ISO: Send BIG Create Sync via hci_sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |   3 +-
 include/net/bluetooth/hci_core.h |  34 +++++++++
 net/bluetooth/hci_conn.c         | 123 +++++++++++++++++++++----------
 net/bluetooth/hci_event.c        |  19 ++++-
 4 files changed, 139 insertions(+), 40 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index d1d073089f384..355e2c2d56f9f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1,7 +1,7 @@
 /*
    BlueZ - Bluetooth protocol stack for Linux
    Copyright (C) 2000-2001 Qualcomm Incorporated
-   Copyright 2023 NXP
+   Copyright 2023-2024 NXP
 
    Written 2000,2001 by Maxim Krasnyansky <maxk@qualcomm.com>
 
@@ -683,6 +683,7 @@ enum {
 #define HCI_RSSI_INVALID	127
 
 #define HCI_SYNC_HANDLE_INVALID	0xffff
+#define HCI_SID_INVALID		0xff
 
 #define HCI_ROLE_MASTER		0x00
 #define HCI_ROLE_SLAVE		0x01
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 88265d37aa72e..494fcd68f8311 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -668,6 +668,7 @@ struct hci_conn {
 	__u8		adv_instance;
 	__u16		handle;
 	__u16		sync_handle;
+	__u8		sid;
 	__u16		state;
 	__u16		mtu;
 	__u8		mode;
@@ -947,6 +948,7 @@ enum {
 	HCI_CONN_CREATE_CIS,
 	HCI_CONN_BIG_SYNC,
 	HCI_CONN_BIG_SYNC_FAILED,
+	HCI_CONN_CREATE_PA_SYNC,
 	HCI_CONN_PA_SYNC,
 	HCI_CONN_PA_SYNC_FAILED,
 };
@@ -1099,6 +1101,30 @@ static inline struct hci_conn *hci_conn_hash_lookup_bis(struct hci_dev *hdev,
 	return NULL;
 }
 
+static inline struct hci_conn *hci_conn_hash_lookup_sid(struct hci_dev *hdev,
+							__u8 sid,
+							bdaddr_t *dst,
+							__u8 dst_type)
+{
+	struct hci_conn_hash *h = &hdev->conn_hash;
+	struct hci_conn  *c;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(c, &h->list, list) {
+		if (c->type != ISO_LINK  || bacmp(&c->dst, dst) ||
+		    c->dst_type != dst_type || c->sid != sid)
+			continue;
+
+		rcu_read_unlock();
+		return c;
+	}
+
+	rcu_read_unlock();
+
+	return NULL;
+}
+
 static inline struct hci_conn *
 hci_conn_hash_lookup_per_adv_bis(struct hci_dev *hdev,
 				 bdaddr_t *ba,
@@ -1328,6 +1354,13 @@ hci_conn_hash_lookup_pa_sync_handle(struct hci_dev *hdev, __u16 sync_handle)
 		if (c->type != ISO_LINK)
 			continue;
 
+		/* Ignore the listen hcon, we are looking
+		 * for the child hcon that was created as
+		 * a result of the PA sync established event.
+		 */
+		if (c->state == BT_LISTEN)
+			continue;
+
 		if (c->sync_handle == sync_handle) {
 			rcu_read_unlock();
 			return c;
@@ -1445,6 +1478,7 @@ bool hci_setup_sync(struct hci_conn *conn, __u16 handle);
 void hci_sco_setup(struct hci_conn *conn, __u8 status);
 bool hci_iso_setup_path(struct hci_conn *conn);
 int hci_le_create_cis_pending(struct hci_dev *hdev);
+int hci_pa_create_sync_pending(struct hci_dev *hdev);
 int hci_conn_check_create_cis(struct hci_conn *conn);
 
 struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index a7ffce4851235..21b900995e2d2 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -953,6 +953,7 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t
 	conn->tx_power = HCI_TX_POWER_INVALID;
 	conn->max_tx_power = HCI_TX_POWER_INVALID;
 	conn->sync_handle = HCI_SYNC_HANDLE_INVALID;
+	conn->sid = HCI_SID_INVALID;
 
 	set_bit(HCI_CONN_POWER_SAVE, &conn->flags);
 	conn->disc_timeout = HCI_DISCONN_TIMEOUT;
@@ -2063,73 +2064,119 @@ static int create_big_sync(struct hci_dev *hdev, void *data)
 
 static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 {
-	struct hci_cp_le_pa_create_sync *cp = data;
-
 	bt_dev_dbg(hdev, "");
 
 	if (err)
 		bt_dev_err(hdev, "Unable to create PA: %d", err);
+}
+
+static bool hci_conn_check_create_pa_sync(struct hci_conn *conn)
+{
+	if (conn->type != ISO_LINK || conn->sid == HCI_SID_INVALID)
+		return false;
 
-	kfree(cp);
+	return true;
 }
 
 static int create_pa_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_cp_le_pa_create_sync *cp = data;
-	int err;
+	struct hci_cp_le_pa_create_sync *cp = NULL;
+	struct hci_conn *conn;
+	int err = 0;
 
-	err = __hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC,
-				    sizeof(*cp), cp, HCI_CMD_TIMEOUT);
-	if (err) {
-		hci_dev_clear_flag(hdev, HCI_PA_SYNC);
-		return err;
+	hci_dev_lock(hdev);
+
+	rcu_read_lock();
+
+	/* The spec allows only one pending LE Periodic Advertising Create
+	 * Sync command at a time. If the command is pending now, don't do
+	 * anything. We check for pending connections after each PA Sync
+	 * Established event.
+	 *
+	 * BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
+	 * page 2493:
+	 *
+	 * If the Host issues this command when another HCI_LE_Periodic_
+	 * Advertising_Create_Sync command is pending, the Controller shall
+	 * return the error code Command Disallowed (0x0C).
+	 */
+	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
+		if (test_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags))
+			goto unlock;
 	}
 
-	return hci_update_passive_scan_sync(hdev);
+	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
+		if (hci_conn_check_create_pa_sync(conn)) {
+			struct bt_iso_qos *qos = &conn->iso_qos;
+
+			cp = kzalloc(sizeof(*cp), GFP_KERNEL);
+			if (!cp) {
+				err = -ENOMEM;
+				goto unlock;
+			}
+
+			cp->options = qos->bcast.options;
+			cp->sid = conn->sid;
+			cp->addr_type = conn->dst_type;
+			bacpy(&cp->addr, &conn->dst);
+			cp->skip = cpu_to_le16(qos->bcast.skip);
+			cp->sync_timeout = cpu_to_le16(qos->bcast.sync_timeout);
+			cp->sync_cte_type = qos->bcast.sync_cte_type;
+
+			break;
+		}
+	}
+
+unlock:
+	rcu_read_unlock();
+
+	hci_dev_unlock(hdev);
+
+	if (cp) {
+		hci_dev_set_flag(hdev, HCI_PA_SYNC);
+		set_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
+
+		err = __hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC,
+					    sizeof(*cp), cp, HCI_CMD_TIMEOUT);
+		if (!err)
+			err = hci_update_passive_scan_sync(hdev);
+
+		kfree(cp);
+
+		if (err) {
+			hci_dev_clear_flag(hdev, HCI_PA_SYNC);
+			clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
+		}
+	}
+
+	return err;
+}
+
+int hci_pa_create_sync_pending(struct hci_dev *hdev)
+{
+	/* Queue start pa_create_sync and scan */
+	return hci_cmd_sync_queue(hdev, create_pa_sync,
+				  NULL, create_pa_complete);
 }
 
 struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
 				    __u8 dst_type, __u8 sid,
 				    struct bt_iso_qos *qos)
 {
-	struct hci_cp_le_pa_create_sync *cp;
 	struct hci_conn *conn;
-	int err;
-
-	if (hci_dev_test_and_set_flag(hdev, HCI_PA_SYNC))
-		return ERR_PTR(-EBUSY);
 
 	conn = hci_conn_add_unset(hdev, ISO_LINK, dst, HCI_ROLE_SLAVE);
 	if (IS_ERR(conn))
 		return conn;
 
 	conn->iso_qos = *qos;
+	conn->dst_type = dst_type;
+	conn->sid = sid;
 	conn->state = BT_LISTEN;
 
 	hci_conn_hold(conn);
 
-	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp) {
-		hci_dev_clear_flag(hdev, HCI_PA_SYNC);
-		hci_conn_drop(conn);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	cp->options = qos->bcast.options;
-	cp->sid = sid;
-	cp->addr_type = dst_type;
-	bacpy(&cp->addr, dst);
-	cp->skip = cpu_to_le16(qos->bcast.skip);
-	cp->sync_timeout = cpu_to_le16(qos->bcast.sync_timeout);
-	cp->sync_cte_type = qos->bcast.sync_cte_type;
-
-	/* Queue start pa_create_sync and scan */
-	err = hci_cmd_sync_queue(hdev, create_pa_sync, cp, create_pa_complete);
-	if (err < 0) {
-		hci_conn_drop(conn);
-		kfree(cp);
-		return ERR_PTR(err);
-	}
+	hci_pa_create_sync_pending(hdev);
 
 	return conn;
 }
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 561c8cb87473e..63504248d58dd 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6345,7 +6345,7 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 	struct hci_ev_le_pa_sync_established *ev = data;
 	int mask = hdev->link_mode;
 	__u8 flags = 0;
-	struct hci_conn *pa_sync;
+	struct hci_conn *pa_sync, *conn;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
@@ -6353,6 +6353,20 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
+	conn = hci_conn_hash_lookup_sid(hdev, ev->sid, &ev->bdaddr,
+					ev->bdaddr_type);
+	if (!conn) {
+		bt_dev_err(hdev,
+			   "Unable to find connection for dst %pMR sid 0x%2.2x",
+			   &ev->bdaddr, ev->sid);
+		goto unlock;
+	}
+
+	clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
+
+	conn->sync_handle = le16_to_cpu(ev->handle);
+	conn->sid = HCI_SID_INVALID;
+
 	mask |= hci_proto_connect_ind(hdev, &ev->bdaddr, ISO_LINK, &flags);
 	if (!(mask & HCI_LM_ACCEPT)) {
 		hci_le_pa_term_sync(hdev, ev->handle);
@@ -6379,6 +6393,9 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 	}
 
 unlock:
+	/* Handle any other pending PA sync command */
+	hci_pa_create_sync_pending(hdev);
+
 	hci_dev_unlock(hdev);
 }
 
-- 
2.43.0



