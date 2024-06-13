Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CD11420C6;
	Thu, 13 Jun 2024 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281622; cv=none; b=aVPwukG1dXGzXl7pigV5EOB1cHwm5nuOxqAMNE4EdGAhVgHhQwXCeZOQeSj+TqAYnl2F2KB485D57v3PVlJ5+a5AfIYXn4k8CFQDEcKFPq7Ncch8+SPbDSf4d5vg23HrGTs2qa0buJzDujhZrEs0w2e1wTL2/mDLC/qceSJREK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281622; c=relaxed/simple;
	bh=jbPBdkPwVttwEXmtELnvsxONNLRvSPmImpooOE+EQFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ast1UYY8gkhUKdIBOo2CoBW17dajsxYrhUFn1rMFeNPNo5Y/Tss+5F2pDZEQmSHK4jpT3RZW1toviumTcKy4F/nq0uQPX45KkW49Zp4KaY7OB8zPlVpVtifMpdAAAqj2MsTlWydYGqMN6snkMJd3+5Q61LX55vcCz1awOD/2AO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUgY+pz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUgY+pz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEE3C2BBFC;
	Thu, 13 Jun 2024 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281621;
	bh=jbPBdkPwVttwEXmtELnvsxONNLRvSPmImpooOE+EQFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUgY+pz8ULPIBB2vr2OcJ/j8o8iqo8/YmvCDoNJ/rzUNloU9lL5tMTmOkxzUrWe16
	 MbYUvT4lwm0KIGo8yznH1P8oGLYig7G+hhdg6VmwrCP4LF2aSutkaEI62SjBtD6U/z
	 hWZkp5nqPdSU64AUyGNDVnK0BWC/skVjWNokMf4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.10 317/317] RDMA/hns: Fix CQ and QP cache affinity
Date: Thu, 13 Jun 2024 13:35:35 +0200
Message-ID: <20240613113259.815606243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

commit 9e03dbea2b0634b21a45946b4f8097e0dc86ebe1 upstream.

Currently, the affinity between QP cache and CQ cache is not
considered when assigning QPN, it will affect the message rate of HW.

Allocate QPN from QP cache with better CQ affinity to get better
performance.

Fixes: 71586dd20010 ("RDMA/hns: Create QP with selected QPN for bank load balance")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20230804012711.808069-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |    2 ++
 drivers/infiniband/hw/hns/hns_roce_qp.c     |   28 ++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -122,6 +122,8 @@
  */
 #define EQ_DEPTH_COEFF				2
 
+#define CQ_BANKID_MASK GENMASK(1, 0)
+
 enum {
 	SERV_TYPE_RC,
 	SERV_TYPE_UC,
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -154,14 +154,29 @@ static void hns_roce_ib_qp_event(struct
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
@@ -193,7 +208,8 @@ static int alloc_qpn_with_bankid(struct
 
 	return 0;
 }
-static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
+static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
+		     struct ib_qp_init_attr *init_attr)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 	unsigned long num = 0;
@@ -211,7 +227,7 @@ static int alloc_qpn(struct hns_roce_dev
 		hr_qp->doorbell_qpn = 1;
 	} else {
 		mutex_lock(&qp_table->bank_mutex);
-		bankid = get_least_load_bankid_for_qp(qp_table->bank);
+		bankid = get_least_load_bankid_for_qp(init_attr, qp_table->bank);
 
 		ret = alloc_qpn_with_bankid(&qp_table->bank[bankid], bankid,
 					    &num);
@@ -1005,7 +1021,7 @@ static int hns_roce_create_qp_common(str
 		goto err_db;
 	}
 
-	ret = alloc_qpn(hr_dev, hr_qp);
+	ret = alloc_qpn(hr_dev, hr_qp, init_attr);
 	if (ret) {
 		ibdev_err(ibdev, "failed to alloc QPN, ret = %d.\n", ret);
 		goto err_buf;


