Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BFF19E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C1BC433EF;
	Wed,  7 Jun 2023 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170277;
	bh=4j1bQAvYl+/vTNWjPIqrHOrcVT474x9o514f+h7nx8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8WXIxUmhpnjM0UlfZQPZAFTW2RJpz+cM56hhUE0mMnj6E4RvvvJg8ekuQ/zn3WIv
	 A24h1Xxbba8lWwIDNxdu62M0nzncmlgorOZCwEOhiY+qtFAeloOkSY0oqSmsXcyuFq
	 0jiyK5y3p4/lmQE6m7FFYZ3fl8r5almNDE72DXUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/225] RDMA/hns: Fix base address table allocation
Date: Wed,  7 Jun 2023 22:13:18 +0200
Message-ID: <20230607200913.516835535@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 7f3969b14f356dd65fa95b3528eb05c32e68bc06 ]

For hns, the specification of an entry like resource (E.g. WQE/CQE/EQE)
depends on BT page size, buf page size and hopnum. For user mode, the buf
page size depends on UMEM. Therefore, the actual specification is
controlled by BT page size and hopnum.

The current BT page size and hopnum are obtained from firmware. This makes
the driver inflexible and introduces unnecessary constraints.  Resource
allocation failures occur in many scenarios.

This patch will calculate whether the BT page size set by firmware is
sufficient before allocating BT, and increase the BT page size if it is
insufficient.

Fixes: 1133401412a9 ("RDMA/hns: Optimize base address table config flow for qp buffer")
Link: https://lore.kernel.org/r/20230512092245.344442-3-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 43 +++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 37a5cf62f88b4..14376490ac226 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -33,6 +33,7 @@
 
 #include <linux/vmalloc.h>
 #include <rdma/ib_umem.h>
+#include <linux/math.h>
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
 #include "hns_roce_hem.h"
@@ -909,6 +910,44 @@ static int mtr_init_buf_cfg(struct hns_roce_dev *hr_dev,
 	return page_cnt;
 }
 
+static u64 cal_pages_per_l1ba(unsigned int ba_per_bt, unsigned int hopnum)
+{
+	return int_pow(ba_per_bt, hopnum - 1);
+}
+
+static unsigned int cal_best_bt_pg_sz(struct hns_roce_dev *hr_dev,
+				      struct hns_roce_mtr *mtr,
+				      unsigned int pg_shift)
+{
+	unsigned long cap = hr_dev->caps.page_size_cap;
+	struct hns_roce_buf_region *re;
+	unsigned int pgs_per_l1ba;
+	unsigned int ba_per_bt;
+	unsigned int ba_num;
+	int i;
+
+	for_each_set_bit_from(pg_shift, &cap, sizeof(cap) * BITS_PER_BYTE) {
+		if (!(BIT(pg_shift) & cap))
+			continue;
+
+		ba_per_bt = BIT(pg_shift) / BA_BYTE_LEN;
+		ba_num = 0;
+		for (i = 0; i < mtr->hem_cfg.region_count; i++) {
+			re = &mtr->hem_cfg.region[i];
+			if (re->hopnum == 0)
+				continue;
+
+			pgs_per_l1ba = cal_pages_per_l1ba(ba_per_bt, re->hopnum);
+			ba_num += DIV_ROUND_UP(re->count, pgs_per_l1ba);
+		}
+
+		if (ba_num <= ba_per_bt)
+			return pg_shift;
+	}
+
+	return 0;
+}
+
 static int mtr_alloc_mtt(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 			 unsigned int ba_page_shift)
 {
@@ -917,6 +956,10 @@ static int mtr_alloc_mtt(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 
 	hns_roce_hem_list_init(&mtr->hem_list);
 	if (!cfg->is_direct) {
+		ba_page_shift = cal_best_bt_pg_sz(hr_dev, mtr, ba_page_shift);
+		if (!ba_page_shift)
+			return -ERANGE;
+
 		ret = hns_roce_hem_list_request(hr_dev, &mtr->hem_list,
 						cfg->region, cfg->region_count,
 						ba_page_shift);
-- 
2.39.2



