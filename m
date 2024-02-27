Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2644B78B61;
	Tue, 27 Feb 2024 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043550; cv=none; b=VytvVhtvw8iQYXE5trczcdoRAKWp2Wj4UJIZoR1XAnlkhyEFsbO5d5Ra8QiTK7DAM7sTWDm7LmSxAS4VCvzCCa82vszEnfUtA0Ax2QM1xzVHAcXgLx2LgF7PNegVhUUz7qBy3uxfE+xWG/241yWhiVlETxPa7AKXikioFelD87g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043550; c=relaxed/simple;
	bh=GJFMKHmBU68Cy7mALJAe234vMhGUFEIS+WBhdKX/WWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMdyPbyn/Ws31tiwLrlnqRI1WluHgu8qMq8i6CdBx4mDrXuE8mH6D+G7iovLiLCsD5H9cqgYSmaRaRJcuOis/xIhs/ysfpi+41nj08WP5+R1/+CvBlnACPUCTh2mkMn9BiNqyya+ZCTeXlfeEZppOh/ESW0LEpSb6dUYH3XHSws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJMdkjZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJMdkjZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A827BC433C7;
	Tue, 27 Feb 2024 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043550;
	bh=GJFMKHmBU68Cy7mALJAe234vMhGUFEIS+WBhdKX/WWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJMdkjZqpm7vyDkbuNNl7VMd6LfhPWLAe52BuJe7dOSdgaVqOLXlo4w7bcVetXJEQ
	 D4dDdz+hy4QE8+scSVXK/wvSlG+DwjLipt0w93SBHUjeUL9JY4drG3axCGzKPoeP/o
	 en9WPOcT7HDK7ogAQ2uos1LpJpPlCX2d2EBYzNlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/195] RDMA/bnxt_re: Return error for SRQ resize
Date: Tue, 27 Feb 2024 14:26:32 +0100
Message-ID: <20240227131614.766619003@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3687b450c5f32e80f179ce4b09e0454da1449eac ]

SRQ resize is not supported in the driver. But driver is not
returning error from bnxt_re_modify_srq() for SRQ resize.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 4ed8814efde6f..6ed0568747eaa 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1710,7 +1710,7 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 	switch (srq_attr_mask) {
 	case IB_SRQ_MAX_WR:
 		/* SRQ resize is not supported */
-		break;
+		return -EINVAL;
 	case IB_SRQ_LIMIT:
 		/* Change the SRQ threshold */
 		if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
@@ -1725,13 +1725,12 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 		/* On success, update the shadow */
 		srq->srq_limit = srq_attr->srq_limit;
 		/* No need to Build and send response back to udata */
-		break;
+		return 0;
 	default:
 		ibdev_err(&rdev->ibdev,
 			  "Unsupported srq_attr_mask 0x%x", srq_attr_mask);
 		return -EINVAL;
 	}
-	return 0;
 }
 
 int bnxt_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
-- 
2.43.0



