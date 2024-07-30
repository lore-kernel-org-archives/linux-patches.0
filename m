Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7D189901;
	Tue, 30 Jul 2024 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359298; cv=none; b=XNb/fHY7UHfjuOcPdUZ/OLwjqwLxM1Dn9UG6340FYKdROIJUS4Tv6K8uJQERk0fFOVck03BkTQ9Typypr+h2XjuGXOWWUkbUASUf8CyEl7D+w5zy8b9ePxtbVN4UdorzHC+pqVMvCFsMbTc0BLPBywTSAr0gnSKvBLziMcWNDuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359298; c=relaxed/simple;
	bh=HThQ36L3xwnJiTcoQ7WPzt55k8koJSlSpfA0ZSOKnuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAiDfuAn4axl2+4ea+IJ0R0QWgSQIJ+7j98h/RoUnHWSO7x6FM1e3QeC9CxZHHtA+Th8ErFifYXoXFuuA5vIc/31VgO6r9KF18Spg3Gj0LRfPWmZjvQMgYqEK56sv1TJQTppCn32+GtZK5acabNZdghadLRY8a4jIH3z37v18qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EU1HjCOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EU1HjCOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747BBC32782;
	Tue, 30 Jul 2024 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359298;
	bh=HThQ36L3xwnJiTcoQ7WPzt55k8koJSlSpfA0ZSOKnuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EU1HjCOUnUFqAODMFhc6sbUUOvW7x0awn5xtu9xSABoNozihQ/v39vvKxQSghLHKL
	 WebBMMoDFhMVYTYFRyf9mEVMjmeioVFRDrDwlGDZmQCvyziAEAAPK1nCH4J2jBkDuh
	 6CmmYEp8GSVkPF/0mQGIsxQDBDgm2TssH+bi/9y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 463/809] RDMA/hns: Fix missing pagesize and alignment check in FRMR
Date: Tue, 30 Jul 2024 17:45:39 +0200
Message-ID: <20240730151743.016815774@linuxfoundation.org>
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

[ Upstream commit d387d4b54eb84208bd4ca13572e106851d0a0819 ]

The offset requires 128B alignment and the page size ranges from
4K to 128M.

Fixes: 68a997c5d28c ("RDMA/hns: Add FRMR support for hip08")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 4 ++++
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index f8451e5ab107e..7d5931872f8a7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -83,6 +83,7 @@
 #define MR_TYPE_DMA				0x03
 
 #define HNS_ROCE_FRMR_MAX_PA			512
+#define HNS_ROCE_FRMR_ALIGN_SIZE		128
 
 #define PKEY_ID					0xffff
 #define NODE_DESC_SIZE				64
@@ -189,6 +190,9 @@ enum {
 #define HNS_HW_PAGE_SHIFT			12
 #define HNS_HW_PAGE_SIZE			(1 << HNS_HW_PAGE_SHIFT)
 
+#define HNS_HW_MAX_PAGE_SHIFT			27
+#define HNS_HW_MAX_PAGE_SIZE			(1 << HNS_HW_MAX_PAGE_SHIFT)
+
 struct hns_roce_uar {
 	u64		pfn;
 	unsigned long	index;
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 1a61dceb33197..846da8c78b8b7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -443,6 +443,11 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 	struct hns_roce_mtr *mtr = &mr->pbl_mtr;
 	int ret, sg_num = 0;
 
+	if (!IS_ALIGNED(*sg_offset, HNS_ROCE_FRMR_ALIGN_SIZE) ||
+	    ibmr->page_size < HNS_HW_PAGE_SIZE ||
+	    ibmr->page_size > HNS_HW_MAX_PAGE_SIZE)
+		return sg_num;
+
 	mr->npages = 0;
 	mr->page_list = kvcalloc(mr->pbl_mtr.hem_cfg.buf_pg_count,
 				 sizeof(dma_addr_t), GFP_KERNEL);
-- 
2.43.0



