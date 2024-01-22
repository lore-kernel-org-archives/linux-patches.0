Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D1C12DDB0;
	Tue, 23 Jan 2024 01:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971723; cv=none; b=TjGUCj1NU3PKF6DRXSNkvvvpotvwKeXNk1s8P4I46ovkf3MOdchucA/5hk7ZORI0xgDrBiGjGEPP4j5tZaZTKPSvdySlj4CG8Vqv3knfUCtOl3VVSXocGh9TiTfjOjOj2aqSl06D40fl8qWFQpNOzVw3z0b/MyoYuW8CKJMcElg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971723; c=relaxed/simple;
	bh=UZFkgmRUCU42uplYt0tP1JGM/YSIwi7bZAaVviB0m8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaAg+njWicnCSsBawWs2Q+U/qJvJdVc77QXhReQvjSwSe+16Twx8YdH69nXGqyQeC8hkjRRwX7t6T1xk5U50tSfkJp6eqNa+13HyXBfpkySQtRtCXQUB8aGDmZ+moUL/zm5Y3aScd9PJegt9HUFKeQJpbZvjbGMmiFEodutP/rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWUm2rMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWUm2rMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE08C433C7;
	Tue, 23 Jan 2024 01:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971723;
	bh=UZFkgmRUCU42uplYt0tP1JGM/YSIwi7bZAaVviB0m8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWUm2rMXlbhusa/pJXABnPNuo0ngswLuDMWCHLvtQRGM9h8bpuXWduKJf5MBqEmkM
	 BD7y8xMIgDv4pA56mrnWOsmWBPM/txOH8DtYV8Zg/pRsn6VVEbM3c4AwNFkS/4na2+
	 OzLzf61F9bpMcqB0VvJyo4Oiwt3zB+vRCbqwo8S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Murphy <murphyt7@tcd.ie>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Saravana Kannan <saravanak@google.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 306/417] iommu/dma: Trace bounce buffer usage when mapping buffers
Date: Mon, 22 Jan 2024 15:57:54 -0800
Message-ID: <20240122235802.425334565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dma-iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -28,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
 #include <linux/vmalloc.h>
+#include <trace/events/swiotlb.h>
 
 #include "dma-iommu.h"
 
@@ -999,6 +1000,8 @@ static dma_addr_t iommu_dma_map_page(str
 			return DMA_MAPPING_ERROR;
 		}
 
+		trace_swiotlb_bounced(dev, phys, size);
+
 		aligned_size = iova_align(iovad, size);
 		phys = swiotlb_tbl_map_single(dev, phys, size, aligned_size,
 					      iova_mask(iovad), dir, attrs);


