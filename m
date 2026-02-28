Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E354348875
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302602; cv=none; b=GFja0K9jfHAACoqVQEbk7UVa7Jmht8+i6hZ20zVKxflGsq/M8S+C04CkOu1ri6xMsos4z/m1CMsOTeC3KCfcYMxEqERqjDLK/4ea36rDUAL91khkpL0tAOp7Bb3psjxHVPaA1LwgTgD8Y6829sAkoHwPcleCtMkor9qO3fZMQLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302602; c=relaxed/simple;
	bh=8x0OtuhIw3Sm8/M1QIyFxX3QhhFoD4UPnlY8ZV1w1VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgVMtZF+Ylaba4FC7HAjV/j2LqBWXqWZC5vjsFfrCQ0ekhazCYypmNFuayQxXE2zWzh3rsH5pIPb3Fq1EIo3vQ//drnaAts67IZXnU8qKwDysrqaraN6HePaZVgweuk4p7PgarcQgj6qRUFqHJVrJMWSmOh8fBeTetj2+XqQSS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyDS8Viy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyDS8Viy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DEBC19423;
	Sat, 28 Feb 2026 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302601;
	bh=8x0OtuhIw3Sm8/M1QIyFxX3QhhFoD4UPnlY8ZV1w1VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyDS8ViyzsUXo1+MmFpd+xQMtiddoD53FD78cEasSxUQgERKOZLgjE4RysQW9J137
	 +1dII5EvFY4sdkBlJJ3+8jng5TqLiP6p7jkHGTUr50YSOc76oT1HMUj5QsjhC7AAca
	 xLY/Pox+wjGY3YFA4f6OMIYZtNcTMX7bo5liN9s5+Bi8kb2u9OwBEh8cf07XGv2boC
	 y0ZEJjF0fbbyzfQ+S5Bj/ZzQrnazxq7va22+APK9I4zH2rtiQzJqEPyEVkviJdWwAk
	 1Xi5Jo69fH2Yqb4qpD2Dvq9HYQVS8vgGh5cS0JzaYion2gWog6FBTO2blAO1YBRrjt
	 oHUHDhMY4f95Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/164] svcrdma: Remove queue-shortening warnings
Date: Sat, 28 Feb 2026 13:14:14 -0500
Message-ID: <20260228181505.1600663-115-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index f776f0cb471f0..7b7e882c7a508 100644
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

