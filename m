Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1A2F5491;
	Tue, 31 Mar 2026 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976582; cv=none; b=Qox3KeZHyMB8BFdeGvDmVvm6ngPYQsgtlSOUWj+ZMP//8RJvrIMmbt+SFj9uuMbVMKtvV3c2Z+2bNfggvBq1PE3tPyRewmYYdS5QCxObjOHpXJ65dEf0DIj0FbEyTBN3IPR1sBcw/R5rND35eN02KJajNs7Kya7JVFf02dVLyBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976582; c=relaxed/simple;
	bh=gjcVj02mr6V2vNkoyRWzRQUSyPt7f3SL9wKhVF21Ozo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYh2tae75pRKdiBBy7ZvQYTc/x1/C/dXx0tATihuhouhVHZHN2Ck6m81OsWTLf9FnoI9IQlq/0dkNAd8BvDq2+P1U0Gt9TgbSIheXUAOI2H5QxjO0LQGmIhJAFy8aW42uSAIaL//c8H1x3ycUrgHejXEvS6VONEWrjgJUlpejSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8YekhvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8YekhvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDDAC19424;
	Tue, 31 Mar 2026 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976582;
	bh=gjcVj02mr6V2vNkoyRWzRQUSyPt7f3SL9wKhVF21Ozo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8YekhvDjpctfu907WQZHze+N6NSFh8v88VxFdJZ1VGy1QdneY5WBzvgq/la1f9J5
	 ScqghGRsmvXs9+zmShrzmdMTV33+pXw0ahvgwNBhhISsZL6nzgAvrGix9RosJ14V6u
	 pt46C3xTRcevH896WFyo8i7bo1Hk2XheXoGq9Ib0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/309] RDMA/irdma: Harden depth calculation functions
Date: Tue, 31 Mar 2026 18:20:51 +0200
Message-ID: <20260331161758.918188909@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit e37afcb56ae070477741fe2d6e61fc0c542cce2d ]

An issue was exposed where OS can pass in U32_MAX for SQ/RQ/SRQ size.
This can cause integer overflow and truncation of SQ/RQ/SRQ depth
returning a success when it should have failed.

Harden the functions to do all depth calculations and boundary
checking in u64 sizes.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/uk.c | 39 ++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index d5568584ad5e3..4cc81d61be7fa 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1410,7 +1410,7 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
  * irdma_round_up_wq - return round up qp wq depth
  * @wqdepth: wq depth in quanta to round up
  */
-static int irdma_round_up_wq(u32 wqdepth)
+static u64 irdma_round_up_wq(u64 wqdepth)
 {
 	int scount = 1;
 
@@ -1463,15 +1463,16 @@ void irdma_get_wqe_shift(struct irdma_uk_attrs *uk_attrs, u32 sge,
 int irdma_get_sqdepth(struct irdma_uk_attrs *uk_attrs, u32 sq_size, u8 shift,
 		      u32 *sqdepth)
 {
-	u32 min_size = (u32)uk_attrs->min_hw_wq_size << shift;
+	u32 min_hw_quanta = (u32)uk_attrs->min_hw_wq_size << shift;
+	u64 hw_quanta =
+		irdma_round_up_wq(((u64)sq_size << shift) + IRDMA_SQ_RSVD);
 
-	*sqdepth = irdma_round_up_wq((sq_size << shift) + IRDMA_SQ_RSVD);
-
-	if (*sqdepth < min_size)
-		*sqdepth = min_size;
-	else if (*sqdepth > uk_attrs->max_hw_wq_quanta)
+	if (hw_quanta < min_hw_quanta)
+		hw_quanta = min_hw_quanta;
+	else if (hw_quanta > uk_attrs->max_hw_wq_quanta)
 		return -EINVAL;
 
+	*sqdepth = hw_quanta;
 	return 0;
 }
 
@@ -1485,15 +1486,16 @@ int irdma_get_sqdepth(struct irdma_uk_attrs *uk_attrs, u32 sq_size, u8 shift,
 int irdma_get_rqdepth(struct irdma_uk_attrs *uk_attrs, u32 rq_size, u8 shift,
 		      u32 *rqdepth)
 {
-	u32 min_size = (u32)uk_attrs->min_hw_wq_size << shift;
-
-	*rqdepth = irdma_round_up_wq((rq_size << shift) + IRDMA_RQ_RSVD);
+	u32 min_hw_quanta = (u32)uk_attrs->min_hw_wq_size << shift;
+	u64 hw_quanta =
+		irdma_round_up_wq(((u64)rq_size << shift) + IRDMA_RQ_RSVD);
 
-	if (*rqdepth < min_size)
-		*rqdepth = min_size;
-	else if (*rqdepth > uk_attrs->max_hw_rq_quanta)
+	if (hw_quanta < min_hw_quanta)
+		hw_quanta = min_hw_quanta;
+	else if (hw_quanta > uk_attrs->max_hw_rq_quanta)
 		return -EINVAL;
 
+	*rqdepth = hw_quanta;
 	return 0;
 }
 
@@ -1507,13 +1509,16 @@ int irdma_get_rqdepth(struct irdma_uk_attrs *uk_attrs, u32 rq_size, u8 shift,
 int irdma_get_srqdepth(struct irdma_uk_attrs *uk_attrs, u32 srq_size, u8 shift,
 		       u32 *srqdepth)
 {
-	*srqdepth = irdma_round_up_wq((srq_size << shift) + IRDMA_RQ_RSVD);
+	u32 min_hw_quanta = (u32)uk_attrs->min_hw_wq_size << shift;
+	u64 hw_quanta =
+		irdma_round_up_wq(((u64)srq_size << shift) + IRDMA_RQ_RSVD);
 
-	if (*srqdepth < ((u32)uk_attrs->min_hw_wq_size << shift))
-		*srqdepth = uk_attrs->min_hw_wq_size << shift;
-	else if (*srqdepth > uk_attrs->max_hw_srq_quanta)
+	if (hw_quanta < min_hw_quanta)
+		hw_quanta = min_hw_quanta;
+	else if (hw_quanta > uk_attrs->max_hw_srq_quanta)
 		return -EINVAL;
 
+	*srqdepth = hw_quanta;
 	return 0;
 }
 
-- 
2.53.0



