Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B51D3B1ECC;
	Tue, 21 Jul 2026 20:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666357; cv=none; b=Wb/3Sw5lm+VWC+17IDE5QVGiZG6cYRz2vWWTglsazqReGXgx/Y39Maku4vub04+h6g8XWEMqNr+QnYGcOhQvG0CC0jLd4V2caxoDZf/7gOlqmOelNe0Zd378d1Yo+v8i9hvym34Wv88ywm9RORSRlXqRO5a1N98kkjrGHwruByc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666357; c=relaxed/simple;
	bh=TljcrmXFdAIwS3peTiLeCze2SQhEWG7Ce+lA8vq7+/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxgfzVMN7b6i1wLkmPAJ73eH0boavlfUpBLPaP2hmTQMhEaGjNHth8KdNAhvvksnFsZFUchVcI27+zn1WS/BEIGhyVMb40dOyWgVjYdIpA8JmoWMMQjMOqeXj/LZZa/WJni7EVDegkhhoahBlCgWjNCrKjBP1gGqoAVmW8cJfXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlyev01t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlyev01t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CB11F000E9;
	Tue, 21 Jul 2026 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666356;
	bh=Uf4y2zmMCkdZpJwkHGdtfqryRXISEw8Ngu4T4Uwivr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlyev01tbnlC6ntFGhnNs3Fgg2mW6TsvXkZ9/0PQyvHD1Lm2C92T5wsVCEoPDyjcA
	 Rwk03uVn72a1Z49gjp2GPmd4xPFbWnbAdMdpwap/Z/eeByb8sbu6NLUAGOdVH9Q/Bj
	 7fSHQQQvm157LRIxw7kEhnCY1l5iIExRAZvSp88k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0653/1266] xprtrdma: Post receive buffers after RPC completion
Date: Tue, 21 Jul 2026 17:18:10 +0200
Message-ID: <20260721152456.468206860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 704f3f640f72db4d44ec5ce3db8d4e150c974bc7 ]

rpcrdma_post_recvs() runs in CQ poll context and its cost
falls on the latency-critical path between polling a Receive
completion and waking the RPC consumer. Every cycle spent
refilling the Receive Queue delays delivery of the reply to
the NFS layer.

Move the rpcrdma_post_recvs() call in rpcrdma_reply_handler()
to after the RPC has been decoded and completed. The larger
batch size from the preceding patch provides sufficient
Receive Queue headroom to absorb the brief delay before
buffers are replenished.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: e786233d2e0b ("xprtrdma: Decouple req recycling from RPC completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 1478c41c7e9da7..6e7bd1b47d7c7c 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1471,7 +1471,6 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 		credits = 1;	/* don't deadlock */
 	else if (credits > r_xprt->rx_ep->re_max_requests)
 		credits = r_xprt->rx_ep->re_max_requests;
-	rpcrdma_post_recvs(r_xprt, credits + (buf->rb_bc_srv_max_requests << 1));
 	if (buf->rb_credits != credits)
 		rpcrdma_update_cwnd(r_xprt, credits);
 
@@ -1490,15 +1489,20 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 		/* LocalInv completion will complete the RPC */
 	else
 		kref_put(&req->rl_kref, rpcrdma_reply_done);
-	return;
 
-out_badversion:
-	trace_xprtrdma_reply_vers_err(rep);
-	goto out;
+out_post:
+	rpcrdma_post_recvs(r_xprt,
+			   credits + (buf->rb_bc_srv_max_requests << 1));
+	return;
 
 out_norqst:
 	spin_unlock(&xprt->queue_lock);
 	trace_xprtrdma_reply_rqst_err(rep);
+	rpcrdma_rep_put(buf, rep);
+	goto out_post;
+
+out_badversion:
+	trace_xprtrdma_reply_vers_err(rep);
 	goto out;
 
 out_shortreply:
-- 
2.53.0



