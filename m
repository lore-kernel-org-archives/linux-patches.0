Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAF512C54B;
	Tue, 30 Apr 2024 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474189; cv=none; b=eVKLQPTL50aVSPAx0bMbwXAP0VL7b90tnPZXy9ADB6zVcTwwJTvP0nlUuhX84S4V3hI/3EpbAZAG9JjwIp5p03CoI5qITNbCMYwxp3rA7dSO60qFfiv/D5kMTJ2e+wCgi8frtgtmL2AaCeQpvjH6lr9iriRTEOrHHCzalU5WZlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474189; c=relaxed/simple;
	bh=Qn1t5DdhFOgxvooTVbax7E0TLHVVzNUU+j+DBMRT1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTsCb9u7c6ieB0hXuCn0ziH5GklECHx38jKe/nrQrh3IkGW9TkJ5l63uIWPoOTWD3ONRc44uuFZiBRvWCIVrXKlsFrUeQUEarUmqsJbIxkLWiiKSBmCRe7aJ44Qip1/OF2AXwj5OUcae2uHJ7PB3VlkBTOe0I+9GZ6gLB0AI+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCvQRFD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCvQRFD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215C5C2BBFC;
	Tue, 30 Apr 2024 10:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474189;
	bh=Qn1t5DdhFOgxvooTVbax7E0TLHVVzNUU+j+DBMRT1bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCvQRFD5TM+k2qPBxRWo3w34Cifo60AekHEbTp2J8CnYoNUPzi5/62j3QVlSo0DTv
	 f2+kFnCbzS+0iwPMADd/MXz2pkTvQHCKeVxKnf2NMxA2GC62hM6ZULJTOvq6J3Rd0r
	 HpDNYToIKxFcsKIJxE6rLRR9OSBrE3Y7mVTDnxN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 083/228] Bluetooth: hci_sync: Attempt to dequeue connection attempt
Date: Tue, 30 Apr 2024 12:37:41 +0200
Message-ID: <20240430103106.198598375@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 881559af5f5c545f6828e7c74d79813eb886d523 ]

If connection is still queued/pending in the cmd_sync queue it means no
command has been generated and it should be safe to just dequeue the
callback when it is being aborted.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 19 ++++++++
 include/net/bluetooth/hci_sync.h | 10 +++--
 net/bluetooth/hci_conn.c         | 70 ++++++------------------------
 net/bluetooth/hci_sync.c         | 74 ++++++++++++++++++++++++++++----
 4 files changed, 102 insertions(+), 71 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 65da50f216069..93e2b17b11267 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1084,6 +1084,24 @@ static inline unsigned int hci_conn_count(struct hci_dev *hdev)
 	return c->acl_num + c->amp_num + c->sco_num + c->le_num + c->iso_num;
 }
 
+static inline bool hci_conn_valid(struct hci_dev *hdev, struct hci_conn *conn)
+{
+	struct hci_conn_hash *h = &hdev->conn_hash;
+	struct hci_conn  *c;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(c, &h->list, list) {
+		if (c == conn) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
+
 static inline __u8 hci_conn_lookup_type(struct hci_dev *hdev, __u16 handle)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
@@ -1494,6 +1512,7 @@ struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 				u8 dst_type, bool dst_resolved, u8 sec_level,
 				u16 conn_timeout, u8 role);
+void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status);
 struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 				 u8 sec_level, u8 auth_type,
 				 enum conn_reasons conn_reason, u16 timeout);
diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 4ff4aa68ee196..6a9d063e9f472 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -48,11 +48,11 @@ int hci_cmd_sync_submit(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			void *data, hci_cmd_sync_work_destroy_t destroy);
 int hci_cmd_sync_queue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 		       void *data, hci_cmd_sync_work_destroy_t destroy);
+int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			    void *data, hci_cmd_sync_work_destroy_t destroy);
 struct hci_cmd_sync_work_entry *
 hci_cmd_sync_lookup_entry(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			  void *data, hci_cmd_sync_work_destroy_t destroy);
-int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
-			    void *data, hci_cmd_sync_work_destroy_t destroy);
 void hci_cmd_sync_cancel_entry(struct hci_dev *hdev,
 			       struct hci_cmd_sync_work_entry *entry);
 bool hci_cmd_sync_dequeue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
@@ -139,8 +139,6 @@ struct hci_conn;
 
 int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason);
 
-int hci_le_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn);
-
 int hci_le_create_cis_sync(struct hci_dev *hdev);
 
 int hci_le_remove_cig_sync(struct hci_dev *hdev, u8 handle);
@@ -152,3 +150,7 @@ int hci_le_big_terminate_sync(struct hci_dev *hdev, u8 handle);
 int hci_le_pa_terminate_sync(struct hci_dev *hdev, u16 handle);
 
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn);
+
+int hci_connect_le_sync(struct hci_dev *hdev, struct hci_conn *conn);
+
+int hci_cancel_connect_sync(struct hci_dev *hdev, struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3475ea55c2534..3a66d357b9323 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -68,7 +68,7 @@ static const struct sco_param esco_param_msbc[] = {
 };
 
 /* This function requires the caller holds hdev->lock */
-static void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status)
+void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status)
 {
 	struct hci_conn_params *params;
 	struct hci_dev *hdev = conn->hdev;
@@ -1124,6 +1124,9 @@ void hci_conn_del(struct hci_conn *conn)
 	 * rest of hci_conn_del.
 	 */
 	hci_conn_cleanup(conn);
+
+	/* Dequeue callbacks using connection pointer as data */
+	hci_cmd_sync_dequeue(hdev, NULL, conn, NULL);
 }
 
 struct hci_dev *hci_get_route(bdaddr_t *dst, bdaddr_t *src, uint8_t src_type)
@@ -1258,53 +1261,6 @@ u8 hci_conn_set_handle(struct hci_conn *conn, u16 handle)
 	return 0;
 }
 
-static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
-{
-	struct hci_conn *conn;
-	u16 handle = PTR_UINT(data);
-
-	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (!conn)
-		return;
-
-	bt_dev_dbg(hdev, "err %d", err);
-
-	hci_dev_lock(hdev);
-
-	if (!err) {
-		hci_connect_le_scan_cleanup(conn, 0x00);
-		goto done;
-	}
-
-	/* Check if connection is still pending */
-	if (conn != hci_lookup_le_connect(hdev))
-		goto done;
-
-	/* Flush to make sure we send create conn cancel command if needed */
-	flush_delayed_work(&conn->le_conn_timeout);
-	hci_conn_failed(conn, bt_status(err));
-
-done:
-	hci_dev_unlock(hdev);
-}
-
-static int hci_connect_le_sync(struct hci_dev *hdev, void *data)
-{
-	struct hci_conn *conn;
-	u16 handle = PTR_UINT(data);
-
-	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (!conn)
-		return 0;
-
-	bt_dev_dbg(hdev, "conn %p", conn);
-
-	clear_bit(HCI_CONN_SCANNING, &conn->flags);
-	conn->state = BT_CONNECT;
-
-	return hci_le_create_conn_sync(hdev, conn);
-}
-
 struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 				u8 dst_type, bool dst_resolved, u8 sec_level,
 				u16 conn_timeout, u8 role)
@@ -1371,9 +1327,7 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	conn->sec_level = BT_SECURITY_LOW;
 	conn->conn_timeout = conn_timeout;
 
-	err = hci_cmd_sync_queue(hdev, hci_connect_le_sync,
-				 UINT_PTR(conn->handle),
-				 create_le_conn_complete);
+	err = hci_connect_le_sync(hdev, conn);
 	if (err) {
 		hci_conn_del(conn);
 		return ERR_PTR(err);
@@ -2909,12 +2863,10 @@ u32 hci_conn_get_phy(struct hci_conn *conn)
 
 static int abort_conn_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_conn *conn;
-	u16 handle = PTR_UINT(data);
+	struct hci_conn *conn = data;
 
-	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (!conn)
-		return 0;
+	if (!hci_conn_valid(hdev, conn))
+		return -ECANCELED;
 
 	return hci_abort_conn_sync(hdev, conn, conn->abort_reason);
 }
@@ -2949,8 +2901,10 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 			hci_cmd_sync_cancel(hdev, ECANCELED);
 			break;
 		}
+	/* Cancel connect attempt if still queued/pending */
+	} else if (!hci_cancel_connect_sync(hdev, conn)) {
+		return 0;
 	}
 
-	return hci_cmd_sync_queue(hdev, abort_conn_sync, UINT_PTR(conn->handle),
-				  NULL);
+	return hci_cmd_sync_queue_once(hdev, abort_conn_sync, conn, NULL);
 }
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 22db2949eb3ef..ed7db30ac0e0d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6344,12 +6344,21 @@ static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
 					conn->conn_timeout, NULL);
 }
 
-int hci_le_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn)
+static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 {
 	struct hci_cp_le_create_conn cp;
 	struct hci_conn_params *params;
 	u8 own_addr_type;
 	int err;
+	struct hci_conn *conn = data;
+
+	if (!hci_conn_valid(hdev, conn))
+		return -ECANCELED;
+
+	bt_dev_dbg(hdev, "conn %p", conn);
+
+	clear_bit(HCI_CONN_SCANNING, &conn->flags);
+	conn->state = BT_CONNECT;
 
 	/* If requested to connect as peripheral use directed advertising */
 	if (conn->role == HCI_ROLE_SLAVE) {
@@ -6670,16 +6679,11 @@ int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 
 static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_conn *conn;
-	u16 handle = PTR_UINT(data);
+	struct hci_conn *conn = data;
 	struct inquiry_entry *ie;
 	struct hci_cp_create_conn cp;
 	int err;
 
-	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (!conn)
-		return 0;
-
 	/* Many controllers disallow HCI Create Connection while it is doing
 	 * HCI Inquiry. So we cancel the Inquiry first before issuing HCI Create
 	 * Connection. This may cause the MGMT discovering state to become false
@@ -6738,6 +6742,58 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
-	return hci_cmd_sync_queue(hdev, hci_acl_create_conn_sync,
-				  UINT_PTR(conn->handle), NULL);
+	return hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync, conn,
+				       NULL);
+}
+
+static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
+{
+	struct hci_conn *conn = data;
+
+	bt_dev_dbg(hdev, "err %d", err);
+
+	if (err == -ECANCELED)
+		return;
+
+	hci_dev_lock(hdev);
+
+	if (!err) {
+		hci_connect_le_scan_cleanup(conn, 0x00);
+		goto done;
+	}
+
+	/* Check if connection is still pending */
+	if (conn != hci_lookup_le_connect(hdev))
+		goto done;
+
+	/* Flush to make sure we send create conn cancel command if needed */
+	flush_delayed_work(&conn->le_conn_timeout);
+	hci_conn_failed(conn, bt_status(err));
+
+done:
+	hci_dev_unlock(hdev);
+}
+
+int hci_connect_le_sync(struct hci_dev *hdev, struct hci_conn *conn)
+{
+	return hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync, conn,
+				       create_le_conn_complete);
+}
+
+int hci_cancel_connect_sync(struct hci_dev *hdev, struct hci_conn *conn)
+{
+	if (conn->state != BT_OPEN)
+		return -EINVAL;
+
+	switch (conn->type) {
+	case ACL_LINK:
+		return !hci_cmd_sync_dequeue_once(hdev,
+						  hci_acl_create_conn_sync,
+						  conn, NULL);
+	case LE_LINK:
+		return !hci_cmd_sync_dequeue_once(hdev, hci_le_create_conn_sync,
+						  conn, create_le_conn_complete);
+	}
+
+	return -ENOENT;
 }
-- 
2.43.0



