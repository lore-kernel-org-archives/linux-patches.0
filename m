Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDF844DB64;
	Tue, 16 Jun 2026 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625889; cv=none; b=ptP2AG8iJQgzGrxck3iow+SLRinODO8rsHfqyGbmmrGJ1ktvCVZwmPwNPHNhoKUqIkCs4Uol+umJwAz34z1yNAxhZoeujacVqoOFEuHF0R+Lhy3KCm9nOaDIt8fqYtKCAwfx6W1Ep8cNfe7XFznAl/fgAyd3pdHAixZSpS+CKvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625889; c=relaxed/simple;
	bh=8jvyuvvBdN8kfWSQG2mUn5NAodIh6WQ6/4pqn75Ai8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0SqyJJMS2BMwtOEx36lnwj8gCw35Q86xR3rouBuUTOuQEGUU1bWqsdM7U5xY8KO3k/LJ1M4SrmbpphY4+/EGnDW+H5AgDuMPwcT+U5tqTh/YnEtFT83hE30Nl81qArsQKeBxo1QHo8/kvEbPjn3GI0KCegkaww8AZj8q2xWh+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nx1bTtWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nx1bTtWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209711F000E9;
	Tue, 16 Jun 2026 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625888;
	bh=ttM8uhy2BI3rzh4whiXnb8TN+Rwb7rNejeZJ7LjNFG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nx1bTtWaFV03cFdKFg338Svwi4v3CrparC2rzSu1HY7LZu+CTrhs5IF1iWx119wWE
	 nvNVW4ujSqEY1E62+epF29ze+xTyZtOmgYfJhREJADJQ4FJA/eWwnHPCT8ckazq8Do
	 ofeQAtDK5P5oCKeKGsD7VgFbq68SSd90b3mQdzyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Lord <mlord@pobox.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.18 227/325] iommu/dma: Do not try to iommu_map a 0 length region in swiotlb
Date: Tue, 16 Jun 2026 20:30:23 +0530
Message-ID: <20260616145109.692185376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

commit 6ec91df8aff77e2e8fe3179c1f3fc15b43a40ba3 upstream.

iommu_dma_iova_link_swiotlb() processes a mapping that is unaligned in three
parts, the head, middle and trailer. If the middle is empty because there
are no aligned pages it will call down to iommu_map() with a 0 size
which the iommupt implementation will fail as illegal.

It then tries to do an error unwind and starts from the wrong spot
corrupting the mapping so the eventual destruction triggers a WARN_ON.

Check for 0 length and avoid mapping and use offset not 0 as the starting
point to unlink.

This is frequently triggered by using some kinds of thunderbolt NVMe
drives that trigger forced SWIOTLB for unaligned memory. NVMe seems to
pass in oddly aligned buffers for the passthrough commands from smartctl
that hit this condition.

Cc: stable@vger.kernel.org
Fixes: 433a76207dcf ("dma-mapping: Implement link/unlink ranges API")
Reported-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dma-iommu.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1894,12 +1894,18 @@ static int iommu_dma_iova_link_swiotlb(s
 			return 0;
 	}
 
+	/*
+	 * After removing the partial head and tail, there may be no aligned
+	 * middle left to map.  The tail still gets bounced below.
+	 */
 	size -= iova_end_pad;
-	error = __dma_iova_link(dev, addr + mapped, phys + mapped, size, dir,
-			attrs);
-	if (error)
-		goto out_unmap;
-	mapped += size;
+	if (size) {
+		error = __dma_iova_link(dev, addr + mapped, phys + mapped,
+				size, dir, attrs);
+		if (error)
+			goto out_unmap;
+		mapped += size;
+	}
 
 	if (iova_end_pad) {
 		error = iommu_dma_iova_bounce_and_link(dev, addr + mapped,
@@ -1912,7 +1918,8 @@ static int iommu_dma_iova_link_swiotlb(s
 	return 0;
 
 out_unmap:
-	dma_iova_unlink(dev, state, 0, mapped, dir, attrs);
+	if (mapped)
+		dma_iova_unlink(dev, state, offset, mapped, dir, attrs);
 	return error;
 }
 


