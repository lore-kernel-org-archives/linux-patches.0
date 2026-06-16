Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03443C5842;
	Tue, 16 Jun 2026 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632848; cv=none; b=k1QWQ4dWp6Nfh1ByojKX3+VCgZhhgclcD2HsmmA9pmBc6EQsJ+vNHq8NdzCDFQ9m/1HfWliGlbtWVSb7eJ39ICwIWgBDn8tus12RvO5rCIcAgC1MA+mfsjy/KsVExGxqxQhPD2l44QnUbdZ/Lp3OCJe6ZW/nAvsCwBAvA8IlKE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632848; c=relaxed/simple;
	bh=4B/YHNaRmM1OqJc93PHRQ4IOEvbBzT0wrcgFfSPvCEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAkZFr7j5Ebd3BGejORurhJomc6EgloKoyMubZltsdwfCXf84ejTk5d9W28lstjbEAV5OJgVbg4UCeGLg9Gx5wYkM5jOeblg3OqPQOqu8E8fwqDdQunG9fT6TfTld7eIgFodoUhlYxXlnDW3/q6T1UIS8vXlkC/WLzvWoJt78tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G30sRV7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G30sRV7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712251F000E9;
	Tue, 16 Jun 2026 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632847;
	bh=zV+fn4ST9b0m/KC5H6q6H0Zvtaip9T5Lw2mfy0z4ik0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G30sRV7X3Ns0qGVYjJwSS/eDgbwt4zRykns440vnpF9W7IRDov8/nFrmzWKolKB6y
	 tA8iH24WTQJxPK7Ftok91RbPLyQnrOkpQk4jrvZjy+ogqnHXE+T8z7/391T3V1Gfut
	 +/+wP4gI4VUfOiyKqKNPC/lJFLulC9VD/ArpMpZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 489/522] RDMA/umem: Fix truncation for block sizes >= 4G
Date: Tue, 16 Jun 2026 20:30:36 +0530
Message-ID: <20260616145148.683548449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


