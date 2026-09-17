Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11CB4FC332;
	Thu, 17 Sep 2026 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664387; cv=none; b=CllTJacbBDcNUjvLxG8Bu9z1HxyQmntOmhQAy1xnarp5T0zeE8j900xltbfHke0jzeSRTZGz8DRdDLDeXdwwQUfi0gE0lFsEB00wiMYrhxjQJCJUnHWgyb8QpYDpaHeM8ZGWT3qRbcFZPa2U7yT09uIp7u+zlaf2Fcwd0QMQIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664387; c=relaxed/simple;
	bh=4Y8O5/yicaFJf6xtatKSQgg1WCkNz/fLDv1ajHSPtlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szYD9EopYSvGD0LxZq/pUsRuDY1Y4RV7jYAM3HMjc3eRnIikLsQc1vmDzb7QEwHONYqfCKlIl2eieybloy92iRN++VwqNT0daU5ZLNhBbtx4EkdISD33W8p7wG8UxQMOZ/lXof9fhLxy/Ka9ysHidItLmQhVLPjPOKjJjAYqIgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpPzsJX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpPzsJX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F163C1F000FF;
	Thu, 17 Sep 2026 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664386;
	bh=0rrJ7gd2G76ziSy6iPNjh5fqwcu03e/aTbAs65vKWus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpPzsJX9jwl+ZNCv7C9IApOOKS0tpF2/cOPgv5KjQA0iIOzM6oQ8jMznmCCEbFvEr
	 UER2gAAegnc+vMuyHthQ52fnKTHQlN7nw50PpjWzT5jn2/6ZQPlUIEnUpko3993Pd9
	 gosfQ1k1TSfxkL8jvI1z5/ZN22FavgX56cvkL/U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0339/1250] RDMA/umem: Make ib_umem_is_contiguous() safe on 32 bit
Date: Thu, 17 Sep 2026 16:02:14 +0100
Message-ID: <20260917151601.271490279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 55d984dae65262fbb0a673cff7cc9824a5e19bdb ]

Sashiko points out the roundup_pow_of_two() only uses unsigned long but
dma_addr_t can be u64.

Change this algorithm to be simpler, compute the page size, if any page
size is found and it results in a single block then it is contiguous.

Link: https://patch.msgid.link/r/3-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_umem.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 0cda3e6425d2e..8a74153332577 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -121,16 +121,11 @@ static inline unsigned long ib_umem_find_best_pgoff(struct ib_umem *umem,
 
 static inline bool ib_umem_is_contiguous(struct ib_umem *umem)
 {
-	dma_addr_t dma_addr;
 	unsigned long pgsz;
 
-	/*
-	 * Select the smallest aligned page that can contain the whole umem if
-	 * it was contiguous.
-	 */
-	dma_addr = ib_umem_start_dma_addr(umem);
-	pgsz = roundup_pow_of_two((dma_addr ^ (umem->length - 1 + dma_addr)) + 1);
-	return !!ib_umem_find_best_pgoff(umem, pgsz, U64_MAX);
+	pgsz = ib_umem_find_best_pgsz(umem, ULONG_MAX,
+				      ib_umem_start_dma_addr(umem));
+	return pgsz && ib_umem_num_dma_blocks(umem, pgsz) == 1;
 }
 
 struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
-- 
2.53.0



