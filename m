Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350E2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED505C4339B;
	Tue, 18 Apr 2023 12:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821823;
	bh=QLuWp/FA/lwtuc7GQjwRB/DPIc3cr0LAm4izXSO+5pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGZo/mA89jLMZuguJtjGMLb2otqpOcWux2GBSifNNoC7Skmk29kWngRVKvulWPRZu
	 +e34XceB7TqvobKgCy9QO0Z5Lj4NmNK3vQLbSkqqLb1An4c7FjH4p0fAKwFg3rslTm
	 yfF9u6lapUYNUmN1JyU2odzxU+WbF2wS0LV49RUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/134] Bluetooth: Fix printing errors if LE Connection times out
Date: Tue, 18 Apr 2023 14:21:51 +0200
Message-Id: <20230418120314.855365087@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b62e72200eaad523f08d8319bba50fc652e032a8 ]

This fixes errors like bellow when LE Connection times out since that
is actually not a controller error:

 Bluetooth: hci0: Opcode 0x200d failed: -110
 Bluetooth: hci0: request failed to create LE connection: err -110

Instead the code shall properly detect if -ETIMEDOUT is returned and
send HCI_OP_LE_CREATE_CONN_CANCEL to give up on the connection.

Link: https://github.com/bluez/bluez/issues/340
Fixes: 8e8b92ee60de ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_conn.c         |  7 +++++--
 net/bluetooth/hci_event.c        | 16 ++++++----------
 net/bluetooth/hci_sync.c         | 13 ++++++++++---
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 7f585e5dd71b8..061fec6fd0152 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -953,6 +953,7 @@ enum {
 	HCI_CONN_STK_ENCRYPT,
 	HCI_CONN_AUTH_INITIATOR,
 	HCI_CONN_DROP,
+	HCI_CONN_CANCEL,
 	HCI_CONN_PARAM_REMOVAL_PEND,
 	HCI_CONN_NEW_LINK_KEY,
 	HCI_CONN_SCANNING,
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 1b80d94d639cc..c2c6dea01cc91 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1247,6 +1247,8 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 {
 	struct hci_conn *conn = data;
 
+	bt_dev_dbg(hdev, "err %d", err);
+
 	hci_dev_lock(hdev);
 
 	if (!err) {
@@ -1254,8 +1256,6 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 		goto done;
 	}
 
-	bt_dev_err(hdev, "request failed to create LE connection: err %d", err);
-
 	/* Check if connection is still pending */
 	if (conn != hci_lookup_le_connect(hdev))
 		goto done;
@@ -2796,6 +2796,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	int r = 0;
 
+	if (test_and_set_bit(HCI_CONN_CANCEL, &conn->flags))
+		return 0;
+
 	switch (conn->state) {
 	case BT_CONNECTED:
 	case BT_CONFIG:
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0e2425eb6aa79..78c505f528a47 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2876,16 +2876,6 @@ static void cs_le_create_conn(struct hci_dev *hdev, bdaddr_t *peer_addr,
 
 	conn->resp_addr_type = peer_addr_type;
 	bacpy(&conn->resp_addr, peer_addr);
-
-	/* We don't want the connection attempt to stick around
-	 * indefinitely since LE doesn't have a page timeout concept
-	 * like BR/EDR. Set a timer for any connection that doesn't use
-	 * the accept list for connecting.
-	 */
-	if (filter_policy == HCI_LE_USE_PEER_ADDR)
-		queue_delayed_work(conn->hdev->workqueue,
-				   &conn->le_conn_timeout,
-				   conn->conn_timeout);
 }
 
 static void hci_cs_le_create_conn(struct hci_dev *hdev, u8 status)
@@ -5892,6 +5882,12 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	if (status)
 		goto unlock;
 
+	/* Drop the connection if it has been aborted */
+	if (test_bit(HCI_CONN_CANCEL, &conn->flags)) {
+		hci_conn_drop(conn);
+		goto unlock;
+	}
+
 	if (conn->dst_type == ADDR_LE_DEV_PUBLIC)
 		addr_type = BDADDR_LE_PUBLIC;
 	else
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f614f96c5c23d..9361fb3685cc7 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -246,8 +246,9 @@ int __hci_cmd_sync_status_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	skb = __hci_cmd_sync_sk(hdev, opcode, plen, param, event, timeout, sk);
 	if (IS_ERR(skb)) {
-		bt_dev_err(hdev, "Opcode 0x%4x failed: %ld", opcode,
-				PTR_ERR(skb));
+		if (!event)
+			bt_dev_err(hdev, "Opcode 0x%4x failed: %ld", opcode,
+				   PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
 
@@ -5108,8 +5109,11 @@ static int hci_le_connect_cancel_sync(struct hci_dev *hdev,
 	if (test_bit(HCI_CONN_SCANNING, &conn->flags))
 		return 0;
 
+	if (test_and_set_bit(HCI_CONN_CANCEL, &conn->flags))
+		return 0;
+
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_CREATE_CONN_CANCEL,
-				     6, &conn->dst, HCI_CMD_TIMEOUT);
+				     0, NULL, HCI_CMD_TIMEOUT);
 }
 
 static int hci_connect_cancel_sync(struct hci_dev *hdev, struct hci_conn *conn)
@@ -6084,6 +6088,9 @@ int hci_le_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn)
 				       conn->conn_timeout, NULL);
 
 done:
+	if (err == -ETIMEDOUT)
+		hci_le_connect_cancel_sync(hdev, conn);
+
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
 	return err;
-- 
2.39.2



