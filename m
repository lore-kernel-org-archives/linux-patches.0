Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96961774B;
	Thu, 18 Jan 2024 10:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575405; cv=none; b=toQ4JvsG4ZPZLrC081yNVy6xlJEZdVT+UnQHijd9O5Gm8FAEVOIWOVZsZ5ruJEmWYEq0IJUzEFGXFHfELTPJVgbhoV59UjPktsgwfFe8lmGV/KuEyg//Hp3VR9nLzD9v92Xz/nExL5yZDYCB/937Dj0Iu9dlSheJGybJo2G6Ddc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575405; c=relaxed/simple;
	bh=2fuKmE0iJtvMy94Ov77WFG26ZZc2DylF33HyxXbt0iE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=QDEc5nTciu7halZPVqu8EUWSq2N7TOqQKxpsP5DqH0LbDmJQXTkxS8wLDOs7Bc+Dol+UXrkzYR7z7mg5Z1uQ4g4AQ/GDJqYrTmjy9KOfYgnCHq0Z6psWHSPkSRNI7AzcGiJNTOBbXjIfqFKEZxC3AtzYV1ZXPWY++t6sj7wPC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmTR59iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmTR59iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2C1C433F1;
	Thu, 18 Jan 2024 10:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575404;
	bh=2fuKmE0iJtvMy94Ov77WFG26ZZc2DylF33HyxXbt0iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmTR59iqYlLrha38En8bH+Egmyvch/+7sFeYjrUidEX31yG196nLQymjaZs9Qz6fc
	 Cg9l+L8iBXu04mL6GvPryyvgRUgGown9SuYLSmfeq3Wiqn+nGTVrVnr7ynD7KaMpeB
	 4bghT3vHzFGSq9xcM8DIxk3ZF9HM1laPPM8H+JUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/150] s390/scm: fix virtual vs physical address confusion
Date: Thu, 18 Jan 2024 11:48:35 +0100
Message-ID: <20240118104324.251311072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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
index 3a9cc8a4a230..ade95e91b3c8 100644
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



