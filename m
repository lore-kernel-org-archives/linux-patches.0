Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D3281504;
	Tue, 27 May 2025 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365979; cv=none; b=dZhApYg5O7bU0y3gX+aY8MC+/0PkAFQ3QcAyrAFf/Bn5ojadLtIt+cdEENUbGCVG9F23SKFv/ftIBrNOTwveM7DX+f1WkXMB09sjC3Lz51MqVBkheiizc2fYCVo884MLvFHMxk9AZuTv3AyDwTL2BQ9CnbiMJjAuEpXnd7/B/uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365979; c=relaxed/simple;
	bh=vXAsIeXZEYiidS0NvS1I8zn//BlJnMWULz1qzDOGF7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSJgeZTjakSR6RvkrzCKeOOD4hbIFzxBlOMxSm5z+cmH5tiNSprvC7r748Y79nVFt34bOvBk76gG0OlJRMS0E3ND3Qckk5Asaokzxpro+d8I4/5DNV8EjEkAMFOSnMiJIHcXSYpSr3FImoM7YgTd/3X9bMxLzCsC/B673KGQqBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vo05tAp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vo05tAp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B15BC4CEE9;
	Tue, 27 May 2025 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365977;
	bh=vXAsIeXZEYiidS0NvS1I8zn//BlJnMWULz1qzDOGF7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vo05tAp+i/OVJWmlIsqdcngvJWRSMKvvcsLYi4ZkHEnG8Qz9ZWHuQ0HQ5+I0kk/GO
	 djyHPTSHjcU04EUFVG0CxsROb4p6aTQttqs8/+KoHLfLaPK/lCKwmg+hwvUdJlU+tT
	 j6W71msbNfBdwEBGc4E8GDrFz/qrlqFRVNsGbJIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	En-Wei Wu <en-wei.wu@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 552/626] Bluetooth: btusb: use skb_pull to avoid unsafe access in QCA dump handling
Date: Tue, 27 May 2025 18:27:25 +0200
Message-ID: <20250527162507.404402555@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e1f03231b4c9..af2be0271806f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2979,9 +2979,8 @@ static void btusb_coredump_qca(struct hci_dev *hdev)
 static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	int ret = 0;
+	unsigned int skip = 0;
 	u8 pkt_type;
-	u8 *sk_ptr;
-	unsigned int sk_len;
 	u16 seqno;
 	u32 dump_size;
 
@@ -2990,18 +2989,13 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
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
@@ -3021,16 +3015,15 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 
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
@@ -3050,7 +3043,6 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 		return ret;
 	}
 
-	skb_pull(skb, skb->len - sk_len);
 	hci_devcd_append(hdev, skb);
 	btdata->qca_dump.ram_dump_seqno++;
 	if (seqno == QCA_LAST_SEQUENCE_NUM) {
@@ -3078,68 +3070,58 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
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



