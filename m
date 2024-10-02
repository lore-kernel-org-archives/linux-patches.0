Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E7B1CFECF;
	Wed,  2 Oct 2024 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875882; cv=none; b=JufesrEuV0BFuF6N1sNgIaDis/55sXu411yrhPTQCWRww5I6X/MAU5aMKl1vec7o3U9vh0juxSpmdI9pYL+KhApu10U93k2kcHLNnTKsJmzg9PfJCaiiL5jBfuqEp21S5B/E5nJ2YTD0jttSBoXugOhDxI1JQ4uP0CG1bAa/tNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875882; c=relaxed/simple;
	bh=+scjoCCLN0vLKDqO14ArgMV7B65smzeaTl0J/cdFsY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc47wIeYblTwY5ogtk2Ks5i6Zk1xpRicPXCas2qY90bo+a4f781JZDe43bf4UXLUO1ZY4UZzxtk0Es038ePEfi7CQTB1pSz8Qi9c9YY1DtJ2GSxgEJgzSyWu8Z/pzD74Ya+CvVjSCS8dEdB45wfpjZHMQPEuKGGfT/RVYzV5MaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igqpX3WH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igqpX3WH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71D4C4CEC5;
	Wed,  2 Oct 2024 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875882;
	bh=+scjoCCLN0vLKDqO14ArgMV7B65smzeaTl0J/cdFsY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igqpX3WHLR2fkkZBq2HInuBMJXuy7MfEGjp9/ZWSc+o2TrfMkxUMYQdbyHQLS4OBD
	 /YAwVTc0By5RB+fI3FwpzAwbQgM+gvksfDOYaFJ2tgAmxz8MK/6WimBfM9F/2GeUu4
	 gi4g8xw12ikAZFXZ4go5RQEskpsDbO7N3vpjHq8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 252/695] xen/swiotlb: fix allocated size
Date: Wed,  2 Oct 2024 14:54:10 +0200
Message-ID: <20241002125832.507200194@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d7fbba8b47003..a337edcf8faf7 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -147,7 +147,7 @@ xen_swiotlb_alloc_coherent(struct device *dev, size_t size,
 	void *ret;
 
 	/* Align the allocation to the Xen page size */
-	size = 1UL << (order + XEN_PAGE_SHIFT);
+	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	ret = (void *)__get_free_pages(flags, get_order(size));
 	if (!ret)
@@ -179,7 +179,7 @@ xen_swiotlb_free_coherent(struct device *dev, size_t size, void *vaddr,
 	int order = get_order(size);
 
 	/* Convert the size to actually allocated. */
-	size = 1UL << (order + XEN_PAGE_SHIFT);
+	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	if (WARN_ON_ONCE(dma_handle + size - 1 > dev->coherent_dma_mask) ||
 	    WARN_ON_ONCE(range_straddles_page_boundary(phys, size)))
-- 
2.43.0



