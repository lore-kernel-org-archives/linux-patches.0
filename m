Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7214619B3FF;
	Tue, 15 Oct 2024 11:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993008; cv=none; b=akhadsqeZvb/nTQZUF1FmuqQBxjNW/n1PfVbk9MJQVhIK0OEzXCv0Au7iND7E0lTOhXzUtv/8CWXzqcd8saqOKSBjtkgrY9tdlKKrZIYgpN1NZiUTUs2QXJisD9DlL1iya1oUsRk/EHy7cRsIuMRP1bksEk7+88Hbf/sY1ZDels=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993008; c=relaxed/simple;
	bh=9VzgB7qSinzEuSylRy4gNSFlCStZogKdwekEm5OD61E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqKy+KtN6d3x06gKi6IIP9+EwgweW6WS8yBNA+NuLQz9YUkZ8XSfFkvn/uj3heDnMnJKhYvEcIF8y6DFo0uSNL1sRd/ITjTuY6oUq+VhXHQmSvH3AjcOoSagMhcP1wpa52dxJfo5g9mwPNZ5ujRZJyfjj0ahTecQdcv8cS0Hsfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNyFuz5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNyFuz5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6087C4CEC6;
	Tue, 15 Oct 2024 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993008;
	bh=9VzgB7qSinzEuSylRy4gNSFlCStZogKdwekEm5OD61E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNyFuz5TqTkMpEMczGCDSK2P9Yx9OY7gLghFDCcysq0vsUISkYol1sopun6zIgTbH
	 CU7iuHgzKSXGgtlZiuiMQzqHme1F/w3wk1Tnp2NiRyBirM7jFfntfdfCr1yU7tdbXh
	 z84rOVzDleNLgyM0QHOKMZemHU1BMXGss+gso2Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Wenpeng Liang <liangwenpeng@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/691] RDMA/hns: Refactor the abnormal interrupt handler function
Date: Tue, 15 Oct 2024 13:23:20 +0200
Message-ID: <20241015112450.353578159@linuxfoundation.org>
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

[ Upstream commit 75e4e716f7089558fda4ddc660fa8dbdec4eb1d3 ]

Use a single function to handle the same kind of abnormal interrupts.

Link: https://lore.kernel.org/r/20220714134353.16700-5-liangwenpeng@huawei.com
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 4321feefa550 ("RDMA/hns: Fix VF triggering PF reset in abnormal interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 35 ++++++++++++++--------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4c98341602067..92cff8d014cbe 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5808,24 +5808,19 @@ static irqreturn_t hns_roce_v2_msix_interrupt_eq(int irq, void *eq_ptr)
 	return IRQ_RETVAL(int_work);
 }
 
-static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
+static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
+					    u32 int_st)
 {
-	struct hns_roce_dev *hr_dev = dev_id;
-	struct device *dev = hr_dev->dev;
+	struct pci_dev *pdev = hr_dev->pci_dev;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+	const struct hnae3_ae_ops *ops = ae_dev->ops;
 	irqreturn_t int_work = IRQ_NONE;
-	u32 int_st;
 	u32 int_en;
 
-	/* Abnormal interrupt */
-	int_st = roce_read(hr_dev, ROCEE_VF_ABN_INT_ST_REG);
 	int_en = roce_read(hr_dev, ROCEE_VF_ABN_INT_EN_REG);
 
 	if (int_st & BIT(HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S)) {
-		struct pci_dev *pdev = hr_dev->pci_dev;
-		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
-		const struct hnae3_ae_ops *ops = ae_dev->ops;
-
-		dev_err(dev, "AEQ overflow!\n");
+		dev_err(hr_dev->dev, "AEQ overflow!\n");
 
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG,
 			   1 << HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S);
@@ -5842,12 +5837,28 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 
 		int_work = IRQ_HANDLED;
 	} else {
-		dev_err(dev, "There is no abnormal irq found!\n");
+		dev_err(hr_dev->dev, "there is no basic abn irq found.\n");
 	}
 
 	return IRQ_RETVAL(int_work);
 }
 
+static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
+{
+	struct hns_roce_dev *hr_dev = dev_id;
+	irqreturn_t int_work = IRQ_NONE;
+	u32 int_st;
+
+	int_st = roce_read(hr_dev, ROCEE_VF_ABN_INT_ST_REG);
+
+	if (int_st)
+		int_work = abnormal_interrupt_basic(hr_dev, int_st);
+	else
+		dev_err(hr_dev->dev, "there is no abnormal irq found.\n");
+
+	return IRQ_RETVAL(int_work);
+}
+
 static void hns_roce_v2_int_mask_enable(struct hns_roce_dev *hr_dev,
 					int eq_num, u32 enable_flag)
 {
-- 
2.43.0



