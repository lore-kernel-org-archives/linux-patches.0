Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C935C1A0;
	Tue, 21 Jul 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660496; cv=none; b=ljuaPBgAK1pLlX93IOH3XgLCWbZr90aEGZTjmuvsiOJSEeG6NmFq9+A7y106V4fSUHrb+04bxXyjuxtsfzZGACEfJWELhscHHzVkHmG6UoFYaRA2PQ51Vtc9qphgXIy62SjT/Hp+mYayfKAsflR2kq4GXZC4BoHlMBXK65iTSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660496; c=relaxed/simple;
	bh=d4bIWEgyNhI+xYAPCD8/9GX9rko4+cVwvOodUj2zNw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLfO0d4trh4S9tfDk6tsrF6TMAI6263peYA8pQJOfBYm9n/K2fwXpLl+MreVFq9y0mHDKXa5c2PhzhDAXPtisvmqCx7N/muFfwv+fvRnoNHbRTGm3RbV2mlJD7K+pyO0BpGYFKCRy+AktN923ixE6bGQItFugDI0fteOdz7bGXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIB1P89h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIB1P89h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A92E1F01564;
	Tue, 21 Jul 2026 19:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660483;
	bh=Exyi7jZR24QvDPZejBIOA6lmcJLOS1YXKISQxt4GGWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIB1P89h9aiPlmnqSKpTp1ex1kDdPAMMwlP1i3tO6cyZNqfMuEYaoKdkLSuZCP8d+
	 6HsGTMF0glHc6iJC/w/w0UUzXFvSlfYkAT86X5jOjvTX7AwjjKEKOD6bkZtH8iadd4
	 IY+H2CUOLygZ5F10kUS2WQKAVLTzAPJsAfP+79os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0996/2077] xprtrdma: Resize reply buffers before reposting receives
Date: Tue, 21 Jul 2026 17:11:09 +0200
Message-ID: <20260721152616.310883147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 234c0ff695ef3ffb656931000e6b823d0c2f30fd ]

Commit 0e13dd9ea8be ("xprtrdma: Remove temp allocation of
rpcrdma_rep objects") made rpcrdma_rep objects survive disconnects.
That is normally fine, but it also means their receive regbufs keep
the size they had when they were first allocated.

Each rep's receive buffer is sized to ep->re_inline_recv when the rep
is created. rpcrdma_ep_create() resets that threshold to the
rdma_max_inline_read ceiling for every new endpoint, and the connect
handshake then shrinks it to the peer's advertised inline send size.
A rep allocated under a smaller negotiated threshold keeps that size:
on disconnect, rpcrdma_xprt_disconnect() drains and DMA-unmaps the
surviving reps but does not free or resize them.

The threshold can come back larger on the next connection. The first
peer may supply no RPC-over-RDMA CM private data, defaulting its send
size to 1024, while the reconnect target is an ordinary server
offering 4096; or, with rdma_max_inline_read raised above its default,
the reconnect target may advertise a larger svcrdma_max_req_size than
the first. rpcrdma_post_recvs() then reposts a surviving rep whose SGE
length is still the old, smaller value, and a larger inline Reply hits
a receive length error and forces another disconnect.

The undersized rep returns to the free list when its failed Receive
flushes, so the following reconnect reposts the same rep and fails the
same way. The transport flaps without making forward progress for as
long as the peer keeps advertising the larger inline size.

This is local/admin-triggerable rather than remote-triggerable: a local
administrator must create and maintain the NFS/RDMA mount, while the
server or reconnect target has to advertise a larger inline send size
and return a reply that uses it.

Fix this by checking each rep before it is reposted. If the receive
regbuf is smaller than the current endpoint's inline receive size,
reallocate it on the current RDMA device's NUMA node and reinitialize
the rep's xdr_buf before DMA-mapping and posting the Receive WR.

Fixes: 0e13dd9ea8be ("xprtrdma: Remove temp allocation of rpcrdma_rep objects")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ee6c4b18105ba1..6a8370c8f43d9c 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -81,6 +81,8 @@ rpcrdma_regbuf_alloc_node(size_t size, enum dma_data_direction direction,
 			  int node);
 static struct rpcrdma_regbuf *
 rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction);
+static bool rpcrdma_regbuf_realloc_node(struct rpcrdma_regbuf *rb,
+					size_t size, gfp_t flags, int node);
 static void rpcrdma_regbuf_dma_unmap(struct rpcrdma_regbuf *rb);
 static void rpcrdma_regbuf_free(struct rpcrdma_regbuf *rb);
 
@@ -1334,10 +1336,16 @@ rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction)
  * returned, @rb is left untouched.
  */
 bool rpcrdma_regbuf_realloc(struct rpcrdma_regbuf *rb, size_t size, gfp_t flags)
+{
+	return rpcrdma_regbuf_realloc_node(rb, size, flags, NUMA_NO_NODE);
+}
+
+static bool rpcrdma_regbuf_realloc_node(struct rpcrdma_regbuf *rb,
+					size_t size, gfp_t flags, int node)
 {
 	void *buf;
 
-	buf = kmalloc(size, flags);
+	buf = kmalloc_node(size, flags, node);
 	if (!buf)
 		return false;
 
@@ -1349,6 +1357,23 @@ bool rpcrdma_regbuf_realloc(struct rpcrdma_regbuf *rb, size_t size, gfp_t flags)
 	return true;
 }
 
+static bool rpcrdma_rep_resize(struct rpcrdma_xprt *r_xprt,
+			       struct rpcrdma_rep *rep)
+{
+	struct rpcrdma_regbuf *rb = rep->rr_rdmabuf;
+	struct rpcrdma_ep *ep = r_xprt->rx_ep;
+	size_t size = ep->re_inline_recv;
+
+	if (likely(rdmab_length(rb) >= size))
+		return true;
+	if (!rpcrdma_regbuf_realloc_node(rb, size, XPRTRDMA_GFP_FLAGS,
+					 ibdev_to_node(ep->re_id->device)))
+		return false;
+
+	xdr_buf_init(&rep->rr_hdrbuf, rdmab_data(rb), rdmab_length(rb));
+	return true;
+}
+
 /**
  * __rpcrdma_regbuf_dma_map - DMA-map a regbuf
  * @r_xprt: controlling transport instance
@@ -1432,6 +1457,10 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed)
 			break;
 		/* I1: a rep on rb_free_reps must carry no rqst pointer. */
 		WARN_ON_ONCE(rep->rr_rqst);
+		if (!rpcrdma_rep_resize(r_xprt, rep)) {
+			rpcrdma_rep_put(buf, rep);
+			break;
+		}
 		if (!rpcrdma_regbuf_dma_map(r_xprt, rep->rr_rdmabuf)) {
 			rpcrdma_rep_put(buf, rep);
 			break;
-- 
2.53.0



