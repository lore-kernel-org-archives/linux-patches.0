Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DEA335BCD;
	Mon, 18 Aug 2025 13:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525268; cv=none; b=PrVDkvJ2rMIHqefxuQ4WIBrxI4XW4vK4BU7FecAkBzPqCzJ444I2G0dC0Lo0RQDt1aXOcrahbfkTYvvHRTOsoybNJx0vQqfYYSJrLZ5rQ7dVdPIaK3oEqb1PzZr14bOnsEpWa3bMVGLK2CewcNRB3m/XBtkgiXA92loGfMTIkHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525268; c=relaxed/simple;
	bh=Ra3fJCyiFCcEslXvBrF6XsFOAYihou2VRGW1ElS8zfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbP+KUar6YrkkJSJ+jI9387vR4lg+/nO/30WBm07PwRXtTvGsuhbFu22b2LsxX0XCT6tjjs7cqi8dxFuTmP7OJg86V8XKu3YDBk03ifvu0FhN5PPy2MYmRomiB2vLBhB+OQ2br5To8pJqJpPcUCiZEehhgPuhFN8GZ50GfQIKTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxN3taY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxN3taY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1859C4CEEB;
	Mon, 18 Aug 2025 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525268;
	bh=Ra3fJCyiFCcEslXvBrF6XsFOAYihou2VRGW1ElS8zfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxN3taY4YvlcsFQBNeoN/V7rN/vj/6ICEidXTQzdcbvzTPvlg6gmZqKTsg45ByurZ
	 NKmgrKlpd8KVIB5EJJhBbubRAAcbGKWg7KSVKDMKj8ZPr0T2j7KlG8nglGpHv7MCnV
	 WdLKg6FDBLYv7HxnPWFMykJZW26xzK14HDhjSV/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 211/570] Bluetooth: hci_event: Add support for handling LE BIG Sync Lost event
Date: Mon, 18 Aug 2025 14:43:18 +0200
Message-ID: <20250818124513.930706727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit b2a5f2e1c127cb431df22e114998ff72eb4578c8 ]

When the BIS source stops, the controller sends an LE BIG Sync Lost
event (subevent 0x1E). Currently, this event is not handled, causing
the BIS stream to remain active in BlueZ and preventing recovery.

Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |  6 +++++
 include/net/bluetooth/hci_core.h |  5 ++--
 net/bluetooth/hci_conn.c         |  3 ++-
 net/bluetooth/hci_event.c        | 39 +++++++++++++++++++++++++++++++-
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 5796ca9fe5da..8fa829873134 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2852,6 +2852,12 @@ struct hci_evt_le_big_sync_estabilished {
 	__le16  bis[];
 } __packed;
 
+#define HCI_EVT_LE_BIG_SYNC_LOST 0x1e
+struct hci_evt_le_big_sync_lost {
+	__u8    handle;
+	__u8    reason;
+} __packed;
+
 #define HCI_EVT_LE_BIG_INFO_ADV_REPORT	0x22
 struct hci_evt_le_big_info_adv_report {
 	__le16  sync_handle;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c371dadc6fa3..f22881bf1b39 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1352,7 +1352,8 @@ hci_conn_hash_lookup_big_sync_pend(struct hci_dev *hdev,
 }
 
 static inline struct hci_conn *
-hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle,  __u16 state)
+hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle, __u16 state,
+			       __u8 role)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
 	struct hci_conn  *c;
@@ -1360,7 +1361,7 @@ hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle,  __u16 state)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (c->type != BIS_LINK || c->state != state)
+		if (c->type != BIS_LINK || c->state != state || c->role != role)
 			continue;
 
 		if (handle == c->iso_qos.bcast.big) {
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 4f379184df5b..f5cd935490ad 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2146,7 +2146,8 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 	struct hci_link *link;
 
 	/* Look for any BIS that is open for rebinding */
-	conn = hci_conn_hash_lookup_big_state(hdev, qos->bcast.big, BT_OPEN);
+	conn = hci_conn_hash_lookup_big_state(hdev, qos->bcast.big, BT_OPEN,
+					      HCI_ROLE_MASTER);
 	if (conn) {
 		memcpy(qos, &conn->iso_qos, sizeof(*qos));
 		conn->state = BT_CONNECTED;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index c1dd8d78701f..b83995898da0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6880,7 +6880,8 @@ static void hci_le_create_big_complete_evt(struct hci_dev *hdev, void *data,
 
 	/* Connect all BISes that are bound to the BIG */
 	while ((conn = hci_conn_hash_lookup_big_state(hdev, ev->handle,
-						      BT_BOUND))) {
+						      BT_BOUND,
+						      HCI_ROLE_MASTER))) {
 		if (ev->status) {
 			hci_connect_cfm(conn, ev->status);
 			hci_conn_del(conn);
@@ -6996,6 +6997,37 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 	hci_dev_unlock(hdev);
 }
 
+static void hci_le_big_sync_lost_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
+{
+	struct hci_evt_le_big_sync_lost *ev = data;
+	struct hci_conn *bis, *conn;
+
+	bt_dev_dbg(hdev, "big handle 0x%2.2x", ev->handle);
+
+	hci_dev_lock(hdev);
+
+	/* Delete the pa sync connection */
+	bis = hci_conn_hash_lookup_pa_sync_big_handle(hdev, ev->handle);
+	if (bis) {
+		conn = hci_conn_hash_lookup_pa_sync_handle(hdev,
+							   bis->sync_handle);
+		if (conn)
+			hci_conn_del(conn);
+	}
+
+	/* Delete each bis connection */
+	while ((bis = hci_conn_hash_lookup_big_state(hdev, ev->handle,
+						     BT_CONNECTED,
+						     HCI_ROLE_SLAVE))) {
+		clear_bit(HCI_CONN_BIG_SYNC, &bis->flags);
+		hci_disconn_cfm(bis, ev->reason);
+		hci_conn_del(bis);
+	}
+
+	hci_dev_unlock(hdev);
+}
+
 static void hci_le_big_info_adv_report_evt(struct hci_dev *hdev, void *data,
 					   struct sk_buff *skb)
 {
@@ -7119,6 +7151,11 @@ static const struct hci_le_ev {
 		     hci_le_big_sync_established_evt,
 		     sizeof(struct hci_evt_le_big_sync_estabilished),
 		     HCI_MAX_EVENT_SIZE),
+	/* [0x1e = HCI_EVT_LE_BIG_SYNC_LOST] */
+	HCI_LE_EV_VL(HCI_EVT_LE_BIG_SYNC_LOST,
+		     hci_le_big_sync_lost_evt,
+		     sizeof(struct hci_evt_le_big_sync_lost),
+		     HCI_MAX_EVENT_SIZE),
 	/* [0x22 = HCI_EVT_LE_BIG_INFO_ADV_REPORT] */
 	HCI_LE_EV_VL(HCI_EVT_LE_BIG_INFO_ADV_REPORT,
 		     hci_le_big_info_adv_report_evt,
-- 
2.39.5



