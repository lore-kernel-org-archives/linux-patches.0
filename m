Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB191C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E5FC433D2;
	Wed, 28 Dec 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243877;
	bh=XiMLpo45J1vgXOJroZHAgOw3zs2PvsavUPb7lv5C+4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1SMQzOCb1M/B29rYxLbmajLrQxiKwGbkObdlw/bQvR3r1+dWOzKZYQctG0Npm77X
	 4tkAangntT3eatfuR/j47Zi24HJtyeCnodFV9BrXbqPKOWtaI02OjjmIk7addyT9Gb
	 dpm38jl3KH5U9JEV95w9zleEX6fUN99jlXg9dqzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luoyouming <luoyouming@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0603/1073] RDMA/hns: Fix ext_sge num error when post send
Date: Wed, 28 Dec 2022 15:36:31 +0100
Message-Id: <20221228144344.424955802@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 8eaa6f7d569b4a22bfc1b0a3fdfeeb401feb65a4 ]

In the HNS ROCE driver, The sge is divided into standard sge and extended
sge.  There are 2 standard sge in RC/XRC, and the UD standard sge is 0.
In the scenario of RC SQ inline, if the data does not exceed 32bytes, the
standard sge will be used. If it exceeds, only the extended sge will be
used to fill the data.

Currently, when filling the extended sge, max_gs is directly used as the
number of the extended sge, which did not subtract the number of standard
sge.  There is a logical error. The new algorithm subtracts the number of
standard sge from max_gs to get the actual number of extended sge.

Fixes: 30b707886aeb ("RDMA/hns: Support inline data in extented sge space for RC")
Link: https://lore.kernel.org/r/20221108133847.2304539-2-xuhaoyue1@hisilicon.com
Signed-off-by: Luoyouming <luoyouming@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index eb1601bd1255..ee05be2e3da6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -187,20 +187,29 @@ static void set_atomic_seg(const struct ib_send_wr *wr,
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SGE_NUM, valid_num_sge);
 }
 
+static unsigned int get_std_sge_num(struct hns_roce_qp *qp)
+{
+	if (qp->ibqp.qp_type == IB_QPT_GSI || qp->ibqp.qp_type == IB_QPT_UD)
+		return 0;
+
+	return HNS_ROCE_SGE_IN_WQE;
+}
+
 static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 				 const struct ib_send_wr *wr,
 				 unsigned int *sge_idx, u32 msg_len)
 {
 	struct ib_device *ibdev = &(to_hr_dev(qp->ibqp.device))->ib_dev;
-	unsigned int ext_sge_sz = qp->sq.max_gs * HNS_ROCE_SGE_SIZE;
 	unsigned int left_len_in_pg;
 	unsigned int idx = *sge_idx;
+	unsigned int std_sge_num;
 	unsigned int i = 0;
 	unsigned int len;
 	void *addr;
 	void *dseg;
 
-	if (msg_len > ext_sge_sz) {
+	std_sge_num = get_std_sge_num(qp);
+	if (msg_len > (qp->sq.max_gs - std_sge_num) * HNS_ROCE_SGE_SIZE) {
 		ibdev_err(ibdev,
 			  "no enough extended sge space for inline data.\n");
 		return -EINVAL;
-- 
2.35.1



