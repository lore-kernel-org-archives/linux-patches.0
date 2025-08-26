Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5492F83C1;
	Tue, 26 Aug 2025 11:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207244; cv=none; b=PzUqRZ63y10cBCW+5Cx9Lz4SinuPihTm6mnjLy/Cd6w1rE4z5rDllKSCjD5E9eAUG38gk94ndYYAPLEdQF14OZtUTQ03bFtAOFGriJh3xNO1JWs3Dub1mqcVIJZnKN7dCe6Mpf0viqJMwjoM/Y3Ccp9NwY5FOEB/7cB2PZZYBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207244; c=relaxed/simple;
	bh=GKXbjDDqK5sKT4UaDV7UA7XlrZKO4qp02VUjdnybEDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agtGIFluj8Vf2Od8+FrMindMMxphIVy1gu9RKOqU6JyL9tTjrgzw3eU40RbwRZ8XhS12XpF9AYOBkIEZ2F10/qaoOCC97eAWiLVjx/YAb09Dt8ZQBs/cu3QIn6fy4+IUit3/wk26CF2wUIuSR0AkFWfHt3xMnNYHeZ99h9LIQrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiUa0ki/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiUa0ki/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6F5C4CEF1;
	Tue, 26 Aug 2025 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207244;
	bh=GKXbjDDqK5sKT4UaDV7UA7XlrZKO4qp02VUjdnybEDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiUa0ki/hgftfQzHWOoN5A4+WW2uPr+MTGCUDPKr9A1N2/gwWC/B7kGgLIfX4l6Ug
	 nn0c5NYgub/9nknyFYMc4fFqrqA5oEcVWzoZJ/VbD1ya7ANlZDqMp6kIVCekZWcRPN
	 CjEFbG5den2Ga44LKbTb/m9snHW2ziaVJcDvsBwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.16 106/457] vhost/vsock: Avoid allocating arbitrarily-sized SKBs
Date: Tue, 26 Aug 2025 13:06:30 +0200
Message-ID: <20250826110939.994507477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


