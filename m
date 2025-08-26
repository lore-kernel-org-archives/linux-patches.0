Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707262BE62B;
	Tue, 26 Aug 2025 11:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208358; cv=none; b=IqS83IdMvERr563fPOA4M1CxsfRlyJwjcCBEtX8gYgSLnYCapQboXGqohy3uoew4w5QIn9VQbLLQtmkouB4QTD1TP3HSer6SVOox9h7YpIeCVld8c7DIRLyfFrRq4nPd3WalmYIMTPmtUbd3MKR6HqD1EFXn0foEljhO7jsShvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208358; c=relaxed/simple;
	bh=pEF6bqp1bTF3HTYrZ2IHhx+OD1v5OLnzhKc/UGkcNdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADfz4dSm1whZ/NcRa2tYl1mjJXHlYXSBAhx9rF/80XttoVVGQiAbESgavFFvYatR+40Ph8JxyBvEKfCq5f5aM9mCUO83d19kbAposB+Q/2mrijtf/N3/li8ICAiAem1+LSCzBDYScAljvamaPXa+OeMaZ7QIhESMlKj4nj8Isc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVfUyDE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVfUyDE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009F7C4CEF1;
	Tue, 26 Aug 2025 11:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208358;
	bh=pEF6bqp1bTF3HTYrZ2IHhx+OD1v5OLnzhKc/UGkcNdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVfUyDE5A4utjxr+Qe/byKoD/lM9ZfPsmLlk5WvUunTtL1LHZKO66dULG0i+HHbQ6
	 L7M8lzZdRoQpHLhmJ0+ki65AJHz3BEMTiMvwyNsTooCU5TlA4Ll+j+vTpkO0KfcUaG
	 RSCb9h40NbI+XcGwZmkPIVMSpFzsLiHQsJHue/TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.12 081/322] vhost/vsock: Avoid allocating arbitrarily-sized SKBs
Date: Tue, 26 Aug 2025 13:08:16 +0200
Message-ID: <20250826110917.621499902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 10a886aaed293c4db3417951f396827216299e3d upstream.

vhost_vsock_alloc_skb() returns NULL for packets advertising a length
larger than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE in the packet header. However,
this is only checked once the SKB has been allocated and, if the length
in the packet header is zero, the SKB may not be freed immediately.

Hoist the size check before the SKB allocation so that an iovec larger
than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE + the header size is rejected
outright. The subsequent check on the length field in the header can
then simply check that the allocated SKB is indeed large enough to hold
the packet.

Cc: <stable@vger.kernel.org>
Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-2-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -344,6 +344,9 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 
 	len = iov_length(vq->iov, out);
 
+	if (len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM)
+		return NULL;
+
 	/* len contains both payload and hdr */
 	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -367,8 +370,7 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 		return skb;
 
 	/* The pkt is too big or the length in the header is invalid */
-	if (payload_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE ||
-	    payload_len + sizeof(*hdr) > len) {
+	if (payload_len + sizeof(*hdr) > len) {
 		kfree_skb(skb);
 		return NULL;
 	}


