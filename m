Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E193DD847;
	Sat, 12 Sep 2026 08:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201957; cv=none; b=qtSakISPRVfixIcYFZSHRWMiLMnKpAonQId1SIAPZCNXBWY3/7uwYhfLNwpN1FcTrCTEUPi3p0QWtMwdVdjeDztS23G5p3vB4nsBUoggLKIa8CKaa16MCxJjzH5zUTVQmESdCCFsRxfY/jik2K8/sstJ9HS153q4+gakSB4tYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201957; c=relaxed/simple;
	bh=+ElLt4zwp17wsmdX7ZN4zb4CSCIjjZyNg142dx5Wx/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhlLH0NuhZoac1r1U+wmw1L6ZfX5krTE9FaaIDP5pbfFmmHZLXBPdI0vrv8cCbknL/yUcOwP/ZPXI729TCO6ldlNI7DxwZVMDAqPZ1Pk25marpr/sJadUkWqkyn2jyBp944R1/8pigwElpee8GbUYO0Nm31b5bBMlhfUoPNJ1Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5++tA0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5++tA0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950B21F000FF;
	Sat, 12 Sep 2026 08:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201955;
	bh=YTJMUGcudcwnMPD4Pz80lfzkug8JLM0+mCrDtHh6xZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5++tA0yVkWaYO9aaFKPmo5E45bI6+ArAZdyZ8VEt82gqb4vNytmEa2K/6MxWEV0k
	 Hvsw9MBoIBuba5juPc4i4yQR7bhN+EXLeq0DWVmAVwWPidwgR4Oz8aZxx97pqptNtI
	 oygQv6X8xtKyJghWkSJbywTS/FnkVYwmnJH9suMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1104/1815] RDMA/erdma: Hold QP references for AE and CM processing
Date: Sat, 12 Sep 2026 08:47:34 +0200
Message-ID: <20260912065714.935722569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5c7d3a8f8038c..70c5df566d9de 100644
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
index 96e74fcf417c0..d5d1704cb57ca 100644
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
index 5ad23a6547adb..20944d506da77 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1371,6 +1371,7 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		udata, struct erdma_ucontext, ibucontext);
 	struct erdma_cmdq_destroy_qp_req req;
 	union erdma_mod_qp_params params;
+	unsigned long flags;
 	int err;
 
 	down_write(&qp->state_lock);
@@ -1398,6 +1399,10 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 				       "failed to destroy QP %u: %d\n",
 				       QP_ID(qp), err);
 
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	__xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
 
@@ -1411,7 +1416,6 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (qp->cep)
 		erdma_cep_put(qp->cep);
-	xa_erase(&dev->qp_xa, QP_ID(qp));
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 894e080435fbf..c73cecf92f611 100644
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



