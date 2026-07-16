Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5B2C11E4;
	Thu, 16 Jul 2026 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209504; cv=none; b=FToxG7j4RgDuUS9ETe/sOnwyv/msgVaM74FlGsRqiKfZzAC8er1PfCwmNevaNqVIUm6W1yB/MNqVMr1PPe0O9y58l/xqIbLGTZBY2BbLjODO1ybzcL1zwyMFmtzmRAoiuax0eJvBTNw4nKmy9xT98/fs+sK5sxMpgJH14DOZ44A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209504; c=relaxed/simple;
	bh=79lBq0fXQ4cewFO6qkDhVDcSLuYfI2hDi2IvqqOvztE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raulNoDaGk6K8nJ0U0yAYPU6PbZWBerSVYqkyC2QSK/m7iQAmxgk8hZJhIQUwdg5VWd4m71k8uUR6YgRp5rNTOOdUs/lw7fsCnxyDVHc4o4hIbHll3dEX4T3xeIfHrVlN8nGeKmXUyK5q+1dEpb+F1eI2BBjixVRpu7Fw1ewwr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm7iRjnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm7iRjnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C041F000E9;
	Thu, 16 Jul 2026 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209502;
	bh=MDC7Le0zYYfTSRSQJxDaERQA3JrWRq5KpCXofIMMKt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hm7iRjnDst+IplYKfalSZ476oZ/o7gXqu5UBF9y88SxGafq7l8FbhMqOe3HeNGh7g
	 Q48cXUO295AL86DStaATxwgqVpMYe5eMxlhesk33xQ1f25FVZDJO8RCJp6w5heMT3s
	 qE9ecysp7TjHJNDsYi/SXskyOlCfK6df0tq/Ac3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XIAO WU <xiaowu.417@qq.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 208/518] Bluetooth: hci_conn: Fix null ptr deref in hci_abort_conn()
Date: Thu, 16 Jul 2026 15:27:56 +0200
Message-ID: <20260716133052.370551137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 12917f591cea1af36087dba5b9ec888652f0b42a upstream.

hci_abort_conn() read hci_skb_event(hdev->sent_cmd) when a connection
was pending, but hdev->sent_cmd can be NULL while req_status is still
HCI_REQ_PEND, leading to a NULL pointer dereference and a general
protection fault from the hci_rx_work() receive path.

Instead of inspecting hdev->sent_cmd, track the in-flight create
connection command with a new per-connection HCI_CONN_CREATE flag and
route all cancellation through hci_cancel_connect_sync(), which
dispatches to a dedicated per-type cancel function. The create command
is in exactly one of two states: still queued, or in flight. The cancel
function holds cmd_sync_work_lock across the whole decision: the worker
takes this lock to dequeue every entry, so while it is held a queued
command cannot start running and an in-flight command cannot complete
and let the next command become pending. This keeps the flag test and
hci_cmd_sync_cancel() atomic with respect to the worker, so a queued
command is simply dequeued, and an in-flight command owned by this
connection is cancelled without the risk of cancelling an unrelated
command that became pending in the meantime. CIS uses the same flag
mechanism via HCI_CONN_CREATE_CIS but cannot be dequeued per-connection.

hci_acl_create_conn_sync() and hci_le_create_conn_sync() clear
HCI_CONN_CREATE after the create command completes, but the command
status handler can free conn via hci_conn_del() (for example when the
controller rejects the connection) while the worker is still blocked on
the connection complete event. Hold a reference on conn across the
create command so the flag can be cleared without a use-after-free.

Fixes: a13f316e90fd ("Bluetooth: hci_conn: Consolidate code for aborting connections")
Cc: stable@vger.kernel.org
Suggested-by: XIAO WU <xiaowu.417@qq.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    1 
 net/bluetooth/hci_conn.c         |   21 ------
 net/bluetooth/hci_sync.c         |  133 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 123 insertions(+), 32 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -988,6 +988,7 @@ enum {
 	HCI_CONN_AUTH_FAILURE,
 	HCI_CONN_PER_ADV,
 	HCI_CONN_BIG_CREATED,
+	HCI_CONN_CREATE,
 	HCI_CONN_CREATE_CIS,
 	HCI_CONN_CREATE_BIG_SYNC,
 	HCI_CONN_BIG_SYNC,
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -3181,26 +3181,11 @@ int hci_abort_conn(struct hci_conn *conn
 
 	conn->abort_reason = reason;
 
-	/* If the connection is pending check the command opcode since that
-	 * might be blocking on hci_cmd_sync_work while waiting its respective
-	 * event so we need to hci_cmd_sync_cancel to cancel it.
-	 *
-	 * hci_connect_le serializes the connection attempts so only one
-	 * connection can be in BT_CONNECT at time.
+	/* Cancel the connect attempt. A return of 0 means the create command
+	 * was still queued and got dequeued, so there is nothing to disconnect.
 	 */
-	if (conn->state == BT_CONNECT && READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
-		switch (hci_skb_event(hdev->sent_cmd)) {
-		case HCI_EV_CONN_COMPLETE:
-		case HCI_EV_LE_CONN_COMPLETE:
-		case HCI_EV_LE_ENHANCED_CONN_COMPLETE:
-		case HCI_EVT_LE_CIS_ESTABLISHED:
-			hci_cmd_sync_cancel(hdev, ECANCELED);
-			break;
-		}
-	/* Cancel connect attempt if still queued/pending */
-	} else if (!hci_cancel_connect_sync(hdev, conn)) {
+	if (!hci_cancel_connect_sync(hdev, conn))
 		return 0;
-	}
 
 	/* Run immediately if on cmd_sync_work since this may be called
 	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6611,6 +6611,11 @@ static int hci_le_create_conn_sync(struc
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
+	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
+	 * clear_bit() at done.
+	 */
+	hci_conn_get(conn);
+
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 	conn->state = BT_CONNECT;
 
@@ -6623,6 +6628,7 @@ static int hci_le_create_conn_sync(struc
 		    hdev->le_scan_type == LE_SCAN_ACTIVE &&
 		    !hci_dev_test_flag(hdev, HCI_LE_SIMULTANEOUS_ROLES)) {
 			hci_conn_del(conn);
+			hci_conn_put(conn);
 			return -EBUSY;
 		}
 
@@ -6668,6 +6674,12 @@ static int hci_le_create_conn_sync(struc
 					     &own_addr_type);
 	if (err)
 		goto done;
+
+	/* Mark create connection in flight so hci_cancel_connect_sync() can
+	 * cancel it while blocking on the connection complete event.
+	 */
+	set_bit(HCI_CONN_CREATE, &conn->flags);
+
 	/* Send command LE Extended Create Connection if supported */
 	if (use_ext_conn(hdev)) {
 		err = hci_le_ext_create_conn_sync(hdev, conn, own_addr_type);
@@ -6703,11 +6715,14 @@ static int hci_le_create_conn_sync(struc
 				       conn->conn_timeout, NULL);
 
 done:
+	clear_bit(HCI_CONN_CREATE, &conn->flags);
+
 	if (err == -ETIMEDOUT)
 		hci_le_connect_cancel_sync(hdev, conn, 0x00);
 
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
+	hci_conn_put(conn);
 	return err;
 }
 
@@ -6982,10 +6997,25 @@ static int hci_acl_create_conn_sync(stru
 	else
 		cp.role_switch = 0x00;
 
-	return __hci_cmd_sync_status_sk(hdev, HCI_OP_CREATE_CONN,
-					sizeof(cp), &cp,
-					HCI_EV_CONN_COMPLETE,
-					conn->conn_timeout, NULL);
+	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
+	 * clear_bit() below.
+	 */
+	hci_conn_get(conn);
+
+	/* Mark create connection in flight so hci_cancel_connect_sync() can
+	 * cancel it while blocking on the connection complete event.
+	 */
+	set_bit(HCI_CONN_CREATE, &conn->flags);
+
+	err = __hci_cmd_sync_status_sk(hdev, HCI_OP_CREATE_CONN,
+				       sizeof(cp), &cp,
+				       HCI_EV_CONN_COMPLETE,
+				       conn->conn_timeout, NULL);
+
+	clear_bit(HCI_CONN_CREATE, &conn->flags);
+	hci_conn_put(conn);
+
+	return err;
 }
 
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)
@@ -7037,22 +7067,97 @@ int hci_connect_le_sync(struct hci_dev *
 	return (err == -EEXIST) ? 0 : err;
 }
 
-int hci_cancel_connect_sync(struct hci_dev *hdev, struct hci_conn *conn)
+static int hci_acl_cancel_create_conn_sync(struct hci_dev *hdev,
+					   struct hci_conn *conn)
+{
+	struct hci_cmd_sync_work_entry *entry;
+	int err = -EBUSY;
+
+	/* cmd_sync_work_lock makes the HCI_CONN_CREATE test and the cancel
+	 * atomic against the worker, which takes this lock to dequeue every
+	 * entry: while it is held no other command can become pending, so
+	 * hci_cmd_sync_cancel() cannot cancel an unrelated command.
+	 */
+	mutex_lock(&hdev->cmd_sync_work_lock);
+
+	/* In flight: this connection owns the pending request, cancel it. */
+	if (test_bit(HCI_CONN_CREATE, &conn->flags)) {
+		hci_cmd_sync_cancel(hdev, ECANCELED);
+		goto unlock;
+	}
+
+	/* Still queued: a successful dequeue means it never started, so there
+	 * is nothing to disconnect.
+	 */
+	entry = _hci_cmd_sync_lookup_entry(hdev, hci_acl_create_conn_sync, conn,
+					   NULL);
+	if (entry) {
+		_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
+		err = 0;
+	}
+
+unlock:
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+	return err;
+}
+
+static int hci_le_cancel_create_conn_sync(struct hci_dev *hdev,
+					  struct hci_conn *conn)
 {
-	if (conn->state != BT_OPEN)
-		return -EINVAL;
+	struct hci_cmd_sync_work_entry *entry;
+	int err = -EBUSY;
+
+	/* cmd_sync_work_lock keeps the HCI_CONN_CREATE test and the cancel
+	 * atomic against the cmd_sync worker.
+	 */
+	mutex_lock(&hdev->cmd_sync_work_lock);
+
+	if (test_bit(HCI_CONN_CREATE, &conn->flags)) {
+		hci_cmd_sync_cancel(hdev, ECANCELED);
+		goto unlock;
+	}
 
+	entry = _hci_cmd_sync_lookup_entry(hdev, hci_le_create_conn_sync, conn,
+					   create_le_conn_complete);
+	if (entry) {
+		_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
+		err = 0;
+	}
+
+unlock:
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+	return err;
+}
+
+static int hci_cis_cancel_create_conn_sync(struct hci_dev *hdev,
+					   struct hci_conn *conn)
+{
+	/* LE Create CIS is shared by the whole CIG and cannot be dequeued
+	 * per-connection, so only an in-flight command can be cancelled.
+	 * cmd_sync_work_lock keeps the test and the cancel atomic against the
+	 * cmd_sync worker.
+	 */
+	mutex_lock(&hdev->cmd_sync_work_lock);
+
+	if (test_bit(HCI_CONN_CREATE_CIS, &conn->flags))
+		hci_cmd_sync_cancel(hdev, ECANCELED);
+
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+	return -EBUSY;
+}
+
+int hci_cancel_connect_sync(struct hci_dev *hdev, struct hci_conn *conn)
+{
 	switch (conn->type) {
 	case ACL_LINK:
-		return !hci_cmd_sync_dequeue_once(hdev,
-						  hci_acl_create_conn_sync,
-						  conn, NULL);
+		return hci_acl_cancel_create_conn_sync(hdev, conn);
 	case LE_LINK:
-		return !hci_cmd_sync_dequeue_once(hdev, hci_le_create_conn_sync,
-						  conn, create_le_conn_complete);
+		return hci_le_cancel_create_conn_sync(hdev, conn);
+	case CIS_LINK:
+		return hci_cis_cancel_create_conn_sync(hdev, conn);
+	default:
+		return -ENOENT;
 	}
-
-	return -ENOENT;
 }
 
 int hci_le_conn_update_sync(struct hci_dev *hdev, struct hci_conn *conn,


