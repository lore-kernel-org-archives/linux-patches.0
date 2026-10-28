Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216825;
	b=KaQFUPzL8zqQ9oeoonwuhKRE290QtT8T09d76YwwhxuTMSEpTVOqEOO6KEL+o5Qbl/up
	 4+EoWXxfvYvyhkVyd8gF2FGDuFDqgureYC/h01XjQEvRINQnyNxyKoy9Pe8yuhyGRkQuo
	 XD3Dhz84CTdJWoRjIvzDbw8fHAk8N3QqGtgls9qVvqNwstDTTV7BzHrT1/SKalk9+xbvJ
	 8Hp5Lgcsk3OFLpCLG3a0n7NANtapIko7tC3txQGnMPtDBNGKBdGczgtPrvMz0tX/ZPgnL
	 5pu4QBNhQKTbev4pnN/bRLzDFY6pVRMDIWzmgNGNaFr3bLhCVpDEwiX+9W2zIicCYtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LicnQNuUYJMQ70lbggxwb0VmCRNWghm6V6RQr0b6aoI=;
	b=tIO36gu/R3gsto0JkR4YFRBCi+GCrSy8WQam+QvtcfptbxLGXVdyUggIKEYChr1K9UR1
	 mJE61oEy0iv4FNo2U9Uj1vtK9pelnzBZoS9FFmyd/ui2J3vw4XkEeePILHDAB4Vr2SnZf
	 JPyiRKcI/UEWrxzLOu10Fm0fA8DLHz4BfYj6TzPeUCZ/IAAw4wX2k3An7rH4u341qhZLU
	 y2JJwDD1+ED0J0G6PwGLWO5XHlfqUV6jyftOnCzzV8kD8XYtnhtZsN5xorKZ+i/u/bwB6
	 Wooc0Vv/KmVvjjIZTvJw/oFMHHoxUlLkVraxx1eZhap5XNJRjI3Bgq8RVg22leNsJYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyAkw2qS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FCE606A31A;
	Wed, 28 Oct 2026 19:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyAkw2qS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23301F01825;
	Wed, 28 Oct 2026 19:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216825;
	bh=LicnQNuUYJMQ70lbggxwb0VmCRNWghm6V6RQr0b6aoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyAkw2qSJ+p947qi3GkhJ4B/wXfQ1a+x+IHn7LxYOjJc0FyiegSyvhoDWywC/qwax
	 6FOfZF/0hV//DxWpaSEit32jdg/hnj8ucAUqtj1C0kHccKSz4oYvjNvB4zkiswz0xB
	 eUN18CpeR8sODWZAlI5iFPokNsNz4WSqYQziCslg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1648/1887] svcrdma: Reject Write/Reply chunks with segcount 0
Date: Wed, 28 Oct 2026 18:02:24 +0100
Message-ID: <20261028170536.966689224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit 9808eb7656666acc7291bae9ab6b987bd16e47e0 ]

A peer can send a Write or Reply chunk whose segcount field is zero.
xdr_check_write_chunk() only rejects segcount > rc_maxpages, so zero
passes the range check, and xdr_inline_decode(stream, 0) returns the
current (non-NULL) cursor without advancing. The function returns
true and pcl_alloc_write() then links a struct svc_rdma_chunk with
ch_segcount == 0 onto rc_write_pcl or rc_reply_pcl.

An earlier patch in this series made pcl_for_each_segment() safe for
ch_segcount == 0, so this no longer drives the memory walk it used
to. Rejecting the malformed frame at the decode boundary is still
worthwhile as defense in depth: it keeps degenerate zero-segment
chunks off the parsed chunk lists entirely, so any future consumer
that walks ch_segments directly cannot observe one, and it makes the
zero-floor easy to backport to trees where the macro change is more
intrusive. RFC 8166 has no meaning for a Write/Reply chunk that
describes no remote buffer, so no legitimate client is affected.

xdr_check_reply_chunk() funnels Reply chunks through
xdr_check_write_chunk() and inherits the same rejection.

pcl_alloc_write() also links each chunk onto the parsed chunk list
before filling its segment array. If a future change weakens the
segcount-0 rejection, an incomplete chunk is visible to consumers
during the fill loop. Reorder so that list_add_tail() follows the
segment fill loop, ensuring only fully-populated chunks appear on
the list.

Fixes: 78147ca8b4a9 ("svcrdma: Add a "parsed chunk list" data structure")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-rpc-kernel-bugs-v1-5-e251306ccca9@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_pcl.c      | 2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_pcl.c b/net/sunrpc/xprtrdma/svc_rdma_pcl.c
index b63cfeaa29234..a1c61311714da 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_pcl.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_pcl.c
@@ -213,7 +213,6 @@ bool pcl_alloc_write(struct svc_rdma_recv_ctxt *rctxt,
 		chunk = pcl_alloc_chunk(segcount, 0);
 		if (!chunk)
 			return false;
-		list_add_tail(&chunk->ch_list, &pcl->cl_chunks);
 
 		for (j = 0; j < segcount; j++) {
 			segment = &chunk->ch_segments[j];
@@ -225,6 +224,7 @@ bool pcl_alloc_write(struct svc_rdma_recv_ctxt *rctxt,
 			chunk->ch_length += segment->rs_length;
 			chunk->ch_segcount++;
 		}
+		list_add_tail(&chunk->ch_list, &pcl->cl_chunks);
 	}
 	return true;
 }
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index b66ded5b039a8..06c64aeed5fdb 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -491,10 +491,13 @@ static bool xdr_check_write_chunk(struct svc_rdma_recv_ctxt *rctxt)
 		return false;
 
 	/* Before trusting the segcount value enough to use it in
-	 * a computation, perform a simple range check. This is an
-	 * arbitrary but sensible limit (ie, not architectural).
+	 * a computation, perform a simple range check. A zero
+	 * segcount describes no remote buffer and is rejected so
+	 * downstream consumers never see a degenerate ch_segcount==0
+	 * chunk. The upper bound is an arbitrary but sensible limit
+	 * (ie, not architectural).
 	 */
-	if (unlikely(segcount > RPCSVC_MAXPAGES))
+	if (segcount == 0 || unlikely(segcount > RPCSVC_MAXPAGES))
 		return false;
 
 	p = xdr_inline_decode(&rctxt->rc_stream,
-- 
2.53.0



