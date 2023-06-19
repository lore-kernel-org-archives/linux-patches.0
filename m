Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71E95381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014A8C433C0;
	Mon, 19 Jun 2023 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171367;
	bh=BATRtXwuWyndhYr+1qrdbUgj8XrIrPt4UkQXnPg6g7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKQo7mKP/dEwDQurYVaoAajpLiU2bKx588cxvja0z5e8kgCuH8Iq/lM5TdJoeu4nS
	 lTHKMV6by+6FZM6uAPjsk8OqnoXeWbtHja/KyD4Oi0Ra/lBCkH/9NTCeCyVZ3h61Ck
	 Hxy/FUpw0gbutTrSFQdn99e0/ShcC3/uAJWrS06k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ziemba <ian.ziemba@hpe.com>,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/49] RDMA/rxe: Removed unused name from rxe_task struct
Date: Mon, 19 Jun 2023 12:30:08 +0200
Message-ID: <20230619102131.451779801@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit de669ae8af49ceed0eed44f5b3d51dc62affc5e4 ]

The name field in struct rxe_task is never used. This patch removes it.

Link: https://lore.kernel.org/r/20221021200118.2163-4-rpearsonhpe@gmail.com
Signed-off-by: Ian Ziemba <ian.ziemba@hpe.com>
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 2a62b6210ce8 ("RDMA/rxe: Fix the use-before-initialization error of resp_pkts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c   | 9 +++------
 drivers/infiniband/sw/rxe/rxe_task.c | 4 +---
 drivers/infiniband/sw/rxe/rxe_task.h | 4 +---
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index a797b5d23f507..b137ed1c74af1 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -268,10 +268,8 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	skb_queue_head_init(&qp->req_pkts);
 
-	rxe_init_task(&qp->req.task, qp,
-		      rxe_requester, "req");
-	rxe_init_task(&qp->comp.task, qp,
-		      rxe_completer, "comp");
+	rxe_init_task(&qp->req.task, qp, rxe_requester);
+	rxe_init_task(&qp->comp.task, qp, rxe_completer);
 
 	qp->qp_timeout_jiffies = 0; /* Can't be set for UD/UC in modify_qp */
 	if (init->qp_type == IB_QPT_RC) {
@@ -317,8 +315,7 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	skb_queue_head_init(&qp->resp_pkts);
 
-	rxe_init_task(&qp->resp.task, qp,
-		      rxe_responder, "resp");
+	rxe_init_task(&qp->resp.task, qp, rxe_responder);
 
 	qp->resp.opcode		= OPCODE_NONE;
 	qp->resp.msn		= 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index ea7d5a69eb2a3..39b3adda16550 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -114,12 +114,10 @@ void rxe_do_task(unsigned long data)
 	task->ret = ret;
 }
 
-int rxe_init_task(struct rxe_task *task,
-		  void *arg, int (*func)(void *), char *name)
+int rxe_init_task(struct rxe_task *task, void *arg, int (*func)(void *))
 {
 	task->arg	= arg;
 	task->func	= func;
-	snprintf(task->name, sizeof(task->name), "%s", name);
 	task->destroyed	= false;
 
 	tasklet_init(&task->tasklet, rxe_do_task, (unsigned long)task);
diff --git a/drivers/infiniband/sw/rxe/rxe_task.h b/drivers/infiniband/sw/rxe/rxe_task.h
index e87ee072e3179..ecd81b1d1a8cb 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.h
+++ b/drivers/infiniband/sw/rxe/rxe_task.h
@@ -52,7 +52,6 @@ struct rxe_task {
 	void			*arg;
 	int			(*func)(void *arg);
 	int			ret;
-	char			name[16];
 	bool			destroyed;
 };
 
@@ -61,8 +60,7 @@ struct rxe_task {
  *	arg  => parameter to pass to fcn
  *	fcn  => function to call until it returns != 0
  */
-int rxe_init_task(struct rxe_task *task,
-		  void *arg, int (*func)(void *), char *name);
+int rxe_init_task(struct rxe_task *task, void *arg, int (*func)(void *));
 
 /* cleanup task */
 void rxe_cleanup_task(struct rxe_task *task);
-- 
2.39.2



