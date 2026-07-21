Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5E53B6356;
	Tue, 21 Jul 2026 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669338; cv=none; b=Et3OWxocCD/prMW0RLvevtIMW1syUfIaRf3lWa/OJw9MVYHQ8Bgr94KQZHZaQZSz0/P0PCiHmiZEMz0qVMOa/YmJMu2Lhz2jdUCMBSOrU+i3jIv0vR0Pi6Olyw9p5DGH0v2HSqsbLoDitPLGz6h/CqjoCSs4TN2CwSU/MO3MCfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669338; c=relaxed/simple;
	bh=yEDj5Q7e9yR6XvDlL562W4U9k4nogUmNvC4M3bpiAr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDBuB62Il97oC6BRx7x6Mkdw8wXhScpZogS/jQqglNqJDfePyVjazIVG6jl+W2OOx8UsIijqsM465axecQETEBAosmqM6zn/zyO1pfQ/zY6FzGUWF788+bz5Ve99MpCMaNIdZZwXHt3Ry3b0tPhUNsUA8NFVyzNfDmBfgUVsBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC0Tt8M9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC0Tt8M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBF31F000E9;
	Tue, 21 Jul 2026 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669334;
	bh=f7jmCjR9bEqiMem0GZuUts3xO0LkaqgCuhl+Ohgmi00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC0Tt8M9vx1sRvnKajt6dAQSNW3yLvdNs+hY/4t1vi31tKOVnS4PJmDSvafNjSLjY
	 81wyPKkEmVoibRW0nWE7WvyfvbUxSmLc26VOKdXyMK9r8/h/ZUjfFbFZ4YnbGNSx08
	 Xi9UcO8gVDQpE9R9KHvwUzh7DyAfg5ieTubOxNPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0514/1067] xprtrdma: Avoid 250 ms delay on backlog wakeup
Date: Tue, 21 Jul 2026 17:18:35 +0200
Message-ID: <20260721152436.110760260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 100142093e22b3f7741ac88e94878bb3694e306f ]

Commit a721035477fb ("SUNRPC/xprt: async tasks mustn't block waiting
for memory") changed xprt_rdma_alloc_slot() to set tk_status to
-ENOMEM so that call_reserveresult() would sleep HZ/4 before
retrying.  That rationale applies to xprt_dynamic_alloc_slot(),
where an immediate retry under memory pressure wastes CPU, but not
to the RDMA backlog path: a task woken from the backlog has a slot
waiting for it, so the 250 ms rpc_delay adds latency without
benefit.

This also aligns the code with the existing kernel-doc for
xprt_rdma_alloc_slot(), which already documented %-EAGAIN.

Fixes: a721035477fb ("SUNRPC/xprt: async tasks mustn't block waiting for memory")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: e786233d2e0b ("xprtrdma: Decouple req recycling from RPC completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 10bb2b929c6d70..80731cbb1365ee 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -520,7 +520,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
-	task->tk_status = -ENOMEM;
+	task->tk_status = -EAGAIN;
 	xprt_add_backlog(xprt, task);
 }
 
-- 
2.53.0



