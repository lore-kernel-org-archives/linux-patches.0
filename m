Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F73342CA7;
	Sat, 30 May 2026 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163589; cv=none; b=PKVYPI8tVxXARMFCLGMNtfIC8WOwLwg9m/E76I0IrBOXa+80ZwCh9R65gmgtacplgfr1nzvs4OoNTxGdD6pq5gllDU9xDjWDsh63xBhm3B/B/mbil3t4XhtpGaXu/cz7O1y5VIZnEYUm253JOBG9Uy+3nAei+veuPJGf6lUsm6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163589; c=relaxed/simple;
	bh=YtoJ7aeATsfmaV2mZnK/L4p2hcprxfBgRzd1FBJl+Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU+eErWIO+IXZ4GC+tszhfdhNZIwo7SRXluccQdZMfqnJ1Qs3HXON3hSpmoTj1uVfgCdCMHN6qOfl0ljfCVtEVPJ/lTLaXAhkC1ZWlSYGtpzEMNZkUNeIa59/AhIJ5oMAGMa6g9fXjsw0ofkn43ZH6j2JKMz0wrCe9nJMCguJUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8pGCv3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8pGCv3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB531F00893;
	Sat, 30 May 2026 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163588;
	bh=Ut+2HAJ6TuFVsifXPPVv8dazsgwUkJAc6MHp9xGs65w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8pGCv3hp/YiXOtLnyoMHfk48SkV1/vgWTxTuNmtPKT8j4HsHY7om3bupifKkgRHv
	 Dx6NE28OYUysU/6o6WKsPUJi1qOAimjLndZpUnXJFAHnL44jfx9c4sLiv3/byEtbkD
	 NCy3xK3dZN6eJD6jU6kRInNcbUlTLyMi4i7OhNI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soenke Huster <soenke.huster@eknoes.de>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 304/776] Bluetooth: virtio_bt: validate rx pkt_type header length
Date: Sat, 30 May 2026 18:00:18 +0200
Message-ID: <20260530160248.425478470@linuxfoundation.org>
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

commit daf23014e5d975e72ea9c02b5160d3fcf070ea47 upstream.

virtbt_rx_handle() reads the leading pkt_type byte from the RX skb
and forwards the remainder to hci_recv_frame() for every
event/ACL/SCO/ISO type, without checking that the remaining payload
is at least the fixed HCI header for that type.

After the preceding patch bounds the backend-supplied used.len to
[1, VIRTBT_RX_BUF_SIZE], a one-byte completion still reaches
hci_recv_frame() with skb->len already pulled to 0. If the byte
happened to be HCI_ACLDATA_PKT, the ACL-vs-ISO classification
fast-path in hci_dev_classify_pkt_type() dereferences
hci_acl_hdr(skb)->handle whenever the HCI device has an active
CIS_LINK, BIS_LINK, or PA_LINK connection, reading two bytes of
uninitialized RX-buffer data. The same hazard exists for every
packet type the driver accepts because none of the switch cases in
virtbt_rx_handle() check skb->len against the per-type minimum HCI
header size before handing the frame to the core.

After stripping pkt_type, require skb->len to cover the fixed
header size for the selected type (event 2, ACL 4, SCO 3, ISO 4)
before calling hci_recv_frame(); drop ratelimited otherwise.
Unknown pkt_type values still take the original kfree_skb() default
path.

Use bt_dev_err_ratelimited() because both the length and pkt_type
values come from an untrusted backend that can otherwise flood the
kernel log.

Fixes: 160fbcf3bfb9 ("Bluetooth: virtio_bt: Use skb_put to set length")
Cc: stable@vger.kernel.org
Cc: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/virtio_bt.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -190,6 +190,7 @@ static int virtbt_shutdown_generic(struc
 
 static void virtbt_rx_handle(struct virtio_bluetooth *vbt, struct sk_buff *skb)
 {
+	size_t min_hdr;
 	__u8 pkt_type;
 
 	pkt_type = *((__u8 *) skb->data);
@@ -197,16 +198,32 @@ static void virtbt_rx_handle(struct virt
 
 	switch (pkt_type) {
 	case HCI_EVENT_PKT:
+		min_hdr = sizeof(struct hci_event_hdr);
+		break;
 	case HCI_ACLDATA_PKT:
+		min_hdr = sizeof(struct hci_acl_hdr);
+		break;
 	case HCI_SCODATA_PKT:
+		min_hdr = sizeof(struct hci_sco_hdr);
+		break;
 	case HCI_ISODATA_PKT:
-		hci_skb_pkt_type(skb) = pkt_type;
-		hci_recv_frame(vbt->hdev, skb);
+		min_hdr = sizeof(struct hci_iso_hdr);
 		break;
 	default:
 		kfree_skb(skb);
-		break;
+		return;
 	}
+
+	if (skb->len < min_hdr) {
+		bt_dev_err_ratelimited(vbt->hdev,
+				       "rx pkt_type 0x%02x payload %u < hdr %zu\n",
+				       pkt_type, skb->len, min_hdr);
+		kfree_skb(skb);
+		return;
+	}
+
+	hci_skb_pkt_type(skb) = pkt_type;
+	hci_recv_frame(vbt->hdev, skb);
 }
 
 static void virtbt_rx_work(struct work_struct *work)


