Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9CC1898F2;
	Tue, 30 Jul 2024 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359288; cv=none; b=Ntd5I6qsinsD8lwdDGHLd7QYpKjLB7thT8DMpXwg4bhVQKM5Lf2BPE2Z6uXogLbSdicKMBEudXS3h9ems6jJMCXno1os/Vf7Y/P8wyl4KqWQpxfqU5INXgCUIwlJtcoziTyiJP9YI3EkhU5WtUoUGS71Y3Rge3tYFNq+YnxuZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359288; c=relaxed/simple;
	bh=Rl+OIyM2Qi2HooBmpIeAfbaft/u9TA7vhivfn6pR6Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFPj3TqJCjfjR86fRF7F8qzAz9Xu9SGI2F4dDo5l5Ceq9FY6GafMjhDHBwK1JmQ7mwP4AUnuQaVLEFn7nPJwxKOb2NpydHpUyfHP1Tml9Bb37SrA4M+I/GKkqtu8udqgHe4aLui6XLLgJZGy2Da+WE6DjY1e+OBpvP2Z2VJ0/yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgwljqPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgwljqPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC290C4AF0A;
	Tue, 30 Jul 2024 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359288;
	bh=Rl+OIyM2Qi2HooBmpIeAfbaft/u9TA7vhivfn6pR6Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgwljqPwH3b83ct6v3K0JpsTIscIrLnTqhGPR0qteOotbB968gvGFBOB+la4l3lzD
	 HqoWh6W6QDVybysgZIswB0BV9IBTlh9s3NGx0EkkgScvmhyZImIxXiU+4F41pfpPuT
	 Z7o+aSlVhcmu4H9z2T/nexTz/tAacYfJw1tcLOM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 462/809] RDMA/hns: Fix unmatch exception handling when init eq table fails
Date: Tue, 30 Jul 2024 17:45:38 +0200
Message-ID: <20240730151742.976453023@linuxfoundation.org>
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

[ Upstream commit 543fb987bd63ed27409b5dea3d3eec27b9c1eac9 ]

The hw ctx should be destroyed when init eq table fails.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 25 +++++++++++-----------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2f16554c96bef..cbbc142afc1be 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6368,9 +6368,16 @@ static void hns_roce_v2_int_mask_enable(struct hns_roce_dev *hr_dev,
 	roce_write(hr_dev, ROCEE_VF_ABN_INT_CFG_REG, enable_flag);
 }
 
-static void hns_roce_v2_destroy_eqc(struct hns_roce_dev *hr_dev, u32 eqn)
+static void free_eq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
+{
+	hns_roce_mtr_destroy(hr_dev, &eq->mtr);
+}
+
+static void hns_roce_v2_destroy_eqc(struct hns_roce_dev *hr_dev,
+				    struct hns_roce_eq *eq)
 {
 	struct device *dev = hr_dev->dev;
+	int eqn = eq->eqn;
 	int ret;
 	u8 cmd;
 
@@ -6381,12 +6388,9 @@ static void hns_roce_v2_destroy_eqc(struct hns_roce_dev *hr_dev, u32 eqn)
 
 	ret = hns_roce_destroy_hw_ctx(hr_dev, cmd, eqn & HNS_ROCE_V2_EQN_M);
 	if (ret)
-		dev_err(dev, "[mailbox cmd] destroy eqc(%u) failed.\n", eqn);
-}
+		dev_err(dev, "[mailbox cmd] destroy eqc(%d) failed.\n", eqn);
 
-static void free_eq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
-{
-	hns_roce_mtr_destroy(hr_dev, &eq->mtr);
+	free_eq_buf(hr_dev, eq);
 }
 
 static void init_eq_config(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
@@ -6733,7 +6737,7 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 
 err_create_eq_fail:
 	for (i -= 1; i >= 0; i--)
-		free_eq_buf(hr_dev, &eq_table->eq[i]);
+		hns_roce_v2_destroy_eqc(hr_dev, &eq_table->eq[i]);
 	kfree(eq_table->eq);
 
 	return ret;
@@ -6753,11 +6757,8 @@ static void hns_roce_v2_cleanup_eq_table(struct hns_roce_dev *hr_dev)
 	__hns_roce_free_irq(hr_dev);
 	destroy_workqueue(hr_dev->irq_workq);
 
-	for (i = 0; i < eq_num; i++) {
-		hns_roce_v2_destroy_eqc(hr_dev, i);
-
-		free_eq_buf(hr_dev, &eq_table->eq[i]);
-	}
+	for (i = 0; i < eq_num; i++)
+		hns_roce_v2_destroy_eqc(hr_dev, &eq_table->eq[i]);
 
 	kfree(eq_table->eq);
 }
-- 
2.43.0



