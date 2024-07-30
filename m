Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6EE1898F2;
	Tue, 30 Jul 2024 17:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359281; cv=none; b=bmlueWYrkkJSKXtDtCrTmKKzvFf6SONzXi3f/HPp8/0xc4knZMcGDHSTCdx+2dRr8uTeMFay3XnaFNo618zdAXMavOgZewYN4zy8MIgH3CYZQLNzAxB5PUmoO+U3qXt+VgTaaWD/lJU56umt7OdtD+oSRNo5U5rcxmVMiSz/qVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359281; c=relaxed/simple;
	bh=DvrzVFyRa3IP4MHO+yZq15/4c0FwO+ohIxAG5EGU7Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMMyNh8tiZ/DDEduCnx3XshZjduoRmN+zOI5PsmW6DNi3F9JXCn/Ze+wMlPhsd/jsIP4KLI60eytE94FDEEyj7MnZqgDvMzja3BGUqsWEtip40mbXi1yXvKzgFb+HeQG8YYOYJPe6Jr6F0+W2VO/5bsSrNwCUncJjgpRYmHznNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIaTtXP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIaTtXP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9226C32782;
	Tue, 30 Jul 2024 17:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359281;
	bh=DvrzVFyRa3IP4MHO+yZq15/4c0FwO+ohIxAG5EGU7Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIaTtXP5X5kHQt91xRwyrZ11h0PGtzbbP7sVKEIsnz6Ia6HO+CJL8zl9si1N9AbtT
	 1H1g0FE+21WTxYM3fTNxGGQdR4TotMtxxx4R4dzCKr254cpBsFBmYwIqliCsxDx2LZ
	 5ZOCCp5oIb4XHPl61x8MpuuxxevfBCaeCiKGTHFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 461/809] RDMA/hns: Fix soft lockup under heavy CEQE load
Date: Tue, 30 Jul 2024 17:45:37 +0200
Message-ID: <20240730151742.935248858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 2fdf34038369c0a27811e7b4680662a14ada1d6b ]

CEQEs are handled in interrupt handler currently. This may cause the
CPU core staying in interrupt context too long and lead to soft lockup
under heavy load.

Handle CEQEs in BH workqueue and set an upper limit for the number of
CEQE handled by a single call of work handler.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 89 ++++++++++++---------
 2 files changed, 54 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 05005079258cf..f8451e5ab107e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -717,6 +717,7 @@ struct hns_roce_eq {
 	int				shift;
 	int				event_type;
 	int				sub_type;
+	struct work_struct		work;
 };
 
 struct hns_roce_eq_table {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index eb6052ee89383..2f16554c96bef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -36,6 +36,7 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 #include <net/addrconf.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
@@ -6140,33 +6141,11 @@ static struct hns_roce_ceqe *next_ceqe_sw_v2(struct hns_roce_eq *eq)
 		!!(eq->cons_index & eq->entries)) ? ceqe : NULL;
 }
 
-static irqreturn_t hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
-				       struct hns_roce_eq *eq)
+static irqreturn_t hns_roce_v2_ceq_int(struct hns_roce_eq *eq)
 {
-	struct hns_roce_ceqe *ceqe = next_ceqe_sw_v2(eq);
-	irqreturn_t ceqe_found = IRQ_NONE;
-	u32 cqn;
-
-	while (ceqe) {
-		/* Make sure we read CEQ entry after we have checked the
-		 * ownership bit
-		 */
-		dma_rmb();
-
-		cqn = hr_reg_read(ceqe, CEQE_CQN);
-
-		hns_roce_cq_completion(hr_dev, cqn);
-
-		++eq->cons_index;
-		ceqe_found = IRQ_HANDLED;
-		atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_CEQE_CNT]);
-
-		ceqe = next_ceqe_sw_v2(eq);
-	}
+	queue_work(system_bh_wq, &eq->work);
 
-	update_eq_db(eq);
-
-	return IRQ_RETVAL(ceqe_found);
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t hns_roce_v2_msix_interrupt_eq(int irq, void *eq_ptr)
@@ -6177,7 +6156,7 @@ static irqreturn_t hns_roce_v2_msix_interrupt_eq(int irq, void *eq_ptr)
 
 	if (eq->type_flag == HNS_ROCE_CEQ)
 		/* Completion event interrupt */
-		int_work = hns_roce_v2_ceq_int(hr_dev, eq);
+		int_work = hns_roce_v2_ceq_int(eq);
 	else
 		/* Asynchronous event interrupt */
 		int_work = hns_roce_v2_aeq_int(hr_dev, eq);
@@ -6545,6 +6524,34 @@ static int hns_roce_v2_create_eq(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
+static void hns_roce_ceq_work(struct work_struct *work)
+{
+	struct hns_roce_eq *eq = from_work(eq, work, work);
+	struct hns_roce_ceqe *ceqe = next_ceqe_sw_v2(eq);
+	struct hns_roce_dev *hr_dev = eq->hr_dev;
+	int ceqe_num = 0;
+	u32 cqn;
+
+	while (ceqe && ceqe_num < hr_dev->caps.ceqe_depth) {
+		/* Make sure we read CEQ entry after we have checked the
+		 * ownership bit
+		 */
+		dma_rmb();
+
+		cqn = hr_reg_read(ceqe, CEQE_CQN);
+
+		hns_roce_cq_completion(hr_dev, cqn);
+
+		++eq->cons_index;
+		++ceqe_num;
+		atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_CEQE_CNT]);
+
+		ceqe = next_ceqe_sw_v2(eq);
+	}
+
+	update_eq_db(eq);
+}
+
 static int __hns_roce_request_irq(struct hns_roce_dev *hr_dev, int irq_num,
 				  int comp_num, int aeq_num, int other_num)
 {
@@ -6576,21 +6583,24 @@ static int __hns_roce_request_irq(struct hns_roce_dev *hr_dev, int irq_num,
 			 j - other_num - aeq_num);
 
 	for (j = 0; j < irq_num; j++) {
-		if (j < other_num)
+		if (j < other_num) {
 			ret = request_irq(hr_dev->irq[j],
 					  hns_roce_v2_msix_interrupt_abn,
 					  0, hr_dev->irq_names[j], hr_dev);
-
-		else if (j < (other_num + comp_num))
+		} else if (j < (other_num + comp_num)) {
+			INIT_WORK(&eq_table->eq[j - other_num].work,
+				  hns_roce_ceq_work);
 			ret = request_irq(eq_table->eq[j - other_num].irq,
 					  hns_roce_v2_msix_interrupt_eq,
 					  0, hr_dev->irq_names[j + aeq_num],
 					  &eq_table->eq[j - other_num]);
-		else
+		} else {
 			ret = request_irq(eq_table->eq[j - other_num].irq,
 					  hns_roce_v2_msix_interrupt_eq,
 					  0, hr_dev->irq_names[j - comp_num],
 					  &eq_table->eq[j - other_num]);
+		}
+
 		if (ret) {
 			dev_err(hr_dev->dev, "request irq error!\n");
 			goto err_request_failed;
@@ -6600,12 +6610,16 @@ static int __hns_roce_request_irq(struct hns_roce_dev *hr_dev, int irq_num,
 	return 0;
 
 err_request_failed:
-	for (j -= 1; j >= 0; j--)
-		if (j < other_num)
+	for (j -= 1; j >= 0; j--) {
+		if (j < other_num) {
 			free_irq(hr_dev->irq[j], hr_dev);
-		else
-			free_irq(eq_table->eq[j - other_num].irq,
-				 &eq_table->eq[j - other_num]);
+			continue;
+		}
+		free_irq(eq_table->eq[j - other_num].irq,
+			 &eq_table->eq[j - other_num]);
+		if (j < other_num + comp_num)
+			cancel_work_sync(&eq_table->eq[j - other_num].work);
+	}
 
 err_kzalloc_failed:
 	for (i -= 1; i >= 0; i--)
@@ -6626,8 +6640,11 @@ static void __hns_roce_free_irq(struct hns_roce_dev *hr_dev)
 	for (i = 0; i < hr_dev->caps.num_other_vectors; i++)
 		free_irq(hr_dev->irq[i], hr_dev);
 
-	for (i = 0; i < eq_num; i++)
+	for (i = 0; i < eq_num; i++) {
 		free_irq(hr_dev->eq_table.eq[i].irq, &hr_dev->eq_table.eq[i]);
+		if (i < hr_dev->caps.num_comp_vectors)
+			cancel_work_sync(&hr_dev->eq_table.eq[i].work);
+	}
 
 	for (i = 0; i < irq_num; i++)
 		kfree(hr_dev->irq_names[i]);
-- 
2.43.0



