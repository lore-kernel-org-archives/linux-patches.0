Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFFA145B2E;
	Thu, 13 Jun 2024 12:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281016; cv=none; b=VCkZRtWlLUeekqpKM4iYfo5nzN0yNb+dawE0dZkOmD8G+z3tQ9bMe0o6JwnAYq4ZxL9NFZn/ufHy8xe0t114MjXdY9Kj0XHZTufYNFbPBQ+uWu6/Vx23UnJgLW8zEf1ONTMIbm8D9nPG/EwjGOlbVgC2oDlClVlVrSL6hRzlRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281016; c=relaxed/simple;
	bh=H9la8uehHM1jqyNY8s721nFaXKjBL9BQ/T37XlcXSh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpEteNR1bMUQbGu4LhckYV/Rn0h6pjSnXos9llSRPyR5nMauo7mm2RfiVW+zSKswLQm3du+/Fc25HBIAjvaJEj1j8YQgdZUGvLKrGSuzpKtDtQ4H4E8+BGstoNLERPA2qV5czezZAVw8jn7M6Vu9EhPUutUFiX/NKwQIjcAEAHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTMnZ9vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTMnZ9vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E98C4AF1A;
	Thu, 13 Jun 2024 12:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281015;
	bh=H9la8uehHM1jqyNY8s721nFaXKjBL9BQ/T37XlcXSh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTMnZ9vPhj/iLFzZJbvhFpjE9kS92DTOpN+zXWeRRXs35ilJFe1pfB0xF8XTdZqfn
	 kMandrB6K1YEe5SSuO4ngO2UFVR9AaC9FiSpwjPM5kB/dOZMKf9JHbtTRRNeeQG/Nb
	 Qzst/lsK7AElFDgVDZj//GFGDO3pWI+Q0Fxiy89I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangyang Li <liyangyang20@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/317] RDMA/hns: Create QP with selected QPN for bank load balance
Date: Thu, 13 Jun 2024 13:32:10 +0200
Message-ID: <20240613113251.882958783@linuxfoundation.org>
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

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit 71586dd2001087e89e344e2c7dcee6b4a53bb6de ]

In order to improve performance by balancing the load between different
banks of cache, the QPC cache is desigend to choose one of 8 banks
according to lower 3 bits of QPN. The hns driver needs to count the number
of QP on each bank and then assigns the QP being created to the bank with
the minimum load first.

Link: https://lore.kernel.org/r/1606220649-1465-1-git-send-email-liweihang@huawei.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 203b70fda634 ("RDMA/hns: Fix return value in hns_roce_map_mr_sg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  15 ++-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 100 ++++++++++++++++----
 2 files changed, 96 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index e1f5b92596824..5f16173566614 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -115,6 +115,8 @@
 #define HNS_ROCE_IDX_QUE_ENTRY_SZ		4
 #define SRQ_DB_REG				0x230
 
+#define HNS_ROCE_QP_BANK_NUM 8
+
 /* The chip implementation of the consumer index is calculated
  * according to twice the actual EQ depth
  */
@@ -520,13 +522,22 @@ struct hns_roce_uar_table {
 	struct hns_roce_bitmap bitmap;
 };
 
+struct hns_roce_bank {
+	struct ida ida;
+	u32 inuse; /* Number of IDs allocated */
+	u32 min; /* Lowest ID to allocate.  */
+	u32 max; /* Highest ID to allocate. */
+	u32 next; /* Next ID to allocate. */
+};
+
 struct hns_roce_qp_table {
-	struct hns_roce_bitmap		bitmap;
 	struct hns_roce_hem_table	qp_table;
 	struct hns_roce_hem_table	irrl_table;
 	struct hns_roce_hem_table	trrl_table;
 	struct hns_roce_hem_table	sccc_table;
 	struct mutex			scc_mutex;
+	struct hns_roce_bank bank[HNS_ROCE_QP_BANK_NUM];
+	spinlock_t bank_lock;
 };
 
 struct hns_roce_cq_table {
@@ -776,7 +787,7 @@ struct hns_roce_caps {
 	u32		max_rq_sg;
 	u32		max_extend_sg;
 	int		num_qps;
-	int             reserved_qps;
+	u32             reserved_qps;
 	int		num_qpc_timer;
 	int		num_cqc_timer;
 	int		num_srqs;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index d1c07f1f8fe98..8323de2c4bf9a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -154,9 +154,50 @@ static void hns_roce_ib_qp_event(struct hns_roce_qp *hr_qp,
 	}
 }
 
+static u8 get_least_load_bankid_for_qp(struct hns_roce_bank *bank)
+{
+	u32 least_load = bank[0].inuse;
+	u8 bankid = 0;
+	u32 bankcnt;
+	u8 i;
+
+	for (i = 1; i < HNS_ROCE_QP_BANK_NUM; i++) {
+		bankcnt = bank[i].inuse;
+		if (bankcnt < least_load) {
+			least_load = bankcnt;
+			bankid = i;
+		}
+	}
+
+	return bankid;
+}
+
+static int alloc_qpn_with_bankid(struct hns_roce_bank *bank, u8 bankid,
+				 unsigned long *qpn)
+{
+	int id;
+
+	id = ida_alloc_range(&bank->ida, bank->next, bank->max, GFP_KERNEL);
+	if (id < 0) {
+		id = ida_alloc_range(&bank->ida, bank->min, bank->max,
+				     GFP_KERNEL);
+		if (id < 0)
+			return id;
+	}
+
+	/* the QPN should keep increasing until the max value is reached. */
+	bank->next = (id + 1) > bank->max ? bank->min : id + 1;
+
+	/* the lower 3 bits is bankid */
+	*qpn = (id << 3) | bankid;
+
+	return 0;
+}
 static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 {
+	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 	unsigned long num = 0;
+	u8 bankid;
 	int ret;
 
 	if (hr_qp->ibqp.qp_type == IB_QPT_GSI) {
@@ -169,13 +210,21 @@ static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 
 		hr_qp->doorbell_qpn = 1;
 	} else {
-		ret = hns_roce_bitmap_alloc_range(&hr_dev->qp_table.bitmap,
-						  1, 1, &num);
+		spin_lock(&qp_table->bank_lock);
+		bankid = get_least_load_bankid_for_qp(qp_table->bank);
+
+		ret = alloc_qpn_with_bankid(&qp_table->bank[bankid], bankid,
+					    &num);
 		if (ret) {
-			ibdev_err(&hr_dev->ib_dev, "Failed to alloc bitmap\n");
-			return -ENOMEM;
+			ibdev_err(&hr_dev->ib_dev,
+				  "failed to alloc QPN, ret = %d\n", ret);
+			spin_unlock(&qp_table->bank_lock);
+			return ret;
 		}
 
+		qp_table->bank[bankid].inuse++;
+		spin_unlock(&qp_table->bank_lock);
+
 		hr_qp->doorbell_qpn = (u32)num;
 	}
 
@@ -340,9 +389,15 @@ static void free_qpc(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 	hns_roce_table_put(hr_dev, &qp_table->irrl_table, hr_qp->qpn);
 }
 
+static inline u8 get_qp_bankid(unsigned long qpn)
+{
+	/* The lower 3 bits of QPN are used to hash to different banks */
+	return (u8)(qpn & GENMASK(2, 0));
+}
+
 static void free_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 {
-	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
+	u8 bankid;
 
 	if (hr_qp->ibqp.qp_type == IB_QPT_GSI)
 		return;
@@ -350,7 +405,13 @@ static void free_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 	if (hr_qp->qpn < hr_dev->caps.reserved_qps)
 		return;
 
-	hns_roce_bitmap_free_range(&qp_table->bitmap, hr_qp->qpn, 1, BITMAP_RR);
+	bankid = get_qp_bankid(hr_qp->qpn);
+
+	ida_free(&hr_dev->qp_table.bank[bankid].ida, hr_qp->qpn >> 3);
+
+	spin_lock(&hr_dev->qp_table.bank_lock);
+	hr_dev->qp_table.bank[bankid].inuse--;
+	spin_unlock(&hr_dev->qp_table.bank_lock);
 }
 
 static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
@@ -1293,22 +1354,24 @@ bool hns_roce_wq_overflow(struct hns_roce_wq *hr_wq, int nreq,
 int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
-	int reserved_from_top = 0;
-	int reserved_from_bot;
-	int ret;
+	unsigned int reserved_from_bot;
+	unsigned int i;
 
 	mutex_init(&qp_table->scc_mutex);
 	xa_init(&hr_dev->qp_table_xa);
 
 	reserved_from_bot = hr_dev->caps.reserved_qps;
 
-	ret = hns_roce_bitmap_init(&qp_table->bitmap, hr_dev->caps.num_qps,
-				   hr_dev->caps.num_qps - 1, reserved_from_bot,
-				   reserved_from_top);
-	if (ret) {
-		dev_err(hr_dev->dev, "qp bitmap init failed!error=%d\n",
-			ret);
-		return ret;
+	for (i = 0; i < reserved_from_bot; i++) {
+		hr_dev->qp_table.bank[get_qp_bankid(i)].inuse++;
+		hr_dev->qp_table.bank[get_qp_bankid(i)].min++;
+	}
+
+	for (i = 0; i < HNS_ROCE_QP_BANK_NUM; i++) {
+		ida_init(&hr_dev->qp_table.bank[i].ida);
+		hr_dev->qp_table.bank[i].max = hr_dev->caps.num_qps /
+					       HNS_ROCE_QP_BANK_NUM - 1;
+		hr_dev->qp_table.bank[i].next = hr_dev->qp_table.bank[i].min;
 	}
 
 	return 0;
@@ -1316,5 +1379,8 @@ int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 
 void hns_roce_cleanup_qp_table(struct hns_roce_dev *hr_dev)
 {
-	hns_roce_bitmap_cleanup(&hr_dev->qp_table.bitmap);
+	int i;
+
+	for (i = 0; i < HNS_ROCE_QP_BANK_NUM; i++)
+		ida_destroy(&hr_dev->qp_table.bank[i].ida);
 }
-- 
2.43.0



