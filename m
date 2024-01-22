Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622F313A246;
	Tue, 23 Jan 2024 00:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968127; cv=none; b=a5RNNVRaIIUY1vnfXp1Hv0Gztc6BmQmJ3Pz/2mGUs7w8PEriLX8GN4QVgreb+jen8ySzj9q+q48Ii2MCX8z5oW+eD8jg6ZadeAOh1T7rTu5/gefedw+k7JWN8yZ4WRBE5zKJmngPP5L+J/BFMv9+iayj1ZLRfuHvl8KU8a97TEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968127; c=relaxed/simple;
	bh=EjDe6KE/KcS3UYMjN2XZDFx4mKzp9+ZTcKe8kh0JuHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4//SDiEdj8xycxixkqNaGZalaf+en9ahh6P0R8AKymAhPm7mJDebhcv83URObQx5ptVzV26pUzaQ03xIMYoCa4MdMISknmjzwH9Al/Lh1wcB6OBvsgqkAL9r6BUiATR9vCYnab/mWcOtwLB4NONIHxyVlcLHBZRMhiKZUVa+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6f9uckm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6f9uckm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BAFC433F1;
	Tue, 23 Jan 2024 00:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968127;
	bh=EjDe6KE/KcS3UYMjN2XZDFx4mKzp9+ZTcKe8kh0JuHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6f9uckmiK7PgQA02KKl0ry7nyS3Cb0sJDegNnghK17kZizgjK3FmvRxx6DjoOKE3
	 obrv8rBa8NTD0ac2S+vVMfUFkzeW041T0VbxYeFC6LshXa5xDojthO21GNOUYPDTjN
	 rTxBV+9TgH5WAwOCFlwJNJbe3yQJPf94VM5W00J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/148] s390/scm: fix virtual vs physical address confusion
Date: Mon, 22 Jan 2024 15:56:14 -0800
Message-ID: <20240122235713.164677270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e01889394c84..d3133023a557 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -18,6 +18,7 @@
 #include <linux/genhd.h>
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/io.h>
 #include <asm/eadm.h>
 #include "scm_blk.h"
 
@@ -131,7 +132,7 @@ static void scm_request_done(struct scm_request *scmrq)
 
 	for (i = 0; i < nr_requests_per_io && scmrq->request[i]; i++) {
 		msb = &scmrq->aob->msb[i];
-		aidaw = msb->data_addr;
+		aidaw = (u64)phys_to_virt(msb->data_addr);
 
 		if ((msb->flags & MSB_FLAG_IDA) && aidaw &&
 		    IS_ALIGNED(aidaw, PAGE_SIZE))
@@ -196,12 +197,12 @@ static int scm_request_prepare(struct scm_request *scmrq)
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



