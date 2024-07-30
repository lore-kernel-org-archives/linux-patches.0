Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B511A6166;
	Tue, 30 Jul 2024 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357924; cv=none; b=Ja2IANmQCB+Z20KvIZyMXUu4CkewSGq+Wj7K5Sbc4/ZyzWELTwNI4r4olfGhDUwtijgCaSNvgLXa/Flk8j97SF1XjNCQovjgMqtLTBLIF2llaptlW3vDXCwZbCB+8yJQoLsEoIbVYHHXk9m7HRYGOsid4ih/AYDouQ/OZHmrbpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357924; c=relaxed/simple;
	bh=cJhik+M8otWZvXxg9egqSnYTxnCFQuBVk3L1E7wk8aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYaNqHb2q+0MGNoIkTJvqo+FcwPnlXnN1IMyjozCDiPtD3IYS/eQCa9KVEOy2psX24ZcKrekTSX7ZBFwkGNnrxgeI0SswTxPssTo8isEfvBgknbjb4MT/nmWJPr1x6McJwt3FFo38Tr8W5UPYduWLeW8m0HDoGyj4qjqn3qhHxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJIAlpiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJIAlpiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E2CC4AF0E;
	Tue, 30 Jul 2024 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357924;
	bh=cJhik+M8otWZvXxg9egqSnYTxnCFQuBVk3L1E7wk8aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJIAlpiNwiOr+5YVSpbVPuK+YJzqHGpaDMTZLDsUFmEuAuA7JgkKax4iJKrppLBwZ
	 HWx0fKutoB+PrfeANpbPvBpYNMWPKX9sWXjqGQuajLqmIQC43ZtrfFhUBsdKB6PTyE
	 xkiO/xV6/p3O2osgKanNMWFzsEFYyzH0DSDDWXLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/568] RDMA/hns: Fix insufficient extend DB for VFs.
Date: Tue, 30 Jul 2024 17:46:51 +0200
Message-ID: <20240730151651.757536442@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 0b8e658f70ffd5dc7cda3872fd524d657d4796b7 ]

VFs and its PF will share the memory of the extend DB. Currently,
the number of extend DB allocated by driver is only enough for PF.
This leads to a probability of DB loss and some other problems in
scenarios where both PF and VFs use a large number of QPs.

Fixes: 6b63597d3540 ("RDMA/hns: Add TSQ link table support")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 680fe2bdda09d..a49280e2df8ca 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2448,14 +2448,16 @@ static int set_llm_cfg_to_hw(struct hns_roce_dev *hr_dev,
 static struct hns_roce_link_table *
 alloc_link_table_buf(struct hns_roce_dev *hr_dev)
 {
+	u16 total_sl = hr_dev->caps.sl_num * hr_dev->func_num;
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hns_roce_link_table *link_tbl;
 	u32 pg_shift, size, min_size;
 
 	link_tbl = &priv->ext_llm;
 	pg_shift = hr_dev->caps.llm_buf_pg_sz + PAGE_SHIFT;
-	size = hr_dev->caps.num_qps * HNS_ROCE_V2_EXT_LLM_ENTRY_SZ;
-	min_size = HNS_ROCE_EXT_LLM_MIN_PAGES(hr_dev->caps.sl_num) << pg_shift;
+	size = hr_dev->caps.num_qps * hr_dev->func_num *
+	       HNS_ROCE_V2_EXT_LLM_ENTRY_SZ;
+	min_size = HNS_ROCE_EXT_LLM_MIN_PAGES(total_sl) << pg_shift;
 
 	/* Alloc data table */
 	size = max(size, min_size);
-- 
2.43.0



