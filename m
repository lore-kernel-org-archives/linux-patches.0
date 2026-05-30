Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450F2628D;
	Sat, 30 May 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163586; cv=none; b=mYTkHMRUNxakSrWFu5HYketXsCkiK3iu95yAJgWDj9U83MpQdUwfDoGCXotERo0Zn1CsQAzQCBtOdj2pq9uSh2X8BVm5JynsB5gkLrYvTSDl47L8Z4JBG670EvFGun7HP/n1aBG3XrTp1i5Hltdqfu3XRk2Ufls1su0FzKbuu7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163586; c=relaxed/simple;
	bh=7Lt0aW9pmQmeuYQMDQRJtdEOrunn5hh/jAfEVlbPyq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSDNurC+uFFjrnFXfcYn8LCJtKEGnenxIDsNE0RvaVghV2HOXPUBdbRfa1+D/da459SmBr/5BpDCMQrHevH6XubWbz3X7959nnc4Y1eouSvAK1cx43ettNGuUaM5BauA+EpJ9QRWDamoT/jwnEWPIO6bfzqUYqcelUISKqbahko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSX46KDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSX46KDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FC01F00893;
	Sat, 30 May 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163584;
	bh=ptYhgls3vwS5smVjVSYm9Av/YWRK/s3tmHzVank90a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSX46KDkEHtahT4TG0WkjUvLbpBOEnyQykRzEYDoT4kczxKhAFlJJsVJl2Bdp1saA
	 ZIWWZy6S+L1NTRIZe3bkJgU5No23qBFx1KWEKIIQmiS7njAG/Nlb0spvYYjFByBqR0
	 +dXM80+CDPMOlQW410BHQAAfWmaJnZficfTuZG14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soenke Huster <soenke.huster@eknoes.de>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 303/776] Bluetooth: virtio_bt: clamp rx length before skb_put
Date: Sat, 30 May 2026 18:00:17 +0200
Message-ID: <20260530160248.398888845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 21bd244b6de5d2fe1063c23acc93fbdd2b20d112 upstream.

virtbt_rx_work() calls skb_put(skb, len) where len comes directly
from virtqueue_get_buf() with no validation against the buffer we
posted to the device. The RX skb is allocated in virtbt_add_inbuf()
and exposed to virtio as exactly 1000 bytes via sg_init_one().

Checking len against skb_tailroom(skb) is not sufficient because
alloc_skb() can leave more tailroom than the 1000 bytes actually
handed to the device. A malicious or buggy backend can therefore
report used.len between 1001 and skb_tailroom(skb), causing skb_put()
to include uninitialized kernel heap bytes that were never written by
the device.

The same path also accepts len == 0, in which case skb_put(skb, 0)
leaves the skb empty but virtbt_rx_handle() still reads the pkt_type
byte from skb->data, consuming uninitialized memory.

Define VIRTBT_RX_BUF_SIZE once and reuse it in alloc_skb() and
sg_init_one(), and gate virtbt_rx_work() on that same constant so
the bound checked matches the buffer actually exposed to the device.
Reject used.len == 0 in the same gate so an empty completion can
no longer reach virtbt_rx_handle().

Use bt_dev_err_ratelimited() because the length value comes from an
untrusted backend that can otherwise flood the kernel log.

Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
overflow in USB transport layer"), which hardened the USB 9p
transport against unchecked device-reported length.

Fixes: 160fbcf3bfb9 ("Bluetooth: virtio_bt: Use skb_put to set length")
Cc: stable@vger.kernel.org
Cc: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/virtio_bt.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -12,6 +12,7 @@
 #include <net/bluetooth/hci_core.h>
 
 #define VERSION "0.1"
+#define VIRTBT_RX_BUF_SIZE 1000
 
 enum {
 	VIRTBT_VQ_TX,
@@ -33,11 +34,11 @@ static int virtbt_add_inbuf(struct virti
 	struct sk_buff *skb;
 	int err;
 
-	skb = alloc_skb(1000, GFP_KERNEL);
+	skb = alloc_skb(VIRTBT_RX_BUF_SIZE, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
-	sg_init_one(sg, skb->data, 1000);
+	sg_init_one(sg, skb->data, VIRTBT_RX_BUF_SIZE);
 
 	err = virtqueue_add_inbuf(vq, sg, 1, skb, GFP_KERNEL);
 	if (err < 0) {
@@ -219,8 +220,15 @@ static void virtbt_rx_work(struct work_s
 	if (!skb)
 		return;
 
-	skb_put(skb, len);
-	virtbt_rx_handle(vbt, skb);
+	if (!len || len > VIRTBT_RX_BUF_SIZE) {
+		bt_dev_err_ratelimited(vbt->hdev,
+				       "rx reply len %u outside [1, %u]\n",
+				       len, VIRTBT_RX_BUF_SIZE);
+		kfree_skb(skb);
+	} else {
+		skb_put(skb, len);
+		virtbt_rx_handle(vbt, skb);
+	}
 
 	if (virtbt_add_inbuf(vbt) < 0)
 		return;


