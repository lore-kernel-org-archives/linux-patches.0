Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2063B840B;
	Tue, 16 Jun 2026 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624669; cv=none; b=X1S92Xgmtn6YA672k15byXs3OBd61CedZnUcKDL02FsmCN/Rd5dNPFHBgv6FBWx+sQ7knqNbA/6/jXSrDBrhB3f/GxHXwUuCDx2OmXTujGRUqqU6V2LqGdC0WgZ9ukVyijEs0gkgfF61dTUuGHwcHdtH3whHDuUiXzLT4AyKWoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624669; c=relaxed/simple;
	bh=PZeyafYMYVyZjRKkxAQMpvbt05/bmQOnxIp/lkbjrHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Brh9CkCCHgOzrWIE8uSMNTNuMlrEpUUGrN7hzvwh0G252ah/WJJUv8lip5gvgKcz4dcapVhTknHaSXq/i9oIAi6gQy+qbXZcU4WanDFN1Ym227fQMMNo6T+IMV7TaYCUxCXQb9uyd3VIqSy2MWIXoyIdzzt6dh6w3eCVULFUlQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo2TLPBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo2TLPBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E9B1F00A3A;
	Tue, 16 Jun 2026 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624667;
	bh=MEi8fmaT69eva8Z2mi2Lq2i7AadW0sf3G3upSDxgpHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xo2TLPBsm3425trJCwYJffvc7X77lD3nGlH+rzbXvrqbj41UNvBUZdeMBnDdVh6V0
	 rOTzsvQm/KXKXKj9J7CngQXyRdGz+xzhWBzuRk37KOWtKN7lwfeJn4Sg3NmO+rRW82
	 lrzbJpxB70C28ZvFwA91zn6uzfys5/hZGV4ZJxIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 371/378] vsock/virtio: fix skb overhead accounting to preserve full buf_alloc
Date: Tue, 16 Jun 2026 20:30:02 +0530
Message-ID: <20260616145129.638510255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit c6087c5aaad6d1b8be1a1a641e0a422218ade911 upstream.

After commit 059b7dbd20a6 ("vsock/virtio: fix potential unbounded skb
queue"), virtio_transport_inc_rx_pkt() subtracts per-skb overhead from
buf_alloc when checking whether a new packet fits. This reduces the
effective receive buffer below what the user configured via
SO_VM_SOCKETS_BUFFER_SIZE, causing legitimate data packets to be
silently dropped and applications that rely on the full buffer size
to deadlock.

Also, the reduced space is not communicated to the remote peer, so
its credit calculation accounts more credit than the receiver will
actually accept, causing data loss (there is no retransmission).

With this approach we currently have failures in
tools/testing/vsock/vsock_test.c. Test 18 sometimes fails, while
test 22 always fails in this way:
    18 - SOCK_STREAM MSG_ZEROCOPY...hash mismatch

    22 - SOCK_STREAM virtio credit update + SO_RCVLOWAT...send failed:
    Resource temporarily unavailable

Fix by allowing at most `buf_alloc * 2` as the total budget for payload
plus skb overhead in virtio_transport_inc_rx_pkt(), similar to how
SO_RCVBUF is doubled to reserve space for sk_buff metadata.
This preserves the full buf_alloc for payload under normal operation,
while still bounding the skb queue growth.

With this patch, all tests in tools/testing/vsock/vsock_test.c are
now passing again.

Fixes: 059b7dbd20a6 ("vsock/virtio: fix potential unbounded skb queue")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260518090656.134588-3-sgarzare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -427,7 +427,14 @@ static bool virtio_transport_inc_rx_pkt(
 {
 	u64 skb_overhead = (skb_queue_len(&vvs->rx_queue) + 1) * SKB_TRUESIZE(0);
 
-	if (skb_overhead + vvs->buf_used + len > vvs->buf_alloc)
+	/* Allow at most buf_alloc * 2 total budget (payload + overhead),
+	 * similar to how SO_RCVBUF is doubled to reserve space for sk_buff
+	 * metadata. Check payload against buf_alloc to be sure the other
+	 * peer is respecting the credit, and sk_buff overhead to bound
+	 * queue growth.
+	 */
+	if ((u64)vvs->buf_used + len > vvs->buf_alloc ||
+	    skb_overhead > vvs->buf_alloc)
 		return false;
 
 	vvs->rx_bytes += len;


