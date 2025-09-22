Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A82F0C52;
	Mon, 22 Sep 2025 19:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570238; cv=none; b=A36vsgacZbB/4CpJIIFhmgYxG/6ajTKc7D30yJgYWoSYo9jBV9ddq0hsuCB9aoIGvUnQOYjTr9jI5yhCq16iYWAqWzhgmPIIKh0aRTdROwxrTpL3ihZVgs56FPlJ2gXMcmyZfuodFI9dBCmiiHjvBLFH6Qw7dSTt1t6dSFzIG9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570238; c=relaxed/simple;
	bh=kx31ylSRz9djZwS31wsJkYKXF7JB5ReqH4cDGKSbycI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4j4nfSmnOlzhHbq8HvKEr+w4c257G9BS9gPIsLKQTCa0jdOJYM39x6d/BcYzQBeHnM4zdSCb6JEjrZHgDlTuH912YjhP9mgKe24TarqzrBMCZnCvbh73d45hjsUCwozmNx0y9Hds/Q4WkqVZw1sc8NV5+uMkPiRCqR4YfGHmuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffov56a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffov56a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCF6C4CEF0;
	Mon, 22 Sep 2025 19:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570238;
	bh=kx31ylSRz9djZwS31wsJkYKXF7JB5ReqH4cDGKSbycI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffov56a4Lwl71BpMcDGLbx2MF05dDiF/9ElcZ2vgWib2XWbMeWCMKQxr7KQIzNiVO
	 5yEaBQP6pS0J/bo7jsHXdq0XJyuhsk3F5c+zbXUbaMdFcoerync83GVjKLNbcX2t/9
	 Sze41tPKwdXSxm6kNghuTl4r5RFdOaU4ewfAhjAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhe <lizhe.67@bytedance.com>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 060/149] gup: optimize longterm pin_user_pages() for large folio
Date: Mon, 22 Sep 2025 21:29:20 +0200
Message-ID: <20250922192414.394799141@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhe <lizhe.67@bytedance.com>

commit a03db236aebfaeadf79396dbd570896b870bda01 upstream.

In the current implementation of longterm pin_user_pages(), we invoke
collect_longterm_unpinnable_folios().  This function iterates through the
list to check whether each folio belongs to the "longterm_unpinnabled"
category.  The folios in this list essentially correspond to a contiguous
region of userspace addresses, with each folio representing a physical
address in increments of PAGESIZE.

If this userspace address range is mapped with large folio, we can
optimize the performance of function collect_longterm_unpinnable_folios()
by reducing the using of READ_ONCE() invoked in
pofs_get_folio()->page_folio()->_compound_head().

Also, we can simplify the logic of collect_longterm_unpinnable_folios().
Instead of comparing with prev_folio after calling pofs_get_folio(), we
can check whether the next page is within the same folio.

The performance test results, based on v6.15, obtained through the
gup_test tool from the kernel source tree are as follows.  We achieve an
improvement of over 66% for large folio with pagesize=2M.  For small
folio, we have only observed a very slight degradation in performance.

Without this patch:

    [root@localhost ~] ./gup_test -HL -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:14391 put:10858 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    [root@localhost ~]# ./gup_test -LT -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:130538 put:31676 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

With this patch:

    [root@localhost ~] ./gup_test -HL -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:4867 put:10516 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    [root@localhost ~]# ./gup_test -LT -m 8192 -n 512
    TAP version 13
    1..1
    # PIN_LONGTERM_BENCHMARK: Time: get:131798 put:31328 us#
    ok 1 ioctl status 0
    # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

[lizhe.67@bytedance.com: whitespace fix, per David]
  Link: https://lkml.kernel.org/r/20250606091917.91384-1-lizhe.67@bytedance.com
Link: https://lkml.kernel.org/r/20250606023742.58344-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2300,6 +2300,31 @@ static void pofs_unpin(struct pages_or_f
 		unpin_user_pages(pofs->pages, pofs->nr_entries);
 }
 
+static struct folio *pofs_next_folio(struct folio *folio,
+		struct pages_or_folios *pofs, long *index_ptr)
+{
+	long i = *index_ptr + 1;
+
+	if (!pofs->has_folios && folio_test_large(folio)) {
+		const unsigned long start_pfn = folio_pfn(folio);
+		const unsigned long end_pfn = start_pfn + folio_nr_pages(folio);
+
+		for (; i < pofs->nr_entries; i++) {
+			unsigned long pfn = page_to_pfn(pofs->pages[i]);
+
+			/* Is this page part of this folio? */
+			if (pfn < start_pfn || pfn >= end_pfn)
+				break;
+		}
+	}
+
+	if (unlikely(i == pofs->nr_entries))
+		return NULL;
+	*index_ptr = i;
+
+	return pofs_get_folio(pofs, i);
+}
+
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
@@ -2307,16 +2332,13 @@ static unsigned long collect_longterm_un
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	unsigned long i, collected = 0;
-	struct folio *prev_folio = NULL;
+	unsigned long collected = 0;
 	bool drain_allow = true;
+	struct folio *folio;
+	long i = 0;
 
-	for (i = 0; i < pofs->nr_entries; i++) {
-		struct folio *folio = pofs_get_folio(pofs, i);
-
-		if (folio == prev_folio)
-			continue;
-		prev_folio = folio;
+	for (folio = pofs_get_folio(pofs, i); folio;
+	     folio = pofs_next_folio(folio, pofs, &i)) {
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;


