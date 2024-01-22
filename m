Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F06168A;
	Tue, 23 Jan 2024 01:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974945; cv=none; b=cLJp/HcrI+BfIMT1IQveQhtGbmrb+vK8TUBmKWSkQFAFgf5C8ikAIBHpykfximCPE0Oky0ePN291qJAC8+xR0kwmpUJtRu85JDemPyICpsE6BNHJ/SGHtmR+Q3vBuYfWuVH5vgboA6uIb3/mSqZ77WkOBdGgP6iFV1vX9Ii2k4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974945; c=relaxed/simple;
	bh=KhPKd/iYAxDSmKMQ5WjXJ2CAtyvfRjqKcg95wFDKvSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL3UpaRiESyOLLzTpX67vhQKm/VPkBR0bL0oMmOo0kSOyp93VViEcZ1GPfF1hj28m92B4xdMPxfCHfzXWJPS29QMbJsGu9HhWygsABSCJ2NxXLS+zwZEP9sd2V9uge93g79hgTxKO/T9wUhhosRZLSAVkY2gsYzId7cA8RYnah4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkPnOi7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkPnOi7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7629EC433F1;
	Tue, 23 Jan 2024 01:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974945;
	bh=KhPKd/iYAxDSmKMQ5WjXJ2CAtyvfRjqKcg95wFDKvSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkPnOi7+tTE0pv8aexJ7aHRjZoghjk/MOqoOC29krQy0u/HBfFTiUM5Jml00Zmstc
	 kK/XI1acg2EXajSe5FYwO8UJYLqOEb36VVDZfox/rEaRbCBcZIGrhlbNw24MQ28Nt/
	 ahTxixI3eES7/tirwnjakR4kEMGptpFloZYzAymE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Murphy <murphyt7@tcd.ie>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Saravana Kannan <saravanak@google.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 290/374] iommu/dma: Trace bounce buffer usage when mapping buffers
Date: Mon, 22 Jan 2024 15:59:06 -0800
Message-ID: <20240122235754.865626150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit a63c357b9fd56ad5fe64616f5b22835252c6a76a upstream.

When commit 82612d66d51d ("iommu: Allow the dma-iommu api to
use bounce buffers") was introduced, it did not add the logic
for tracing the bounce buffer usage from iommu_dma_map_page().

All of the users of swiotlb_tbl_map_single() trace their bounce
buffer usage, except iommu_dma_map_page(). This makes it difficult
to track SWIOTLB usage from that function. Thus, trace bounce buffer
usage from iommu_dma_map_page().

Fixes: 82612d66d51d ("iommu: Allow the dma-iommu api to use bounce buffers")
Cc: stable@vger.kernel.org # v5.15+
Cc: Tom Murphy <murphyt7@tcd.ie>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20231208234141.2356157-1-isaacmanjarres@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dma-iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -25,6 +25,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/dma-direct.h>
+#include <trace/events/swiotlb.h>
 
 struct iommu_dma_msi_page {
 	struct list_head	list;
@@ -817,6 +818,8 @@ static dma_addr_t iommu_dma_map_page(str
 		void *padding_start;
 		size_t padding_size, aligned_size;
 
+		trace_swiotlb_bounced(dev, phys, size, swiotlb_force);
+
 		aligned_size = iova_align(iovad, size);
 		phys = swiotlb_tbl_map_single(dev, phys, size, aligned_size,
 					      iova_mask(iovad), dir, attrs);


