Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DD53E3C40;
	Tue, 31 Mar 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975185; cv=none; b=dhblCbrZ4SRf9cTwoFvegXjmVRaaQ2CgRTyAjggEcv4BuncrW5aRrM+/xDDTImuAKRt9hVlKRW4gFvsJ7FiMh7yEk+umYXsBUzpWGKBTu3wdvLom0ZWc8gUJUqnBe+jrXbGMtE5n+X4BWPE47NHSYu4/SbuQ4C5Jq9irWqrx7KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975185; c=relaxed/simple;
	bh=+UPPyOZqCu5ZvZ3cR14o+r7L7sDNbd6NqiN+7IvvY7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQ0ofjO/rx4f7dA5aAWX8QmDrVRnSTT4bP/M5Cd+Tmvu39NYrak8Np2pOSOXqZbyfaJ067Ug7PjMehfdewmXPd/+HHc4/j0KMXI2rlFAebGaBudHMXA0q41DLHX2uO9EUpNLhj/16Vu7LHHnzItO3l5k7XDYHbZzh+r+WvJD18k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ9ATgxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ9ATgxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF59C19423;
	Tue, 31 Mar 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975184;
	bh=+UPPyOZqCu5ZvZ3cR14o+r7L7sDNbd6NqiN+7IvvY7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ9ATgxa18Lr8npwiRFRmBHeBKH4FBOJUPJrWLxqoljMeqfcFNslFy2wxwD40t3Jb
	 wzZRIRrb1fk1Z087/w5TRcIFNvBls9NzbRgaEf65+EY145MOyxVWwkM3Nyk7FK7kiC
	 kuOBJV5CU1x+3XrHmRkIRR8Ar1cOrTfYaXffT7gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 163/342] RDMA/irdma: Harden depth calculation functions
Date: Tue, 31 Mar 2026 18:19:56 +0200
Message-ID: <20260331161805.010191324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index f0846b800913d..3d6d0ee57c4c1 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1442,7 +1442,7 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
  * irdma_round_up_wq - return round up qp wq depth
  * @wqdepth: wq depth in quanta to round up
  */
-static int irdma_round_up_wq(u32 wqdepth)
+static u64 irdma_round_up_wq(u64 wqdepth)
 {
 	int scount = 1;
 
@@ -1495,15 +1495,16 @@ void irdma_get_wqe_shift(struct irdma_uk_attrs *uk_attrs, u32 sge,
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
 
@@ -1517,15 +1518,16 @@ int irdma_get_sqdepth(struct irdma_uk_attrs *uk_attrs, u32 sq_size, u8 shift,
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
 
@@ -1539,13 +1541,16 @@ int irdma_get_rqdepth(struct irdma_uk_attrs *uk_attrs, u32 rq_size, u8 shift,
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



