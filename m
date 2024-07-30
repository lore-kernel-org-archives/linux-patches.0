Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFF1A76A1;
	Tue, 30 Jul 2024 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359476; cv=none; b=eZSkHL0SRtiN48nNFk7x/uVFNqgXAGjtJPBRIx80YYf7/5r2lOyYDzIgdGt2tlkf5OUQQZZlIHYhQuwySRNsOhQngjn8BPeMWpO/HUtJJLglXdwEnN4w2sZ51+ig7WfzcVgIf+U5AyOoMCWZ58um7PDGMW552kWwX+QsmNhW338=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359476; c=relaxed/simple;
	bh=DzRCqH90N2DdhA9iXaScfYScu80uKfPjtZoJ3a1wP0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM2lqk9Bxaoc9v/DYcCjdTCbTeuq5AmynCiLlY5Zhzal3p+nODghrTe4daFObeBtKsBN13IQwNop8LbAjQD49N9T+DkFa6VJSeD9IBu5fJCDao7QpE5g93k3K2Z8gfWX4fhUzAjXP8PiaLbHQarisXpvR1hYjbEdXYLrDYbmUJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL4dWE7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL4dWE7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBE7C4AF0C;
	Tue, 30 Jul 2024 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359476;
	bh=DzRCqH90N2DdhA9iXaScfYScu80uKfPjtZoJ3a1wP0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL4dWE7JHX5ucL1mZ2vhZwUS2U75zKv0w4W3xh8CIOTOqZdaBIyAphVE6NHr7KvZB
	 9roWIkB7oUuVMbopjySN3i2DYDp7rXFR78gKC0q83jkG9AyhfjKRGP4pAv1o80ltZ7
	 4w2RpqHU75rNWANf0jOUr1Hscn3gluppgc+B0cWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 466/809] RDMA/hns: Fix insufficient extend DB for VFs.
Date: Tue, 30 Jul 2024 17:45:42 +0200
Message-ID: <20240730151743.138605690@linuxfoundation.org>
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
index cbbc142afc1be..aecd137c1e605 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2463,14 +2463,16 @@ static int set_llm_cfg_to_hw(struct hns_roce_dev *hr_dev,
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



