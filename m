Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6423911706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB10AC433C8;
	Mon, 11 Sep 2023 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443929;
	bh=/7PQcGbXpIXX2suuloLKXiQ2i59Tnd3kNLrysKk/2jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqyPj8fMYqnWQ0TiYDciDmV1FSZflLFxIBf/0yVk7LppTpQ+ddMu+ky+E0r/GH97j
	 EETYlVLqjP8lAK9scJnzkli7L2svY6OZBF9V7mIkFe4ukFzz83cY9IyAhvRAgANzNK
	 U7HbLFmzRCiyCpPGS0CCcjC8e2specV7Y1m8Qhbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2da1965168e7dbcba136@syzkaller.appspotmail.com,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 521/737] RDMA/rxe: Fix unsafe drain work queue code
Date: Mon, 11 Sep 2023 15:46:20 +0200
Message-ID: <20230911134705.131358244@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 5993b75d0bc71cd2b441d174b028fc36180f032c ]

If create_qp does not fully succeed it is possible for qp cleanup
code to attempt to drain the send or recv work queues before the
queues have been created causing a seg fault. This patch checks
to see if the queues exist before attempting to drain them.

Link: https://lore.kernel.org/r/20230620135519.9365-3-rpearsonhpe@gmail.com
Reported-by: syzbot+2da1965168e7dbcba136@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-rdma/00000000000012d89205fe7cfe00@google.com/raw
Fixes: 49dc9c1f0c7e ("RDMA/rxe: Cleanup reset state handling in rxe_resp.c")
Fixes: fbdeb828a21f ("RDMA/rxe: Cleanup error state handling in rxe_comp.c")
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 4 ++++
 drivers/infiniband/sw/rxe/rxe_resp.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index f46c5a5fd0aea..44fece204abdd 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -597,6 +597,10 @@ static void flush_send_queue(struct rxe_qp *qp, bool notify)
 	struct rxe_queue *q = qp->sq.queue;
 	int err;
 
+	/* send queue never got created. nothing to do. */
+	if (!qp->sq.queue)
+		return;
+
 	while ((wqe = queue_head(q, q->type))) {
 		if (notify) {
 			err = flush_send_wqe(qp, wqe);
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index ee68306555b99..ed5af55237d9f 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1452,6 +1452,10 @@ static void flush_recv_queue(struct rxe_qp *qp, bool notify)
 	if (qp->srq)
 		return;
 
+	/* recv queue not created. nothing to do. */
+	if (!qp->rq.queue)
+		return;
+
 	while ((wqe = queue_head(q, q->type))) {
 		if (notify) {
 			err = flush_recv_wqe(qp, wqe);
-- 
2.40.1



