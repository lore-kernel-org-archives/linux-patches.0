Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1D18E77F;
	Tue, 10 Sep 2024 10:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964241; cv=none; b=i5nXKJIRgnpO+4u3K1L3z4mYk+byhQ0wZvPuZ0d5B4Md6g8f6+/5WyJLZDpM2pU+IE1UtymS4ql4De2ivBe7d7GPkkk8RhwIiku709tGuF77wAGNL9b5unQCUabqc+XSIYk7CncoZD8mq13zX8SNGZbVMEFEwGfmJ8mQVYoaWYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964241; c=relaxed/simple;
	bh=hZ5bZhLuK3NX174YHWIdu4g9yuXPvO5xCRNYWKFA0LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWcBmzFlvrQkyUPcrevBeUyd4YmNC9j3mg/1/arkCFD5EyByHYCptfZ59Ds0akvAJzz0b9bxHU61QJjIw+4CtZ13tK1UdC8r8KqC2iyY3q3S/t3nKzGsGUkurI7LWpvKxnPGoS5sx1bFZO/wcFuQXF+o3973RsXqaptZ6TjXy/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKT9GBQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKT9GBQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53EFC4CEC3;
	Tue, 10 Sep 2024 10:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964241;
	bh=hZ5bZhLuK3NX174YHWIdu4g9yuXPvO5xCRNYWKFA0LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKT9GBQViS5ebkMaNzZ7HrE6I5K2m4ViH0hx6UN55EOQGHGv0p2YzU2mvYJetUhCV
	 EvTOUzIwo2km8a+AskJbL1MHwiyc4vMEfsvK90Lym7XtHJS+wjjybTKoApL+kXv14K
	 6I+eBBN8EacMnZW5LGkmOsgyu17e//o+pFE9vejQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f0a39be7a2035700868@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/269] Bluetooth: hci_conn: Fix UAF Write in __hci_acl_create_connection_sync
Date: Tue, 10 Sep 2024 11:31:42 +0200
Message-ID: <20240910092612.291505620@linuxfoundation.org>
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

[ Upstream commit 5f641f03abccddd1a37233ff1b8e774b9ff1f4e8 ]

This fixes the UAF on __hci_acl_create_connection_sync caused by
connection abortion, it uses the same logic as to LE_LINK which uses
hci_cmd_sync_cancel to prevent the callback to run if the connection is
abort prematurely.

Reported-by: syzbot+3f0a39be7a2035700868@syzkaller.appspotmail.com
Fixes: 45340097ce6e ("Bluetooth: hci_conn: Only do ACL connections sequentially")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  3 +--
 net/bluetooth/hci_conn.c         |  3 ++-
 net/bluetooth/hci_sync.c         | 16 ++++++++++------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 532230150cc9..37ca8477b3f4 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -141,5 +141,4 @@ int hci_le_big_terminate_sync(struct hci_dev *hdev, u8 handle);
 
 int hci_le_pa_terminate_sync(struct hci_dev *hdev, u16 handle);
 
-int hci_acl_create_connection_sync(struct hci_dev *hdev,
-				   struct hci_conn *conn);
+int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 36731d047f16..d15c8ce4b418 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1650,7 +1650,7 @@ struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 		acl->pending_sec_level = sec_level;
 		acl->auth_type = auth_type;
 
-		err = hci_acl_create_connection_sync(hdev, acl);
+		err = hci_connect_acl_sync(hdev, acl);
 		if (err) {
 			hci_conn_del(acl);
 			return ERR_PTR(err);
@@ -2913,6 +2913,7 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 */
 	if (conn->state == BT_CONNECT && hdev->req_status == HCI_REQ_PEND) {
 		switch (hci_skb_event(hdev->sent_cmd)) {
+		case HCI_EV_CONN_COMPLETE:
 		case HCI_EV_LE_CONN_COMPLETE:
 		case HCI_EV_LE_ENHANCED_CONN_COMPLETE:
 		case HCI_EVT_LE_CIS_ESTABLISHED:
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 165c532fa2a2..19ceb7ce66bf 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6578,13 +6578,18 @@ int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 				  UINT_PTR(instance), NULL);
 }
 
-static int __hci_acl_create_connection_sync(struct hci_dev *hdev, void *data)
+static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 {
-	struct hci_conn *conn = data;
+	struct hci_conn *conn;
+	u16 handle = PTR_UINT(data);
 	struct inquiry_entry *ie;
 	struct hci_cp_create_conn cp;
 	int err;
 
+	conn = hci_conn_hash_lookup_handle(hdev, handle);
+	if (!conn)
+		return 0;
+
 	/* Many controllers disallow HCI Create Connection while it is doing
 	 * HCI Inquiry. So we cancel the Inquiry first before issuing HCI Create
 	 * Connection. This may cause the MGMT discovering state to become false
@@ -6641,9 +6646,8 @@ static int __hci_acl_create_connection_sync(struct hci_dev *hdev, void *data)
 	return err;
 }
 
-int hci_acl_create_connection_sync(struct hci_dev *hdev,
-				   struct hci_conn *conn)
+int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
-	return hci_cmd_sync_queue(hdev, __hci_acl_create_connection_sync,
-				  conn, NULL);
+	return hci_cmd_sync_queue(hdev, hci_acl_create_conn_sync,
+				  UINT_PTR(conn->handle), NULL);
 }
-- 
2.43.0



