Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4773A137932;
	Tue, 26 Aug 2025 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214897; cv=none; b=eF4YoWGa9GUpozqczXTBdKOyNczevdQDj07krQOJv5VH5jDY3k9ipxJQXgtPEKJrBDUPXNoNmKOKTJJmrV92ZRVvasx4AVpJPvA8nGVYJkKkXcKqW2jpNomkaK6H3kisceWYGKhWHDB6o/br3OAc8m3afZKD2+ouFoCLOjFdjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214897; c=relaxed/simple;
	bh=WU+seN7EptUzr77fJNcFC9rABVT5/P9kbiRWMDmq6lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0sV1B7NJwTWoJTHFWccif/BeIRoAOClId1gZh9gPT/jx5W2ksqh9BhVi8f95++M9i+c1b5Q4rISRfMCJkGlv8pxi8kIiGEiE5zZP2b9AWTah9gbG+jzZ6XmOzRv/5iih95pymlc9fAYWH0l9fvjO4/tkY6rOX68EDG/GVA82F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/FduzZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/FduzZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828DFC4CEF1;
	Tue, 26 Aug 2025 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214895;
	bh=WU+seN7EptUzr77fJNcFC9rABVT5/P9kbiRWMDmq6lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/FduzZC5hXzsWC5AClwpQQIB4spixOZiVZDobLF1HNhdXtjphk8uGE1+CxfWQ7Gd
	 X+EqK1Nq0E8CvnP7c8BIo9T+bi+Vie0aij5/GiJdIcpqhktawn3OIGh/u4E1YYYdJg
	 TXHFXWYHYoIp3fGtopIRTFvAhI2HVQCb10rXZrQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 310/482] vhost/vsock: Avoid allocating arbitrarily-sized SKBs
Date: Tue, 26 Aug 2025 13:09:23 +0200
Message-ID: <20250826110938.459455489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -340,6 +340,9 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 
 	len = iov_length(vq->iov, out);
 
+	if (len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM)
+		return NULL;
+
 	/* len contains both payload and hdr */
 	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -363,8 +366,7 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 		return skb;
 
 	/* The pkt is too big or the length in the header is invalid */
-	if (payload_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE ||
-	    payload_len + sizeof(*hdr) > len) {
+	if (payload_len + sizeof(*hdr) > len) {
 		kfree_skb(skb);
 		return NULL;
 	}


