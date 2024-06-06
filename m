Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0C119AD47;
	Thu,  6 Jun 2024 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683326; cv=none; b=OahBek4De4rtws1qr7g1GRy69fhWjEKR9DV38IuAW4Qw9RLbyzNmikHy9uRdCNlGL57yhzzIGtJ1QS7cE6dCxnroPc9zg+fiICxQsDOnbUwNc6ivaqNtNZ/6P/P/0CuFb1t2BbyFRHQLVlc2fRCdllW9vd1CyI8gqy0c8srDfA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683326; c=relaxed/simple;
	bh=grbLZfN2DXtAHHGU6u7jJCx44GJUDP9jKj5c74p7JKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVwU9+6vDuzhKid+gmPH8/iNy38S2GsBEMQ2N7qtqj05I6kmuqDL9D36vGFEHrKK/qF1rvei1KFHpI7aKjOpsbeBggWQy3W7iaTqxOW8vSk1LVaOQ/xNz5Z1a57f4E6cGiuuoQDs8dcr3DfkG7KUCxLXRplxxvoE5jlg5gFpI5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut3NpeEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut3NpeEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAEBC2BD10;
	Thu,  6 Jun 2024 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683325;
	bh=grbLZfN2DXtAHHGU6u7jJCx44GJUDP9jKj5c74p7JKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut3NpeEyl8Q0KiAYNKf6pa5ByZR7OAKVXXGdINvh0oTf8xH47AWEy/Zgg6TxgIo/i
	 2bsByMkfo2UUxQp0iPCYznD9M+QFwkTjPZ42nDK8O1c4ZhR8zjfcLyQbs6/UDLuBtF
	 Rbgs2s0c0NVo0NQ4mXa8KbLlyMYYW4qBXk150d5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/744] Bluetooth: hci_event: Remove code to removed CONFIG_BT_HS
Date: Thu,  6 Jun 2024 15:58:57 +0200
Message-ID: <20240606131740.889101367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit f4b0c2b4cd78b75acde56c2ee5aa732b6fb2a6a9 ]

Commit cec9f3c5561d ("Bluetooth: Remove BT_HS") removes config BT_HS, but
misses two "ifdef BT_HS" blocks in hci_event.c.

Remove this dead code from this removed config option.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 84a4bb6548a2 ("Bluetooth: HCI: Remove HCI_AMP support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 163 --------------------------------------
 1 file changed, 163 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 361e2c68a51a1..d357ec131aa5a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5710,150 +5710,6 @@ static void hci_remote_oob_data_request_evt(struct hci_dev *hdev, void *edata,
 	hci_dev_unlock(hdev);
 }
 
-#if IS_ENABLED(CONFIG_BT_HS)
-static void hci_chan_selected_evt(struct hci_dev *hdev, void *data,
-				  struct sk_buff *skb)
-{
-	struct hci_ev_channel_selected *ev = data;
-	struct hci_conn *hcon;
-
-	bt_dev_dbg(hdev, "handle 0x%2.2x", ev->phy_handle);
-
-	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (!hcon)
-		return;
-
-	amp_read_loc_assoc_final_data(hdev, hcon);
-}
-
-static void hci_phy_link_complete_evt(struct hci_dev *hdev, void *data,
-				      struct sk_buff *skb)
-{
-	struct hci_ev_phy_link_complete *ev = data;
-	struct hci_conn *hcon, *bredr_hcon;
-
-	bt_dev_dbg(hdev, "handle 0x%2.2x status 0x%2.2x", ev->phy_handle,
-		   ev->status);
-
-	hci_dev_lock(hdev);
-
-	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (!hcon)
-		goto unlock;
-
-	if (!hcon->amp_mgr)
-		goto unlock;
-
-	if (ev->status) {
-		hci_conn_del(hcon);
-		goto unlock;
-	}
-
-	bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;
-
-	hcon->state = BT_CONNECTED;
-	bacpy(&hcon->dst, &bredr_hcon->dst);
-
-	hci_conn_hold(hcon);
-	hcon->disc_timeout = HCI_DISCONN_TIMEOUT;
-	hci_conn_drop(hcon);
-
-	hci_debugfs_create_conn(hcon);
-	hci_conn_add_sysfs(hcon);
-
-	amp_physical_cfm(bredr_hcon, hcon);
-
-unlock:
-	hci_dev_unlock(hdev);
-}
-
-static void hci_loglink_complete_evt(struct hci_dev *hdev, void *data,
-				     struct sk_buff *skb)
-{
-	struct hci_ev_logical_link_complete *ev = data;
-	struct hci_conn *hcon;
-	struct hci_chan *hchan;
-	struct amp_mgr *mgr;
-
-	bt_dev_dbg(hdev, "log_handle 0x%4.4x phy_handle 0x%2.2x status 0x%2.2x",
-		   le16_to_cpu(ev->handle), ev->phy_handle, ev->status);
-
-	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (!hcon)
-		return;
-
-	/* Create AMP hchan */
-	hchan = hci_chan_create(hcon);
-	if (!hchan)
-		return;
-
-	hchan->handle = le16_to_cpu(ev->handle);
-	hchan->amp = true;
-
-	BT_DBG("hcon %p mgr %p hchan %p", hcon, hcon->amp_mgr, hchan);
-
-	mgr = hcon->amp_mgr;
-	if (mgr && mgr->bredr_chan) {
-		struct l2cap_chan *bredr_chan = mgr->bredr_chan;
-
-		l2cap_chan_lock(bredr_chan);
-
-		bredr_chan->conn->mtu = hdev->block_mtu;
-		l2cap_logical_cfm(bredr_chan, hchan, 0);
-		hci_conn_hold(hcon);
-
-		l2cap_chan_unlock(bredr_chan);
-	}
-}
-
-static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev, void *data,
-					     struct sk_buff *skb)
-{
-	struct hci_ev_disconn_logical_link_complete *ev = data;
-	struct hci_chan *hchan;
-
-	bt_dev_dbg(hdev, "handle 0x%4.4x status 0x%2.2x",
-		   le16_to_cpu(ev->handle), ev->status);
-
-	if (ev->status)
-		return;
-
-	hci_dev_lock(hdev);
-
-	hchan = hci_chan_lookup_handle(hdev, le16_to_cpu(ev->handle));
-	if (!hchan || !hchan->amp)
-		goto unlock;
-
-	amp_destroy_logical_link(hchan, ev->reason);
-
-unlock:
-	hci_dev_unlock(hdev);
-}
-
-static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev, void *data,
-					     struct sk_buff *skb)
-{
-	struct hci_ev_disconn_phy_link_complete *ev = data;
-	struct hci_conn *hcon;
-
-	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
-
-	if (ev->status)
-		return;
-
-	hci_dev_lock(hdev);
-
-	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (hcon && hcon->type == AMP_LINK) {
-		hcon->state = BT_CLOSED;
-		hci_disconn_cfm(hcon, ev->reason);
-		hci_conn_del(hcon);
-	}
-
-	hci_dev_unlock(hdev);
-}
-#endif
-
 static void le_conn_update_addr(struct hci_conn *conn, bdaddr_t *bdaddr,
 				u8 bdaddr_type, bdaddr_t *local_rpa)
 {
@@ -7675,25 +7531,6 @@ static const struct hci_ev {
 	/* [0x3e = HCI_EV_LE_META] */
 	HCI_EV_REQ_VL(HCI_EV_LE_META, hci_le_meta_evt,
 		      sizeof(struct hci_ev_le_meta), HCI_MAX_EVENT_SIZE),
-#if IS_ENABLED(CONFIG_BT_HS)
-	/* [0x40 = HCI_EV_PHY_LINK_COMPLETE] */
-	HCI_EV(HCI_EV_PHY_LINK_COMPLETE, hci_phy_link_complete_evt,
-	       sizeof(struct hci_ev_phy_link_complete)),
-	/* [0x41 = HCI_EV_CHANNEL_SELECTED] */
-	HCI_EV(HCI_EV_CHANNEL_SELECTED, hci_chan_selected_evt,
-	       sizeof(struct hci_ev_channel_selected)),
-	/* [0x42 = HCI_EV_DISCONN_PHY_LINK_COMPLETE] */
-	HCI_EV(HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE,
-	       hci_disconn_loglink_complete_evt,
-	       sizeof(struct hci_ev_disconn_logical_link_complete)),
-	/* [0x45 = HCI_EV_LOGICAL_LINK_COMPLETE] */
-	HCI_EV(HCI_EV_LOGICAL_LINK_COMPLETE, hci_loglink_complete_evt,
-	       sizeof(struct hci_ev_logical_link_complete)),
-	/* [0x46 = HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE] */
-	HCI_EV(HCI_EV_DISCONN_PHY_LINK_COMPLETE,
-	       hci_disconn_phylink_complete_evt,
-	       sizeof(struct hci_ev_disconn_phy_link_complete)),
-#endif
 	/* [0x48 = HCI_EV_NUM_COMP_BLOCKS] */
 	HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
 	       sizeof(struct hci_ev_num_comp_blocks)),
-- 
2.43.0



