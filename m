Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C0A84A3F;
	Tue, 14 May 2024 10:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684204; cv=none; b=cFrCud0BekvXmB8I7aEC/kIEbexRNbGlZxFwFdseTMJSp9vGBmI3gJ6eqcuF4apstdGeAgfvzwmUWrvlUOv+X1N8rJxo7Ct1KQGHNB6p7aPw/dwRuCm6vzv6bKkEfbZStGkf/KJIS+Xr/nDQv9PhCZxsBiD3xxOH9MIr5dM32zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684204; c=relaxed/simple;
	bh=wRdhn/dQid05s7zg3Z1p/b5D6muU2EV/7M7xs3VXkLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtfD2OciAGDGrz9y7+JGSNk34issLyKifFw4bGWh1EQmOri2UwnDYl7duc5lOvr+ttWPqVfkJW/JhLitCnpe0+hVtDbyPgriEL5NhooM/EO5Isv5pB81Y2LhCZeBsWKrKYnJxK2XeNgXoQmf/wEn81B6zTQYp3lKsGTg4bY+NBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTIUbqn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTIUbqn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBA3C2BD10;
	Tue, 14 May 2024 10:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684203;
	bh=wRdhn/dQid05s7zg3Z1p/b5D6muU2EV/7M7xs3VXkLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTIUbqn9o0Eq9jLriLi8TA++Wr6Yn2mid1Sy5vhDSH8JSKrW8O0FdUr/lTdy9OE73
	 qtmM9rN6HPk0GE8TxddAw55sB7iPf1EzMYkn9jCQRL8MoSyaoY9k0ipjJDWJKvOtcM
	 478PZGYmpFRRe4NcrJp+VrX5geKMmQYZUI0GsET0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 318/336] fs/proc/task_mmu: fix uffd-wp confusion in pagemap_scan_pmd_entry()
Date: Tue, 14 May 2024 12:18:42 +0200
Message-ID: <20240514101050.628271078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 2c7ad9a590d1a99ec59c7d90cef41e2b296944c4 upstream.

pagemap_scan_pmd_entry() checks if uffd-wp is set on each pte to avoid
unnecessary if set.  However it was previously checking with
`pte_uffd_wp(ptep_get(pte))` without first confirming that the pte was
present.  It is only valid to call pte_uffd_wp() for present ptes.  For
swap ptes, pte_swp_uffd_wp() must be called because the uffd-wp bit may be
kept in a different position, depending on the arch.

This was leading to test failures in the pagemap_ioctl mm selftest, when
bringing up uffd-wp support on arm64 due to incorrectly interpretting the
uffd-wp status of migration entries.

Let's fix this by using the correct check based on pte_present().  While
we are at it, let's pass the pte to make_uffd_wp_pte() to avoid the
pointless extra ptep_get() which can't be optimized out due to READ_ONCE()
on many arches.

Link: https://lkml.kernel.org/r/20240429114104.182890-1-ryan.roberts@arm.com
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Closes: https://lore.kernel.org/linux-arm-kernel/ZiuyGXt0XWwRgFh9@x1n/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1818,10 +1818,8 @@ static unsigned long pagemap_page_catego
 }
 
 static void make_uffd_wp_pte(struct vm_area_struct *vma,
-			     unsigned long addr, pte_t *pte)
+			     unsigned long addr, pte_t *pte, pte_t ptent)
 {
-	pte_t ptent = ptep_get(pte);
-
 	if (pte_present(ptent)) {
 		pte_t old_pte;
 
@@ -2176,9 +2174,12 @@ static int pagemap_scan_pmd_entry(pmd_t
 	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
 		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
-			if (pte_uffd_wp(ptep_get(pte)))
+			pte_t ptent = ptep_get(pte);
+
+			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
+			    pte_swp_uffd_wp_any(ptent))
 				continue;
-			make_uffd_wp_pte(vma, addr, pte);
+			make_uffd_wp_pte(vma, addr, pte, ptent);
 			if (!flush_end)
 				start = addr;
 			flush_end = addr + PAGE_SIZE;
@@ -2191,8 +2192,10 @@ static int pagemap_scan_pmd_entry(pmd_t
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
 			unsigned long next = addr + PAGE_SIZE;
+			pte_t ptent = ptep_get(pte);
 
-			if (pte_uffd_wp(ptep_get(pte)))
+			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
+			    pte_swp_uffd_wp_any(ptent))
 				continue;
 			ret = pagemap_scan_output(p->cur_vma_category | PAGE_IS_WRITTEN,
 						  p, addr, &next);
@@ -2200,7 +2203,7 @@ static int pagemap_scan_pmd_entry(pmd_t
 				break;
 			if (~p->arg.flags & PM_SCAN_WP_MATCHING)
 				continue;
-			make_uffd_wp_pte(vma, addr, pte);
+			make_uffd_wp_pte(vma, addr, pte, ptent);
 			if (!flush_end)
 				start = addr;
 			flush_end = next;
@@ -2209,8 +2212,9 @@ static int pagemap_scan_pmd_entry(pmd_t
 	}
 
 	for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
+		pte_t ptent = ptep_get(pte);
 		unsigned long categories = p->cur_vma_category |
-					   pagemap_page_category(p, vma, addr, ptep_get(pte));
+					   pagemap_page_category(p, vma, addr, ptent);
 		unsigned long next = addr + PAGE_SIZE;
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
@@ -2225,7 +2229,7 @@ static int pagemap_scan_pmd_entry(pmd_t
 		if (~categories & PAGE_IS_WRITTEN)
 			continue;
 
-		make_uffd_wp_pte(vma, addr, pte);
+		make_uffd_wp_pte(vma, addr, pte, ptent);
 		if (!flush_end)
 			start = addr;
 		flush_end = next;


