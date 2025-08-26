Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDD7242D6A;
	Tue, 26 Aug 2025 13:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213541; cv=none; b=rKM7bm8ueHlnYBpWt4MmwFq5sT21oTPEY+LJRtz+68zxO0XQt5XukBMyEIuV+itGMCCBu1YvQ3IWhw9cCVzopDcYkLKrs+kjRaVjFIt2aBRDmdrw4ogtRstUsXb7YLmCVslnCX9uaxalRF8Kd6VzguvGyQrg8sIpULW3wYUQeHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213541; c=relaxed/simple;
	bh=7obho7UFx38bScCwidz5bZTIrbg9wrbYGkgaR842tZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYD3BTRqoONomvmaTW5M9HG7cZk9IM/t1uKxmHQ0VcjJytNDJG1Z6ZRaWit9qeIK5kxjYa1MD0YzcEgRTjbZ7r7SuAt/dj3mrU6t7vxVifCk6rSAEbsV6YQu7sMMnGTYX+WIe5uvfxszQTMJSr/74E+J0VyW6BN9h4lXInz1AgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SemD0CdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SemD0CdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DADC19421;
	Tue, 26 Aug 2025 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213541;
	bh=7obho7UFx38bScCwidz5bZTIrbg9wrbYGkgaR842tZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SemD0CdSFzE7OQ8vy5gXirTGajONH1GG82J3004up6SNK8TzfJ05cHwP9YbybgmCV
	 ik3uXtAVoo4qMar+GsqIRgyt3xe/gpXYRR+MRY7OWDtBqcnsurNaRTQEqn1hcMswcG
	 53rFIvack8OeFcS5Gbl2WkBhnB9xEpB/2CpobK5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 387/587] vhost/vsock: Avoid allocating arbitrarily-sized SKBs
Date: Tue, 26 Aug 2025 13:08:56 +0200
Message-ID: <20250826111002.758593819@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


