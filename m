Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8681DFEF;
	Wed, 20 Nov 2024 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107668; cv=none; b=k95VI4YnGGB2XCIR6h2HxM1MxIkMnX5ISId+ZMn/8lQTcQoZOfm0KQfSBm1CHq/B9vEfx7wEkT5z0y7NpkIRT+3HBOM1dKF7RyOkKjpjyE+xWB1jhzDrN9w2aKaH8JXIjPlXSdbsVuQUoj6eY2LksZ/JQH4tmmvQv+iiZQ3tigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107668; c=relaxed/simple;
	bh=CuxeHG2gPc0sQUkvDXLMTKR5lY/kOpt9zdb/YDJ6GhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOBjkKhqxgOCynIj7fx/WT4jaHa68L7JEIm8YxC3kB7fTSQWtRD9ZDJ+Kqw2rWVD26AryFs7n+NqBMuEBacUEpAMEPsw0/XI2Cm1nlLbJdWWZl0OqtsFEntzEbP0/cOFbQR9+f9kt5c4hKWlw2gBqryRfaAzKmL7A/H/TJENd/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7TTQ2lM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7TTQ2lM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D518C4CECD;
	Wed, 20 Nov 2024 13:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107668;
	bh=CuxeHG2gPc0sQUkvDXLMTKR5lY/kOpt9zdb/YDJ6GhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7TTQ2lMElSsxcPOilcMo252gb9GxrFFSXuzDDEM2WDhKGD9PdxRInNox6dc6aeG9
	 7bHalBay/HlmrLhxOesp4Rx6SKfqE3huEhas5y4DriPasWlEYC3Qp4HH5LejBw+Kod
	 v7sOEzY6ULDUMSwMdxcB0kb6Vi/8wo5ZC0HtrS+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/73] Bluetooth: hci_event: Remove code to removed CONFIG_BT_HS
Date: Wed, 20 Nov 2024 13:57:55 +0100
Message-ID: <20241120125809.850556473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit f4b0c2b4cd78b75acde56c2ee5aa732b6fb2a6a9 ]

Commit cec9f3c5561d ("Bluetooth: Remove BT_HS") removes config BT_HS, but
misses two "ifdef BT_HS" blocks in hci_event.c.

Remove this dead code from this removed config option.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 7967dc8f797f ("Bluetooth: hci_core: Fix calling mgmt_device_connected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 163 --------------------------------------
 1 file changed, 163 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7c1df481ebe9d..b6fe5e15981f8 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5648,150 +5648,6 @@ static void hci_remote_oob_data_request_evt(struct hci_dev *hdev, void *edata,
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
@@ -7473,25 +7329,6 @@ static const struct hci_ev {
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



