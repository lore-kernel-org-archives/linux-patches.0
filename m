Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECEE12C48F;
	Tue, 30 Apr 2024 10:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474173; cv=none; b=B25Q+nc337yuoPN2+FDqcqrJmrqbtUADRjPtbjh4vKkhfThOKiQq2u0OK8lCYGs9KZOTJQ4O4DxuknsceWYpdUK6UIPJmWQrmRdalA3YnGjAs+3+4ZPvul6cjEd/ic9y5LR633wZ86vn7UhDPc5JP6ikW317PKyUm6P1vWMvyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474173; c=relaxed/simple;
	bh=9ipD906QJp66bVxTKK/gyPKoah22p/LIvU5N46rwKAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRWsnpjSVDl6+2FwsBOiOZjuLTpRPTegMF/PQ2i27P95Ni6BfEQ9aMg/wJloqx6hc9HOzsumUA3LF7E1jHQpuGprruZsJsPFM35YxDdwqvruPxFazI9z4tY78UZtP3Hrjn2Y/MYpIJStaMM7nZSwGVBkj5U1WyWHz4GqJa1i2TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScWSSP+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScWSSP+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3134C4AF18;
	Tue, 30 Apr 2024 10:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474173;
	bh=9ipD906QJp66bVxTKK/gyPKoah22p/LIvU5N46rwKAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScWSSP+8/ypfiiFz6b9F5lrKq9XWA5w0XmyyfKUSKgYFZqow8oeas1MdE+fmNyVCE
	 cjrTR/dv8ApvXKPxT4awSx5+UVYZLPgVcQVBfVew8WwfvFMe39s/i2awC/5I6K6TTA
	 TfGHvBOFSiYHV0ICqqt+LHykzBajCJ6ga+1FHDVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 078/228] Bluetooth: hci_conn: Only do ACL connections sequentially
Date: Tue, 30 Apr 2024 12:37:36 +0200
Message-ID: <20240430103106.055570684@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit 45340097ce6ea7e875674a5a7d24c95ecbc93ef9 ]

Pretty much all bluetooth chipsets only support paging a single device at
a time, and if they don't reject a secondary "Create Connection" request
while another is still ongoing, they'll most likely serialize those
requests in the firware.

With commit 4c67bc74f016 ("[Bluetooth] Support concurrent connect
requests") we started adding some serialization of our own in case the
adapter returns "Command Disallowed" HCI error.

This commit was using the BT_CONNECT2 state for the serialization, this
state is also used for a few more things (most notably to indicate we're
waiting for an inquiry to cancel) and therefore a bit unreliable. Also
not all BT firwares would respond with "Command Disallowed" on too many
connection requests, some will also respond with "Hardware Failure"
(BCM4378), and others will error out later and send a "Connect Complete"
event with error "Rejected Limited Resources" (Marvell 88W8897).

We can clean things up a bit and also make the serialization more reliable
by using our hci_sync machinery to always do "Create Connection" requests
in a sequential manner.

This is very similar to what we're already doing for establishing LE
connections, and it works well there.

Note that this causes a test failure in mgmt-tester (test "Pair Device
- Power off 1") because the hci_abort_conn_sync() changes the error we
return on timeout of the "Create Connection". We'll fix this on the
mgmt-tester side by adjusting the expected error for the test.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |  1 +
 include/net/bluetooth/hci_sync.h |  3 ++
 net/bluetooth/hci_conn.c         | 69 ++++---------------------------
 net/bluetooth/hci_sync.c         | 70 ++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 60 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 04ec9c6e69e46..bfddb648fcc3e 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -453,6 +453,7 @@ enum {
 #define HCI_NCMD_TIMEOUT	msecs_to_jiffies(4000)	/* 4 seconds */
 #define HCI_ACL_TX_TIMEOUT	msecs_to_jiffies(45000)	/* 45 seconds */
 #define HCI_AUTO_OFF_TIMEOUT	msecs_to_jiffies(2000)	/* 2 seconds */
+#define HCI_ACL_CONN_TIMEOUT	msecs_to_jiffies(20000)	/* 20 seconds */
 #define HCI_LE_CONN_TIMEOUT	msecs_to_jiffies(20000)	/* 20 seconds */
 #define HCI_LE_AUTOCONN_TIMEOUT	msecs_to_jiffies(4000)	/* 4 seconds */
 
diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index e2582c2425449..824660f8f30da 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -138,3 +138,6 @@ int hci_le_terminate_big_sync(struct hci_dev *hdev, u8 handle, u8 reason);
 int hci_le_big_terminate_sync(struct hci_dev *hdev, u8 handle);
 
 int hci_le_pa_terminate_sync(struct hci_dev *hdev, u16 handle);
+
+int hci_acl_create_connection_sync(struct hci_dev *hdev,
+				   struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ba330114d38f7..d21e39ae67658 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -178,64 +178,6 @@ static void hci_conn_cleanup(struct hci_conn *conn)
 	hci_dev_put(hdev);
 }
 
-static void hci_acl_create_connection(struct hci_conn *conn)
-{
-	struct hci_dev *hdev = conn->hdev;
-	struct inquiry_entry *ie;
-	struct hci_cp_create_conn cp;
-
-	BT_DBG("hcon %p", conn);
-
-	/* Many controllers disallow HCI Create Connection while it is doing
-	 * HCI Inquiry. So we cancel the Inquiry first before issuing HCI Create
-	 * Connection. This may cause the MGMT discovering state to become false
-	 * without user space's request but it is okay since the MGMT Discovery
-	 * APIs do not promise that discovery should be done forever. Instead,
-	 * the user space monitors the status of MGMT discovering and it may
-	 * request for discovery again when this flag becomes false.
-	 */
-	if (test_bit(HCI_INQUIRY, &hdev->flags)) {
-		/* Put this connection to "pending" state so that it will be
-		 * executed after the inquiry cancel command complete event.
-		 */
-		conn->state = BT_CONNECT2;
-		hci_send_cmd(hdev, HCI_OP_INQUIRY_CANCEL, 0, NULL);
-		return;
-	}
-
-	conn->state = BT_CONNECT;
-	conn->out = true;
-	conn->role = HCI_ROLE_MASTER;
-
-	conn->attempt++;
-
-	conn->link_policy = hdev->link_policy;
-
-	memset(&cp, 0, sizeof(cp));
-	bacpy(&cp.bdaddr, &conn->dst);
-	cp.pscan_rep_mode = 0x02;
-
-	ie = hci_inquiry_cache_lookup(hdev, &conn->dst);
-	if (ie) {
-		if (inquiry_entry_age(ie) <= INQUIRY_ENTRY_AGE_MAX) {
-			cp.pscan_rep_mode = ie->data.pscan_rep_mode;
-			cp.pscan_mode     = ie->data.pscan_mode;
-			cp.clock_offset   = ie->data.clock_offset |
-					    cpu_to_le16(0x8000);
-		}
-
-		memcpy(conn->dev_class, ie->data.dev_class, 3);
-	}
-
-	cp.pkt_type = cpu_to_le16(conn->pkt_type);
-	if (lmp_rswitch_capable(hdev) && !(hdev->link_mode & HCI_LM_MASTER))
-		cp.role_switch = 0x01;
-	else
-		cp.role_switch = 0x00;
-
-	hci_send_cmd(hdev, HCI_OP_CREATE_CONN, sizeof(cp), &cp);
-}
-
 int hci_disconnect(struct hci_conn *conn, __u8 reason)
 {
 	BT_DBG("hcon %p", conn);
@@ -1696,10 +1638,17 @@ struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 
 	acl->conn_reason = conn_reason;
 	if (acl->state == BT_OPEN || acl->state == BT_CLOSED) {
+		int err;
+
 		acl->sec_level = BT_SECURITY_LOW;
 		acl->pending_sec_level = sec_level;
 		acl->auth_type = auth_type;
-		hci_acl_create_connection(acl);
+
+		err = hci_acl_create_connection_sync(hdev, acl);
+		if (err) {
+			hci_conn_del(acl);
+			return ERR_PTR(err);
+		}
 	}
 
 	return acl;
@@ -2654,7 +2603,7 @@ void hci_conn_check_pending(struct hci_dev *hdev)
 
 	conn = hci_conn_hash_lookup_state(hdev, ACL_LINK, BT_CONNECT2);
 	if (conn)
-		hci_acl_create_connection(conn);
+		hci_acl_create_connection_sync(hdev, conn);
 
 	hci_dev_unlock(hdev);
 }
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e1050d7d21a59..e4f89b6e917e2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6551,3 +6551,73 @@ int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 	return hci_cmd_sync_queue(hdev, _update_adv_data_sync,
 				  UINT_PTR(instance), NULL);
 }
+
+static int __hci_acl_create_connection_sync(struct hci_dev *hdev, void *data)
+{
+	struct hci_conn *conn = data;
+	struct inquiry_entry *ie;
+	struct hci_cp_create_conn cp;
+	int err;
+
+	/* Many controllers disallow HCI Create Connection while it is doing
+	 * HCI Inquiry. So we cancel the Inquiry first before issuing HCI Create
+	 * Connection. This may cause the MGMT discovering state to become false
+	 * without user space's request but it is okay since the MGMT Discovery
+	 * APIs do not promise that discovery should be done forever. Instead,
+	 * the user space monitors the status of MGMT discovering and it may
+	 * request for discovery again when this flag becomes false.
+	 */
+	if (test_bit(HCI_INQUIRY, &hdev->flags)) {
+		err = __hci_cmd_sync_status(hdev, HCI_OP_INQUIRY_CANCEL, 0,
+					    NULL, HCI_CMD_TIMEOUT);
+		if (err)
+			bt_dev_warn(hdev, "Failed to cancel inquiry %d", err);
+	}
+
+	conn->state = BT_CONNECT;
+	conn->out = true;
+	conn->role = HCI_ROLE_MASTER;
+
+	conn->attempt++;
+
+	conn->link_policy = hdev->link_policy;
+
+	memset(&cp, 0, sizeof(cp));
+	bacpy(&cp.bdaddr, &conn->dst);
+	cp.pscan_rep_mode = 0x02;
+
+	ie = hci_inquiry_cache_lookup(hdev, &conn->dst);
+	if (ie) {
+		if (inquiry_entry_age(ie) <= INQUIRY_ENTRY_AGE_MAX) {
+			cp.pscan_rep_mode = ie->data.pscan_rep_mode;
+			cp.pscan_mode     = ie->data.pscan_mode;
+			cp.clock_offset   = ie->data.clock_offset |
+					    cpu_to_le16(0x8000);
+		}
+
+		memcpy(conn->dev_class, ie->data.dev_class, 3);
+	}
+
+	cp.pkt_type = cpu_to_le16(conn->pkt_type);
+	if (lmp_rswitch_capable(hdev) && !(hdev->link_mode & HCI_LM_MASTER))
+		cp.role_switch = 0x01;
+	else
+		cp.role_switch = 0x00;
+
+	err = __hci_cmd_sync_status_sk(hdev, HCI_OP_CREATE_CONN,
+				       sizeof(cp), &cp,
+				       HCI_EV_CONN_COMPLETE,
+				       HCI_ACL_CONN_TIMEOUT, NULL);
+
+	if (err == -ETIMEDOUT)
+		hci_abort_conn_sync(hdev, conn, HCI_ERROR_LOCAL_HOST_TERM);
+
+	return err;
+}
+
+int hci_acl_create_connection_sync(struct hci_dev *hdev,
+				   struct hci_conn *conn)
+{
+	return hci_cmd_sync_queue(hdev, __hci_acl_create_connection_sync,
+				  conn, NULL);
+}
-- 
2.43.0



