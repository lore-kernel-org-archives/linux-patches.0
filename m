Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607003DDDBD;
	Tue, 16 Jun 2026 19:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636852; cv=none; b=smEsg52L739JBrcv8GpSmZCyazM8gtiHHEkiWx9A+1lZfTvl/BfBA0VeY13Pe5fzK1FHGrsZHOtVZoxBGCGqJ9fPm+qPc7Z2lvRwzqX9hT6UpDU1Q+r91A3ygqy5A1wKAq78Gord66Zq8cehiEr/n+DDV/0aM77IYKNtbkNcdzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636852; c=relaxed/simple;
	bh=HP6ENdZrPYXkWOrLwqnXbEg5a/pzqk2RZiR8q40PPvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4XFICwsxajb8G52NgGFmPRRXsE2le7J9mc5Gw0+OUdpEFkWMqXfB1pDtUGPl3vb3WwbeHkrG8wF9hXTXr9vJnpM93PCIMBpdtNgejsCL6hoz69sqny3Sus8U7kRgoSL4IXJO9YCE6NKY3LLtVnU6H2e3OPEvppjVvnEIgKS5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmQhzydI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmQhzydI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C581F000E9;
	Tue, 16 Jun 2026 19:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636851;
	bh=kNl0Z4/FN6M9iUHiK+/4vhUBplLmMShaFw/ZE83fEeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmQhzydIyPdLXDxadaqHj/v5LdqeS9J/A1oGlk5Tma8QWukwNL1gc74y8g7l0ct/Y
	 EyjFGOtwsMvvtTY7AFfmgeTHoP09j2a0itzMqAn+cqdL2In9hMSOHSq8kEqppLAvgq
	 RykNJegj3QYmIJeERwH97Q3XjhatCewIuBohrnbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/342] RDMA/umem: Fix truncation for block sizes >= 4G
Date: Tue, 16 Jun 2026 20:30:12 +0530
Message-ID: <20260616145103.239896189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


