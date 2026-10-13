Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B04F4EA398;
	Tue, 13 Oct 2026 12:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893739; cv=none; b=fbSUhYgRKsy076iAbQph9BCpfP7WnfMEzoc7L2yF9nTwStE/BFdU7nuIHg1C7g4jAs+tLlj5Kbr0Djn7E4p5vB/wdOPkOoivk51HH0rb34kKWMOtqlXbH3XqH2WGQNs9VWogpeehg+/gxsCiqdVo+Q88lGAJqTWFyzsIWQAHR2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893739; c=relaxed/simple;
	bh=q5qqxuJ0/BwQtnm3grPwTb3DcxRQUCWiZ1qK+pC4+hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEKspG+6A6PblFdtcKnsZDpkqLe/ZaOk19q2vQEq3jra17wv14zAuk/Z2RO0YB50yCtjPXBM6xvdVVVyf7JZYCrKCa0ugY5+LpWvlPVKnTtU9LjQsVCa+S2qiqI3qUiwLmhw7JRF0a5Rka3W3lJNe/jziEfzkcdV6fxFub11TfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DONjPLgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DONjPLgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7A51F00893;
	Tue, 13 Oct 2026 12:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893737;
	bh=grdiG5F7OCJoocgv4KT7Ygks0gXVqenKwfoRZr//zOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DONjPLgnLNzwco5gNgnnaXeYLLFg0dDMCWPJOW1REwt5BApfsx7GAax9F/s+VM6D5
	 9l6Tq57GhtwIj1ffbPo6hJ44ATTkh+ZMGNFQy2GqAjpaf8w7sNYtQhhI1ikWa4dpPG
	 9D+MBjLhSzWXdCY3dk3Fl9NeFTz7rPOF13UFomOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 325/621] Bluetooth: hci_conn: Fix using conn->le_{tx,rx}_phy as supported PHYs
Date: Tue, 13 Oct 2026 13:35:20 +0200
Message-ID: <20261013112928.565688479@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 129d1ef3c5e60d51678e6359beaba85771a49e46 ]

conn->le_{tx,rx}_phy is not actually a bitfield as it set by
HCI_EV_LE_PHY_UPDATE_COMPLETE it is actually correspond to the current
PHY in use not what is supported by the controller, so this introduces
different fields (conn->le_{tx,rx}_def_phys) to track what PHYs are
supported by the connection.

Fixes: eab2404ba798 ("Bluetooth: Add BT_PHY socket option")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Adapted for this tree: the all-remote-features event handler does not
exist here, so that hunk is dropped, and the LE remote features are
kept in conn->features[0] rather than conn->le_features.

Stable-dep-of: 56e78b670356 ("Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_conn.c         | 17 +++++++++++------
 net/bluetooth/hci_event.c        | 14 +++++++++++++-
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4dc8e6c39c01e..c416f7f2af6aa 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -729,6 +729,8 @@ struct hci_conn {
 	__u16		le_per_adv_data_offset;
 	__u8		le_adv_phy;
 	__u8		le_adv_sec_phy;
+	__u8		le_tx_def_phys;
+	__u8		le_rx_def_phys;
 	__u8		le_tx_phy;
 	__u8		le_rx_phy;
 	__s8		rssi;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index fab41702ea573..32cabe83351ac 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1017,6 +1017,11 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t
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
@@ -2960,22 +2965,22 @@ u32 hci_conn_get_phy(struct hci_conn *conn)
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
index c42f480e4f6d3..23fe327a0fcd6 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6621,9 +6621,21 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev, void *data,
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
 	if (conn) {
-		if (!ev->status)
+		if (!ev->status) {
 			memcpy(conn->features[0], ev->features, 8);
 
+			/* Update supported PHYs */
+			if (!(conn->features[0][1] & HCI_LE_PHY_2M)) {
+				conn->le_tx_def_phys &= ~HCI_LE_SET_PHY_2M;
+				conn->le_rx_def_phys &= ~HCI_LE_SET_PHY_2M;
+			}
+
+			if (!(conn->features[0][1] & HCI_LE_PHY_CODED)) {
+				conn->le_tx_def_phys &= ~HCI_LE_SET_PHY_CODED;
+				conn->le_rx_def_phys &= ~HCI_LE_SET_PHY_CODED;
+			}
+		}
+
 		if (conn->state == BT_CONFIG) {
 			__u8 status;
 
-- 
2.53.0



