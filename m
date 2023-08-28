Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CB511C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8555AC433C7;
	Mon, 28 Aug 2023 10:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217866;
	bh=iYLDdaRWw84YbUXr7zLqSedNDrn5rgYC92ZlT2C536o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeLh4+o5/on7s5RwvteNiKt8mndbls/gzQ/7ajJigN13dMDz7h+uchfRE/vTp6hS/
	 BlG3JTp1TELsZYHcRfPu35m1g7jPZMsbsuWKyZN1O3aN7KwKntRQgMHW0i6zHaGXJU
	 qxRNpCoaB9TAqZmutkkVIPnRvtkihQccsQzWqUnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 003/129] xprtrdma: Remap Receive buffers after a reconnect
Date: Mon, 28 Aug 2023 12:11:22 +0200
Message-ID: <20230828101157.503182793@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 895cedc1791916e8a98864f12b656702fad0bb67 ]

On server-initiated disconnect, rpcrdma_xprt_disconnect() was DMA-
unmapping the Receive buffers, but rpcrdma_post_recvs() neglected
to remap them after a new connection had been established. The
result was immediate failure of the new connection with the Receives
flushing with LOCAL_PROT_ERR.

Fixes: 671c450b6fe0 ("xprtrdma: Fix oops in Receive handler after device removal")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index b098fde373abf..28c0771c4e8c3 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -935,9 +935,6 @@ struct rpcrdma_rep *rpcrdma_rep_create(struct rpcrdma_xprt *r_xprt,
 	if (!rep->rr_rdmabuf)
 		goto out_free;
 
-	if (!rpcrdma_regbuf_dma_map(r_xprt, rep->rr_rdmabuf))
-		goto out_free_regbuf;
-
 	rep->rr_cid.ci_completion_id =
 		atomic_inc_return(&r_xprt->rx_ep->re_completion_ids);
 
@@ -956,8 +953,6 @@ struct rpcrdma_rep *rpcrdma_rep_create(struct rpcrdma_xprt *r_xprt,
 	spin_unlock(&buf->rb_lock);
 	return rep;
 
-out_free_regbuf:
-	rpcrdma_regbuf_free(rep->rr_rdmabuf);
 out_free:
 	kfree(rep);
 out:
@@ -1363,6 +1358,10 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 			rep = rpcrdma_rep_create(r_xprt, temp);
 		if (!rep)
 			break;
+		if (!rpcrdma_regbuf_dma_map(r_xprt, rep->rr_rdmabuf)) {
+			rpcrdma_rep_put(buf, rep);
+			break;
+		}
 
 		rep->rr_cid.ci_queue_id = ep->re_attr.recv_cq->res.id;
 		trace_xprtrdma_post_recv(rep);
-- 
2.40.1



