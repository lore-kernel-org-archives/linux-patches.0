Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2319B3FF;
	Tue, 15 Oct 2024 11:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993005; cv=none; b=WBx72B4KnzB5xUgHkJ5fotfE2An1LaQ6rNUNlB0iNSbyV1+4BlJCrpoeDKzD7ZVtA9gTgIzVyi85G04K7ScH/nN5X+DfeH24nfIQhxjgBQzXiu0CVYn1g36IM50OChn1EWpOSaMLG218ierYSoTRU7CqY8l2isl+935gfzvGY8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993005; c=relaxed/simple;
	bh=JsvmRveATQ6A+V8HRSCzsOk3S0UlWGRQR5ArglUCbMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6K8O8eFTZk8SYcGGA8XmvPO9MQd6XIk/+utrerbQWPsj1IEcMSsCzj/WN+PEYmnlBa7dXY1Snp1xOsCW+cw/psahy1HcLJuMvL2gp0rpzgQwATGygZxnYktvbFJUYC/K7kfZR9yOYWbzWwNsNpEldu0q8HgsISNUSrK1lE2hyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSNm4l1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSNm4l1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F7EC4CEC6;
	Tue, 15 Oct 2024 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993005;
	bh=JsvmRveATQ6A+V8HRSCzsOk3S0UlWGRQR5ArglUCbMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSNm4l1mlxM5HoJvfwrhSdkJUAOUYTxVHh2SuuX/Xh9vbLtuNP27TdZQBvz8JAGOZ
	 4DoQsKfjiupt/hgqczcBz4j6FqaCKcDk52EsOrPkXvdhxvoLWtlh5+qiy0jU5xUT98
	 oZR6BBraQ54rg157kTh+dqBtuq6bDAnHAioXGkHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Wenpeng Liang <liangwenpeng@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/691] RDMA/hns: Fix the wrong type of return value of the interrupt handler
Date: Tue, 15 Oct 2024 13:23:19 +0200
Message-ID: <20241015112450.314434533@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyue Xu <xuhaoyue1@hisilicon.com>

[ Upstream commit d95e0a0c6c9602ff6bb90c1c20987b204493d8e1 ]

The type of return value of the interrupt handler should be irqreturn_t.

Link: https://lore.kernel.org/r/20220714134353.16700-3-liangwenpeng@huawei.com
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 4321feefa550 ("RDMA/hns: Fix VF triggering PF reset in abnormal interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 27 +++++++++++-----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 71ba2960e4b0f..4c98341602067 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5674,12 +5674,12 @@ static struct hns_roce_aeqe *next_aeqe_sw_v2(struct hns_roce_eq *eq)
 		!!(eq->cons_index & eq->entries)) ? aeqe : NULL;
 }
 
-static int hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
-			       struct hns_roce_eq *eq)
+static irqreturn_t hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
+				       struct hns_roce_eq *eq)
 {
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_aeqe *aeqe = next_aeqe_sw_v2(eq);
-	int aeqe_found = 0;
+	irqreturn_t aeqe_found = IRQ_NONE;
 	int event_type;
 	u32 queue_num;
 	int sub_type;
@@ -5739,7 +5739,7 @@ static int hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 		eq->event_type = event_type;
 		eq->sub_type = sub_type;
 		++eq->cons_index;
-		aeqe_found = 1;
+		aeqe_found = IRQ_HANDLED;
 
 		hns_roce_v2_init_irq_work(hr_dev, eq, queue_num);
 
@@ -5747,7 +5747,8 @@ static int hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 	}
 
 	update_eq_db(eq);
-	return aeqe_found;
+
+	return IRQ_RETVAL(aeqe_found);
 }
 
 static struct hns_roce_ceqe *next_ceqe_sw_v2(struct hns_roce_eq *eq)
@@ -5762,11 +5763,11 @@ static struct hns_roce_ceqe *next_ceqe_sw_v2(struct hns_roce_eq *eq)
 		(!!(eq->cons_index & eq->entries)) ? ceqe : NULL;
 }
 
-static int hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
-			       struct hns_roce_eq *eq)
+static irqreturn_t hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
+				       struct hns_roce_eq *eq)
 {
 	struct hns_roce_ceqe *ceqe = next_ceqe_sw_v2(eq);
-	int ceqe_found = 0;
+	irqreturn_t ceqe_found = IRQ_NONE;
 	u32 cqn;
 
 	while (ceqe) {
@@ -5781,21 +5782,21 @@ static int hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
 		hns_roce_cq_completion(hr_dev, cqn);
 
 		++eq->cons_index;
-		ceqe_found = 1;
+		ceqe_found = IRQ_HANDLED;
 
 		ceqe = next_ceqe_sw_v2(eq);
 	}
 
 	update_eq_db(eq);
 
-	return ceqe_found;
+	return IRQ_RETVAL(ceqe_found);
 }
 
 static irqreturn_t hns_roce_v2_msix_interrupt_eq(int irq, void *eq_ptr)
 {
 	struct hns_roce_eq *eq = eq_ptr;
 	struct hns_roce_dev *hr_dev = eq->hr_dev;
-	int int_work;
+	irqreturn_t int_work;
 
 	if (eq->type_flag == HNS_ROCE_CEQ)
 		/* Completion event interrupt */
@@ -5811,7 +5812,7 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 {
 	struct hns_roce_dev *hr_dev = dev_id;
 	struct device *dev = hr_dev->dev;
-	int int_work = 0;
+	irqreturn_t int_work = IRQ_NONE;
 	u32 int_st;
 	u32 int_en;
 
@@ -5839,7 +5840,7 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 		int_en |= 1 << HNS_ROCE_V2_VF_ABN_INT_EN_S;
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG, int_en);
 
-		int_work = 1;
+		int_work = IRQ_HANDLED;
 	} else {
 		dev_err(dev, "There is no abnormal irq found!\n");
 	}
-- 
2.43.0



