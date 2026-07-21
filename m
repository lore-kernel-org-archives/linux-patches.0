Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D735C682;
	Tue, 21 Jul 2026 22:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671871; cv=none; b=botMaOgHliMve/IaH5DiTg+08citQGrE7F0qEUE5qRTYo190MRvbeXMghvqSxluD8ujw9Gl/owJ/hj1XdcapNxsXOud7VA7y7fJ0ej+7MuhSMZ91WtnjHu7WRf8myhSO3EV3nVHGHrTTvCaIC9wxvlwFRcGZW9i7DBtswPvrvcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671871; c=relaxed/simple;
	bh=DodsAeCAgmraou46ico94dtEqdBDuJ2HbYD3kEdNT5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1WJ8wCp7403RImr9Ptm0q8MssRanAtAWsFzYu2WC69zp34pYBiqEXsLbZqAQ80B9t1u6W9Zyov3TiXb3cux7zTs8cw+Du28+uavv5rh8ZZ4LEHZqOuw1ZNLg+3spuZgG6VcfJEAumQtjesLetrh1AtvJcUggmq5Ve6G4F9oUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygtljt42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygtljt42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AD81F000E9;
	Tue, 21 Jul 2026 22:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671870;
	bh=mO5kwagd3jy9oN4GkKtEdIamDXL5DhAqQotZEAjBDvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygtljt42VHE0C7OPWcqzz7S9vpEc0C4ZkWPSl5TS+4EW3LMdAfmgfDqsKlxcITaAc
	 wxzB9+VEhf7dTNqW0tAOiL2IihrJW3jxZ+K92MJ0IgmppBDZM+MCJBXW196Q3anIDe
	 X1IGZ1DsL2meeUus3fWDp90ZhY2oMnClc0qxhZRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/843] xprtrdma: Fix bcall rep leak and unbounded peek
Date: Tue, 21 Jul 2026 17:20:46 +0200
Message-ID: <20260721152415.284105559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit c7653d5cebc8492c77ec0415b5e9c0fb3e644bc6 ]

rpcrdma_is_bcall() decodes a reply's first words to decide whether
the frame is a backchannel call. Two issues in that decode path
let a short or malformed reply leak the receive buffer and drain
the Receive queue.

First, the speculative peek

    p = xdr_inline_decode(xdr, 0);
    /* five p++ reads follow */

asks xdr_inline_decode() for zero bytes, which returns xdr->p
without consulting xdr->end. The five subsequent __be32 reads can
then walk up to 20 bytes past the wire payload into stale regbuf
contents and misclassify the reply as a backchannel call.

Second, after the post-peek

    p = xdr_inline_decode(xdr, 3 * sizeof(*p));
    if (unlikely(!p))
            return true;

the short-header arm returns true without calling
rpcrdma_bc_receive_call(). The contract with the caller is that a
true return transfers ownership of rep to the backchannel path:

    rpcrdma_reply_handler()
      if (rpcrdma_is_bcall(r_xprt, rep))
              return;        /* bare return, skips out_post */
      ...
    out_post:
      rpcrdma_post_recvs(r_xprt, credits + ...);

Because rpcrdma_bc_receive_call() never ran, no one took rep, but
rpcrdma_reply_handler still bare-returns past rpcrdma_rep_put()
and rpcrdma_post_recvs(). The rep, with its persistently
DMA-mapped receive buffer, is orphaned on rb_all_reps and freed
only at transport teardown. This completion reposts nothing, so
its slot is reclaimed only when a later forward-channel reply
reaches out_post and rpcrdma_post_recvs() allocates a fresh rep to
backfill; absent that traffic the Receive queue drains and the
peer's Sends draw RNR NAKs.

Fix by consulting xdr->end after the zero-length peek so the five
__be32 reads cannot run unless 20 bytes of wire payload remain. A
byte-precise comparison against xdr->end is required because a
non-4-aligned receive rounds the stream's word count up past the
true payload. Also return false from the short-header arm so the
reply falls through the normal out_norqst cleanup chain
(rpcrdma_rep_put() plus rpcrdma_post_recvs()).

Fixes: 41c8f70f5a3d ("xprtrdma: Harden backchannel call decoding")
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e9c69e9f429919..9c5e08ce9c2d3c 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1129,6 +1129,8 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 
 	/* Peek at stream contents without advancing. */
 	p = xdr_inline_decode(xdr, 0);
+	if ((char *)xdr->end - (char *)p < 5 * XDR_UNIT)
+		return false;
 
 	/* Chunk lists */
 	if (xdr_item_is_present(p++))
@@ -1153,7 +1155,7 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 	 */
 	p = xdr_inline_decode(xdr, 3 * sizeof(*p));
 	if (unlikely(!p))
-		return true;
+		return false;
 
 	rpcrdma_bc_receive_call(r_xprt, rep);
 	return true;
-- 
2.53.0



