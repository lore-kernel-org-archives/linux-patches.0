Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DCF4ED1B4;
	Tue, 13 Oct 2026 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893257; cv=none; b=eydBktKivCAjDnFFp0+DKhk2CJeZkb9iwZ9Ym2EsFaq0+TFyH2Yyj+58pOBaORqlEHRAV1sC77laY9EMX5J1cUlPR1AnBb2W62Z+l8rXJR7OKBjVyaiXX+LL5i6S+SCytoljSAmeuXprzEjVsF2/xgkXcAoRrtfJD2Y2lbgpVeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893257; c=relaxed/simple;
	bh=RnWnv3+8Uh2K3JhLD92K0G6yEq8iHR7UpcajEHrpaNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AshkqIYJTGkFLHe5cHrzDIKPgDriNfMT6jssz6kYf3UBy4utrMBEoh5ZmF3CEt07jRtS56EWJD5gvOSDxSIBMn10yxq7OCC2baAAfl5f3c9UHpuGG5FXi/+NiakGcvY0ZUcwRoiRBytXN7EH2q2q68zvF8b4JVodL4DfpifXHc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xty62kRD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xty62kRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BEA1F00893;
	Tue, 13 Oct 2026 12:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893255;
	bh=MQ1L695MZTHz1mhvvq9ZSjPKR3n86Qnsr1vY26eWeiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xty62kRDITyniK2E0hHcI87FJt+381RnYnYRxF/Ci4Q8jkLO3t5yVvHsQBFYbinH1
	 Uac4F2qBlF+ySSCMgD81GmMeu3Afxk4HvLDhwrhldl3US8q2CE/ZAyFaAn4Fygtcax
	 GQ2bTsKbAp2iJXmEJi3b32eZ2urXZJRSe6Ct115s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/621] Bluetooth: hci_event: move wake reason storage into validated event handlers
Date: Tue, 13 Oct 2026 13:32:41 +0200
Message-ID: <20261013112924.802697209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleh Konko <security@1seal.org>

[ Upstream commit 2b2bf47cd75518c36fa2d41380e4a40641cc89cd ]

hci_store_wake_reason() is called from hci_event_packet() immediately
after stripping the HCI event header but before hci_event_func()
enforces the per-event minimum payload length from hci_ev_table.
This means a short HCI event frame can reach bacpy() before any bounds
check runs.

Rather than duplicating skb parsing and per-event length checks inside
hci_store_wake_reason(), move wake-address storage into the individual
event handlers after their existing event-length validation has
succeeded. Convert hci_store_wake_reason() into a small helper that only
stores an already-validated bdaddr while the caller holds hci_dev_lock().
Use the same helper after hci_event_func() with a NULL address to
preserve the existing unexpected-wake fallback semantics when no
validated event handler records a wake address.

Annotate the helper with __must_hold(&hdev->lock) and add
lockdep_assert_held(&hdev->lock) so future call paths keep the lock
contract explicit.

Call the helper from hci_conn_request_evt(), hci_conn_complete_evt(),
hci_sync_conn_complete_evt(), le_conn_complete_evt(),
hci_le_adv_report_evt(), hci_le_ext_adv_report_evt(),
hci_le_direct_adv_report_evt(), hci_le_pa_sync_established_evt(), and
hci_le_past_received_evt().

Fixes: 2f20216c1d6f ("Bluetooth: Emit controller suspend and resume events")
Cc: stable@vger.kernel.org
Signed-off-by: Oleh Konko <security@1seal.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 94 +++++++++++++++------------------------
 1 file changed, 35 insertions(+), 59 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 031ee997bb92f..c42f480e4f6d3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -80,6 +80,10 @@ static void *hci_le_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
 	return data;
 }
 
+static void hci_store_wake_reason(struct hci_dev *hdev,
+				  const bdaddr_t *bdaddr, u8 addr_type)
+	__must_hold(&hdev->lock);
+
 static u8 hci_cc_inquiry_cancel(struct hci_dev *hdev, void *data,
 				struct sk_buff *skb)
 {
@@ -3099,6 +3103,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, BDADDR_BREDR);
 
 	/* Check for existing connection:
 	 *
@@ -3261,6 +3266,10 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "bdaddr %pMR type 0x%x", &ev->bdaddr, ev->link_type);
 
+	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, BDADDR_BREDR);
+	hci_dev_unlock(hdev);
+
 	/* Reject incoming connection from device with same BD ADDR against
 	 * CVE-2020-26555
 	 */
@@ -4963,6 +4972,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, BDADDR_BREDR);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
 	if (!conn) {
@@ -5664,6 +5674,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	u8 addr_type;
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, bdaddr, bdaddr_type);
 
 	/* Advertising stops when a connection is created. On a failed
 	 * connection it keeps running, so leave the state bit alone.
@@ -5976,6 +5987,7 @@ static void hci_le_past_received_evt(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, ev->bdaddr_type);
 
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
@@ -6374,6 +6386,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
 					info->length + 1))
 			break;
 
+		hci_store_wake_reason(hdev, &info->bdaddr, info->bdaddr_type);
+
 		if (info->length <= max_adv_len(hdev)) {
 			rssi = info->data[info->length];
 			process_adv_report(hdev, info->type, &info->bdaddr,
@@ -6462,6 +6476,8 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
 					info->length))
 			break;
 
+		hci_store_wake_reason(hdev, &info->bdaddr, info->bdaddr_type);
+
 		evt_type = __le16_to_cpu(info->type) & LE_EXT_ADV_EVT_TYPE_MASK;
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
 
@@ -6507,6 +6523,7 @@ static void hci_le_pa_sync_established_evt(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, ev->bdaddr_type);
 
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
@@ -6801,6 +6818,8 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev, void *data,
 	for (i = 0; i < ev->num; i++) {
 		struct hci_ev_le_direct_adv_info *info = &ev->info[i];
 
+		hci_store_wake_reason(hdev, &info->bdaddr, info->bdaddr_type);
+
 		process_adv_report(hdev, info->type, &info->bdaddr,
 				   info->bdaddr_type, &info->direct_addr,
 				   info->direct_addr_type, HCI_ADV_PHY_1M, 0,
@@ -7430,73 +7449,29 @@ static bool hci_get_cmd_complete(struct hci_dev *hdev, u16 opcode,
 	return true;
 }
 
-static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
-				  struct sk_buff *skb)
+static void hci_store_wake_reason(struct hci_dev *hdev,
+				  const bdaddr_t *bdaddr, u8 addr_type)
+	__must_hold(&hdev->lock)
 {
-	struct hci_ev_le_advertising_info *adv;
-	struct hci_ev_le_direct_adv_info *direct_adv;
-	struct hci_ev_le_ext_adv_info *ext_adv;
-	const struct hci_ev_conn_complete *conn_complete = (void *)skb->data;
-	const struct hci_ev_conn_request *conn_request = (void *)skb->data;
-
-	hci_dev_lock(hdev);
+	lockdep_assert_held(&hdev->lock);
 
 	/* If we are currently suspended and this is the first BT event seen,
 	 * save the wake reason associated with the event.
 	 */
 	if (!hdev->suspended || hdev->wake_reason)
-		goto unlock;
+		return;
+
+	if (!bdaddr) {
+		hdev->wake_reason = MGMT_WAKE_REASON_UNEXPECTED;
+		return;
+	}
 
 	/* Default to remote wake. Values for wake_reason are documented in the
 	 * Bluez mgmt api docs.
 	 */
 	hdev->wake_reason = MGMT_WAKE_REASON_REMOTE_WAKE;
-
-	/* Once configured for remote wakeup, we should only wake up for
-	 * reconnections. It's useful to see which device is waking us up so
-	 * keep track of the bdaddr of the connection event that woke us up.
-	 */
-	if (event == HCI_EV_CONN_REQUEST) {
-		bacpy(&hdev->wake_addr, &conn_request->bdaddr);
-		hdev->wake_addr_type = BDADDR_BREDR;
-	} else if (event == HCI_EV_CONN_COMPLETE) {
-		bacpy(&hdev->wake_addr, &conn_complete->bdaddr);
-		hdev->wake_addr_type = BDADDR_BREDR;
-	} else if (event == HCI_EV_LE_META) {
-		struct hci_ev_le_meta *le_ev = (void *)skb->data;
-		u8 subevent = le_ev->subevent;
-		u8 *ptr = &skb->data[sizeof(*le_ev)];
-		u8 num_reports = *ptr;
-
-		if ((subevent == HCI_EV_LE_ADVERTISING_REPORT ||
-		     subevent == HCI_EV_LE_DIRECT_ADV_REPORT ||
-		     subevent == HCI_EV_LE_EXT_ADV_REPORT) &&
-		    num_reports) {
-			adv = (void *)(ptr + 1);
-			direct_adv = (void *)(ptr + 1);
-			ext_adv = (void *)(ptr + 1);
-
-			switch (subevent) {
-			case HCI_EV_LE_ADVERTISING_REPORT:
-				bacpy(&hdev->wake_addr, &adv->bdaddr);
-				hdev->wake_addr_type = adv->bdaddr_type;
-				break;
-			case HCI_EV_LE_DIRECT_ADV_REPORT:
-				bacpy(&hdev->wake_addr, &direct_adv->bdaddr);
-				hdev->wake_addr_type = direct_adv->bdaddr_type;
-				break;
-			case HCI_EV_LE_EXT_ADV_REPORT:
-				bacpy(&hdev->wake_addr, &ext_adv->bdaddr);
-				hdev->wake_addr_type = ext_adv->bdaddr_type;
-				break;
-			}
-		}
-	} else {
-		hdev->wake_reason = MGMT_WAKE_REASON_UNEXPECTED;
-	}
-
-unlock:
-	hci_dev_unlock(hdev);
+	bacpy(&hdev->wake_addr, bdaddr);
+	hdev->wake_addr_type = addr_type;
 }
 
 #define HCI_EV_VL(_op, _func, _min_len, _max_len) \
@@ -7743,14 +7718,15 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 
 	skb_pull(skb, HCI_EVENT_HDR_SIZE);
 
-	/* Store wake reason if we're suspended */
-	hci_store_wake_reason(hdev, event, skb);
-
 	bt_dev_dbg(hdev, "event 0x%2.2x", event);
 
 	hci_event_func(hdev, event, skb, &opcode, &status, &req_complete,
 		       &req_complete_skb);
 
+	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, NULL, 0);
+	hci_dev_unlock(hdev);
+
 	if (req_complete) {
 		req_complete(hdev, status, opcode);
 	} else if (req_complete_skb) {
-- 
2.53.0



