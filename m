Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D631B124;
	Fri, 21 Nov 2025 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731889; cv=none; b=aQ2YXXvBrwntsI2S0ABYd+Y/OE+LpkN2l7fssCvYJsrFs22iJTW74TwpL3tiYjnmUMvy+E3QleMLe40XWupGkFW6WKgMCrnSebz9LyXbrjdcUbePsWksebozBif36G3vsVBPbAutTP+PVuUpWUk5NymS2D4kHZ22fRa9sTtkllY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731889; c=relaxed/simple;
	bh=8hveUr9/ADSaEQ8ZMjfVVPt9KG78UVWCUjOCDRxjgwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZblK/y+3P8MVr7O5KhGEPbjvEwnmu7m+ws+h6BYfCtBy06YExqPUcKKVVEoKCdCuwom1+iVz0Gf+rTqPCdJr9xi7WSACuYU0lbYouNTFFIOqAp6ckvv2dgPrquzDRR4vy/Lxv+0wzrSbAQBFDxSDXhp3Jc7kKchoYZ3enSEBCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsnpMEzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsnpMEzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC7FC4CEF1;
	Fri, 21 Nov 2025 13:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731889;
	bh=8hveUr9/ADSaEQ8ZMjfVVPt9KG78UVWCUjOCDRxjgwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsnpMEzXKpqOAfz0zL3xAkzarq2Yh8GRYWMMz2/AAEAd1x3uYkRqdBrNkPKiGabpz
	 bSjJGdDa0S+iox3jpap+Fyrt1Y2H4uqPI4JW570ND5e2p5ZlfMSvXVKosjDnMJ6ded
	 +8hM0y+CW4Fn9yMsmJvE1WqJYnMjPdlfqkQxlCQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	craftfever <craftfever@airmail.cc>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	xu xin <xu.xin16@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 115/185] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Fri, 21 Nov 2025 14:12:22 +0100
Message-ID: <20251121130148.025032123@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

commit f5548c318d6520d4fa3c5ed6003eeb710763cbc5 upstream.

Currently, scan_get_next_rmap_item() walks every page address in a VMA to
locate mergeable pages.  This becomes highly inefficient when scanning
large virtual memory areas that contain mostly unmapped regions, causing
ksmd to use large amount of cpu without deduplicating much pages.

This patch replaces the per-address lookup with a range walk using
walk_page_range().  The range walker allows KSM to skip over entire
unmapped holes in a VMA, avoiding unnecessary lookups.  This problem was
previously discussed in [1].

Consider the following test program which creates a 32 TiB mapping in the
virtual address space but only populates a single page:

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
        char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                          MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

        if (area == MAP_FAILED) {
                perror("mmap() failed\n");
                return -1;
        }

        /* Populate a single page such that we get an anon_vma. */
        *area = 0;

        /* Enable KSM. */
        madvise(area, size, MADV_MERGEABLE);
        pause();
        return 0;
}

$ ./ksm-sparse  &
$ echo 1 > /sys/kernel/mm/ksm/run

Without this patch ksmd uses 100% of the cpu for a long time (more then 1
hour in my test machine) scanning all the 32 TiB virtual address space
that contain only one mapped page.  This makes ksmd essentially deadlocked
not able to deduplicate anything of value.  With this patch ksmd walks
only the one mapped page and skips the rest of the 32 TiB virtual address
space, making the scan fast using little cpu.

Link: https://lkml.kernel.org/r/20251023035841.41406-1-pedrodemargomes@gmail.com
Link: https://lkml.kernel.org/r/20251022153059.22763-1-pedrodemargomes@gmail.com
Link: https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/ [1]
Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: craftfever <craftfever@airmail.cc>
Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ksm.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 104 insertions(+), 9 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2447,6 +2447,95 @@ static bool should_skip_rmap_item(struct
 	return true;
 }
 
+struct ksm_next_page_arg {
+	struct folio *folio;
+	struct page *page;
+	unsigned long addr;
+};
+
+static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+	struct ksm_next_page_arg *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	pte_t *start_ptep = NULL, *ptep, pte;
+	struct mm_struct *mm = walk->mm;
+	struct folio *folio;
+	struct page *page;
+	spinlock_t *ptl;
+	pmd_t pmd;
+
+	if (ksm_test_exit(mm))
+		return 0;
+
+	cond_resched();
+
+	pmd = pmdp_get_lockless(pmdp);
+	if (!pmd_present(pmd))
+		return 0;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pmd_leaf(pmd)) {
+		ptl = pmd_lock(mm, pmdp);
+		pmd = pmdp_get(pmdp);
+
+		if (!pmd_present(pmd)) {
+			goto not_found_unlock;
+		} else if (pmd_leaf(pmd)) {
+			page = vm_normal_page_pmd(vma, addr, pmd);
+			if (!page)
+				goto not_found_unlock;
+			folio = page_folio(page);
+
+			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+				goto not_found_unlock;
+
+			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+			goto found_unlock;
+		}
+		spin_unlock(ptl);
+	}
+
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte = ptep_get(ptep);
+
+		if (!pte_present(pte))
+			continue;
+
+		page = vm_normal_page(vma, addr, pte);
+		if (!page)
+			continue;
+		folio = page_folio(page);
+
+		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			continue;
+		goto found_unlock;
+	}
+
+not_found_unlock:
+	spin_unlock(ptl);
+	if (start_ptep)
+		pte_unmap(start_ptep);
+	return 0;
+found_unlock:
+	folio_get(folio);
+	spin_unlock(ptl);
+	if (start_ptep)
+		pte_unmap(start_ptep);
+	private->page = page;
+	private->folio = folio;
+	private->addr = addr;
+	return 1;
+}
+
+static struct mm_walk_ops ksm_next_page_ops = {
+	.pmd_entry = ksm_next_page_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2534,21 +2623,27 @@ next_mm:
 			ksm_scan.address = vma->vm_end;
 
 		while (ksm_scan.address < vma->vm_end) {
+			struct ksm_next_page_arg ksm_next_page_arg;
 			struct page *tmp_page = NULL;
-			struct folio_walk fw;
 			struct folio *folio;
 
 			if (ksm_test_exit(mm))
 				break;
 
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
+			int found;
+
+			found = walk_page_range_vma(vma, ksm_scan.address,
+						    vma->vm_end,
+						    &ksm_next_page_ops,
+						    &ksm_next_page_arg);
+
+			if (found > 0) {
+				folio = ksm_next_page_arg.folio;
+				tmp_page = ksm_next_page_arg.page;
+				ksm_scan.address = ksm_next_page_arg.addr;
+			} else {
+				VM_WARN_ON_ONCE(found < 0);
+				ksm_scan.address = vma->vm_end - PAGE_SIZE;
 			}
 
 			if (tmp_page) {


