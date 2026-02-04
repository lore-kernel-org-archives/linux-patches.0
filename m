Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81BB41C301;
	Wed,  4 Feb 2026 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217902; cv=none; b=nCPPI7VAcOthQSRLQv2aHQmFQRKUZTLtSZJglmoFoK+oA0rfrxULh8+8wC0h4UniFIzJwKahAFgxMFlOBqlgGd/VZZ+OPejCe2RM8GldVACr5tVP/cpZLkqi5+f5KnSagQc3fX92dzQtHfNhQudD/zi6illT6RcZHocLrZVy/3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217902; c=relaxed/simple;
	bh=qDTtSyWM7sa/mxHb/tsyasTaeEwbs0KY1L/5cDYc6Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkKSpvRfJh7r/XwMz4DlX2iKpO3JRUV8J4z8tAGic6gHEdjQw7IClKCeahr9IdxcPQ1MHFVWFeUs4ruvV7/jT2hF8qAjM8tXycg0GOqtG8S4A1TXqAajw2wtLLXj3HviP827qAmry4FL+jOBSIrdcMSpfqgStTXoL5QoozV1p1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qD0UPqoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qD0UPqoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE1EC4CEF7;
	Wed,  4 Feb 2026 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217902;
	bh=qDTtSyWM7sa/mxHb/tsyasTaeEwbs0KY1L/5cDYc6Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qD0UPqoEarZFuUKg5s9ose04qdwMjglleG5Q4kra+oHSo0UHYjEup2Y1H+1cQHV8P
	 6thcdRuqhIZExTptULEUnFDUf9DjY+v9uBUuujwt4t6vBEvEgOEkVP3hj5XWVVx93M
	 wiyfx5KnSpbhfy2nEHysRO3KMb8tWU+qfzOZtrx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/280] vsock/virtio: cap TX credit to local buffer size
Date: Wed,  4 Feb 2026 15:38:46 +0100
Message-ID: <20260204143915.099480016@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melbin K Mathew <mlbnkm1@gmail.com>

[ Upstream commit 8ee784fdf006cbe8739cfa093f54d326cbf54037 ]

The virtio transports derives its TX credit directly from peer_buf_alloc,
which is set from the remote endpoint's SO_VM_SOCKETS_BUFFER_SIZE value.

On the host side this means that the amount of data we are willing to
queue for a connection is scaled by a guest-chosen buffer size, rather
than the host's own vsock configuration. A malicious guest can advertise
a large buffer and read slowly, causing the host to allocate a
correspondingly large amount of sk_buff memory.
The same thing would happen in the guest with a malicious host, since
virtio transports share the same code base.

Introduce a small helper, virtio_transport_tx_buf_size(), that
returns min(peer_buf_alloc, buf_alloc), and use it wherever we consume
peer_buf_alloc.

This ensures the effective TX window is bounded by both the peer's
advertised buffer and our own buf_alloc (already clamped to
buffer_max_size via SO_VM_SOCKETS_BUFFER_MAX_SIZE), so a remote peer
cannot force the other to queue more data than allowed by its own
vsock settings.

On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
32 guest vsock connections advertising 2 GiB each and reading slowly
drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
recovered after killing the QEMU process. That said, if QEMU memory is
limited with cgroups, the maximum memory used will be limited.

With this patch applied:

  Before:
    MemFree:        ~61.6 GiB
    Slab:           ~142 MiB
    SUnreclaim:     ~117 MiB

  After 32 high-credit connections:
    MemFree:        ~61.5 GiB
    Slab:           ~178 MiB
    SUnreclaim:     ~152 MiB

Only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the guest
remains responsive.

Compatibility with non-virtio transports:

  - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs per
    socket based on the local vsk->buffer_* values; the remote side
    cannot enlarge those queues beyond what the local endpoint
    configured.

  - Hyper-V's vsock transport uses fixed-size VMBus ring buffers and
    an MTU bound; there is no peer-controlled credit field comparable
    to peer_buf_alloc, and the remote endpoint cannot drive in-flight
    kernel memory above those ring sizes.

  - The loopback path reuses virtio_transport_common.c, so it
    naturally follows the same semantics as the virtio transport.

This change is limited to virtio_transport_common.c and thus affects
virtio-vsock, vhost-vsock, and loopback, bringing them in line with the
"remote window intersected with local policy" behaviour that VMCI and
Hyper-V already effectively have.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
[Stefano: small adjustments after changing the previous patch]
[Stefano: tweak the commit message]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20260121093628.9941-4-sgarzare@redhat.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 76329191102a0..bb44a95b43d5a 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -532,6 +532,15 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+static u32 virtio_transport_tx_buf_size(struct virtio_vsock_sock *vvs)
+{
+	/* The peer advertises its receive buffer via peer_buf_alloc, but we
+	 * cap it to our local buf_alloc so a remote peer cannot force us to
+	 * queue more data than our own buffer configuration allows.
+	 */
+	return min(vvs->peer_buf_alloc, vvs->buf_alloc);
+}
+
 int
 virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
@@ -541,7 +550,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 
 	spin_lock_bh(&vvs->tx_lock);
 
-	if (len > vvs->peer_buf_alloc) {
+	if (len > virtio_transport_tx_buf_size(vvs)) {
 		spin_unlock_bh(&vvs->tx_lock);
 		return -EMSGSIZE;
 	}
@@ -595,7 +604,8 @@ static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
 	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
 	 * does not underflow.
 	 */
-	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
+	bytes = (s64)virtio_transport_tx_buf_size(vvs) -
+		(vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (bytes < 0)
 		bytes = 0;
 
-- 
2.51.0



