Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3708717FD;
	Thu, 13 Jun 2024 12:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282993; cv=none; b=pdJAAAOgWXYk6u9TK2EGAAyIHx8t246BYdGs1QQ1Bx44S26D1hQYOIQQSgOD9Za3wsbcEx2i7Aypxe8UARs8JEGuSoy0hVH8pnD3sR14YvAvL4avxSGrzu8ho20pErbSK6XSFLa20blRgSd3QWUnpqfUWWV3A3oVmM64EWRfKsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282993; c=relaxed/simple;
	bh=X77bXRNxdDiWWeCkox/mQ9N1BhYyICbZrfDZQ9Tvx4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP36DUnZhxzwsLu7fnpnmuWG+yQk7vyD+IoE53sTEPJZRFBXYoz1QHnqbOVwwyuff888Yfmtjg86Hl5BZv0Y1ec9D4EjsDTOtRzyzzUOf+t1dcYLGD2jykCF2h/r5eiPKe0CHRhU8l0U1DHvuFwr9NXI6/XOTx8qB0+hzKfvFlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdxwkkcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdxwkkcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DBEC2BBFC;
	Thu, 13 Jun 2024 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282993;
	bh=X77bXRNxdDiWWeCkox/mQ9N1BhYyICbZrfDZQ9Tvx4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdxwkkcnMoUcblVMEC2BJ50gCkKL5viXlW4P2UulSYMTZywArtg7jIHOHkxCX4FGn
	 4UmkKSUMQIJa8guNdSginlW1pxmbyeCTQSo7j8J0IT0kDisYp/ZVMt/27IHErIH7Gu
	 jWPS7OaUTSQ5yrIi591diNanE3Hq/ZtwjlMXTQP8=
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
Subject: [PATCH 6.1 63/85] mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
Date: Thu, 13 Jun 2024 13:36:01 +0200
Message-ID: <20240613113216.569863021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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
@@ -7669,9 +7669,9 @@ void __init hugetlb_cma_reserve(int orde
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


