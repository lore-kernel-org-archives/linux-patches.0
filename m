Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B2347A0C4;
	Tue, 16 Jun 2026 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630246; cv=none; b=QG5TGyj8MpTILWTzPo/MKE4czusyX4GmaFt1y3b6Y4Gu4mT6SnCO+PmINOBOartO3xHk0HNKJA6Shk3LkgKx5/4eSyNqSFcrID2ZxEMHBDNA06KASeWcJPKWhrkdKwpJi1g//M+nZbZ/8hThgMWw143UF2X2tj8zgpdrG6oSZbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630246; c=relaxed/simple;
	bh=kyY0XvP/320Rig/TXFYNFzljbu4wP2VhTWuxvRY3aXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9dXZhN066x4cmVV91kRKZFjbZdrH3h3DCH2yujDQcwW8YA1hpYwC5Gfv63bRt7RaNb5vcG/l3px9sKYsg9LKCVj0AlRkJCkompeiBiZEWTsHANJHg7j7E0NjVw/RT+xKj/TKpwOLP+BCrsj2Ji5WOceyqkKkYaNoE15JbnG7pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+xBIOJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+xBIOJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1231F00A3A;
	Tue, 16 Jun 2026 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630243;
	bh=Mz9zGDjMGJm6fjMaQdv8J+j7fDvGS1b2WREIFCaWHrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+xBIOJ9Ilbn3zcuObn913dpShcCl6SKyjMBKpx/MoTHfpe1ycRo5PFn6QP9tGUGH
	 ihpk2DXiqz9rZA6HSbXbanSsGxb16sUosv5ws2Udg5WcSuneHL7plRORwZ0TgKXGKp
	 PvBcVPRee0Ql8X/kX6GJ69HvVHi/XJOrtHdXLjf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 437/452] RDMA/umem: Fix truncation for block sizes >= 4G
Date: Tue, 16 Jun 2026 20:31:04 +0530
Message-ID: <20260616145139.568314810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


