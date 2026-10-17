Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493D13C0A1E;
	Sat, 17 Oct 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258813; cv=none; b=ZhrSyBuL2rpyKt0GcCExurpA4tkWfX7hIuKrASEXdDn0VHlP7WjVVOEkjHZxid76IExeCKNP36nZb0pOKkpePGYJDjaOcUQpGrEGNKTO3AKdn2g+Du96KhyzeLmoPE8cygWkub5ZjrOh59P0nByVQgjcdAhUm7yNoLA/aUibhUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258813; c=relaxed/simple;
	bh=A+TE9J9oMkVQqeF90xxC45ESyiD5+0lE5yr9OGKmoG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV6ac2HxHrP/OZYnPcog0T5V+bEesJWqillSzCi2e8gyzwYNh0YWkMy6YJkzANXOgoYwZVtPkAjMfjvqxnPBOJryM7OFryJD4ZGpSur5HwK3NNvZFLvXwC6Pxp4p2DjtWz3zLcFknK+ZFqcORa/w3Y7K08f2WazqkBDswmtjxyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8Cf7cR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8Cf7cR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD801F000C4;
	Sat, 17 Oct 2026 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258812;
	bh=ik3JCtP3YNvXjiGHng079I2vwyRjik7LphLwcZqFiLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8Cf7cR1epyQCvJkfppO1M3jWWPHoC3sKuUQaZ3ZG7ZPDNVdhC1VEpWwLPVbZb9jl
	 60p/+58KQirEHw8wKp/Bm4+b0cfKvZh8a0zTds3tuvyv/IP954VO2EGEodfDo2FDwn
	 Iii6LwXpBHTatBy0JR02qRTRmJ0AZ4dgKSFcSkY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1006/1674] vsock/virtio/vhost: read data from non-linear skb
Date: Sat, 17 Oct 2026 17:54:38 +0200
Message-ID: <20261017160456.954883026@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit 0df7cd3c13e44d01f9f28e29cbce74e2931b00fe ]

This is preparation patch for MSG_ZEROCOPY support. It adds handling of
non-linear skbs by replacing direct calls of 'memcpy_to_msg()' with
'skb_copy_datagram_iter()'. Main advantage of the second one is that it
can handle paged part of the skb by using 'kmap()' on each page, but if
there are no pages in the skb, it behaves like simple copying to iov
iterator. This patch also adds new field to the control block of skb -
this value shows current offset in the skb to read next portion of data
(it doesn't matter linear it or not). Idea behind this field is that
'skb_copy_datagram_iter()' handles both types of skb internally - it
just needs an offset from which to copy data from the given skb. This
offset is incremented on each read from skb. This approach allows to
simplify handling of both linear and non-linear skbs, because for
linear skb we need to call 'skb_pull()' after reading data from it,
while in non-linear case we need to update 'data_len'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 059b7dbd20a6 ("vsock/virtio: fix potential unbounded skb queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c                   | 14 +++++++----
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 32 +++++++++++++++----------
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 912e5153b1f86..f609e17cdaba8 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -115,6 +115,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		struct sk_buff *skb;
 		unsigned out, in;
 		size_t nbytes;
+		u32 offset;
 		int head;
 
 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
@@ -157,7 +158,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
-		payload_len = skb->len;
+		offset = VIRTIO_VSOCK_SKB_CB(skb)->offset;
+		payload_len = skb->len - offset;
 		hdr = virtio_vsock_hdr(skb);
 
 		/* If the packet is greater than the space available in the
@@ -198,8 +200,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
-		if (nbytes != payload_len) {
+		if (skb_copy_datagram_iter(skb,
+					   offset,
+					   &iov_iter,
+					   payload_len)) {
 			kfree_skb(skb);
 			vq_err(vq, "Faulted on copying pkt buf\n");
 			break;
@@ -213,13 +217,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
 		added = true;
 
-		skb_pull(skb, payload_len);
+		VIRTIO_VSOCK_SKB_CB(skb)->offset += payload_len;
 		total_len += payload_len;
 
 		/* If we didn't send all the payload we can requeue the packet
 		 * to send it with the next available buffer.
 		 */
-		if (skb->len > 0) {
+		if (VIRTIO_VSOCK_SKB_CB(skb)->offset < skb->len) {
 			hdr->flags |= cpu_to_le32(flags_to_restore);
 
 			/* We are queueing the same skb to handle
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 5148b035a8f38..bf8cac814ae5b 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -12,6 +12,7 @@
 struct virtio_vsock_skb_cb {
 	bool reply;
 	bool tap_delivered;
+	u32 offset;
 };
 
 #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16431ef52799d..4f3b14e1b5252 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -368,9 +368,10 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 		spin_unlock_bh(&vvs->rx_lock);
 
 		/* sk_lock is held by caller so no one else can dequeue.
-		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 		 */
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		err = skb_copy_datagram_iter(skb, VIRTIO_VSOCK_SKB_CB(skb)->offset,
+					     &msg->msg_iter, bytes);
 		if (err)
 			goto out;
 
@@ -416,25 +417,27 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
 		skb = skb_peek(&vvs->rx_queue);
 
-		bytes = len - total;
-		if (bytes > skb->len)
-			bytes = skb->len;
+		bytes = min_t(size_t, len - total,
+			      skb->len - VIRTIO_VSOCK_SKB_CB(skb)->offset);
 
 		/* sk_lock is held by caller so no one else can dequeue.
-		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 		 */
 		spin_unlock_bh(&vvs->rx_lock);
 
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		err = skb_copy_datagram_iter(skb,
+					     VIRTIO_VSOCK_SKB_CB(skb)->offset,
+					     &msg->msg_iter, bytes);
 		if (err)
 			goto out;
 
 		spin_lock_bh(&vvs->rx_lock);
 
 		total += bytes;
-		skb_pull(skb, bytes);
 
-		if (skb->len == 0) {
+		VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;
+
+		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
 
 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
@@ -503,9 +506,10 @@ virtio_transport_seqpacket_do_peek(struct vsock_sock *vsk,
 			spin_unlock_bh(&vvs->rx_lock);
 
 			/* sk_lock is held by caller so no one else can dequeue.
-			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 			 */
-			err = memcpy_to_msg(msg, skb->data, bytes);
+			err = skb_copy_datagram_iter(skb, VIRTIO_VSOCK_SKB_CB(skb)->offset,
+						     &msg->msg_iter, bytes);
 			if (err)
 				return err;
 
@@ -564,11 +568,13 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				int err;
 
 				/* sk_lock is held by caller so no one else can dequeue.
-				 * Unlock rx_lock since memcpy_to_msg() may sleep.
+				 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 				 */
 				spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
+				err = skb_copy_datagram_iter(skb, 0,
+							     &msg->msg_iter,
+							     bytes_to_copy);
 				if (err) {
 					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
-- 
2.53.0



