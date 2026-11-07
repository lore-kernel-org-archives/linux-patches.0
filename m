Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061898;
	b=rFqWhLjZO3bG7IqKTQZefbHqiyXzsaAQgBiFzsBeY+/oAaYGLjG8b/0d1iloS2If8t/j
	 yEpGzNQVeTCKu3ITGB3YpKGNnHn5paB9RHklbuTU+sI/Q4k2bCrGgxKfyhoBSSLBJKv2M
	 2NuOVMj/GiPW6/nQniqowdh2t2YKIhcvLC3Pw+yvwHFolqDiyAIQSuVr/8vbp/TuyKtxR
	 i8BydTaaXF+7TKOXgxJWTXdl8K7wyn8w+NI9G7vSdGgJrinHlrcZEGQZowyekmKS0l1VM
	 M+awGLiPzRuaWC3IRCuU0u2By1kRIS9a8XWz86bOUukh25RmUpTatXgxqKAAvbs5syg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYZT3+8pZag26IsCABqnXJ/uycos7yySl9eIxV2Z3pk=;
	b=gurcmLt4zi1MvPthHPtOdhXpNpT4tZMZ0PSo4RyndP6Qi8/LmHp3WGsabVcfM9DKWIzc
	 vaVfGq6NE++0VAdbNJFb18uvvMJX/3b9GsoVScWx5AzGtZbmpUWtuMr67dnM/1VSKGT1q
	 afrB/IeB4sCC6yaRxywtH1JRS8njQtoZO2AMd+JifoRpf1Q9ZlFVIeJjyJLs7aBQC2TH3
	 dArrUqQ1QdKKvKj3Dd6RmHGkugU7H+vrOiXHdYIlMc4vfBzszbg0+FJhG6yEUIv9EVUrW
	 snWHgBQm6EHnXvtkBlj5bUb82lHc129cd9uEAkiIFng9mK+/U7HFtTmOrb+prK4o6HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMPbn4la;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A806606A330;
	Sat,  7 Nov 2026 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMPbn4la
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B801F0089F;
	Sat,  7 Nov 2026 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061897;
	bh=tYZT3+8pZag26IsCABqnXJ/uycos7yySl9eIxV2Z3pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMPbn4laXoeMVGmR+BfuKdxun6PfeOVPkia9t8SJ3nIZge7G/g5acFGIE96ApFUq5
	 dCNRkYl8MUy4Xidbo4vGXkxKkpJOnmYt8s2gNh3wgVhGLoQk4rg5QdIoy0OTkZXPG7
	 fmgVAN9EQpb0fVhDujehr3w6dOhMC1aLI6O8kn6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Gavin Guo <gavinguo@igalia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0870/1536] mm,hugetlb: sort out folio locking in the faulting path
Date: Sat,  7 Nov 2026 08:48:06 -0500
Message-ID: <20261107135021.981676626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Salvador <osalvador@suse.de>

[ Upstream commit 9293fb4765527c0d2375eb441d045a5a75f5210d ]

Recent conversations showed that there was a misunderstanding about why we
were locking the folio prior to call in hugetlb_wp().  In fact, as soon as
we have the folio mapped into the pagetables, we no longer need to hold it
locked, because we know that no concurrent truncation could have happened.

There is only one case where the folio needs to be locked, and that is
when we are handling an anonymous folio, because hugetlb_wp() will check
whether it can re-use it exclusively for the process that is faulting it
in.

So, pass the folio locked to hugetlb_wp() when that is the case.

Link: https://lkml.kernel.org/r/20250627102904.107202-3-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250630144212.156938-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 824cc56bf43c ("mm/hugetlb: fix use-after-free of a new anon folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4d80b8497142a..5196c1a816e38 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6116,6 +6116,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	pte_t new_pte;
 	bool new_folio, new_pagecache_folio = false;
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
+	bool folio_locked = true;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -6282,6 +6283,14 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+		/*
+		 * No need to keep file folios locked. See comment in
+		 * hugetlb_fault().
+		 */
+		if (!anon_rmap) {
+			folio_locked = false;
+			folio_unlock(folio);
+		}
 		/* Optimization, do the COW without a second fault */
 		ret = hugetlb_wp(vmf);
 	}
@@ -6296,7 +6305,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	if (new_folio)
 		folio_set_hugetlb_migratable(folio);
 
-	folio_unlock(folio);
+	if (folio_locked)
+		folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
 
@@ -6480,15 +6490,20 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
-			/* hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) */
+			/*
+			 * Anonymous folios need to be lock since hugetlb_wp()
+			 * checks whether we can re-use the folio exclusively
+			 * for us in case we are the only user of it.
+			 */
 			folio = page_folio(pte_page(vmf.orig_pte));
-			if (!folio_trylock(folio)) {
+			if (folio_test_anon(folio) && !folio_trylock(folio)) {
 				need_wait_lock = true;
 				goto out_ptl;
 			}
 			folio_get(folio);
 			ret = hugetlb_wp(&vmf);
-			folio_unlock(folio);
+			if (folio_test_anon(folio))
+				folio_unlock(folio);
 			folio_put(folio);
 			goto out_ptl;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
-- 
2.53.0



