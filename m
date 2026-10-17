Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D73C73EC;
	Sat, 17 Oct 2026 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258816; cv=none; b=PV/APmR+L2OgtziYnprIJi7ZhMzuFY0PSygo0my5OLVkMUvqAPWg96s+H+5tAZES0eaRYrapjYn3HPzX0deXh4gtenLa6i05wtYqCEjfT8i7iDeO0W2aiCWKha6Lx0Cmg/PcGNetXIvQ2GcurHELLsa+Z1+3jnao+3cujPKG8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258816; c=relaxed/simple;
	bh=O/m/RG6KO61SND1pKqUdyrJknZVprJ0A34pJYZKKslQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Erpf7XUqI3ndwxibM/eRoKLHbRudiTZP5V+MhJc+6cJFCeqbJqpUqhRwJ2SZEtPqH/7auKtPo63IjmT0Ey+s3UCDmwpzqm20C08WSfPb+1/EXg6FGneMVJlJ/WCzUSBMuAs+23iVq3TXlNPCoOtnKsWgUlpP8KocmWJ7ZiuBN9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wl4a2qf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wl4a2qf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836041F000C4;
	Sat, 17 Oct 2026 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258815;
	bh=5fVPUEHIBj1vQqgeeorLMkKvr0arpmEv6cVKji4CbcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wl4a2qf6FIjDkS70IiKp+7gYKZid0EN3YH8VMr74lX/Q+sgBRJIcKCMpXSXCJSRLQ
	 BjfACJ2VF2PGFxC7vlRxzKq7ZBb80OJGcSX7bEjbidE9xfSHK9JBIr5vxiwokE5J58
	 36m81IPVRE+a6GgGu2CGW7O7EDoZepTSB7RJG/t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1007/1674] vsock/virtio: fix `rx_bytes` accounting for stream sockets
Date: Sat, 17 Oct 2026 17:54:39 +0200
Message-ID: <20261017160456.980752116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 45ca7e9f0730ae36fc610e675b990e9cc9ca0714 ]

In `struct virtio_vsock_sock`, we maintain two counters:
- `rx_bytes`: used internally to track how many bytes have been read.
  This supports mechanisms like .stream_has_data() and sock_rcvlowat().
- `fwd_cnt`: used for the credit mechanism to inform available receive
  buffer space to the remote peer.

These counters are updated via virtio_transport_inc_rx_pkt() and
virtio_transport_dec_rx_pkt().

Since the beginning with commit 06a8fc78367d ("VSOCK: Introduce
virtio_vsock_common.ko"), we call virtio_transport_dec_rx_pkt() in
virtio_transport_stream_do_dequeue() only when we consume the entire
packet, so partial reads, do not update `rx_bytes` and `fwd_cnt`.

This is fine for `fwd_cnt`, because we still have space used for the
entire packet, and we don't want to update the credit for the other
peer until we free the space of the entire packet. However, this
causes `rx_bytes` to be stale on partial reads.

Previously, this didn’t cause issues because `rx_bytes` was used only by
.stream_has_data(), and any unread portion of a packet implied data was
still available. However, since commit 93b808876682
("virtio/vsock: fix logic which reduces credit update messages"), we now
rely on `rx_bytes` to determine if a credit update should be sent when
the data in the RX queue drops below SO_RCVLOWAT value.

This patch fixes the accounting by updating `rx_bytes` with the number
of bytes actually read, even on partial reads, while leaving `fwd_cnt`
untouched until the packet is fully consumed. Also introduce a new
`buf_used` counter to check that the remote peer is honoring the given
credit; this was previously done via `rx_bytes`.

Fixes: 93b808876682 ("virtio/vsock: fix logic which reduces credit update messages")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20250521121705.196379-1-sgarzare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 059b7dbd20a6 ("vsock/virtio: fix potential unbounded skb queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 26 +++++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index bf8cac814ae5b..2b0ac38dc3b06 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -144,6 +144,7 @@ struct virtio_vsock_sock {
 	u32 last_fwd_cnt;
 	u32 rx_bytes;
 	u32 buf_alloc;
+	u32 buf_used;
 	struct sk_buff_head rx_queue;
 	u32 msg_count;
 };
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 4f3b14e1b5252..e2a5803c0bbb7 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -283,18 +283,20 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
 					u32 len)
 {
-	if (vvs->rx_bytes + len > vvs->buf_alloc)
+	if (vvs->buf_used + len > vvs->buf_alloc)
 		return false;
 
 	vvs->rx_bytes += len;
+	vvs->buf_used += len;
 	return true;
 }
 
 static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
-					u32 len)
+					u32 bytes_read, u32 bytes_dequeued)
 {
-	vvs->rx_bytes -= len;
-	vvs->fwd_cnt += len;
+	vvs->rx_bytes -= bytes_read;
+	vvs->buf_used -= bytes_dequeued;
+	vvs->fwd_cnt += bytes_dequeued;
 }
 
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
@@ -399,11 +401,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 				   size_t len)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	size_t bytes, total = 0;
 	struct sk_buff *skb;
 	u32 fwd_cnt_delta;
 	bool low_rx_bytes;
 	int err = -EFAULT;
+	size_t total = 0;
 	u32 free_space;
 
 	spin_lock_bh(&vvs->rx_lock);
@@ -415,6 +417,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	}
 
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
+		size_t bytes, dequeued = 0;
+
 		skb = skb_peek(&vvs->rx_queue);
 
 		bytes = min_t(size_t, len - total,
@@ -438,12 +442,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;
 
 		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
-			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
-
-			virtio_transport_dec_rx_pkt(vvs, pkt_len);
+			dequeued = le32_to_cpu(virtio_vsock_hdr(skb)->len);
 			__skb_unlink(skb, &vvs->rx_queue);
 			consume_skb(skb);
 		}
+
+		virtio_transport_dec_rx_pkt(vvs, bytes, dequeued);
 	}
 
 	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
@@ -599,7 +603,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				msg->msg_flags |= MSG_EOR;
 		}
 
-		virtio_transport_dec_rx_pkt(vvs, pkt_len);
+		virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
 		kfree_skb(skb);
 	}
 
@@ -1566,6 +1570,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	struct sock *sk = sk_vsock(vsk);
 	struct virtio_vsock_hdr *hdr;
 	struct sk_buff *skb;
+	u32 pkt_len;
 	int off = 0;
 	int err;
 
@@ -1583,7 +1588,8 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
 		vvs->msg_count--;
 
-	virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
+	pkt_len = le32_to_cpu(hdr->len);
+	virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
 	spin_unlock_bh(&vvs->rx_lock);
 
 	virtio_transport_send_credit_update(vsk);
-- 
2.53.0



