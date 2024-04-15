Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66FD78C75;
	Mon, 15 Apr 2024 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191333; cv=none; b=X+LLvTS0GYuTy0Dr6/R1Qj6PQUkvUjMBDb9VuWHizRvZLzvo3b36nE3WHO2baQUjwZIY08ceoLO10HWk+N8PxyDV/DPJG4mDV0eQ/cSR9vPnyUrh43hau1WBcXYqVhHSRevPiG27de9ynxGkn6kze4m7DeYVgNxkNPuGZKlUQzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191333; c=relaxed/simple;
	bh=7tw3wU3GXeDzIFlXyeZGAZmbn2fC0uWW65UnIbuQRLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc0WipK7nF2hJF2xPjunZODELghfOriUzDHIz117q8d/Qnxf3P57P6WWwzX+cFY1xUCeazaQtYFp0KUiQT/5xi5WF9vbcdtopfAHvwlZirW4m/le4HMjDmmdrPZPvs+VarSJOK1uby/i3Fpl2txGOcQ9RtpHQIPu22h0iH973ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpPQD+Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpPQD+Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E32C2BD11;
	Mon, 15 Apr 2024 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191333;
	bh=7tw3wU3GXeDzIFlXyeZGAZmbn2fC0uWW65UnIbuQRLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpPQD+NuHo8KFUM1m3vV+e6XCyMO31nQG8f/Qs+8CZoG8hu2iPJoEhpZ91p/IJhuy
	 da9FSXneY6rg+Dzw/7p1hc718FJf0cwKaVvwH1H9yRnH8jNgwGlCQibIt0ER1oU1VY
	 2kd8Fg+mc5afsxA6nFwZPkkLWJ2YBvZwxn81f+u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 092/172] Revert "s390/ism: fix receive message buffer allocation"
Date: Mon, 15 Apr 2024 16:19:51 +0200
Message-ID: <20240415142003.188614846@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index affb05521e146..2c8e964425dc3 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -14,8 +14,6 @@
 #include <linux/err.h>
 #include <linux/ctype.h>
 #include <linux/processor.h>
-#include <linux/dma-mapping.h>
-#include <linux/mm.h>
 
 #include "ism.h"
 
@@ -294,15 +292,13 @@ static int ism_read_local_gid(struct ism_dev *ism)
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
@@ -319,30 +315,14 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
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



