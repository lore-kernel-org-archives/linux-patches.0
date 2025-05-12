Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3384140E34;
	Mon, 12 May 2025 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072938; cv=none; b=LtQs5t/vRzBAPp5o+xNdaZZu7DGUi4ejjOGTofvSGnv6gkG7QIYscqjPxHOMsf6BwYWoWgJRQaNaDXz2MtY+uiMxJX8RToe6kiP70+HrSsJN/UKDwZ2/ro3WFJdNnNTbhF2WYHzrDWdOhs1ZyeSbG80rtFUekrTkyxF/4my4Ijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072938; c=relaxed/simple;
	bh=zy5VoowhCcaoGHttALmh7DPd1MtUJqPfuxcq1h2/10Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e23hMXxuPDA/I79deA51Y7hTqRtR9DZ3EAUR0IyCe8Kzi69/IfvRHNKU5k5GUtsrtljRHdjaSnZB4bUfN6XTYT//9mgWy74tLPY4ve6OfYUL7LsttmLypXr5NejdNPgnngk8Tt+u82eRXVrIfbdNBjFA8Bty9s43MmBxpG3h6n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gYVl/2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gYVl/2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9E7C4CEE7;
	Mon, 12 May 2025 18:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072938;
	bh=zy5VoowhCcaoGHttALmh7DPd1MtUJqPfuxcq1h2/10Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gYVl/2LJ3qZqEMxX+WK33e/vNQ72Z37X0Wz5O9x0y6u4A9EH0wwp3zfcfMbNgYTC
	 EGW95xMk3nCsCyLAeA6SGUEQOOAdzcKO4W9kBNZmvf2CeAoJObFyfiWQ43T8sc58dS
	 fnBvJUl71uMNRsqr19ea69hD26IDriHaxMVMSXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	stable@kernel.org
Subject: [PATCH 6.12 104/184] xen: swiotlb: Use swiotlb bouncing if kmalloc allocation demands it
Date: Mon, 12 May 2025 19:45:05 +0200
Message-ID: <20250512172046.055681837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ernberg <john.ernberg@actia.se>

commit cd9c058489053e172a6654cad82ee936d1b09fab upstream.

Xen swiotlb support was missed when the patch set starting with
4ab5f8ec7d71 ("mm/slab: decouple ARCH_KMALLOC_MINALIGN from
ARCH_DMA_MINALIGN") was merged.

When running Xen on iMX8QXP, a SoC without IOMMU, the effect was that USB
transfers ended up corrupted when there was more than one URB inflight at
the same time.

Add a call to dma_kmalloc_needs_bounce() to make sure that allocations too
small for DMA get bounced via swiotlb.

Closes: https://lore.kernel.org/linux-usb/ab2776f0-b838-4cf6-a12a-c208eb6aad59@actia.se/
Fixes: 4ab5f8ec7d71 ("mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN")
Cc: stable@kernel.org # v6.5+
Signed-off-by: John Ernberg <john.ernberg@actia.se>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250502114043.1968976-2-john.ernberg@actia.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/swiotlb-xen.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -217,6 +217,7 @@ static dma_addr_t xen_swiotlb_map_page(s
 	 * buffering it.
 	 */
 	if (dma_capable(dev, dev_addr, size, true) &&
+	    !dma_kmalloc_needs_bounce(dev, size, dir) &&
 	    !range_straddles_page_boundary(phys, size) &&
 		!xen_arch_need_swiotlb(dev, phys, dev_addr) &&
 		!is_swiotlb_force_bounce(dev))


