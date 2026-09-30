Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5142D594F;
	Wed, 30 Sep 2026 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793468; cv=none; b=e6kNzBXbyZNUnD94U+bxiP7lXlWtyKitwneyAGDazdHeKzvLNs6fKg5Cr+VHLSAX462ihulH/P1Nk6oPKzs4KwAhekEgakgGMaPxx9DrJw4+vy+HqMFSsZjDJdFPHoI5VesYLePTbfhfYP5X71xrUENK1W+m4MGQW+6+TyCD3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793468; c=relaxed/simple;
	bh=9yZrm4GXqqqI094iVmOJw2o9W6NC3CYlEvdQuGeqDwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZnFk/LRzNyNRvrnakZKWOIW+Ya4cQxBybZWuw9EYvVHBIEP64OHhYwvdnQHst9324OwGV3+Z4pDhAvtJZeBqSj8dn2el2rhUl9OVVbuKu3L8G2nSXwtr1aV5uyTPV+t51uudeH//vof291gVZ/PIsJsmVTllSvYfM0edBDjHrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPVe2caX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPVe2caX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3161F000FF;
	Wed, 30 Sep 2026 18:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793466;
	bh=KJjGZuTV4UKgYwaA+bVRZ8XYo/23YKkomOpeq5rcQLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPVe2caXVf7YC3SRBQic9qBQH6lhbH6hPXpPREtqXyQo9fhIbL1AErOthTVwk/lJl
	 jb+lym1CHV24y4lKsLEmHn3b9fbL2smi3kvaqjyxBBpH4Jc0YohU4drBV426LiOL1y
	 eINoG2/Nur00SUfiseWYP6bi6Z02xHJsrWWolKCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewook You <jaewook376@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 6.18 263/395] mm/hugetlb: preserve mremap address delta when skipping page tables
Date: Wed, 30 Sep 2026 17:28:45 +0200
Message-ID: <20260930152346.359144943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaewook You <jaewook376@gmail.com>

commit 9bdad082d44bdcf93716973dcba6be77e8a06e7b upstream.

move_hugetlb_page_tables() optimizes mremap() by advancing to the last
entry in the page table when the source page table does not exist, either
initially or after unsharing a PMD table.  The common loop increment then
steps to the first entry in the next page table.

However, the code advances both the source and destination addresses to
the last entries in their respective page tables, which is wrong.  The
destination address must be advanced only by the same amount as the source
address.

If the source and destination offsets within their page tables differ, the
destination address can be advanced too far, causing follow-up issues.
Fix this by advancing the destination address by the source advance
distance.

With a reproducer, we were able to trigger a kernel panic on x86-64.  With
this fix in place, we can no longer reproduce the issue.

Link: https://lore.kernel.org/20260914132352.472-1-jaewook376@gmail.com
Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
Signed-off-by: Jaewook You <jaewook376@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5828,18 +5828,21 @@ int move_hugetlb_page_tables(struct vm_a
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		const unsigned long offset_to_last_entry =
+			(old_addr | last_addr_mask) - old_addr;
+
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
 		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 


