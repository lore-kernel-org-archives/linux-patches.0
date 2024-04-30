Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D63812C48B;
	Tue, 30 Apr 2024 10:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474196; cv=none; b=J4UYJ3RsYrjqwa+W55iW1sr7k35pIo1hzKU/5T3t7ZmJftCOaT8zmgKsnRCSH3O6U4AletDBrK1REFAOCkjUSNQwtpYbZ6gL9g6feDtwUPlB188XgK6yOusbtTRFU5P9Fj5Z46TdNu/EeFtLGVc2NF9D6AeZlKu1MnV7qczIp7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474196; c=relaxed/simple;
	bh=iANw7G25jHe9vbT7Wnh/IPTiHGPP1TLEm/+jN/IJcYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFqkt/UTrRidZjY0Z0h3aY32YSGwcli/QkkA4uxH7AxRMD/XwbkMzEQzMKocV/tUaMRxnengxWbxadanEX+v30/qXyBdT+O9Cd3hCfJD5SdHFdn/5csCu/rUCQFc9E7i4utNAlMp8aJtFgzqlBhagklBogrJjhG9akyoISqQbKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTNjF1xO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTNjF1xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC5C2BBFC;
	Tue, 30 Apr 2024 10:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474195;
	bh=iANw7G25jHe9vbT7Wnh/IPTiHGPP1TLEm/+jN/IJcYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTNjF1xOJD+dpLRCOulD2VJOjClQANFPhp9NxfJ63HgcNqki7YB08hInySCwc5wuY
	 OvhM1rZXNviSaD3Gk2Le95sBc2eA+qx6w2wYCaxekDByUFmcewIWlA9gNPdJ3aPiS8
	 Er0tkUchCboPL6iP5LtIAYMPsss0lLb0NxNOmxJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 085/228] Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync
Date: Tue, 30 Apr 2024 12:37:43 +0200
Message-ID: <20240430103106.255827169@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 2e7ed5f5e69b6fe93dd3c6b651d041e0a7a456d1 ]

The extended advertising reports do report the PHYs so this store then
in hci_conn so it can be later used in hci_le_ext_create_conn_sync to
narrow the PHYs to be scanned since the controller will also perform a
scan having a smaller set of PHYs shall reduce the time it takes to
find and connect peers.

Fixes: 288c90224eec ("Bluetooth: Enable all supported LE PHY by default")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  4 +++-
 net/bluetooth/hci_conn.c         |  6 ++++--
 net/bluetooth/hci_event.c        | 20 ++++++++++++--------
 net/bluetooth/hci_sync.c         |  9 ++++++---
 net/bluetooth/l2cap_core.c       |  2 +-
 5 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 1da71254caf61..b6fb104ea1976 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -738,6 +738,8 @@ struct hci_conn {
 	__u8		le_per_adv_data[HCI_MAX_PER_AD_TOT_LEN];
 	__u16		le_per_adv_data_len;
 	__u16		le_per_adv_data_offset;
+	__u8		le_adv_phy;
+	__u8		le_adv_sec_phy;
 	__u8		le_tx_phy;
 	__u8		le_rx_phy;
 	__s8		rssi;
@@ -1512,7 +1514,7 @@ struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 				     enum conn_reasons conn_reason);
 struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 				u8 dst_type, bool dst_resolved, u8 sec_level,
-				u16 conn_timeout, u8 role);
+				u16 conn_timeout, u8 role, u8 phy, u8 sec_phy);
 void hci_connect_le_scan_cleanup(struct hci_conn *conn, u8 status);
 struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 				 u8 sec_level, u8 auth_type,
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3a66d357b9323..18f97b2288699 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1263,7 +1263,7 @@ u8 hci_conn_set_handle(struct hci_conn *conn, u16 handle)
 
 struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 				u8 dst_type, bool dst_resolved, u8 sec_level,
-				u16 conn_timeout, u8 role)
+				u16 conn_timeout, u8 role, u8 phy, u8 sec_phy)
 {
 	struct hci_conn *conn;
 	struct smp_irk *irk;
@@ -1326,6 +1326,8 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	conn->dst_type = dst_type;
 	conn->sec_level = BT_SECURITY_LOW;
 	conn->conn_timeout = conn_timeout;
+	conn->le_adv_phy = phy;
+	conn->le_adv_sec_phy = sec_phy;
 
 	err = hci_connect_le_sync(hdev, conn);
 	if (err) {
@@ -2253,7 +2255,7 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 		le = hci_connect_le(hdev, dst, dst_type, false,
 				    BT_SECURITY_LOW,
 				    HCI_LE_CONN_TIMEOUT,
-				    HCI_ROLE_SLAVE);
+				    HCI_ROLE_SLAVE, 0, 0);
 	else
 		le = hci_connect_le_scan(hdev, dst, dst_type,
 					 BT_SECURITY_LOW,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f5d77c8089d81..9450df4ee5b9b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6182,7 +6182,7 @@ static void hci_le_conn_update_complete_evt(struct hci_dev *hdev, void *data,
 static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 					      bdaddr_t *addr,
 					      u8 addr_type, bool addr_resolved,
-					      u8 adv_type)
+					      u8 adv_type, u8 phy, u8 sec_phy)
 {
 	struct hci_conn *conn;
 	struct hci_conn_params *params;
@@ -6237,7 +6237,7 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 
 	conn = hci_connect_le(hdev, addr, addr_type, addr_resolved,
 			      BT_SECURITY_LOW, hdev->def_le_autoconnect_timeout,
-			      HCI_ROLE_MASTER);
+			      HCI_ROLE_MASTER, phy, sec_phy);
 	if (!IS_ERR(conn)) {
 		/* If HCI_AUTO_CONN_EXPLICIT is set, conn is already owned
 		 * by higher layer that tried to connect, if no then
@@ -6272,8 +6272,9 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 
 static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 			       u8 bdaddr_type, bdaddr_t *direct_addr,
-			       u8 direct_addr_type, s8 rssi, u8 *data, u8 len,
-			       bool ext_adv, bool ctl_time, u64 instant)
+			       u8 direct_addr_type, u8 phy, u8 sec_phy, s8 rssi,
+			       u8 *data, u8 len, bool ext_adv, bool ctl_time,
+			       u64 instant)
 {
 	struct discovery_state *d = &hdev->discovery;
 	struct smp_irk *irk;
@@ -6361,7 +6362,7 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 	 * for advertising reports) and is already verified to be RPA above.
 	 */
 	conn = check_pending_le_conn(hdev, bdaddr, bdaddr_type, bdaddr_resolved,
-				     type);
+				     type, phy, sec_phy);
 	if (!ext_adv && conn && type == LE_ADV_IND &&
 	    len <= max_adv_len(hdev)) {
 		/* Store report for later inclusion by
@@ -6507,7 +6508,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
 		if (info->length <= max_adv_len(hdev)) {
 			rssi = info->data[info->length];
 			process_adv_report(hdev, info->type, &info->bdaddr,
-					   info->bdaddr_type, NULL, 0, rssi,
+					   info->bdaddr_type, NULL, 0,
+					   HCI_ADV_PHY_1M, 0, rssi,
 					   info->data, info->length, false,
 					   false, instant);
 		} else {
@@ -6592,6 +6594,8 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
 		if (legacy_evt_type != LE_ADV_INVALID) {
 			process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
 					   info->bdaddr_type, NULL, 0,
+					   info->primary_phy,
+					   info->secondary_phy,
 					   info->rssi, info->data, info->length,
 					   !(evt_type & LE_EXT_ADV_LEGACY_PDU),
 					   false, instant);
@@ -6874,8 +6878,8 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev, void *data,
 
 		process_adv_report(hdev, info->type, &info->bdaddr,
 				   info->bdaddr_type, &info->direct_addr,
-				   info->direct_addr_type, info->rssi, NULL, 0,
-				   false, false, instant);
+				   info->direct_addr_type, HCI_ADV_PHY_1M, 0,
+				   info->rssi, NULL, 0, false, false, instant);
 	}
 
 	hci_dev_unlock(hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ed7db30ac0e0d..84fe44c796f4f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6315,7 +6315,8 @@ static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
 
 	plen = sizeof(*cp);
 
-	if (scan_1m(hdev)) {
+	if (scan_1m(hdev) && (conn->le_adv_phy == HCI_ADV_PHY_1M ||
+			      conn->le_adv_sec_phy == HCI_ADV_PHY_1M)) {
 		cp->phys |= LE_SCAN_PHY_1M;
 		set_ext_conn_params(conn, p);
 
@@ -6323,7 +6324,8 @@ static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
 		plen += sizeof(*p);
 	}
 
-	if (scan_2m(hdev)) {
+	if (scan_2m(hdev) && (conn->le_adv_phy == HCI_ADV_PHY_2M ||
+			      conn->le_adv_sec_phy == HCI_ADV_PHY_2M)) {
 		cp->phys |= LE_SCAN_PHY_2M;
 		set_ext_conn_params(conn, p);
 
@@ -6331,7 +6333,8 @@ static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
 		plen += sizeof(*p);
 	}
 
-	if (scan_coded(hdev)) {
+	if (scan_coded(hdev) && (conn->le_adv_phy == HCI_ADV_PHY_CODED ||
+				 conn->le_adv_sec_phy == HCI_ADV_PHY_CODED)) {
 		cp->phys |= LE_SCAN_PHY_CODED;
 		set_ext_conn_params(conn, p);
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index dc08974087936..84fc70862d78a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7018,7 +7018,7 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		if (hci_dev_test_flag(hdev, HCI_ADVERTISING))
 			hcon = hci_connect_le(hdev, dst, dst_type, false,
 					      chan->sec_level, timeout,
-					      HCI_ROLE_SLAVE);
+					      HCI_ROLE_SLAVE, 0, 0);
 		else
 			hcon = hci_connect_le_scan(hdev, dst, dst_type,
 						   chan->sec_level, timeout,
-- 
2.43.0



