Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61AC3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A63BC433C9;
	Mon, 19 Jun 2023 10:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171063;
	bh=W5G6nBpbdDuLzXyolWXhyJT7ng5vwLVIdAdMBKkdkns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFWwqX5u79Mi7Qx8+X842rzWYTI9Z3UBPzDuLGspNBmrvBbVtVINlH7C6k1A4e3m/
	 4k6FSp8Du1A6sZmu/zSTjz4+K3R4TLYc5BADtTZhlPwr4sFMQcpr7sjJfRvs7WG8eR
	 batnRI92hlu2tSvzWnRZTD1O/tuiaUnoauezBFL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 135/187] RDMA/rxe: Fix the use-before-initialization error of resp_pkts
Date: Mon, 19 Jun 2023 12:29:13 +0200
Message-ID: <20230619102204.151689064@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 2a62b6210ce876c596086ab8fd4c8a0c3d10611a ]

In the following:

  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
   assign_lock_key kernel/locking/lockdep.c:982 [inline]
   register_lock_class+0xdb6/0x1120 kernel/locking/lockdep.c:1295
   __lock_acquire+0x10a/0x5df0 kernel/locking/lockdep.c:4951
   lock_acquire kernel/locking/lockdep.c:5691 [inline]
   lock_acquire+0x1b1/0x520 kernel/locking/lockdep.c:5656
   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
   _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
   skb_dequeue+0x20/0x180 net/core/skbuff.c:3639
   drain_resp_pkts drivers/infiniband/sw/rxe/rxe_comp.c:555 [inline]
   rxe_completer+0x250d/0x3cc0 drivers/infiniband/sw/rxe/rxe_comp.c:652
   rxe_qp_do_cleanup+0x1be/0x820 drivers/infiniband/sw/rxe/rxe_qp.c:761
   execute_in_process_context+0x3b/0x150 kernel/workqueue.c:3473
   __rxe_cleanup+0x21e/0x370 drivers/infiniband/sw/rxe/rxe_pool.c:233
   rxe_create_qp+0x3f6/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:583

This is a use-before-initialization problem.

It happens because rxe_qp_do_cleanup is called during error unwind before
the struct has been fully initialized.

Move the initialization of the skb earlier.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20230602035408.741534-1-yanjun.zhu@intel.com
Reported-by: syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index d5de5ba6940f1..94a7f5ebc6292 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -176,6 +176,9 @@ static void rxe_qp_init_misc(struct rxe_dev *rxe, struct rxe_qp *qp,
 	spin_lock_init(&qp->rq.producer_lock);
 	spin_lock_init(&qp->rq.consumer_lock);
 
+	skb_queue_head_init(&qp->req_pkts);
+	skb_queue_head_init(&qp->resp_pkts);
+
 	atomic_set(&qp->ssn, 0);
 	atomic_set(&qp->skb_out, 0);
 }
@@ -236,8 +239,6 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	qp->req.opcode		= -1;
 	qp->comp.opcode		= -1;
 
-	skb_queue_head_init(&qp->req_pkts);
-
 	rxe_init_task(&qp->req.task, qp, rxe_requester);
 	rxe_init_task(&qp->comp.task, qp, rxe_completer);
 
@@ -281,8 +282,6 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 		}
 	}
 
-	skb_queue_head_init(&qp->resp_pkts);
-
 	rxe_init_task(&qp->resp.task, qp, rxe_responder);
 
 	qp->resp.opcode		= OPCODE_NONE;
-- 
2.39.2



