Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D52FE570;
	Tue, 12 Aug 2025 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024461; cv=none; b=CRNSOorLARHhYhsPgiSKcaA1QIDOYD0HCDj9IVxM3qDR97qgAFO8+ASKhMkkFoXhkhnKRVI3FfW38MtTsXRjNzBhNEn49FA88+qzngBMZkSNADTGXLE4vsy0IMwGJM/CFrKtEXyOdxGGSJk9glPNyS0X8iQLCKWXlz2y6tyvZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024461; c=relaxed/simple;
	bh=66xKFWYNwNMasBanIubSF0f3PafBmlWOHLND4Swaekc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBSx2DzLY8nWEO+B2XDF9iiZnJTlPk910J/avytvafUKpJJAVuYON83vivO0JZQd2/iMH9Mh30qqQRkKC+MTP4MludvV+7g8bnEs7cckBQeFKXChdoVii59nHdD2/Fz4mM5yRl9wcjM6T01gC4t3BQ6HN9SgvkTXV2GMkRpuTx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mo1JyeRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mo1JyeRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BE3C4CEF0;
	Tue, 12 Aug 2025 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024461;
	bh=66xKFWYNwNMasBanIubSF0f3PafBmlWOHLND4Swaekc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mo1JyeRg1cZvB6q1G1tOZ1TbmRLtfDhAgQDiy5Ein6shJtB8mqakkq6qlK2nVBOF8
	 KG7/2kOtdLCH3jnMzu50mxdIQZclxnX2KjypLQQaIV3poQMSLlc9EsFBGHtoBgxtu8
	 tH7tCFBpnLpL2/Oh95RxdXxv2avXRMlIocjT7MEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 379/627] cxl/edac: Fix wrong dpa checking for PPR operation
Date: Tue, 12 Aug 2025 19:31:14 +0200
Message-ID: <20250812173433.716812321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit 03ff65c02559e8da32be231d7f10fe899233ceae ]

Per Table 8-143. "Get Partition Info Output Payload" in CXL r3.2 section
8.2.10.9.2.1 "Get Partition Info(Opcode 4100h)", DPA 0 is a valid
address of a CXL device. However, cxl_do_ppr() considers it as an
invalid address, so that user will get an -EINVAL when user calls the
sysfs interface of the edac driver to trigger a Post Package Repair(PPR)
operation for DPA 0 on a CXL device. The correct implementation should
be checking if the input DPA is in the DPA range of the CXL device.

Fixes: be9b359e056a ("cxl/edac: Add CXL memory device soft PPR control feature")
Signed-off-by: Li Ming <ming.li@zohomail.com>
Tested-by: Shiju Jose <shiju.jose@huawei.com>
Reviewed-by: Shiju Jose <shiju.jose@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20250711032357.127355-3-ming.li@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/edac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/edac.c b/drivers/cxl/core/edac.c
index 623aaa4439c4..991fa3e70522 100644
--- a/drivers/cxl/core/edac.c
+++ b/drivers/cxl/core/edac.c
@@ -1923,8 +1923,11 @@ static int cxl_ppr_set_nibble_mask(struct device *dev, void *drv_data,
 static int cxl_do_ppr(struct device *dev, void *drv_data, u32 val)
 {
 	struct cxl_ppr_context *cxl_ppr_ctx = drv_data;
+	struct cxl_memdev *cxlmd = cxl_ppr_ctx->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 
-	if (!cxl_ppr_ctx->dpa || val != EDAC_DO_MEM_REPAIR)
+	if (val != EDAC_DO_MEM_REPAIR ||
+	    !cxl_resource_contains_addr(&cxlds->dpa_res, cxl_ppr_ctx->dpa))
 		return -EINVAL;
 
 	return cxl_mem_perform_ppr(cxl_ppr_ctx);
-- 
2.39.5



