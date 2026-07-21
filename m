Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740E471255;
	Tue, 21 Jul 2026 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657390; cv=none; b=skG7HCWzB+9aJlfk35qqy6EUBLi5hDQIm4utKh0fPQ94I0yGiCqKXOTYexAOPmfzpEQufghl/1Nitw9QLUglT8ea/Mo46UhwSYgSy9zivgM2+Dac99Y40KJi4+71gP2GVv84kEALPIRQve5TqZJrgv8TcE4Yt4yLmrlwvCSc+R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657390; c=relaxed/simple;
	bh=VH3lyq4Wp2jBPAAhpuwU9s+54j4QmCg26HlgwKYHyhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/h4Q7vrMWB33TZRC5xqFDfD9BH/y2gmYxtZxCY6yTg6bBo/lvjxrI8IokTTrcDOq72J4NR3nwgI64ogphrZNVV8Pf7UdRyoLfTFjCGDdlIf49szCg1kHy/n/qpqCL7ipWtyW3U2kWQtnPNrjjDu3Tisv2gwPwrPCS3w7flZ5n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et0nRvhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et0nRvhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DED1F000E9;
	Tue, 21 Jul 2026 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657388;
	bh=24gVv5//Nb9D0+yhDePXZMVqH+jFak9aNoO0NVc3WJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Et0nRvhe2tax7mvHHhqkbsdc5A8hxsG6LOU3QI/AOFbSEWQWvUxRAyqbrrrIYvs4W
	 dm3zE2j/q6dDl4U5TRSdkLXzZMrq3cb7tHrpHnuQiG/9NpjZRhnkaANPHu2s88SozN
	 yCCx/pzqizkaV/IusT1l8v6v6Pk6bMjEuixG/fDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0703/1611] xprtrdma: Repost Receive buffers for malformed replies
Date: Tue, 21 Jul 2026 17:13:39 +0200
Message-ID: <20260721152531.192089498@linuxfoundation.org>
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
index 3002e625f2b3f0..425dbaec66fdfb 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1573,11 +1573,13 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 
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



