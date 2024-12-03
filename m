Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931011F75B4;
	Tue,  3 Dec 2024 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241347; cv=none; b=pccN5bCzueZZ7PdgzrAi1NoV8XcEuFb79aRY9eBAvxrPPnovhpfSPFY0sYJkDeAS2vlcEreyV90IIbzwCi6MOL8MN8XvvUk9GUtz07xoAZ90IXspAmZjU6/Srf4tngeBNi9Gp7Xq51LMM7H0SCpM7ybLY0/iPGaZmzgSKsWNDAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241347; c=relaxed/simple;
	bh=RETAVY18ISCfk3lLwdpn9FZ0CAEU2AcoLRznDfFJpo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtnIsjb1yqpu29hgTq/cxrG06RlmajsFDXrxLIFQ+OfC5FToRlHatmUvpW5XEajRSvW2nFtX/vGNAGbVERCqbRSKDvjyg0+cCMoZiDGv09oRrkJS+2UDLXytRPv85EG0oeAsTDS8JM56eGkFQ+ouT/ayd5H44ETkM0ogyc+Az7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1xSp1TW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1xSp1TW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EB7C4CECF;
	Tue,  3 Dec 2024 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241347;
	bh=RETAVY18ISCfk3lLwdpn9FZ0CAEU2AcoLRznDfFJpo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1xSp1TWv8EHE8s0HnoXBEh0LUfLssYdKVrR+BZKhy1JYYaATdWeZFF04YnFXCf/f
	 2XLzCN3ZsEGSX/aV8VaAKybCqR9ExXW5/7sv8Fst9b3D2s+NMM7ueY9c8Q+0Qw4oRl
	 HD7fp11GSV+IVq6x57/kUYwsDjKRqYOv5nco7GkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 394/826] RDMA/hns: Fix cpu stuck caused by printings during reset
Date: Tue,  3 Dec 2024 15:42:01 +0100
Message-ID: <20241203144759.132603622@linuxfoundation.org>
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

[ Upstream commit 323275ac2ff15b2b7b3eac391ae5d8c5a3c3a999 ]

During reset, cmd to destroy resources such as qp, cq, and mr may fail,
and error logs will be printed. When a large number of resources are
destroyed, there will be lots of printings, and it may lead to a cpu
stuck.

Delete some unnecessary printings and replace other printing functions
in these paths with the ratelimited version.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Fixes: c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241024124000.2931869-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c    |  4 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c   |  4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 73 ++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_mr.c    |  4 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c   |  4 +-
 5 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 4ec66611a1434..4106423a1b399 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -179,8 +179,8 @@ static void free_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	ret = hns_roce_destroy_hw_ctx(hr_dev, HNS_ROCE_CMD_DESTROY_CQC,
 				      hr_cq->cqn);
 	if (ret)
-		dev_err(dev, "DESTROY_CQ failed (%d) for CQN %06lx\n", ret,
-			hr_cq->cqn);
+		dev_err_ratelimited(dev, "DESTROY_CQ failed (%d) for CQN %06lx\n",
+				    ret, hr_cq->cqn);
 
 	xa_erase_irq(&cq_table->array, hr_cq->cqn);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index ee5d2c1bb5ca0..f84521be3bea4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -672,8 +672,8 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 
 	ret = hr_dev->hw->clear_hem(hr_dev, table, obj, HEM_HOP_STEP_DIRECT);
 	if (ret)
-		dev_warn(dev, "failed to clear HEM base address, ret = %d.\n",
-			 ret);
+		dev_warn_ratelimited(dev, "failed to clear HEM base address, ret = %d.\n",
+				     ret);
 
 	hns_roce_free_hem(hr_dev, table->hem[i]);
 	table->hem[i] = NULL;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4c3bc1f6a183c..d1c075fb0ad89 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -373,19 +373,12 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 static int check_send_valid(struct hns_roce_dev *hr_dev,
 			    struct hns_roce_qp *hr_qp)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
-
 	if (unlikely(hr_qp->state == IB_QPS_RESET ||
 		     hr_qp->state == IB_QPS_INIT ||
-		     hr_qp->state == IB_QPS_RTR)) {
-		ibdev_err(ibdev, "failed to post WQE, QP state %u!\n",
-			  hr_qp->state);
+		     hr_qp->state == IB_QPS_RTR))
 		return -EINVAL;
-	} else if (unlikely(hr_dev->state >= HNS_ROCE_DEVICE_STATE_RST_DOWN)) {
-		ibdev_err(ibdev, "failed to post WQE, dev state %d!\n",
-			  hr_dev->state);
+	else if (unlikely(hr_dev->state >= HNS_ROCE_DEVICE_STATE_RST_DOWN))
 		return -EIO;
-	}
 
 	return 0;
 }
@@ -2775,8 +2768,8 @@ static int free_mr_modify_rsv_qp(struct hns_roce_dev *hr_dev,
 	ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, attr, mask, IB_QPS_INIT,
 				    IB_QPS_INIT, NULL);
 	if (ret) {
-		ibdev_err(ibdev, "failed to modify qp to init, ret = %d.\n",
-			  ret);
+		ibdev_err_ratelimited(ibdev, "failed to modify qp to init, ret = %d.\n",
+				      ret);
 		return ret;
 	}
 
@@ -3421,8 +3414,8 @@ static int free_mr_post_send_lp_wqe(struct hns_roce_qp *hr_qp)
 
 	ret = hns_roce_v2_post_send(&hr_qp->ibqp, send_wr, &bad_wr);
 	if (ret) {
-		ibdev_err(ibdev, "failed to post wqe for free mr, ret = %d.\n",
-			  ret);
+		ibdev_err_ratelimited(ibdev, "failed to post wqe for free mr, ret = %d.\n",
+				      ret);
 		return ret;
 	}
 
@@ -3461,9 +3454,9 @@ static void free_mr_send_cmd_to_hw(struct hns_roce_dev *hr_dev)
 
 		ret = free_mr_post_send_lp_wqe(hr_qp);
 		if (ret) {
-			ibdev_err(ibdev,
-				  "failed to send wqe (qp:0x%lx) for free mr, ret = %d.\n",
-				  hr_qp->qpn, ret);
+			ibdev_err_ratelimited(ibdev,
+					      "failed to send wqe (qp:0x%lx) for free mr, ret = %d.\n",
+					      hr_qp->qpn, ret);
 			break;
 		}
 
@@ -3474,16 +3467,16 @@ static void free_mr_send_cmd_to_hw(struct hns_roce_dev *hr_dev)
 	while (cqe_cnt) {
 		npolled = hns_roce_v2_poll_cq(&free_mr->rsv_cq->ib_cq, cqe_cnt, wc);
 		if (npolled < 0) {
-			ibdev_err(ibdev,
-				  "failed to poll cqe for free mr, remain %d cqe.\n",
-				  cqe_cnt);
+			ibdev_err_ratelimited(ibdev,
+					      "failed to poll cqe for free mr, remain %d cqe.\n",
+					      cqe_cnt);
 			goto out;
 		}
 
 		if (time_after(jiffies, end)) {
-			ibdev_err(ibdev,
-				  "failed to poll cqe for free mr and timeout, remain %d cqe.\n",
-				  cqe_cnt);
+			ibdev_err_ratelimited(ibdev,
+					      "failed to poll cqe for free mr and timeout, remain %d cqe.\n",
+					      cqe_cnt);
 			goto out;
 		}
 		cqe_cnt -= npolled;
@@ -5061,10 +5054,8 @@ static int hns_roce_v2_set_abs_fields(struct ib_qp *ibqp,
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	int ret = 0;
 
-	if (!check_qp_state(cur_state, new_state)) {
-		ibdev_err(&hr_dev->ib_dev, "Illegal state for QP!\n");
+	if (!check_qp_state(cur_state, new_state))
 		return -EINVAL;
-	}
 
 	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		memset(qpc_mask, 0, hr_dev->caps.qpc_sz);
@@ -5325,7 +5316,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	/* SW pass context to HW */
 	ret = hns_roce_v2_qp_modify(hr_dev, context, qpc_mask, hr_qp);
 	if (ret) {
-		ibdev_err(ibdev, "failed to modify QP, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ibdev, "failed to modify QP, ret = %d.\n", ret);
 		goto out;
 	}
 
@@ -5463,7 +5454,9 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	ret = hns_roce_v2_query_qpc(hr_dev, hr_qp->qpn, &context);
 	if (ret) {
-		ibdev_err(ibdev, "failed to query QPC, ret = %d.\n", ret);
+		ibdev_err_ratelimited(ibdev,
+				      "failed to query QPC, ret = %d.\n",
+				      ret);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5471,7 +5464,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	state = hr_reg_read(&context, QPC_QP_ST);
 	tmp_qp_state = to_ib_qp_st((enum hns_roce_v2_qp_state)state);
 	if (tmp_qp_state == -1) {
-		ibdev_err(ibdev, "Illegal ib_qp_state\n");
+		ibdev_err_ratelimited(ibdev, "Illegal ib_qp_state\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5564,9 +5557,9 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 		ret = hns_roce_v2_modify_qp(&hr_qp->ibqp, NULL, 0,
 					    hr_qp->state, IB_QPS_RESET, udata);
 		if (ret)
-			ibdev_err(ibdev,
-				  "failed to modify QP to RST, ret = %d.\n",
-				  ret);
+			ibdev_err_ratelimited(ibdev,
+					      "failed to modify QP to RST, ret = %d.\n",
+					      ret);
 	}
 
 	send_cq = hr_qp->ibqp.send_cq ? to_hr_cq(hr_qp->ibqp.send_cq) : NULL;
@@ -5609,9 +5602,9 @@ int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	ret = hns_roce_v2_destroy_qp_common(hr_dev, hr_qp, udata);
 	if (ret)
-		ibdev_err(&hr_dev->ib_dev,
-			  "failed to destroy QP, QPN = 0x%06lx, ret = %d.\n",
-			  hr_qp->qpn, ret);
+		ibdev_err_ratelimited(&hr_dev->ib_dev,
+				      "failed to destroy QP, QPN = 0x%06lx, ret = %d.\n",
+				      hr_qp->qpn, ret);
 
 	hns_roce_qp_destroy(hr_dev, hr_qp, udata);
 
@@ -5905,9 +5898,9 @@ static int hns_roce_v2_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 				HNS_ROCE_CMD_MODIFY_CQC, hr_cq->cqn);
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 	if (ret)
-		ibdev_err(&hr_dev->ib_dev,
-			  "failed to process cmd when modifying CQ, ret = %d.\n",
-			  ret);
+		ibdev_err_ratelimited(&hr_dev->ib_dev,
+				      "failed to process cmd when modifying CQ, ret = %d.\n",
+				      ret);
 
 err_out:
 	if (ret)
@@ -5931,9 +5924,9 @@ static int hns_roce_v2_query_cqc(struct hns_roce_dev *hr_dev, u32 cqn,
 	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma,
 				HNS_ROCE_CMD_QUERY_CQC, cqn);
 	if (ret) {
-		ibdev_err(&hr_dev->ib_dev,
-			  "failed to process cmd when querying CQ, ret = %d.\n",
-			  ret);
+		ibdev_err_ratelimited(&hr_dev->ib_dev,
+				      "failed to process cmd when querying CQ, ret = %d.\n",
+				      ret);
 		goto err_mailbox;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 846da8c78b8b7..b3f4327d0e64a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -138,8 +138,8 @@ static void hns_roce_mr_free(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr
 					      key_to_hw_index(mr->key) &
 					      (hr_dev->caps.num_mtpts - 1));
 		if (ret)
-			ibdev_warn(ibdev, "failed to destroy mpt, ret = %d.\n",
-				   ret);
+			ibdev_warn_ratelimited(ibdev, "failed to destroy mpt, ret = %d.\n",
+					       ret);
 	}
 
 	free_mr_pbl(hr_dev, mr);
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index c9b8233f4b057..70c06ef65603d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -151,8 +151,8 @@ static void free_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 	ret = hns_roce_destroy_hw_ctx(hr_dev, HNS_ROCE_CMD_DESTROY_SRQ,
 				      srq->srqn);
 	if (ret)
-		dev_err(hr_dev->dev, "DESTROY_SRQ failed (%d) for SRQN %06lx\n",
-			ret, srq->srqn);
+		dev_err_ratelimited(hr_dev->dev, "DESTROY_SRQ failed (%d) for SRQN %06lx\n",
+				    ret, srq->srqn);
 
 	xa_erase_irq(&srq_table->xa, srq->srqn);
 
-- 
2.43.0



