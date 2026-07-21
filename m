Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F96414A1C;
	Tue, 21 Jul 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660496; cv=none; b=SmeR7//OX6mNQAdZhPsFxUjT9LK6RshquTU8MPo7EvmX1hJOJ0/nLa28j+bq7O6pziAGONtjwLjC/IycjBWNPyPCKw/u8udUaVqPybgHTxyCO8zuBOaVWHv7rngWqVp4yE17lqdNWgzfs+C6hSq/23LR0ckOGvf83cENrkaScNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660496; c=relaxed/simple;
	bh=+4Sabo7UfyVDOj7QIROtXF+nnAa2Wpar7hfNkeebJGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivcIh8GFVNMiavuk/zXXFoFCxLJuGP6uBJ0X0mudViZRbj9jseQHXYS/YkDcf901tqRltHTB/EdETBetb1Y2yAD34FaHHGqUV4AE1zyQaDtBmoIm+LyNj+wNB2b0uVR/EXkMkGMJ+GfGaHsz08GGj1Enr7j1dYQ1EajxOum9JLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjpkLZAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjpkLZAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644F91F01566;
	Tue, 21 Jul 2026 19:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660488;
	bh=lQtIiihDKOMMuJaIHCmQFtuX0OMovbFVV0yj50CmGP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjpkLZAtmnQk7l77QVMJeuRTyrNj8fDYdMt2RZVOus2pBplCD2Vh3DCjQMJGgxT91
	 X/Bm+96PQ8RSZ/JIk6RgjBLC9jcrzDYWQhpsjNFUUGY6EuwH7unqxz6XlDlWMgdU5r
	 fq+3u7Q3fqER0IvgjF2Z7qCtbzhTqHSdFpUioQZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0998/2077] xprtrdma: Sanitize the reply credit grant after parsing
Date: Tue, 21 Jul 2026 17:11:11 +0200
Message-ID: <20260721152616.357756686@linuxfoundation.org>
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

[ Upstream commit c3a628aab2dc8f5fd7bff86ceaeae64de590e60a ]

The out_norqst exit in rpcrdma_reply_handler() branches away before
the credit clamp, so a reply that matches no pending request reaches
out_post carrying the raw credit value parsed from the wire.
rpcrdma_post_recvs() does not bound its @needed argument: the refill
loop allocates and chains Receive WRs until the count is satisfied or
allocation fails. A peer that sends a well-formed reply carrying an
unknown XID and an inflated credit grant therefore drives rep
allocation and Receive posting past re_max_requests on every such
reply.

Move the clamp to immediately after the credit field is parsed,
ahead of the first branch that can reach out_post, so every later
consumer sees a sanitized value. The cwnd update stays on the
matched-request path.

Fixes: 704f3f640f72 ("xprtrdma: Post receive buffers after RPC completion")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 912d5de60abe81..9255d44960cca5 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1468,6 +1468,14 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	credits = be32_to_cpu(*p++);
 	rep->rr_proc = *p++;
 
+	/* The credit grant from the wire is not trustworthy;
+	 * sanitize it before any code path consumes it.
+	 */
+	if (credits == 0)
+		credits = 1;	/* don't deadlock */
+	else if (credits > r_xprt->rx_ep->re_max_requests)
+		credits = r_xprt->rx_ep->re_max_requests;
+
 	if (rep->rr_vers != rpcrdma_version)
 		goto out_badversion;
 
@@ -1484,10 +1492,6 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	xprt_pin_rqst(rqst);
 	spin_unlock(&xprt->queue_lock);
 
-	if (credits == 0)
-		credits = 1;	/* don't deadlock */
-	else if (credits > r_xprt->rx_ep->re_max_requests)
-		credits = r_xprt->rx_ep->re_max_requests;
 	if (buf->rb_credits != credits)
 		rpcrdma_update_cwnd(r_xprt, credits);
 
-- 
2.53.0



