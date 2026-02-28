Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20E33A6F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302190; cv=none; b=W6fNEwuGH4d5Wowpf6q5G3SeNOcdjYtdWA0N0B2cGliTkL9gRMkOo/+cQya8X3ZioAuL40GpPm7WLNwG6EV0iMzN09kczlxw/J6CXY/zB994m3W4mSA2k/Ao+RB1cY9jhh+kOHoIOPHgO9SQpAazdnNrdpA0EVGlPjULf7UEiLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302190; c=relaxed/simple;
	bh=juUR0amETMlzXtSptGui99tvxODr2K6/P+p35SyGGrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbaDW3/EIS8xWPceC9hMgfOkKkw1DcPWtD7CZyQaVtTvSb//D8lkah+5aPAvx6qtjlI9Xk+b58GEFSha+vHP1inXKGGxNoJQCma6npUtqzzrWBb0z0NpSvnlhBQhhx8GKC6zYwFAQ4g9Quc6XvEIyU/mQaSEYqz5E+VY+hjHUnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jnOkNWQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jnOkNWQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5A5C116D0;
	Sat, 28 Feb 2026 18:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302189;
	bh=juUR0amETMlzXtSptGui99tvxODr2K6/P+p35SyGGrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnOkNWQvT4tdNC9H71vJia6dYX1jobwYruZAZxfTaAEbKAQqSGYBI8cjr08GOvqOq
	 M7OdhyPoh+YKVdyssA/chO3ABuSsUwYEpI1AJ9ZdQ+fnkMl5WQSKtUcYdkMSQsUaqH
	 i79SRwM6dGeI75RYD9ZGiEnGB6PuClKEQwNVdmivEXJTgH8hzOH9PpWVzpZ6xbaH8/
	 YAAkw9s1YESyXaXJjtZ5ky+QnS9y12M6rN1bjyLESUr9Aek85LwpTCb3U965Ex3sa/
	 aJjn5EVTedQUwP5YiGfwsH4oWfHbPCyLiza3NG7eggdN4hsH8MHsPlFXMfv7CX3nNb
	 DFgMIC8DIpwHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/283] RDMA/rxe: Fix race condition in QP timer handlers
Date: Sat, 28 Feb 2026 13:05:33 -0500
Message-ID: <20260228180709.1583486-191-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 87bf646921430e303176edc4eb07c30160361b73 ]

I encontered the following warning:
 WARNING: drivers/infiniband/sw/rxe/rxe_task.c:249 at rxe_sched_task+0x1c8/0x238 [rdma_rxe], CPU#0: swapper/0/0
...
  libsha1 [last unloaded: ip6_udp_tunnel]
 CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G         C          6.19.0-rc5-64k-v8+ #37 PREEMPT
 Tainted: [C]=CRAP
 Hardware name: Raspberry Pi 4 Model B Rev 1.2
 Call trace:
  rxe_sched_task+0x1c8/0x238 [rdma_rxe] (P)
  retransmit_timer+0x130/0x188 [rdma_rxe]
  call_timer_fn+0x68/0x4d0
  __run_timers+0x630/0x888
...
 WARNING: drivers/infiniband/sw/rxe/rxe_task.c:38 at rxe_sched_task+0x1c0/0x238 [rdma_rxe], CPU#0: swapper/0/0
...
 WARNING: drivers/infiniband/sw/rxe/rxe_task.c:111 at do_work+0x488/0x5c8 [rdma_rxe], CPU#3: kworker/u17:4/93400
...
 refcount_t: underflow; use-after-free.
 WARNING: lib/refcount.c:28 at refcount_warn_saturate+0x138/0x1a0, CPU#3: kworker/u17:4/93400

The issue is caused by a race condition between retransmit_timer() and
rxe_destroy_qp, leading to the Queue Pair's (QP) reference count dropping
to zero during timer handler execution.

It seems this warning is harmless because rxe_qp_do_cleanup() will flush
all pending timers and requests.

Example of flow causing the issue:

CPU0                                   CPU1
retransmit_timer() {
    spin_lock_irqsave
                           rxe_destroy_qp()
                            __rxe_cleanup()
                              __rxe_put() // qp->ref_count decrease to 0
                            rxe_qp_do_cleanup() {
    if (qp->valid) {
        rxe_sched_task() {
            WARN_ON(rxe_read(task->qp) <= 0);
        }
    }
    spin_unlock_irqrestore
}
                              spin_lock_irqsave
                              qp->valid = 0
                              spin_unlock_irqrestore
                            }

Ensure the QP's reference count is maintained and its validity is checked
within the timer callbacks by adding calls to rxe_get(qp) and corresponding
rxe_put(qp) after use.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Fixes: d94671632572 ("RDMA/rxe: Rewrite rxe_task.c")
Link: https://patch.msgid.link/20260120074437.623018-1-lizhijian@fujitsu.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 3 +++
 drivers/infiniband/sw/rxe/rxe_req.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index c997b7cbf2a9e..81b645c727a17 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -119,12 +119,15 @@ void retransmit_timer(struct timer_list *t)
 
 	rxe_dbg_qp(qp, "retransmit timer fired\n");
 
+	if (!rxe_get(qp))
+		return;
 	spin_lock_irqsave(&qp->state_lock, flags);
 	if (qp->valid) {
 		qp->comp.timeout = 1;
 		rxe_sched_task(&qp->comp.task);
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
+	rxe_put(qp);
 }
 
 void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 7ff152ffe15b9..4d550ac0dac5a 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -103,6 +103,8 @@ void rnr_nak_timer(struct timer_list *t)
 
 	rxe_dbg_qp(qp, "nak timer fired\n");
 
+	if (!rxe_get(qp))
+		return;
 	spin_lock_irqsave(&qp->state_lock, flags);
 	if (qp->valid) {
 		/* request a send queue retry */
@@ -111,6 +113,7 @@ void rnr_nak_timer(struct timer_list *t)
 		rxe_sched_task(&qp->req.task);
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
+	rxe_put(qp);
 }
 
 static void req_check_sq_drain_done(struct rxe_qp *qp)
-- 
2.51.0

