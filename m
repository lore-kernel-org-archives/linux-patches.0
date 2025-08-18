Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45B732277A;
	Mon, 18 Aug 2025 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523516; cv=none; b=j1gznxL0n8njXEvi+CUxlOBWvtk/AfAoCwec4zjW7zwe5ftplfweLNSp/Jf4EuT3xrc0/TY4rnVIYiXOdPuycO9NhQ9lRKXZKNFjOKvaSNnODjt5YZ1X4hTOyFtXR3fl7sWm11hPVmACBnLhUuEsvaUtfKOtbrMb7k9rURczlfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523516; c=relaxed/simple;
	bh=PInJDu7GrzGuzseIKv0d1OyWZDaG0f8f3q0LUyk25WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/236uyWXCtmSV9C6jk/zrZGlAGOzhw0F1KMaTzNbPhtXtvu5Lh/T6Xo5GwUjzmGdDvtR8E6fNC+oifh0xOlmUw8W5pgoyYyOsWC0qu9RK70VPgSo+jh6aSUCifPhi8kI3Jo6R/D+WrLnCclEpRIsDvBJaVJU40SoQIuQ54BBKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtJdPF02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtJdPF02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105DCC4CEEB;
	Mon, 18 Aug 2025 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523515;
	bh=PInJDu7GrzGuzseIKv0d1OyWZDaG0f8f3q0LUyk25WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtJdPF02OQg0wn4iYnTsrJbz5OPOukrHT25l6xpYC9n3bPQm7d/2Tz6oFwQMtKtUr
	 fhJ3qLuVwpejimWudzJu2E/U+sfpieafqHNVRwdwU694UBkWm30zkXxi4qvu4QrHUB
	 nyS9q+dCIP5S4pEtg3aF6ckcoBwXUm6nIApP4Ecs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 195/515] Bluetooth: hci_event: Add support for handling LE BIG Sync Lost event
Date: Mon, 18 Aug 2025 14:43:01 +0200
Message-ID: <20250818124505.873374402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ebe01eb28264..702b526541e6 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2851,6 +2851,12 @@ struct hci_evt_le_big_sync_estabilished {
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
index 351a9057e70e..1d62f0cce195 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1348,7 +1348,8 @@ hci_conn_hash_lookup_big_sync_pend(struct hci_dev *hdev,
 }
 
 static inline struct hci_conn *
-hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle,  __u16 state)
+hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle, __u16 state,
+			       __u8 role)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
 	struct hci_conn  *c;
@@ -1356,7 +1357,7 @@ hci_conn_hash_lookup_big_state(struct hci_dev *hdev, __u8 handle,  __u16 state)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (c->type != BIS_LINK || c->state != state)
+		if (c->type != BIS_LINK || c->state != state || c->role != role)
 			continue;
 
 		if (handle == c->iso_qos.bcast.big) {
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index fccdb864af72..082cca18db2e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2144,7 +2144,8 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
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



