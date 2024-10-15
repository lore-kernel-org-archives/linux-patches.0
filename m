Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4331E6DEE;
	Tue, 15 Oct 2024 11:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992685; cv=none; b=VKPvGcS5Ca5DeLv1ZvYiez27sb7Y/PgDnA6U7A2JpDZ+GXkJBTc0dD1fxtZi+fxG+ZDtI5rG/cXAYVovLwlrTe1NrO42wYC5ZoMTPv0QK/EWNuFm5oGZWlQFj/k4DHmFGLDOInPY202VYFHoRqP3RtptmScRAyyppn/Qp9nwtDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992685; c=relaxed/simple;
	bh=rE7inbJWu+x0EdbqXmkPtP4o0mPUUPdnDXrfyTOgJjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6ct2zOu49WNXxFYDLZiskuKnK/JM+dx0MK41cLB4WDw9yBQGn+Y1N5+LtVlca49l2ZSu0fcnNJ0kqEquRaALZcHPxugnvYKXSc4vR25OhuF82H3y6FEN6uhfMC/ZlnY6JpbMGlPq9MBZbzfxeh79B7CGouGrMdFregzTY8+jdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNwYt3Mv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNwYt3Mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AADBC4CEC6;
	Tue, 15 Oct 2024 11:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992685;
	bh=rE7inbJWu+x0EdbqXmkPtP4o0mPUUPdnDXrfyTOgJjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNwYt3Mv18x8rzpyBvsUIDswLSSAkV10WY1ma6JM+dGL844JvImboNMSet0wR6tjM
	 tSWudqsR7NiyqWGmtZNc7R4P64Pq4l2kfv7KgFE5CuoIV1l2/ilwlyhR8AG3I/LE+6
	 RuTv1zlNghAewMerdFWuH91VOaZY5EXZFAgBag2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/691] xen/swiotlb: add alignment check for dma buffers
Date: Tue, 15 Oct 2024 13:22:17 +0200
Message-ID: <20241015112447.860274876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86bcf329ebfbf..0392841a822fa 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -79,9 +79,15 @@ static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
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



