Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15759470102;
	Tue, 21 Jul 2026 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662540; cv=none; b=ZvYXHrxK3Brai6DyR9MuSPfJVthrPMfQWy5DEuda3VM/DFGZd2zDgDROPTiCr6tld8D5d3ekxpE7gJ11hi/LGXSzTvu4zW47pd6syg+Xue3TSA59SzuQYlL0Tr7fOGArli0+dwkvfiXjqFP5QNnrPD7fG8rvNLWL9qK5W8ataAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662540; c=relaxed/simple;
	bh=KCT6x9Pb0sftp/drrhbGQxNNYbGOO3DGGX59hPvLldw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4SBB12LMDCbPybXL4VjBSeyW33HoAvnGh69BTaMQa9hWcGkdlI93t9mZLnvkU0ZR0ZSeap0HXwqMHQKLyPnhNQ7Rg3PoUNmI5kcFoy/tNyPhrRFTXM8AlSwj9CHG6bZcgPM6k4KUjvPNn7KJTNAvwvvcHObFdHSfGnDOVAvj8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hd4R1rXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hd4R1rXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAE61F000E9;
	Tue, 21 Jul 2026 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662539;
	bh=8j0aBPKlbSkXuZF7DOZVqkmbbvtAORK0jB63XI1SELY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hd4R1rXvLqfzI25pCSZjCgSNUDVIBIw62gnUE/t1jZ1EzN3Xf5aCa/5465mNHav8g
	 fXpko/ts0CwxY/ZqA/tPUByAL0xJhyuF1LYbtnIQCCAHbA6Se/Yk1Q3lvgsy2XudGK
	 1fNXTqrcvLykep9Ry4A/S19O4Lotu27xm0c0ugjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0483/1276] xprtrdma: Avoid 250 ms delay on backlog wakeup
Date: Tue, 21 Jul 2026 17:15:26 +0200
Message-ID: <20260721152456.910117455@linuxfoundation.org>
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
index 9a8ce5df83cad9..ca079439f9cceb 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -510,7 +510,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
-	task->tk_status = -ENOMEM;
+	task->tk_status = -EAGAIN;
 	xprt_add_backlog(xprt, task);
 }
 
-- 
2.53.0



