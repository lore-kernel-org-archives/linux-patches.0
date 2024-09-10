Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6218B49E;
	Tue, 10 Sep 2024 10:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964332; cv=none; b=S1j6G0ZU4sWWXd/s6kAsieAH/utgXHl72OX1LSvZycMfmJFCdE6w/576jdSYHBQGMGCtc8QYifhJtExpXuoOJ0jAy1Yn6VfYTWU533LsQJ7LNThUnNVFg6JSYwyRs1v1m5VZAz3nzXbvuIXEYBmgn8JR4wX/4qXFiGU/z+jGrys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964332; c=relaxed/simple;
	bh=i3qoHgThPEh8i+rvDwoNcqDMXSXIo4ZUVUYpwxvNp40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFArOOkD7vnaAiJ5ZmPR3SCpJy9sYy0A+RW7ya3LR+HKwl0xpLGxGwGr60Dgznoo/iCG93lr4w1YhNFSovlOntlGS08+iMDdbwzTCEumjfuClpoU3ejSQsM3CoRC1l6Zg+ipfM7aAip1nlDL9Y6TB84Wm1ae/45JkxYOuq7ezhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fd7i79Hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fd7i79Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99CEC4CEC3;
	Tue, 10 Sep 2024 10:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964332;
	bh=i3qoHgThPEh8i+rvDwoNcqDMXSXIo4ZUVUYpwxvNp40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fd7i79Hkj1GCX1aO2szjS15Gy7vaP/SWbV+soCIAt/MRn82Fxpe2sFF6Ye0e4LyGb
	 uftD+MVHWPKw3njetXvojQDoet2fsKVOibtwJl0wk/b665mMCCFX2eFw7IrR8sng1R
	 TVjYSlXd4JMbXpnqESWuA4qDD81p+pQMS62HG4JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/269] Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT
Date: Tue, 10 Sep 2024 11:31:46 +0200
Message-ID: <20240910092612.424668479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index efa0881a90e1..d8a01eb016ad 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2877,5 +2877,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
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
index bad365f3d7bf..4ae9029b5785 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2918,7 +2918,12 @@ static int unpair_device_sync(struct hci_dev *hdev, void *data)
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
@@ -3050,13 +3055,44 @@ static int unpair_device(struct sock *sk, struct hci_dev *hdev, void *data,
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
@@ -3079,27 +3115,7 @@ static int disconnect(struct sock *sk, struct hci_dev *hdev, void *data,
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
@@ -3107,9 +3123,10 @@ static int disconnect(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	cmd->cmd_complete = generic_cmd_complete;
 
-	err = hci_disconnect(conn, HCI_ERROR_REMOTE_USER_TERM);
+	err = hci_cmd_sync_queue(hdev, disconnect_sync, cmd,
+				 disconnect_complete);
 	if (err < 0)
-		mgmt_pending_remove(cmd);
+		mgmt_pending_free(cmd);
 
 failed:
 	hci_dev_unlock(hdev);
@@ -9627,18 +9644,6 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
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
@@ -9679,8 +9684,6 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	if (link_type != ACL_LINK && link_type != LE_LINK)
 		return;
 
-	mgmt_pending_foreach(MGMT_OP_DISCONNECT, hdev, disconnect_rsp, &sk);
-
 	bacpy(&ev.addr.bdaddr, bdaddr);
 	ev.addr.type = link_to_bdaddr(link_type, addr_type);
 	ev.reason = reason;
@@ -9693,9 +9696,6 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 	if (sk)
 		sock_put(sk);
-
-	mgmt_pending_foreach(MGMT_OP_UNPAIR_DEVICE, hdev, unpair_device_rsp,
-			     hdev);
 }
 
 void mgmt_disconnect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr,
-- 
2.43.0



