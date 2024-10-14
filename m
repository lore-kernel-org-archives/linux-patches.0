Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23021ABEBD;
	Mon, 14 Oct 2024 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917791; cv=none; b=s8FQRbZKf1BqCycB9KJQ9eBVeDeCVBtsB3btRvDk6gu5DtzX9ZRwTyP1Xr0nyDWKrFNgCIRoP64Ne64oGTZ1vTTEeeS53NE3499F2qnElUBhidMqkldI04skvuxka/Gd6h/++o/GFepht5WuvcJ45WOU4KgcB6LzT4qAYd02Wbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917791; c=relaxed/simple;
	bh=KYwxRFf+pJSlAbsOabTwdOOrbPLY59wUEIMetiDi0fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHZOqH2rWODwT0R9DGd1YA8sp+0/AazsSyT55MZrWdhhg0cHbI14pXhdlwTN7YtvOIn3XjR8qmc0bwkPMpjrczpUos5URvQDlDfczENSmlWIfVo2qWvakoPEm+fqS1vk2+Se5HQRPwtoL3GzC9wd1ORXVNRckb0bgCbNjAphAtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2i2o2cbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2i2o2cbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D88C4CEC3;
	Mon, 14 Oct 2024 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917790;
	bh=KYwxRFf+pJSlAbsOabTwdOOrbPLY59wUEIMetiDi0fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2i2o2cbk8Lyf2L8FKwTpIcNRt8JDUM+tA/a613aCy2vE2lT5edYnZFJvT71qBq04h
	 VYFCd4Csi4roZxZvyT2Lmo9AX2zPyHb1MyUY7gpa46sfhbKzm2KStdVqf1PXpik4Wf
	 grQTM6GdLogFt3s5QBxmMRxJuSOG8LPwDney3jMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/798] xen/swiotlb: fix allocated size
Date: Mon, 14 Oct 2024 16:11:30 +0200
Message-ID: <20241014141223.262499265@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit c3dea3d54f4d399f8044547f0f1abdccbdfb0fee ]

The allocated size in xen_swiotlb_alloc_coherent() and
xen_swiotlb_free_coherent() is calculated wrong for the case of
XEN_PAGE_SIZE not matching PAGE_SIZE. Fix that.

Fixes: 7250f422da04 ("xen-swiotlb: use actually allocated size on check physical continuous")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index cf52964f057b3..0451e6ebc21a3 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -146,7 +146,7 @@ xen_swiotlb_alloc_coherent(struct device *dev, size_t size,
 	void *ret;
 
 	/* Align the allocation to the Xen page size */
-	size = 1UL << (order + XEN_PAGE_SHIFT);
+	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	ret = (void *)__get_free_pages(flags, get_order(size));
 	if (!ret)
@@ -178,7 +178,7 @@ xen_swiotlb_free_coherent(struct device *dev, size_t size, void *vaddr,
 	int order = get_order(size);
 
 	/* Convert the size to actually allocated. */
-	size = 1UL << (order + XEN_PAGE_SHIFT);
+	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	if (WARN_ON_ONCE(dma_handle + size - 1 > dev->coherent_dma_mask) ||
 	    WARN_ON_ONCE(range_straddles_page_boundary(phys, size)))
-- 
2.43.0



