Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7652C46AEFE;
	Tue, 16 Jun 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626659; cv=none; b=QD/51Xj7rITyJ1IurWeHCI6aU2fpsb+jV0VJi0n4or1bqYGRulrgIyJesTR1u/ssOjOm7WY1WjlXmxGlcvwYZuOVJjnFQlM/ppeTbZGxDfhSWnq0qxzA1QZ8STWvlmrKlbrJrZrLwpE2nNbyfd1kzfDxzR5iIL0zdWR0+CvKdW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626659; c=relaxed/simple;
	bh=VrAFcFMlgmXLCKoHjpRVy5BzG8xKyOGxw0LiKC0XjgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsnEwRFeIxTjxBmI4KL1TP9E1x0OIqhJ1CpZukAPxA/R9JSXlAiauLCFUHBieVb/ZPmbyBHOopYpKENXJAUscRupmLsOer4emnTk1ml2o3c9zJU3wuxOAdNj5eWD8aovrJ/bezUHu1rlJ4Ed8V3pCPVoHV3xJsqjZYWBasTWCV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDaB7v+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDaB7v+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5F21F00A3A;
	Tue, 16 Jun 2026 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626658;
	bh=EPb0JqzxVhZ2ryuscdxEULEyEDy4X3K1pcyDIcBaQmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDaB7v+YBo/1xuo9kT9+jNIHLKoxpD3WJy/IHb1J8AQXkAMQhedYrKccK9sF43RsP
	 Y8OMq2SWnAc8rnkPoQ1dQBTjNRC0pdlaYT1U5kGDPSUPosNILRc79RWwcO3CoNFpqM
	 9KHqU5zf+KSUnwnntcIGUEveIDUbnCDphAk4G/0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/261] Bluetooth: ISO: Fix not using bc_sid as advertisement SID
Date: Tue, 16 Jun 2026 20:28:02 +0530
Message-ID: <20260616145047.144618928@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5842c01a9ed1d515c8ba2d6d3733eac78ace89c1 ]

Currently bc_sid is being ignore when acting as Broadcast Source role,
so this fix it by passing the bc_sid and then use it when programming
the PA:

< HCI Command: LE Set Exte.. (0x08|0x0036) plen 25
        Handle: 0x01
        Properties: 0x0000
        Min advertising interval: 140.000 msec (0x00e0)
        Max advertising interval: 140.000 msec (0x00e0)
        Channel map: 37, 38, 39 (0x07)
        Own address type: Random (0x01)
        Peer address type: Public (0x00)
        Peer address: 00:00:00:00:00:00 (OUI 00-00-00)
        Filter policy: Allow Scan Request from Any, Allow Connect Request from Any (0x00)
        TX power: Host has no preference (0x7f)
        Primary PHY: LE 1M (0x01)
        Secondary max skip: 0x00
        Secondary PHY: LE 2M (0x02)
        SID: 0x01
        Scan request notifications: Disabled (0x00)

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 9ca7053d6215 ("Bluetooth: ISO: Fix data-race on iso_pi fields in hci_get_route calls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  9 ++++++---
 include/net/bluetooth/hci_sync.h |  4 ++--
 net/bluetooth/hci_conn.c         | 31 ++++++++++++++++++++++++-------
 net/bluetooth/hci_core.c         | 16 +++++++++++++++-
 net/bluetooth/hci_sync.c         | 20 +++++++++++++++++---
 net/bluetooth/iso.c              | 12 ++++++++----
 6 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ba5d176069a692..a0c84a83f25eb1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -244,6 +244,7 @@ struct adv_info {
 	__u8	mesh;
 	__u8	instance;
 	__u8	handle;
+	__u8	sid;
 	__u32	flags;
 	__u16	timeout;
 	__u16	remaining_time;
@@ -1576,13 +1577,14 @@ struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
 				 u16 timeout);
 struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 			      __u8 dst_type, struct bt_iso_qos *qos);
-struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
+struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 			      struct bt_iso_qos *qos,
 			      __u8 base_len, __u8 *base);
 struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 				 __u8 dst_type, struct bt_iso_qos *qos);
 struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
-				 __u8 dst_type, struct bt_iso_qos *qos,
+				 __u8 dst_type, __u8 sid,
+				 struct bt_iso_qos *qos,
 				 __u8 data_len, __u8 *data);
 struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
 		       __u8 dst_type, __u8 sid, struct bt_iso_qos *qos);
@@ -1846,6 +1848,7 @@ int hci_remove_remote_oob_data(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 void hci_adv_instances_clear(struct hci_dev *hdev);
 struct adv_info *hci_find_adv_instance(struct hci_dev *hdev, u8 instance);
+struct adv_info *hci_find_adv_sid(struct hci_dev *hdev, u8 sid);
 struct adv_info *hci_get_next_instance(struct hci_dev *hdev, u8 instance);
 struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 				      u32 flags, u16 adv_data_len, u8 *adv_data,
@@ -1853,7 +1856,7 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 				      u16 timeout, u16 duration, s8 tx_power,
 				      u32 min_interval, u32 max_interval,
 				      u8 mesh_handle);
-struct adv_info *hci_add_per_instance(struct hci_dev *hdev, u8 instance,
+struct adv_info *hci_add_per_instance(struct hci_dev *hdev, u8 instance, u8 sid,
 				      u32 flags, u8 data_len, u8 *data,
 				      u32 min_interval, u32 max_interval);
 int hci_set_adv_instance_data(struct hci_dev *hdev, u8 instance,
diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 17e5112f7840e0..4d3132a50ef058 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -115,8 +115,8 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance);
 int hci_enable_advertising_sync(struct hci_dev *hdev);
 int hci_enable_advertising(struct hci_dev *hdev);
 
-int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
-			   u8 *data, u32 flags, u16 min_interval,
+int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 sid,
+			   u8 data_len, u8 *data, u32 flags, u16 min_interval,
 			   u16 max_interval, u16 sync_interval);
 
 int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f89af453cb3b18..d34c66b92fbc1b 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1494,8 +1494,8 @@ static int qos_set_bis(struct hci_dev *hdev, struct bt_iso_qos *qos)
 
 /* This function requires the caller holds hdev->lock */
 static struct hci_conn *hci_add_bis(struct hci_dev *hdev, bdaddr_t *dst,
-				    struct bt_iso_qos *qos, __u8 base_len,
-				    __u8 *base)
+				    __u8 sid, struct bt_iso_qos *qos,
+				    __u8 base_len, __u8 *base)
 {
 	struct hci_conn *conn;
 	int err;
@@ -1536,6 +1536,7 @@ static struct hci_conn *hci_add_bis(struct hci_dev *hdev, bdaddr_t *dst,
 		return conn;
 
 	conn->state = BT_CONNECT;
+	conn->sid = sid;
 
 	hci_conn_hold(conn);
 	return conn;
@@ -2063,7 +2064,8 @@ static int create_big_sync(struct hci_dev *hdev, void *data)
 	if (qos->bcast.bis)
 		sync_interval = interval * 4;
 
-	err = hci_start_per_adv_sync(hdev, qos->bcast.bis, conn->le_per_adv_data_len,
+	err = hci_start_per_adv_sync(hdev, qos->bcast.bis, conn->sid,
+				     conn->le_per_adv_data_len,
 				     conn->le_per_adv_data, flags, interval,
 				     interval, sync_interval);
 	if (err)
@@ -2148,7 +2150,7 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
 	hci_conn_put(conn);
 }
 
-struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
+struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 			      struct bt_iso_qos *qos,
 			      __u8 base_len, __u8 *base)
 {
@@ -2170,7 +2172,7 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
 						   base, base_len);
 
 	/* We need hci_conn object using the BDADDR_ANY as dst */
-	conn = hci_add_bis(hdev, dst, qos, base_len, eir);
+	conn = hci_add_bis(hdev, dst, sid, qos, base_len, eir);
 	if (IS_ERR(conn))
 		return conn;
 
@@ -2221,20 +2223,35 @@ static void bis_mark_per_adv(struct hci_conn *conn, void *data)
 }
 
 struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
-				 __u8 dst_type, struct bt_iso_qos *qos,
+				 __u8 dst_type, __u8 sid,
+				 struct bt_iso_qos *qos,
 				 __u8 base_len, __u8 *base)
 {
 	struct hci_conn *conn;
 	int err;
 	struct iso_list_data data;
 
-	conn = hci_bind_bis(hdev, dst, qos, base_len, base);
+	conn = hci_bind_bis(hdev, dst, sid, qos, base_len, base);
 	if (IS_ERR(conn))
 		return conn;
 
 	if (conn->state == BT_CONNECTED)
 		return conn;
 
+	/* Check if SID needs to be allocated then search for the first
+	 * available.
+	 */
+	if (conn->sid == HCI_SID_INVALID) {
+		u8 sid;
+
+		for (sid = 0; sid <= 0x0f; sid++) {
+			if (!hci_find_adv_sid(hdev, sid)) {
+				conn->sid = sid;
+				break;
+			}
+		}
+	}
+
 	data.big = qos->bcast.big;
 	data.bis = qos->bcast.bis;
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 677f51edb27752..e96ccdd7ef15e7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1602,6 +1602,19 @@ struct adv_info *hci_find_adv_instance(struct hci_dev *hdev, u8 instance)
 	return NULL;
 }
 
+/* This function requires the caller holds hdev->lock */
+struct adv_info *hci_find_adv_sid(struct hci_dev *hdev, u8 sid)
+{
+	struct adv_info *adv;
+
+	list_for_each_entry(adv, &hdev->adv_instances, list) {
+		if (adv->sid == sid)
+			return adv;
+	}
+
+	return NULL;
+}
+
 /* This function requires the caller holds hdev->lock */
 struct adv_info *hci_get_next_instance(struct hci_dev *hdev, u8 instance)
 {
@@ -1754,7 +1767,7 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 }
 
 /* This function requires the caller holds hdev->lock */
-struct adv_info *hci_add_per_instance(struct hci_dev *hdev, u8 instance,
+struct adv_info *hci_add_per_instance(struct hci_dev *hdev, u8 instance, u8 sid,
 				      u32 flags, u8 data_len, u8 *data,
 				      u32 min_interval, u32 max_interval)
 {
@@ -1766,6 +1779,7 @@ struct adv_info *hci_add_per_instance(struct hci_dev *hdev, u8 instance,
 	if (IS_ERR(adv))
 		return adv;
 
+	adv->sid = sid;
 	adv->periodic = true;
 	adv->per_adv_data_len = data_len;
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 535fd7de9b1aec..fc9977c8c42705 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1393,10 +1393,12 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 		hci_cpu_to_le24(adv->min_interval, cp.min_interval);
 		hci_cpu_to_le24(adv->max_interval, cp.max_interval);
 		cp.tx_power = adv->tx_power;
+		cp.sid = adv->sid;
 	} else {
 		hci_cpu_to_le24(hdev->le_adv_min_interval, cp.min_interval);
 		hci_cpu_to_le24(hdev->le_adv_max_interval, cp.max_interval);
 		cp.tx_power = HCI_ADV_TX_POWER_NO_PREFERENCE;
+		cp.sid = 0x00;
 	}
 
 	secondary_adv = (flags & MGMT_ADV_FLAG_SEC_MASK);
@@ -1730,8 +1732,8 @@ static int hci_adv_bcast_annoucement(struct hci_dev *hdev, struct adv_info *adv)
 	return hci_update_adv_data_sync(hdev, adv->instance);
 }
 
-int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
-			   u8 *data, u32 flags, u16 min_interval,
+int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 sid,
+			   u8 data_len, u8 *data, u32 flags, u16 min_interval,
 			   u16 max_interval, u16 sync_interval)
 {
 	struct adv_info *adv = NULL;
@@ -1743,6 +1745,18 @@ int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
 	if (instance) {
 		adv = hci_find_adv_instance(hdev, instance);
 		if (adv) {
+			if (sid != HCI_SID_INVALID && adv->sid != sid) {
+				/* If the SID don't match attempt to find by
+				 * SID.
+				 */
+				adv = hci_find_adv_sid(hdev, sid);
+				if (!adv) {
+					bt_dev_err(hdev,
+						   "Unable to find adv_info");
+					return -EINVAL;
+				}
+			}
+
 			/* Turn it into periodic advertising */
 			adv->periodic = true;
 			adv->per_adv_data_len = data_len;
@@ -1751,7 +1765,7 @@ int hci_start_per_adv_sync(struct hci_dev *hdev, u8 instance, u8 data_len,
 			adv->flags = flags;
 		} else if (!adv) {
 			/* Create an instance if that could not be found */
-			adv = hci_add_per_instance(hdev, instance, flags,
+			adv = hci_add_per_instance(hdev, instance, sid, flags,
 						   data_len, data,
 						   sync_interval,
 						   sync_interval);
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 935e230484b78c..f9aa59c7ac0080 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -338,7 +338,7 @@ static int iso_connect_bis(struct sock *sk)
 	struct hci_dev  *hdev;
 	int err;
 
-	BT_DBG("%pMR", &iso_pi(sk)->src);
+	BT_DBG("%pMR (SID 0x%2.2x)", &iso_pi(sk)->src, iso_pi(sk)->bc_sid);
 
 	hdev = hci_get_route(&iso_pi(sk)->dst, &iso_pi(sk)->src,
 			     iso_pi(sk)->src_type);
@@ -367,7 +367,7 @@ static int iso_connect_bis(struct sock *sk)
 
 	/* Just bind if DEFER_SETUP has been set */
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
-		hcon = hci_bind_bis(hdev, &iso_pi(sk)->dst,
+		hcon = hci_bind_bis(hdev, &iso_pi(sk)->dst, iso_pi(sk)->bc_sid,
 				    &iso_pi(sk)->qos, iso_pi(sk)->base_len,
 				    iso_pi(sk)->base);
 		if (IS_ERR(hcon)) {
@@ -377,12 +377,16 @@ static int iso_connect_bis(struct sock *sk)
 	} else {
 		hcon = hci_connect_bis(hdev, &iso_pi(sk)->dst,
 				       le_addr_type(iso_pi(sk)->dst_type),
-				       &iso_pi(sk)->qos, iso_pi(sk)->base_len,
-				       iso_pi(sk)->base);
+				       iso_pi(sk)->bc_sid, &iso_pi(sk)->qos,
+				       iso_pi(sk)->base_len, iso_pi(sk)->base);
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto unlock;
 		}
+
+		/* Update SID if it was not set */
+		if (iso_pi(sk)->bc_sid == HCI_SID_INVALID)
+			iso_pi(sk)->bc_sid = hcon->sid;
 	}
 
 	conn = iso_conn_add(hcon);
-- 
2.53.0



