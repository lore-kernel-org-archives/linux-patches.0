Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C704212D6A;
	Thu, 12 Dec 2024 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016548; cv=none; b=mE28OFf0PrL7ozOB5i7EY9c/78QkLx5zs1S034tzijy9okqfQqbG1uCVOJWQEyqNTEaZE1FpJcpOT3agdsPhjAtFpnuzoIaR1RPFtESXMo2APyIrntBNjDuyxtXiEJYKoJc3xS6MTBhuFe0RsIlQntnR2naeAeuKuBCjCNwtjW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016548; c=relaxed/simple;
	bh=7O9GKFNdTUnXVi064DUvglY1E8YoFiYzfSZku0Z+Uuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af5yCWj2aHoRpoK22w5WQHvH92yXnNJLZUtLkZjR06xOvQJGjQZpx0jgGSYQHRDP6Rm5XF0I1iNwBeCsqTC+LznmXF6mgjUTZg7U3kT9clRziSTjDnjhcDrZnq3MZcgwG8y3BbTQyBaOp+IlJRIbghKkqULzE/CtVUPxoLS1jRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxl5eXYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxl5eXYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7BEC4CECE;
	Thu, 12 Dec 2024 15:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016548;
	bh=7O9GKFNdTUnXVi064DUvglY1E8YoFiYzfSZku0Z+Uuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxl5eXYGPAcXp0Izdt5oGMHSwc9HFDw0NyqZ3K/2dnpBQHDSPS6RpIyRqQs0O23zJ
	 lUwpbJ6ARx06gF8b2lQXjTV+7VBz4MZgBDRAzQlpgYIp7dmGOQwcKLKfS9z3o0sgBj
	 wBmmQ/3Lrw3mbMEGBMAWb8dHmNjmFdR8XZfkjPP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Junxiao Chang <junxiao.chang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 199/466] mm/gup: handle NULL pages in unpin_user_pages()
Date: Thu, 12 Dec 2024 15:56:08 +0100
Message-ID: <20241212144314.654146085@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

commit a1268be280d8e484ab3606d7476edd0f14bb9961 upstream.

The recent addition of "pofs" (pages or folios) handling to gup has a
flaw: it assumes that unpin_user_pages() handles NULL pages in the pages**
array.  That's not the case, as I discovered when I ran on a new
configuration on my test machine.

Fix this by skipping NULL pages in unpin_user_pages(), just like
unpin_folios() already does.

Details: when booting on x86 with "numa=fake=2 movablecore=4G" on Linux
6.12, and running this:

    tools/testing/selftests/mm/gup_longterm

...I get the following crash:

BUG: kernel NULL pointer dereference, address: 0000000000000008
RIP: 0010:sanity_check_pinned_pages+0x3a/0x2d0
...
Call Trace:
 <TASK>
 ? __die_body+0x66/0xb0
 ? page_fault_oops+0x30c/0x3b0
 ? do_user_addr_fault+0x6c3/0x720
 ? irqentry_enter+0x34/0x60
 ? exc_page_fault+0x68/0x100
 ? asm_exc_page_fault+0x22/0x30
 ? sanity_check_pinned_pages+0x3a/0x2d0
 unpin_user_pages+0x24/0xe0
 check_and_migrate_movable_pages_or_folios+0x455/0x4b0
 __gup_longterm_locked+0x3bf/0x820
 ? mmap_read_lock_killable+0x12/0x50
 ? __pfx_mmap_read_lock_killable+0x10/0x10
 pin_user_pages+0x66/0xa0
 gup_test_ioctl+0x358/0xb20
 __se_sys_ioctl+0x6b/0xc0
 do_syscall_64+0x7b/0x150
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/20241121034933.77502-1-jhubbard@nvidia.com
Fixes: 94efde1d1539 ("mm/gup: avoid an unnecessary allocation call for FOLL_LONGTERM cases")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -52,7 +52,12 @@ static inline void sanity_check_pinned_p
 	 */
 	for (; npages; npages--, pages++) {
 		struct page *page = *pages;
-		struct folio *folio = page_folio(page);
+		struct folio *folio;
+
+		if (!page)
+			continue;
+
+		folio = page_folio(page);
 
 		if (is_zero_page(page) ||
 		    !folio_test_anon(folio))
@@ -409,6 +414,10 @@ void unpin_user_pages(struct page **page
 
 	sanity_check_pinned_pages(pages, npages);
 	for (i = 0; i < npages; i += nr) {
+		if (!pages[i]) {
+			nr = 1;
+			continue;
+		}
 		folio = gup_folio_next(pages, npages, i, &nr);
 		gup_put_folio(folio, nr, FOLL_PIN);
 	}


