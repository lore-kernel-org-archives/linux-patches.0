Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1AD1D5AD7;
	Wed,  6 Nov 2024 12:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894980; cv=none; b=clNPDYTOjocEctBxBPGTAt7LAO6lKrteIm5OIFTWAf91zza/8FSukiXujwiiDnCl58YH/vig8qTS28ylO9cWDolSFanIQdeN/gDBe9t0wQnQGqXrtjykdb1RLKueLBEc5H0zsEVJNMr0VQdt+Cj/WSuxyo+wpoADoQDTEJSuc20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894980; c=relaxed/simple;
	bh=HTSJ4Yz3nz4kj3QLgF4kr0TB0v/fxsANetXTZu22T6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGRGiZ9nQE9yQW2h671eBQP2uAFQKRX5pfGohqEVkqZWWfHMl+m5VtnZp+F8LEsWe2OY8p3n67jPeDzkb5+H/x6MudSKfNRcxTy/hxvkldCXIGCcr7wI5w4U7NILowqIKgnSuQzyhMNZbtw7MsZBDgo41ZiAYjYaVJoDRTF219M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NdnF8Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NdnF8Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70C0C4CECD;
	Wed,  6 Nov 2024 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894980;
	bh=HTSJ4Yz3nz4kj3QLgF4kr0TB0v/fxsANetXTZu22T6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NdnF8Jzymml8+WfLVZSJ9NQHRMnoT/YKqfdsDdeH78/LoJvD6yGr1hV7xfOUEbdB
	 DgPW4/L+hXLDFNdxhhj2YWneXU+Ark8C1sC6YbfaiCnodaIhIyduFhMIuFmCfvLyBc
	 LRMv9ETn7klMAMR5ggk5+7yHu6bLHsWkTtWZ+Tj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/350] xen/swiotlb: add alignment check for dma buffers
Date: Wed,  6 Nov 2024 12:59:53 +0100
Message-ID: <20241106120322.498681024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 9f40ec84a7976d95c34e7cc070939deb103652b0 ]

When checking a memory buffer to be consecutive in machine memory,
the alignment needs to be checked, too. Failing to do so might result
in DMA memory not being aligned according to its requested size,
leading to error messages like:

  4xxx 0000:2b:00.0: enabling device (0140 -> 0142)
  4xxx 0000:2b:00.0: Ring address not aligned
  4xxx 0000:2b:00.0: Failed to initialise service qat_crypto
  4xxx 0000:2b:00.0: Resetting device qat_dev0
  4xxx: probe of 0000:2b:00.0 failed with error -14

Fixes: 9435cce87950 ("xen/swiotlb: Add support for 64KB page granularity")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 2f4d4e36c7b36..98f82c759d1e2 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -98,9 +98,15 @@ static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
 {
 	unsigned long next_bfn, xen_pfn = XEN_PFN_DOWN(p);
 	unsigned int i, nr_pages = XEN_PFN_UP(xen_offset_in_page(p) + size);
+	phys_addr_t algn = 1ULL << (get_order(size) + PAGE_SHIFT);
 
 	next_bfn = pfn_to_bfn(xen_pfn);
 
+	/* If buffer is physically aligned, ensure DMA alignment. */
+	if (IS_ALIGNED(p, algn) &&
+	    !IS_ALIGNED((phys_addr_t)next_bfn << XEN_PAGE_SHIFT, algn))
+		return 1;
+
 	for (i = 1; i < nr_pages; i++)
 		if (pfn_to_bfn(++xen_pfn) != ++next_bfn)
 			return 1;
-- 
2.43.0



