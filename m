Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807063AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005ECC4339E;
	Wed,  7 Jun 2023 20:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169316;
	bh=kcfzZsM5n+TmCIR2BvESjOVnORqZOjlP1FqDOujtkHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHRGkXrpcy/kPdb3KxUvn+eKHBPrSeP27XpqC7mhQlpTWH/q/FJNt2mJm+gyBIn77
	 TAmwnDTWYefmEfZvkeN3CH5LeBVleoN9fNLvUhdxkQH0wYSQYaEsq2X0Nh7Q93udkX
	 6X8oC7PB6SANN9nfujBHx+9+hyAEB/Seai5gd2+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangyang Li <liyangyang20@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 006/286] RDMA/hns: Modify the value of long message loopback slice
Date: Wed,  7 Jun 2023 22:11:45 +0200
Message-ID: <20230607200923.205888725@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit 56518a603fd2bf74762d176ac980572db84a3e14 ]

Long message loopback slice is used for achieving traffic balance between
QPs. It prevents the problem that QPs with large traffic occupying the
hardware pipeline for a long time and QPs with small traffic cannot be
scheduled.

Currently, its maximum value is set to 16K, which means only after a QP
sends 16K will the second QP be scheduled. This value is too large, which
will lead to unbalanced traffic scheduling, and thus it needs to be
modified.

The setting range of the long message loopback slice is modified to be
from 1024 (the lower limit supported by hardware) to mtu. Actual testing
shows that this value can significantly reduce error in hardware traffic
scheduling.

This solution is compatible with both HIP08 and HIP09. The modified
lp_pktn_ini has a maximum value of 2 (when mtu is 256), so the range
checking code for lp_pktn_ini is no longer necessary and needs to be
deleted.

Fixes: 0e60778efb07 ("RDMA/hns: Modify the value of MAX_LP_MSG_LEN to meet hardware compatibility")
Link: https://lore.kernel.org/r/20230512092245.344442-4-huangjunxian6@hisilicon.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 79954d99dc7a3..9369f93afaedd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4664,11 +4664,9 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	mtu = ib_mtu_enum_to_int(ib_mtu);
 	if (WARN_ON(mtu <= 0))
 		return -EINVAL;
-#define MAX_LP_MSG_LEN 16384
-	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 16KB */
-	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
-	if (WARN_ON(lp_pktn_ini >= 0xF))
-		return -EINVAL;
+#define MIN_LP_MSG_LEN 1024
+	/* mtu * (2 ^ lp_pktn_ini) should be in the range of 1024 to mtu */
+	lp_pktn_ini = ilog2(max(mtu, MIN_LP_MSG_LEN) / mtu);
 
 	if (attr_mask & IB_QP_PATH_MTU) {
 		hr_reg_write(context, QPC_MTU, ib_mtu);
-- 
2.39.2



