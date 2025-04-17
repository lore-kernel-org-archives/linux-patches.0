Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8225256C93;
	Thu, 17 Apr 2025 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915967; cv=none; b=gU3MDUsLeAxWD7Z7g+N9EUTg8uAULh2yoUg2z5uMeoxvjN2Fj3ydXDqec5lQbki+b60v6tMDW27d3kgSJVRVwI+DjAKEJy55zK1SJO18Q/6ABD8KF4XRKbKDKfKHLBQnK1LKCJtYcVGUnWTC5+d1DAhzQKm7Au9MCjG6nEPntDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915967; c=relaxed/simple;
	bh=ARnqRe0DryUYzhiMRD9ZFbirZSOrnjDFxJl0XytC+jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQBLER3vdf2YKF+BRNOmAEKp2SqHuQlATYxCRi8OokL1f3YlZVY88JuxM6GIUkG0Nh0/kMFTA4oXv7IGNm/IDJjsGdEnyonYeSkO2A6NU18U/yQQy3uCmP/qDq1wZT1G5b1KpeczifR/foXnJpklCFAwrLvhNbvn2Grhk+AS4Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KskrFMSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KskrFMSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43663C4CEE4;
	Thu, 17 Apr 2025 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915967;
	bh=ARnqRe0DryUYzhiMRD9ZFbirZSOrnjDFxJl0XytC+jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KskrFMSsC/4Y8Ewa4lSY2e0E54ca5rIRbBVhXjupUOVucFdnVkZvHcXBACC8l2Bfo
	 ZpA9rJn4xNAbaF2qCzlJuSEoKnwrGQkPQb7QcBvwl2BUkQJfL/STvKAe2BtWDaDmX7
	 IvW4InuddvhnSp0o4tnG0EQKzBBitw2/QCCB/JHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Juergen Gross <jgross@suse.com>,
	Borislav Betkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 300/393] sparc/mm: disable preemption in lazy mmu mode
Date: Thu, 17 Apr 2025 19:51:49 +0200
Message-ID: <20250417175119.677741659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit a1d416bf9faf4f4871cb5a943614a07f80a7d70f upstream.

Since commit 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy
updates") it's been possible for arch_[enter|leave]_lazy_mmu_mode() to be
called without holding a page table lock (for the kernel mappings case),
and therefore it is possible that preemption may occur while in the lazy
mmu mode.  The Sparc lazy mmu implementation is not robust to preemption
since it stores the lazy mode state in a per-cpu structure and does not
attempt to manage that state on task switch.

Powerpc had the same issue and fixed it by explicitly disabling preemption
in arch_enter_lazy_mmu_mode() and re-enabling in
arch_leave_lazy_mmu_mode().  See commit b9ef323ea168 ("powerpc/64s:
Disable preemption in hash lazy mmu mode").

Given Sparc's lazy mmu mode is based on powerpc's, let's fix it in the
same way here.

Link: https://lkml.kernel.org/r/20250303141542.3371656-4-ryan.roberts@arm.com
Fixes: 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy updates")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/tlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -52,8 +52,10 @@ out:
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+	struct tlb_batch *tb;
 
+	preempt_disable();
+	tb = this_cpu_ptr(&tlb_batch);
 	tb->active = 1;
 }
 
@@ -64,6 +66,7 @@ void arch_leave_lazy_mmu_mode(void)
 	if (tb->tlb_nr)
 		flush_tlb_pending();
 	tb->active = 0;
+	preempt_enable();
 }
 
 static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,


