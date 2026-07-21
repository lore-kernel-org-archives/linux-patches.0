Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120883B1EFC;
	Tue, 21 Jul 2026 20:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666468; cv=none; b=pCevG1Bw6nCk9BiZ5zkw2CKjQc+TbQPyRtqm8XuOAqccew0czdeg/cCvwjHXgCaN26GqHtxSrKhJj3ZnT++eq/ezDqODdsYboWrs0nkxGv6Lo6Wl9zaMJeIpJWSGajcH1Pz5pP0p9mFPNrz8S3iJ7TGjXVJOo8/6/gtihZWAg5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666468; c=relaxed/simple;
	bh=LJcyx3KfNnDKoAVBmlhkKyD9gB2AiAnkFFMcDq0NNmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONBOvFe8Dle+8lMTT5qf5Khn6JIMVC3LUwxfKehZXBktR+nv2krjmsd1pfo0qJ8UdvXi3+X5qsDfCm1nmkGe631lexjhxh0NVUGV3cpo7YSCkoqxJ2VYDQHUPc0fue+n5A4LoFrit7T9XZygndOtdhJlnnRwg3BBcV7tDghnsQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zunu+UK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zunu+UK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D151F000E9;
	Tue, 21 Jul 2026 20:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666467;
	bh=fSU4nb0ykQBv1UeFH3du6URqSLzNAK/9Ahqs5dbezCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zunu+UK9y9j2wv7++kPU8zJUxFAkOWTZGvBfACNrywu7coo8s/t7Y8Q/VYzdK8ZUm
	 u2qmbYXMndaHP12jF4saTLv+s0567UzPJieYpp/U/Dw6zjgZZuBAN/RN/Qvf6DPvJJ
	 Fp+ZiBiOwcDH9Sg/MNuhQuh2fMOLDOvxD0urOrlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0651/1266] xprtrdma: Avoid 250 ms delay on backlog wakeup
Date: Tue, 21 Jul 2026 17:18:08 +0200
Message-ID: <20260721152456.423623807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 29b0562d62e759..b971776b55936c 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -511,7 +511,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
-	task->tk_status = -ENOMEM;
+	task->tk_status = -EAGAIN;
 	xprt_add_backlog(xprt, task);
 }
 
-- 
2.53.0



