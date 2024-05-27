Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19E017E90E;
	Mon, 27 May 2024 19:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837222; cv=none; b=mtnyJyafkDZQvPt1/U0OCMVYqxXruj9qNeU/p5ni+2iZRHnAfpwZyiPsAicqZPG6OZKzYLLfy7/hAbvxtABDY+fde7SEwapy3RD/cZ98sAdq1+sVmMItMbc0/JH5bh3BdZKcHD3msd/BlcBe07qh9QrZYqq9JQgMyiIBM3I68+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837222; c=relaxed/simple;
	bh=vfSb5NdAchSC8A9t1RcHDk1F6lHke1WhT4Y6JJWfSAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBJIBxKOLedusCFO6vaFMsYxEIYE5qTLgcqWddhN/09ZQfR0sNPbJ3zF1NsiwZ3BYGvZTV19LqfpA320BzYWgGqa3rMu4THVmFA90aHaVYWy2i74bVAzBa+9sIK4/fqCqKivAD8NTEVravFd3NhW6z7QDlmqyc1DLpB8GpMwkp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzpvEs8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzpvEs8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDDDC2BBFC;
	Mon, 27 May 2024 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837222;
	bh=vfSb5NdAchSC8A9t1RcHDk1F6lHke1WhT4Y6JJWfSAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzpvEs8LZR9m5oHWkTsY1Yaf/1yACc0aJybjRy92GYqf/l5k7B+78OBhjacOuLMcD
	 P5yekbYzAoBNIrP/bfZ1uIlvcNK6bhZXNrRSuX5jxx4OR7zwqT6TzKH+sxTaZROWb1
	 dTcCu9QHU63sLLyLSnP83i0E7NLS2QmsF/mmIkZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 355/427] RDMA/hns: Add max_ah and cq moderation capacities in query_device()
Date: Mon, 27 May 2024 20:56:42 +0200
Message-ID: <20240527185633.641957483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 2ce384307f2ddf39dc662878e151722199afc9ae ]

Add max_ah and cq moderation capacities to hns_roce_query_device().

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 3 +++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   | 7 +++++++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index c3cbd0a494bfd..0b47c6d68804f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -100,6 +100,9 @@
 #define CQ_BANKID_SHIFT 2
 #define CQ_BANKID_MASK GENMASK(1, 0)
 
+#define HNS_ROCE_MAX_CQ_COUNT 0xFFFF
+#define HNS_ROCE_MAX_CQ_PERIOD 0xFFFF
+
 enum {
 	SERV_TYPE_RC,
 	SERV_TYPE_UC,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ba7ae792d279d..99f6ae6135c2f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5802,7 +5802,7 @@ static int hns_roce_v2_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 			dev_info(hr_dev->dev,
 				 "cq_period(%u) reached the upper limit, adjusted to 65.\n",
 				 cq_period);
-			cq_period = HNS_ROCE_MAX_CQ_PERIOD;
+			cq_period = HNS_ROCE_MAX_CQ_PERIOD_HIP08;
 		}
 		cq_period *= HNS_ROCE_CLOCK_ADJUST;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index df04bc8ede57b..dfed6b4ddb04d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1334,7 +1334,7 @@ struct fmea_ram_ecc {
 
 /* only for RNR timeout issue of HIP08 */
 #define HNS_ROCE_CLOCK_ADJUST 1000
-#define HNS_ROCE_MAX_CQ_PERIOD 65
+#define HNS_ROCE_MAX_CQ_PERIOD_HIP08 65
 #define HNS_ROCE_MAX_EQ_PERIOD 65
 #define HNS_ROCE_RNR_TIMER_10NS 1
 #define HNS_ROCE_1US_CFG 999
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 1dc60c2b2b7ab..4d94fcb8685ab 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -40,6 +40,7 @@
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
+#include "hns_roce_hw_v2.h"
 
 static int hns_roce_set_mac(struct hns_roce_dev *hr_dev, u32 port,
 			    const u8 *addr)
@@ -192,6 +193,12 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 			    IB_ATOMIC_HCA : IB_ATOMIC_NONE;
 	props->max_pkeys = 1;
 	props->local_ca_ack_delay = hr_dev->caps.local_ca_ack_delay;
+	props->max_ah = INT_MAX;
+	props->cq_caps.max_cq_moderation_period = HNS_ROCE_MAX_CQ_PERIOD;
+	props->cq_caps.max_cq_moderation_count = HNS_ROCE_MAX_CQ_COUNT;
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
+		props->cq_caps.max_cq_moderation_period = HNS_ROCE_MAX_CQ_PERIOD_HIP08;
+
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ) {
 		props->max_srq = hr_dev->caps.num_srqs;
 		props->max_srq_wr = hr_dev->caps.max_srq_wrs;
-- 
2.43.0



