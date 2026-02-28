Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2001359A70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302418; cv=none; b=B9mSFhzevTnKVYOm0filqYOuuw9x14Edss/IaavfY75NGgybINhd4tSwJ6Xhn84iqjye/ezLZYfxZDnfsxgsOU0g3H/6MmScAYvs0lzuT+iaCRwfQpEclCU/+/j+V/l/U8yEfArlOqIK+f7smwGSk3mxOg9EEX2ADZCugVtzZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302418; c=relaxed/simple;
	bh=8x0OtuhIw3Sm8/M1QIyFxX3QhhFoD4UPnlY8ZV1w1VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKQ2MDEnueP8l+FJhF2kXRPSPW7l6SuTQrMtE3uUKI1YWUpVEXndIBs207SaujTd7UvWazXAHyhY4Mi4+Gqy8eXgDncACBYtPfckDS4bpbxdPO3jGVyvTeZCaMj6Ghezb3wvcXfKrQ/tjCfBQjEOpyulacpWRX38nJYoghBBKuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6tEhLUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6tEhLUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9FBC19425;
	Sat, 28 Feb 2026 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302418;
	bh=8x0OtuhIw3Sm8/M1QIyFxX3QhhFoD4UPnlY8ZV1w1VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6tEhLUfeFnkhGdszvJvQkXEcp1RNtfcdycEA9JAaVjdxZIZboQCzLrxnX5jR0G+h
	 7nLMvKAa3nwbveWQxgwF7zStOJ6D2QqCLRpgtIr4lQbkIY9O+sPKXmr5oXOF3UjJsI
	 4GoX737Ie/O3zmzWkKQXECPJKWMyAxyv4prnszPoC+aJJRYThbzG+673O6CpUKuX+b
	 fC0HspW3QOuJMzfDUueCO5V4TO92euQoqhSZXyHGtpoxXwr2glWMWEYe2e0opsEA0F
	 yYkmEN92LWN2CAUq9qYGkDMzl3E/zVy1hR3dLYpwdIQeVzXsLeJg9p28XZZwzJ1DTZ
	 qIWNHDlGqcvlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/232] svcrdma: Remove queue-shortening warnings
Date: Sat, 28 Feb 2026 13:10:06 -0500
Message-ID: <20260228181127.1592657-153-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

