Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D1531D393;
	Mon, 27 Oct 2025 19:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593054; cv=none; b=T8G/PBndeCf/WwKHBPqZsB21LMjbXLHhUJgHmED+ZNj2+/A2Hs2+UEuDMP71X7TxpGG8ry5UNMBkFWkqoQ2MDxsVXfAV616ZGYnj1liTvO30aj7cFb5ZfZM6ise2hMrVou1/rz8RRMnmmzJjx7ucNAEPj4X1Sk17l7vHy3RVcFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593054; c=relaxed/simple;
	bh=M3cHJ7rL4CLn/LCWKHt86c9MRzEoiBGsOyU/g5rUZwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azYwuRMrF1Ooo5PI+h08T3rWOfaCP38zTVjU4U+o4YCizlMhfEuoj21FvAeLHW9+CEtFnGfP/iaaY4SlVgSI1rJjIDbyQFa0Qgh3q+XjLLBudkdNgJKQ1ALbSCIp8uPVnn5D58PznKXtWfJNkVHUbLep4pjpQigsh354S+xUqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eToXTJYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eToXTJYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A650CC4CEF1;
	Mon, 27 Oct 2025 19:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593054;
	bh=M3cHJ7rL4CLn/LCWKHt86c9MRzEoiBGsOyU/g5rUZwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eToXTJYjkUa7FtWNRi2Z3S6KWEgFE1vR4oQK32nyMttY9dTMnKggRncncrTqO4Lhi
	 7QU3k7Fq2R1c3dVB5Ce8WSTJJvF4hOAca9IhQvGUi4Haq0f3xp90f92NTRE/gfQt4Y
	 DFMzLlj0ldmZjG7uOh/rXA1FfKgdpM4hB52fqmD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Mariano Pache <npache@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 067/117] mm: prevent poison consumption when splitting THP
Date: Mon, 27 Oct 2025 19:36:33 +0100
Message-ID: <20251027183455.821920654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 841a8bfcbad94bb1ba60f59ce34f75259074ae0d upstream.

When performing memory error injection on a THP (Transparent Huge Page)
mapped to userspace on an x86 server, the kernel panics with the following
trace.  The expected behavior is to terminate the affected process instead
of panicking the kernel, as the x86 Machine Check code can recover from an
in-userspace #MC.

  mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
  mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
  mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
  mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
  mce: [Hardware Error]: Run the above through 'mcelog --ascii'
  mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
  Kernel panic - not syncing: Fatal local machine check

The root cause of this panic is that handling a memory failure triggered
by an in-userspace #MC necessitates splitting the THP.  The splitting
process employs a mechanism, implemented in
try_to_map_unused_to_zeropage(), which reads the pages in the THP to
identify zero-filled pages.  However, reading the pages in the THP results
in a second in-kernel #MC, occurring before the initial memory_failure()
completes, ultimately leading to a kernel panic.  See the kernel panic
call trace on the two #MCs.

  First Machine Check occurs // [1]
    memory_failure()         // [2]
      try_to_split_thp_page()
        split_huge_page()
          split_huge_page_to_list_to_order()
            __folio_split()  // [3]
              remap_page()
                remove_migration_ptes()
                  remove_migration_pte()
                    try_to_map_unused_to_zeropage()  // [4]
                      memchr_inv()                   // [5]
                        Second Machine Check occurs  // [6]
                          Kernel panic

[1] Triggered by accessing a hardware-poisoned THP in userspace, which is
    typically recoverable by terminating the affected process.

[2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().

[3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().

[4] Try to map the unused THP to zeropage.

[5] Re-access pages in the hw-poisoned THP in the kernel.

[6] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the poisoned flag on the page in the THP
by TestSetPageHWPoison() before calling try_to_split_thp_page().

As suggested by David Hildenbrand, fix this panic by not accessing to the
poisoned page in the THP during zeropage identification, while continuing
to scan unaffected pages in the THP for possible zeropage mapping.  This
prevents a second in-kernel #MC that would cause kernel panic in Step[4].

Thanks to Andrew Zaborowski for his initial work on fixing this issue.

Link: https://lkml.kernel.org/r/20251015064926.1887643-1-qiuxu.zhuo@intel.com
Link: https://lkml.kernel.org/r/20251011075520.320862-1-qiuxu.zhuo@intel.com
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    3 +++
 mm/migrate.c     |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3720,6 +3720,9 @@ static bool thp_underused(struct folio *
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
+	if (folio_contain_hwpoisoned_page(folio))
+		return false;
+
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
 			if (++num_zero_pages > khugepaged_max_ptes_none)
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -203,8 +203,9 @@ static bool try_to_map_unused_to_zeropag
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
 
-	if (PageCompound(page))
+	if (PageCompound(page) || PageHWPoison(page))
 		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);


