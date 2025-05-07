Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D929A0;
	Wed,  7 May 2025 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644546; cv=none; b=qYtjfUtDr5vxKfZTVuVqKS3StFmz6n/Mq1hfPPgfZTNdXMrKO6Lef4sBcDeOrTFSrQ9iuueLovkqNrPM5iPviyjJPSpoYZ+1IL2cQ3wPLDhAqwgzGd+TC8UrHRclk2mUWmXkFd29kLgV9s2zRjc5FXLZtoh9FYBKTx/CguMNT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644546; c=relaxed/simple;
	bh=EadIyELre1jRbCRwTm8P38BkApaAYy5KpgB3Uf0GpzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc2Wb/iVRqMty5VTHroLEtq+1k4tmPg1LiKS7Wh+N03S+IxNmGB4Q5AGPL3xvf9aaZ3ZAZ3nAl4ER3oP+6qz0MHs0Qht4X28GTwKbJHeGCGjbPeJ6y7PSpxcSZVXgMEaooP3q/mSfACE3luoSPgcEmLml0NwTC3kLZySM5oYSI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOT0cZDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOT0cZDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED69C4CEE9;
	Wed,  7 May 2025 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644546;
	bh=EadIyELre1jRbCRwTm8P38BkApaAYy5KpgB3Uf0GpzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOT0cZDhZ0Tyj0aMP10M8vtv0FyK+7w0C4krDkbMW+0RsSkICbhuf9fTslj2QQKhc
	 6K85u4ljqXZ59Zz7M2iSTvSnou8g8h4S32/Up3tFvbMiNsVRYetuApjnwCg4WPDySi
	 m3pb2FSdSBLNBR8ZRgzIeYG4qTSF8I+VXNAUL9sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	En-Wei Wu <en-wei.wu@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/164] Bluetooth: btusb: avoid NULL pointer dereference in skb_dequeue()
Date: Wed,  7 May 2025 20:39:23 +0200
Message-ID: <20250507183824.120991083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

[ Upstream commit 0317b033abcd1d8dd2798f0e2de5e84543d0bd22 ]

A NULL pointer dereference can occur in skb_dequeue() when processing a
QCA firmware crash dump on WCN7851 (0489:e0f3).

[ 93.672166] Bluetooth: hci0: ACL memdump size(589824)

[ 93.672475] BUG: kernel NULL pointer dereference, address: 0000000000000008
[ 93.672517] Workqueue: hci0 hci_devcd_rx [bluetooth]
[ 93.672598] RIP: 0010:skb_dequeue+0x50/0x80

The issue stems from handle_dump_pkt_qca() returning 0 even when a dump
packet is successfully processed. This is because it incorrectly
forwards the return value of hci_devcd_init() (which returns 0 on
success). As a result, the caller (btusb_recv_acl_qca() or
btusb_recv_evt_qca()) assumes the packet was not handled and passes it
to hci_recv_frame(), leading to premature kfree() of the skb.

Later, hci_devcd_rx() attempts to dequeue the same skb from the dump
queue, resulting in a NULL pointer dereference.

Fix this by:
1. Making handle_dump_pkt_qca() return 0 on success and negative errno
   on failure, consistent with kernel conventions.
2. Splitting dump packet detection into separate functions for ACL
   and event packets for better structure and readability.

This ensures dump packets are properly identified and consumed, avoiding
double handling and preventing NULL pointer access.

Fixes: 20981ce2d5a5 ("Bluetooth: btusb: Add WCN6855 devcoredump support")
Signed-off-by: En-Wei Wu <en-wei.wu@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 101 +++++++++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 28 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f784daaa6b528..7e1f03231b4c9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2975,22 +2975,16 @@ static void btusb_coredump_qca(struct hci_dev *hdev)
 		bt_dev_err(hdev, "%s: triggle crash failed (%d)", __func__, err);
 }
 
-/*
- * ==0: not a dump pkt.
- * < 0: fails to handle a dump pkt
- * > 0: otherwise.
- */
+/* Return: 0 on success, negative errno on failure. */
 static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	int ret = 1;
+	int ret = 0;
 	u8 pkt_type;
 	u8 *sk_ptr;
 	unsigned int sk_len;
 	u16 seqno;
 	u32 dump_size;
 
-	struct hci_event_hdr *event_hdr;
-	struct hci_acl_hdr *acl_hdr;
 	struct qca_dump_hdr *dump_hdr;
 	struct btusb_data *btdata = hci_get_drvdata(hdev);
 	struct usb_device *udev = btdata->udev;
@@ -3000,30 +2994,14 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 	sk_len = skb->len;
 
 	if (pkt_type == HCI_ACLDATA_PKT) {
-		acl_hdr = hci_acl_hdr(skb);
-		if (le16_to_cpu(acl_hdr->handle) != QCA_MEMDUMP_ACL_HANDLE)
-			return 0;
 		sk_ptr += HCI_ACL_HDR_SIZE;
 		sk_len -= HCI_ACL_HDR_SIZE;
-		event_hdr = (struct hci_event_hdr *)sk_ptr;
-	} else {
-		event_hdr = hci_event_hdr(skb);
 	}
 
-	if ((event_hdr->evt != HCI_VENDOR_PKT)
-		|| (event_hdr->plen != (sk_len - HCI_EVENT_HDR_SIZE)))
-		return 0;
-
 	sk_ptr += HCI_EVENT_HDR_SIZE;
 	sk_len -= HCI_EVENT_HDR_SIZE;
 
 	dump_hdr = (struct qca_dump_hdr *)sk_ptr;
-	if ((sk_len < offsetof(struct qca_dump_hdr, data))
-		|| (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS)
-	    || (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
-		return 0;
-
-	/*it is dump pkt now*/
 	seqno = le16_to_cpu(dump_hdr->seqno);
 	if (seqno == 0) {
 		set_bit(BTUSB_HW_SSR_ACTIVE, &btdata->flags);
@@ -3097,17 +3075,84 @@ static int handle_dump_pkt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 	return ret;
 }
 
+/* Return: true if the ACL packet is a dump packet, false otherwise. */
+static bool acl_pkt_is_dump_qca(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	u8 *sk_ptr;
+	unsigned int sk_len;
+
+	struct hci_event_hdr *event_hdr;
+	struct hci_acl_hdr *acl_hdr;
+	struct qca_dump_hdr *dump_hdr;
+
+	sk_ptr = skb->data;
+	sk_len = skb->len;
+
+	acl_hdr = hci_acl_hdr(skb);
+	if (le16_to_cpu(acl_hdr->handle) != QCA_MEMDUMP_ACL_HANDLE)
+		return false;
+
+	sk_ptr += HCI_ACL_HDR_SIZE;
+	sk_len -= HCI_ACL_HDR_SIZE;
+	event_hdr = (struct hci_event_hdr *)sk_ptr;
+
+	if ((event_hdr->evt != HCI_VENDOR_PKT) ||
+	    (event_hdr->plen != (sk_len - HCI_EVENT_HDR_SIZE)))
+		return false;
+
+	sk_ptr += HCI_EVENT_HDR_SIZE;
+	sk_len -= HCI_EVENT_HDR_SIZE;
+
+	dump_hdr = (struct qca_dump_hdr *)sk_ptr;
+	if ((sk_len < offsetof(struct qca_dump_hdr, data)) ||
+	    (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS) ||
+	    (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
+		return false;
+
+	return true;
+}
+
+/* Return: true if the event packet is a dump packet, false otherwise. */
+static bool evt_pkt_is_dump_qca(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	u8 *sk_ptr;
+	unsigned int sk_len;
+
+	struct hci_event_hdr *event_hdr;
+	struct qca_dump_hdr *dump_hdr;
+
+	sk_ptr = skb->data;
+	sk_len = skb->len;
+
+	event_hdr = hci_event_hdr(skb);
+
+	if ((event_hdr->evt != HCI_VENDOR_PKT)
+	    || (event_hdr->plen != (sk_len - HCI_EVENT_HDR_SIZE)))
+		return false;
+
+	sk_ptr += HCI_EVENT_HDR_SIZE;
+	sk_len -= HCI_EVENT_HDR_SIZE;
+
+	dump_hdr = (struct qca_dump_hdr *)sk_ptr;
+	if ((sk_len < offsetof(struct qca_dump_hdr, data)) ||
+	    (dump_hdr->vse_class != QCA_MEMDUMP_VSE_CLASS) ||
+	    (dump_hdr->msg_type != QCA_MEMDUMP_MSG_TYPE))
+		return false;
+
+	return true;
+}
+
 static int btusb_recv_acl_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	if (handle_dump_pkt_qca(hdev, skb))
-		return 0;
+	if (acl_pkt_is_dump_qca(hdev, skb))
+		return handle_dump_pkt_qca(hdev, skb);
 	return hci_recv_frame(hdev, skb);
 }
 
 static int btusb_recv_evt_qca(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	if (handle_dump_pkt_qca(hdev, skb))
-		return 0;
+	if (evt_pkt_is_dump_qca(hdev, skb))
+		return handle_dump_pkt_qca(hdev, skb);
 	return hci_recv_frame(hdev, skb);
 }
 
-- 
2.39.5



