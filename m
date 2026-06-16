Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916538837F;
	Tue, 16 Jun 2026 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624115; cv=none; b=EmoLykHCudVd7uTT05A7vvmTlilBvuo/D2+KGw3xK3llH53l0Yi3IP40iM3JEbRvJ1wcHFGDRHbimJ0TSANJKP+qdnrYgaT7ZyUNaumJT/pljTylRMoNf0UqrHL0hiRILcjYcL0mUgaAbElLjyEXCmTVKObW7vvPmGj9eLdX3pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624115; c=relaxed/simple;
	bh=QWKBrz7LtSasIw+aiaqCUmaUEjy3c5H8kzkQwe8/vUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJhnb9xjsxkRzjTfqWyy3Nwp6Rl45Ltz30f7tbulqfkpUFIe8eHBsm+5QigAtU84d84QsKvmMhaHRnVa211IKOPLfsAJRq7MqaVw8TIxAMXvEdOjnNT0In6LFeXg+9cDvIoDVGJbm8TBc+4j3uXN1bVelj3+Yh6oNvPGta7BIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zyUzV7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zyUzV7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12271F00AC4;
	Tue, 16 Jun 2026 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624114;
	bh=T7lSHEsKQUp/xKUG+6k8XcUxyR8q/iiWWl568ADM50Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zyUzV7mClcIuh1t8aVIOLJBHdLg1Xnfj2/H6JTTutl/T1WkSknNcaQj8ThaujLN8
	 LOOybetSOvGjSgDl5s7Xerea96J4PVEI20MnPzIXR9dIlI4q6jjexKuN+6dQNdT018
	 keBSOaHc07VkL5UvidS3mdzCcLojFyiNOpVX3wuk=
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
Subject: [PATCH 7.0 277/378] iommu/dma: Do not try to iommu_map a 0 length region in swiotlb
Date: Tue, 16 Jun 2026 20:28:28 +0530
Message-ID: <20260616145124.689470923@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1895,12 +1895,18 @@ static int iommu_dma_iova_link_swiotlb(s
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
@@ -1913,7 +1919,8 @@ static int iommu_dma_iova_link_swiotlb(s
 	return 0;
 
 out_unmap:
-	dma_iova_unlink(dev, state, 0, mapped, dir, attrs);
+	if (mapped)
+		dma_iova_unlink(dev, state, offset, mapped, dir, attrs);
 	return error;
 }
 


