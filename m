Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48290392C34;
	Fri,  7 Aug 2026 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114504; cv=none; b=sU3Wxg65NSrT4fiPydiQCC3h9YUSl4oO4W0k5prxVhgWyBBxsfWbdMqnfj0/42eQiDoJrhoAXty1HQtCcVBaAi1fA2Bf3GWHlWx8n45xCQgN0Q0Nj17F8kIzinWu00BwGONfgpNLeQJ2y9QXvUZrViOLUpi17nrmJjCadQ9hh/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114504; c=relaxed/simple;
	bh=ivBwd5L09qm9trVoVECdfmzwj+3pxyhGTXf/L9vGWOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb1AfyyWzzpBJQdMeLpy7plJZrmmJ2QlA8+K7JzsBYQBuneon9Vk22V/kLYHlggZe2dDCdr2uyrS8cX757YDyN4vn1rHTTgOJc+E6XccTjAJzisL19pBBMZYdUzKgIhIKA1FJC2AdmgHvPCB8nMqyfpm+FRy03rCNCSOZCoUtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkHxs0UJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkHxs0UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE6B1F00A3A;
	Fri,  7 Aug 2026 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114501;
	bh=1ozGw6CuxHqRb1y056NjIMgodcderwRgHQorcOauPqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkHxs0UJ/esGLXzEkErg+Z0pBbnVEvyF8UcZ0sHYocPh5k4rT/VJSCRHzbTxJlGR9
	 x72aY0TIzwjGawqGsDhtikASlzqshBDyvnp5tsm1dnrKcrBfIY3bwMumylsinRWNbV
	 wXkoi+HmKoqKdTA1SW/qyZD1hbPN6RYgWYs7Pzi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/337] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
Date: Fri,  7 Aug 2026 16:38:09 +0200
Message-ID: <20260807143424.733432014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit 07b4377bdbe74a3ec0c8da5849d014f70e003384 ]

PAGEMAP_SCAN reports an unpopulated pte differently depending on which
path serves the request.  The PAGE_IS_WRITTEN fast path in
pagemap_scan_pmd_entry() reports a pte_none as written (and, under
PM_SCAN_WP_MATCHING, arms a marker); pagemap_page_category() returns 0 for
the same pte_none.  A request that cannot take the fast path (an extra
category bit, category_anyof_mask or category_inverted) therefore reports
the pte as clean and skips arming it.

A range that was populated and then MADV_DONTNEED'd reads as written via
one mask and clean via another, and in the latter case is not re-armed for
the next round -- an incremental-dump consumer (e.g.  CRIU) using a richer
mask drops the zapped range and stops tracking writes to it.

Report pte_none as written in pagemap_page_category() too.  A pte_none
carries no uffd-wp marker, i.e.  it is not write-protected -- the same
condition under which the present and swap cases already report
PAGE_IS_WRITTEN.  The fast path applies no VMA test, so neither does this.

The hugetlb and fully-unpopulated-PMD (no page table) scans have no
PAGE_IS_WRITTEN fast path, so they do not exhibit the per-entry divergence
and are left unchanged.

Add a pagemap_ioctl selftest that populates a range, drops it with
MADV_DONTNEED, and checks that the fast path and the generic
(category_anyof_mask) path both report every page written.

Link: https://lore.kernel.org/20260707151349.92143-1-kirill@shutemov.name
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-fable-5
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 07b4377bdbe74a3ec0c8da5849d014f70e003384)
[ kas: fix only; selftest hunk dropped (pagemap_ioctl.c differs on this tree) ]

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index a521f0faa0a49..44dc442b4f0e7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2097,6 +2097,19 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 {
 	unsigned long categories = 0;
 
+	if (pte_none(pte)) {
+		/*
+		 * An unpopulated pte carries no uffd-wp marker, i.e. it is not
+		 * write-protected, the same condition under which the present
+		 * and swap cases below report PAGE_IS_WRITTEN. Report it here
+		 * too so this generic path agrees with the PAGE_IS_WRITTEN fast
+		 * path in pagemap_scan_pmd_entry(), which reports pte_none as
+		 * written and, under PM_SCAN_WP_MATCHING, arms a marker. The
+		 * fast path applies no VMA test, so neither does this.
+		 */
+		return PAGE_IS_WRITTEN;
+	}
+
 	if (pte_present(pte)) {
 		struct page *page;
 
-- 
2.53.0



