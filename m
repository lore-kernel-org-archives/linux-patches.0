Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B0635AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302739; cv=none; b=I7vnEjuaxooNAsXx7bu/zPrnipwqnx+KdVrJbefSGyM3g6b6GuBQhac4lPy9gqYTsDNUZHwlwXRQAQhJKsWx2U+y7TtbUZzougXSTOccYgbGzukeE5e0lfwjf6nZevmvN+X4ya1rXkGnk+4Z/1UpOkdusx/tTOXNVwE51sCskJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302739; c=relaxed/simple;
	bh=3g7DGvGdpe9DCHXjcjt8a58Y3K4e1n1PDs1vTsMAkeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCAL5MvMQwEJ9TBQrgxNEUnjb//uDvTQaXcx4GDzbhEKu7yu++J4i5xz93iSICSlrgSAeXNTDpUP0UWpj+KsXgvrXwXI7mds+aQ9xj7PFNjLoynopLNIW4BOUjuS+aU/ja6BVsL9sAzzCstTAa7nH9uxpx2qQugT4ds6cgl9/EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=alZDiMZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="alZDiMZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B583C19423;
	Sat, 28 Feb 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302739;
	bh=3g7DGvGdpe9DCHXjcjt8a58Y3K4e1n1PDs1vTsMAkeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alZDiMZknYsChETT5hVEUwjs9g7CaB3wMfyaUCPB39w/FNjSr5l+mGi8LCHO/Q+3q
	 txXqQkIvwDp8yd7Fo3rjMBE0b6Ps+XpyEpRil43LXpVA/lcw1ca3XTN6nBMFpyb9XW
	 r5uo5+Cvd8+3dwpeQFKVDqMjJQrS2yGZbr6FUoULNm1UNA3XHJ8VvBaTRXWHIg7hTu
	 05wMVZpyjQzjtb71pMqaK6zjqlfBhxrVX0Wj8NnaNkm4Rh9tnQn23pLJY52Hbg8yYv
	 o8iwiV81LjxbxHGxItf8JpcZxahqnCIp7P/BocOlarJ/Gl3RjRNNgqnVdvKZ3DP9cp
	 CWqypliZlgcMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/147] svcrdma: Remove queue-shortening warnings
Date: Sat, 28 Feb 2026 13:16:52 -0500
Message-ID: <20260228181736.1605592-104-sashal@kernel.org>
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
index b00ea4dbe7d40..d6c9814644c6a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -408,8 +408,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	rq_depth = newxprt->sc_max_requests + newxprt->sc_max_bc_requests +
 		   newxprt->sc_recv_batch;
 	if (rq_depth > dev->attrs.max_qp_wr) {
-		pr_warn("svcrdma: reducing receive depth to %d\n",
-			dev->attrs.max_qp_wr);
 		rq_depth = dev->attrs.max_qp_wr;
 		newxprt->sc_recv_batch = 1;
 		newxprt->sc_max_requests = rq_depth - 2;
@@ -419,11 +417,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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

