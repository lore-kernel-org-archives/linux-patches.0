Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C54144D1A;
	Tue, 10 Sep 2024 10:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964238; cv=none; b=BGV5Ah+l0/jBe1jp+I8Ao0AP0Edli5btlAvS14kEm/qqF+j+TjoiP+1xFoTqQxF10x/b8vIvYlS+zDurL9qAD+CWwHjPWA6VU3JigJsueBuv5jMNICDykyi4NNTpXccgn8HfFbgpMPJzdZ7BuE4LB26AIGqT0mQ+sOrKcazrVgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964238; c=relaxed/simple;
	bh=bo9euLSEawJtzimmu20ZIihWo0QjqfXiPGDlvu71WT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chhOnexHypfKPLqrXefs2YzxqlradvaCxNQAPDhyj36PCkVyWXGN1JpZt/rFLEnnvDaTesZArMy+OnDjAhW1I4bqtf6zYqx0DHXA+qR9wetTubH5tNyz9HycaZpv+aiZ+eeXEfpvagPQ5SGXlJq/JCT/PQlw9bwjiJmviBtLlJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTHx0cO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTHx0cO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB2DC4CEC3;
	Tue, 10 Sep 2024 10:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964238;
	bh=bo9euLSEawJtzimmu20ZIihWo0QjqfXiPGDlvu71WT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTHx0cO1JbMiue1BBX2T3kXegWeIGnXyvJF/cdQFbLCcj1+HdUl15JqUB7f97dIYa
	 iVrxEqj2TrxXNW++oZ7Pow0CbyVIXjQXo5rRXv9h1hBqYgrGhcuZqKrqM+YLtC3u/M
	 KEMLdp3PPSb2eFyyDZuijXMPty03yNGsSHGZRLuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/269] Bluetooth: Remove pending ACL connection attempts
Date: Tue, 10 Sep 2024 11:31:41 +0200
Message-ID: <20240910092612.258483803@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit 4aa42119d971603dc9e4d8cf4f53d5fcf082ea7d ]

With the last commit we moved to using the hci_sync queue for "Create
Connection" requests, removing the need for retrying the paging after
finished/failed "Create Connection" requests and after the end of
inquiries.

hci_conn_check_pending() was used to trigger this retry, we can remove it
now.

Note that we can also remove the special handling for COMMAND_DISALLOWED
errors in the completion handler of "Create Connection", because "Create
Connection" requests are now always serialized.

This is somewhat reverting commit 4c67bc74f016 ("[Bluetooth] Support
concurrent connect requests").

With this, the BT_CONNECT2 state of ACL hci_conn objects should now be
back to meaning only one thing: That we received a "Connection Request"
from another device (see hci_conn_request_evt), but the response to that
is going to be deferred.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 -
 net/bluetooth/hci_conn.c         | 16 ----------------
 net/bluetooth/hci_event.c        | 21 ++++-----------------
 3 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 070c794e6a42..850f0e46aecf 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1417,7 +1417,6 @@ struct hci_conn *hci_conn_add_unset(struct hci_dev *hdev, int type,
 				    bdaddr_t *dst, u8 role);
 void hci_conn_del(struct hci_conn *conn);
 void hci_conn_hash_flush(struct hci_dev *hdev);
-void hci_conn_check_pending(struct hci_dev *hdev);
 
 struct hci_chan *hci_chan_create(struct hci_conn *conn);
 void hci_chan_del(struct hci_chan *chan);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 04fe901a47f7..36731d047f16 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2565,22 +2565,6 @@ void hci_conn_hash_flush(struct hci_dev *hdev)
 	}
 }
 
-/* Check pending connect attempts */
-void hci_conn_check_pending(struct hci_dev *hdev)
-{
-	struct hci_conn *conn;
-
-	BT_DBG("hdev %s", hdev->name);
-
-	hci_dev_lock(hdev);
-
-	conn = hci_conn_hash_lookup_state(hdev, ACL_LINK, BT_CONNECT2);
-	if (conn)
-		hci_acl_create_connection_sync(hdev, conn);
-
-	hci_dev_unlock(hdev);
-}
-
 static u32 get_link_mode(struct hci_conn *conn)
 {
 	u32 link_mode = 0;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index dc80c1560357..d81c7fccdd40 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -118,8 +118,6 @@ static u8 hci_cc_inquiry_cancel(struct hci_dev *hdev, void *data,
 		hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
 	hci_dev_unlock(hdev);
 
-	hci_conn_check_pending(hdev);
-
 	return rp->status;
 }
 
@@ -150,8 +148,6 @@ static u8 hci_cc_exit_periodic_inq(struct hci_dev *hdev, void *data,
 
 	hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);
 
-	hci_conn_check_pending(hdev);
-
 	return rp->status;
 }
 
@@ -2257,10 +2253,8 @@ static void hci_cs_inquiry(struct hci_dev *hdev, __u8 status)
 {
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
-	if (status) {
-		hci_conn_check_pending(hdev);
+	if (status)
 		return;
-	}
 
 	if (hci_sent_cmd_data(hdev, HCI_OP_INQUIRY))
 		set_bit(HCI_INQUIRY, &hdev->flags);
@@ -2285,12 +2279,9 @@ static void hci_cs_create_conn(struct hci_dev *hdev, __u8 status)
 
 	if (status) {
 		if (conn && conn->state == BT_CONNECT) {
-			if (status != HCI_ERROR_COMMAND_DISALLOWED || conn->attempt > 2) {
-				conn->state = BT_CLOSED;
-				hci_connect_cfm(conn, status);
-				hci_conn_del(conn);
-			} else
-				conn->state = BT_CONNECT2;
+			conn->state = BT_CLOSED;
+			hci_connect_cfm(conn, status);
+			hci_conn_del(conn);
 		}
 	} else {
 		if (!conn) {
@@ -2980,8 +2971,6 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
-	hci_conn_check_pending(hdev);
-
 	if (!test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
 		return;
 
@@ -3228,8 +3217,6 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 
 unlock:
 	hci_dev_unlock(hdev);
-
-	hci_conn_check_pending(hdev);
 }
 
 static void hci_reject_conn(struct hci_dev *hdev, bdaddr_t *bdaddr)
-- 
2.43.0



