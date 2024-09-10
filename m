Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225746444;
	Tue, 10 Sep 2024 09:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961737; cv=none; b=hC/8C5/lzibBJk2cZdb1ZcwWaWah+rV+IeCwX1lODf0boZL33GxOzMWj2qEhw9fOVZhqf6TUcuhg0rwP5NfcO1e7D+QZ6xuvzSyq+tTYBiznygHlspMZbLtQu/WKvzsARGoHweesy4Rl2gFtCeIrZYJDzLA1BAI32gSzQb5+1vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961737; c=relaxed/simple;
	bh=sU9Dk+0F1ztYPmPqc3GqsqTOjTdriAIqwi/ungD7OeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqLMzNFgjXprp/OlqDGjrYzQJbvOYOUJFmNPhOHzooPdyFS/xgHzjtTkugzliNd5oVfcpi1lWp8Hd0TGmYmLV5FH4lZ1s6RK0ufe8eVmlMU+M5mrNVr37lagV/xwyNyhXKU+4MzChLEKGPGgeBTECz0vLSoSEk9HXtgkm25bggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnKYL1Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnKYL1Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C660C4CECD;
	Tue, 10 Sep 2024 09:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961737;
	bh=sU9Dk+0F1ztYPmPqc3GqsqTOjTdriAIqwi/ungD7OeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnKYL1MnoElphrYnC5q3RM1s3AdI895L7Og6GvPeWjo9ZyJTo26z11tybRU57+PKt
	 ewDtJtq9ezJilOle4KzXi6CkM6tIpq3x+lY7PRuy8bvI/MJHJyg7O/Oz9quZHVjpHZ
	 2YGqiwzzQnbcw2tJshFiOF1VJKdQhuYUlysARBWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 172/375] Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT
Date: Tue, 10 Sep 2024 11:29:29 +0200
Message-ID: <20240910092628.259065855@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 227a0cdf4a028a73dc256d0f5144b4808d718893 ]

MGMT_OP_DISCONNECT can be called while mgmt_device_connected has not
been called yet, which will cause the connection procedure to be
aborted, so mgmt_device_disconnected shall still respond with command
complete to MGMT_OP_DISCONNECT and just not emit
MGMT_EV_DEVICE_DISCONNECTED since MGMT_EV_DEVICE_CONNECTED was never
sent.

To fix this MGMT_OP_DISCONNECT is changed to work similarly to other
command which do use hci_cmd_sync_queue and then use hci_conn_abort to
disconnect and returns the result, in order for hci_conn_abort to be
used from hci_cmd_sync context it now uses hci_cmd_sync_run_once.

Link: https://github.com/bluez/bluez/issues/932
Fixes: 12d4a3b2ccb3 ("Bluetooth: Move check for MGMT_CONNECTED flag into mgmt.c")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c |  6 ++-
 net/bluetooth/mgmt.c     | 84 ++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 43 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 080053a85b4d..3c74d171085d 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2953,5 +2953,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 		return 0;
 	}
 
-	return hci_cmd_sync_queue_once(hdev, abort_conn_sync, conn, NULL);
+	/* Run immediately if on cmd_sync_work since this may be called
+	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
+	 * already queue its callback on cmd_sync_work.
+	 */
+	return hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
 }
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fa3fa1fde5df..ba28907afb3f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2925,7 +2925,12 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
 	if (!conn)
 		return 0;
 
-	return hci_abort_conn_sync(hdev, conn, HCI_ERROR_REMOTE_USER_TERM);
+	/* Disregard any possible error since the likes of hci_abort_conn_sync
+	 * will clean up the connection no matter the error.
+	 */
+	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+
+	return 0;
 }
 
 static int unpair_device(struct sock *sk, struct hci_dev *hdev, void *data,
@@ -3057,13 +3062,44 @@ static int unpair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 	return err;
 }
 
+static void disconnect_complete(struct hci_dev *hdev, void *data, int err)
+{
+	struct mgmt_pending_cmd *cmd = data;
+
+	cmd->cmd_complete(cmd, mgmt_status(err));
+	mgmt_pending_free(cmd);
+}
+
+static int disconnect_sync(struct hci_dev *hdev, void *data)
+{
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_disconnect *cp = cmd->param;
+	struct hci_conn *conn;
+
+	if (cp->addr.type == BDADDR_BREDR)
+		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
+					       &cp->addr.bdaddr);
+	else
+		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
+					       le_addr_type(cp->addr.type));
+
+	if (!conn)
+		return -ENOTCONN;
+
+	/* Disregard any possible error since the likes of hci_abort_conn_sync
+	 * will clean up the connection no matter the error.
+	 */
+	hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+
+	return 0;
+}
+
 static int disconnect(struct sock *sk, struct hci_dev *hdev, void *data,
 		      u16 len)
 {
 	struct mgmt_cp_disconnect *cp = data;
 	struct mgmt_rp_disconnect rp;
 	struct mgmt_pending_cmd *cmd;
-	struct hci_conn *conn;
 	int err;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
@@ -3086,27 +3122,7 @@ static int disconnect(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto failed;
 	}
 
-	if (pending_find(MGMT_OP_DISCONNECT, hdev)) {
-		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_DISCONNECT,
-					MGMT_STATUS_BUSY, &rp, sizeof(rp));
-		goto failed;
-	}
-
-	if (cp->addr.type == BDADDR_BREDR)
-		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
-					       &cp->addr.bdaddr);
-	else
-		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
-					       le_addr_type(cp->addr.type));
-
-	if (!conn || conn->state == BT_OPEN || conn->state == BT_CLOSED) {
-		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_DISCONNECT,
-					MGMT_STATUS_NOT_CONNECTED, &rp,
-					sizeof(rp));
-		goto failed;
-	}
-
-	cmd = mgmt_pending_add(sk, MGMT_OP_DISCONNECT, hdev, data, len);
+	cmd = mgmt_pending_new(sk, MGMT_OP_DISCONNECT, hdev, data, len);
 	if (!cmd) {
 		err = -ENOMEM;
 		goto failed;
@@ -3114,9 +3130,10 @@ static int disconnect(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	cmd->cmd_complete = generic_cmd_complete;
 
-	err = hci_disconnect(conn, HCI_ERROR_REMOTE_USER_TERM);
+	err = hci_cmd_sync_queue(hdev, disconnect_sync, cmd,
+				 disconnect_complete);
 	if (err < 0)
-		mgmt_pending_remove(cmd);
+		mgmt_pending_free(cmd);
 
 failed:
 	hci_dev_unlock(hdev);
@@ -9634,18 +9651,6 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
 	mgmt_event_skb(skb, NULL);
 }
 
-static void disconnect_rsp(struct mgmt_pending_cmd *cmd, void *data)
-{
-	struct sock **sk = data;
-
-	cmd->cmd_complete(cmd, 0);
-
-	*sk = cmd->sk;
-	sock_hold(*sk);
-
-	mgmt_pending_remove(cmd);
-}
-
 static void unpair_device_rsp(struct mgmt_pending_cmd *cmd, void *data)
 {
 	struct hci_dev *hdev = data;
@@ -9689,8 +9694,6 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	if (link_type != ACL_LINK && link_type != LE_LINK)
 		return;
 
-	mgmt_pending_foreach(MGMT_OP_DISCONNECT, hdev, disconnect_rsp, &sk);
-
 	bacpy(&ev.addr.bdaddr, bdaddr);
 	ev.addr.type = link_to_bdaddr(link_type, addr_type);
 	ev.reason = reason;
@@ -9703,9 +9706,6 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 	if (sk)
 		sock_put(sk);
-
-	mgmt_pending_foreach(MGMT_OP_UNPAIR_DEVICE, hdev, unpair_device_rsp,
-			     hdev);
 }
 
 void mgmt_disconnect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr,
-- 
2.43.0



