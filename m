Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345A73CAE74;
	Sat, 17 Oct 2026 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260091; cv=none; b=N6HX7DpTXhJBA/uDmodDVyLdoRBg621xZnNL9Iq2TyQ1O80mHxUuaM2uRiWD8We4eKsfx+Z7XAdPQ1qTmyjeqy92sWbqK3QF84ypOxBqeBt8RxtmxjYE59KSah/wlu0MH3i/jYM8R0hiC7c9k3IilpBrzvIwbzU5XhmvTN2k9Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260091; c=relaxed/simple;
	bh=H7KghDz8xltWlku0hrKHM8MfdUEOxsYDSoU5DjzTiaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVudxSkqca/zGoxHwLIzgvXuql2K1I5AtjRB5d6Fe6DErwMonntvTwMvwW2MKFcuZ703z46kvu3l4N3kgkj59a9Dw4dDOY0HGubXkfT47xKNWbMJTCE0L7vpfYVdWuuuUda9bF1Sr4bjeu+YVoVD3fEVdueitMJHvcjje1WFKaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVe0oi5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVe0oi5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABCE1F000C4;
	Sat, 17 Oct 2026 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260090;
	bh=4gaJ71GUBCHASPK7cGZPRyWqvuqjDsg/s36J2f1+QCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVe0oi5l9VshbNIFagOowtr3iITzyTula3fvxIavDeZLlZgxdMJcT4ssuF900H0ff
	 LDO2HEt6dSxEhZdA+LIRETuMyKWI784rGDR6euXuh2dOXkHdo/ifBUdhKUeQnZb3YJ
	 yW5cuoFeVJONz2UED0Qps+XQ/gqiE50Od+zZ0ujk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1430/1674] RDMA/erdma: Hold QP references for AE and CM processing
Date: Sat, 17 Oct 2026 18:01:42 +0200
Message-ID: <20261017160507.887919733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit a52eeff32024f190b3bdc99088c7becccd4fa60b ]

AE QP fatal events and iWARP CM paths load QPs from dev->qp_xa
and then use or reference them outside the xarray lock.
erdma_destroy_qp() can drop the destroy-path reference and free QP
resources while such a lookup is in flight.

Add erdma_qp_get_by_qpn() to acquire a kref under the xarray
lock with kref_get_unless_zero(). Remove the QP from the xarray
before dropping the destroy-path reference so no new lookup can acquire
it while destruction waits for existing users.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20260730124357.12976-2-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_cm.c    |  6 ++----
 drivers/infiniband/hw/erdma/erdma_eq.c    |  3 ++-
 drivers/infiniband/hw/erdma/erdma_verbs.c |  6 +++++-
 drivers/infiniband/hw/erdma/erdma_verbs.h | 15 +++++++++++++++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index e349e8d2fb50a..c747f77c1bdbd 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -1017,10 +1017,9 @@ int erdma_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (laddr->sa_family != AF_INET || raddr->sa_family != AF_INET)
 		return -EAFNOSUPPORT;
 
-	qp = find_qp_by_qpn(dev, params->qpn);
+	qp = erdma_qp_get_by_qpn(dev, params->qpn);
 	if (!qp)
 		return -ENOENT;
-	erdma_qp_get(qp);
 
 	ret = sock_create(AF_INET, SOCK_STREAM, IPPROTO_TCP, &s);
 	if (ret < 0)
@@ -1149,10 +1148,9 @@ int erdma_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		return -ECONNRESET;
 	}
 
-	qp = find_qp_by_qpn(dev, params->qpn);
+	qp = erdma_qp_get_by_qpn(dev, params->qpn);
 	if (!qp)
 		return -ENOENT;
-	erdma_qp_get(qp);
 
 	down_write(&qp->state_lock);
 	if (qp->attrs.state > ERDMA_QP_STATE_RTR) {
diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index 3fec9cd18afaf..9d5b75abf06ab 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -65,7 +65,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 			erdma_cq_put(cq);
 		} else {
 			qpn = le32_to_cpu(aeqe->event_data0);
-			qp = find_qp_by_qpn(dev, qpn);
+			qp = erdma_qp_get_by_qpn(dev, qpn);
 			if (!qp)
 				continue;
 
@@ -75,6 +75,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 			if (qp->ibqp.event_handler)
 				qp->ibqp.event_handler(&event,
 						       qp->ibqp.qp_context);
+			erdma_qp_put(qp);
 		}
 	}
 
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 066144ae3b248..047f5977c420b 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1266,6 +1266,7 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	struct erdma_ucontext *ctx = rdma_udata_to_drv_context(
 		udata, struct erdma_ucontext, ibucontext);
 	struct erdma_qp_attrs qp_attrs;
+	unsigned long flags;
 	int err;
 	struct erdma_cmdq_destroy_qp_req req;
 
@@ -1284,6 +1285,10 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	__xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
 
@@ -1306,7 +1311,6 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (qp->cep)
 		erdma_cep_put(qp->cep);
-	xa_erase(&dev->qp_xa, QP_ID(qp));
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 10b9b8a5f6a8b..687017531b958 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -280,6 +280,21 @@ static inline struct erdma_qp *find_qp_by_qpn(struct erdma_dev *dev, int id)
 	return (struct erdma_qp *)xa_load(&dev->qp_xa, id);
 }
 
+static inline struct erdma_qp *erdma_qp_get_by_qpn(struct erdma_dev *dev,
+						   int id)
+{
+	struct erdma_qp *qp;
+	unsigned long flags;
+
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	qp = xa_load(&dev->qp_xa, id);
+	if (qp && !kref_get_unless_zero(&qp->ref))
+		qp = NULL;
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
+	return qp;
+}
+
 static inline struct erdma_cq *erdma_cq_get_by_cqn(struct erdma_dev *dev,
 						   int id)
 {
-- 
2.53.0



