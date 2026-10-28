Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216098;
	b=drGucO/XuSC3keIioeU5EHsrGJCCTJAwWxfmaIv7nd+zmM1KsTzXRI7Ki68NLvW9JMhZ
	 /b6rtrA40yQJ3mS1eDDyZu3FpvRm/AwqM+HKICxg3hcqmL6idL5GuofV8jaRBpt+9vrn4
	 /M/HqAGBIuYAxxuf/7zt7GVa8jh59wGlTuFTiALErTnKMoXKHtdr6DQmHmdLU3UjWXDee
	 HExt3DK3jGmyPA+M8v21Em4or62iqeZmyohrilqrhTl1CrNjMbTQ/P53BzrbeLUIpw+vH
	 SUr6HDUJceUf/jpfrSEwigHAeJ7cHHHIQ2HJvC4RYblUTszSvLVMFPdN54NsGrvZ6lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zGzhWuuQXHseVwpHkFOrni3wjqxBx3dk+lX3VkFbOAE=;
	b=2eTYKEvx3iNtrz6tU8tf9LzSuMHAH389iNvG/34OmNJIJfD5eCNRATjuO2XmwdShAl0a
	 kI+XeVXH9lvkMtfYOCZD2v1OnT9vJFPVavLbTouN8Ec0ICbKYuvgQLMqAu3XsiHOOhFjl
	 VORU7v5bjURYwokL21BCzVSmTdxXzbWO6tmgUgvcojFPy8VLMcacd5bDEAAYQLRGqAbVh
	 cm7YHGdtDwM+XRycpat5zkDzWIT+fSTpItzToe04A8CZBbsGI6xMIX8Dh0HNOS9PEU1WQ
	 2hxBHTeM6JB4fb5+MY2qiNoeOp76rFR67vbb7zVm22KCrH+PrkcgxYAf6F6Sxtfp3Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOMTIe00;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CB3606A31D;
	Wed, 28 Oct 2026 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOMTIe00
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999F91F01825;
	Wed, 28 Oct 2026 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216098;
	bh=zGzhWuuQXHseVwpHkFOrni3wjqxBx3dk+lX3VkFbOAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOMTIe00/4XJF802d3nx620BIJTPmsouaDngO+tJa3k3CyaefU0uHsSMysjX1ifeV
	 VXJQH3ny0WajV4lLOfArDyLxahZYn7oxZHM0gaw5wbkeDupcMzX+lyI+KeZwKe5ZOn
	 n6H/GJwVNwuIjL2piS3pVNgaQJaXj4YKXz5o9Vg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1440/1887] RDMA/hns: Fix soft lockup under heavy CEQE load
Date: Wed, 28 Oct 2026 17:58:56 +0100
Message-ID: <20261028170532.228830209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 87 ++++++++++++---------
 2 files changed, 53 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 0607970013536..fec4084e2dfff 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -718,6 +718,7 @@ struct hns_roce_eq {
 	int				shift;
 	int				event_type;
 	int				sub_type;
+	struct work_struct		work;
 };
 
 struct hns_roce_eq_table {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1775120634745..538b3261614a1 100644
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
@@ -6217,32 +6218,11 @@ static struct hns_roce_ceqe *next_ceqe_sw_v2(struct hns_roce_eq *eq)
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
+	queue_work(system_highpri_wq, &eq->work);
 
-		ceqe = next_ceqe_sw_v2(eq);
-	}
-
-	update_eq_db(eq);
-
-	return IRQ_RETVAL(ceqe_found);
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t hns_roce_v2_msix_interrupt_eq(int irq, void *eq_ptr)
@@ -6253,7 +6233,7 @@ static irqreturn_t hns_roce_v2_msix_interrupt_eq(int irq, void *eq_ptr)
 
 	if (eq->type_flag == HNS_ROCE_CEQ)
 		/* Completion event interrupt */
-		int_work = hns_roce_v2_ceq_int(hr_dev, eq);
+		int_work = hns_roce_v2_ceq_int(eq);
 	else
 		/* Asynchronous event interrupt */
 		int_work = hns_roce_v2_aeq_int(hr_dev, eq);
@@ -6628,6 +6608,33 @@ static int hns_roce_v2_create_eq(struct hns_roce_dev *hr_dev,
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
@@ -6658,21 +6665,24 @@ static int __hns_roce_request_irq(struct hns_roce_dev *hr_dev, int irq_num,
 			 "hns-ceq-%d", j - other_num - aeq_num);
 
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
@@ -6682,12 +6692,16 @@ static int __hns_roce_request_irq(struct hns_roce_dev *hr_dev, int irq_num,
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
@@ -6708,8 +6722,11 @@ static void __hns_roce_free_irq(struct hns_roce_dev *hr_dev)
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
2.53.0



