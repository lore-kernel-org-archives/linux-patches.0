Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D786471258;
	Tue, 21 Jul 2026 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657387; cv=none; b=B/3zgtIPh9xFMSD6riJWvwkYRZv1d5FVIuoEsr5BsbqdZstRvd7ERfrTW+3vqpdMmVCx4HcSJLBLaO5e+uqpnZILY0i3rit9eJ8LmfM5Zi3kQ+I1AEAFfjZyMLFNnSFjLoc7FzUN1EDpt2hWujlvv8SavZsY3Q5YF9LefnQrLs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657387; c=relaxed/simple;
	bh=c3sMWR36YGr2C42QXrNk4KN+pepLOwRgLWBA8hvNrIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjb43APR78WWmnxpF3lRGauRuwg1PJyTma05ccFpAr2MpyzUb/Tu0qOz59qcbmcsN65t+LaC74eLlFV46w96S9nYpX2kues5thQONbLKZoPwPUl1PEnZom3KgoEfUQLs5aViwNz25o/tZTxf2RSUBzZHZkXhgswqedx064PzeI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zecGVetN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zecGVetN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335F31F000E9;
	Tue, 21 Jul 2026 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657385;
	bh=stvKlUC+pY6eDA3/GXtXdRNz5xCfKS/19SUfF7kf+oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zecGVetNDVXUA4z8p4tXE5CEz/sPeFIA82GGvHyqRaJ2A/NNteKAiycJYogeuo118
	 6/MT3kJOVpWsA+b4J3fwv6lfN6+bPVDxM4NZd4UCEeXsmYmKU+gkKNgBOScFFEq08Y
	 ABX/d6KKM6JdvMk//80oSzRanqtom5HUxeECzzhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0702/1611] xprtrdma: Sanitize the reply credit grant after parsing
Date: Tue, 21 Jul 2026 17:13:38 +0200
Message-ID: <20260721152531.170083760@linuxfoundation.org>
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
index d19e371d63cf1a..3002e625f2b3f0 100644
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



