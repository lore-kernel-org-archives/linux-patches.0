Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C866296147;
	Mon, 12 May 2025 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073385; cv=none; b=UqVJ8Tia2FUYD71e7IFCgdsLeqfbQgg0OQBlPkvBEq1o9wy3fi2Gpz/MNBzH/xy/1+gve1ya3gMNOxjEVuHlXX58J5pLMwGiRWQOj/5Vo7l8D3w3jGXAFoclR1oa8lQdme50Y2e4Nn25lABdCiToI3c3S9kEkn3clm9vUXd1NHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073385; c=relaxed/simple;
	bh=tNs8H26QVdT693Dp3XHQaL9pJVqnmX2HfvgwD8PoDKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq5ka7ou10RDDV8f6thaJfaOvnXH+9CRr43PTYAqED0+TFApWAsWZGI8dqjc7xnvgxwj5PBtmjeNYLxAOjkDBzAgp0Ql9UBHsPLg6ad9QdH/U9wmJ7QMrKsDpgBeLEpTDvAqNniU2m2vAb1y4jYFbO95bG1bxZATE+ISfaXHmEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JVawoQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JVawoQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254ABC4CEE7;
	Mon, 12 May 2025 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073385;
	bh=tNs8H26QVdT693Dp3XHQaL9pJVqnmX2HfvgwD8PoDKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JVawoQcs2m7YIqhhQ2lTUB0rCWRS3ofxQ3eqhvg8Oly66DZ6NDJgmm1gZl5sB79O
	 dHl1VIVU/EbUGXyCefY+fql3099QYfgKpKyCMoUstFKJ6KfDK3xL4hrCUymb7POl0n
	 n9TTjM4Bv3uf1LGDdYuvgSocvhGhhgFDK6SD8V/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	stable@kernel.org
Subject: [PATCH 6.6 059/113] xen: swiotlb: Use swiotlb bouncing if kmalloc allocation demands it
Date: Mon, 12 May 2025 19:45:48 +0200
Message-ID: <20250512172030.081554873@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,6 +216,7 @@ static dma_addr_t xen_swiotlb_map_page(s
 	 * buffering it.
 	 */
 	if (dma_capable(dev, dev_addr, size, true) &&
+	    !dma_kmalloc_needs_bounce(dev, size, dir) &&
 	    !range_straddles_page_boundary(phys, size) &&
 		!xen_arch_need_swiotlb(dev, phys, dev_addr) &&
 		!is_swiotlb_force_bounce(dev))


