Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496EA762D2;
	Mon, 15 Apr 2024 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191722; cv=none; b=e9knHQHEDqGnKcH+QrihIkniudVe+wOluBKwiJDXdBdI0yPHnjIP/K5bqaQ+7Vxr7x8jbIFu2PjtZ6HeiwJR2NOzvNKuSlnWhWwz6P+NeOPWdbdduBK3i2VPWkUpls4/bbJA5s/FKS78KGhHrZruTXhZ/14Pjyt5lS8Qc60VxHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191722; c=relaxed/simple;
	bh=WBoFh24SDIMZqyS85byot9cpHgEnXfxyx/oLRuIQ61Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBiSV1BYf77uP7bJokn7BG9GPyiavc1CFLGipOkwL19GrlM1seAcaSG3P+PiRPkEY326rEt+p2qiGNPe/drRP3MtTBb2visJYJqyAB1tfh3Eq/nldIwQS8qL4dN9eIoa6F9FvqAIckML1Vd0N4MGfTwnutd8Ntu6FmMuy6L3IAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyFdct5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyFdct5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6657C4AF0A;
	Mon, 15 Apr 2024 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191722;
	bh=WBoFh24SDIMZqyS85byot9cpHgEnXfxyx/oLRuIQ61Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyFdct5Key9NKx7LYdkGWdi3TbBBAamNv1kwqmAiK0KriNVcF2OHzIO8LFv2Nf/2n
	 YpvkyEFCVnNb182HNbA5amLNj2s2nfPG7iPKSBp1m6DkEcvmlZSgBFTwmkO0a2raxW
	 8rfImIa9z/t7gALTkc4QxB/ZY/m4crxixVmyzwMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/122] Revert "s390/ism: fix receive message buffer allocation"
Date: Mon, 15 Apr 2024 16:20:29 +0200
Message-ID: <20240415141955.296070857@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit d51dc8dd6ab6f93a894ff8b38d3b8d02c98eb9fb ]

This reverts commit 58effa3476536215530c9ec4910ffc981613b413.
Review was not finished on this patch. So it's not ready for
upstreaming.

Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://lore.kernel.org/r/20240409113753.2181368-1-gbayer@linux.ibm.com
Fixes: 58effa347653 ("s390/ism: fix receive message buffer allocation")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 477d7b003c3f0..81aabbfbbe2ca 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -14,8 +14,6 @@
 #include <linux/err.h>
 #include <linux/ctype.h>
 #include <linux/processor.h>
-#include <linux/dma-mapping.h>
-#include <linux/mm.h>
 
 #include "ism.h"
 
@@ -293,15 +291,13 @@ static int ism_read_local_gid(struct ism_dev *ism)
 static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
-	dma_unmap_page(&ism->pdev->dev, dmb->dma_addr, dmb->dmb_len,
-		       DMA_FROM_DEVICE);
-	folio_put(virt_to_folio(dmb->cpu_addr));
+	dma_free_coherent(&ism->pdev->dev, dmb->dmb_len,
+			  dmb->cpu_addr, dmb->dma_addr);
 }
 
 static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 {
 	unsigned long bit;
-	int rc;
 
 	if (PAGE_ALIGN(dmb->dmb_len) > dma_get_max_seg_size(&ism->pdev->dev))
 		return -EINVAL;
@@ -318,30 +314,14 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	    test_and_set_bit(dmb->sba_idx, ism->sba_bitmap))
 		return -EINVAL;
 
-	dmb->cpu_addr =
-		folio_address(folio_alloc(GFP_KERNEL | __GFP_NOWARN |
-					  __GFP_NOMEMALLOC | __GFP_NORETRY,
-					  get_order(dmb->dmb_len)));
+	dmb->cpu_addr = dma_alloc_coherent(&ism->pdev->dev, dmb->dmb_len,
+					   &dmb->dma_addr,
+					   GFP_KERNEL | __GFP_NOWARN |
+					   __GFP_NOMEMALLOC | __GFP_NORETRY);
+	if (!dmb->cpu_addr)
+		clear_bit(dmb->sba_idx, ism->sba_bitmap);
 
-	if (!dmb->cpu_addr) {
-		rc = -ENOMEM;
-		goto out_bit;
-	}
-	dmb->dma_addr = dma_map_page(&ism->pdev->dev,
-				     virt_to_page(dmb->cpu_addr), 0,
-				     dmb->dmb_len, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&ism->pdev->dev, dmb->dma_addr)) {
-		rc = -ENOMEM;
-		goto out_free;
-	}
-
-	return 0;
-
-out_free:
-	kfree(dmb->cpu_addr);
-out_bit:
-	clear_bit(dmb->sba_idx, ism->sba_bitmap);
-	return rc;
+	return dmb->cpu_addr ? 0 : -ENOMEM;
 }
 
 int ism_register_dmb(struct ism_dev *ism, struct ism_dmb *dmb,
-- 
2.43.0



