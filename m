Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E61BD9DE;
	Wed, 19 Feb 2025 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955486; cv=none; b=I+0qWefzS9ZXKkfEzHrGo/gOg586modmXstzj0jPibw7Q7sOtgZWG3+aLBgtHIXMj7SIniRQX5w7HC12hbH6row3Z0A3xKB0PQOyxcjZQzcYSFiCz9fNL8L+n+GAYGt6m3YV/4+z/CJ0MUyNgdh1epHsySYfKFWEYwmHVnCe8iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955486; c=relaxed/simple;
	bh=9i6s23YXfV4AQRcn/GUoqSzpPuXlMNgF8wuJ9HPrO9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ocnf9m3VQ0UFBLML3NZAhrU30EYLJ9uaGyu6O2wsFRE6gJNQUQ26ZDABVSJiU4nVBQJBAAc1FtfBS9wUtbdTpoUP6ly37WwE4DCW/Kvovkwl+iEU7FXxgZg9kf4G27B7wPgCq3wJRG8ooDnUFHbriZ7MPQmgedleVGdSy/1Wwbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHHNOxCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHHNOxCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AB9C4CED1;
	Wed, 19 Feb 2025 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955486;
	bh=9i6s23YXfV4AQRcn/GUoqSzpPuXlMNgF8wuJ9HPrO9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHHNOxCpFxUTR1nQCxNunZ/bvuaLafOl9FJQsMe9OevEgV74qlOVHR5EkBivwxN8Z
	 jwfh/knwPe2JFRZo89teB7JACO6s7dbKoZRprlGbh9H0QW7mt8ni0rdK7xNq0jwnwK
	 DCckibU5ufPD++KNF/54jjVxBLUb/mCmVm8gOtR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Vejvalka <jan.vejvalka@lfmotol.cuni.cz>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/152] xen/swiotlb: relax alignment requirements
Date: Wed, 19 Feb 2025 09:27:14 +0100
Message-ID: <20250219082550.870961669@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 85fcb57c983f423180ba6ec5d0034242da05cc54 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 6d0d1c8a508bf..b6e54ab3b6f3b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -74,19 +74,21 @@ static inline phys_addr_t xen_dma_to_phys(struct device *dev,
 	return xen_bus_to_phys(dev, dma_to_phys(dev, dma_addr));
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
@@ -155,7 +157,8 @@ xen_swiotlb_alloc_coherent(struct device *dev, size_t size,
 
 	*dma_handle = xen_phys_to_dma(dev, phys);
 	if (*dma_handle + size - 1 > dma_mask ||
-	    range_straddles_page_boundary(phys, size)) {
+	    range_straddles_page_boundary(phys, size) ||
+	    range_requires_alignment(phys, size)) {
 		if (xen_create_contiguous_region(phys, order, fls64(dma_mask),
 				dma_handle) != 0)
 			goto out_free_pages;
@@ -181,7 +184,8 @@ xen_swiotlb_free_coherent(struct device *dev, size_t size, void *vaddr,
 	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	if (WARN_ON_ONCE(dma_handle + size - 1 > dev->coherent_dma_mask) ||
-	    WARN_ON_ONCE(range_straddles_page_boundary(phys, size)))
+	    WARN_ON_ONCE(range_straddles_page_boundary(phys, size) ||
+			 range_requires_alignment(phys, size)))
 	    	return;
 
 	if (TestClearPageXenRemapped(virt_to_page(vaddr)))
-- 
2.39.5



