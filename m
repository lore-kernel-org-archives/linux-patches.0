Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1F35C6B3;
	Tue, 21 Jul 2026 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670689; cv=none; b=PM8iWj6anNfrZRgFeOIviUUXVX7nLyHKk6dzv8l3vaK3TWSH9op2n2RvB6Oj8PPeLVssGoreF4y/fSRIAGgAMcGsSfdH9CBUi85z/YC1ni3HFsV88SEUIncRZBQdfnXTYWJU8aFJC3lniA07sEEjMPj3Sk3rE+bXmZTSc2dQ8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670689; c=relaxed/simple;
	bh=7Ifv8j52Te1rPWqybUcWwx1uByhkUlWjxFctjXHJHms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvQM6oPXQIgUmSQVAWEYcblxf521G1vvn2EpMn4ak+waFndjm06Mu5H+txCJAIeABrJznJ8tL8eJSvPAxQpmWoDyOLGrH3zZSIFr5KeKcghrPIEhLUdYOKI1agQzhhTXySkZ4rUNSV1246noayaBFuAi9jXTcuOk7bq/7YDAIsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hu9V72vX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hu9V72vX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422B71F000E9;
	Tue, 21 Jul 2026 21:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670687;
	bh=XA58dixiSW5ErWO5N3apUn+IWQtNaOdkoZrmU5UlMRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hu9V72vXcswWsRbU8Harxur0kNo0GoeG/VD5/dGC3Hp0lOVLpKT5XsyLKkMbHZb6Q
	 1dF7hn8iMdttSg4D00/mBK/PVL6Yx19nxzieiCRGdJeM0BW2VSAN1TL7Adpg2HzEZH
	 mp0qeXFoqShw2ybMGxIrwEB2KBBCCGpZqi8JaduY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0984/1067] Bluetooth: Make handle of hci_conn be unique
Date: Tue, 21 Jul 2026 17:26:25 +0200
Message-ID: <20260721152446.567358630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 181a42edddf51d5d9697ecdf365d72ebeab5afb0 ]

The handle of new hci_conn is always HCI_CONN_HANDLE_MAX + 1 if
the handle of the first hci_conn entry in hci_dev->conn_hash->list
is not HCI_CONN_HANDLE_MAX + 1. Use ida to manage the allocation of
hci_conn->handle to make it be unique.

Fixes: 9f78191cc9f1 ("Bluetooth: hci_conn: Always allocate unique handles")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6fef032af009 ("Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    8 ++++-
 net/bluetooth/amp.c              |    3 --
 net/bluetooth/hci_conn.c         |   45 +++++++++++++++++++++++--------
 net/bluetooth/hci_core.c         |    3 ++
 net/bluetooth/hci_event.c        |   56 ++++++++++++++++++++++++---------------
 5 files changed, 79 insertions(+), 36 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -322,8 +322,8 @@ struct adv_monitor {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
-#define HCI_CONN_HANDLE_UNSET		0xffff
 #define HCI_CONN_HANDLE_MAX		0x0eff
+#define HCI_CONN_HANDLE_UNSET(_handle)	(_handle > HCI_CONN_HANDLE_MAX)
 
 /* Min encryption key size to match with SMP */
 #define HCI_MIN_ENC_KEY_SIZE		7
@@ -352,6 +352,8 @@ struct hci_dev {
 	struct srcu_struct srcu;
 	struct mutex	lock;
 
+	struct ida	unset_handle_ida;
+
 	const char	*name;
 	unsigned long	flags;
 	__u16		id;
@@ -1332,7 +1334,9 @@ bool hci_iso_setup_path(struct hci_conn
 int hci_le_create_cis(struct hci_conn *conn);
 
 struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
-			      u8 role);
+			      u8 role, u16 handle);
+struct hci_conn *hci_conn_add_unset(struct hci_dev *hdev, int type,
+				    bdaddr_t *dst, u8 role);
 int hci_conn_del(struct hci_conn *conn);
 void hci_conn_hash_flush(struct hci_dev *hdev);
 void hci_conn_check_pending(struct hci_dev *hdev);
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -109,7 +109,7 @@ struct hci_conn *phylink_add(struct hci_
 	struct hci_conn *hcon;
 	u8 role = out ? HCI_ROLE_MASTER : HCI_ROLE_SLAVE;
 
-	hcon = hci_conn_add(hdev, AMP_LINK, dst, role);
+	hcon = hci_conn_add(hdev, AMP_LINK, dst, role, __next_handle(mgr));
 	if (!hcon)
 		return NULL;
 
@@ -117,7 +117,6 @@ struct hci_conn *phylink_add(struct hci_
 
 	hcon->state = BT_CONNECT;
 	hcon->attempt++;
-	hcon->handle = __next_handle(mgr);
 	hcon->remote_id = remote_id;
 	hcon->amp_mgr = amp_mgr_get(mgr);
 
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -151,6 +151,9 @@ static void hci_conn_cleanup(struct hci_
 
 	hci_conn_hash_del(hdev, conn);
 
+	if (HCI_CONN_HANDLE_UNSET(conn->handle))
+		ida_free(&hdev->unset_handle_ida, conn->handle);
+
 	if (conn->cleanup)
 		conn->cleanup(conn);
 
@@ -980,12 +983,18 @@ static void cis_cleanup(struct hci_conn
 	hci_le_remove_cig(hdev, conn->iso_qos.cig);
 }
 
+static int hci_conn_hash_alloc_unset(struct hci_dev *hdev)
+{
+	return ida_alloc_range(&hdev->unset_handle_ida, HCI_CONN_HANDLE_MAX + 1,
+			       U16_MAX, GFP_ATOMIC);
+}
+
 struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
-			      u8 role)
+			      u8 role, u16 handle)
 {
 	struct hci_conn *conn;
 
-	BT_DBG("%s dst %pMR", hdev->name, dst);
+	bt_dev_dbg(hdev, "dst %pMR handle 0x%4.4x", dst, handle);
 
 	conn = kzalloc(sizeof(*conn), GFP_KERNEL);
 	if (!conn)
@@ -993,7 +1002,7 @@ struct hci_conn *hci_conn_add(struct hci
 
 	bacpy(&conn->dst, dst);
 	bacpy(&conn->src, &hdev->bdaddr);
-	conn->handle = HCI_CONN_HANDLE_UNSET;
+	conn->handle = handle;
 	conn->hdev  = hdev;
 	conn->type  = type;
 	conn->role  = role;
@@ -1077,6 +1086,20 @@ struct hci_conn *hci_conn_add(struct hci
 	return conn;
 }
 
+struct hci_conn *hci_conn_add_unset(struct hci_dev *hdev, int type,
+				    bdaddr_t *dst, u8 role)
+{
+	int handle;
+
+	bt_dev_dbg(hdev, "dst %pMR", dst);
+
+	handle = hci_conn_hash_alloc_unset(hdev);
+	if (unlikely(handle < 0))
+		return NULL;
+
+	return hci_conn_add(hdev, type, dst, role, handle);
+}
+
 static bool hci_conn_unlink(struct hci_conn *conn)
 {
 	if (!conn->link)
@@ -1107,7 +1130,7 @@ int hci_conn_del(struct hci_conn *conn)
 			 * yet at this point. Delete it now, otherwise it is
 			 * possible for it to be stuck and can't be deleted.
 			 */
-			if (link->handle == HCI_CONN_HANDLE_UNSET)
+			if (HCI_CONN_HANDLE_UNSET(link->handle))
 				hci_conn_del(link);
 		}
 
@@ -1336,7 +1359,7 @@ struct hci_conn *hci_connect_le(struct h
 	if (conn) {
 		bacpy(&conn->dst, dst);
 	} else {
-		conn = hci_conn_add(hdev, LE_LINK, dst, role);
+		conn = hci_conn_add_unset(hdev, LE_LINK, dst, role);
 		if (!conn)
 			return ERR_PTR(-ENOMEM);
 		hci_conn_hold(conn);
@@ -1503,7 +1526,7 @@ static struct hci_conn *hci_add_bis(stru
 	if (conn)
 		return ERR_PTR(-EADDRINUSE);
 
-	conn = hci_conn_add(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
+	conn = hci_conn_add_unset(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
 	if (!conn)
 		return ERR_PTR(-ENOMEM);
 
@@ -1548,7 +1571,7 @@ struct hci_conn *hci_connect_le_scan(str
 
 	BT_DBG("requesting refresh of dst_addr");
 
-	conn = hci_conn_add(hdev, LE_LINK, dst, HCI_ROLE_MASTER);
+	conn = hci_conn_add_unset(hdev, LE_LINK, dst, HCI_ROLE_MASTER);
 	if (!conn)
 		return ERR_PTR(-ENOMEM);
 
@@ -1596,7 +1619,7 @@ struct hci_conn *hci_connect_acl(struct
 
 	acl = hci_conn_hash_lookup_ba(hdev, ACL_LINK, dst);
 	if (!acl) {
-		acl = hci_conn_add(hdev, ACL_LINK, dst, HCI_ROLE_MASTER);
+		acl = hci_conn_add_unset(hdev, ACL_LINK, dst, HCI_ROLE_MASTER);
 		if (!acl)
 			return ERR_PTR(-ENOMEM);
 	}
@@ -1627,7 +1650,7 @@ struct hci_conn *hci_connect_sco(struct
 
 	sco = hci_conn_hash_lookup_ba(hdev, type, dst);
 	if (!sco) {
-		sco = hci_conn_add(hdev, type, dst, HCI_ROLE_MASTER);
+		sco = hci_conn_add_unset(hdev, type, dst, HCI_ROLE_MASTER);
 		if (!sco) {
 			hci_conn_drop(acl);
 			return ERR_PTR(-ENOMEM);
@@ -1837,7 +1860,7 @@ struct hci_conn *hci_bind_cis(struct hci
 
 	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type);
 	if (!cis) {
-		cis = hci_conn_add(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
+		cis = hci_conn_add_unset(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
 		if (!cis)
 			return ERR_PTR(-ENOMEM);
 		cis->cleanup = cis_cleanup;
@@ -2247,7 +2270,7 @@ struct hci_conn *hci_connect_cis(struct
 	/* If LE is already connected and CIS handle is already set proceed to
 	 * Create CIS immediately.
 	 */
-	if (le->state == BT_CONNECTED && cis->handle != HCI_CONN_HANDLE_UNSET)
+	if (le->state == BT_CONNECTED && !HCI_CONN_HANDLE_UNSET(cis->handle))
 		hci_le_create_cis(le);
 
 	return cis;
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2525,6 +2525,8 @@ struct hci_dev *hci_alloc_dev_priv(int s
 	mutex_init(&hdev->lock);
 	mutex_init(&hdev->req_lock);
 
+	ida_init(&hdev->unset_handle_ida);
+
 	INIT_LIST_HEAD(&hdev->mesh_pending);
 	INIT_LIST_HEAD(&hdev->mgmt_pending);
 	INIT_LIST_HEAD(&hdev->reject_list);
@@ -2784,6 +2786,7 @@ void hci_release_dev(struct hci_dev *hde
 	msft_release(hdev);
 	hci_dev_unlock(hdev);
 
+	ida_destroy(&hdev->unset_handle_ida);
 	ida_simple_remove(&hci_index_ida, hdev->id);
 	kfree_skb(hdev->sent_cmd);
 	kfree_skb(hdev->recv_event);
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2317,8 +2317,8 @@ static void hci_cs_create_conn(struct hc
 		}
 	} else {
 		if (!conn) {
-			conn = hci_conn_add(hdev, ACL_LINK, &cp->bdaddr,
-					    HCI_ROLE_MASTER);
+			conn = hci_conn_add_unset(hdev, ACL_LINK, &cp->bdaddr,
+						  HCI_ROLE_MASTER);
 			if (!conn)
 				bt_dev_err(hdev, "no memory for new connection");
 		}
@@ -3160,8 +3160,8 @@ static void hci_conn_complete_evt(struct
 		    hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
 						      &ev->bdaddr,
 						      BDADDR_BREDR)) {
-			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
-					    HCI_ROLE_SLAVE);
+			conn = hci_conn_add_unset(hdev, ev->link_type,
+						  &ev->bdaddr, HCI_ROLE_SLAVE);
 			if (!conn) {
 				bt_dev_err(hdev, "no memory for new conn");
 				goto unlock;
@@ -3185,20 +3185,24 @@ static void hci_conn_complete_evt(struct
 	 * As the connection handle is set here for the first time, it indicates
 	 * whether the connection is already set up.
 	 */
-	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+	if (!HCI_CONN_HANDLE_UNSET(conn->handle)) {
 		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
 		goto unlock;
 	}
 
 	if (!status) {
-		conn->handle = __le16_to_cpu(ev->handle);
-		if (conn->handle > HCI_CONN_HANDLE_MAX) {
+		if (__le16_to_cpu(ev->handle) > HCI_CONN_HANDLE_MAX) {
 			bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
-				   conn->handle, HCI_CONN_HANDLE_MAX);
+				   __le16_to_cpu(ev->handle),
+				   HCI_CONN_HANDLE_MAX);
 			status = HCI_ERROR_INVALID_PARAMETERS;
 			goto done;
 		}
 
+		if (HCI_CONN_HANDLE_UNSET(conn->handle))
+			ida_free(&hdev->unset_handle_ida, conn->handle);
+		conn->handle = __le16_to_cpu(ev->handle);
+
 		if (conn->type == ACL_LINK) {
 			conn->state = BT_CONFIG;
 			hci_conn_hold(conn);
@@ -3355,8 +3359,8 @@ static void hci_conn_request_evt(struct
 	conn = hci_conn_hash_lookup_ba(hdev, ev->link_type,
 			&ev->bdaddr);
 	if (!conn) {
-		conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
-				    HCI_ROLE_SLAVE);
+		conn = hci_conn_add_unset(hdev, ev->link_type, &ev->bdaddr,
+					  HCI_ROLE_SLAVE);
 		if (!conn) {
 			bt_dev_err(hdev, "no memory for new connection");
 			goto unlock;
@@ -3867,6 +3871,8 @@ static u8 hci_cc_le_set_cig_params(struc
 		    conn->state == BT_CONNECTED)
 			continue;
 
+		if (HCI_CONN_HANDLE_UNSET(conn->handle))
+			ida_free(&hdev->unset_handle_ida, conn->handle);
 		conn->handle = __le16_to_cpu(rp->handle[i++]);
 
 		bt_dev_dbg(hdev, "%p handle 0x%4.4x link %p", conn,
@@ -5050,22 +5056,26 @@ static void hci_sync_conn_complete_evt(s
 	 * As the connection handle is set here for the first time, it indicates
 	 * whether the connection is already set up.
 	 */
-	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+	if (!HCI_CONN_HANDLE_UNSET(conn->handle)) {
 		bt_dev_err(hdev, "Ignoring HCI_Sync_Conn_Complete event for existing connection");
 		goto unlock;
 	}
 
 	switch (status) {
 	case 0x00:
-		conn->handle = __le16_to_cpu(ev->handle);
-		if (conn->handle > HCI_CONN_HANDLE_MAX) {
+		if (__le16_to_cpu(ev->handle) > HCI_CONN_HANDLE_MAX) {
 			bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
-				   conn->handle, HCI_CONN_HANDLE_MAX);
+				   __le16_to_cpu(ev->handle),
+				   HCI_CONN_HANDLE_MAX);
 			status = HCI_ERROR_INVALID_PARAMETERS;
 			conn->state = BT_CLOSED;
 			break;
 		}
 
+		if (HCI_CONN_HANDLE_UNSET(conn->handle))
+			ida_free(&hdev->unset_handle_ida, conn->handle);
+		conn->handle = __le16_to_cpu(ev->handle);
+
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
 
@@ -5752,7 +5762,7 @@ static void le_conn_complete_evt(struct
 		if (status)
 			goto unlock;
 
-		conn = hci_conn_add(hdev, LE_LINK, bdaddr, role);
+		conn = hci_conn_add_unset(hdev, LE_LINK, bdaddr, role);
 		if (!conn) {
 			bt_dev_err(hdev, "no memory for new connection");
 			goto unlock;
@@ -5790,7 +5800,7 @@ static void le_conn_complete_evt(struct
 	 * As the connection handle is set here for the first time, it indicates
 	 * whether the connection is already set up.
 	 */
-	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+	if (!HCI_CONN_HANDLE_UNSET(conn->handle)) {
 		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
 		goto unlock;
 	}
@@ -5848,6 +5858,8 @@ static void le_conn_complete_evt(struct
 		mgmt_device_connected(hdev, conn, NULL, 0);
 
 	conn->sec_level = BT_SECURITY_LOW;
+	if (HCI_CONN_HANDLE_UNSET(conn->handle))
+		ida_free(&hdev->unset_handle_ida, conn->handle);
 	conn->handle = handle;
 	conn->state = BT_CONFIG;
 
@@ -6849,12 +6861,12 @@ static void hci_le_cis_req_evt(struct hc
 
 	cis = hci_conn_hash_lookup_handle(hdev, cis_handle);
 	if (!cis) {
-		cis = hci_conn_add(hdev, ISO_LINK, &acl->dst, HCI_ROLE_SLAVE);
+		cis = hci_conn_add(hdev, ISO_LINK, &acl->dst, HCI_ROLE_SLAVE,
+				   cis_handle);
 		if (!cis) {
 			hci_le_reject_cis(hdev, ev->cis_handle);
 			goto unlock;
 		}
-		cis->handle = cis_handle;
 	}
 
 	cis->iso_qos.cig = ev->cig_id;
@@ -6896,8 +6908,11 @@ static void hci_le_create_big_complete_e
 		goto unlock;
 	}
 
-	if (ev->num_bis)
+	if (ev->num_bis) {
+		if (HCI_CONN_HANDLE_UNSET(conn->handle))
+			ida_free(&hdev->unset_handle_ida, conn->handle);
 		conn->handle = __le16_to_cpu(ev->bis_handle[0]);
+	}
 
 	if (!ev->status) {
 		conn->state = BT_CONNECTED;
@@ -6939,10 +6954,9 @@ static void hci_le_big_sync_established_
 		bis = hci_conn_hash_lookup_handle(hdev, handle);
 		if (!bis) {
 			bis = hci_conn_add(hdev, ISO_LINK, BDADDR_ANY,
-					   HCI_ROLE_SLAVE);
+					   HCI_ROLE_SLAVE, handle);
 			if (!bis)
 				continue;
-			bis->handle = handle;
 		}
 
 		bis->iso_qos.big = ev->handle;


