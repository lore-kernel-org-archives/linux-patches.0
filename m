Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6598215FCFB;
	Mon, 27 May 2024 19:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838310; cv=none; b=qMeuQiQpeaHq8C4pMoLTpDdfy5meM/Nidg0QEOn+WAQ537TXY906wt8E7FSg8MVuRt/vYDiL4Xv/M3ew0Bf13Es9FzGKUI+PbxlZIDjmbkVB765hQ0M4UhOI7AjraMaBqyCoLVJaMCyp0xYEHcvItwFXiJlUm/Fgc2ZR0McZ1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838310; c=relaxed/simple;
	bh=M4LYytuu6oBFWPtS2lovqQMy+dIozcbh8ScfcaCj5gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjImqaCzgpAX2DYIWgW8xh7DnnLrXtakEVXwr2/04pTpSJScGvU8NWbG0GZoEZapSfbyjqFUWGRrL8WvZpjbHLk7VHJ+5/RjvdUIqjReBNvImHU4vbrI+mO4Q6b+6M6hpcC1/OVIW0Htuef9qAMsCr/z8KUC86lK5rXW26+UYK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAjWAiat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAjWAiat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E29C32781;
	Mon, 27 May 2024 19:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838310;
	bh=M4LYytuu6oBFWPtS2lovqQMy+dIozcbh8ScfcaCj5gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAjWAiatWa02seEVSODLRRoEVvIYmno4hx2KQnudrGriGOXmVzyazKS+ovWSEIFGd
	 lIKZ3wiEzo3cnnXfA2NWFMuypXglDFSE1VUQHOP1AWTsWc6T2w6X4anTVV75q3UEI0
	 KpxECe49/FJoTdzvULtikzo0WweHv0bjqt+XFjWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 343/493] Bluetooth: hci_event: Remove code to removed CONFIG_BT_HS
Date: Mon, 27 May 2024 20:55:45 +0200
Message-ID: <20240527185641.493187420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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
index c19d78e5d2053..4de8f0dc1a523 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5697,150 +5697,6 @@ static void hci_remote_oob_data_request_evt(struct hci_dev *hdev, void *edata,
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
@@ -7656,25 +7512,6 @@ static const struct hci_ev {
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



