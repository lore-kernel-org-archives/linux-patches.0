Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05918415F1A;
	Tue, 21 Jul 2026 19:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662728; cv=none; b=BO7ZuHUZJfSiOsTs+Vm/ausr4pd6W5XvdVMdxLPElhJpZggvimLTliikOJ06+frhv7iTp8RogUAKupAFsDf6csAmK/l7JCpofE1KLhnJnLupRfpDcFJEGDv6umoXUPEPPYp5sRABY2o57KyIkXz8zmJRk2984mz3Tu3SjTIhON4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662728; c=relaxed/simple;
	bh=xCbJEa6wau2Pl1YiqofhdRD+tNgPPckLIxv/hsl+qPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUOy0Ok/Qfpt/V+OmQx6dixWiBilzSCb3K2Muq7/Aat/SNe8R8Athx40fmSaXupoNyPxHsEDH1SzIm+FY82wfJKV/llA0pIsqE6p5AdsKgo5ObxqrShpx2f/svyAPapV/iI3/yMj+TJ5fiH6Cf1TJei6e5pedTqnRne9uar3vVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MaBKHZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MaBKHZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7AF1F000E9;
	Tue, 21 Jul 2026 19:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662726;
	bh=N9ktO0tPaTlPsU2GydZ4odSfEqn7NLGUB866sKBDYG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MaBKHZftG03QYaYqt/1QS6KmHDaNT130H4WWI+yiyegI6Tj8TbMllMGbbIylxuNg
	 nJmlvruyURa4ALkxdiSegJ5wB58gypiW8wpLBuvDUR4M1JnjxJP1FkEN8dUCYZ2Psq
	 q5ph00ENVCmiZFaUMyJU25Eb3FRaKSBcFKF2I5AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0511/1276] xprtrdma: Sanitize the reply credit grant after parsing
Date: Tue, 21 Jul 2026 17:15:54 +0200
Message-ID: <20260721152457.545151690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 51e70c767dace2..34ef05ebf5fd49 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1517,6 +1517,14 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
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
 
@@ -1533,10 +1541,6 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
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



