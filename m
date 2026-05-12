Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C43955DB;
	Tue, 12 May 2026 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608414; cv=none; b=HCjZLi4Ea+ikCXIuG3Zja3Qeu2RhGOFjL135cOy1nUG5q50xEaJTKunraSbDKWsYp3uz2JYnyIH5SUvlFum+zLpTIo/H0gbZ0/XJUn0Kt0XHjNY4nAiBEZj+Ayc3Yn4waiX9ODjg4bDS9ZYruD+HAI857vFMieBVVdNi62fxZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608414; c=relaxed/simple;
	bh=oJDYbN/kAOwu6T1aBKjYpemKg+MIAlE3TL4es49vFC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS7wcjU7rJxcppCx/Nl6H+6RytxLbCZ2lBl+z42xg77/jVsxE1eEHfnkT9r7EnaNuQoUuTeu6zSqtoDmJtr1muKqvL4UAr4ZXM4JWJGXjukXm77OkbK/vVqW8jfOII2LOzLo+7MO/PsIX+SGqkaPWVK+EFOdS0KCQLFJbWR7JTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnW5cLuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnW5cLuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D52BC2BCB0;
	Tue, 12 May 2026 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608414;
	bh=oJDYbN/kAOwu6T1aBKjYpemKg+MIAlE3TL4es49vFC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnW5cLuwaU7A1dBh9o9boajuClZ1BowwEbrGoxqy0GqCda9Dn6NSzU5o61ucokdua
	 sbNX9trv6G1eGZqqQf9tyatNMOjd4JeF4FM3+rpVuQJy4dTXURcTbFWRx9w1OzTtXJ
	 c9cBaWbuBtXlXJiX0OEiuyv3GyaqdRhvL4dKnn3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soenke Huster <soenke.huster@eknoes.de>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 069/270] Bluetooth: virtio_bt: validate rx pkt_type header length
Date: Tue, 12 May 2026 19:37:50 +0200
Message-ID: <20260512173939.904040539@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -198,6 +198,7 @@ static int virtbt_shutdown_generic(struc
 
 static void virtbt_rx_handle(struct virtio_bluetooth *vbt, struct sk_buff *skb)
 {
+	size_t min_hdr;
 	__u8 pkt_type;
 
 	pkt_type = *((__u8 *) skb->data);
@@ -205,16 +206,32 @@ static void virtbt_rx_handle(struct virt
 
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


