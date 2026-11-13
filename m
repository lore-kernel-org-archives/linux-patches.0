Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590434;
	b=qaDDTRTDF2CChabqwwNlkEYgpZQMfHiq83SXnnNKtpKtq6kcZv61Oi9wLVv9tWgn3A2c
	 kKmvB4z3W15rDH1TC5kXsdMnhUpD534T7Qgq0mgGLVi6cWH0db4Di7Am/6X17Pg9FNJ7/
	 TQq3plAbSHNOjT6Tx19A9gkFS3cvR9Z3XyfNjFiMh+mbnS0Vuz5I5fCcyz6t2kFxkivaC
	 KcKdTFzioMQxcdVoSa9GDugKXZW3Q2zWdk+gci7YtKBCy/Odtx78hUIddl8x8CuhD4xj2
	 jkisPNTpkPwQ53i/KmHgKSKbXyO9beTjICKXLRc0n5GGP0dG1KjhK9GUS4skptXdsrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GzfgFD5U3XHtX6LEBsu3Th3Z4v7Td3GRXdg+raXtXv4=;
	b=sI39svpGHVmYtY6en3g10WHK+jRNgmoSwDaQgqLCwQTJV8+6O7ZvXJoHOOc3OFb9mXUn
	 iWu19B31K4Be4otcK3S3Z0RBXyaaHzZFP0XLMC2s6F8/ZiHfYSfEfAEx2FJHOKOcw1RE6
	 rMMKHsrTFZbYldjvOI8zxJXyg51epwfafd0nvAt2L3sh58Ld9zCfPcDCbEY03mdpCBjL/
	 m2fPwiARMeMcIQ65DYLkaLCk0Ome2kuvyI0AGir3Z3dWHxDWt2GL2hf6yTOrsOKuyaWHD
	 I+GI9c+TdQk5UwM+/4dMROFi02O3zU0gdNiz2gKyoNwTeSywaxaKWZrF031sVWPhZ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuAWcd85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734AC606E232;
	Fri, 13 Nov 2026 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuAWcd85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36151F000C6;
	Fri, 13 Nov 2026 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590434;
	bh=GzfgFD5U3XHtX6LEBsu3Th3Z4v7Td3GRXdg+raXtXv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuAWcd85EU1iVm6UxRjsvSBdG8QG3OKajjQYrrTRVw3XypExG8rQE4bjWUesAWX4p
	 Qz+vhmw/9QYazneC2z0yIEj2eu0xZ6HxrUoAnTnQpLDl/Gwkrck0rw5dWluYx7FtyL
	 jcNWVYzRZdDD5TGrZn3RJ6vqN5bX6aRXXhIyH298=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 394/686] vhost/vsock: size receive SKBs from declared payload
Date: Fri, 13 Nov 2026 10:48:47 -0500
Message-ID: <20261113153834.356167012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit d5e912448cd98b261eba8e35ab838f2dc69a79f5 ]

vhost_vsock_alloc_skb() sizes the skb from iov_length(), the total guest
descriptor length.  virtio_transport_inc_rx_pkt() instead adds hdr->len to
rx_bytes and buf_used, and budgets each queued skb as SKB_TRUESIZE(0).  The
guest controls the descriptor length and hdr->len independently.

A guest can therefore provide a 64 KiB descriptor while declaring a zero
payload.  The descriptor-sized skb remains queued, rx_bytes and buf_used
remain unchanged, and only the fixed queue-entry budget limits retention.
This is not a lifetime leak: the skb is freed when dequeued or at socket
teardown.  Repeating this across connections can nevertheless exhaust host
memory.  On Linux v7.2, 455 such descriptors retained 30,255,680 bytes for
a 262,144-byte receive buffer; a full-payload control retained 265,984
bytes.

Vhost previously read hdr->len and allocated pkt->buf from that value.  The
conversion from virtio_vsock_pkt to sk_buff instead allocated receive skbs
from the descriptor length, introducing the allocation-accounting mismatch.

Copy the header into a stack object and validate hdr->len before allocating
the skb.  Size the allocation as sizeof(hdr) + payload_len so descriptor
capacity no longer determines queued memory.  Check payload_len against
len - sizeof(hdr) to avoid addition overflow on 32-bit hosts.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20261004235101.1464007-1-4ncienth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 65297f245b272..f00182e9efec0 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -331,7 +331,7 @@ static struct sk_buff *
 vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 		      unsigned int out, unsigned int in)
 {
-	struct virtio_vsock_hdr *hdr;
+	struct virtio_vsock_hdr hdr;
 	struct iov_iter iov_iter;
 	struct sk_buff *skb;
 	size_t payload_len;
@@ -349,34 +349,32 @@ vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 	    len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM)
 		return NULL;
 
-	/* len contains both payload and hdr */
-	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
 	iov_iter_init(&iov_iter, ITER_SOURCE, vq->iov, out, len);
 
-	hdr = virtio_vsock_hdr(skb);
-	nbytes = copy_from_iter(hdr, sizeof(*hdr), &iov_iter);
-	if (nbytes != sizeof(*hdr)) {
+	nbytes = copy_from_iter(&hdr, sizeof(hdr), &iov_iter);
+	if (nbytes != sizeof(hdr)) {
 		vq_err(vq, "Expected %zu bytes for pkt->hdr, got %zu bytes\n",
-		       sizeof(*hdr), nbytes);
-		kfree_skb(skb);
+		       sizeof(hdr), nbytes);
 		return NULL;
 	}
 
-	payload_len = le32_to_cpu(hdr->len);
+	payload_len = le32_to_cpu(hdr.len);
+
+	/* The pkt is too big or the length in the header is invalid */
+	if (payload_len > len - sizeof(hdr))
+		return NULL;
+
+	/* Allocate only for the payload declared in the header. */
+	skb = virtio_vsock_alloc_skb(payload_len + sizeof(hdr), GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	memcpy(virtio_vsock_hdr(skb), &hdr, sizeof(hdr));
 
 	/* No payload */
 	if (!payload_len)
 		return skb;
 
-	/* The pkt is too big or the length in the header is invalid */
-	if (payload_len + sizeof(*hdr) > len) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
 	virtio_vsock_skb_put(skb, payload_len);
 
 	if (skb_copy_datagram_from_iter(skb, 0, &iov_iter, payload_len)) {
-- 
2.53.0



