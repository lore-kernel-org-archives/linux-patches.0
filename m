Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D237A14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9VDU+6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1D7C433C7;
	Mon, 23 Oct 2023 11:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059005;
	bh=s3pM945Cz4uLcP0y/U1Ku7KRtWnrafyxyadcEh7hlnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9VDU+6fEPa7JB0gtughQKnXqz0/J1x+W8rtSAgQQs9fWD/gv8pgaGQpeJW51Xn3C
	 AaPUW/9tS+1FmCC9UyTbDTiTxMlobS8pJmxQEw/ZjHNdgEy53GBGGhXW80kqrG/Kk2
	 +/h3j8ycvLSoaP7Kt2cLFjyobcd9S1GnoKYVXM0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.5 007/241] Bluetooth: hci_conn: Fix modifying handle while aborting
Date: Mon, 23 Oct 2023 12:53:13 +0200
Message-ID: <20231023104834.032751280@linuxfoundation.org>
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

commit 16e3b6429159795a87add7584eb100b19aa1d70b upstream.

This introduces hci_conn_set_handle which takes care of verifying the
conditions where the hci_conn handle can be modified, including when
hci_conn_abort has been called and also checks that the handles is
valid as well.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    1 +
 net/bluetooth/hci_conn.c         |   27 +++++++++++++++++++++++++++
 net/bluetooth/hci_event.c        |   29 +++++++++++------------------
 3 files changed, 39 insertions(+), 18 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1426,6 +1426,7 @@ int hci_conn_switch_role(struct hci_conn
 void hci_conn_enter_active_mode(struct hci_conn *conn, __u8 force_active);
 
 void hci_conn_failed(struct hci_conn *conn, u8 status);
+u8 hci_conn_set_handle(struct hci_conn *conn, u16 handle);
 
 /*
  * hci_conn_get() and hci_conn_put() are used to control the life-time of an
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1248,6 +1248,33 @@ void hci_conn_failed(struct hci_conn *co
 	hci_conn_del(conn);
 }
 
+/* This function requires the caller holds hdev->lock */
+u8 hci_conn_set_handle(struct hci_conn *conn, u16 handle)
+{
+	struct hci_dev *hdev = conn->hdev;
+
+	bt_dev_dbg(hdev, "hcon %p handle 0x%4.4x", conn, handle);
+
+	if (conn->handle == handle)
+		return 0;
+
+	if (handle > HCI_CONN_HANDLE_MAX) {
+		bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
+			   handle, HCI_CONN_HANDLE_MAX);
+		return HCI_ERROR_INVALID_PARAMETERS;
+	}
+
+	/* If abort_reason has been sent it means the connection is being
+	 * aborted and the handle shall not be changed.
+	 */
+	if (conn->abort_reason)
+		return conn->abort_reason;
+
+	conn->handle = handle;
+
+	return 0;
+}
+
 static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 {
 	struct hci_conn *conn = data;
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3180,13 +3180,9 @@ static void hci_conn_complete_evt(struct
 	}
 
 	if (!status) {
-		conn->handle = __le16_to_cpu(ev->handle);
-		if (conn->handle > HCI_CONN_HANDLE_MAX) {
-			bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
-				   conn->handle, HCI_CONN_HANDLE_MAX);
-			status = HCI_ERROR_INVALID_PARAMETERS;
+		status = hci_conn_set_handle(conn, __le16_to_cpu(ev->handle));
+		if (status)
 			goto done;
-		}
 
 		if (conn->type == ACL_LINK) {
 			conn->state = BT_CONFIG;
@@ -3879,11 +3875,9 @@ static u8 hci_cc_le_set_cig_params(struc
 		if (conn->state != BT_BOUND && conn->state != BT_CONNECT)
 			continue;
 
-		conn->handle = __le16_to_cpu(rp->handle[i]);
+		if (hci_conn_set_handle(conn, __le16_to_cpu(rp->handle[i])))
+			continue;
 
-		bt_dev_dbg(hdev, "%p handle 0x%4.4x parent %p", conn,
-			   conn->handle, conn->parent);
-		
 		if (conn->state == BT_CONNECT)
 			pending = true;
 	}
@@ -5055,11 +5049,8 @@ static void hci_sync_conn_complete_evt(s
 
 	switch (status) {
 	case 0x00:
-		conn->handle = __le16_to_cpu(ev->handle);
-		if (conn->handle > HCI_CONN_HANDLE_MAX) {
-			bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
-				   conn->handle, HCI_CONN_HANDLE_MAX);
-			status = HCI_ERROR_INVALID_PARAMETERS;
+		status = hci_conn_set_handle(conn, __le16_to_cpu(ev->handle));
+		if (status) {
 			conn->state = BT_CLOSED;
 			break;
 		}
@@ -6992,7 +6983,7 @@ static void hci_le_create_big_complete_e
 {
 	struct hci_evt_le_create_big_complete *ev = data;
 	struct hci_conn *conn;
-	__u8 bis_idx = 0;
+	__u8 i = 0;
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
@@ -7010,7 +7001,9 @@ static void hci_le_create_big_complete_e
 		    conn->iso_qos.bcast.big != ev->handle)
 			continue;
 
-		conn->handle = __le16_to_cpu(ev->bis_handle[bis_idx++]);
+		if (hci_conn_set_handle(conn,
+					__le16_to_cpu(ev->bis_handle[i++])))
+			continue;
 
 		if (!ev->status) {
 			conn->state = BT_CONNECTED;
@@ -7029,7 +7022,7 @@ static void hci_le_create_big_complete_e
 		rcu_read_lock();
 	}
 
-	if (!ev->status && !bis_idx)
+	if (!ev->status && !i)
 		/* If no BISes have been connected for the BIG,
 		 * terminate. This is in case all bound connections
 		 * have been closed before the BIG creation


