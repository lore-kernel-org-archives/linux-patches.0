Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0A41CFEDB;
	Wed,  2 Oct 2024 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876351; cv=none; b=A7rhv4z01fCCgZQo4S9qg7PLfo+cWxq+joS7pzscGVcRVlQyIauveleQYmcOGGusRL7mPaMz6Y/hUYMWvIkInLLLUvI7T1b4tquyh+qlPNfeZh72Gja08h5Fd1IbE86pdOpmV9aU83z6ddmncwJLZlEIlZJ6Uy4hS/1QgMA01wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876351; c=relaxed/simple;
	bh=WXS8en5/IqIsCGd6v/i+lVjD9KQ0eB00n66qaTmxv2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qbj3gFp83FlpLCQ3a2DkMVV6v6xOuiarCZ13JWWDXdlONV9rwlCka1kXxfLd9Pz8FfvX1Uo9sOXEesEQk2iw5EkyABm7Tr+xLuGaa38W4bnnmIIMbrTBd/p/p5ltVWX45VMAzhb8fv3dIuanAIVjxwKGCXWeA2dnR+sYQ1MW05I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0cBOP/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0cBOP/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38B1C4CECD;
	Wed,  2 Oct 2024 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876351;
	bh=WXS8en5/IqIsCGd6v/i+lVjD9KQ0eB00n66qaTmxv2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0cBOP/nGteqWqb18/F1ubXieyRzD/E8k6ZM2mAGY1RSXfgYobMu345ffDdho+8io
	 Fu6AjcDX99LcUGRbbeXri2BN/oAKreNO2JLeBPXqWZnrBo/dzMY+MXNZBSBNVB2OQy
	 gkOW1uyZSI3Z7vlAbnXcjaXiwB9nCLfKzGwJhIFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 414/695] RDMA/hns: Fix VF triggering PF reset in abnormal interrupt handler
Date: Wed,  2 Oct 2024 14:56:52 +0200
Message-ID: <20241002125838.975942950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
index 2225c9cc63661..5483d04b3ab7e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6198,6 +6198,7 @@ static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
 	struct pci_dev *pdev = hr_dev->pci_dev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	const struct hnae3_ae_ops *ops = ae_dev->ops;
+	enum hnae3_reset_type reset_type;
 	irqreturn_t int_work = IRQ_NONE;
 	u32 int_en;
 
@@ -6209,10 +6210,12 @@ static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
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



