Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB44749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489B2C433D2;
	Thu, 12 Jan 2023 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532996;
	bh=u73HIvtlZyWWbC1Vw6KW+A1FSYnCFaKKJSJiCNkjbVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbIyS091o/evbSJqbUXUICs5+yZorFUeaKTiW5DCUdTo0BCvkbrjoidrQttSiaL7l
	 8RQDPEFdZJQrmCED/7Z7dBzTT1iHwtQv2UQZ8xsfa4sMuT0MyACuPUHWDncR3oFpDr
	 GOwtBaDRPR8aY/A4BVIR+nCSVdmNKpFsXjeOhsrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luoyouming <luoyouming@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/783] RDMA/hns: Repacing dseg_len by macros in fill_ext_sge_inl_data()
Date: Thu, 12 Jan 2023 14:50:21 +0100
Message-Id: <20230112135538.458523286@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luoyouming <luoyouming@huawei.com>

[ Upstream commit 3b1f864c904915b3baebffb31ea05ee704b0df3c ]

The sge size is known to be constant, so it's unnecessary to use sizeof to
calculate.

Link: https://lore.kernel.org/r/20220922123315.3732205-11-xuhaoyue1@hisilicon.com
Signed-off-by: Luoyouming <luoyouming@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8eaa6f7d569b ("RDMA/hns: Fix ext_sge num error when post send")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6dab03b7aca8..4836090ec817 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -159,8 +159,7 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 				 unsigned int *sge_idx, u32 msg_len)
 {
 	struct ib_device *ibdev = &(to_hr_dev(qp->ibqp.device))->ib_dev;
-	unsigned int dseg_len = sizeof(struct hns_roce_v2_wqe_data_seg);
-	unsigned int ext_sge_sz = qp->sq.max_gs * dseg_len;
+	unsigned int ext_sge_sz = qp->sq.max_gs * HNS_ROCE_SGE_SIZE;
 	unsigned int left_len_in_pg;
 	unsigned int idx = *sge_idx;
 	unsigned int i = 0;
@@ -188,7 +187,7 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 		if (len <= left_len_in_pg) {
 			memcpy(dseg, addr, len);
 
-			idx += len / dseg_len;
+			idx += len / HNS_ROCE_SGE_SIZE;
 
 			i++;
 			if (i >= wr->num_sge)
@@ -203,7 +202,7 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 
 			len -= left_len_in_pg;
 			addr += left_len_in_pg;
-			idx += left_len_in_pg / dseg_len;
+			idx += left_len_in_pg / HNS_ROCE_SGE_SIZE;
 			dseg = hns_roce_get_extend_sge(qp,
 						idx & (qp->sge.sge_cnt - 1));
 			left_len_in_pg = 1 << HNS_HW_PAGE_SHIFT;
-- 
2.35.1



