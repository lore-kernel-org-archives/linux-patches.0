Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7094B143C52;
	Thu, 13 Jun 2024 12:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280544; cv=none; b=Tb2OmCXneyUpFWNsDMZ5cwRyADxJmR2hcKwTPU4H31iY5EaoARMx2UIXkGjiWoockFUuug4gZm2papkI5TqmmQe1z1LtTj4rf8gKu26c13v6srSQp/ctgqj3c2mte04kZDT0JcmGd0KrR3oCSkOCEnMSfkfldS7wbC05D9FAWqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280544; c=relaxed/simple;
	bh=v45Gy+3O+dmOsg5xI8eGNZzpbCF/y1Aanu3g9y4lmEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMMmcPSuTEzEtrdSBQM4o3mX6k6ttmnAbeGOM8oTFzyUAajxYzsBJqShqkjlrVSMibuSWVsWy40CbR9/+IVn1olrWAM5abJJNL/L30gcHZToRyfC47syzITpmlU0CnPTx4+dykWE2k0PGwvqqB/0OZKQFlh2+kfG8nJXLoJvOZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1XNYKZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1XNYKZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEA9C2BBFC;
	Thu, 13 Jun 2024 12:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280544;
	bh=v45Gy+3O+dmOsg5xI8eGNZzpbCF/y1Aanu3g9y4lmEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1XNYKZmWOz8qPfbMQ41okcoguH7W2Jnwmmee5GKlBQfTf4Ygrid2203mIAXqUXZj
	 0ZjalfahoVJp5uQP2DtH0veSNk9nhICH/9SAV3wXeE0XdqU0ThTQjGHjqU97QI+buv
	 uqW7nnbPNZctkYFKW+WfU61c4DJsiQqFX0+mWzhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank van der Linden <fvdl@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 090/137] mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
Date: Thu, 13 Jun 2024 13:34:30 +0200
Message-ID: <20240613113226.789140942@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Frank van der Linden <fvdl@google.com>

commit 55d134a7b499c77e7cfd0ee41046f3c376e791e5 upstream.

The hugetlb_cma code passes 0 in the order_per_bit argument to
cma_declare_contiguous_nid (the alignment, computed using the page order,
is correctly passed in).

This causes a bit in the cma allocation bitmap to always represent a 4k
page, making the bitmaps potentially very large, and slower.

It would create bitmaps that would be pretty big.  E.g.  for a 4k page
size on x86, hugetlb_cma=64G would mean a bitmap size of (64G / 4k) / 8
== 2M.  With HUGETLB_PAGE_ORDER as order_per_bit, as intended, this
would be (64G / 2M) / 8 == 4k.  So, that's quite a difference.

Also, this restricted the hugetlb_cma area to ((PAGE_SIZE <<
MAX_PAGE_ORDER) * 8) * PAGE_SIZE (e.g.  128G on x86) , since
bitmap_alloc uses normal page allocation, and is thus restricted by
MAX_PAGE_ORDER.  Specifying anything about that would fail the CMA
initialization.

So, correctly pass in the order instead.

Link: https://lkml.kernel.org/r/20240404162515.527802-2-fvdl@google.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7464,9 +7464,9 @@ void __init hugetlb_cma_reserve(int orde
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_nid(0, size, 0,
-						PAGE_SIZE << HUGETLB_PAGE_ORDER,
-						 0, false, name,
-						 &hugetlb_cma[nid], nid);
+					PAGE_SIZE << HUGETLB_PAGE_ORDER,
+					HUGETLB_PAGE_ORDER, false, name,
+					&hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
 				res, nid);


