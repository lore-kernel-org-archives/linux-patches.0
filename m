Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E48E2773F7;
	Fri, 21 Nov 2025 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731434; cv=none; b=pfHEcd1xJOZgD2gufEeI9s+KU3ppr6aBqDC+ju6lQLj7DZ3BQheoznpZbiatAGc3T3rtp6M6awaNHRTFhKKPI2GIIqFuQy3EWl+dQyHeT2vMXCCowF0LMGuOjnVN2+4X6cKEFK39H4wb6uzioiPuoPMC1fRZiCoDxbTQXeJto5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731434; c=relaxed/simple;
	bh=Mh04n02/2yNMLyQGTZn5jzpgHb6XfzKinNTE+74fmwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOkQJkF7mz2d5rsQsMfkpJ+q+q9gS8lGmv2VDtoOIBLmcwXzhaMJf0TnIdfKkrkTV8eqMHsPjokRhnNvj0R335kSZ72tu4z22H6ONjpc0FBdBGHJ+SEllYLABTUTA7cbKA1kswDx47txKn6pA9Dcku6giNnwQfUpp+3zNddbF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZCyN9pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZCyN9pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC08FC4CEF1;
	Fri, 21 Nov 2025 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731433;
	bh=Mh04n02/2yNMLyQGTZn5jzpgHb6XfzKinNTE+74fmwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZCyN9pwVgsCLN2Bqt3gu6UAEnvzwnINfKt+zPY9IF9ef+kMIa63Xn2GId8NKz2aD
	 FuoU+j37QCDtajDjzi7qFbs0z2OMFz/j38aBJGSu3pkXV7Na5XtNKOtHAD+jDvWBtP
	 SzX4GmgTZ8qS3LsplI9KsEqUUaTCRAgw3G+kIXbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 189/247] mm/huge_memory: fix folio split check for anon folios in swapcache
Date: Fri, 21 Nov 2025 14:12:16 +0100
Message-ID: <20251121130201.506842656@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit f1d47cafe513b5552a5b20a7af0936d9070a8a78 upstream.

Both uniform and non uniform split check missed the check to prevent
splitting anon folios in swapcache to non-zero order.

Splitting anon folios in swapcache to non-zero order can cause data
corruption since swapcache only support PMD order and order-0 entries.
This can happen when one use split_huge_pages under debugfs to split
anon folios in swapcache.

In-tree callers do not perform such an illegal operation.  Only debugfs
interface could trigger it.  I will put adding a test case on my TODO
list.

Fix the check.

Link: https://lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3529,7 +3529,8 @@ bool non_uniform_split_supported(struct
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    !mapping_large_folio_support(folio->mapping)) {
 		/*
@@ -3560,7 +3561,8 @@ bool uniform_split_supported(struct foli
 	if (folio_test_anon(folio)) {
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else  if (new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {


