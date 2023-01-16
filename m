Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4696733EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE170C433D2;
	Mon, 16 Jan 2023 15:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884639;
	bh=rLuGTVHTJIk3M2IlQc0GL/2gpd1ktQ6uLCeAUWqKeGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxtJKD8GtmKhyXbLiPN5JUKoY/lSPCtbYqkUKv/p3JysSGGA5OhSd/E6BojDhbz6j
	 WCFQsbp/yVkJIlef3cmA1WXyLt3Skqpjy1GPYPeeFcnJVhv4PBymuIxYRm3eM/wPOD
	 q8iWOIfUbA8ge6TJSeC8Id205PsrqD9WbEdSCbLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jianjiao zeng <jianjiao.zeng@mediatek.com>,
	Yunfei Wang <yf.wang@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 083/183] iommu/iova: Fix alloc iova overflows issue
Date: Mon, 16 Jan 2023 16:50:06 +0100
Message-Id: <20230116154806.949144694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunfei Wang <yf.wang@mediatek.com>

commit dcdb3ba7e2a8caae7bfefd603bc22fd0ce9a389c upstream.

In __alloc_and_insert_iova_range, there is an issue that retry_pfn
overflows. The value of iovad->anchor.pfn_hi is ~0UL, then when
iovad->cached_node is iovad->anchor, curr_iova->pfn_hi + 1 will
overflow. As a result, if the retry logic is executed, low_pfn is
updated to 0, and then new_pfn < low_pfn returns false to make the
allocation successful.

This issue occurs in the following two situations:
1. The first iova size exceeds the domain size. When initializing
iova domain, iovad->cached_node is assigned as iovad->anchor. For
example, the iova domain size is 10M, start_pfn is 0x1_F000_0000,
and the iova size allocated for the first time is 11M. The
following is the log information, new->pfn_lo is smaller than
iovad->cached_node.

Example log as follows:
[  223.798112][T1705487] sh: [name:iova&]__alloc_and_insert_iova_range
start_pfn:0x1f0000,retry_pfn:0x0,size:0xb00,limit_pfn:0x1f0a00
[  223.799590][T1705487] sh: [name:iova&]__alloc_and_insert_iova_range
success start_pfn:0x1f0000,new->pfn_lo:0x1efe00,new->pfn_hi:0x1f08ff

2. The node with the largest iova->pfn_lo value in the iova domain
is deleted, iovad->cached_node will be updated to iovad->anchor,
and then the alloc iova size exceeds the maximum iova size that can
be allocated in the domain.

After judging that retry_pfn is less than limit_pfn, call retry_pfn+1
to fix the overflow issue.

Signed-off-by: jianjiao zeng <jianjiao.zeng@mediatek.com>
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.15.*
Fixes: 4e89dce72521 ("iommu/iova: Retry from last rb tree node if iova search fails")
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20230111063801.25107-1-yf.wang@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iova.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -197,7 +197,7 @@ static int __alloc_and_insert_iova_range
 
 	curr = __get_cached_rbnode(iovad, limit_pfn);
 	curr_iova = to_iova(curr);
-	retry_pfn = curr_iova->pfn_hi + 1;
+	retry_pfn = curr_iova->pfn_hi;
 
 retry:
 	do {
@@ -211,7 +211,7 @@ retry:
 	if (high_pfn < size || new_pfn < low_pfn) {
 		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
 			high_pfn = limit_pfn;
-			low_pfn = retry_pfn;
+			low_pfn = retry_pfn + 1;
 			curr = iova_find_limit(iovad, limit_pfn);
 			curr_iova = to_iova(curr);
 			goto retry;


