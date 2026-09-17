Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0074D17B2;
	Thu, 17 Sep 2026 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671813; cv=none; b=DzFKmcge5tzYkUhDHyeAaZyNvg9Lf97tX5HrIuUPFRUbTjWT3gfrajN2KtzVTI964lHSwi87cKeyO1ESLYhy8eWJmhwL+b5fm5Ks3xF3jTWvT0IrSQiwGqOli0HpKOfrgvIvPdXXwJr9dOrKJf28JAIdREsYusQ+b+gNa4++7Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671813; c=relaxed/simple;
	bh=zw5Lg0Hn8TfqRq67d4zvBowsQYTgEVX/MQxWLQN0ZZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItKBNyazLaB/CWUrAExf4lvsht0MgGwmgh0DQJafO+bVKf+fzfwgpCp2SbvVVbYIoxDy6UrvdS61fh6QT30A0WF325MNFDHLG9XF408hk7Pb/FK/3TDjs7h5zqJMz3rrZjj92g3TDuo2YebXSSeD5CByb8IYfPLzHmsvad4WGfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzYUC9gE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzYUC9gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBE31F000FF;
	Thu, 17 Sep 2026 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671812;
	bh=IqqcLwGPYpOkwifvIvALQRXrb+VMseOTAwofL+tcvnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzYUC9gEadGobowNKx2yxAvq/zy99+1nZ3Lz+PXEGwKQQFS4AWPcR7EP/AA5Jog6L
	 x7J01qBi0/ef2OE/0vBAUF/n8Osd8ReWB97Yz2AoxtbaeTiHYvL1X+S59IOKbK1qZ0
	 ps0YyAx6ylyqiMgK7gORGk3MGkMfj6u60EPeaj+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 1098/1102] mm, hugetlb: increment the number of pages to be reset on HVO
Date: Thu, 17 Sep 2026 16:17:21 +0100
Message-ID: <20260917151608.437958800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Salvador <osalvador@suse.de>

commit 274fe92de2c4e50dbfd1b30070b4f6d8a27b388a upstream.

commit 4eeec8c89a0c ("mm: move hugetlb specific things in folio to
page[3]") shifted hugetlb specific stuff, and now mapping overlaps
_hugetlb_cgroup field.

Upon restoring the vmemmap for HVO, only the first two tail pages are
reset, and this causes the check in free_tail_page_prepare() to fail as it
finds an unexpected mapping value in some tails.

Increment the number of pages to be reset to 4 (head + 3 tail pages)

Link: https://lkml.kernel.org/r/20250415111859.376302-1-osalvador@suse.de
Fixes: 4eeec8c89a0c ("mm: move hugetlb specific things in folio to page[3]")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -238,11 +238,11 @@ static void vmemmap_remap_pte(pte_t *pte
  * struct page, the special metadata (e.g. page->flags or page->mapping)
  * cannot copy to the tail struct page structs. The invalid value will be
  * checked in the free_tail_page_prepare(). In order to avoid the message
- * of "corrupted mapping in tail page". We need to reset at least 3 (one
- * head struct page struct and two tail struct page structs) struct page
+ * of "corrupted mapping in tail page". We need to reset at least 4 (one
+ * head struct page struct and three tail struct page structs) struct page
  * structs.
  */
-#define NR_RESET_STRUCT_PAGE		3
+#define NR_RESET_STRUCT_PAGE		4
 
 static inline void reset_struct_pages(struct page *start)
 {


