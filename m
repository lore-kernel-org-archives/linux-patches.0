Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075182DF155;
	Wed, 28 Jan 2026 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615391; cv=none; b=VCuKkG6cBGFYvisBAruO9eD0/3W6XgYFFKOHMoQl+TJO4LRfj48nVguds864kO5qnoNFAiVplaLRRGX++HhjD6fS/Oo8B3bOMOiy2gHTtZPztSdP6DI63NJRutptSG6Yp7Tc7qThQzlGtfawU05ZcQh2dhdNMJ/X1sHFsBQIyCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615391; c=relaxed/simple;
	bh=tj6bcOrchwMiXJqJq7Pm+J4lJRM17a+NC7ijqZ0rlzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brikFm42/OygLS1FsygPVj4HsGH/xEw/bZ6dTIYE6yJeRIl3Ak4+H6agYvOUNNvUrv5NU6D8m9srcYQ9AsEvkNv75bojjc7DLwOrmiy0ULcEjOe6TCAIqSaYHi3fxRMSDQEL8MeGiM85s++cHPK9BSAU1z+Zx3UIMf/1CeGeOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pqgo6d3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pqgo6d3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5639AC4CEF1;
	Wed, 28 Jan 2026 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615390;
	bh=tj6bcOrchwMiXJqJq7Pm+J4lJRM17a+NC7ijqZ0rlzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pqgo6d3su2jt4OXppriopJTAimz37Zj3qkm4trjb/zpLbrHjk6Ciziwm9t4WygMu
	 y4w8qeC/RmtiVL70nXXmJkHgvKOHV1jgF8ctPs8JQS3I/p3hPbX+e+diJ2khxubM0j
	 0FWMvcg6Dcam5e5IAWWYKzYg5Da1EEE6TxUG2Sks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernel-dev@igalia.com, Heitor Alves de Siqueira" <halves@igalia.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 166/169] vhost/vsock: Allocate nonlinear SKBs for handling large receive buffers
Date: Wed, 28 Jan 2026 16:24:09 +0100
Message-ID: <20260128145340.000408047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[Upstream commit ab9aa2f3afc2713c14f6c4c6b90c9a0933b837f1]

When receiving a packet from a guest, vhost_vsock_handle_tx_kick()
calls vhost_vsock_alloc_linear_skb() to allocate and fill an SKB with
the receive data. Unfortunately, these are always linear allocations and
can therefore result in significant pressure on kmalloc() considering
that the maximum packet size (VIRTIO_VSOCK_MAX_PKT_BUF_SIZE +
VIRTIO_VSOCK_SKB_HEADROOM) is a little over 64KiB, resulting in a 128KiB
allocation for each packet.

Rework the vsock SKB allocation so that, for sizes with page order
greater than PAGE_ALLOC_COSTLY_ORDER, a nonlinear SKB is allocated
instead with the packet header in the SKB and the receive data in the
fragments. Finally, add a debug warning if virtio_vsock_skb_rx_put() is
ever called on an SKB with a non-zero length, as this would be
destructive for the nonlinear case.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-8-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c        |    8 +++-----
 include/linux/virtio_vsock.h |   32 +++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -350,7 +350,7 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 		return NULL;
 
 	/* len contains both payload and hdr */
-	skb = virtio_vsock_alloc_linear_skb(len, GFP_KERNEL);
+	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
 	if (!skb)
 		return NULL;
 
@@ -379,10 +379,8 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 
 	virtio_vsock_skb_put(skb, payload_len);
 
-	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
-	if (nbytes != payload_len) {
-		vq_err(vq, "Expected %zu byte payload, got %zu bytes\n",
-		       payload_len, nbytes);
+	if (skb_copy_datagram_from_iter(skb, 0, &iov_iter, payload_len)) {
+		vq_err(vq, "Failed to copy %zu byte payload\n", payload_len);
 		kfree_skb(skb);
 		return NULL;
 	}
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -49,22 +49,48 @@ static inline void virtio_vsock_skb_clea
 
 static inline void virtio_vsock_skb_put(struct sk_buff *skb, u32 len)
 {
-	skb_put(skb, len);
+	DEBUG_NET_WARN_ON_ONCE(skb->len);
+
+	if (skb_is_nonlinear(skb))
+		skb->len = len;
+	else
+		skb_put(skb, len);
 }
 
 static inline struct sk_buff *
-virtio_vsock_alloc_linear_skb(unsigned int size, gfp_t mask)
+__virtio_vsock_alloc_skb_with_frags(unsigned int header_len,
+				    unsigned int data_len,
+				    gfp_t mask)
 {
 	struct sk_buff *skb;
+	int err;
 
-	skb = alloc_skb(size, mask);
+	skb = alloc_skb_with_frags(header_len, data_len,
+				   PAGE_ALLOC_COSTLY_ORDER, &err, mask);
 	if (!skb)
 		return NULL;
 
 	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
+	skb->data_len = data_len;
 	return skb;
 }
 
+static inline struct sk_buff *
+virtio_vsock_alloc_linear_skb(unsigned int size, gfp_t mask)
+{
+	return __virtio_vsock_alloc_skb_with_frags(size, 0, mask);
+}
+
+static inline struct sk_buff *virtio_vsock_alloc_skb(unsigned int size, gfp_t mask)
+{
+	if (size <= SKB_WITH_OVERHEAD(PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
+		return virtio_vsock_alloc_linear_skb(size, mask);
+
+	size -= VIRTIO_VSOCK_SKB_HEADROOM;
+	return __virtio_vsock_alloc_skb_with_frags(VIRTIO_VSOCK_SKB_HEADROOM,
+						   size, mask);
+}
+
 static inline void
 virtio_vsock_skb_queue_head(struct sk_buff_head *list, struct sk_buff *skb)
 {


