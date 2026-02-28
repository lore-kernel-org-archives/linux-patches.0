Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DC535AC0F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302737; cv=none; b=uKQoXBWMr/j4WNWCEm7WWlnfsBQ0i7MBFoLKfDUP/z0n9SRHl1XnE/O5ssEjhftWUtE4wDANvWL2s7HquU8NYiVm5lsBtgHrqVT24PW91MRzOGsuwxb0zg3WO/xvlWsv24k1B3h0jmAIIMgxUY8qS6iaoAA19eLMIx6B8jHST88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302737; c=relaxed/simple;
	bh=5AyQwb25uoHWhnZc2/MkFokYxeoLmo2w59G8R1Gc0Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9Za96+jGUuGSTnLSJFZlVVj9/eQ3tX/WCAzZ+fSg13WEYAy3/oMq/V7sv0VW10AwmoMOp/IOacYitrnlESw8AzGzG290VvP8N84UQx19N17JgNe5x8XyphmZOaJPcJErSi1SFLFqf2r28kfedog6tM+Pb+5qnW9ulAMey3PzX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRmLKsZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRmLKsZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0798BC116D0;
	Sat, 28 Feb 2026 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302737;
	bh=5AyQwb25uoHWhnZc2/MkFokYxeoLmo2w59G8R1Gc0Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRmLKsZ8N/AAgwJaUjdldblJQE1TyUma16EtUpUHJEPWFfTmu98/sGIsGbm+iBf9M
	 1gj3au1txb327vzuX/+tm0eab3VEJgZ6tdaObDQjpgaV6HbTd/WsP2HEbbYilF+/Qx
	 aCokdObmm3olCj4TpxhVZp88AVSnuabH7M1PY2ylhzZPqTujGkXJ2zM7HK26bb0Sxc
	 z8OLmRvyLCF9YHWpPAgvAuN+9wXp5VFphn4Pp/opczB1zsG0ldvVipZWMuFztIsEor
	 YJvoCMT+mTPeWJ9+T0oqPf9XDr9GMkab/r6Jx8ySyYQ6NuTh8tnXnyA2OPhOqmpxl0
	 Ud2j03GxNDPDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/147] svcrdma: Use svc_rdma_refresh_recvs() in wc_receive
Date: Sat, 28 Feb 2026 13:16:49 -0500
Message-ID: <20260228181736.1605592-101-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7b748c30cc046056a24c459de415844a856ea54b ]

Replace svc_rdma_post_recv() with the new batch receive mechanism.
For the moment it is posting just a single Receive WR at a time,
so no change in behavior is expected.

Since svc_rdma_wc_receive() was the last call site for
svc_rdma_post_recv(), it is removed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 43 +++++++------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 4129a2d5cc715..f2264179d9000 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -293,35 +293,6 @@ static bool svc_rdma_refresh_recvs(struct svcxprt_rdma *rdma,
 	return false;
 }
 
-static int __svc_rdma_post_recv(struct svcxprt_rdma *rdma,
-				struct svc_rdma_recv_ctxt *ctxt)
-{
-	int ret;
-
-	trace_svcrdma_post_recv(ctxt);
-	ret = ib_post_recv(rdma->sc_qp, &ctxt->rc_recv_wr, NULL);
-	if (ret)
-		goto err_post;
-	return 0;
-
-err_post:
-	trace_svcrdma_rq_post_err(rdma, ret);
-	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	return ret;
-}
-
-static int svc_rdma_post_recv(struct svcxprt_rdma *rdma)
-{
-	struct svc_rdma_recv_ctxt *ctxt;
-
-	if (test_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags))
-		return 0;
-	ctxt = svc_rdma_recv_ctxt_get(rdma);
-	if (!ctxt)
-		return -ENOMEM;
-	return __svc_rdma_post_recv(rdma, ctxt);
-}
-
 /**
  * svc_rdma_post_recvs - Post initial set of Recv WRs
  * @rdma: fresh svcxprt_rdma
@@ -354,8 +325,17 @@ static void svc_rdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
 	if (wc->status != IB_WC_SUCCESS)
 		goto flushed;
 
-	if (svc_rdma_post_recv(rdma))
-		goto post_err;
+	/* If receive posting fails, the connection is about to be
+	 * lost anyway. The server will not be able to send a reply
+	 * for this RPC, and the client will retransmit this RPC
+	 * anyway when it reconnects.
+	 *
+	 * Therefore we drop the Receive, even if status was SUCCESS
+	 * to reduce the likelihood of replayed requests once the
+	 * client reconnects.
+	 */
+	if (!svc_rdma_refresh_recvs(rdma, 1, false))
+		goto flushed;
 
 	/* All wc fields are now known to be valid */
 	ctxt->rc_byte_len = wc->byte_len;
@@ -373,7 +353,6 @@ static void svc_rdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
 	return;
 
 flushed:
-post_err:
 	svc_rdma_recv_ctxt_put(rdma, ctxt);
 	set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
 	svc_xprt_enqueue(&rdma->sc_xprt);
-- 
2.51.0

