Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401C222A814;
	Mon,  2 Jun 2025 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875867; cv=none; b=G4DfA8KCMQ+IUi1A2Y4meyyY2yJ7jjc3Q5Kdv2z/tC/YadqnGq1blyw72xOm9k2lyVCN7lpeFejBMYD2kuaE1b2yy+TjOqz0+4jDwrZx6vhwonGb9+njirg+5BVLz5lmCfCG3mxyRyLxHEHiBkVKW0zVWpxHR4qipjgwguZDTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875867; c=relaxed/simple;
	bh=Jxiow02KoGX1/qBbPZN38c4c7a3iPLW2p0COstzJZWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmaXOmbvmy35rii7tDlPYugF6ESF6U5Q0I2Fh8WBUJN9dvfhYCeG94MN2Ggt7qsa3jOLg2GvUJBG5NAd6Ztz6ax2GFbiLg+t/Xl3nd3XAyorA/7gG3w/em1dSdT9NlS2hJizuvYnmxBtrk8bJ7f3bt2qObT1zDGttsiMo3Qp2MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhWhhwyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhWhhwyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C10C4CEEB;
	Mon,  2 Jun 2025 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875867;
	bh=Jxiow02KoGX1/qBbPZN38c4c7a3iPLW2p0COstzJZWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhWhhwyIz7GFEwXTb6XiWCA3VXNSjeRSHfRqynG2yJxuFeFtQSPoD0ctg/eMDOWzF
	 m8X06+vS70KSSB1VTNi+nrVEZ2WetMusGxIk8tE+AdBqsEqC2TgidV5aK2TyqsTP43
	 IQ8601OpZBVWoSEYcQuVPiciGhWwpy3Lv0WI66bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Vejvalka <jan.vejvalka@lfmotol.cuni.cz>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.10 269/270] xen/swiotlb: relax alignment requirements
Date: Mon,  2 Jun 2025 15:49:14 +0200
Message-ID: <20250602134318.332879880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 85fcb57c983f423180ba6ec5d0034242da05cc54 upstream.

When mapping a buffer for DMA via .map_page or .map_sg DMA operations,
there is no need to check the machine frames to be aligned according
to the mapped areas size. All what is needed in these cases is that the
buffer is contiguous at machine level.

So carve out the alignment check from range_straddles_page_boundary()
and move it to a helper called by xen_swiotlb_alloc_coherent() and
xen_swiotlb_free_coherent() directly.

Fixes: 9f40ec84a797 ("xen/swiotlb: add alignment check for dma buffers")
Reported-by: Jan Vejvalka <jan.vejvalka@lfmotol.cuni.cz>
Tested-by: Jan Vejvalka <jan.vejvalka@lfmotol.cuni.cz>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/swiotlb-xen.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -87,19 +87,21 @@ static inline dma_addr_t xen_virt_to_bus
 	return xen_phys_to_dma(dev, virt_to_phys(address));
 }
 
+static inline bool range_requires_alignment(phys_addr_t p, size_t size)
+{
+	phys_addr_t algn = 1ULL << (get_order(size) + PAGE_SHIFT);
+	phys_addr_t bus_addr = pfn_to_bfn(XEN_PFN_DOWN(p)) << XEN_PAGE_SHIFT;
+
+	return IS_ALIGNED(p, algn) && !IS_ALIGNED(bus_addr, algn);
+}
+
 static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
 {
 	unsigned long next_bfn, xen_pfn = XEN_PFN_DOWN(p);
 	unsigned int i, nr_pages = XEN_PFN_UP(xen_offset_in_page(p) + size);
-	phys_addr_t algn = 1ULL << (get_order(size) + PAGE_SHIFT);
 
 	next_bfn = pfn_to_bfn(xen_pfn);
 
-	/* If buffer is physically aligned, ensure DMA alignment. */
-	if (IS_ALIGNED(p, algn) &&
-	    !IS_ALIGNED((phys_addr_t)next_bfn << XEN_PAGE_SHIFT, algn))
-		return 1;
-
 	for (i = 1; i < nr_pages; i++)
 		if (pfn_to_bfn(++xen_pfn) != ++next_bfn)
 			return 1;
@@ -321,7 +323,8 @@ xen_swiotlb_alloc_coherent(struct device
 	phys = dma_to_phys(hwdev, *dma_handle);
 	dev_addr = xen_phys_to_dma(hwdev, phys);
 	if (((dev_addr + size - 1 <= dma_mask)) &&
-	    !range_straddles_page_boundary(phys, size))
+	    !range_straddles_page_boundary(phys, size) &&
+	    !range_requires_alignment(phys, size))
 		*dma_handle = dev_addr;
 	else {
 		if (xen_create_contiguous_region(phys, order,
@@ -362,6 +365,7 @@ xen_swiotlb_free_coherent(struct device
 
 	if (!WARN_ON((dev_addr + size - 1 > dma_mask) ||
 		     range_straddles_page_boundary(phys, size)) &&
+	    !range_requires_alignment(phys, size) &&
 	    TestClearPageXenRemapped(page))
 		xen_destroy_contiguous_region(phys, order);
 


