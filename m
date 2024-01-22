Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C83D745D6;
	Tue, 23 Jan 2024 02:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975475; cv=none; b=OxHZsZZNs1IlDDoL5Dzbo7NoEdT4tjBk6zduGAyOT460SLjOcFZYfpUIf0pHo8msJUFojKcRP5KlcasLEH1tHa9cT8zbCYroQLonk2TOH0tnXnpzbIZ5fhK8/C1Rl17JbILme6pb1oLD6Q0jV8YnPBs73lh8ZQxwJ9EQvc6aPgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975475; c=relaxed/simple;
	bh=+GqPlwj2KbaimJ/xHrLkb405N9p1GKNICmbTgAYMp6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxGNlMRRz+nSl11waB12Frq/48Z3mtsmqeJnC8+O+vSK4SMGu68sURUCUnMA4gbpmdMC3bYITqDCeZYSoelG2yqqOu4T5cCzqWKsKZG7Fkj8clEbu3EOiTWOsTrmchc5kpB5k+cwnVGhgg+cAKDHBOxVEMCeIy+A8X15kFNnRW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTesbHAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTesbHAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F793C43390;
	Tue, 23 Jan 2024 02:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975475;
	bh=+GqPlwj2KbaimJ/xHrLkb405N9p1GKNICmbTgAYMp6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTesbHALp9eqb1z/Ze0whFE28ku0H62GkKIvFiAUOuubFA1hcHpsiypnEx3DmOlsT
	 PGmUlKSSX8fYjNSRXwI8tjOgPHWJmJ9kyTbD3jD7g7YF55A3SFaijuGInVJZQoZBMo
	 lZluNG5WvcKAjhiOXofr4cGIzivjH5P/CpCp78wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Murphy <murphyt7@tcd.ie>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Saravana Kannan <saravanak@google.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 412/583] iommu/dma: Trace bounce buffer usage when mapping buffers
Date: Mon, 22 Jan 2024 15:57:43 -0800
Message-ID: <20240122235824.578784319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
 #include <linux/vmalloc.h>
+#include <trace/events/swiotlb.h>
 
 #include "dma-iommu.h"
 
@@ -1052,6 +1053,8 @@ static dma_addr_t iommu_dma_map_page(str
 			return DMA_MAPPING_ERROR;
 		}
 
+		trace_swiotlb_bounced(dev, phys, size);
+
 		aligned_size = iova_align(iovad, size);
 		phys = swiotlb_tbl_map_single(dev, phys, size, aligned_size,
 					      iova_mask(iovad), dir, attrs);


