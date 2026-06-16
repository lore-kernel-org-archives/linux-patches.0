Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE544DB62;
	Tue, 16 Jun 2026 15:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624626; cv=none; b=sfs/FFhRpduneAGjG2HO0nZ2FaY1/phemPIXhUvYSjmGlcCLKSUHWeAWnLUR5yVPohXxlW6pD7Eyd/uxypPZf9ULvdgkEZQMBNC1TvfrFqZ3MedqD6PWi2StV+lnaf9JJN/gbpGOo4iIksg8KUvm4qRJqkP4geS6URJK3dj0r9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624626; c=relaxed/simple;
	bh=ylnzMSefxWO6B6wA2RrXhkD5TV+wDKw/KfWT7Jjhiuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6Yw/6Kwq2L63FVjXsuJQQ4HVWCf2gPEVnzuEqVRBbVt9G7S0Tzl39EalJlayJ7JHL2ZVNZy8TWwdNM054u2wEYfcVo5NWlX0DCfTYMeP75xnkMxSwbc9vIOvEass5eWxb3SA8eq4KAVmeSlaghDulNS4ABWnR+T6umSCLnjZOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLbEBb/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLbEBb/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF6A1F000E9;
	Tue, 16 Jun 2026 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624625;
	bh=8CFrqu7XhWVcTAc8c1vaB3/8G1pK0Eagl0f50u+jVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLbEBb/SkvIw1ifj7CoaHoyDDxzaS8uRlugzrgXpfhrhk2weIwoRK8pemR8gEeF72
	 pLAnQZt9T5BW9bDCvuHRDY14jSR4o5+N+hqTSLt45CbJgXjv9kY4L7HTWguxfggFJd
	 XfNqOBYQC9hPFJJ/4wElmU0F4/iyKwJjXu8wrv8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 369/378] RDMA/umem: Fix truncation for block sizes >= 4G
Date: Tue, 16 Jun 2026 20:30:00 +0530
Message-ID: <20260616145129.542898034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 15fe76e23615f502d051ef0768f86babaf08746c ]

When the iommu is used the linearization of the mapping can give a single
block that is very large split across multiple SG entries.

When __rdma_block_iter_next() reassembles the split SG entries it is
overflowing the 32 bit stack values and computed the wrong DMA addresses
for blocks after the truncation.

Use the right types to hold DMA addresses.

Link: https://patch.msgid.link/r/1-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: a808273a495c ("RDMA/verbs: Add a DMA iterator to return aligned contiguous memory blocks")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/iter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/iter.c
+++ b/drivers/infiniband/core/iter.c
@@ -19,8 +19,8 @@ EXPORT_SYMBOL(__rdma_block_iter_start);
 
 bool __rdma_block_iter_next(struct ib_block_iter *biter)
 {
-	unsigned int block_offset;
-	unsigned int delta;
+	dma_addr_t block_offset;
+	dma_addr_t delta;
 
 	if (!biter->__sg_nents || !biter->__sg)
 		return false;


