Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F0463D5;
	Thu, 15 Aug 2024 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732217; cv=none; b=YOlcli7dMbdk44jwh4TYCen5rPR66BKWHO2XD+P1JxJR+6UWccFfcO3aIvXzq2Ahb5KnPkL85h5ui0pBrr0vTQYjTcqqdl5VUwOkcGaobY9WU7KAi1aCZv3rLd9IZRd2fL4DVpyVR/mqcY+r3p7OmB71T0TWxDI1pMFXEDhn9dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732217; c=relaxed/simple;
	bh=nPsBsovfPOi7AgUhQGrt1A0o15hZ+/7tbo61qpf+F18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knGoqg2PpHFTjfP4OXNeFQEAqGGfwew7KPEKQQtgRQjafjheXSl9q+tVyD/hWib1My2RNddo2kbGouYm/dRMsv3sSyRywy9U96S2LneIZr0nVtd4RC/cOAZh8EwLHl3JcnnntGQvASO2rb9bDQ7HXdJ/UN8fAcyx9HTFFFTkeW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlKkgiYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlKkgiYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A150C32786;
	Thu, 15 Aug 2024 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732217;
	bh=nPsBsovfPOi7AgUhQGrt1A0o15hZ+/7tbo61qpf+F18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlKkgiYiUijGpOvWSWbVjYiwT8d9OdPBitaWBzSbmdmkRDfZMs4wU3xdjTwfaELAn
	 FbnMRmLgp4u0pZ9o4VMHlh6Z38+xIDyOzHfFc2d03jM/89IQiag4lEXmu35iRzxheq
	 koFtlWt6dJ8ps3JCpkromvGggIrHNSKpgYzBEqf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/352] RDMA/hns: Fix missing pagesize and alignment check in FRMR
Date: Thu, 15 Aug 2024 15:22:55 +0200
Message-ID: <20240815131923.470678831@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fe54e09eeccdd..72a41f34ecfd5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -98,6 +98,7 @@
 #define MR_TYPE_DMA				0x03
 
 #define HNS_ROCE_FRMR_MAX_PA			512
+#define HNS_ROCE_FRMR_ALIGN_SIZE		128
 
 #define PKEY_ID					0xffff
 #define GUID_LEN				8
@@ -267,6 +268,9 @@ enum {
 #define HNS_HW_PAGE_SHIFT			12
 #define HNS_HW_PAGE_SIZE			(1 << HNS_HW_PAGE_SHIFT)
 
+#define HNS_HW_MAX_PAGE_SHIFT			27
+#define HNS_HW_MAX_PAGE_SIZE			(1 << HNS_HW_MAX_PAGE_SHIFT)
+
 struct hns_roce_uar {
 	u64		pfn;
 	unsigned long	index;
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index c038ed7d94962..7e93c9b4a33f1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -486,6 +486,11 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
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



