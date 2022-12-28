Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B645E1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F47C433EF;
	Wed, 28 Dec 2022 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244454;
	bh=GhYvX4vhJILAVmlu8v7jLL61MXn0XygWVkKtAwxQ9WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAcBIzwcztJ0yH2e9+1gsyE8u+V9dPepnTERqrWNeSckYe7R+mD3nMooGleN6beSJ
	 9ySXQ4+UEsMwuQ8IKBt6c+6kg9q73/lz05ZR0I1hda+WQsPdPcdBZ6lUnvOJ/IkNcF
	 TGjE2bhq4D0rWwZAZytktaT8wZoamz2PUD4qiRdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0672/1146] RDMA/hns: Fix AH attr queried by query_qp
Date: Wed, 28 Dec 2022 15:36:51 +0100
Message-Id: <20221228144348.401217304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit bc34c04f7b97c3794dec5a6d6d27ffd5f0e4f5c8 ]

The queried AH attr is invalid. This patch fix it.

This problem is found by rdma-core test test_mr_rereg_pd

ERROR: test_mr_rereg_pd (tests.test_mr.MRTest)
Test that cover rereg MR's PD with this flow:
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./tests/test_mr.py", line 157, in test_mr_rereg_pd
    self.restate_qps()
  File "./tests/test_mr.py", line 113, in restate_qps
    self.server.qp.to_rts(self.server_qp_attr)
  File "qp.pyx", line 1137, in pyverbs.qp.QP.to_rts
  File "qp.pyx", line 1123, in pyverbs.qp.QP.to_rtr
pyverbs.pyverbs_error.PyverbsRDMAError: Failed to modify QP state to RTR.
Errno: 22, Invalid argument

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/20221126102911.2921820-3-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 621e6e927d61..6e08e733cde1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5463,6 +5463,8 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 		rdma_ah_set_sl(&qp_attr->ah_attr,
 			       hr_reg_read(&context, QPC_SL));
+		rdma_ah_set_port_num(&qp_attr->ah_attr, hr_qp->port + 1);
+		rdma_ah_set_ah_flags(&qp_attr->ah_attr, IB_AH_GRH);
 		grh->flow_label = hr_reg_read(&context, QPC_FL);
 		grh->sgid_index = hr_reg_read(&context, QPC_GMV_IDX);
 		grh->hop_limit = hr_reg_read(&context, QPC_HOPLIMIT);
-- 
2.35.1



