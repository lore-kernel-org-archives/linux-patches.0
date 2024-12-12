Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADFA222D75;
	Thu, 12 Dec 2024 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019531; cv=none; b=SC+W2wFFxqXxZsKq5ib8K26A7tBG2hf9NAbqc2cS33noEFb5gWqvVUW7cDdMv7QcFKXJ6rd0Oz4ZcNjW07UjvkWWz6+ZSX5IPa6g8hCvBeC7XSUYm3QBB21IAe50oaC/kX3QvXzPdlSyE73Uui12z75vm2JRFzw+muWwpAWcu1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019531; c=relaxed/simple;
	bh=Ra9rIS/DKZCYCjgOrIXLSmB7xF3yMs18vx24WtVa5os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a55BURMnCaI161Sd8zwfX2EsAKoHMGAe5WwF+3i9JM1NbTk2x2T220sCQ5sdDlU1VRjz+kR1FpT1CakYG5+y8S0nZlm2whm0wjTaEjdPo4Beb/Q9JqHfSsj2Moo7/PeiAN1YzDFdfKl9aX5Y48Kp0ZmZ7CjVsMVE2j/ryhs/+sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOtrQT6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOtrQT6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69622C4CED0;
	Thu, 12 Dec 2024 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019530;
	bh=Ra9rIS/DKZCYCjgOrIXLSmB7xF3yMs18vx24WtVa5os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOtrQT6EmRhn/kVzKkH+tUxRNRmUROOqtGhcxPSTWhWhNTyEUw61ej2k9Mw4yQ/Wi
	 iZS0J6iPcxj90I78kmAFBhzjAj8EB/TS/mHm+X5FPKnCkR9PrWjxjqnbgrEaG/nQzl
	 6MSPhRDIDb45JDYuJ2vzEEuXxBZ+wrBqW7yGN5VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/772] RDMA/hns: Add clear_hem return value to log
Date: Thu, 12 Dec 2024 15:52:49 +0100
Message-ID: <20241212144359.163430592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit a519a612a71848b69b70b18b4d14d165b2d8aaf7 ]

Log return value of clear_hem() to help diagnose.

Link: https://lore.kernel.org/r/20230523121641.3132102-4-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d81fb6511abf ("RDMA/hns: Use dev_* printings in hem code instead of ibdev_*")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 44 ++++++++++++++++--------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 2c8f0fd9557d1..d0f338ff78df5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -619,6 +619,7 @@ static void clear_mhop_hem(struct hns_roce_dev *hr_dev,
 	u32 hop_num = mhop->hop_num;
 	u32 chunk_ba_num;
 	u32 step_idx;
+	int ret;
 
 	index->inited = HEM_INDEX_BUF;
 	chunk_ba_num = mhop->bt_chunk_size / BA_BYTE_LEN;
@@ -642,16 +643,24 @@ static void clear_mhop_hem(struct hns_roce_dev *hr_dev,
 		else
 			step_idx = hop_num;
 
-		if (hr_dev->hw->clear_hem(hr_dev, table, obj, step_idx))
-			ibdev_warn(ibdev, "failed to clear hop%u HEM.\n", hop_num);
-
-		if (index->inited & HEM_INDEX_L1)
-			if (hr_dev->hw->clear_hem(hr_dev, table, obj, 1))
-				ibdev_warn(ibdev, "failed to clear HEM step 1.\n");
+		ret = hr_dev->hw->clear_hem(hr_dev, table, obj, step_idx);
+		if (ret)
+			ibdev_warn(ibdev, "failed to clear hop%u HEM, ret = %d.\n",
+				   hop_num, ret);
+
+		if (index->inited & HEM_INDEX_L1) {
+			ret = hr_dev->hw->clear_hem(hr_dev, table, obj, 1);
+			if (ret)
+				ibdev_warn(ibdev, "failed to clear HEM step 1, ret = %d.\n",
+					   ret);
+		}
 
-		if (index->inited & HEM_INDEX_L0)
-			if (hr_dev->hw->clear_hem(hr_dev, table, obj, 0))
-				ibdev_warn(ibdev, "failed to clear HEM step 0.\n");
+		if (index->inited & HEM_INDEX_L0) {
+			ret = hr_dev->hw->clear_hem(hr_dev, table, obj, 0);
+			if (ret)
+				ibdev_warn(ibdev, "failed to clear HEM step 0, ret = %d.\n",
+					   ret);
+		}
 	}
 }
 
@@ -688,6 +697,7 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 {
 	struct device *dev = hr_dev->dev;
 	unsigned long i;
+	int ret;
 
 	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
 		hns_roce_table_mhop_put(hr_dev, table, obj, 1);
@@ -700,8 +710,10 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 					 &table->mutex))
 		return;
 
-	if (hr_dev->hw->clear_hem(hr_dev, table, obj, HEM_HOP_STEP_DIRECT))
-		dev_warn(dev, "failed to clear HEM base address.\n");
+	ret = hr_dev->hw->clear_hem(hr_dev, table, obj, HEM_HOP_STEP_DIRECT);
+	if (ret)
+		dev_warn(dev, "failed to clear HEM base address, ret = %d.\n",
+			 ret);
 
 	hns_roce_free_hem(hr_dev, table->hem[i]);
 	table->hem[i] = NULL;
@@ -917,6 +929,8 @@ void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 {
 	struct device *dev = hr_dev->dev;
 	unsigned long i;
+	int obj;
+	int ret;
 
 	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
 		hns_roce_cleanup_mhop_hem_table(hr_dev, table);
@@ -925,9 +939,11 @@ void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 
 	for (i = 0; i < table->num_hem; ++i)
 		if (table->hem[i]) {
-			if (hr_dev->hw->clear_hem(hr_dev, table,
-			    i * table->table_chunk_size / table->obj_size, 0))
-				dev_err(dev, "clear HEM base address failed.\n");
+			obj = i * table->table_chunk_size / table->obj_size;
+			ret = hr_dev->hw->clear_hem(hr_dev, table, obj, 0);
+			if (ret)
+				dev_err(dev, "clear HEM base address failed, ret = %d.\n",
+					ret);
 
 			hns_roce_free_hem(hr_dev, table->hem[i]);
 		}
-- 
2.43.0



