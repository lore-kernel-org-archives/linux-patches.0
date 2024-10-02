Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBDA1D0486;
	Wed,  2 Oct 2024 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875432; cv=none; b=pUqKdAuHNrsJMuioxRCQJXL+k2vI7Zl9g8FmE6JKlP5DaVL1cPx2kr48yTJcWkyEBaiUZ4V27OBS8PGpO0aL3S2TE+06FxKJ57KZ9gukUsmAatks+Gtxmm1u3TILXOJMQ/oyGr+8RIzQ8KRiPDDmU2mSSQTy7DHu6lNSl3sVCAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875432; c=relaxed/simple;
	bh=ssrMW18wcSdIDDqzcl9RdzjaXQnc2gtQcEEeZZ73BfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olzGV1LRLDkkA/oBjspaTy/4/gzCXUtpBTEiBp2ud36GwMoJovgVNmakHdNzj20vjV+XFSfd9B0GJxzQM16ECLIJgK95zgG6GqIF2xJigdOX6asEgoqioN4kJxwEobSvZN5J8WELQkTQlkk5V8xgT3ZGwG82Kgc04XuhbEAIJMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRbYKFHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRbYKFHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D46C4CEC5;
	Wed,  2 Oct 2024 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875432;
	bh=ssrMW18wcSdIDDqzcl9RdzjaXQnc2gtQcEEeZZ73BfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRbYKFHsFUe5FSRlcRLj9cBRYkUD/tmH3fJWxuOtYWyr1A27BgmNHihHAZcWNXbEY
	 DkMsK/v/SzP2xI5r4EgJZ5miFl6GvAmrNd2sX9hBEs2VRjfMBB9vTk60Z5uiacWEWB
	 ZOv9e2CC3Sv/0m6Y66FUTzMcYyv0KXyU/DsUNhOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 100/695] Bluetooth: hci_core: Fix sending MGMT_EV_CONNECT_FAILED
Date: Wed,  2 Oct 2024 14:51:38 +0200
Message-ID: <20241002125826.468466370@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1a32e602630e3..88265d37aa72e 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2257,8 +2257,8 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
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
index c82502e213a88..58b528df1a86e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -106,8 +106,7 @@ void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status)
 	 * where a timeout + cancel does indicate an actual failure.
 	 */
 	if (status && status != HCI_ERROR_UNKNOWN_CONN_ID)
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
+		mgmt_connect_failed(hdev, conn, status);
 
 	/* The connection attempt was doing scan for new RPA, and is
 	 * in scan phase. If params are not associated with any other
@@ -1250,8 +1249,7 @@ void hci_conn_failed(struct hci_conn *conn, u8 status)
 		hci_le_conn_failed(conn, status);
 		break;
 	case ACL_LINK:
-		mgmt_connect_failed(hdev, &conn->dst, conn->type,
-				    conn->dst_type, status);
+		mgmt_connect_failed(hdev, conn, status);
 		break;
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 279902e8bd8a7..e4f564d6f6fbf 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9779,13 +9779,18 @@ void mgmt_disconnect_failed(struct hci_dev *hdev, bdaddr_t *bdaddr,
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



