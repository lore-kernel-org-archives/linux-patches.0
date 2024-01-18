Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9407824B34;
	Thu, 18 Jan 2024 11:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575665; cv=none; b=fOTFiJ4U52YxoA3i3i9xa48Y2vnK2Y/QZ7G2O0ClagyY7Hn8N81IwZtm2rWL9VKGAJ9qp1rGOE3R8OVYN6Eud1sUfbXKOeTaPoyl5cPFWxrgHZo77mqR8pNord2pm35HZxmXnW+sxMNnm1B+mPqq2IzFoI8XdkM8iJKtqsrB6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575665; c=relaxed/simple;
	bh=LrJWu2RfZSb1vnSbkefxzjxR1f1kUrnIf0owN4fQ04c=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SkiriHuBsyFjT4C96NMHdCQJi4MJ+uw/a2xsNuhGLQsgobZIpBQIABD+4UbBbu1kvXrJjbmLTGpzFRZypBuElYxByAsPU6IgJxpjec9+Oc+kA2BciKJtreiUwwdt9l9zU2U61eURlVHmY9R/Ob42a5kAHPU+flwpTGWh+xmqA5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWXuv5mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWXuv5mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C6DC43390;
	Thu, 18 Jan 2024 11:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575665;
	bh=LrJWu2RfZSb1vnSbkefxzjxR1f1kUrnIf0owN4fQ04c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWXuv5mp6xkfkubtf02MEDBTskxwHPjMJBXpJJgXWQiynvScHcMPlMjqf5f4aRvf8
	 s9tpgyCdxYbMAprORyiGWS0V6OZ1/90hKE5wBA0H0hGqVbKBaZXWopHWf+V6CB+VWY
	 CgJZKB+TT+99oCHhU8JunqDeyoToxO9UV1lpNah8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/100] s390/scm: fix virtual vs physical address confusion
Date: Thu, 18 Jan 2024 11:49:08 +0100
Message-ID: <20240118104313.531662430@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit b1a6a1a77f0666a5a6dc0893ab6ec8fcae46f24c ]

Fix virtual vs physical address confusion (which currently are the same).

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/scm_blk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 0c1df1d5f1ac..a165b1a59fde 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -17,6 +17,7 @@
 #include <linux/blk-mq.h>
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/io.h>
 #include <asm/eadm.h>
 #include "scm_blk.h"
 
@@ -130,7 +131,7 @@ static void scm_request_done(struct scm_request *scmrq)
 
 	for (i = 0; i < nr_requests_per_io && scmrq->request[i]; i++) {
 		msb = &scmrq->aob->msb[i];
-		aidaw = msb->data_addr;
+		aidaw = (u64)phys_to_virt(msb->data_addr);
 
 		if ((msb->flags & MSB_FLAG_IDA) && aidaw &&
 		    IS_ALIGNED(aidaw, PAGE_SIZE))
@@ -195,12 +196,12 @@ static int scm_request_prepare(struct scm_request *scmrq)
 	msb->scm_addr = scmdev->address + ((u64) blk_rq_pos(req) << 9);
 	msb->oc = (rq_data_dir(req) == READ) ? MSB_OC_READ : MSB_OC_WRITE;
 	msb->flags |= MSB_FLAG_IDA;
-	msb->data_addr = (u64) aidaw;
+	msb->data_addr = (u64)virt_to_phys(aidaw);
 
 	rq_for_each_segment(bv, req, iter) {
 		WARN_ON(bv.bv_offset);
 		msb->blk_count += bv.bv_len >> 12;
-		aidaw->data_addr = (u64) page_address(bv.bv_page);
+		aidaw->data_addr = virt_to_phys(page_address(bv.bv_page));
 		aidaw++;
 	}
 
-- 
2.43.0



