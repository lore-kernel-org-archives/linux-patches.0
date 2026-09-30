Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6E521893;
	Wed, 30 Sep 2026 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790965; cv=none; b=MAfbr3ygZtM+0n9mgzf0TGUPRQYqZOrz0DiC0BhIg/fBw4SGWdvfzQnwd8JDbR4q/EGtGO8/uuDw9Iol4hZm/zXQSXQp7y4fxW/NxhyrmGQvs5H0CE2gx9Vpwgr1Cp4hmIKmbTU7B05+p4iIaPQVDQK/SaMdch6G3Kdr4guJy8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790965; c=relaxed/simple;
	bh=QxzzjDFxlrsHgT7OjOaVd0g39xBaPbY3T5T46qDdzt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1v0uDjGAPDwesu9YrdbANc0b+lXHJu0ZA6xbKnI0W8di9VBg9yvkZ81ebXwtKatx5880kLy30YpRSZrZtiCcsgTpz10bMTGATVQvOgYTRqnSFAh9zSzNWGOkdK/kQ2eNZvQjRJ7ZrjNBEWjmOxR3MczLmBWQ2YFO7rMfx5T8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF89B3Ty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF89B3Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F5B1F000FF;
	Wed, 30 Sep 2026 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790963;
	bh=rMmF3r4s0ds2TMqKYq3UOpobYhsuwVFA8h36GM4Pitg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vF89B3Typ+BA7V+BRQTT/R+6qA0lctS7/mbvLTtZXEzqVm0PQdN2AKLuhwf0Get+y
	 hPvyqe/L6O7SQbQ23qHVGn4Sj9UINdnjT1C5XlB/uIWyE/yyFJ1ldsjBT2/uMSPC+O
	 lnAmTIilQi0bc0T7XKjcs0kYR8/bL4QJl8akijmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/752] xprtrdma: Add request-pool slack for delayed recycling
Date: Wed, 30 Sep 2026 17:19:59 +0200
Message-ID: <20260930152400.970835823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 64bf6892057b746c55bcc045b9492741b72d8d27 ]

After the previous patch gates req recycling on Send completion,
a completed RPC's rpcrdma_req can remain pinned by the sendctx
ring until the next signaled Send completion releases it. The
transmitted-RPC ceiling is unchanged: xprt_request_get_cong()
gates Sends against xprt->cwnd, the RPC/RDMA credit window fed
by server-granted credits and capped at re_max_requests. The
req pool, however, must exceed max_reqs by enough that this
recycle delay does not stall a slot allocation that the credit
window would admit.

The headroom is bounded. frwr_open() sets re_send_batch to
re_max_requests >> 3 -- one in every eight Sends is signaled --
so at most re_send_batch unsignaled Sends can be outstanding
before the next signaled completion releases them. That equals
max_reqs / 8 reqs in the worst case, with a one-slot floor for
small max_reqs values where the right-shift rounds to zero.

The sendctx ring and the hardware Send Queue are not enlarged
to match. Both are sized in rpcrdma_sendctxs_create() and
frwr_query_device() for re_max_requests in-flight Sends, which
is the ceiling the credit window enforces. The pool slack does
not raise that ceiling -- it only lets allocation keep pace
with the credit window during the brief interval in which
earlier reqs are pinned waiting for the next signaled
completion. At any moment, at most re_send_batch sendctxes are
held by unswept unsignaled Sends, leaving the rest of the ring
available for newly admitted Sends.

Allocate max_reqs + DIV_ROUND_UP(max_reqs, 8) request objects
and name the slack calculation at the allocation site so the
1/8 bound stays tied to the Send-signaling batch size.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index f1a6b98b8aa98..5d588d26b8bab 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1076,6 +1076,22 @@ static void rpcrdma_reps_destroy(struct rpcrdma_buffer *buf)
 	spin_unlock(&buf->rb_lock);
 }
 
+static unsigned int rpcrdma_req_pool_slack(unsigned int max_reqs)
+{
+	/* The sendctx ring can hold up to one Send-signaling batch
+	 * (re_send_batch, set by frwr_open() to re_max_requests >> 3)
+	 * of unfinished Sends. Each pins its req until a signaled Send
+	 * completion releases the sendctx. Size the pool above max_reqs
+	 * by that batch so the recycle delay does not stall a slot
+	 * allocation that the RPC/RDMA credit window would admit.
+	 *
+	 * Round up: re_max_requests >> 3 is zero when max_reqs < 8, but
+	 * a single unsignaled Send is still enough to pin one req. One
+	 * slack slot covers that case.
+	 */
+	return DIV_ROUND_UP(max_reqs, 8);
+}
+
 /**
  * rpcrdma_buffer_create - Create initial set of req/rep objects
  * @r_xprt: transport instance to (re)initialize
@@ -1085,6 +1101,7 @@ static void rpcrdma_reps_destroy(struct rpcrdma_buffer *buf)
 int rpcrdma_buffer_create(struct rpcrdma_xprt *r_xprt)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
+	unsigned int max_reqs;
 	int i, rc;
 
 	buf->rb_bc_srv_max_requests = 0;
@@ -1098,7 +1115,9 @@ int rpcrdma_buffer_create(struct rpcrdma_xprt *r_xprt)
 	INIT_LIST_HEAD(&buf->rb_all_reps);
 
 	rc = -ENOMEM;
-	for (i = 0; i < r_xprt->rx_xprt.max_reqs; i++) {
+	max_reqs = r_xprt->rx_xprt.max_reqs;
+	max_reqs += rpcrdma_req_pool_slack(max_reqs);
+	for (i = 0; i < max_reqs; i++) {
 		struct rpcrdma_req *req;
 
 		req = rpcrdma_req_create(r_xprt, RPCRDMA_V1_DEF_INLINE_SIZE * 2,
-- 
2.53.0



