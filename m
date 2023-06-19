Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6284AC123
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851BCC433C9;
	Mon, 19 Jun 2023 11:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172447;
	bh=ZVnskgNcEpnqTNSbqcUMFbU+Fsvac14gY6lIINMpfOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKdJqf0F9dMTIPLBPk/gFoDCAjmVN2gyrAxt52WgtQubiiG+SHjmnAE2o+gPeAHNp
	 EWbybd7bOvcA8bvDtlAyBBpRuBbuTwzG5fl9gdAw8WcyaIPdIzx4WIOU6H0blhRGdw
	 CcQzJNeVKbd5F8LRN1jacCL1Kc44+MwfCdyZr2WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/107] RDMA/rxe: Remove the unused variable obj
Date: Mon, 19 Jun 2023 12:30:55 +0200
Message-ID: <20230619102144.844946469@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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

[ Upstream commit f07853582d1f6ed282f8d9a0b1209a87dd761f58 ]

The member variable obj in struct rxe_task is not needed.
So remove it to save memory.

Link: https://lore.kernel.org/r/20220822011615.805603-4-yanjun.zhu@linux.dev
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 2a62b6210ce8 ("RDMA/rxe: Fix the use-before-initialization error of resp_pkts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c   | 6 +++---
 drivers/infiniband/sw/rxe/rxe_task.c | 3 +--
 drivers/infiniband/sw/rxe/rxe_task.h | 3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index d7a968356a9bb..5b78230692fda 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -265,9 +265,9 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	skb_queue_head_init(&qp->req_pkts);
 
-	rxe_init_task(rxe, &qp->req.task, qp,
+	rxe_init_task(&qp->req.task, qp,
 		      rxe_requester, "req");
-	rxe_init_task(rxe, &qp->comp.task, qp,
+	rxe_init_task(&qp->comp.task, qp,
 		      rxe_completer, "comp");
 
 	qp->qp_timeout_jiffies = 0; /* Can't be set for UD/UC in modify_qp */
@@ -315,7 +315,7 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	skb_queue_head_init(&qp->resp_pkts);
 
-	rxe_init_task(rxe, &qp->resp.task, qp,
+	rxe_init_task(&qp->resp.task, qp,
 		      rxe_responder, "resp");
 
 	qp->resp.opcode		= OPCODE_NONE;
diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index 568cf56c236bc..f48882b20d6b2 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -95,10 +95,9 @@ void rxe_do_task(struct tasklet_struct *t)
 	task->ret = ret;
 }
 
-int rxe_init_task(void *obj, struct rxe_task *task,
+int rxe_init_task(struct rxe_task *task,
 		  void *arg, int (*func)(void *), char *name)
 {
-	task->obj	= obj;
 	task->arg	= arg;
 	task->func	= func;
 	snprintf(task->name, sizeof(task->name), "%s", name);
diff --git a/drivers/infiniband/sw/rxe/rxe_task.h b/drivers/infiniband/sw/rxe/rxe_task.h
index 11d183fd33386..7f612a1c68a7b 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.h
+++ b/drivers/infiniband/sw/rxe/rxe_task.h
@@ -19,7 +19,6 @@ enum {
  * called again.
  */
 struct rxe_task {
-	void			*obj;
 	struct tasklet_struct	tasklet;
 	int			state;
 	spinlock_t		state_lock; /* spinlock for task state */
@@ -35,7 +34,7 @@ struct rxe_task {
  *	arg  => parameter to pass to fcn
  *	func => function to call until it returns != 0
  */
-int rxe_init_task(void *obj, struct rxe_task *task,
+int rxe_init_task(struct rxe_task *task,
 		  void *arg, int (*func)(void *), char *name);
 
 /* cleanup task */
-- 
2.39.2



