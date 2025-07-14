Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131B298987;
	Mon, 14 Jul 2025 23:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534488; cv=none; b=TZmDxcUOlXSqDjFRExiyW9xX3E/cT69SnEnOdr7l5repv2CzAM9qoiTwnOum63vSezwVeAsB2XY/6hrkEfX/IEMaPKcSHSAJiu7NiFhtMlbs4HB6dat1k49wpuSj0armT1nWbc5LhMGFHgPiq6NMOVWTHMX/wIPak0fJWQD+S5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534488; c=relaxed/simple;
	bh=vk2Y8kEEKYK9jP60kU2qg+C98h3evx7z/vw+tUivw7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CDZ4wRqaWwGDV4OTtox2hgaqYQnsABxKyavX96weZJhRamTdBZRGrvpNvTyxgL+RO/cF3NJHSdo/S2bEltnc3/d6si1B4iOrNNUZIVHSda/GQL9MaZ/WZkF01+pGozvj7C6gareSdWCA04yRzKUBk4WmmcHhnJUrY16WHH3Exuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ovl4U5LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ovl4U5LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0379EC4CEF4;
	Mon, 14 Jul 2025 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534488;
	bh=vk2Y8kEEKYK9jP60kU2qg+C98h3evx7z/vw+tUivw7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ovl4U5LUzzIisJvA2mK84PXPHEaQO5a2LjKi/TManUswuEahgAlEHT1GwHZTYNmNV
	 XjQSNNq/FnV8mJzjARMEOXahdMvhSXPQq2/tRpEE9Sy2vKMC5b5hRTcxuW1lthDj45
	 rDoCZoDFg6ENKP8I/u/f5goGvbk0szq1PePG4LbMkr6DhWbwy7HPNXASooyTFijdu2
	 70cGVtDfKrO+dzW8BSRHqI3M8/afhxg+hQPXLXOaXggysKvI+GiYIklK43mPH7yxMV
	 23WdQVaYZe2UJZ4I+wPsmhhWZSOQdOQAXzxHEDOUXFDT2/MFGiw7idto54hWwwW3Gw
	 sH1eqXjG3gt6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Junvyyang,
	Tencent Zhuque Lab <zhuque@tencent.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Willy Tarreau <w@1wt.eu>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 2/4] rxrpc: Fix oops due to non-existence of prealloc backlog struct
Date: Mon, 14 Jul 2025 19:07:56 -0400
Message-Id: <20250714230759.3710404-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230759.3710404-1-sashal@kernel.org>
References: <20250714230759.3710404-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.145
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 880a88f318cf1d2a0f4c0a7ff7b07e2062b434a4 ]

If an AF_RXRPC service socket is opened and bound, but calls are
preallocated, then rxrpc_alloc_incoming_call() will oops because the
rxrpc_backlog struct doesn't get allocated until the first preallocation is
made.

Fix this by returning NULL from rxrpc_alloc_incoming_call() if there is no
backlog struct.  This will cause the incoming call to be aborted.

Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Suggested-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Willy Tarreau <w@1wt.eu>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250708211506.2699012-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a Critical Kernel Oops**: The commit addresses a NULL pointer
   dereference that causes a kernel crash when `rx->backlog` is NULL. At
   line 257 of the original code,
   `smp_load_acquire(&b->call_backlog_head)` would dereference a NULL
   pointer if no preallocation was done.

2. **Minimal and Safe Fix**: The fix is a simple defensive check:
  ```c
  +       if (!b)
  +               return NULL;
  ```
  This is placed immediately after obtaining the backlog pointer and
  before any usage. The fix has zero risk of regression - if `b` is
  NULL, the code would have crashed anyway.

3. **Clear Reproducible Scenario**: The bug occurs in a specific but
   realistic scenario - when an AF_RXRPC service socket is opened and
   bound but no calls are preallocated (meaning
   `rxrpc_service_prealloc()` was never called to allocate the backlog
   structure).

4. **Follows Stable Kernel Rules**: This fix meets all criteria for
   stable backporting:
   - Fixes a real bug that users can hit
   - Small and contained change (2 lines)
   - Obviously correct with no side effects
   - Already tested and merged upstream

5. **Similar to Previously Backported Fixes**: Looking at Similar Commit
   #2 which was marked YES, it also fixed an oops in the rxrpc
   preallocation/backlog system with minimal changes.

The commit prevents a kernel crash with a trivial NULL check, making it
an ideal candidate for stable backporting.

 net/rxrpc/call_accept.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 99e10eea37321..658b592e58e05 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -270,6 +270,9 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	unsigned short call_tail, conn_tail, peer_tail;
 	unsigned short call_count, conn_count;
 
+	if (!b)
+		return NULL;
+
 	/* #calls >= #conns >= #peers must hold true. */
 	call_head = smp_load_acquire(&b->call_backlog_head);
 	call_tail = b->call_backlog_tail;
-- 
2.39.5

