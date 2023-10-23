Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D4414A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLYucH6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A2CC433C7;
	Mon, 23 Oct 2023 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059447;
	bh=yyKHfo/TVfTOZmOYxw7dB+J6LHprRwU7qoU6lOt0k8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLYucH6lUxqXHmFB5xDizI7vcmk+sbYFV2CC0E2DuGe9dE6DvO4nE5g4NhEul0VFA
	 g7jbfU6GlC62/2TE7DrrDdkK3O1L53RoJHbEPB1H/XG8eF6/fg1jOtTv2yabE7Rc1e
	 Zs45B+FL+ey17JUXTbxOCk51DkUmlLG+powv3zEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 144/241] Bluetooth: hci_sync: Fix not handling ISO_LINK in hci_abort_conn_sync
Date: Mon, 23 Oct 2023 12:55:30 +0200
Message-ID: <20231023104837.383209674@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 04a51d616929eb96b7a3e547bc11d3bb46af2c9f ]

ISO_LINK connections where not being handled properly on
hci_abort_conn_sync which sometimes resulted in sending the wrong
commands, or in case of having the reject command being sent by the
socket code (iso.c) which is sort of a layer violation.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: acab8ff29a2a ("Bluetooth: ISO: Fix invalid context error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 23 +++++++++++++++++++----
 net/bluetooth/hci_sync.c | 34 ++++++++++++++++++++++++++++++++++
 net/bluetooth/iso.c      | 14 --------------
 3 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 41250e4b94dff..4e9654fe89c9e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1277,7 +1277,12 @@ u8 hci_conn_set_handle(struct hci_conn *conn, u16 handle)
 
 static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 {
-	struct hci_conn *conn = data;
+	struct hci_conn *conn;
+	u16 handle = PTR_ERR(data);
+
+	conn = hci_conn_hash_lookup_handle(hdev, handle);
+	if (!conn)
+		return;
 
 	bt_dev_dbg(hdev, "err %d", err);
 
@@ -1302,10 +1307,17 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 
 static int hci_connect_le_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_conn *conn = data;
+	struct hci_conn *conn;
+	u16 handle = PTR_ERR(data);
+
+	conn = hci_conn_hash_lookup_handle(hdev, handle);
+	if (!conn)
+		return 0;
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
+	conn->state = BT_CONNECT;
+
 	return hci_le_create_conn_sync(hdev, conn);
 }
 
@@ -1375,10 +1387,10 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	conn->sec_level = BT_SECURITY_LOW;
 	conn->conn_timeout = conn_timeout;
 
-	conn->state = BT_CONNECT;
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 
-	err = hci_cmd_sync_queue(hdev, hci_connect_le_sync, conn,
+	err = hci_cmd_sync_queue(hdev, hci_connect_le_sync,
+				 ERR_PTR(conn->handle),
 				 create_le_conn_complete);
 	if (err) {
 		hci_conn_del(conn);
@@ -2905,6 +2917,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	/* If the connection is pending check the command opcode since that
 	 * might be blocking on hci_cmd_sync_work while waiting its respective
 	 * event so we need to hci_cmd_sync_cancel to cancel it.
+	 *
+	 * hci_connect_le serializes the connection attempts so only one
+	 * connection can be in BT_CONNECT at time.
 	 */
 	if (conn->state == BT_CONNECT && hdev->req_status == HCI_REQ_PEND) {
 		switch (hci_skb_event(hdev->sent_cmd)) {
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6aaecd6e656bc..caf4263ef9b77 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5290,6 +5290,24 @@ static int hci_connect_cancel_sync(struct hci_dev *hdev, struct hci_conn *conn,
 	if (conn->type == LE_LINK)
 		return hci_le_connect_cancel_sync(hdev, conn, reason);
 
+	if (conn->type == ISO_LINK) {
+		/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E
+		 * page 1857:
+		 *
+		 * If this command is issued for a CIS on the Central and the
+		 * CIS is successfully terminated before being established,
+		 * then an HCI_LE_CIS_Established event shall also be sent for
+		 * this CIS with the Status Operation Cancelled by Host (0x44).
+		 */
+		if (test_bit(HCI_CONN_CREATE_CIS, &conn->flags))
+			return hci_disconnect_sync(hdev, conn, reason);
+
+		/* There is no way to cancel a BIS without terminating the BIG
+		 * which is done later on connection cleanup.
+		 */
+		return 0;
+	}
+
 	if (hdev->hci_ver < BLUETOOTH_VER_1_2)
 		return 0;
 
@@ -5316,11 +5334,27 @@ static int hci_reject_sco_sync(struct hci_dev *hdev, struct hci_conn *conn,
 				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
 }
 
+static int hci_le_reject_cis_sync(struct hci_dev *hdev, struct hci_conn *conn,
+				  u8 reason)
+{
+	struct hci_cp_le_reject_cis cp;
+
+	memset(&cp, 0, sizeof(cp));
+	cp.handle = cpu_to_le16(conn->handle);
+	cp.reason = reason;
+
+	return __hci_cmd_sync_status(hdev, HCI_OP_LE_REJECT_CIS,
+				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+}
+
 static int hci_reject_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
 				u8 reason)
 {
 	struct hci_cp_reject_conn_req cp;
 
+	if (conn->type == ISO_LINK)
+		return hci_le_reject_cis_sync(hdev, conn, reason);
+
 	if (conn->type == SCO_LINK || conn->type == ESCO_LINK)
 		return hci_reject_sco_sync(hdev, conn, reason);
 
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 42f7b257bdfbc..c8460eb7f5c0b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -622,18 +622,6 @@ static void iso_sock_kill(struct sock *sk)
 	sock_put(sk);
 }
 
-static void iso_conn_defer_reject(struct hci_conn *conn)
-{
-	struct hci_cp_le_reject_cis cp;
-
-	BT_DBG("conn %p", conn);
-
-	memset(&cp, 0, sizeof(cp));
-	cp.handle = cpu_to_le16(conn->handle);
-	cp.reason = HCI_ERROR_REJ_BAD_ADDR;
-	hci_send_cmd(conn->hdev, HCI_OP_LE_REJECT_CIS, sizeof(cp), &cp);
-}
-
 static void __iso_sock_close(struct sock *sk)
 {
 	BT_DBG("sk %p state %d socket %p", sk, sk->sk_state, sk->sk_socket);
@@ -658,8 +646,6 @@ static void __iso_sock_close(struct sock *sk)
 		break;
 
 	case BT_CONNECT2:
-		if (iso_pi(sk)->conn->hcon)
-			iso_conn_defer_reject(iso_pi(sk)->conn->hcon);
 		iso_chan_del(sk, ECONNRESET);
 		break;
 	case BT_CONNECT:
-- 
2.40.1



