Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7691C38F626
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302191; cv=none; b=VoT2pywfAy/hEb5+5g7lOjUWId5ry7fLhenJkSsVwrfV7NNxQk/vVhNvO2gc6YZzQ9eY1RrYuxvi4kqqvqubuCOHnsKDyVmrV1SIrLmUpPy1zsG6OONYfCqjrRgUSwZJ2fJjyIkub26FcpRXpBLjZ4HXQZa8/CrB6EYcgeFOM18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302191; c=relaxed/simple;
	bh=1kcgziwbfpmGkp6Rl31WcZjButrIgsYfAT1Rq8WqGwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbrQloHugei86rPhj6o90qcVQkorfdZlw2oAYMWAzFHuaMII/ZrSgcDMsGyHiPNdobfjTlGnXlr9xs79s7zt3HfgH0f9NQd3f1Su98zHOIQmACz4C4ABaOVlOARTtATNZIIesvqFM4DUjITU6oadgDJ+0ZgR/Ic7kc2PC7FMDgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eOVtuFqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eOVtuFqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E829CC19424;
	Sat, 28 Feb 2026 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302191;
	bh=1kcgziwbfpmGkp6Rl31WcZjButrIgsYfAT1Rq8WqGwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOVtuFqjkBjS02I83LcP7zspr9KkB8Cv1ap00GoW+JyK+IAiQlgKx3RI6dCMxBpuj
	 xNXQuMxJWUBRVRmQ1MVuJnjDxT8Ml9j0tDdQun5KltHZAoCMd5wJxSMRJZPESKqx8A
	 nKajD9ecZl/cpNMUTv58S7QKDaRzvODUZ/HuqIKExfQpQ6cqf9acEZqkUUQ3kSst2t
	 4jbfXt6S9H7FpOL+mSJcuefWolhDAc93O5xWg1zHGAlfIjCGYs2Lmj3Tzy7D37nRII
	 wBQC6CoXF2lAzKPr76OJCJWAxQ8GB6EkfO99amXlrYMKZ+ou06ns8q35XtzziVkAqN
	 so9N2r1v2549g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/283] svcrdma: Remove queue-shortening warnings
Date: Sat, 28 Feb 2026 13:05:35 -0500
Message-ID: <20260228180709.1583486-193-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

[ Upstream commit b918bfcf370c92ea3b82fa9bb3d017702b5fa4cb ]

These won't have much diagnostic value for site administrators.
Since they can't be disabled, they become noise.

What's more, the subsequent rdma_create_qp() call adjusts the Send
Queue size (possibly downward) without warning, making the size
reported by these pr_warns inaccurate.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 2abd895046ee3..86f45461b1851 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -406,8 +406,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	rq_depth = newxprt->sc_max_requests + newxprt->sc_max_bc_requests +
 		   newxprt->sc_recv_batch;
 	if (rq_depth > dev->attrs.max_qp_wr) {
-		pr_warn("svcrdma: reducing receive depth to %d\n",
-			dev->attrs.max_qp_wr);
 		rq_depth = dev->attrs.max_qp_wr;
 		newxprt->sc_recv_batch = 1;
 		newxprt->sc_max_requests = rq_depth - 2;
@@ -417,11 +415,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	ctxts = rdma_rw_mr_factor(dev, newxprt->sc_port_num, RPCSVC_MAXPAGES);
 	ctxts *= newxprt->sc_max_requests;
 	newxprt->sc_sq_depth = rq_depth + ctxts;
-	if (newxprt->sc_sq_depth > dev->attrs.max_qp_wr) {
-		pr_warn("svcrdma: reducing send depth to %d\n",
-			dev->attrs.max_qp_wr);
+	if (newxprt->sc_sq_depth > dev->attrs.max_qp_wr)
 		newxprt->sc_sq_depth = dev->attrs.max_qp_wr;
-	}
 	atomic_set(&newxprt->sc_sq_avail, newxprt->sc_sq_depth);
 
 	newxprt->sc_pd = ib_alloc_pd(dev, 0);
-- 
2.51.0

