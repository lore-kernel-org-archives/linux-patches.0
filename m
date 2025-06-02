Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6B322333B;
	Mon,  2 Jun 2025 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874142; cv=none; b=cFldX+ujbfbazUeS/gfbQChWMVT82kC9IUlqCkI5vV2QlRGJRBf10ueSGdK3pJ0eKdyql96JiaZs+ayP7LZdAQIQljD2phaI+8rDFVZKtr4o82WuuM3MHCYPOspSbl79J/909d9DNpS9dgDjneXf53Hd/TILvtuasZ8QmI0pLyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874142; c=relaxed/simple;
	bh=TH2AZehqhRGDWUk6NoGY0hqBoRO7rKax3dszJ/M1hHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYzuxnvhmWHPrdC2q1c84CsHTukjqUFPEct/c0yREYhqN+5RZsPme4TDVZxQGzhyAkyiPuHIQ/SEsFfc+A2WbC4HKgJ5WnsAWuHfabQ061NohZBcJGCiylFGg7DptjmnAs3SDGD4J0qxFCsfFNz58DIznDzJzqfc/AUOGqVNBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hH61YuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hH61YuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9995C4CEF2;
	Mon,  2 Jun 2025 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874142;
	bh=TH2AZehqhRGDWUk6NoGY0hqBoRO7rKax3dszJ/M1hHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hH61YuJt87IxR6L96q1CAdvocO/xuz88vhkapKOt/1fzOwdyrrFv8dvzqrt3ulOY
	 BwLvprI6ubMefbFRgv60bAYZt9hKEbD75PVjj4YOftD8Idc4uwCnrS/qdrdFbr3KT9
	 zkcL6DOz6Zeau1EdoiaAc6CvCpvzwpTR2Akl6LTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	En-Wei Wu <en-wei.wu@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 341/444] Bluetooth: btusb: use skb_pull to avoid unsafe access in QCA dump handling
Date: Mon,  2 Jun 2025 15:46:45 +0200
Message-ID: <20250602134354.775568921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: En-Wei Wu <en-wei.wu@canonical.com>

[ Upstream commit 4bcb0c7dc25446b99fc7a8fa2a143d69f3314162 ]

Use skb_pull() and skb_pull_data() to safely parse QCA dump packets.

This avoids direct pointer math on skb->data, which could lead to
invalid access if the packet is shorter than expected.

Fixes: 20981ce2d5a5 ("Bluetooth: btusb: Add WCN6855 devcoredump support")
Signed-off-by: En-Wei Wu <en-wei.wu@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 98 ++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 58 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index d6195565ef7ae..e0dd698896088 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3525,9 +3525,8 @@ static void btusb_coredump_qca(struct hci_dev *hdev)
 static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	int ret = 0;
+	unsigned int skip = 0;
 	u8 pkt_type;
-	u8 *sk_ptr;
-	unsigned int sk_len;
 	u16 seqno;
 	u32 dump_size;
 
@@ -3536,18 +3535,13 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 	struct usb_device *udev = btdata->udev;
 
 	pkt_type = hci_skb_pkt_type(skb);
-	sk_ptr = skb->data;
-	sk_len = skb->len;
+	skip = sizeof(struct hci_event_hdr);
+	if (pkt_type == HCI_ACLDATA_PKT)
+		skip += sizeof(struct hci_acl_hdr);
 
-	if (pkt_type == HCI_ACLDATA_PKT) {
-		sk_ptr += HCI_ACL_HDR_SIZE;
-		sk_len -= HCI_ACL_HDR_SIZE;
-	}
-
-	sk_ptr += HCI_EVENT_HDR_SIZE;
-	sk_len -= HCI_EVENT_HDR_SIZE;
+	skb_pull(skb, skip);
+	dump_hdr = (struct qca_dump_hdr *)skb->data;
 
-	dump_hdr = (struct qca_dump_hdr *)sk_ptr;
 	seqno = le16_to_cpu(dump_hdr->seqno);
 	if (seqno == 0) {
 		set_bit(BTUSB_HW_SSR_ACTIVE, &btdata->flags);
@@ -3567,16 +3561,15 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 
 		btdata->qca_dump.ram_dump_size = dump_size;
 		btdata->qca_dump.ram_dump_seqno = 0;
-		sk_ptr += offsetof(struct qca_dump_hdr, data0);
-		sk_len -= offsetof(struct qca_dump_hdr, data0);
+
+		skb_pull(skb, offsetof(struct qca_dump_hdr, data0));
 
 		usb_disable_autosuspend(udev);
 		bt_dev_info(hdev, "%s memdump size(%u)\n",
 			    (pkt_type == HCI_ACLDATA_PKT) ? "ACL" : "event",
 			    dump_size);
 	} else {
-		sk_ptr += offsetof(struct qca_dump_hdr, data);
-		sk_len -= offsetof(struct qca_dump_hdr, data);
+		skb_pull(skb, offsetof(struct qca_dump_hdr, data));
 	}
 
 	if (!btdata->qca_dump.ram_dump_size) {
@@ -3596,7 +3589,6 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 		return ret;
 	}
 
-	skb_pull(skb, skb->len - sk_len);
 	hci_devcd_append(hdev, skb);
 	btdata->qca_dump.ram_dump_seqno++;
 	if (seqno == QCA_LAST_SEQUENCE_NUM) {
@@ -3624,68 +3616,58 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 /* Return: true if the ACL packet is a dump packet, false otherwise. */
 static bool acl_pkt_is_dump_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	u8 *sk_ptr;
-	unsigned int sk_len;
-
 	struct hci_event_hdr *event_hdr;
 	struct hci_acl_hdr *acl_hdr;
 	struct qca_dump_hdr *dump_hdr;
+	struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
+	bool is_dump = false;
 
-	sk_ptr = skb->data;
-	sk_len = skb->len;
-
-	acl_hdr = hci_acl_hdr(skb);
-	if (le16_to_cpu(acl_hdr->handle) != QCA_MEMDUMP_ACL_HANDLE)
+	if (!clone)
 		return false;
 
-	sk_ptr += HCI_ACL_HDR_SIZE;
-	sk_len -= HCI_ACL_HDR_SIZE;
-	event_hdr = (struct hci_event_hdr *)sk_ptr;
-
-	if ((event_hdr->evt != HCI_VENDOR_PKT) ||
-	    (event_hdr->plen != (sk_len - HCI_EVENT_HDR_SIZE)))
-		return false;
+	acl_hdr = skb_pull_data(clone, sizeof(*acl_hdr));
+	if (!acl_hdr || (le16_to_cpu(acl_hdr->handle) != QCA_MEMDUMP_ACL_HANDLE))
+		goto out;
 
-	sk_ptr += HCI_EVENT_HDR_SIZE;
-	sk_len -= HCI_EVENT_HDR_SIZE;
+	event_hdr = skb_pull_data(clone, sizeof(*event_hdr));
+	if (!event_hdr || (event_hdr->evt != HCI_VENDOR_PKT))
+		goto out;
 
-	dump_hdr = (struct qca_dump_hdr *)sk_ptr;
-	if ((sk_len < offsetof(struct qca_dump_hdr, data)) ||
-	    (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS) ||
-	    (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
-		return false;
+	dump_hdr = skb_pull_data(clone, sizeof(*dump_hdr));
+	if (!dump_hdr || (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS) ||
+	   (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
+		goto out;
 
-	return true;
+	is_dump = true;
+out:
+	consume_skb(clone);
+	return is_dump;
 }
 
 /* Return: true if the event packet is a dump packet, false otherwise. */
 static bool evt_pkt_is_dump_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	u8 *sk_ptr;
-	unsigned int sk_len;
-
 	struct hci_event_hdr *event_hdr;
 	struct qca_dump_hdr *dump_hdr;
+	struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
+	bool is_dump = false;
 
-	sk_ptr = skb->data;
-	sk_len = skb->len;
-
-	event_hdr = hci_event_hdr(skb);
-
-	if ((event_hdr->evt != HCI_VENDOR_PKT)
-	    || (event_hdr->plen != (sk_len - HCI_EVENT_HDR_SIZE)))
+	if (!clone)
 		return false;
 
-	sk_ptr += HCI_EVENT_HDR_SIZE;
-	sk_len -= HCI_EVENT_HDR_SIZE;
+	event_hdr = skb_pull_data(clone, sizeof(*event_hdr));
+	if (!event_hdr || (event_hdr->evt != HCI_VENDOR_PKT))
+		goto out;
 
-	dump_hdr = (struct qca_dump_hdr *)sk_ptr;
-	if ((sk_len < offsetof(struct qca_dump_hdr, data)) ||
-	    (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS) ||
-	    (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
-		return false;
+	dump_hdr = skb_pull_data(clone, sizeof(*dump_hdr));
+	if (!dump_hdr || (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS) ||
+	   (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
+		goto out;
 
-	return true;
+	is_dump = true;
+out:
+	consume_skb(clone);
+	return is_dump;
 }
 
 static int btusb_recv_acl_qca(struct hci_dev *hdev, struct sk_buff *skb)
-- 
2.39.5



