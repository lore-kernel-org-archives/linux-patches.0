Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183DD47126D;
	Tue, 21 Jul 2026 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657177; cv=none; b=A3JVNMrcCDhnPhN0AxRURI+wv5Hw13fbiKWC4PhS71jmQOOko0WhXr+VhyxGdOv1plhm3VzvodQftG2/z0q1tyZWJrQS7FLra4NAMEhCOKaJ8IJ4dDES829mQ7wvgpAed50rhCzDldm3z4AxYYzrDwDvMcffsuto4FXy0PloC/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657177; c=relaxed/simple;
	bh=pYeGWsEodPbdPTX+Vz/B7yVc2dIc85Z7OO/5oUnfGmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIk5gdQ4NSnSTMcSiti0ECoCJ1VY9kAdZPUBTGKscCNUVhH8CxiN9QK9g9ONfwNedYh01vhBvFp5HTgxdn4iI334J/5UtttcplSsrolSJ/Ub0J5v+uSry9Alu3KK60Wos5FjfsY+o+AzL1imeE8EEQcIRDXawpHnaDcSv7Na2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq5Wv+AH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq5Wv+AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7DD1F000E9;
	Tue, 21 Jul 2026 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657176;
	bh=7F/XjO2aWTXddrYzkyax7wClCwQ7gcw7fgh5Z/SOOmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq5Wv+AHet/7dZD3sYGAv+YU4CdH6GoBo4pLV7h1Pk56w3GlEgWmN0ZpFUoxUFVqh
	 YZjLNMrjTVTQVfHPfBnAYXJU/UeVKOcs/ySP/mDOqo4Q8DlbICtSHQ6oTmA5rBh4D6
	 80QcusgTmsPQrjm1+mSXEtumgF/SPYZ19hFj3fV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0667/1611] xprtrdma: Post receive buffers after RPC completion
Date: Tue, 21 Jul 2026 17:13:03 +0200
Message-ID: <20260721152530.385983239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3aac1456e23e53..edd2ee0776e37c 100644
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



