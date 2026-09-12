Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C291829D288;
	Sat, 12 Sep 2026 12:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217268; cv=none; b=N7CvKg0endj2XgerzEzbMvT1VdZ0AWxFPOAZcqPWZ52lG+fQJ8S7mN/cK6x2qGzsXyIbsqbf35dOdWnySyKWiQJaCtYuwD+ko8S/qoEsHaR98UIAQDRkwGMrOP62z11fkK3tMIVXcBlt7g0gC0AM0YqCE7UUAKFCdUKDj6ZkMFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217268; c=relaxed/simple;
	bh=tqZ9n2txXkSzcajPEIAZaci5PuqHF5d3Pd2ueYeYXJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJfuLvPRfcXnb6vKXkzvmrbYnqkElBhLVJywbOZ459Ov/N69eFgv/IAunKxx5UancaUwgzemZ3NbINgI7YsFRH+XW0LJjl5lG/lpn5JPtz40mjDNOEPNQFTZ2THELjzRs5/36QJ22Irn1xDpps5b79R7sLJLyjUhOhSQqUg7Ezs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIb8GUMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIb8GUMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712141F000FF;
	Sat, 12 Sep 2026 12:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217267;
	bh=idgC2ElOpSD8L/bey6qtjVeqs36c3FrRTf/Au5R4Ky8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIb8GUMTB2GsoY59C42d1g6zXlNbBWVLGU7V3m9hRU6MkQj9PVT0MdORsTMnW1F82
	 mMzTfh5nJBf1An9I4cEaCDzeeIuxzGJiUz4YXblGOkeWYXIy3dvs9FUUZ9Ej9Raejk
	 45rF8LP34jhBSZzzig3osK9zQaW+9qdXAHLeKJDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0906/1376] RDMA/erdma: Hold QP references for AE and CM processing
Date: Sat, 12 Sep 2026 08:55:32 +0200
Message-ID: <20260912065627.759569139@linuxfoundation.org>
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
index e0acc185e7193..f0c8ebf62a057 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -1021,10 +1021,9 @@ int erdma_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (laddr->sa_family != AF_INET || raddr->sa_family != AF_INET)
 		return -EAFNOSUPPORT;
 
-	qp = find_qp_by_qpn(dev, params->qpn);
+	qp = erdma_qp_get_by_qpn(dev, params->qpn);
 	if (!qp)
 		return -ENOENT;
-	erdma_qp_get(qp);
 
 	ret = sock_create(AF_INET, SOCK_STREAM, IPPROTO_TCP, &s);
 	if (ret < 0)
@@ -1154,10 +1153,9 @@ int erdma_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		return -ECONNRESET;
 	}
 
-	qp = find_qp_by_qpn(dev, params->qpn);
+	qp = erdma_qp_get_by_qpn(dev, params->qpn);
 	if (!qp)
 		return -ENOENT;
-	erdma_qp_get(qp);
 
 	down_write(&qp->state_lock);
 	if (qp->attrs.iwarp.state > ERDMA_QPS_IWARP_RTR) {
diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index 6bffbc1b543be..e4161e85422c6 100644
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
index c9d454813b1f0..057efff532b4f 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1321,6 +1321,7 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		udata, struct erdma_ucontext, ibucontext);
 	struct erdma_cmdq_destroy_qp_req req;
 	union erdma_mod_qp_params params;
+	unsigned long flags;
 	int err;
 
 	down_write(&qp->state_lock);
@@ -1348,6 +1349,10 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 				       "failed to destroy QP %u: %d\n",
 				       QP_ID(qp), err);
 
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	__xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
 
@@ -1361,7 +1366,6 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (qp->cep)
 		erdma_cep_put(qp->cep);
-	xa_erase(&dev->qp_xa, QP_ID(qp));
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 22ceb5fe7ca2a..a752bf7c4c1ec 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -360,6 +360,21 @@ static inline struct erdma_qp *find_qp_by_qpn(struct erdma_dev *dev, int id)
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



