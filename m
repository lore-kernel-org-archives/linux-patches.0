Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B1A27FD4A;
	Wed, 28 Jan 2026 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615378; cv=none; b=k3vLTqtTDyshCL2iTO/5I8fhsgi25i0MxuqcF5KjG6DugnOgogZTyPNpr3REOoniEJTBjngU1+nB/hQwgL81bITR9t3erQ9eQUf1E37Jt/DE//djCCUs6UWXh/MkZ5UEa5FDlMZnD+muEN7t4OqheaBAsnl7nVWvBhxnxv53eoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615378; c=relaxed/simple;
	bh=8VF/3oDm5oCyfIcKNvV1ojQk2hLqqnygG7FZDMQuR7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj3yPB3/bOLbUQEJa1dHXXijYNjqKtr/fHb25LJT8Z5q5eaQQ92Km7DhO/Obvnuz5gEmMxlVYX5WV4wTrPO7ZEbczMURZzFSZNaa+Ud7xI7Lo33pXEwoTO2BAtvgEc4CbtmXbE41MurayTaZjruyYDL6pVh6NMt0SIN32DB4uHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkzV7JKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkzV7JKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68681C4CEF1;
	Wed, 28 Jan 2026 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615377;
	bh=8VF/3oDm5oCyfIcKNvV1ojQk2hLqqnygG7FZDMQuR7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkzV7JKcgloiFepX4BZLlR2DE1ZAirJ6P+Q5Hey2kOzDh/HmXIL7Wxy1mhhVb/fVs
	 fk8bMibNQfWJpdv0TxMq4mRk9ElrIf7ykqKOXSh0DDVt+jZ2wJVaoUNAtpMzSXQyct
	 eGhC0iSWHdGh6kPJoZjYgsUihuBrLQrtUd0vogzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernel-dev@igalia.com, Heitor Alves de Siqueira" <halves@igalia.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 162/169] vsock/virtio: Move length check to callers of virtio_vsock_skb_rx_put()
Date: Wed, 28 Jan 2026 16:24:05 +0100
Message-ID: <20260128145339.850587479@linuxfoundation.org>
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

[Upstream commit 87dbae5e36613a6020f3d64a2eaeac0a1e0e6dc6]

virtio_vsock_skb_rx_put() only calls skb_put() if the length in the
packet header is not zero even though skb_put() handles this case
gracefully.

Remove the functionally redundant check from virtio_vsock_skb_rx_put()
and, on the assumption that this is a worthwhile optimisation for
handling credit messages, augment the existing length checks in
virtio_transport_rx_work() to elide the call for zero-length payloads.
Since the callers all have the length, extend virtio_vsock_skb_rx_put()
to take it as an additional parameter rather than fish it back out of
the packet header.

Note that the vhost code already has similar logic in
vhost_vsock_alloc_skb().

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-4-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c            |    2 +-
 include/linux/virtio_vsock.h     |    9 ++-------
 net/vmw_vsock/virtio_transport.c |    4 +++-
 3 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -376,7 +376,7 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 		return NULL;
 	}
 
-	virtio_vsock_skb_rx_put(skb);
+	virtio_vsock_skb_rx_put(skb, payload_len);
 
 	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
 	if (nbytes != payload_len) {
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -47,14 +47,9 @@ static inline void virtio_vsock_skb_clea
 	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = false;
 }
 
-static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb)
+static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb, u32 len)
 {
-	u32 len;
-
-	len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
-
-	if (len > 0)
-		skb_put(skb, len);
+	skb_put(skb, len);
 }
 
 static inline struct sk_buff *virtio_vsock_alloc_skb(unsigned int size, gfp_t mask)
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -656,7 +656,9 @@ static void virtio_transport_rx_work(str
 				continue;
 			}
 
-			virtio_vsock_skb_rx_put(skb);
+			if (payload_len)
+				virtio_vsock_skb_rx_put(skb, payload_len);
+
 			virtio_transport_deliver_tap_pkt(skb);
 			virtio_transport_recv_pkt(&virtio_transport, skb);
 		}


