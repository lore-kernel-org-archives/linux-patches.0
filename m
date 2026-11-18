Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034805;
	b=THJvWDcqzkrSIuiGfFGLunByu+Wc6iZmW7Q0Zufc0w/+TYVk7t0LZTd3gzF5erGnYpW/
	 3octlm+uVzvo8tEvyBY8+nO1/bx/Zk+iV0eh4bKs7uDB/FwIPZ0TSEwQJSlDKdVEPdoOK
	 426kscixmQhoWayHtz/awE7/Lmo994s1dCALca/qCC3eWY/7e7/HAlt2/gF3i3+IwG04e
	 rEK7TWL7kY/BPJwWV3o//7YGm9fDjqDytt9BEPUhUx02Ous1J8wlQUvUalaCQwlIov3UZ
	 f+yUm/uaR+8UQgy2XGypUepJEN0l4xkei9H2eIFO3n21u3bmSArUJg3BqP4esWFfahw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XFDzKiuHg3sUUy2nOB/MNAEMYE2NcKraXOWnbfj4Wx0=;
	b=AfHgXz2AxRNtehRRZ0jhASWeUcjf3kcbgsbR3tLEWRdJnHuoVwEQFi40TuDEtFg+HXiv
	 arOhZVWnzc8KWGXVnHqqHAu/w3jxJrAbIhrEjICBMQcN+Gzp6o5wRu3rFgaEFAn2UuJ7A
	 LMPiMMKauPy40xSDxU7zmRBEO0EB092fJ4lUmKfxWIaK+9OreiaxnrvQcf262+mbOe8SX
	 xE7O+LMvp7l5a0oQ08P/+vUkPCGBQp6N9FJlBAmoi8IAjTvyStJg1rrKeEWFQyYK/gzzP
	 RoBYse9BT74iiO88iJQGHZaqUHCvwLzd8adhdrUMT5QtPOKh42Ucu6EFBCeAoyY+4vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="irP4H/M3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581F606A31C;
	Wed, 18 Nov 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irP4H/M3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C851F000C4;
	Wed, 18 Nov 2026 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034804;
	bh=XFDzKiuHg3sUUy2nOB/MNAEMYE2NcKraXOWnbfj4Wx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irP4H/M34OARGaZQ6fL30ohWkv8qhqSxc7NXQRTAMJXOH6SRI7algwJ3voDszdf8m
	 9fSsdCNW/FWrfWV73+412Dg54Ttb5lr9bWV4+kz2bYBJqfxdmEMLBFwBxTQBB6555V
	 y5+mosCPBLNtxRjMh40BlhQDjvIddhhTU+D0EyK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mst@redhat.com,
	jasowangio@gmail.com,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0501/3318] virtio_net: copy zerocopy frags in start_xmit without NAPI
Date: Wed, 18 Nov 2026 15:18:43 +0100
Message-ID: <20261118150332.089319103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 07e1a9408b6c2f9d0cfb757b67dabb52da7a32b2 ]

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
[ sashal: Context adapted to the older start_xmit(): the kick_vq label goes before if (kick || netif_xmit_stopped(txq)), and upstream's kick = ... line in the error path is dropped as redundant. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fe0e647808cd7..b98acab38ac4d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2429,6 +2429,13 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	} while (use_napi && kick &&
 	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
+	if (!use_napi &&
+	    unlikely(skb_orphan_frags(skb, GFP_ATOMIC))) {
+		DEV_STATS_INC(dev, tx_dropped);
+		dev_kfree_skb_any(skb);
+		goto kick_vq;
+	}
+
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
 
@@ -2456,6 +2463,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	check_sq_full_and_disable(vi, dev, sq);
 
+kick_vq:
 	if (kick || netif_xmit_stopped(txq)) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
-- 
2.53.0



