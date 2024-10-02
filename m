Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C231D0BB4;
	Wed,  2 Oct 2024 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879364; cv=none; b=Bg2djH0tvd2I6LzuAfejMVDHCbV6lFQwHw7qAVqXdqvbIq/DRnI5l4gFVrVW8MGm2V0hRdBoIUlKdQDZLS2XG8o4IvhaKnaadm7IjU+/PrKrmSOl7NXjn/ydFivNbwSIowmhAE7nketfGF/PAAVzMOoF990aJLQgFHsZ2Xoa2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879364; c=relaxed/simple;
	bh=BHjS//TiHLU+teKB8bAQw9OUZu3gnK0yjX56Pnw0VYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3m04iPLUsMaZfD8PAzOt4PQ3nxPJRiDhaMGL/ypvLbPEYhhSJJRtlabZUpRSKiQZPuabOcd7i2+Lbdq8xuAJQwwftGvSueRuBSRb61S1vQXdtQ2kAvWlai2JdqwHUJQgOtB+ajn8tiJuzEFEL7mKVJV42XBnwOj2efXK/gm/0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vd4Znv+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vd4Znv+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BAEC4CEC2;
	Wed,  2 Oct 2024 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879364;
	bh=BHjS//TiHLU+teKB8bAQw9OUZu3gnK0yjX56Pnw0VYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vd4Znv+ScB3z2ayyiJbS31Hl5DTyrCumuJNsqKLk6HLoJ9O2CoMI0nK0jiw877GEg
	 0SCJOtSHm3HetyJznR42kjbFdKZZU+cdu7Ff9mYAe/aI4rNj3E5gB2OjM8Yc0shlOT
	 yr3RVJguUgC7uPpw1omr+HntWLe0qhQknUwrjgJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/538] Bluetooth: hci_core: Fix sending MGMT_EV_CONNECT_FAILED
Date: Wed,  2 Oct 2024 14:55:01 +0200
Message-ID: <20241002125754.657823260@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 29f1549ee1114..0f50c0cefcb7d 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2224,8 +2224,8 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
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
index d8a01eb016ad0..ed95a87ef9ab6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -107,8 +107,7 @@ void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status)
 	 * where a timeout + cancel does indicate an actual failure.
 	 */
 	if (status && status != HCI_ERROR_UNKNOWN_CONN_ID)
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
+		mgmt_connect_failed(hdev, conn, status);
 
 	/* The connection attempt was doing scan for new RPA, and is
 	 * in scan phase. If params are not associated with any other
@@ -1233,8 +1232,7 @@ void hci_conn_failed(struct hci_conn *conn, u8 status)
 		hci_le_conn_failed(conn, status);
 		break;
 	case ACL_LINK:
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
+		mgmt_connect_failed(hdev, conn, status);
 		break;
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 4ae9029b5785f..149aff29e5646 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9724,13 +9724,18 @@ void mgmt_disconnect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr,
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



