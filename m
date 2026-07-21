Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB5D46D544;
	Tue, 21 Jul 2026 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657171; cv=none; b=qqm2vR+yI43tbjFD9NrGcCETQfQ2eQZ4EtdIT3e1y2VpKwDeKawo6LhWx5EauGOU1Vi/pVgwOC6Gn9EggHiVBPTGD9Dq2BH3dbOAWt1tZbGCG+OUDpcaW8pilRuk4uAN+8K7vDsLGVg/9v8Bd1bp25x45fbCBr6r+GtP0ayvVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657171; c=relaxed/simple;
	bh=K8a2QidDBkpdv/mEQ9xwXQD5lP/g/5YxBlg/RO7xWzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mndqyKlDObJcovuA2F4hrXNTGv204tUXYgWg4oJuZK6+gMomouV5xR0wuk9a0aSTTFOiXpdt1tGbjrjFEPcN4bZxC6jeGK3NQfPGB6PhhlkgmqOkApKryUUSSc8xIaqpgipAx/N8N2bSiT68lFcr2cObbVZLDAKunOsMurkvUWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTqGFrd0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTqGFrd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4F11F000E9;
	Tue, 21 Jul 2026 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657170;
	bh=gjd5z52T6bViJWcWk7teCrpExuhldN4BAlqfEzU7ssM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTqGFrd0duTtvB4k5gHoDHJQSabvwzSVhHLq5/Ivrbeg07bzkzyNj6IeQN7i/jhXe
	 YgHyiqAy+d1JeQRSXjwFPway2ueZ5FAgnrUP3m1fNoIBad2wuE0ncnhYdSfPTuj4Tg
	 3Wqz/4DnOKARPU6lepM3fMvGYa4RncArUnvn46VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0665/1611] xprtrdma: Avoid 250 ms delay on backlog wakeup
Date: Tue, 21 Jul 2026 17:13:01 +0200
Message-ID: <20260721152530.340961708@linuxfoundation.org>
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



