Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A5A501285;
	Wed, 30 Sep 2026 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789381; cv=none; b=Le9wlp4zNijYbueF6zubKoitPo4nbp0TWJgD0xHk4+JOvtPFxTfOLCp48YVV6R7PNERdntLGVoq2ArroQ2gcr601UrDAanhH+6o6/ofF1PSVJW9FKLOIyc9pKJuNhfWdz3TSVi3f/nswFML4FGKAT9JxsVmVyfjcch+GGAj5F4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789381; c=relaxed/simple;
	bh=Q+Sx7MFOoxQ/vY87DY18ldQOw3rM0lfqBbx7jaZIObU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQIxMcWY/1Ur9UG7XhbfV3TBHj7pY20HQhEKsO8Xo5WYg2x7ViTPYT2ukpSXsqPjJHD4IPTIg+c8qFmf9O9Wtd2J9wvqpb0CJZFiRA/U7pgf+stEZWduXmATcDtabQ+HueB8J7yO/guEwE/RnHlLENY4JBQiL3A7dQe+hloaCsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZeOzWN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZeOzWN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7461F008A0;
	Wed, 30 Sep 2026 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789379;
	bh=z38UO2KNZ1CgacTYCXGEsv1++gtcJRYXcI/L9O1YwKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZeOzWN0ouCyKJLbJEWd8b+tx67ri1COI/eXJy3rbOPUKS9biNTfBPhsV677VuvQa
	 8Ka2WpYPmktmOkdNfPLKn4EUcpcktxWUCoHPtoFh4JmRbz/EAgffcu5fxBEFCZjMBH
	 7ncAP2jre0gq2iTtrCNxkdtQjXTyGsPRuWQodhxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mst@redhat.com,
	jasowangio@gmail.com,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 458/877] virtio_net: copy zerocopy frags in start_xmit without NAPI
Date: Wed, 30 Sep 2026 17:22:49 +0200
Message-ID: <20260930152424.562039394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3141,6 +3141,14 @@ static netdev_tx_t start_xmit(struct sk_
 	} while (use_napi && !xmit_more &&
 	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
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
 
@@ -3170,6 +3178,7 @@ static netdev_tx_t start_xmit(struct sk_
 
 	kick = use_napi ? __netdev_tx_sent_queue(txq, skb->len, xmit_more) :
 			  !xmit_more || netif_xmit_stopped(txq);
+kick_vq:
 	if (kick) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);


