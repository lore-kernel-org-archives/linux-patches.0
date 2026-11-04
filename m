Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829138;
	b=4Cr+2Df9+z6sqD1ED+gZXMPnZnzNTpFqx/CG2KIRFayOPva3pccs3FeNuBZV2eBh4oW3
	 JeIkma+wxLYMIyr8dzuq6CXqzLZk+qGh2p/0CjSARXcLNEUnRkIdnbXUs9UDe82QriKGR
	 PfdCRmRVzsBeDEP0I4Ed/a8g+DGQU94aHQyvBnhZYDlXT9YFiYWe+UiPJY/5gCHB1IlPc
	 W0ly1mr57+8TuZ/v0Lah8Sa0mDSVS9chU+6fEQhxIQ8YbuRyQfRD2GzwP88clZwffJqKX
	 QuFeI69OITI5mFVlNQHMeJrdgPYvML3byjsnyhO4L7JMSwZFtPXvRXrPRGQupWpTrvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFF4+i3DNo4vPM3iwdtfsP01oFjIkalZJ56dyZPufpw=;
	b=Zp1IdpRe+7u6/FqN68VqqAubR8jua+03z8kyVFXSjZoVBKeLWvBhhmbQQTTQ8MkpsshX
	 QXjRfsGWqRF8b/TPgoHQ4WjDDjoxKU3+YxmtWGId1nZ5iPfRj6fsjTNSCdhM+s/3wJFsJ
	 fFbMsVIzhIcQVNqFjN5mS8geRo9yFdSJKlHpqnTS8nxuE+0kllhVj/cgrRgNvVqVFUL6v
	 CWrV8WCdwqnNEv/NjfP6/j+vBUmLdAoYpMW232LOidxBHOB7QuTyQbTUL/xbUS42Mgvre
	 RnfYJUUwaVUoPFzFWTEzCVG3HlgKP9ihJLixK5eZGdZ/paLY/nxBqieJFZ1oiFPr0Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDZtu0Rv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE160841B4;
	Wed,  4 Nov 2026 21:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDZtu0Rv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3B71F00919;
	Wed,  4 Nov 2026 21:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829138;
	bh=DFF4+i3DNo4vPM3iwdtfsP01oFjIkalZJ56dyZPufpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDZtu0Rv6cJKOeUKMUez69ArA1dyllTpDIoeG4rjy1YCChJJFUiczdxmbW6l+ryh9
	 vu5N1/CyKYfPlvB5p19iPiLK64PS9tBWaYNVBcz8sNu64JgvkqGpQB4KQsVri3YSvQ
	 IJSCymsB/KkVBiM6A6oixlbBYzz8IEgrJhYJ9QtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 434/547] SUNRPC: Copy the deferred RPC Call from the head buffer
Date: Wed,  4 Nov 2026 16:10:18 -0500
Message-ID: <20261104211050.680306746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 2192a56b0686599358909c3e12e9a366f5b5d452 upstream.

svc_defer() snapshots the RPC Call for replay once a pending cache
upcall resolves. It copies the Call starting (rq_arg.len -
head[0].iov_len) bytes before head[0].iov_base, a back-up that once
covered a transport header. No transport has had one since commit
983084b2672c ("SUNRPC: Remove svc_rqst::rq_xprt_hlen"), so the two
lengths are meant to be equal.

An RPCSEC_GSS Call breaks that assumption. Unwrapping the integrity
service truncates rq_arg.len by the length of the trailing checksum,
and unwrapping the privacy service leaves rq_arg.len short by an
amount the client sets with trailing bytes after the wrap token.
Neither adjusts head[0].iov_len. Both lengths are size_t, so the
subtraction underflows and the copy starts past head[0].iov_base.
Every deferred integrity Call replays a shifted snapshot.

A deferred replay skips GSS verification, so a shifted snapshot runs
as an authenticated Call. With the privacy service the offset is
client-chosen. A forged Call placed in that window, naming another
user's GSS context handle, runs under that identity.

Copy the Call from head[0].iov_base. Refuse to defer a Call whose
length runs past the head buffer, so the copy cannot read out of
bounds.

Fixes: 260c1d1298f6 ("svc: Add transport hdr size for defer/revisit")
Cc: stable@vger.kernel.org
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Reported-by: Yilin Zhang <yilinzhang@moonshot.ai>
Link: https://patch.msgid.link/20260902133101.48914-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc_xprt.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1268,13 +1268,8 @@ static void svc_revisit(struct cache_def
 }
 
 /*
- * Save the request off for later processing. The request buffer looks
- * like this:
- *
- * <xprt-header><rpc-header><rpc-pagelist><rpc-tail>
- *
- * This code can only handle requests that consist of an xprt-header
- * and rpc-header.
+ * Save the request off for later processing. Only a Call that fits
+ * entirely in rq_arg.head[0] can be deferred.
  */
 static struct cache_deferred_req *svc_defer(struct cache_req *req)
 {
@@ -1287,8 +1282,11 @@ static struct cache_deferred_req *svc_de
 		dr = rqstp->rq_deferred;
 		rqstp->rq_deferred = NULL;
 	} else {
-		size_t skip;
 		size_t size;
+
+		if (rqstp->rq_arg.len > rqstp->rq_arg.head[0].iov_len)
+			return NULL;
+
 		/* FIXME maybe discard if size too large */
 		size = sizeof(struct svc_deferred_req) + rqstp->rq_arg.len;
 		dr = kmalloc(size, GFP_KERNEL);
@@ -1302,9 +1300,7 @@ static struct cache_deferred_req *svc_de
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 
-		/* back up head to the start of the buffer and copy */
-		skip = rqstp->rq_arg.len - rqstp->rq_arg.head[0].iov_len;
-		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base - skip,
+		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base,
 		       dr->argslen << 2);
 	}
 	dr->xprt_ctxt = rqstp->rq_xprt_ctxt;
@@ -1327,17 +1323,13 @@ static noinline int svc_deferred_recv(st
 
 	trace_svc_defer_recv(dr);
 
-	/* setup iov_base past transport header */
 	rqstp->rq_arg.head[0].iov_base = dr->args;
-	/* The iov_len does not include the transport header bytes */
 	rqstp->rq_arg.head[0].iov_len = dr->argslen << 2;
 	rqstp->rq_arg.page_len = 0;
-	/* The rq_arg.len includes the transport header bytes */
 	rqstp->rq_arg.len     = dr->argslen << 2;
 	rqstp->rq_prot        = dr->prot;
 	memcpy(&rqstp->rq_addr, &dr->addr, dr->addrlen);
 	rqstp->rq_addrlen     = dr->addrlen;
-	/* Save off transport header len in case we get deferred again */
 	rqstp->rq_daddr       = dr->daddr;
 	rqstp->rq_xprt_ctxt   = dr->xprt_ctxt;
 


