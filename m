Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F29E415F1A;
	Tue, 21 Jul 2026 19:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662730; cv=none; b=TA8aOVR4h37jjg7HOd9mkpS+nlQVEZ7EKxOQndg8xdSCtHeJEEzb/LHltSlT3BzheavV7f1uQSvkfjDbsvrbhwrD8O33M+ftr8qfJR02UKYEQ5nnfQOlQ9PSG1H3nc7FSHVRfjJVarQDtYkHvRK59cRsLVwzCm9ayKKhwuxZWRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662730; c=relaxed/simple;
	bh=ZjQNHosY6aB3Udr7RYDo3grd+I3K543rOEtrg6Gb62g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkqzQSZCGzJ5h6cY6t0jrigW5tU07zmVus6MXW/eKKSpkdC+4jU/rxEqWkX4UYQ5VvJRC7TCNehvVWOTTHHwXvGv15+NOM2IsfWT9Z+DtPxOQ5wqEuX1hxqn9IFkNsoMWznVawFmVn7YX0O1JYxVHxyUrGVJSbHJy93KZjh1XdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7AzZ3Rr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7AzZ3Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105A01F000E9;
	Tue, 21 Jul 2026 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662729;
	bh=a8J7GlDAWwhoKxiPxyzteoih/69dHblkf6wCjL/1u5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7AzZ3RrxpmMxQmFRhGkC7dJreKZ5HCowpNHVyvRpLDqfiA8U9GbLKnc2GrSzg+Ra
	 P1/l3tTb2Lsucylgbb+0g6ypwj1mGMOCGpnWj8A1rXnATlHyKhjI3hlFIHEH9vE7xu
	 UFU+4c8FJOY9ySP/wfL1j96lklsjQje7i/QuHX8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0512/1276] xprtrdma: Repost Receive buffers for malformed replies
Date: Tue, 21 Jul 2026 17:15:55 +0200
Message-ID: <20260721152457.567973181@linuxfoundation.org>
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
index 34ef05ebf5fd49..f65ecbb83befc7 100644
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



