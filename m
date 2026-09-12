Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00264381AF4;
	Sat, 12 Sep 2026 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215310; cv=none; b=ahkWBeMS0rrRXgV1YsSG7wYZ+c03w7OZemnt4eGoD+QDq3Pb9OfMVWky8vEv7T8jNd/vfjZy2L4AQx1wduN4cVGN0VaWEszBzcNXQShbopEAKlsGCsrrsJko9AQxYEoHaoBXX4SUo33KjFZ/QGqvCsjN80RzAFfwUk2SKwB1Vkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215310; c=relaxed/simple;
	bh=DnNPiZi/VnWETP3LA9vDPieVfBlkw9jEI3iSPNYdgic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klLfgWGA76D+RPlgVIpJBiKcUgn24Ly3HYNMIre05H/+vTaXIx2skmd63SvlHhQqvpVMQHzeal2YijjjAC0jYkmCXl6fDtFKprNu6Of5xIQpP98FV5SZ3cbCYJhQxPla0UI7BnuJFDDZ2sy+CmfYsLLLjxTyv8L5KoIqxXpG3Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Wv2De2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Wv2De2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97531F000FF;
	Sat, 12 Sep 2026 12:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215308;
	bh=CUtljDcvvNukCXIY58gXySY95HD0Os+tnwIhgV7Lfok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Wv2De2qx8poTAft1JdD26jOhplS68oOmvaUwPBmW2BrfbDQ6O1y2NSW/ulBNnoMO
	 ujj4+jco4ivz7pellZWFultTDhrutUmcWWCYK1ruu9HBkP0v2d20WkuFwFoPwoWqB2
	 89onpnaZLMJ9DP2XWrRDqZOb+vqI78/DNFwKvfuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0504/1376] RDMA/rxe: Avoid reprocessing the current packet after the QP enters the error state
Date: Sat, 12 Sep 2026 08:48:50 +0200
Message-ID: <20260912065618.773154620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 15ae32c4a3551c4c9da457370bdfdd65d171e512 ]

When do_complete() finds the QP in the error state it returns
RESPST_CHK_RESOURCE.  Before commit 49dc9c1f0c7e ("RDMA/rxe: Cleanup
reset state handling in rxe_resp.c") this was the flush loop:
check_resource() had an error-state branch that fetched each remaining
recv WQE and completed it with IB_WC_WR_FLUSH_ERR, without touching
the current packet.  That commit removed the error-state branch from
check_resource() (draining is now done at rxe_receiver() entry) but
kept the do_complete() error-state return.

As a result, when a QP moves to the error state while a packet is
being completed - e.g. an rdma_cm disconnect racing with receive
processing - the responder state machine loops back into the request
processing chain with the already-completed packet still in hand:
check_resource() fetches a fresh recv WQE, execute()/send_data_in()
copies the same packet payload again, do_complete() posts another
IB_WC_SUCCESS CQE (qp->resp.status is still 0), and control returns
to the error-state check.  The loop re-executes the same packet once
per posted recv WQE (observed: ~1000 duplicate IB_WC_SUCCESS
completions of one SEND, one per ~8us, matching the RQ occupancy)
until the RQ is exhausted, after which qp->resp.wqe is NULL and
send_data_in() dereferences it:

  BUG: kernel NULL pointer dereference, address: 0000000000000014
  Workqueue: rxe_wq do_work
  RIP: copy_data+0x29/0x1f0
  Call Trace:
   send_data_in+0x25/0x50
   rxe_receiver+0xf36/0x1dd0

The duplicate completions are indistinguishable from real receives to
the ULP.  During an rds stress test, the message was accepted as new and
delivered the same datagram to user space hundreds of times, corrupting
the stream; any ULP that relies on RC exactly-once delivery is affected.

A live packet reaching the error-state check in do_complete() has
been executed and completed exactly once and must be consumed, not
re-processed.  Return RESPST_CLEANUP for it (dequeue and free); keep
returning RESPST_CHK_RESOURCE for the pkt == NULL case.

Fixes: 49dc9c1f0c7e ("RDMA/rxe: Cleanup reset state handling in rxe_resp.c")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260711165419.13486-1-achender@kernel.org
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 5611f63a1115c..abf6cf3ce986b 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1188,7 +1188,14 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 	spin_lock_irqsave(&qp->state_lock, flags);
 	if (unlikely(qp_state(qp) == IB_QPS_ERR)) {
 		spin_unlock_irqrestore(&qp->state_lock, flags);
-		return RESPST_CHK_RESOURCE;
+		/* The packet was executed and completed before the QP
+		 * moved to ERROR; it must be consumed exactly once.
+		 * Re-entering the request chain with the stale packet
+		 * would copy it into every remaining recv WQE as a new
+		 * completion.  Remaining WQEs are flushed by the drain
+		 * path at rxe_receiver() entry.
+		 */
+		return pkt ? RESPST_CLEANUP : RESPST_CHK_RESOURCE;
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 
-- 
2.53.0



