Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669DB211A2A;
	Wed,  7 May 2025 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644033; cv=none; b=CAerij5gR4gWjLkwOIDLL1ilLzfojMqqfsz4Xc602WeYKuQv0xl59QqTMYP38nO6xN4ncuFwHNsO3R8wVJxlmUQcKax4FsSdensF2YJYvPbVtyFt65OQcjwXqhRsh9Lf5ybrM8zMogOHBsDkklGjgsNtItYkS85JTekURWDYxmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644033; c=relaxed/simple;
	bh=cSWZ4NQCfYqAZWwOsmG7x9PTAmkud4QQb3AHCu9ahxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUHohFjFc07WBnT7ZGXgQNRTTozl1BeoGmZpyZld/gmxBvpPgQaFFsXlG9Fu0AKsu5EnH5dVGwy3ZMcdtn8H6eyqKdgzXqrab1UeOvIvyxl7lEMyj5YnX4VzE2I8Y1O0RxZzr0Sn/w3w9FkWnsoh5mwu7yxOu9OQluTZcJ7KK0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUq87dds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUq87dds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAA9C4CEE2;
	Wed,  7 May 2025 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644032;
	bh=cSWZ4NQCfYqAZWwOsmG7x9PTAmkud4QQb3AHCu9ahxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUq87ddsLWpyE1PK3w1zsDE9THwhUIfyysvmXKt/Zof9uc8Br4IRzEu6Y7qztnGOE
	 AQ6Wgu1XuoUlBm55MpgsElnZACfUDueOQqJYqIEI4ef07pe+OwGjq231ztlutRAJqL
	 OxA42WVy8XT/GeILb6bUyidzlm69g2JTE+8fEm6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 080/183] Bluetooth: hci_conn: Fix not setting conn_timeout for Broadcast Receiver
Date: Wed,  7 May 2025 20:38:45 +0200
Message-ID: <20250507183827.927500058@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6d0417e4e1cf66fd917f06f0454958362714ef7d ]

Broadcast Receiver requires creating PA sync but the command just
generates a status so this makes use of __hci_cmd_sync_status_sk to wait
for HCI_EV_LE_PA_SYNC_ESTABLISHED, also because of this chance it is not
longer necessary to use a custom method to serialize the process of
creating the PA sync since the cmd_work_sync itself ensures only one
command would be pending which now awaits for
HCI_EV_LE_PA_SYNC_ESTABLISHED before proceeding to next connection.

Fixes: 4a5e0ba68676 ("Bluetooth: ISO: Do not emit LE PA Create Sync if previous is pending")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |  2 +
 include/net/bluetooth/hci_core.h | 13 +++--
 include/net/bluetooth/hci_sync.h |  2 +
 net/bluetooth/hci_conn.c         | 92 +-------------------------------
 net/bluetooth/hci_event.c        |  6 +--
 net/bluetooth/hci_sync.c         | 87 ++++++++++++++++++++++++++++--
 6 files changed, 95 insertions(+), 107 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index a8586c3058c7c..8ea7a063cc651 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1931,6 +1931,8 @@ struct hci_cp_le_pa_create_sync {
 	__u8      sync_cte_type;
 } __packed;
 
+#define HCI_OP_LE_PA_CREATE_SYNC_CANCEL	0x2045
+
 #define HCI_OP_LE_PA_TERM_SYNC		0x2046
 struct hci_cp_le_pa_term_sync {
 	__le16    handle;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f0b49aad519eb..49f51877988d8 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1105,10 +1105,8 @@ static inline struct hci_conn *hci_conn_hash_lookup_bis(struct hci_dev *hdev,
 	return NULL;
 }
 
-static inline struct hci_conn *hci_conn_hash_lookup_sid(struct hci_dev *hdev,
-							__u8 sid,
-							bdaddr_t *dst,
-							__u8 dst_type)
+static inline struct hci_conn *
+hci_conn_hash_lookup_create_pa_sync(struct hci_dev *hdev)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
 	struct hci_conn  *c;
@@ -1116,8 +1114,10 @@ static inline struct hci_conn *hci_conn_hash_lookup_sid(struct hci_dev *hdev,
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (c->type != ISO_LINK  || bacmp(&c->dst, dst) ||
-		    c->dst_type != dst_type || c->sid != sid)
+		if (c->type != ISO_LINK)
+			continue;
+
+		if (!test_bit(HCI_CONN_CREATE_PA_SYNC, &c->flags))
 			continue;
 
 		rcu_read_unlock();
@@ -1516,7 +1516,6 @@ bool hci_setup_sync(struct hci_conn *conn, __u16 handle);
 void hci_sco_setup(struct hci_conn *conn, __u8 status);
 bool hci_iso_setup_path(struct hci_conn *conn);
 int hci_le_create_cis_pending(struct hci_dev *hdev);
-int hci_pa_create_sync_pending(struct hci_dev *hdev);
 int hci_le_big_create_sync_pending(struct hci_dev *hdev);
 int hci_conn_check_create_cis(struct hci_conn *conn);
 
diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 7e2cf0cca939a..93dac4c7f9e3e 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -185,3 +185,5 @@ int hci_connect_le_sync(struct hci_dev *hdev, struct hci_conn *conn);
 int hci_cancel_connect_sync(struct hci_dev *hdev, struct hci_conn *conn);
 int hci_le_conn_update_sync(struct hci_dev *hdev, struct hci_conn *conn,
 			    struct hci_conn_params *params);
+
+int hci_connect_pa_sync(struct hci_dev *hdev, struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index d097e308a7554..badaa6c199204 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2061,95 +2061,6 @@ static int create_big_sync(struct hci_dev *hdev, void *data)
 	return hci_le_create_big(conn, &conn->iso_qos);
 }
 
-static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
-{
-	bt_dev_dbg(hdev, "");
-
-	if (err)
-		bt_dev_err(hdev, "Unable to create PA: %d", err);
-}
-
-static bool hci_conn_check_create_pa_sync(struct hci_conn *conn)
-{
-	if (conn->type != ISO_LINK || conn->sid == HCI_SID_INVALID)
-		return false;
-
-	return true;
-}
-
-static int create_pa_sync(struct hci_dev *hdev, void *data)
-{
-	struct hci_cp_le_pa_create_sync cp = {0};
-	struct hci_conn *conn;
-	int err = 0;
-
-	hci_dev_lock(hdev);
-
-	rcu_read_lock();
-
-	/* The spec allows only one pending LE Periodic Advertising Create
-	 * Sync command at a time. If the command is pending now, don't do
-	 * anything. We check for pending connections after each PA Sync
-	 * Established event.
-	 *
-	 * BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
-	 * page 2493:
-	 *
-	 * If the Host issues this command when another HCI_LE_Periodic_
-	 * Advertising_Create_Sync command is pending, the Controller shall
-	 * return the error code Command Disallowed (0x0C).
-	 */
-	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
-		if (test_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags))
-			goto unlock;
-	}
-
-	list_for_each_entry_rcu(conn, &hdev->conn_hash.list, list) {
-		if (hci_conn_check_create_pa_sync(conn)) {
-			struct bt_iso_qos *qos = &conn->iso_qos;
-
-			cp.options = qos->bcast.options;
-			cp.sid = conn->sid;
-			cp.addr_type = conn->dst_type;
-			bacpy(&cp.addr, &conn->dst);
-			cp.skip = cpu_to_le16(qos->bcast.skip);
-			cp.sync_timeout = cpu_to_le16(qos->bcast.sync_timeout);
-			cp.sync_cte_type = qos->bcast.sync_cte_type;
-
-			break;
-		}
-	}
-
-unlock:
-	rcu_read_unlock();
-
-	hci_dev_unlock(hdev);
-
-	if (bacmp(&cp.addr, BDADDR_ANY)) {
-		hci_dev_set_flag(hdev, HCI_PA_SYNC);
-		set_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
-
-		err = __hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC,
-					    sizeof(cp), &cp, HCI_CMD_TIMEOUT);
-		if (!err)
-			err = hci_update_passive_scan_sync(hdev);
-
-		if (err) {
-			hci_dev_clear_flag(hdev, HCI_PA_SYNC);
-			clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
-		}
-	}
-
-	return err;
-}
-
-int hci_pa_create_sync_pending(struct hci_dev *hdev)
-{
-	/* Queue start pa_create_sync and scan */
-	return hci_cmd_sync_queue(hdev, create_pa_sync,
-				  NULL, create_pa_complete);
-}
-
 struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
 				    __u8 dst_type, __u8 sid,
 				    struct bt_iso_qos *qos)
@@ -2164,10 +2075,11 @@ struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
 	conn->dst_type = dst_type;
 	conn->sid = sid;
 	conn->state = BT_LISTEN;
+	conn->conn_timeout = msecs_to_jiffies(qos->bcast.sync_timeout * 10);
 
 	hci_conn_hold(conn);
 
-	hci_pa_create_sync_pending(hdev);
+	hci_connect_pa_sync(hdev, conn);
 
 	return conn;
 }
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 20d3cdcb14f6c..216db540e502c 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6371,8 +6371,7 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
-	conn = hci_conn_hash_lookup_sid(hdev, ev->sid, &ev->bdaddr,
-					ev->bdaddr_type);
+	conn = hci_conn_hash_lookup_create_pa_sync(hdev);
 	if (!conn) {
 		bt_dev_err(hdev,
 			   "Unable to find connection for dst %pMR sid 0x%2.2x",
@@ -6411,9 +6410,6 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 	}
 
 unlock:
-	/* Handle any other pending PA sync command */
-	hci_pa_create_sync_pending(hdev);
-
 	hci_dev_unlock(hdev);
 }
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 14c3ee5c6a1e8..9d03717263bf8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2693,16 +2693,16 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 	/* Force address filtering if PA Sync is in progress */
 	if (hci_dev_test_flag(hdev, HCI_PA_SYNC)) {
-		struct hci_cp_le_pa_create_sync *sent;
+		struct hci_conn *conn;
 
-		sent = hci_sent_cmd_data(hdev, HCI_OP_LE_PA_CREATE_SYNC);
-		if (sent) {
+		conn = hci_conn_hash_lookup_create_pa_sync(hdev);
+		if (conn) {
 			struct conn_params pa;
 
 			memset(&pa, 0, sizeof(pa));
 
-			bacpy(&pa.addr, &sent->addr);
-			pa.addr_type = sent->addr_type;
+			bacpy(&pa.addr, &conn->dst);
+			pa.addr_type = conn->dst_type;
 
 			/* Clear first since there could be addresses left
 			 * behind.
@@ -6895,3 +6895,80 @@ int hci_le_conn_update_sync(struct hci_dev *hdev, struct hci_conn *conn,
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_CONN_UPDATE,
 				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
 }
+
+static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
+{
+	bt_dev_dbg(hdev, "err %d", err);
+
+	if (!err)
+		return;
+
+	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
+
+	if (err == -ECANCELED)
+		return;
+
+	hci_dev_lock(hdev);
+
+	hci_update_passive_scan_sync(hdev);
+
+	hci_dev_unlock(hdev);
+}
+
+static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
+{
+	struct hci_cp_le_pa_create_sync cp;
+	struct hci_conn *conn = data;
+	struct bt_iso_qos *qos = &conn->iso_qos;
+	int err;
+
+	if (!hci_conn_valid(hdev, conn))
+		return -ECANCELED;
+
+	if (hci_dev_test_and_set_flag(hdev, HCI_PA_SYNC))
+		return -EBUSY;
+
+	/* Mark HCI_CONN_CREATE_PA_SYNC so hci_update_passive_scan_sync can
+	 * program the address in the allow list so PA advertisements can be
+	 * received.
+	 */
+	set_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
+
+	hci_update_passive_scan_sync(hdev);
+
+	memset(&cp, 0, sizeof(cp));
+	cp.options = qos->bcast.options;
+	cp.sid = conn->sid;
+	cp.addr_type = conn->dst_type;
+	bacpy(&cp.addr, &conn->dst);
+	cp.skip = cpu_to_le16(qos->bcast.skip);
+	cp.sync_timeout = cpu_to_le16(qos->bcast.sync_timeout);
+	cp.sync_cte_type = qos->bcast.sync_cte_type;
+
+	/* The spec allows only one pending LE Periodic Advertising Create
+	 * Sync command at a time so we forcefully wait for PA Sync Established
+	 * event since cmd_work can only schedule one command at a time.
+	 *
+	 * BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
+	 * page 2493:
+	 *
+	 * If the Host issues this command when another HCI_LE_Periodic_
+	 * Advertising_Create_Sync command is pending, the Controller shall
+	 * return the error code Command Disallowed (0x0C).
+	 */
+	err = __hci_cmd_sync_status_sk(hdev, HCI_OP_LE_PA_CREATE_SYNC,
+				       sizeof(cp), &cp,
+				       HCI_EV_LE_PA_SYNC_ESTABLISHED,
+				       conn->conn_timeout, NULL);
+	if (err == -ETIMEDOUT)
+		__hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC_CANCEL,
+				      0, NULL, HCI_CMD_TIMEOUT);
+
+	return err;
+}
+
+int hci_connect_pa_sync(struct hci_dev *hdev, struct hci_conn *conn)
+{
+	return hci_cmd_sync_queue_once(hdev, hci_le_pa_create_sync, conn,
+				       create_pa_complete);
+}
-- 
2.39.5



