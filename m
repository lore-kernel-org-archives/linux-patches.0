Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAE212C47A;
	Tue, 30 Apr 2024 10:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474183; cv=none; b=NQPqv/gtOj40N8X8SQ3DXlwAc0Pek/69bAeSDciX+MHioqoL84QJ+pt4YghrQGTRm5npU9fPxtBRTBbwG57y44v2H/HRuVDuj0VNuX/8IAALoeSW93jF+B7gEKJKfyfMtf98gVXs6arhqBCF6VRoR1clV37jcPsBi69Dhb3TG7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474183; c=relaxed/simple;
	bh=ECGiJoNxb881FLZlk4yqtrhw/kntk1FFX2MC42aZYi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNMu1klRqg3tQ4acrFqipBTsxaylz9qgYIaez/BI8UNRcTj7AQQHcyG5NYPRZdA9AELIkb/XInbB7w5xvOcpV/gh+WZsmkf/ePc+778l0r/xe6B5LXjvoNs1dxww104YHL/EWDY13IeVgewkSpl07YDKZQQt1Y+QqaQQ0FXYMcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYQjQRtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYQjQRtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD5CC2BBFC;
	Tue, 30 Apr 2024 10:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474183;
	bh=ECGiJoNxb881FLZlk4yqtrhw/kntk1FFX2MC42aZYi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYQjQRtrtOiS2VD/RXd+JO03WqstbI88QgP30qHFOc/KoldtvPF6RC1E3uWHmyYOL
	 5OxrpEk4vYei/VAVpVWCigNwwPV3g/fdYen8SgzE/wkjHVvtodNJSaEr+CksfBVNrQ
	 U7VsPFyejRz8ivT0Z6aYohUa8A7qMTEVYqpwtwVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f0a39be7a2035700868@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 081/228] Bluetooth: hci_conn: Fix UAF Write in __hci_acl_create_connection_sync
Date: Tue, 30 Apr 2024 12:37:39 +0200
Message-ID: <20240430103106.141449520@linuxfoundation.org>
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

[ Upstream commit 5f641f03abccddd1a37233ff1b8e774b9ff1f4e8 ]

This fixes the UAF on __hci_acl_create_connection_sync caused by
connection abortion, it uses the same logic as to LE_LINK which uses
hci_cmd_sync_cancel to prevent the callback to run if the connection is
abort prematurely.

Reported-by: syzbot+3f0a39be7a2035700868@syzkaller.appspotmail.com
Fixes: 45340097ce6e ("Bluetooth: hci_conn: Only do ACL connections sequentially")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  3 +--
 net/bluetooth/hci_conn.c         |  3 ++-
 net/bluetooth/hci_sync.c         | 16 ++++++++++------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 824660f8f30da..ed334c253ebcd 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -139,5 +139,4 @@ int hci_le_big_terminate_sync(struct hci_dev *hdev, u8 handle);
 
 int hci_le_pa_terminate_sync(struct hci_dev *hdev, u16 handle);
 
-int hci_acl_create_connection_sync(struct hci_dev *hdev,
-				   struct hci_conn *conn);
+int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 47f117874479d..3475ea55c2534 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1645,7 +1645,7 @@ struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 		acl->auth_type = auth_type;
 		acl->conn_timeout = timeout;
 
-		err = hci_acl_create_connection_sync(hdev, acl);
+		err = hci_connect_acl_sync(hdev, acl);
 		if (err) {
 			hci_conn_del(acl);
 			return ERR_PTR(err);
@@ -2942,6 +2942,7 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 */
 	if (conn->state == BT_CONNECT && hdev->req_status == HCI_REQ_PEND) {
 		switch (hci_skb_event(hdev->sent_cmd)) {
+		case HCI_EV_CONN_COMPLETE:
 		case HCI_EV_LE_CONN_COMPLETE:
 		case HCI_EV_LE_ENHANCED_CONN_COMPLETE:
 		case HCI_EVT_LE_CIS_ESTABLISHED:
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 816fd9c38ae04..cffa61ecf234f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6552,13 +6552,18 @@ int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
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
@@ -6615,9 +6620,8 @@ static int __hci_acl_create_connection_sync(struct hci_dev *hdev, void *data)
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



