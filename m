Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E313EA6F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xj2UWom8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0904CC433CC;
	Wed, 15 Nov 2023 19:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076243;
	bh=xAIrYRXspAFaU60KZ3yKh/KxKBQBNTppEqK6Z28pUYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xj2UWom8KCw0m/QWPRMicdAHkTyW3irGPGX+zJNIr249+x9VNAL4A0NMQGz48MPli
	 vpAJt5er3pSilWHhk2dpyiy1tEc1ptBdLEUOyJC03In/EABYDz1M+iss6ZlMqwkZlR
	 j9OWgfYp+TzjfThUMn9daH5malx2ofuINJLMn3qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 141/550] Bluetooth: ISO: Pass BIG encryption info through QoS
Date: Wed, 15 Nov 2023 14:12:05 -0500
Message-ID: <20231115191610.465728455@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 1d11d70d1f6b23e7d3fc00396c17b90b876162a4 ]

This enables a broadcast sink to be informed if the PA
it has synced with is associated with an encrypted BIG,
by retrieving the socket QoS and checking the encryption
field.

After PA sync has been successfully established and the
first BIGInfo advertising report is received, a new hcon
is added and notified to the ISO layer. The ISO layer
sets the encryption field of the socket and hcon QoS
according to the encryption parameter of the BIGInfo
advertising report event.

After that, the userspace is woken up, and the QoS of the
new PA sync socket can be read, to inspect the encryption
field and follow up accordingly.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 181a42edddf5 ("Bluetooth: Make handle of hci_conn be unique")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |  3 ++
 include/net/bluetooth/hci_core.h | 25 ++++++++++++++-
 net/bluetooth/hci_conn.c         |  1 +
 net/bluetooth/hci_event.c        | 54 +++++++++++++++++++++++---------
 net/bluetooth/iso.c              | 19 ++++++++---
 5 files changed, 82 insertions(+), 20 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 3ff822ebb3a47..1788aeedecf5a 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1,6 +1,7 @@
 /*
    BlueZ - Bluetooth protocol stack for Linux
    Copyright (C) 2000-2001 Qualcomm Incorporated
+   Copyright 2023 NXP
 
    Written 2000,2001 by Maxim Krasnyansky <maxk@qualcomm.com>
 
@@ -672,6 +673,8 @@ enum {
 #define HCI_TX_POWER_INVALID	127
 #define HCI_RSSI_INVALID	127
 
+#define HCI_SYNC_HANDLE_INVALID	0xffff
+
 #define HCI_ROLE_MASTER		0x00
 #define HCI_ROLE_SLAVE		0x01
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 032c05998345d..0a3f98481b0fe 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1315,7 +1315,7 @@ static inline struct hci_conn *hci_conn_hash_lookup_big_any_dst(struct hci_dev *
 }
 
 static inline struct hci_conn *
-hci_conn_hash_lookup_pa_sync(struct hci_dev *hdev, __u8 big)
+hci_conn_hash_lookup_pa_sync_big_handle(struct hci_dev *hdev, __u8 big)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
 	struct hci_conn  *c;
@@ -1337,6 +1337,29 @@ hci_conn_hash_lookup_pa_sync(struct hci_dev *hdev, __u8 big)
 	return NULL;
 }
 
+static inline struct hci_conn *
+hci_conn_hash_lookup_pa_sync_handle(struct hci_dev *hdev, __u16 sync_handle)
+{
+	struct hci_conn_hash *h = &hdev->conn_hash;
+	struct hci_conn  *c;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(c, &h->list, list) {
+		if (c->type != ISO_LINK ||
+			!test_bit(HCI_CONN_PA_SYNC, &c->flags))
+			continue;
+
+		if (c->sync_handle == sync_handle) {
+			rcu_read_unlock();
+			return c;
+		}
+	}
+	rcu_read_unlock();
+
+	return NULL;
+}
+
 static inline struct hci_conn *hci_conn_hash_lookup_state(struct hci_dev *hdev,
 							__u8 type, __u16 state)
 {
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c3da326615931..7cad9665360cf 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -975,6 +975,7 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 	conn->rssi = HCI_RSSI_INVALID;
 	conn->tx_power = HCI_TX_POWER_INVALID;
 	conn->max_tx_power = HCI_TX_POWER_INVALID;
+	conn->sync_handle = HCI_SYNC_HANDLE_INVALID;
 
 	set_bit(HCI_CONN_POWER_SAVE, &conn->flags);
 	conn->disc_timeout = HCI_DISCONN_TIMEOUT;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 97d589178eb78..5a23dd251cb2e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6578,7 +6578,7 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 	struct hci_ev_le_pa_sync_established *ev = data;
 	int mask = hdev->link_mode;
 	__u8 flags = 0;
-	struct hci_conn *bis;
+	struct hci_conn *pa_sync;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
@@ -6595,20 +6595,19 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 	if (!(flags & HCI_PROTO_DEFER))
 		goto unlock;
 
-	/* Add connection to indicate the PA sync event */
-	bis = hci_conn_add(hdev, ISO_LINK, BDADDR_ANY,
-			   HCI_ROLE_SLAVE);
+	if (ev->status) {
+		/* Add connection to indicate the failed PA sync event */
+		pa_sync = hci_conn_add(hdev, ISO_LINK, BDADDR_ANY,
+				       HCI_ROLE_SLAVE);
 
-	if (!bis)
-		goto unlock;
+		if (!pa_sync)
+			goto unlock;
 
-	if (ev->status)
-		set_bit(HCI_CONN_PA_SYNC_FAILED, &bis->flags);
-	else
-		set_bit(HCI_CONN_PA_SYNC, &bis->flags);
+		set_bit(HCI_CONN_PA_SYNC_FAILED, &pa_sync->flags);
 
-	/* Notify connection to iso layer */
-	hci_connect_cfm(bis, ev->status);
+		/* Notify iso layer */
+		hci_connect_cfm(pa_sync, ev->status);
+	}
 
 unlock:
 	hci_dev_unlock(hdev);
@@ -7082,7 +7081,7 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 	hci_dev_lock(hdev);
 
 	if (!ev->status) {
-		pa_sync = hci_conn_hash_lookup_pa_sync(hdev, ev->handle);
+		pa_sync = hci_conn_hash_lookup_pa_sync_big_handle(hdev, ev->handle);
 		if (pa_sync)
 			/* Also mark the BIG sync established event on the
 			 * associated PA sync hcon
@@ -7143,15 +7142,42 @@ static void hci_le_big_info_adv_report_evt(struct hci_dev *hdev, void *data,
 	struct hci_evt_le_big_info_adv_report *ev = data;
 	int mask = hdev->link_mode;
 	__u8 flags = 0;
+	struct hci_conn *pa_sync;
 
 	bt_dev_dbg(hdev, "sync_handle 0x%4.4x", le16_to_cpu(ev->sync_handle));
 
 	hci_dev_lock(hdev);
 
 	mask |= hci_proto_connect_ind(hdev, BDADDR_ANY, ISO_LINK, &flags);
-	if (!(mask & HCI_LM_ACCEPT))
+	if (!(mask & HCI_LM_ACCEPT)) {
 		hci_le_pa_term_sync(hdev, ev->sync_handle);
+		goto unlock;
+	}
 
+	if (!(flags & HCI_PROTO_DEFER))
+		goto unlock;
+
+	pa_sync = hci_conn_hash_lookup_pa_sync_handle
+			(hdev,
+			le16_to_cpu(ev->sync_handle));
+
+	if (pa_sync)
+		goto unlock;
+
+	/* Add connection to indicate the PA sync event */
+	pa_sync = hci_conn_add(hdev, ISO_LINK, BDADDR_ANY,
+			       HCI_ROLE_SLAVE);
+
+	if (!pa_sync)
+		goto unlock;
+
+	pa_sync->sync_handle = le16_to_cpu(ev->sync_handle);
+	set_bit(HCI_CONN_PA_SYNC, &pa_sync->flags);
+
+	/* Notify iso layer */
+	hci_connect_cfm(pa_sync, 0x00);
+
+unlock:
 	hci_dev_unlock(hdev);
 }
 
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 4689f94e4da81..9433a273b4fc2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -77,6 +77,7 @@ static struct bt_iso_qos default_qos;
 static bool check_ucast_qos(struct bt_iso_qos *qos);
 static bool check_bcast_qos(struct bt_iso_qos *qos);
 static bool iso_match_sid(struct sock *sk, void *data);
+static bool iso_match_sync_handle(struct sock *sk, void *data);
 static void iso_sock_disconn(struct sock *sk);
 
 /* ---- ISO timers ---- */
@@ -1222,7 +1223,6 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			    test_bit(HCI_CONN_PA_SYNC, &pi->conn->hcon->flags)) {
 				iso_conn_big_sync(sk);
 				sk->sk_state = BT_LISTEN;
-				set_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags);
 			} else {
 				iso_conn_defer_accept(pi->conn->hcon);
 				sk->sk_state = BT_CONFIG;
@@ -1580,6 +1580,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 	struct sock *sk = conn->sk;
 	struct hci_ev_le_big_sync_estabilished *ev = NULL;
 	struct hci_ev_le_pa_sync_established *ev2 = NULL;
+	struct hci_evt_le_big_info_adv_report *ev3 = NULL;
 	struct hci_conn *hcon;
 
 	BT_DBG("conn %p", conn);
@@ -1604,14 +1605,20 @@ static void iso_conn_ready(struct iso_conn *conn)
 				parent = iso_get_sock_listen(&hcon->src,
 							     &hcon->dst,
 							     iso_match_big, ev);
-		} else if (test_bit(HCI_CONN_PA_SYNC, &hcon->flags) ||
-				test_bit(HCI_CONN_PA_SYNC_FAILED, &hcon->flags)) {
+		} else if (test_bit(HCI_CONN_PA_SYNC_FAILED, &hcon->flags)) {
 			ev2 = hci_recv_event_data(hcon->hdev,
 						  HCI_EV_LE_PA_SYNC_ESTABLISHED);
 			if (ev2)
 				parent = iso_get_sock_listen(&hcon->src,
 							     &hcon->dst,
 							     iso_match_sid, ev2);
+		} else if (test_bit(HCI_CONN_PA_SYNC, &hcon->flags)) {
+			ev3 = hci_recv_event_data(hcon->hdev,
+						  HCI_EVT_LE_BIG_INFO_ADV_REPORT);
+			if (ev3)
+				parent = iso_get_sock_listen(&hcon->src,
+							     &hcon->dst,
+							     iso_match_sync_handle, ev3);
 		}
 
 		if (!parent)
@@ -1651,11 +1658,13 @@ static void iso_conn_ready(struct iso_conn *conn)
 			hcon->sync_handle = iso_pi(parent)->sync_handle;
 		}
 
-		if (ev2 && !ev2->status) {
-			iso_pi(sk)->sync_handle = iso_pi(parent)->sync_handle;
+		if (ev3) {
 			iso_pi(sk)->qos = iso_pi(parent)->qos;
+			iso_pi(sk)->qos.bcast.encryption = ev3->encryption;
+			hcon->iso_qos = iso_pi(sk)->qos;
 			iso_pi(sk)->bc_num_bis = iso_pi(parent)->bc_num_bis;
 			memcpy(iso_pi(sk)->bc_bis, iso_pi(parent)->bc_bis, ISO_MAX_NUM_BIS);
+			set_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags);
 		}
 
 		bacpy(&iso_pi(sk)->dst, &hcon->dst);
-- 
2.42.0



