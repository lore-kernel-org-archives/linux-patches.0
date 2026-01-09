Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E0E33B6ED;
	Fri,  9 Jan 2026 12:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963209; cv=none; b=GJhDBFZaemWv1IQ7yXO/mbGV8CjjSbevVjBpQXCALTdv0IlGfCDhChzx951ioF7wJELIBLbH3/sZ8Tz2eDp+0FhzBb0Dqt9O/FarWCD+yARl0Y3g5YN5VsoNY3N/kLROQ1T4+TIb42apuPiyXlZeajGjuYb/48A8Wty92CFnQtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963209; c=relaxed/simple;
	bh=5NWRFrCJjnQxbckAbCm4hbwO+5BGeLbEEw4xDQ0yihw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q59+WxZWdyS/+ewO8l3p+UGBRnITCe9hvZT6Mf+PTc6V5m7bdEP7PLpg61y/CS0X+YCOrK5OLGuK9oujwjNXO4yAwAMQtb6LRO1P7+OJKmCp6TBuxYaZ7bCKWXtljeD8mgESrKB1FcHHiC2tsxWXtLVA5MOGEDZJxFIEfdNJ7YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXhW7jZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXhW7jZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4020C4CEF1;
	Fri,  9 Jan 2026 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963209;
	bh=5NWRFrCJjnQxbckAbCm4hbwO+5BGeLbEEw4xDQ0yihw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXhW7jZcmp90A0wNqtdGTMEJBnlD3gTLwuJTRIv8ShBU1d++CjRZwu4peS3cGL6W3
	 mkmg5csKHUhvwgsEnxz7moBuRtSiZR41nUCgMcL7IpuH6I8ezLUq0WYDKeOc8yyqM7
	 Pxua2Uop7jsyP1kDNlsfwd6QOLIxSm6F0vRE/hN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 628/634] mm: (un)track_pfn_copy() fix + doc improvements
Date: Fri,  9 Jan 2026 12:45:06 +0100
Message-ID: <20260109112141.266633093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 8c56c5dbcf52220cc9be7a36e7f21ebd5939e0b9 upstream.

We got a late smatch warning and some additional review feedback.

	smatch warnings:
	mm/memory.c:1428 copy_page_range() error: uninitialized symbol 'pfn'.

We actually use the pfn only when it is properly initialized; however, we
may pass an uninitialized value to a function -- although it will not use
it that likely still is UB in C.

So let's just fix it by always initializing pfn in the caller of
track_pfn_copy(), and improving the documentation of track_pfn_copy().

While at it, clarify the doc of untrack_pfn_copy(), that internal checks
make sure if we actually have to untrack anything.

Link: https://lkml.kernel.org/r/20250408085950.976103-1-david@redhat.com
Fixes: dc84bc2aba85 ("x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202503270941.IFILyNCX-lkp@intel.com/
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pgtable.h |    9 ++++++---
 mm/memory.c             |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1196,8 +1196,9 @@ static inline void track_pfn_insert(stru
 
 /*
  * track_pfn_copy is called when a VM_PFNMAP VMA is about to get the page
- * tables copied during copy_page_range(). On success, stores the pfn to be
- * passed to untrack_pfn_copy().
+ * tables copied during copy_page_range(). Will store the pfn to be
+ * passed to untrack_pfn_copy() only if there is something to be untracked.
+ * Callers should initialize the pfn to 0.
  */
 static inline int track_pfn_copy(struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long *pfn)
@@ -1207,7 +1208,9 @@ static inline int track_pfn_copy(struct
 
 /*
  * untrack_pfn_copy is called when a VM_PFNMAP VMA failed to copy during
- * copy_page_range(), but after track_pfn_copy() was already called.
+ * copy_page_range(), but after track_pfn_copy() was already called. Can
+ * be called even if track_pfn_copy() did not actually track anything:
+ * handled internally.
  */
 static inline void untrack_pfn_copy(struct vm_area_struct *dst_vma,
 		unsigned long pfn)
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1283,7 +1283,7 @@ copy_page_range(struct vm_area_struct *d
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct mmu_notifier_range range;
-	unsigned long next, pfn;
+	unsigned long next, pfn = 0;
 	bool is_cow;
 	int ret;
 


