Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DF71AC8AE;
	Mon, 14 Oct 2024 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918126; cv=none; b=EvogxLUEq4yYNSmXIsoRNCVvwIO9YhLRVBokTvkGfGzZ3QA/PTFwjnPHZHN6kAG9NlT3StyMF3tDDm5dZGb1Syp2vB/mq9PljfrYCzH9R6mjDc7pnDQYInV6OkrJyyNym5j97P7dU0kLSeJWdSiPNueAlXMipe8GBZiZCKOsKgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918126; c=relaxed/simple;
	bh=i0DZuXUPVGknmVaU4NaRQsHr62slr8Q4pHm0w95nBrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm0935J1Nl56PJR7axRewmydIFNQse4l43Ww1/mOl4DLkhsEGwpmJY5dgKQs41w+GxwgCAWgrL9Ozmi7f2IVF3uFJCAnPVOQ0HaPwpWWF2AdCcID9MSZhzYOjqN+2bmtHmw7+JP5IZIcbTlHKEH1dUm9ScBIq+q0JNYfAZ59kzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpSYqEMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpSYqEMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D009C4CEC3;
	Mon, 14 Oct 2024 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918125;
	bh=i0DZuXUPVGknmVaU4NaRQsHr62slr8Q4pHm0w95nBrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpSYqEMw7b3r7cngpa1WMK+ml5WA88kavnUUjy/vbY2dgR7zO7J+7n5NzWhzboSFE
	 zCMQLqLrtWbiGD/HgNex8pWXi0t4AIG8noFpJGxTyojeICa1e/KQ0R3VVRMJ4XRL+2
	 NE0Sq/jjGbR8aVHqWmJPAx7Xwmsm7baUTeRcbbwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/798] RDMA/hns: Fix VF triggering PF reset in abnormal interrupt handler
Date: Mon, 14 Oct 2024 16:12:57 +0200
Message-ID: <20241014141226.687918704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7ca85dcb5458c..42636aa28b4bb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6227,6 +6227,7 @@ static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
 	struct pci_dev *pdev = hr_dev->pci_dev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	const struct hnae3_ae_ops *ops = ae_dev->ops;
+	enum hnae3_reset_type reset_type;
 	irqreturn_t int_work = IRQ_NONE;
 	u32 int_en;
 
@@ -6238,10 +6239,12 @@ static irqreturn_t abnormal_interrupt_basic(struct hns_roce_dev *hr_dev,
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



