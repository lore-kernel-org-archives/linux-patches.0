Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803661F6698;
	Tue,  3 Dec 2024 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238929; cv=none; b=bk3jpg73Ep5+AMGBgCDh0nRJqcmREjxaPqUYSwogVWwYyXH3hl1eeS+cknCveD9Bu2F/NNDhWo0Ym+K0q5P/8V6Q5nfGPW374bX12QIQNDU+SZBjSI1VXbGi+pHUNIqEx9T0C10HDlsfrIz9KATCKD3K116397gpuQV/qV+EwH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238929; c=relaxed/simple;
	bh=vf3Fttim0+XAl8nySZbcpTB6cLhw93+Suzhis0ul9bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4orY52ISKUk+QKZ0JAPp2hQ2z36djfNgVMlvrDa3nq5RTd35YkGuAcHSIj8XOzTZqZgjHA/13C5P1NeyTTZtyZzup6f5VmeauDl3DWvS6dezBj51KRS21MxCdyguGWAkSPD/l4N5H7rt9ghgxNmthm98/p4LG++8+vO9c2Ud4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dww6czcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dww6czcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941B2C4CECF;
	Tue,  3 Dec 2024 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238929;
	bh=vf3Fttim0+XAl8nySZbcpTB6cLhw93+Suzhis0ul9bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dww6czczV3Mt/yuipspq4LBrmyoDQ84XDq+1hyP1NCWnHu9D7GmBLsRqVtUQCqQHq
	 Tg9JW4f0FY375cMuj+yXAfXOI13uKq1im+kU4FAMkNoNPuIxTTShgAafsZLi9W3BjF
	 boJ2KR7gEveq0eW2dRjM6S/gXgt+dn8O+SB33MQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 414/817] RDMA/hns: Fix flush cqe error when racing with destroy qp
Date: Tue,  3 Dec 2024 15:39:46 +0100
Message-ID: <20241203144012.040144973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit 377a2097705b915325a67e4d44f9f2844e567809 ]

QP needs to be modified to IB_QPS_ERROR to trigger HW flush cqe. But
when this process races with destroy qp, the destroy-qp process may
modify the QP to IB_QPS_RESET first. In this case flush cqe will fail
since it is invalid to modify qp from IB_QPS_RESET to IB_QPS_ERROR.

Add lock and bit flag to make sure pending flush cqe work is completed
first and no more new works will be added.

Fixes: ffd541d45726 ("RDMA/hns: Add the workqueue framework for flush cqe handler")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241024124000.2931869-3-huangjunxian6@hisilicon.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  7 +++++++
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 15 +++++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 73c78005901e6..9b51d5a1533f5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -593,6 +593,7 @@ struct hns_roce_dev;
 
 enum {
 	HNS_ROCE_FLUSH_FLAG = 0,
+	HNS_ROCE_STOP_FLUSH_FLAG = 1,
 };
 
 struct hns_roce_work {
@@ -656,6 +657,7 @@ struct hns_roce_qp {
 	enum hns_roce_cong_type	cong_type;
 	u8			tc_mode;
 	u8			priority;
+	spinlock_t flush_lock;
 };
 
 struct hns_roce_ib_iboe {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index bbdeb02102e87..4c3bc1f6a183c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5598,8 +5598,15 @@ int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
+	unsigned long flags;
 	int ret;
 
+	/* Make sure flush_cqe() is completed */
+	spin_lock_irqsave(&hr_qp->flush_lock, flags);
+	set_bit(HNS_ROCE_STOP_FLUSH_FLAG, &hr_qp->flush_flag);
+	spin_unlock_irqrestore(&hr_qp->flush_lock, flags);
+	flush_work(&hr_qp->flush_work.work);
+
 	ret = hns_roce_v2_destroy_qp_common(hr_dev, hr_qp, udata);
 	if (ret)
 		ibdev_err(&hr_dev->ib_dev,
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index dcaa370d4a265..2ad03ecdbf8ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -90,11 +90,18 @@ static void flush_work_handle(struct work_struct *work)
 void init_flush_work(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 {
 	struct hns_roce_work *flush_work = &hr_qp->flush_work;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hr_qp->flush_lock, flags);
+	/* Exit directly after destroy_qp() */
+	if (test_bit(HNS_ROCE_STOP_FLUSH_FLAG, &hr_qp->flush_flag)) {
+		spin_unlock_irqrestore(&hr_qp->flush_lock, flags);
+		return;
+	}
 
-	flush_work->hr_dev = hr_dev;
-	INIT_WORK(&flush_work->work, flush_work_handle);
 	refcount_inc(&hr_qp->refcount);
 	queue_work(hr_dev->irq_workq, &flush_work->work);
+	spin_unlock_irqrestore(&hr_qp->flush_lock, flags);
 }
 
 void flush_cqe(struct hns_roce_dev *dev, struct hns_roce_qp *qp)
@@ -1140,6 +1147,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 				     struct ib_udata *udata,
 				     struct hns_roce_qp *hr_qp)
 {
+	struct hns_roce_work *flush_work = &hr_qp->flush_work;
 	struct hns_roce_ib_create_qp_resp resp = {};
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_ib_create_qp ucmd = {};
@@ -1148,9 +1156,12 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 	mutex_init(&hr_qp->mutex);
 	spin_lock_init(&hr_qp->sq.lock);
 	spin_lock_init(&hr_qp->rq.lock);
+	spin_lock_init(&hr_qp->flush_lock);
 
 	hr_qp->state = IB_QPS_RESET;
 	hr_qp->flush_flag = 0;
+	flush_work->hr_dev = hr_dev;
+	INIT_WORK(&flush_work->work, flush_work_handle);
 
 	if (init_attr->create_flags)
 		return -EOPNOTSUPP;
-- 
2.43.0



