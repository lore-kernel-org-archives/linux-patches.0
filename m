Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105C4078E8;
	Sat, 12 Sep 2026 09:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207101; cv=none; b=SuiST1a9meHCR/d0VfkbOc2PBVbP+YXDlc7iUgW0pt0qIBtVpWkbWu3ycn8kEaboaA/yokE9WAXa0RcCk//RSRUeRKcHTGsRk+cs5I1qOo+nlyqzuJspY/xmLlSqsT1oC7b8Lcse7zQT7dFSbn4poYoLwlYV8+Zt4DaS3VLtxig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207101; c=relaxed/simple;
	bh=JcdRGVTlqSBXjGZZHAnhwSvRru48h3s7tJdHPC4H278=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqhQnq3rEdAA2qOKJC0MkXb5KZ7hhtfy6Hz8zTKAzua9/j0eM9skbXuLzZ1ip6js2Y2jYETNN87n/ukgGhpXHapLfQnN5TPKucMOEcW+XKhXUwIDy2HG4ubBq6ou3KhwsCFOf+2ki8+JGXiHzkhXSrq9MtAc5++9zaZNUTbNZJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo61NGrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo61NGrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F2F1F000FF;
	Sat, 12 Sep 2026 09:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207100;
	bh=RrxqddRSqDPQpvdaLw1xSvCgrVdDF92Tc+VBgIPYw50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fo61NGrloN9qN7Rtzthje/4ayrfKGq1I7CwI94nBGxuT6ObYNj48WkLmRqIBWd4V+
	 tCXS1D9J4P01Y7qznD+n+ggTMZr1sbSiRafb/a8gxLSOOJ01SVQt1cT5Xb9EEBXICS
	 FTzh3LdAiYd3YI3Z4xriiL5vt0bWOomYJO3B+RZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0343/1518] RDMA/rxe: Avoid reprocessing the current packet after the QP enters the error state
Date: Sat, 12 Sep 2026 08:41:52 +0200
Message-ID: <20260912065631.234259519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 995805e16d78b..6aabf1d07ea34 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1203,7 +1203,14 @@ static enum resp_states do_complete(struct rxe_qp *qp,
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



