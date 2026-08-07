Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4834C27466A;
	Fri,  7 Aug 2026 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116083; cv=none; b=q2/IYo1AuR/0eNxNXN7mM5eohuQFtk5zmEczq4+IhUIuRs3hOLm3Tt2GHm5bWgYatoOjVIMh9z0hAhOFCkrXAGvccASHe+YtEi3qsJmhml11sRh8g3VY/kmW8jFcjoU8XVI7s4v1M+wvvy/g0MAbpiYDXYkeBCnewTU9z9AP/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116083; c=relaxed/simple;
	bh=lId8XxGwulMfrEWDdXuVkWMcSIywb4KB7wJOlEP78Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc/MI+cT5UmTDnYTIkuoe+VJWo4l35t7BisW0FH5rcHWSDqwBA8nWv+jCtw5vgDVTw63hsNJPZg0H63G8WQRYpBD4/eoKlSJ3EWa9nVtU/ZKnaipT99ZHeYGlioqK9CwTI00xj4481KFogUlyNM2EqPMFWdxVQCDme2yRICduz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2niynRph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2niynRph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2E21F00A3A;
	Fri,  7 Aug 2026 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116082;
	bh=xChG7KyVhzYuB4YFy7vjrjkkSlbazXvXBm0XWoodb8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2niynRph8OrhJcOUIAiBv2YSxnON4kMPesMUFtEKAor7HnJW9ziHMO2fXJKm6y53J
	 Nn7kgOoBDjdd1Vz1Em6lapyPGXVQcojEvDOObbYATk7NytBdzXw4Ltz58T0lx5Z+I+
	 9H2AcJlqlEs2fuejppvGt96zkTlRUWB+jHyuoHes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 105/261] Bluetooth: mgmt: fix UAF in pair command cancellation
Date: Fri,  7 Aug 2026 16:37:42 +0200
Message-ID: <20260807143417.646009952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit d0a7b48ad0921bd88effaee10bf970ab1d5d0ddd upstream.

The pairing completion and authentication failure callbacks look up the
pending MGMT_OP_PAIR_DEVICE command by walking hdev->mgmt_pending. The
lookup returned a command that was still linked on the shared pending list,
without keeping mgmt_pending_lock held for the later dereference and
removal.

A concurrent MGMT_OP_CANCEL_PAIR_DEVICE request can remove and free the
same pending command before the callback uses it. The reverse race is also
possible when cancel_pair_device() gets a command from pending_find() and a
callback removes it before the cancel path dereferences it. This can lead
to a use-after-free and a second list_del().

Make the pairing lookup helpers transfer ownership of the pending command
by removing it from hdev->mgmt_pending while holding mgmt_pending_lock.
The callbacks and cancel path then complete the command and free it
directly, so racing paths cannot find or free the same command again. Take
a temporary hci_conn reference in cancel_pair_device() because the command
completion drops the reference stored in the pending command.

Fixes: e9a416b5ce0c ("Bluetooth: Add mgmt_pair_device command")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |   64 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 18 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3437,11 +3437,13 @@ static int set_io_capability(struct sock
 				 NULL, 0);
 }
 
-static struct mgmt_pending_cmd *find_pairing(struct hci_conn *conn)
+static struct mgmt_pending_cmd *remove_pairing(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
 	struct mgmt_pending_cmd *cmd;
 
+	mutex_lock(&hdev->mgmt_pending_lock);
+
 	list_for_each_entry(cmd, &hdev->mgmt_pending, list) {
 		if (cmd->opcode != MGMT_OP_PAIR_DEVICE)
 			continue;
@@ -3449,9 +3451,39 @@ static struct mgmt_pending_cmd *find_pai
 		if (cmd->user_data != conn)
 			continue;
 
+		list_del(&cmd->list);
+		mutex_unlock(&hdev->mgmt_pending_lock);
 		return cmd;
 	}
 
+	mutex_unlock(&hdev->mgmt_pending_lock);
+
+	return NULL;
+}
+
+static struct mgmt_pending_cmd *remove_pairing_by_addr(struct hci_dev *hdev,
+						       bdaddr_t *bdaddr)
+{
+	struct mgmt_pending_cmd *cmd;
+	struct hci_conn *conn;
+
+	mutex_lock(&hdev->mgmt_pending_lock);
+
+	list_for_each_entry(cmd, &hdev->mgmt_pending, list) {
+		if (cmd->opcode != MGMT_OP_PAIR_DEVICE)
+			continue;
+
+		conn = cmd->user_data;
+		if (bacmp(bdaddr, &conn->dst) != 0)
+			continue;
+
+		list_del(&cmd->list);
+		mutex_unlock(&hdev->mgmt_pending_lock);
+		return cmd;
+	}
+
+	mutex_unlock(&hdev->mgmt_pending_lock);
+
 	return NULL;
 }
 
@@ -3489,10 +3521,10 @@ void mgmt_smp_complete(struct hci_conn *
 	u8 status = complete ? MGMT_STATUS_SUCCESS : MGMT_STATUS_FAILED;
 	struct mgmt_pending_cmd *cmd;
 
-	cmd = find_pairing(conn);
+	cmd = remove_pairing(conn);
 	if (cmd) {
 		cmd->cmd_complete(cmd, status);
-		mgmt_pending_remove(cmd);
+		mgmt_pending_free(cmd);
 	}
 }
 
@@ -3502,14 +3534,14 @@ static void pairing_complete_cb(struct h
 
 	BT_DBG("status %u", status);
 
-	cmd = find_pairing(conn);
+	cmd = remove_pairing(conn);
 	if (!cmd) {
 		BT_DBG("Unable to find a pending command");
 		return;
 	}
 
 	cmd->cmd_complete(cmd, mgmt_status(status));
-	mgmt_pending_remove(cmd);
+	mgmt_pending_free(cmd);
 }
 
 static void le_pairing_complete_cb(struct hci_conn *conn, u8 status)
@@ -3521,14 +3553,14 @@ static void le_pairing_complete_cb(struc
 	if (!status)
 		return;
 
-	cmd = find_pairing(conn);
+	cmd = remove_pairing(conn);
 	if (!cmd) {
 		BT_DBG("Unable to find a pending command");
 		return;
 	}
 
 	cmd->cmd_complete(cmd, mgmt_status(status));
-	mgmt_pending_remove(cmd);
+	mgmt_pending_free(cmd);
 }
 
 static int pair_device(struct sock *sk, struct hci_dev *hdev, void *data,
@@ -3684,23 +3716,17 @@ static int cancel_pair_device(struct soc
 		goto unlock;
 	}
 
-	cmd = pending_find(MGMT_OP_PAIR_DEVICE, hdev);
+	cmd = remove_pairing_by_addr(hdev, &addr->bdaddr);
 	if (!cmd) {
 		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_CANCEL_PAIR_DEVICE,
 				      MGMT_STATUS_INVALID_PARAMS);
 		goto unlock;
 	}
 
-	conn = cmd->user_data;
-
-	if (bacmp(&addr->bdaddr, &conn->dst) != 0) {
-		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_CANCEL_PAIR_DEVICE,
-				      MGMT_STATUS_INVALID_PARAMS);
-		goto unlock;
-	}
+	conn = hci_conn_get(cmd->user_data);
 
 	cmd->cmd_complete(cmd, MGMT_STATUS_CANCELLED);
-	mgmt_pending_remove(cmd);
+	mgmt_pending_free(cmd);
 
 	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_CANCEL_PAIR_DEVICE, 0,
 				addr, sizeof(*addr));
@@ -3718,6 +3744,8 @@ static int cancel_pair_device(struct soc
 	if (conn->conn_reason == CONN_REASON_PAIR_DEVICE)
 		hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
 
+	hci_conn_put(conn);
+
 unlock:
 	hci_dev_unlock(hdev);
 	return err;
@@ -10138,14 +10166,14 @@ void mgmt_auth_failed(struct hci_conn *c
 	ev.addr.type = link_to_bdaddr(conn->type, conn->dst_type);
 	ev.status = status;
 
-	cmd = find_pairing(conn);
+	cmd = remove_pairing(conn);
 
 	mgmt_event(MGMT_EV_AUTH_FAILED, conn->hdev, &ev, sizeof(ev),
 		    cmd ? cmd->sk : NULL);
 
 	if (cmd) {
 		cmd->cmd_complete(cmd, status);
-		mgmt_pending_remove(cmd);
+		mgmt_pending_free(cmd);
 	}
 }
 


