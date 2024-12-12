Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB15D21E085;
	Thu, 12 Dec 2024 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019651; cv=none; b=RWO7YxyKnqERCiTmG3UnAToTvMjC/ZX31ntktgkY4IDhMKlEH/fGbpIKHu8NGp4y6vbk2sAWm08yN73tNlR7apgo7hbUEZqwL9g/py3lS6o5QwF9XRYj/JQGQL/Kc9Hf08qeci7rgdFypaIgz7Xbw0DPADG15PSihq/0cig1mAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019651; c=relaxed/simple;
	bh=PpCGGUX+ODlPF8wD7sx6fytTgN6U1U4kBB0dfJDC4Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKeyhc/Ia9i09xBULDwCWCDQfhxOAnlbKS7S0Dj0gGhUyiWLn2SD+70RKMehFHzGpc/YnSwHk4Evn0MjSF/9R5UOJzG2yLfZN1ykf4wlgtf7AEh+SK4tJTj3RuqmseyV8bRGxCtQ6lPt5ICHH/+zp3S86uUBd4su2/ycaKo3/Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3SLh/pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3SLh/pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4762CC4CECE;
	Thu, 12 Dec 2024 16:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019651;
	bh=PpCGGUX+ODlPF8wD7sx6fytTgN6U1U4kBB0dfJDC4Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3SLh/pU6OYuhUA1puMXxAvwbmbpE5fLgpQPu9SX2bMsLM0lgjJaLFzCgUrpwVBMo
	 uUmKjXe5qNhUatiaaAJsDWBQYUFnAfPMwXUhQQJStd9XDgA2U9MAnkTZCibkQwOo3S
	 fUOgnraTVVQI3ELpvFs9dulIpSN7dV7TBjd6gUvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/772] RDMA/hns: Fix an AEQE overflow error caused by untimely update of eq_db_ci
Date: Thu, 12 Dec 2024 15:52:48 +0100
Message-ID: <20241212144359.123091307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit 571e4ab8a45e530623ab129803f090a844dd3fe9 ]

eq_db_ci is updated only after all AEQEs are processed in the AEQ
interrupt handler, which is not timely enough and may result in
AEQ overflow. Two optimization methods are proposed:
1. Set an upper limit for AEQE processing.
2. Move time-consuming operations such as printings to the bottom
half of the interrupt.

cmd events and flush_cqe events are still fully processed in the top half
to ensure timely handling.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241024124000.2931869-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 75 ++++++++++++++-------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  5 ++
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 54 +++++++++------
 4 files changed, 91 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index a2bdfa026c560..5b8b68b2d69cf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -1228,6 +1228,7 @@ void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn);
 void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type);
 void flush_cqe(struct hns_roce_dev *dev, struct hns_roce_qp *qp);
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type);
+void hns_roce_flush_cqe(struct hns_roce_dev *hr_dev, u32 qpn);
 void hns_roce_srq_event(struct hns_roce_dev *hr_dev, u32 srqn, int event_type);
 u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u32 port, int gid_index);
 void hns_roce_handle_device_err(struct hns_roce_dev *hr_dev);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 56c0e87c494ec..8b371d6ecbac9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5977,11 +5977,10 @@ static int hns_roce_v2_query_mpt(struct hns_roce_dev *hr_dev, u32 key,
 	return ret;
 }
 
-static void hns_roce_irq_work_handle(struct work_struct *work)
+static void dump_aeqe_log(struct hns_roce_work *irq_work)
 {
-	struct hns_roce_work *irq_work =
-				container_of(work, struct hns_roce_work, work);
-	struct ib_device *ibdev = &irq_work->hr_dev->ib_dev;
+	struct hns_roce_dev *hr_dev = irq_work->hr_dev;
+	struct ib_device *ibdev = &hr_dev->ib_dev;
 
 	switch (irq_work->event_type) {
 	case HNS_ROCE_EVENT_TYPE_PATH_MIG:
@@ -6025,6 +6024,8 @@ static void hns_roce_irq_work_handle(struct work_struct *work)
 	case HNS_ROCE_EVENT_TYPE_DB_OVERFLOW:
 		ibdev_warn(ibdev, "DB overflow.\n");
 		break;
+	case HNS_ROCE_EVENT_TYPE_MB:
+		break;
 	case HNS_ROCE_EVENT_TYPE_FLR:
 		ibdev_warn(ibdev, "function level reset.\n");
 		break;
@@ -6035,8 +6036,46 @@ static void hns_roce_irq_work_handle(struct work_struct *work)
 		ibdev_err(ibdev, "invalid xrceth error.\n");
 		break;
 	default:
+		ibdev_info(ibdev, "Undefined event %d.\n",
+			   irq_work->event_type);
 		break;
 	}
+}
+
+static void hns_roce_irq_work_handle(struct work_struct *work)
+{
+	struct hns_roce_work *irq_work =
+				container_of(work, struct hns_roce_work, work);
+	struct hns_roce_dev *hr_dev = irq_work->hr_dev;
+	int event_type = irq_work->event_type;
+	u32 queue_num = irq_work->queue_num;
+
+	switch (event_type) {
+	case HNS_ROCE_EVENT_TYPE_PATH_MIG:
+	case HNS_ROCE_EVENT_TYPE_PATH_MIG_FAILED:
+	case HNS_ROCE_EVENT_TYPE_COMM_EST:
+	case HNS_ROCE_EVENT_TYPE_SQ_DRAINED:
+	case HNS_ROCE_EVENT_TYPE_WQ_CATAS_ERROR:
+	case HNS_ROCE_EVENT_TYPE_SRQ_LAST_WQE_REACH:
+	case HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR:
+	case HNS_ROCE_EVENT_TYPE_LOCAL_WQ_ACCESS_ERROR:
+	case HNS_ROCE_EVENT_TYPE_XRCD_VIOLATION:
+	case HNS_ROCE_EVENT_TYPE_INVALID_XRCETH:
+		hns_roce_qp_event(hr_dev, queue_num, event_type);
+		break;
+	case HNS_ROCE_EVENT_TYPE_SRQ_LIMIT_REACH:
+	case HNS_ROCE_EVENT_TYPE_SRQ_CATAS_ERROR:
+		hns_roce_srq_event(hr_dev, queue_num, event_type);
+		break;
+	case HNS_ROCE_EVENT_TYPE_CQ_ACCESS_ERROR:
+	case HNS_ROCE_EVENT_TYPE_CQ_OVERFLOW:
+		hns_roce_cq_event(hr_dev, queue_num, event_type);
+		break;
+	default:
+		break;
+	}
+
+	dump_aeqe_log(irq_work);
 
 	kfree(irq_work);
 }
@@ -6097,14 +6136,14 @@ static struct hns_roce_aeqe *next_aeqe_sw_v2(struct hns_roce_eq *eq)
 static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 				       struct hns_roce_eq *eq)
 {
-	struct device *dev = hr_dev->dev;
 	struct hns_roce_aeqe *aeqe = next_aeqe_sw_v2(eq);
 	irqreturn_t aeqe_found = IRQ_NONE;
+	int num_aeqes = 0;
 	int event_type;
 	u32 queue_num;
 	int sub_type;
 
-	while (aeqe) {
+	while (aeqe && num_aeqes < HNS_AEQ_POLLING_BUDGET) {
 		/* Make sure we read AEQ entry after we have checked the
 		 * ownership bit
 		 */
@@ -6115,25 +6154,12 @@ static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 		queue_num = hr_reg_read(aeqe, AEQE_EVENT_QUEUE_NUM);
 
 		switch (event_type) {
-		case HNS_ROCE_EVENT_TYPE_PATH_MIG:
-		case HNS_ROCE_EVENT_TYPE_PATH_MIG_FAILED:
-		case HNS_ROCE_EVENT_TYPE_COMM_EST:
-		case HNS_ROCE_EVENT_TYPE_SQ_DRAINED:
 		case HNS_ROCE_EVENT_TYPE_WQ_CATAS_ERROR:
-		case HNS_ROCE_EVENT_TYPE_SRQ_LAST_WQE_REACH:
 		case HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR:
 		case HNS_ROCE_EVENT_TYPE_LOCAL_WQ_ACCESS_ERROR:
 		case HNS_ROCE_EVENT_TYPE_XRCD_VIOLATION:
 		case HNS_ROCE_EVENT_TYPE_INVALID_XRCETH:
-			hns_roce_qp_event(hr_dev, queue_num, event_type);
-			break;
-		case HNS_ROCE_EVENT_TYPE_SRQ_LIMIT_REACH:
-		case HNS_ROCE_EVENT_TYPE_SRQ_CATAS_ERROR:
-			hns_roce_srq_event(hr_dev, queue_num, event_type);
-			break;
-		case HNS_ROCE_EVENT_TYPE_CQ_ACCESS_ERROR:
-		case HNS_ROCE_EVENT_TYPE_CQ_OVERFLOW:
-			hns_roce_cq_event(hr_dev, queue_num, event_type);
+			hns_roce_flush_cqe(hr_dev, queue_num);
 			break;
 		case HNS_ROCE_EVENT_TYPE_MB:
 			hns_roce_cmd_event(hr_dev,
@@ -6141,12 +6167,7 @@ static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 					aeqe->event.cmd.status,
 					le64_to_cpu(aeqe->event.cmd.out_param));
 			break;
-		case HNS_ROCE_EVENT_TYPE_DB_OVERFLOW:
-		case HNS_ROCE_EVENT_TYPE_FLR:
-			break;
 		default:
-			dev_err(dev, "unhandled event %d on EQ %d at idx %u.\n",
-				event_type, eq->eqn, eq->cons_index);
 			break;
 		}
 
@@ -6158,6 +6179,7 @@ static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 		hns_roce_v2_init_irq_work(hr_dev, eq, queue_num);
 
 		aeqe = next_aeqe_sw_v2(eq);
+		++num_aeqes;
 	}
 
 	update_eq_db(eq);
@@ -6687,6 +6709,9 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 	int ret;
 	int i;
 
+	if (hr_dev->caps.aeqe_depth < HNS_AEQ_POLLING_BUDGET)
+		return -EINVAL;
+
 	other_num = hr_dev->caps.num_other_vectors;
 	comp_num = hr_dev->caps.num_comp_vectors;
 	aeq_num = hr_dev->caps.num_aeq_vectors;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 2b4dbbb06eb56..e24ddbcafe0fc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -114,6 +114,11 @@
 
 #define HNS_ROCE_V2_TABLE_CHUNK_SIZE		(1 << 18)
 
+/* budget must be smaller than aeqe_depth to guarantee that we update
+ * the ci before we polled all the entries in the EQ.
+ */
+#define HNS_AEQ_POLLING_BUDGET 64
+
 enum {
 	HNS_ROCE_CMD_FLAG_IN = BIT(0),
 	HNS_ROCE_CMD_FLAG_OUT = BIT(1),
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index e158ed9e6c83c..7af6631761044 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -39,6 +39,25 @@
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
 
+static struct hns_roce_qp *hns_roce_qp_lookup(struct hns_roce_dev *hr_dev,
+					      u32 qpn)
+{
+	struct device *dev = hr_dev->dev;
+	struct hns_roce_qp *qp;
+	unsigned long flags;
+
+	xa_lock_irqsave(&hr_dev->qp_table_xa, flags);
+	qp = __hns_roce_qp_lookup(hr_dev, qpn);
+	if (qp)
+		refcount_inc(&qp->refcount);
+	xa_unlock_irqrestore(&hr_dev->qp_table_xa, flags);
+
+	if (!qp)
+		dev_warn(dev, "async event for bogus QP %08x\n", qpn);
+
+	return qp;
+}
+
 static void flush_work_handle(struct work_struct *work)
 {
 	struct hns_roce_work *flush_work = container_of(work,
@@ -95,31 +114,28 @@ void flush_cqe(struct hns_roce_dev *dev, struct hns_roce_qp *qp)
 
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type)
 {
-	struct device *dev = hr_dev->dev;
 	struct hns_roce_qp *qp;
 
-	xa_lock(&hr_dev->qp_table_xa);
-	qp = __hns_roce_qp_lookup(hr_dev, qpn);
-	if (qp)
-		refcount_inc(&qp->refcount);
-	xa_unlock(&hr_dev->qp_table_xa);
-
-	if (!qp) {
-		dev_warn(dev, "async event for bogus QP %08x\n", qpn);
+	qp = hns_roce_qp_lookup(hr_dev, qpn);
+	if (!qp)
 		return;
-	}
 
-	if (event_type == HNS_ROCE_EVENT_TYPE_WQ_CATAS_ERROR ||
-	    event_type == HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR ||
-	    event_type == HNS_ROCE_EVENT_TYPE_LOCAL_WQ_ACCESS_ERROR ||
-	    event_type == HNS_ROCE_EVENT_TYPE_XRCD_VIOLATION ||
-	    event_type == HNS_ROCE_EVENT_TYPE_INVALID_XRCETH) {
-		qp->state = IB_QPS_ERR;
+	qp->event(qp, (enum hns_roce_event)event_type);
 
-		flush_cqe(hr_dev, qp);
-	}
+	if (refcount_dec_and_test(&qp->refcount))
+		complete(&qp->free);
+}
 
-	qp->event(qp, (enum hns_roce_event)event_type);
+void hns_roce_flush_cqe(struct hns_roce_dev *hr_dev, u32 qpn)
+{
+	struct hns_roce_qp *qp;
+
+	qp = hns_roce_qp_lookup(hr_dev, qpn);
+	if (!qp)
+		return;
+
+	qp->state = IB_QPS_ERR;
+	flush_cqe(hr_dev, qp);
 
 	if (refcount_dec_and_test(&qp->refcount))
 		complete(&qp->free);
-- 
2.43.0



