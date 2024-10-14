Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9521D1C7B9C;
	Mon, 14 Oct 2024 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917480; cv=none; b=WRGgtPQX3MLB5XaiEi4zX7nfXafuRROVXBnsorUO/0qNv1tuFESmua1HykWDKpTuqLh1/U+tikyJ/sSnKyzyL1HnSEbmMT/FNA8ErDeiFpkb8QwXNpYoa4ghc0nHlij2d289f/uAfJw2cs1JjI6hvAF4yP3OA9wcKGjrN3WlB74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917480; c=relaxed/simple;
	bh=TV4FH4z8T1RMUldEFmrgRH8d9GY1dMbm/9zX9QWKb54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAXs1t35gnhsqjXSxdZZe1Zeehx6NK5WtwxpWd6kkCVIBhRyAPvn7BN1rq8lVL0FnUtEjj5jwA0jQLwfLcXXZN6DPXIy6jcH54L/vDGeJdBADyVzqOOVaCEXeSH9QcSSrNxsIU3qDkKO9MwHsz7ZjBMbzH4YghgYTmcjxtmlQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhD2aCXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhD2aCXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C81EC4CEC3;
	Mon, 14 Oct 2024 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917480;
	bh=TV4FH4z8T1RMUldEFmrgRH8d9GY1dMbm/9zX9QWKb54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhD2aCXVJntlPPYuJZ2G3NlRg0yHR7iFrBOz7YHxc+L0nZ66G0sv76ctYtxdCxDoT
	 1TjRQE+4qOs8quXfijJetnwEiFcQzGQ3k849Hl1vUwabgUbUMPO9r4WQj4m7cvD6ZV
	 JBuJj/IxJfKZYfDB7mGmqGLtpTyjh/0Sy8c/uh8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/798] Bluetooth: hci_core: Fix sending MGMT_EV_CONNECT_FAILED
Date: Mon, 14 Oct 2024 16:10:01 +0200
Message-ID: <20241014141219.791350549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d47da6bd4cfa982fe903f33423b9e2ec541e9496 ]

If HCI_CONN_MGMT_CONNECTED has been set then the event shall be
HCI_CONN_MGMT_DISCONNECTED.

Fixes: b644ba336997 ("Bluetooth: Update device_connected and device_found events to latest API")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  4 ++--
 net/bluetooth/hci_conn.c         |  6 ++----
 net/bluetooth/mgmt.c             | 13 +++++++++----
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 98c0a82bd5338..215b56dc26df2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2071,8 +2071,8 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			      bool mgmt_connected);
 void mgmt_disconnect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			    u8 link_type, u8 addr_type, u8 status);
-void mgmt_connect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
-			 u8 addr_type, u8 status);
+void mgmt_connect_failed(struct hci_dev *hdev, struct hci_conn *conn,
+			 u8 status);
 void mgmt_pin_code_request(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 secure);
 void mgmt_pin_code_reply_complete(struct hci_dev *hdev, bdaddr_t *bdaddr,
 				  u8 status);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 858c454e35e67..5ec2160108a1f 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -107,8 +107,7 @@ static void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status)
 	 * where a timeout + cancel does indicate an actual failure.
 	 */
 	if (status && status != HCI_ERROR_UNKNOWN_CONN_ID)
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
+		mgmt_connect_failed(hdev, conn, status);
 
 	/* The connection attempt was doing scan for new RPA, and is
 	 * in scan phase. If params are not associated with any other
@@ -1181,8 +1180,7 @@ void hci_conn_failed(struct hci_conn *conn, u8 status)
 		hci_le_conn_failed(conn, status);
 		break;
 	case ACL_LINK:
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
+		mgmt_connect_failed(hdev, conn, status);
 		break;
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index c5a3a336515e7..284a0672dcc38 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9816,13 +9816,18 @@ void mgmt_disconnect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	mgmt_pending_remove(cmd);
 }
 
-void mgmt_connect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
-			 u8 addr_type, u8 status)
+void mgmt_connect_failed(struct hci_dev *hdev, struct hci_conn *conn, u8 status)
 {
 	struct mgmt_ev_connect_failed ev;
 
-	bacpy(&ev.addr.bdaddr, bdaddr);
-	ev.addr.type = link_to_bdaddr(link_type, addr_type);
+	if (test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags)) {
+		mgmt_device_disconnected(hdev, &conn->dst, conn->type,
+					 conn->dst_type, status, true);
+		return;
+	}
+
+	bacpy(&ev.addr.bdaddr, &conn->dst);
+	ev.addr.type = link_to_bdaddr(conn->type, conn->dst_type);
 	ev.status = mgmt_status(status);
 
 	mgmt_event(MGMT_EV_CONNECT_FAILED, hdev, &ev, sizeof(ev), NULL);
-- 
2.43.0



