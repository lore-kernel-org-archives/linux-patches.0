Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0C224677D;
	Wed, 25 Feb 2026 01:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983228; cv=none; b=DNfrFD0KKCENplMO3UgvrT4vruIL0jvh0+QA1lkUAuW2Pc8DcGPBFAotBmMs0V/RByVQ6BZ07dYmnEYA10pI6k8g8RZjy4BdZuIxNMC17cetNBdZCrpicqs9ARnN01G00nc4BRktN5dlglOw7ToXPiyGdIRfKrus511ZbwtJb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983228; c=relaxed/simple;
	bh=Bk9SJQPoi79DqxwvGZnyQgyHOAaJXc/jJTW1skZN7kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA05ET6YiAHcbwfLhN8D/UKd5lIrU80rPkPIa00F4xeNxQHsxae2uZGYx3WHSDi837b1MzU9Y2x/QJiKmWP7GsolrioxHV3e3dCtQRXRSeEwMGPQBqadd1NaVdFszUnUKyo+pLLgouSZ0MFzri6vRVo0k6AHXrxz4Ej7FAaCYQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ao6btOE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ao6btOE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FB1C116D0;
	Wed, 25 Feb 2026 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983228;
	bh=Bk9SJQPoi79DqxwvGZnyQgyHOAaJXc/jJTW1skZN7kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ao6btOE/qH0Ur3xVcUCuGT9JSATNcteCVLR/xH2hg8LHx2xR8bsG5W45t+Up7a8gx
	 QEe8AO9HjUKPQjLjnaI4PSvLyZ3xdX9HczJ9+KFzQU4tVsX7TXKx/mqkaf0eqzEmTR
	 DuQn/a3GGfwIQfdpYzUxfS+CES2QtUgR6IM/ElOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 372/781] Bluetooth: hci_conn: Fix using conn->le_{tx,rx}_phy as supported PHYs
Date: Tue, 24 Feb 2026 17:18:01 -0800
Message-ID: <20260225012408.812718125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 129d1ef3c5e60d51678e6359beaba85771a49e46 ]

conn->le_{tx,rx}_phy is not actually a bitfield as it set by
HCI_EV_LE_PHY_UPDATE_COMPLETE it is actually correspond to the current
PHY in use not what is supported by the controller, so this introduces
different fields (conn->le_{tx,rx}_def_phys) to track what PHYs are
supported by the connection.

Fixes: eab2404ba798 ("Bluetooth: Add BT_PHY socket option")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_conn.c         | 17 +++++++++++------
 net/bluetooth/hci_event.c        | 30 +++++++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4263e71a23efb..8aadf4cdead2b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -730,6 +730,8 @@ struct hci_conn {
 	__u16		le_per_adv_data_offset;
 	__u8		le_adv_phy;
 	__u8		le_adv_sec_phy;
+	__u8		le_tx_def_phys;
+	__u8		le_rx_def_phys;
 	__u8		le_tx_phy;
 	__u8		le_rx_phy;
 	__s8		rssi;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c3f7828bf9d54..5a4374ccf8e84 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1008,6 +1008,11 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type,
 		/* conn->src should reflect the local identity address */
 		hci_copy_identity_address(hdev, &conn->src, &conn->src_type);
 		conn->mtu = hdev->le_mtu ? hdev->le_mtu : hdev->acl_mtu;
+		/* Use the controller supported PHYS as default until the
+		 * remote features are resolved.
+		 */
+		conn->le_tx_def_phys = hdev->le_tx_def_phys;
+		conn->le_rx_def_phys = hdev->le_tx_def_phys;
 		break;
 	case CIS_LINK:
 		/* conn->src should reflect the local identity address */
@@ -2928,22 +2933,22 @@ u32 hci_conn_get_phy(struct hci_conn *conn)
 		break;
 
 	case LE_LINK:
-		if (conn->le_tx_phy & HCI_LE_SET_PHY_1M)
+		if (conn->le_tx_def_phys & HCI_LE_SET_PHY_1M)
 			phys |= BT_PHY_LE_1M_TX;
 
-		if (conn->le_rx_phy & HCI_LE_SET_PHY_1M)
+		if (conn->le_rx_def_phys & HCI_LE_SET_PHY_1M)
 			phys |= BT_PHY_LE_1M_RX;
 
-		if (conn->le_tx_phy & HCI_LE_SET_PHY_2M)
+		if (conn->le_tx_def_phys & HCI_LE_SET_PHY_2M)
 			phys |= BT_PHY_LE_2M_TX;
 
-		if (conn->le_rx_phy & HCI_LE_SET_PHY_2M)
+		if (conn->le_rx_def_phys & HCI_LE_SET_PHY_2M)
 			phys |= BT_PHY_LE_2M_RX;
 
-		if (conn->le_tx_phy & HCI_LE_SET_PHY_CODED)
+		if (conn->le_tx_def_phys & HCI_LE_SET_PHY_CODED)
 			phys |= BT_PHY_LE_CODED_TX;
 
-		if (conn->le_rx_phy & HCI_LE_SET_PHY_CODED)
+		if (conn->le_rx_def_phys & HCI_LE_SET_PHY_CODED)
 			phys |= BT_PHY_LE_CODED_RX;
 
 		break;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a9868f17ef40f..58075bf720554 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6607,8 +6607,20 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev, void *data,
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
 	if (conn) {
-		if (!ev->status)
-			memcpy(conn->features[0], ev->features, 8);
+		if (!ev->status) {
+			memcpy(conn->le_features, ev->features, 8);
+
+			/* Update supported PHYs */
+			if (!(conn->le_features[1] & HCI_LE_PHY_2M)) {
+				conn->le_tx_def_phys &= ~HCI_LE_SET_PHY_2M;
+				conn->le_rx_def_phys &= ~HCI_LE_SET_PHY_2M;
+			}
+
+			if (!(conn->le_features[1] & HCI_LE_PHY_CODED)) {
+				conn->le_tx_def_phys &= ~HCI_LE_SET_PHY_CODED;
+				conn->le_rx_def_phys &= ~HCI_LE_SET_PHY_CODED;
+			}
+		}
 
 		if (conn->state == BT_CONFIG) {
 			__u8 status;
@@ -7221,9 +7233,21 @@ static void hci_le_read_all_remote_features_evt(struct hci_dev *hdev,
 	if (!conn)
 		goto unlock;
 
-	if (!ev->status)
+	if (!ev->status) {
 		memcpy(conn->le_features, ev->features, 248);
 
+		/* Update supported PHYs */
+		if (!(conn->le_features[1] & HCI_LE_PHY_2M)) {
+			conn->le_tx_def_phys &= ~HCI_LE_SET_PHY_2M;
+			conn->le_rx_def_phys &= ~HCI_LE_SET_PHY_2M;
+		}
+
+		if (!(conn->le_features[1] & HCI_LE_PHY_CODED)) {
+			conn->le_tx_def_phys &= ~HCI_LE_SET_PHY_CODED;
+			conn->le_rx_def_phys &= ~HCI_LE_SET_PHY_CODED;
+		}
+	}
+
 	if (conn->state == BT_CONFIG) {
 		__u8 status;
 
-- 
2.51.0



