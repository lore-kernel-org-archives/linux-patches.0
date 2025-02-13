Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3051626B0BE;
	Thu, 13 Feb 2025 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459926; cv=none; b=hkJb8KDbaUekLa63ourGcSFfAROaVLhLXvkm/Q2gOmmtrH6VQ30ySqFerd01Kqf6+6Jpq6EJ/+5DlgdD8XfmbH/8VUuZmLCpbyV9NbQ6A5GObQ0dcyDzS06aJ02yzmmVQBRPFwxxklTA13lRPGLSjej0F26IuCaMYGAAOHTwmkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459926; c=relaxed/simple;
	bh=ZlX0G1SaTShCIV2ZIR6o0piePEGkGxC9Lt+kVeyY4jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emRvKlKViVbGnAxdF+C9N7o66zTexCJNcMXgzlc7FP3OIsdCu/vW1B58Y1P8DFK9YKjdwSUL4GPxxjmm5kXtrY4h+R22doXhz2gTonsusUWivjAF6Dl9r4/HcAYsSgyObPvvPzB4Y+pq5+R4MYQyF22Ij107iLtKwOysNm34Frw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGPRq8IV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGPRq8IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E182C4CED1;
	Thu, 13 Feb 2025 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459926;
	bh=ZlX0G1SaTShCIV2ZIR6o0piePEGkGxC9Lt+kVeyY4jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGPRq8IVZl6aE7lqNHa+IDui2g+3F+LlSmuV0JWUnB2rJj1cWqUOBTm4KeGAbRuUT
	 1EbLINb/1Kf6ebXaoZ8ueaOzozmvQAapsuDN/J6ZS3QZDYIJTTeD9VkOaPGqmb1QYJ
	 SBo79L4mPaItmgOaFukSmbfUAPcW/p404qGEc4B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	John Hubbard <jhubbard@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Aijun Sun <aijun.sun@unisoc.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 378/443] mm: gup: fix infinite loop within __get_longterm_locked
Date: Thu, 13 Feb 2025 15:29:03 +0100
Message-ID: <20250213142455.194817113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

commit 1aaf8c122918aa8897605a9aa1e8ed6600d6f930 upstream.

We can run into an infinite loop in __get_longterm_locked() when
collect_longterm_unpinnable_folios() finds only folios that are isolated
from the LRU or were never added to the LRU.  This can happen when all
folios to be pinned are never added to the LRU, for example when
vm_ops->fault allocated pages using cma_alloc() and never added them to
the LRU.

Fix it by simply taking a look at the list in the single caller, to see if
anything was added.

[zhaoyang.huang@unisoc.com: move definition of local]
  Link: https://lkml.kernel.org/r/20250122012604.3654667-1-zhaoyang.huang@unisoc.com
Link: https://lkml.kernel.org/r/20250121020159.3636477-1-zhaoyang.huang@unisoc.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2323,13 +2323,13 @@ static void pofs_unpin(struct pages_or_f
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
-static unsigned long collect_longterm_unpinnable_folios(
+static void collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
+	unsigned long i;
 
 	for (i = 0; i < pofs->nr_entries; i++) {
 		struct folio *folio = pofs_get_folio(pofs, i);
@@ -2341,8 +2341,6 @@ static unsigned long collect_longterm_un
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
-		collected++;
-
 		if (folio_is_device_coherent(folio))
 			continue;
 
@@ -2364,8 +2362,6 @@ static unsigned long collect_longterm_un
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
-
-	return collected;
 }
 
 /*
@@ -2442,11 +2438,9 @@ static long
 check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 {
 	LIST_HEAD(movable_folio_list);
-	unsigned long collected;
 
-	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
-						       pofs);
-	if (!collected)
+	collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
+	if (list_empty(&movable_folio_list))
 		return 0;
 
 	return migrate_longterm_unpinnable_folios(&movable_folio_list, pofs);


