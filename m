Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F131D14A4D2;
	Tue, 20 Feb 2024 21:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464669; cv=none; b=ZWvEWn3ekue/C+jLwuGBouurf4Xb0o+Pe9SJsICM6/y6XuFIJH8VR2ttqkO9StGQVGvDLbOR5wTM6ifGOagIX4bgE2mHbjDOgDJJV6tb+DSm6DwpXEiOdv0GYwWcAUcRWhixzqp7p7YDCsyqic9efWME0hIIC3HSRaLSHVa4CzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464669; c=relaxed/simple;
	bh=ThIChC1wUEhqrxuUZij5up7oeN6PLivza1xdVWMH4I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7ByPOY/BePDYMYWc4OJEfn8AI8g+FwnXc0Rfa4bihQcKHWYWz44SQ3sxZYCMcDSfr5TTJmhWETY0lPPxWFPneq8VhKkuWPlOOCgq/aUC4oF+muJBodIQ9s5c9hHyny4SXWK2qfdje0Hsc+ORbB4S4jiJ7O5bOfycwWXP/cHh+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdbRmpZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdbRmpZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7736EC433F1;
	Tue, 20 Feb 2024 21:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464668;
	bh=ThIChC1wUEhqrxuUZij5up7oeN6PLivza1xdVWMH4I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdbRmpZoftH46l8XAEVyuC0K1Dw1L8SUROz0IAdWeBuNyNNn1WrDnPNmE0rErnoRI
	 i8L8hP/2nYjI0KSJcMvP/Po/qya/pnVqtuamtL/szXV1j0zisVRm8DnukNm46NPwQO
	 nmHCQ9sUJ5teVofuVduTLi0RatN6bo3pUrrfnZSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 068/309] fs/hugetlbfs/inode.c: mm/memory-failure.c: fix hugetlbfs hwpoison handling
Date: Tue, 20 Feb 2024 21:53:47 +0100
Message-ID: <20240220205635.337345525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

commit 19d3e221807772f8443e565234a6fdc5a2b09d26 upstream.

has_extra_refcount() makes the assumption that the page cache adds a ref
count of 1 and subtracts this in the extra_pins case.  Commit a08c7193e4f1
(mm/filemap: remove hugetlb special casing in filemap.c) modifies
__filemap_add_folio() by calling folio_ref_add(folio, nr); for all cases
(including hugtetlb) where nr is the number of pages in the folio.  We
should adjust the number of references coming from the page cache by
subtracing the number of pages rather than 1.

In hugetlbfs_read_iter(), folio_test_has_hwpoisoned() is testing the wrong
flag as, in the hugetlb case, memory-failure code calls
folio_test_set_hwpoison() to indicate poison.  folio_test_hwpoison() is
the correct function to test for that flag.

After these fixes, the hugetlb hwpoison read selftest passes all cases.

Link: https://lkml.kernel.org/r/20240112180840.367006-1-sidhartha.kumar@oracle.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Closes: https://lore.kernel.org/linux-mm/20230713001833.3778937-1-jiaqiyan@google.com/T/#m8e1469119e5b831bbd05d495f96b842e4a1c5519
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: James Houghton <jthoughton@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>	[6.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 mm/memory-failure.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -340,7 +340,7 @@ static ssize_t hugetlbfs_read_iter(struc
 		} else {
 			folio_unlock(folio);
 
-			if (!folio_test_has_hwpoisoned(folio))
+			if (!folio_test_hwpoison(folio))
 				want = nr;
 			else {
 				/*
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -976,7 +976,7 @@ static bool has_extra_refcount(struct pa
 	int count = page_count(p) - 1;
 
 	if (extra_pins)
-		count -= 1;
+		count -= folio_nr_pages(page_folio(p));
 
 	if (count > 0) {
 		pr_err("%#lx: %s still referenced by %d users\n",


