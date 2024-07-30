Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC1189503;
	Tue, 30 Jul 2024 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357892; cv=none; b=trl+TmN6nCjSGSfu/Ru5jtwsV1n1zbzVvqom5cq2F+ZhG9cMRlDmsC3pDT6EdeTKRq96UOdOmWYuYpVJMSTuaOCI9KOgV1L7/Y9jVBE6MX7HqCtM3uOiJspkcC9jG1OWzZhecT6WP0nWBQmo+r2FFBZppMOZat/LOsX6NTSLVNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357892; c=relaxed/simple;
	bh=b3J+ol486K2B/+0116NegKXvw31DcIscUTFk/Swa2Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXaRDdTKBLxZX29eCcSF6evSnRYFC4Ksl0Jpuy4O57l8S63+7F1ZHGsSyKsxC4OFI3O6/I3F9dEpEpXdYyxflPlrE7Z3nPe5Ri/ju5RTX3beP8GYLCPk/HISPlFF6XubmOanSESxWykA+t+sxwweiq6dPpt+c4UQ9n4t1Bj/kSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeIFJmlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeIFJmlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B3FC4AF0E;
	Tue, 30 Jul 2024 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357892;
	bh=b3J+ol486K2B/+0116NegKXvw31DcIscUTFk/Swa2Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeIFJmlV6BOisSuJreA6AhjPMDmpi5d8hFPuqcb4gFPG9+Mo5dzetROBP5RHpZpTs
	 o8zTaTklllPU63MuufbIImpHH5ouYw6ENMnP2ZwloSkhjA3rNoLgdRxcfOWW9Fw9xA
	 qJ3l66I2rh0MVJwYHAHpDIdcBn0F8wlesD5LTDdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/568] RDMA/hns: Fix missing pagesize and alignment check in FRMR
Date: Tue, 30 Jul 2024 17:46:48 +0200
Message-ID: <20240730151651.640390628@linuxfoundation.org>
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
index b3719579a24b3..cd593d651e4ca 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -82,6 +82,7 @@
 #define MR_TYPE_DMA				0x03
 
 #define HNS_ROCE_FRMR_MAX_PA			512
+#define HNS_ROCE_FRMR_ALIGN_SIZE		128
 
 #define PKEY_ID					0xffff
 #define NODE_DESC_SIZE				64
@@ -183,6 +184,9 @@ enum {
 #define HNS_HW_PAGE_SHIFT			12
 #define HNS_HW_PAGE_SIZE			(1 << HNS_HW_PAGE_SHIFT)
 
+#define HNS_HW_MAX_PAGE_SHIFT			27
+#define HNS_HW_MAX_PAGE_SIZE			(1 << HNS_HW_MAX_PAGE_SHIFT)
+
 struct hns_roce_uar {
 	u64		pfn;
 	unsigned long	index;
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 190e62da98e4b..980261969b0c0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -423,6 +423,11 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
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



