Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1511CF5FB;
	Wed,  2 Oct 2024 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879605; cv=none; b=SQasCwdyE7vr85PJzIzOuJIycygKH67pGy2rOxUtABxTGbHRz1CAg5xbDrO08btAQ7RZZoqTlEQ6JTEd55/9y2KXb3ELdCj5KNSIvSECF5Se6jpvcX+BRcLww+pVcIcr/Y16HwyoiQNaMVWHLRQ6HlewkGLq6GySoLyOSQP+8es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879605; c=relaxed/simple;
	bh=KJ2lwR+1cam7wqe0pFjKIYt38Bp63NtBtp3CvvFYwO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzgAo+gFRQvdGAWg/WoT0vPztuejYooMtOpdyuDC65++iLuWLmKT7/kK9Vyfn9ISmHsvsd+G11tFMkmNRPDQqxugZFH90f1ifPAQfUSH79LQpe6NKxycs7uh4MSN2FY0C0dd1rkkRsBfFvd6HZcYa0tkHcOzg/ea8ZVUbg47kuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6ikKfhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6ikKfhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C118FC4CEC2;
	Wed,  2 Oct 2024 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879605;
	bh=KJ2lwR+1cam7wqe0pFjKIYt38Bp63NtBtp3CvvFYwO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6ikKfhFwuHwl7Y+JXDbB0mEbrtmxWXidEVQHEMaJa0QySOOuyS44hFV6AVeZemYn
	 pOL/ujHprSgnhJfwejGGtIgN1zoud7a6YdzlLaWRR65q0fdY7UMbYGGc6Ro3/pa7ZI
	 lzDDxkgCIi4wZkeqJ2WPWNWhdd+rIeuiJYPvLBq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/538] xen/swiotlb: fix allocated size
Date: Wed,  2 Oct 2024 14:56:56 +0200
Message-ID: <20241002125759.243168873@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 892f87300e2cd..6d0d1c8a508bf 100644
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



