Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00211DDDB
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFFAC433C7;
	Fri, 21 Jul 2023 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955738;
	bh=IDnESwUJm/lDI2qWCyoVhjPxoKFgbhbGilgHOUjkqRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klaWKorXutPlGWi5AGvPIkPFgdZuvsaU6jwdahtKQusE2fbmFiaRpugP+zUAWeIVY
	 HlgUI5jX0mCCohuv8X5EY019CBy7p4l9pjGfbwS+Cl8VXNjguH825dLAGZslREYVRR
	 zx+F9H7L5YjdTNoq9swlDn9Gwo6KeeANz033643k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 013/292] swiotlb: always set the number of areas before allocating the pool
Date: Fri, 21 Jul 2023 18:02:02 +0200
Message-ID: <20230721160529.382327747@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Tesarik <petr.tesarik.ext@huawei.com>

[ Upstream commit aabd12609f91155f26584508b01f548215cc3c0c ]

The number of areas defaults to the number of possible CPUs. However, the
total number of slots may have to be increased after adjusting the number
of areas. Consequently, the number of areas must be determined before
allocating the memory pool. This is even explained with a comment in
swiotlb_init_remap(), but swiotlb_init_late() adjusts the number of areas
after slots are already allocated. The areas may end up being smaller than
IO_TLB_SEGSIZE, which breaks per-area locking.

While fixing swiotlb_init_late(), move all relevant comments before the
definition of swiotlb_adjust_nareas() and convert them to kernel-doc.

Fixes: 20347fca71a3 ("swiotlb: split up the global swiotlb lock")
Signed-off-by: Petr Tesarik <petr.tesarik.ext@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index af2e304c672c4..16f53d8c51bcf 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -115,9 +115,16 @@ static bool round_up_default_nslabs(void)
 	return true;
 }
 
+/**
+ * swiotlb_adjust_nareas() - adjust the number of areas and slots
+ * @nareas:	Desired number of areas. Zero is treated as 1.
+ *
+ * Adjust the default number of areas in a memory pool.
+ * The default size of the memory pool may also change to meet minimum area
+ * size requirements.
+ */
 static void swiotlb_adjust_nareas(unsigned int nareas)
 {
-	/* use a single area when non is specified */
 	if (!nareas)
 		nareas = 1;
 	else if (!is_power_of_2(nareas))
@@ -298,10 +305,6 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	if (swiotlb_force_disable)
 		return;
 
-	/*
-	 * default_nslabs maybe changed when adjust area number.
-	 * So allocate bounce buffer after adjusting area number.
-	 */
 	if (!default_nareas)
 		swiotlb_adjust_nareas(num_possible_cpus());
 
@@ -363,6 +366,9 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 	if (swiotlb_force_disable)
 		return 0;
 
+	if (!default_nareas)
+		swiotlb_adjust_nareas(num_possible_cpus());
+
 retry:
 	order = get_order(nslabs << IO_TLB_SHIFT);
 	nslabs = SLABS_PER_PAGE << order;
@@ -397,9 +403,6 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 			(PAGE_SIZE << order) >> 20);
 	}
 
-	if (!default_nareas)
-		swiotlb_adjust_nareas(num_possible_cpus());
-
 	area_order = get_order(array_size(sizeof(*mem->areas),
 		default_nareas));
 	mem->areas = (struct io_tlb_area *)
-- 
2.39.2



