Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFE02E2DF4;
	Wed, 28 Jan 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615640; cv=none; b=Bfw/H9qvFZFCDBQkbPlhkt9ngo5jPfygLrxHrQhG/LrXRLE7vKhL8SZ1h9/FQXIfqpWXn1PNYB1UuG8eZdG3ULPzQwDA2ko1YmaxAg3EC3mKlXcnDiUGyrsxeI/ZjX9SVoDS4x3GDTN2qntLTLPjPEPdYKVrAkOkAitgFJib7os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615640; c=relaxed/simple;
	bh=pzrdnueCqbSOy+/PJbIMn1JgSrJ5z9RxPWFdgpkJeZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dais1VerqOK1nC8BXYhb565O6JGWDGWrL/83xjSOIZ2bwrbAmwQlcs5AuYx9mvAxtCfJ54Re1rlLOnHIWgcw1cuTr5xO6aYtdvrqMsNwhLAkPCPxkajiXggcn/TdHYvnmrJkERm6mafV6QHUy4iF4ecFqEmJMKFgp7wOuX4R21c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnvg7eel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnvg7eel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F285C4CEF1;
	Wed, 28 Jan 2026 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615640;
	bh=pzrdnueCqbSOy+/PJbIMn1JgSrJ5z9RxPWFdgpkJeZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnvg7eelWOmjcx08QQ63TQm2jsUSIhCDBJ0WcCWiDVSFX89BNwNsiFhbYykvRhY9K
	 iFeuMqzBwM7Gj0oTkNYgpgNB8gIufhxmOnN8tNQ/uj9QxMxSTPqW6BQPtMOyQtU85/
	 X1Y2IPFX6KyrmNUnJdI8NPZfOlaxKK0gyPGW/pns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/227] vsock/virtio: Coalesce only linear skb
Date: Wed, 28 Jan 2026 16:21:12 +0100
Message-ID: <20260128145345.322972691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 0386bd321d0f95d041a7b3d7b07643411b044a96 ]

vsock/virtio common tries to coalesce buffers in rx queue: if a linear skb
(with a spare tail room) is followed by a small skb (length limited by
GOOD_COPY_LEN = 128), an attempt is made to join them.

Since the introduction of MSG_ZEROCOPY support, assumption that a small skb
will always be linear is incorrect. In the zerocopy case, data is lost and
the linear skb is appended with uninitialized kernel memory.

Of all 3 supported virtio-based transports, only loopback-transport is
affected. G2H virtio-transport rx queue operates on explicitly linear skbs;
see virtio_vsock_alloc_linear_skb() in virtio_vsock_rx_fill(). H2G
vhost-transport may allocate non-linear skbs, but only for sizes that are
not considered for coalescence; see PAGE_ALLOC_COSTLY_ORDER in
virtio_vsock_alloc_skb().

Ensure only linear skbs are coalesced. Note that skb_tailroom(last_skb) > 0
guarantees last_skb is linear.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260113-vsock-recv-coalescence-v2-1-552b17837cf4@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dcc8a1d5851e6..26b979ad71f09 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1359,9 +1359,11 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 
 	/* Try to copy small packets into the buffer of last packet queued,
 	 * to avoid wasting memory queueing the entire buffer with a small
-	 * payload.
+	 * payload. Skip non-linear (e.g. zerocopy) skbs; these carry payload
+	 * in skb_shinfo.
 	 */
-	if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue)) {
+	if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue) &&
+	    !skb_is_nonlinear(skb)) {
 		struct virtio_vsock_hdr *last_hdr;
 		struct sk_buff *last_skb;
 
-- 
2.51.0



