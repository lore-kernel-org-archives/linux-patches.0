Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360DB19E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC269C433EF;
	Wed,  7 Jun 2023 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170275;
	bh=aSMHMd7Ve45Nt/rPPLA18lQWxCU9kiubd3x+iCTL93c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbaikBItgx4UdYi793v8OueDnoqdoV0LlnMHESxI8xr7cglM4TvPmZ3UZuitzfj0C
	 SXyvI+K0vbBUTRmC32FNP/kYVuW22pGUTy0jHDFU+9fMZ5YZHXtUQqO7az/iOPsEbx
	 hsqxLzBpyFaquQYCaAL1wGd04tJVCMegXWIIVC3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/225] RDMA/hns: Fix timeout attr in query qp for HIP08
Date: Wed,  7 Jun 2023 22:13:17 +0200
Message-ID: <20230607200913.486495162@linuxfoundation.org>
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

[ Upstream commit 58caa2a51ad4fd21763696cc6c4defc9fc1b4b4f ]

On HIP08, the queried timeout attr is different from the timeout attr
configured by the user.

It is found by rdma-core testcase test_rdmacm_async_traffic:

======================================================================
FAIL: test_rdmacm_async_traffic (tests.test_rdmacm.CMTestCase)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./tests/test_rdmacm.py", line 33, in test_rdmacm_async_traffic
    self.two_nodes_rdmacm_traffic(CMAsyncConnection, self.rdmacm_traffic,
  File "./tests/base.py", line 382, in two_nodes_rdmacm_traffic
    raise(res)
AssertionError

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/20230512092245.344442-2-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 17 ++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 ++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b2421883993b1..7a5bfe6a9115f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5136,7 +5136,6 @@ static int hns_roce_v2_set_abs_fields(struct ib_qp *ibqp,
 static bool check_qp_timeout_cfg_range(struct hns_roce_dev *hr_dev, u8 *timeout)
 {
 #define QP_ACK_TIMEOUT_MAX_HIP08 20
-#define QP_ACK_TIMEOUT_OFFSET 10
 #define QP_ACK_TIMEOUT_MAX 31
 
 	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
@@ -5145,7 +5144,7 @@ static bool check_qp_timeout_cfg_range(struct hns_roce_dev *hr_dev, u8 *timeout)
 				   "local ACK timeout shall be 0 to 20.\n");
 			return false;
 		}
-		*timeout += QP_ACK_TIMEOUT_OFFSET;
+		*timeout += HNS_ROCE_V2_QP_ACK_TIMEOUT_OFS_HIP08;
 	} else if (hr_dev->pci_dev->revision > PCI_REVISION_ID_HIP08) {
 		if (*timeout > QP_ACK_TIMEOUT_MAX) {
 			ibdev_warn(&hr_dev->ib_dev,
@@ -5431,6 +5430,18 @@ static int hns_roce_v2_query_qpc(struct hns_roce_dev *hr_dev, u32 qpn,
 	return ret;
 }
 
+static u8 get_qp_timeout_attr(struct hns_roce_dev *hr_dev,
+			      struct hns_roce_v2_qp_context *context)
+{
+	u8 timeout;
+
+	timeout = (u8)hr_reg_read(context, QPC_AT);
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
+		timeout -= HNS_ROCE_V2_QP_ACK_TIMEOUT_OFS_HIP08;
+
+	return timeout;
+}
+
 static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 				int qp_attr_mask,
 				struct ib_qp_init_attr *qp_init_attr)
@@ -5508,7 +5519,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	qp_attr->max_dest_rd_atomic = 1 << hr_reg_read(&context, QPC_RR_MAX);
 
 	qp_attr->min_rnr_timer = (u8)hr_reg_read(&context, QPC_MIN_RNR_TIME);
-	qp_attr->timeout = (u8)hr_reg_read(&context, QPC_AT);
+	qp_attr->timeout = get_qp_timeout_attr(hr_dev, &context);
 	qp_attr->retry_cnt = hr_reg_read(&context, QPC_RETRY_NUM_INIT);
 	qp_attr->rnr_retry = hr_reg_read(&context, QPC_RNR_NUM_INIT);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index b1b3e1e0b84e5..2b4dbbb06eb56 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -72,6 +72,8 @@
 #define HNS_ROCE_V2_IDX_ENTRY_SZ		4
 
 #define HNS_ROCE_V2_SCCC_SZ			32
+#define HNS_ROCE_V2_QP_ACK_TIMEOUT_OFS_HIP08    10
+
 #define HNS_ROCE_V3_SCCC_SZ			64
 #define HNS_ROCE_V3_GMV_ENTRY_SZ		32
 
-- 
2.39.2



