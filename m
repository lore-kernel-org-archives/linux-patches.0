Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8A246D2DF;
	Tue, 21 Jul 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660499; cv=none; b=An2NZULbp/2TduPNHvaY8DMZhQWPy3d8ty5skL6eVR2vt/OyZ9ig2INzL1MdmPvZEFvlzuaIhmjcYjJwh4yhSPjPKrJ96dfV9saTuLanxQ24cIuvEStdFNyhnqmnQ+KEZc5zOx93CebcjAQhO+7weDY06mnQwAX8Uk8ZDE3uDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660499; c=relaxed/simple;
	bh=Fq9Sxy9UjBhgISUTEWraxeXhs7JR/JyoiS8ZZ0Ttiv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmFZW9NOF6GHrcw+i9f2OtNVJxzzZoNgtHOlIuAaJDiF35n8QWjas4VRssNLreRh6Wk+mbsYbg2f+r4B6SOfr8OJzyH+9LLNL9nlUYKy/lDd+8Kh6CQ2nUoRENeiXQQv0Qpl4g9cA8Cu4Ak7CtFlIltcbwbdsKraHKrBzjTvpGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UzVmzaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UzVmzaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EBA1F000E9;
	Tue, 21 Jul 2026 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660491;
	bh=6/qteSTyA130B737xjFO+hhQEIQfNTSddrgspc3jo1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UzVmzaTBcbJLV0cj0ocyhq1aXBecLrscFq8VDaeLnTOkwtd3h1ie3hOxmhruro57
	 F83ypCVjSrzEMXXeF5mxV/crlA4f/zK4+Q467KZjfgsbLR5tJeDEbSq/+c9kZHYC27
	 bQsgfNV7veU+UrMrhkkIlsiXNPDvRj79Syk5qRuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0999/2077] xprtrdma: Repost Receive buffers for malformed replies
Date: Tue, 21 Jul 2026 17:11:12 +0200
Message-ID: <20260721152616.380731247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit abc011ddaf1617e3e82d8a1e87daa7ddbfb9bac5 ]

rpcrdma_wc_receive() decrements the transport's Receive count for
every completion before it dispatches a successful Receive to
rpcrdma_reply_handler(). The handler must post a replacement
Receive WR before returning unless ownership of the rep has moved
elsewhere, as on the backchannel path.

Commit 2ae50ad68cd7 ("xprtrdma: Close window between waking RPC
senders and posting Receives") moved the Receive refill out of
rpcrdma_wc_receive(), where it had run ahead of every reply, into
rpcrdma_reply_handler() so that the responder's credit grant could
be parsed before reposting. The bad-version and short-reply exits
never reach that refill: they recycle the rep and return without
calling rpcrdma_post_recvs().

A remote peer can therefore drain the client's posted Receive
queue by sending a sustained stream of replies that are shorter
than the fixed transport header or that carry an unrecognized
RPC/RDMA version. Each such reply consumes one posted Receive
without replacing it. Once the queue empties, the peer's next
Send finds no posted Receive and the transport stalls until
reconnect.

Route both malformed-reply exits through the shared repost tail
after recycling the rep, refilling against buf->rb_credits, the
most recent accepted credit grant. Neither exit updates the
congestion window, so RPCs admitted under the previous grant
remain in flight awaiting replies. A smaller refill target would
let a stream of malformed replies ratchet the posted Receive count
down to the batch floor while the congestion window still admits
rb_credits RPCs; a burst of valid replies to those RPCs could then
overrun the posted Receives, and because the client connects with
rnr_retry_count of zero, a single RNR NAK terminates the
connection. Refilling against rb_credits also restores the target
that applied to malformed replies before commit 2ae50ad68cd7
("xprtrdma: Close window between waking RPC senders and posting
Receives") when rpcrdma_post_recvs() computed it from rb_credits
internally. rb_credits is at least one from connection
establishment onward, so the repost path always keeps Receives
posted.

Fixes: 2ae50ad68cd7 ("xprtrdma: Close window between waking RPC senders and posting Receives")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 9255d44960cca5..ae90e6dc1487e9 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1524,11 +1524,13 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 
 out_badversion:
 	trace_xprtrdma_reply_vers_err(rep);
-	goto out;
+	rpcrdma_rep_put(buf, rep);
+	credits = buf->rb_credits;
+	goto out_post;
 
 out_shortreply:
 	trace_xprtrdma_reply_short_err(rep);
-
-out:
 	rpcrdma_rep_put(buf, rep);
+	credits = buf->rb_credits;
+	goto out_post;
 }
-- 
2.53.0



