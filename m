Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89004502F;
	Tue, 16 Jun 2026 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627871; cv=none; b=OrDnDjE/RkD4WUpc//7e3K2EuCI3xJQU7n8/sQfzSJuM4KQ5dyYFaFicn7JaMs/QrGln4tCHVqLZZTHluLqxl5rxamTTvOi1F4RFQvrn9/WLgiaiT8HbiUjSf64WNB88tZliTveTvyebwhA/3F7zou8jTJlEyLvwlcqZtWlXxHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627871; c=relaxed/simple;
	bh=ivTdGJEkretD+fOzP3lIrlbmgHK2y9n50Za71w0F3J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNPc2690t9+obY/ZJmEgZzVSKq0mII3sCJ/fZ5HDK1d8lpnhxLhpShroEVN42LlhRcnpAxOYdXfrqrVLwz0P0gseyoSdqzL1zLnuy/lXR7oMI0MZ9xnY6N5WBu24c/xjkMTCmoM1C/ORWrhR4PjwRjPVD0t9uttgyuSX30ToWeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIeNgVyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIeNgVyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21831F000E9;
	Tue, 16 Jun 2026 16:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627870;
	bh=+MWQ+YgIrhn/qmvJpXWX6aenmdK82rJaM+iW1jHbvlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIeNgVyb/d8dIFzoSSv3mJEBEje3ByTreDsBywSXVsUklmoUR2SeDFL05LNsfOxmP
	 SjS28OHEPOxAvWqJYMV/QpIdOEvGXVW581JiARyKUtIjow7CxMUVt9kPKlpw+tdtTg
	 Cv9hDA6/ff38KxY4cG1GcbvM+tZ9hhsckPZT5rN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/261] RDMA/umem: Fix truncation for block sizes >= 4G
Date: Tue, 16 Jun 2026 20:31:20 +0530
Message-ID: <20260616145056.295341016@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


