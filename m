Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE51AB6C9;
	Tue,  3 Dec 2024 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241330; cv=none; b=IEfjr6R1Y+ZWDDW9dg7J1sxY+2SIiSKILvuGP3Kf9E51U22eiYoJrqwc1by4hMc2sin0BMFbmy3clfQKakw0xvn6FFu1M4b66d2BpNiASGnTCSz98P0f+vlBAuCb9C/zQKmXr0EI/WckWsKtziIUZYKQGTayyena0plNu71mG2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241330; c=relaxed/simple;
	bh=uhyQmmp2dT8mM/9R8sJWo63AnAo0ZW8CndGrEGFV0eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMrCt8py+yhCrkz+ZJDHb6W7aP/wFx83/sRTbD6uqlmAWG0PvAfv9cOgSsHGE5ZUWo0gBZoFhESmhHeI3IFGf/2ID/XTYHsPNXPQgb+DjRVPE5bHVPTkIc+rD8xf24eHY3uUBsjioGB3xeXX3xaE0QWuZkjuKx+I3/IpXcacvmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS5E1iHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS5E1iHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A038C4CECF;
	Tue,  3 Dec 2024 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241330;
	bh=uhyQmmp2dT8mM/9R8sJWo63AnAo0ZW8CndGrEGFV0eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yS5E1iHAUZ1Iyilfck6XzGTGdRSl+KOEH6nkuB495p9otuJAKuVXVIgoPD/L/d3Me
	 bwsmsKcAaI2Q75AVpzrGYyJhc2wfpqMl9XVSz2r2YQPPx7lQvyEocBEBtvn+MUc1eO
	 v2Q5yTSRxtwDyqW6riekCATAZ3uM1JPlyfv0ivpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/826] RDMA/hns: Fix an AEQE overflow error caused by untimely update of eq_db_ci
Date: Tue,  3 Dec 2024 15:41:57 +0100
Message-ID: <20241203144758.974396578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0b1e21cb6d2d3..73c78005901e6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -1289,6 +1289,7 @@ void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn);
 void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type);
 void flush_cqe(struct hns_roce_dev *dev, struct hns_roce_qp *qp);
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type);
+void hns_roce_flush_cqe(struct hns_roce_dev *hr_dev, u32 qpn);
 void hns_roce_srq_event(struct hns_roce_dev *hr_dev, u32 srqn, int event_type);
 void hns_roce_handle_device_err(struct hns_roce_dev *hr_dev);
 int hns_roce_init(struct hns_roce_dev *hr_dev);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index f1feaa79f78ee..bbdeb02102e87 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5967,11 +5967,10 @@ static int hns_roce_v2_query_mpt(struct hns_roce_dev *hr_dev, u32 key,
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
@@ -6015,6 +6014,8 @@ static void hns_roce_irq_work_handle(struct work_struct *work)
 	case HNS_ROCE_EVENT_TYPE_DB_OVERFLOW:
 		ibdev_warn(ibdev, "DB overflow.\n");
 		break;
+	case HNS_ROCE_EVENT_TYPE_MB:
+		break;
 	case HNS_ROCE_EVENT_TYPE_FLR:
 		ibdev_warn(ibdev, "function level reset.\n");
 		break;
@@ -6025,8 +6026,46 @@ static void hns_roce_irq_work_handle(struct work_struct *work)
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
@@ -6087,14 +6126,14 @@ static struct hns_roce_aeqe *next_aeqe_sw_v2(struct hns_roce_eq *eq)
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
@@ -6105,25 +6144,12 @@ static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
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
@@ -6131,12 +6157,7 @@ static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
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
 
@@ -6150,6 +6171,7 @@ static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 		hns_roce_v2_init_irq_work(hr_dev, eq, queue_num);
 
 		aeqe = next_aeqe_sw_v2(eq);
+		++num_aeqes;
 	}
 
 	update_eq_db(eq);
@@ -6699,6 +6721,9 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 	int ret;
 	int i;
 
+	if (hr_dev->caps.aeqe_depth < HNS_AEQ_POLLING_BUDGET)
+		return -EINVAL;
+
 	other_num = hr_dev->caps.num_other_vectors;
 	comp_num = hr_dev->caps.num_comp_vectors;
 	aeq_num = hr_dev->caps.num_aeq_vectors;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index c65f68a14a260..3b3c6259ace0e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -85,6 +85,11 @@
 
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
index 6b03ba671ff8f..dcaa370d4a265 100644
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



