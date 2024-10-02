Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619631D0E1F;
	Wed,  2 Oct 2024 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877875; cv=none; b=Jh3xAxdNS3yWQuEDqLAE9HnDuZ5NeqPUG5eqxKqK2f+PLbFJdXiJmThy2yt4Db4YqVQpR3aEu+HO6kDF8ur0X/1EEOB4mFve+RuwxbZSbDyYbKy1CP9zEr/YPZOSFQGl1YbQ7dA/B4yg60BzGLlm2D+c8r5UjbTYCyizbcX+hss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877875; c=relaxed/simple;
	bh=iFnRZTtHipd3t0G7xbstpbnTHKdBobfiN85rYl+fyNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu9kx6pdmkm+vo7RalizVA0ym58sAO06JXuZ4yQfDUEQYr/phsqd0YMRXppKQnyAJt8VYRyCa1RTlOAR+vkXzSae2yWnGLeDhjlOTefbvX8+NdrnpPmbMBfuEQzvVk+EBSqKA16Q5x22GSfFCrh4bS/cBPURg3rrQ8FuFDzEHo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0jogEsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0jogEsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC86DC4CEC2;
	Wed,  2 Oct 2024 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877875;
	bh=iFnRZTtHipd3t0G7xbstpbnTHKdBobfiN85rYl+fyNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0jogEsHztvHZgHXSs2fE13nw4nTj8PWKd7F+3fkxk3anPYIwscurvXZIL9XLpJy/
	 skA+v4kU3cU6ZW9Gs/0I+g9a1gcyHtdNpJtpUb9t1ZWe6qtwYddNpPMdFyHiXuY0l7
	 1NzSs1JfHuqZZxpwgvVpDaywHB0BV1WlMe8XCPRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 224/634] xen/swiotlb: add alignment check for dma buffers
Date: Wed,  2 Oct 2024 14:55:24 +0200
Message-ID: <20241002125819.941645694@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6579ae3f6dac2..7a6f1f007527c 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -78,9 +78,15 @@ static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
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



