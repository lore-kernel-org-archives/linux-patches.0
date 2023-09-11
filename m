Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7B011706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E58C433C7;
	Mon, 11 Sep 2023 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443906;
	bh=p8I4CPRSceJFUChAR2hDmeD4RAsVXyBTRHi6gqz1IBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3evARZJE8MNERh59AKel3SBiXzKSAmNhN/ctkoic74BU8l4ThhehLH9cyOaGJojP
	 kM97I+bEkIhuPnR7oJQWzEzpgAWIzeyidcdHJ1Y4q3IbRQdVzzAYY4c9x2koAB6VQn
	 4bVgVBzPWAwMZXQDyxOpRcSiaqogXFZvfzo8C0lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 542/737] RDMA/hns: Fix CQ and QP cache affinity
Date: Mon, 11 Sep 2023 15:46:41 +0200
Message-ID: <20230911134705.703727999@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 9e03dbea2b0634b21a45946b4f8097e0dc86ebe1 ]

Currently, the affinity between QP cache and CQ cache is not
considered when assigning QPN, it will affect the message rate of HW.

Allocate QPN from QP cache with better CQ affinity to get better
performance.

Fixes: 71586dd20010 ("RDMA/hns: Create QP with selected QPN for bank load balance")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20230804012711.808069-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 28 ++++++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 84239b907de2a..bb94eb076858c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -97,6 +97,7 @@
 #define HNS_ROCE_CQ_BANK_NUM 4
 
 #define CQ_BANKID_SHIFT 2
+#define CQ_BANKID_MASK GENMASK(1, 0)
 
 enum {
 	SERV_TYPE_RC,
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index d855a917f4cfa..cdc1c6de43a17 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -170,14 +170,29 @@ static void hns_roce_ib_qp_event(struct hns_roce_qp *hr_qp,
 	}
 }
 
-static u8 get_least_load_bankid_for_qp(struct hns_roce_bank *bank)
+static u8 get_affinity_cq_bank(u8 qp_bank)
 {
-	u32 least_load = bank[0].inuse;
+	return (qp_bank >> 1) & CQ_BANKID_MASK;
+}
+
+static u8 get_least_load_bankid_for_qp(struct ib_qp_init_attr *init_attr,
+					struct hns_roce_bank *bank)
+{
+#define INVALID_LOAD_QPNUM 0xFFFFFFFF
+	struct ib_cq *scq = init_attr->send_cq;
+	u32 least_load = INVALID_LOAD_QPNUM;
+	unsigned long cqn = 0;
 	u8 bankid = 0;
 	u32 bankcnt;
 	u8 i;
 
-	for (i = 1; i < HNS_ROCE_QP_BANK_NUM; i++) {
+	if (scq)
+		cqn = to_hr_cq(scq)->cqn;
+
+	for (i = 0; i < HNS_ROCE_QP_BANK_NUM; i++) {
+		if (scq && (get_affinity_cq_bank(i) != (cqn & CQ_BANKID_MASK)))
+			continue;
+
 		bankcnt = bank[i].inuse;
 		if (bankcnt < least_load) {
 			least_load = bankcnt;
@@ -209,7 +224,8 @@ static int alloc_qpn_with_bankid(struct hns_roce_bank *bank, u8 bankid,
 
 	return 0;
 }
-static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
+static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
+		     struct ib_qp_init_attr *init_attr)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 	unsigned long num = 0;
@@ -220,7 +236,7 @@ static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 		num = 1;
 	} else {
 		mutex_lock(&qp_table->bank_mutex);
-		bankid = get_least_load_bankid_for_qp(qp_table->bank);
+		bankid = get_least_load_bankid_for_qp(init_attr, qp_table->bank);
 
 		ret = alloc_qpn_with_bankid(&qp_table->bank[bankid], bankid,
 					    &num);
@@ -1082,7 +1098,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 		goto err_buf;
 	}
 
-	ret = alloc_qpn(hr_dev, hr_qp);
+	ret = alloc_qpn(hr_dev, hr_qp, init_attr);
 	if (ret) {
 		ibdev_err(ibdev, "failed to alloc QPN, ret = %d.\n", ret);
 		goto err_qpn;
-- 
2.40.1



