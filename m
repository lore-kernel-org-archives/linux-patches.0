Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83447339A8;
	Mon, 12 May 2025 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072046; cv=none; b=WKdF57cctnSVAJDfdiRcT+ih3sSHd+8+mZCOXQ0ZrmFUIjiwwTIk9HB6nQueORP6aPi1kgrS62ZpsWalWcbowsw01d20HsPuqeViaPh3dNxTXNmAzJ2YNmSqf+UX/vl7+bkd8NgL9qflMMDwpRzaYWlKBcMS2yk1DiKx9CmmuqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072046; c=relaxed/simple;
	bh=nTQLZjA8G2Oxy2bXnyvFR5l7CPlGxouRt9uNOmsX8Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVb0u1rh6AJlY5qcGboaH4Wl/rRxhQBakBVe/9zz10gJ8ys5EUeE/3NrwaowKHfaexLwwpS5q23vtGtTyn/Hbqdj6uoWNY23PzvjHGlFXukC7mGz3jjH4TpZhWtmXZxJuOCOfEgjbp0MKXF9KMTvBVdgUvorYa+dDZWOlkAjgII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrfD5gD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrfD5gD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FB7C4CEE7;
	Mon, 12 May 2025 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072046;
	bh=nTQLZjA8G2Oxy2bXnyvFR5l7CPlGxouRt9uNOmsX8Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrfD5gD9m/vPIjujaX8xc2WTHFxDo5iyYxtMOHDDekoSQLzyUHMyt+Em5TrB33Z82
	 4vUCFN/HK0XMQt68O8N1XldDv17I0ZgkFASWX+KOS+i/E2arbBUFQ3hPh5QaPHW1ga
	 OhJlI+lwywJEO6Ts8qvwb0PEjSiCy77VmvO68jLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	stable@kernel.org
Subject: [PATCH 6.14 120/197] xen: swiotlb: Use swiotlb bouncing if kmalloc allocation demands it
Date: Mon, 12 May 2025 19:39:30 +0200
Message-ID: <20250512172049.272351856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


