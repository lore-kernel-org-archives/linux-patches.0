Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0894513F426;
	Wed, 19 Jun 2024 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802565; cv=none; b=dfuViznda1DNsd6SCnsJN+79+Zo2q3vGfcp9+C5vfz3JoNlkPh+mwsCsXKOSk9gHogLx24LC+B/NxlHOow8P9MMYM/cj93s8GRUEqSGjPn/t5xku8okfVJITbgMbi2vjWDO2madq5vHg0DETXxaOV17akbiOwpJIXEY63GTxSiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802565; c=relaxed/simple;
	bh=yYFHpKpSbVgPV9vWMOChv98i+8KqzbrEM2wIKE/MPyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgc+0IzcE06+/pbDk8XE9qDgaUfTz8OgVsyO65gJcMxPZgQXD57FvJ7mu06PiCNntbSaEAk0aSy+eScdje9h85fTwgxCLZTsIu743vbV3ZoAVXLjgmT5NskUmtVuJfRByvvftPByIs4L+KHAh8MmoqHxlJkU2VvPb0W/OHlA8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kL0jo1T/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kL0jo1T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82737C2BBFC;
	Wed, 19 Jun 2024 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802564;
	bh=yYFHpKpSbVgPV9vWMOChv98i+8KqzbrEM2wIKE/MPyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL0jo1T/LNP/vsI1C6oC8Fj/fRFtcB0p2lCqyGY3AaLQBatXlGhAlbVzJ5HpT75+R
	 2EPdazSkQ9cVX8TFge3FbBIvoYjXU6XnUR9jxN7FlCORuywB/iOKvmN7ViSwl+4Uah
	 qMAKj/M4QpkiPptnGDTkhB0Ij9/2rA3pvUjlPYZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Petr Tesarik <petr.tesarik1@huawei-partners.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Fabio Estevam <festevam@denx.de>
Subject: [PATCH 6.6 239/267] swiotlb: Reinstate page-alignment for mappings >= PAGE_SIZE
Date: Wed, 19 Jun 2024 14:56:30 +0200
Message-ID: <20240619125615.494983503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit 14cebf689a78e8a1c041138af221ef6eac6bc7da upstream.

For swiotlb allocations >= PAGE_SIZE, the slab search historically
adjusted the stride to avoid checking unaligned slots. This had the
side-effect of aligning large mapping requests to PAGE_SIZE, but that
was broken by 0eee5ae10256 ("swiotlb: fix slot alignment checks").

Since this alignment could be relied upon drivers, reinstate PAGE_SIZE
alignment for swiotlb mappings >= PAGE_SIZE.

Cc: stable@vger.kernel.org # v6.6+
Reported-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Petr Tesarik <petr.tesarik1@huawei-partners.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -993,6 +993,17 @@ static int swiotlb_area_find_slots(struc
 	BUG_ON(area_index >= pool->nareas);
 
 	/*
+	 * Historically, swiotlb allocations >= PAGE_SIZE were guaranteed to be
+	 * page-aligned in the absence of any other alignment requirements.
+	 * 'alloc_align_mask' was later introduced to specify the alignment
+	 * explicitly, however this is passed as zero for streaming mappings
+	 * and so we preserve the old behaviour there in case any drivers are
+	 * relying on it.
+	 */
+	if (!alloc_align_mask && !iotlb_align_mask && alloc_size >= PAGE_SIZE)
+		alloc_align_mask = PAGE_SIZE - 1;
+
+	/*
 	 * Ensure that the allocation is at least slot-aligned and update
 	 * 'iotlb_align_mask' to ignore bits that will be preserved when
 	 * offsetting into the allocation.
@@ -1006,13 +1017,6 @@ static int swiotlb_area_find_slots(struc
 	 */
 	stride = get_max_slots(max(alloc_align_mask, iotlb_align_mask));
 
-	/*
-	 * For allocations of PAGE_SIZE or larger only look for page aligned
-	 * allocations.
-	 */
-	if (alloc_size >= PAGE_SIZE)
-		stride = umax(stride, PAGE_SHIFT - IO_TLB_SHIFT + 1);
-
 	spin_lock_irqsave(&area->lock, flags);
 	if (unlikely(nslots > pool->area_nslabs - area->used))
 		goto not_found;


