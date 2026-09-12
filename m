Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669E9431E51;
	Sat, 12 Sep 2026 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209809; cv=none; b=Fv+ngvvS1QtW9wMWMs7bY4jQw5XsuYk2MsxTaxMmp4ApBETgSlwjNjbk63ODvU6NcsG21hs3Dj0OJfUt7g9S8NfArAU9SxGCclAxntMBBvlpHYocSFVbl85VdPwWHAVU69V7CCfwwSqsMKtXkY4acSPu7Bb/cC9EaXV2BQlGSoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209809; c=relaxed/simple;
	bh=tE7ZgT3y5+pIFyCUtS363g5338TgyIXO+FyvgCaBvPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU4X7vL1W09lACVFyhPp09IFTEQqOmfWk/M/pwF8IO7piIJqYMUSnQVGsSoEC2CXhncOlEGzIDs/IIhdQoEwztyh6l7BG+AIQoos5lUdzidlsB2hHxrOL/GhS87zzqNdeYiune/pvnX+mdoUwSg29dE/UjDXk1hNDCkWyRHdAvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2sa8QPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2sa8QPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AD21F000FF;
	Sat, 12 Sep 2026 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209804;
	bh=/tHi/BjzbihTbhJoFSt60YuGY3B9aGgrse7ODhbSRyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2sa8QPBX5ITD3PglR7cFCuGHU1sahXMpFNbpiW3V0zr2QO7zJsr68AcG0hK1H6Rl
	 nG2iPIG2EdVmj/nyeEtPej0RDbosmxmQuO5Q47Mg7XNQKodVeQvXHI1B+jX4KDF1P5
	 boU0pvB4vaOmysCssWLRtpt8QCYGgEH4K/D3xszg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0896/1518] RDMA/erdma: Hold QP references for AE and CM processing
Date: Sat, 12 Sep 2026 08:51:05 +0200
Message-ID: <20260912065643.723315939@linuxfoundation.org>
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
index e70a95897581a..fdd67756f3bc3 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1370,6 +1370,7 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		udata, struct erdma_ucontext, ibucontext);
 	struct erdma_cmdq_destroy_qp_req req;
 	union erdma_mod_qp_params params;
+	unsigned long flags;
 	int err;
 
 	down_write(&qp->state_lock);
@@ -1397,6 +1398,10 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 				       "failed to destroy QP %u: %d\n",
 				       QP_ID(qp), err);
 
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	__xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
 
@@ -1410,7 +1415,6 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
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



