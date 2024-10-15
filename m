Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64019B3FF;
	Tue, 15 Oct 2024 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993011; cv=none; b=RO6HEZclVI366EnTPREy5U52+50EKubx3+X+ke0j9Cxm5QWLordbJ9g7D+F0TBbGIw+JL+kfZTrO06DzGIjo2VyyfQqAuvCVczz/57EDzIEBBHioa2WNT0ptcxH+xtGIJ8xjfCZA86JBX8iEC6OuhlEslMYNhEBloh3pEJcCSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993011; c=relaxed/simple;
	bh=yqILZbu8SQ5bKZfy4zs/V10GgFXSK1L0UXZanXDSSo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQuYVxDJk36zoHZGwDGRAA12qRIsNWm6rMU54heFP3fK8bZptq9uxLUxMtkeB2OwSjr+lObhknmwQ/pEAsUqk10ZrgnfxlF6z1k3PFqGWr5NULOl+u3776p5c6OMBI+8f6kzF0PkH9lRXKzWUOcYtmHBKZhQul3HehgherOzePs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOVJ9n+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOVJ9n+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40830C4CEC6;
	Tue, 15 Oct 2024 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993011;
	bh=yqILZbu8SQ5bKZfy4zs/V10GgFXSK1L0UXZanXDSSo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOVJ9n+fAkXpHYCgiDhtQfFzZbybgx/eQj8pFbh33/yTT3VbW31k56VQSpCU46PAJ
	 qDdiNbF5JfYosFOKIzJ3b5Z9lzWXN+RV85JPu7rjM6AJ2Bw9vTwR/Nf7SDRm0P0ZHa
	 ySGnHkcZl9nVkUHwQUfQmhHkRTF367EqobBmQjoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/691] RDMA/hns: Fix VF triggering PF reset in abnormal interrupt handler
Date: Tue, 15 Oct 2024 13:23:21 +0200
Message-ID: <20241015112450.392591165@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 4321feefa5501a746ebf6a7d8b59e6b955ae1860 ]

In abnormal interrupt handler, a PF reset will be triggered even if
the device is a VF. It should be a VF reset.

Fixes: 2b9acb9a97fe ("RDMA/hns: Add the process of AEQ overflow for hip08")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 92cff8d014cbe..64d458fd39ba9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5814,6 +5814,7 @@ static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
 	struct pci_dev *pdev = hr_dev->pci_dev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	const struct hnae3_ae_ops *ops = ae_dev->ops;
+	enum hnae3_reset_type reset_type;
 	irqreturn_t int_work = IRQ_NONE;
 	u32 int_en;
 
@@ -5825,10 +5826,12 @@ static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG,
 			   1 << HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S);
 
+		reset_type = hr_dev->is_vf ?
+			     HNAE3_VF_FUNC_RESET : HNAE3_FUNC_RESET;
+
 		/* Set reset level for reset_event() */
 		if (ops->set_default_reset_request)
-			ops->set_default_reset_request(ae_dev,
-						       HNAE3_FUNC_RESET);
+			ops->set_default_reset_request(ae_dev, reset_type);
 		if (ops->reset_event)
 			ops->reset_event(pdev, NULL);
 
-- 
2.43.0



