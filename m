Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374794E322C;
	Thu, 17 Sep 2026 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660050; cv=none; b=Hw/Hw8rczYBGpbHRUt9h5Jn1JyYIdW96VRc7nPzvF0bNg7o2jF0esfWXWTLBTOPDMjoBo724GqLonljhIFz7XPpFvkT7ldqK8AKPCuI+Yh41O/c06Os3H4zQsZs3TMFIMcGGrhLDDVnoKJsyAgm7dN6ukq/jcQ/l7LrMTkXhrZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660050; c=relaxed/simple;
	bh=OLouJ488I/5xuj6YveSJl4eRZJF9ILCTVtSAVHO1LHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hold7PiS5AUmPpxjGBfR2gZg6Az3yhHmMerD1jNj9aXGhK3ongefy5asU7evMCCAB8lRiTefo0na4EFVPGqacK7N9fEJRFwHSOKLw9LbMFQxjmf3DTtaJSCEDRgTBThqBzJ/kYnH43RkBIToFlu0N1Kg3YwmjtmEkJASxP0wI50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8b6EXWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8b6EXWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE9C1F000FF;
	Thu, 17 Sep 2026 15:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660044;
	bh=akUwCQXVT4kEftxHBCa47OKtlIaolqtjytYww0Af/J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8b6EXWlKoOLGvEAUrJt4tL0G4VI90VMMDyFMk0eSCZ3WtZRCUyBlIZdnd1Nwx0Hi
	 Tlc7KCX87ElUHOUwXhngEdg03yDOxaW7Vigz3fXZBx1XYhONQNFnreJduu84hvvQ4c
	 kE7m8U0P7Mny/Nj1ZET2m3QZ/RJgCEq+mB2ojMb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	David Carlier <devnexen@gmail.com>,
	Atish Patra <atishp@meta.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH 7.2 461/733] x86/mm/pat: Acquire init_mm write lock on collapse to avoid UAF
Date: Thu, 17 Sep 2026 16:12:49 +0100
Message-ID: <20260917151403.431633780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit a1c7570cedd03372812a5b693732880867babbca upstream.

x86 implements page attribute modification using its Change Page
Attributes (CPA) mechanism.

This tracks properties of ranges such as cache mode through x86 page
attributes, and as part of that logic manipulates kernel page tables.

Since commit:

  41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")

ranges of kernel page table entries can be collapsed into
huge page table entries as part of this logic.

As part of this collapse, it frees the page tables which the collapsed
entries previously pointed to, and it does so without any relevant locks
being held to preclude concurrent kernel page table walkers.

The only way this code can be reached is if CPA_COLLAPSE is specified, and
this is only set in set_memory_rox() via:

set_memory_rox()
-> change_page_attr_set_clr()
-> cpa_flush()
-> cpa_collapse_large_pages()

Notable users of this are execmem and BPF when manipulating executable
mappings.

However, this is problematic for ptdump as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

In addition, concurrent CPA collapse operations are possible which can also
cause races.

Resolve the issue by acquiring the mmap write lock on init_mm across the
whole operation.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: David Carlier <devnexen@gmail.com>
Tested-by: Atish Patra <atishp@meta.com>
Tested-by: Nikunj A Dadhania <nikunj@amd.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260813-cpa-fixes-v2-1-39b4ff90f91d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |   15 ++++++++++++++-
 include/linux/mmap_lock.h    |    2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -410,7 +411,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -448,6 +449,18 @@ static void cpa_collapse_large_pages(str
 	spin_unlock(&cpa_lock);
 }
 
+static void cpa_collapse_large_pages(struct cpa_data *cpa)
+{
+	/*
+	 * Take the mmap write lock on init_mm to:
+	 * - Avoid a use-after-free if raced by ptdump (which takes its own
+	 *   write lock on init_mm).
+	 * - Serialise concurrent CPA walkers.
+	 */
+	scoped_guard(mmap_write_lock, &init_mm)
+		__cpa_collapse_large_pages(cpa);
+}
+
 static void cpa_flush(struct cpa_data *cpa, int cache)
 {
 	unsigned int i;
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -622,6 +622,8 @@ static inline void mmap_read_unlock(stru
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
 DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {


