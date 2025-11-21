Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944C434B191;
	Fri, 21 Nov 2025 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731046; cv=none; b=oj4UrJ1ObduAZ56Si4TJB/ajGFDjjp+gx9+jxKTbjUJb3K0mkRlHhAhCaczUvqQOyIWYtXfqSFeOcF0GFfdaybz0bBZSf/aAU0/sK/2+Lmz2I/v/WfkrMxw2lYFqSuTbgIKT/7lHEmf2YV3ODxy4Xl0aog4Ad7SMiX3Nh1PhHvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731046; c=relaxed/simple;
	bh=C23BwULp/AY0I7np2XyFTa2aZQ2MOB4MYqfRlklJFmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT0lWUAS5IzjwrmrDJNBEZDC7P9XKcfa0sPNbgx18NHVSxT801k4bDyS+V/8LEQq14EjMB14o6ZtLkaewQTLdDSfkadWsKxyRCUknYLaI4e1eVrWZksCA0KXCgt6xL6nA3JmP3mPetakkVrD53FoaRXx5sOb0AM5wVlnUeF1qBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSA0NdKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSA0NdKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63DDC4CEF1;
	Fri, 21 Nov 2025 13:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731046;
	bh=C23BwULp/AY0I7np2XyFTa2aZQ2MOB4MYqfRlklJFmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSA0NdKaZnHhxIgYOKYkVebApdH9vO35ACx5iiLqni4SteXSy1xGMFmRe3iuyEMwP
	 90sPD9e9I+2NELtmz4HlNq2lDO9+bdK7weolPyfHbEwGT41lLf+AF2/qAnpAKTbKup
	 LGHygWNIm7l+QUggAb5y2G09eNEOWSwm5/6Qzwjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 071/247] Bluetooth: hci_event: Fix not handling PA Sync Lost event
Date: Fri, 21 Nov 2025 14:10:18 +0100
Message-ID: <20251121130157.148618198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 485e0626e58768f3c53ba61ab9e09d6b60a455f4 ]

This handles PA Sync Lost event which previously was assumed to be
handled with BIG Sync Lost but their lifetime are not the same thus why
there are 2 different events to inform when each sync is lost.

Fixes: b2a5f2e1c127 ("Bluetooth: hci_event: Add support for handling LE BIG Sync Lost event")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  5 ++++
 net/bluetooth/hci_event.c   | 49 ++++++++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index dca650cede3c4..63160cfcf2b22 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2782,6 +2782,11 @@ struct hci_ev_le_per_adv_report {
 	__u8     data[];
 } __packed;
 
+#define HCI_EV_LE_PA_SYNC_LOST		0x10
+struct hci_ev_le_pa_sync_lost {
+	__le16 handle;
+} __packed;
+
 #define LE_PA_DATA_COMPLETE	0x00
 #define LE_PA_DATA_MORE_TO_COME	0x01
 #define LE_PA_DATA_TRUNCATED	0x02
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0380d2f596c97..a9a5d12943fa0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5853,6 +5853,29 @@ static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev, void *data,
 			     le16_to_cpu(ev->supervision_timeout));
 }
 
+static void hci_le_pa_sync_lost_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
+{
+	struct hci_ev_le_pa_sync_lost *ev = data;
+	u16 handle = le16_to_cpu(ev->handle);
+	struct hci_conn *conn;
+
+	bt_dev_dbg(hdev, "sync handle 0x%4.4x", handle);
+
+	hci_dev_lock(hdev);
+
+	/* Delete the pa sync connection */
+	conn = hci_conn_hash_lookup_pa_sync_handle(hdev, handle);
+	if (conn) {
+		clear_bit(HCI_CONN_BIG_SYNC, &conn->flags);
+		clear_bit(HCI_CONN_PA_SYNC, &conn->flags);
+		hci_disconn_cfm(conn, HCI_ERROR_REMOTE_USER_TERM);
+		hci_conn_del(conn);
+	}
+
+	hci_dev_unlock(hdev);
+}
+
 static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, void *data,
 				    struct sk_buff *skb)
 {
@@ -7056,29 +7079,24 @@ static void hci_le_big_sync_lost_evt(struct hci_dev *hdev, void *data,
 				     struct sk_buff *skb)
 {
 	struct hci_evt_le_big_sync_lost *ev = data;
-	struct hci_conn *bis, *conn;
-	bool mgmt_conn;
+	struct hci_conn *bis;
+	bool mgmt_conn = false;
 
 	bt_dev_dbg(hdev, "big handle 0x%2.2x", ev->handle);
 
 	hci_dev_lock(hdev);
 
-	/* Delete the pa sync connection */
-	bis = hci_conn_hash_lookup_pa_sync_big_handle(hdev, ev->handle);
-	if (bis) {
-		conn = hci_conn_hash_lookup_pa_sync_handle(hdev,
-							   bis->sync_handle);
-		if (conn)
-			hci_conn_del(conn);
-	}
-
 	/* Delete each bis connection */
 	while ((bis = hci_conn_hash_lookup_big_state(hdev, ev->handle,
 						     BT_CONNECTED,
 						     HCI_ROLE_SLAVE))) {
-		mgmt_conn = test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &bis->flags);
-		mgmt_device_disconnected(hdev, &bis->dst, bis->type, bis->dst_type,
-					 ev->reason, mgmt_conn);
+		if (!mgmt_conn) {
+			mgmt_conn = test_and_clear_bit(HCI_CONN_MGMT_CONNECTED,
+						       &bis->flags);
+			mgmt_device_disconnected(hdev, &bis->dst, bis->type,
+						 bis->dst_type, ev->reason,
+						 mgmt_conn);
+		}
 
 		clear_bit(HCI_CONN_BIG_SYNC, &bis->flags);
 		hci_disconn_cfm(bis, ev->reason);
@@ -7192,6 +7210,9 @@ static const struct hci_le_ev {
 				 hci_le_per_adv_report_evt,
 				 sizeof(struct hci_ev_le_per_adv_report),
 				 HCI_MAX_EVENT_SIZE),
+	/* [0x10 = HCI_EV_LE_PA_SYNC_LOST] */
+	HCI_LE_EV(HCI_EV_LE_PA_SYNC_LOST, hci_le_pa_sync_lost_evt,
+		  sizeof(struct hci_ev_le_pa_sync_lost)),
 	/* [0x12 = HCI_EV_LE_EXT_ADV_SET_TERM] */
 	HCI_LE_EV(HCI_EV_LE_EXT_ADV_SET_TERM, hci_le_ext_adv_term_evt,
 		  sizeof(struct hci_evt_le_ext_adv_set_term)),
-- 
2.51.0



