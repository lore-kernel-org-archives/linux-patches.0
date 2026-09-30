Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AAE4F68C9;
	Wed, 30 Sep 2026 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793309; cv=none; b=owop9k+ClnRQAD5J5T493Dm8p8SCG5AGAT32xcuiPmfDzWUpI6OCix+i9AkzHq5DuuyfNmBWxDKg1k9sePoZFMsSYGLa/z3LvHRxDwZ/tQOhql9D6efqKFv/x0wyjLonLnCUQI7REc3xES2ADg4eoTL9Ww0u66ZQuIY48rzpqbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793309; c=relaxed/simple;
	bh=81EXGqL3/eHIqeCC2UDI3FnjV30OPSROXkP/UNfRpoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd5dZExrLNrRh34b0gycnQrTBwgILNOENrhvWyl/JhK/h2/6H5+hLKZ0ydOgSP6Nxz5EiTeDVUvWeV/z7wLc1TrXlsF6I7sfag41tNOjxuoVSU+MAdZFHtOZyFzJ0eHGM2a2YW8vTsrEYNG4/nMFw88W9hhScOOMpQmaCUzAbic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZq66e8M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZq66e8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9BF1F000FF;
	Wed, 30 Sep 2026 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793307;
	bh=DGt51DqixQa/vA3b8YPNoxvpaECyBP7tJj9+y620Z9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZq66e8MvUNz3cFKTf3ZJIZpRJLNUaVAIZi9wUe3jmV7fmUwJihHs5i1eJU8CzYaK
	 d9mQXskl5MbVUBFmYSoIFGqBH9DsO3xjUSJhOM58pBDUWATRj5b0VTZavEE61a/uFp
	 3vbzsAF8Qv3qO0kMO3Kxh2xJY7oXkt4Fz96c9oW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mst@redhat.com,
	jasowangio@gmail.com,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 208/395] virtio_net: copy zerocopy frags in start_xmit without NAPI
Date: Wed, 30 Sep 2026 17:27:50 +0200
Message-ID: <20260930152345.164710661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

commit 07e1a9408b6c2f9d0cfb757b67dabb52da7a32b2 upstream.

Virtio-net without NAPI frees completed skbs lazily on the next
start_xmit. Senders waiting for in-flight zerocopy buffers can
deadlock if they cannot transmit more packets, as then no
completed packets will be freed.

When !use_napi, virtio-net already calls skb_orphan to avoid waiting
up for transmitted skbs to be freed. For zerocopy packets that
require deep copying on orphan (i.e. those that do not set
SKBFL_DONT_ORPHAN, such as PACKET_TX_RING), call skb_orphan_frags
before orphaning to release the buffers.

This fixes the tpacket_snd slot reuse bug on skb_orphan for
virtio-net, and prevents PACKET_TX_RING from running out of slots.

This fix also touches vhost_net zerocopy packets, which also do not
set SKBFL_DONT_ORPHAN. This is fine: vhost_net packets only encounter
virtio-net in nested virtualization, and only if napi_tx is
explicitly disabled (it has been default-enabled since Linux 4.12).
In that rare case, copying the frags is desirable anyway to prevent
holding guest descriptors pinned across unbounded intervals.

This is a prerequisite for the next patch, which converts
PACKET_TX_RING to standard zerocopy completion. Without this patch
first, a bounded ring sender can stall indefinitely behind a
virtio-net virtqueue that cannot reclaim.

Fixes: 5cd8d46ea156 ("packet: copy user buffers before orphan or clone")
Cc: stable@vger.kernel.org
Cc: mst@redhat.com
Cc: jasowangio@gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260919004748.1463985-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3397,6 +3397,14 @@ static netdev_tx_t start_xmit(struct sk_
 	else
 		virtqueue_disable_cb(sq->vq);
 
+	if (!use_napi &&
+	    unlikely(skb_orphan_frags(skb, GFP_ATOMIC))) {
+		DEV_STATS_INC(dev, tx_dropped);
+		dev_kfree_skb_any(skb);
+		kick = !xmit_more || netif_xmit_stopped(txq);
+		goto kick_vq;
+	}
+
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
 
@@ -3429,6 +3437,7 @@ static netdev_tx_t start_xmit(struct sk_
 
 	kick = use_napi ? __netdev_tx_sent_queue(txq, skb->len, xmit_more) :
 			  !xmit_more || netif_xmit_stopped(txq);
+kick_vq:
 	if (kick) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);


