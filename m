Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8537C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F35C433EF;
	Mon, 24 Apr 2023 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342830;
	bh=O7h4IJTp71ezAL1PtBDjB3kID/LODlnPyWXpeIHNK/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoFU+b2F/af7u1iEvLygA5VkGImSkITFQbEpNdCW7Rzi/0PbCxr6ogSx/h9/y6VP6
	 111yKIDSSG09SXoW/MKFlnPtg3FlSXWTrccJxtewEdVTHYQBy926RErDlyH86IfCVV
	 bwrbFGZV36ffiSbeiDN35EDDxx3gZTLCB0IVxrFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Rapoport <rppt@linux.vnet.ibm.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 73/98] mm/khugepaged: check again on anon uffd-wp during isolation
Date: Mon, 24 Apr 2023 15:17:36 +0200
Message-Id: <20230424131136.686173919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Xu <peterx@redhat.com>

commit dd47ac428c3f5f3bcabe845f36be870fe6c20784 upstream.

Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd
round done in __collapse_huge_page_isolate() after
hpage_collapse_scan_pmd(), during which all the locks will be released
temporarily.  It means the pgtable can change during this phase before 2nd
round starts.

It's logically possible some ptes got wr-protected during this phase, and
we can errornously collapse a thp without noticing some ptes are
wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only
did that for the 1st phase, not the 2nd phase.

Since __collapse_huge_page_isolate() happens after a round of small page
swapins, we don't need to worry on any !present ptes - if it existed
khugepaged will already bail out.  So we only need to check present ptes
with uffd-wp bit set there.

This is something I found only but never had a reproducer, I thought it
was one caused a bug in Muhammad's recent pagemap new ioctl work, but it
turns out it's not the cause of that but an userspace bug.  However this
seems to still be a real bug even with a very small race window, still
worth to have it fixed and copy stable.

Link: https://lkml.kernel.org/r/20230405155120.3608140-1-peterx@redhat.com
Fixes: e1e267c7928f ("khugepaged: skip collapse if uffd-wp detected")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -561,6 +561,10 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
+		if (pte_uffd_wp(pteval)) {
+			result = SCAN_PTE_UFFD_WP;
+			goto out;
+		}
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;


