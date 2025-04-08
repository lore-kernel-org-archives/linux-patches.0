Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D51374C4;
	Tue,  8 Apr 2025 11:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110267; cv=none; b=F0mQ15XaKpaDJyYhWNd48qIsQkkgLm/Jskn5RW+HKoQJWM7NK2RApOSRlGbhhz/xd+VvHTidWZyiiPk8P75k/oPCzAfW+5OOVpS0VTr6iPsMIX2sL+DbYrvOjQbhOp8tfIY79RWe3xWFhdzRHDyqN3lHNHbN1j4zIkbmvE6NIRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110267; c=relaxed/simple;
	bh=w61hcUYnm7MnJPkPL5UwIrYcy18x8zaXRaQNIKmVbPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbRzCFSoSrDHdj7+CH1iE5R0L9xsbKhawxrhoThXJ7xFhzGW0FYw8g1+bL7QWcn9kkiTzHpN/75iMckZiV2ZHP46wWCkGnL9Jd8ypGOM3yQoKPuTJDesxUhH5hh4PxU7IYmiqNIfkFIjHxRts/7fIxxFuzplbUseZ91iDHXBO2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1qq4Oq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1qq4Oq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1367DC4CEE5;
	Tue,  8 Apr 2025 11:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110267;
	bh=w61hcUYnm7MnJPkPL5UwIrYcy18x8zaXRaQNIKmVbPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1qq4Oq/Gn3x0Quca5rBtKygXjx/Anw8ZFK2ukUDGCrnyhApQH4oQJfTtjFaJEabT
	 m4TDFtzvSXi8Q3LC1oiQAxDk37R60LTGPX8mV/TZnAz1KRmxHQAQQxHD0TgLgRMl3E
	 CdZSF/iRCoeKvofNfJbCZe/0qftAuAlfcriMYMj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 214/227] x86/mm: Fix flush_tlb_range() when used for zapping normal PMDs
Date: Tue,  8 Apr 2025 12:49:52 +0200
Message-ID: <20250408104826.730971241@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 3ef938c3503563bfc2ac15083557f880d29c2e64 upstream.

On the following path, flush_tlb_range() can be used for zapping normal
PMD entries (PMD entries that point to page tables) together with the PTE
entries in the pointed-to page table:

    collapse_pte_mapped_thp
      pmdp_collapse_flush
        flush_tlb_range

The arm64 version of flush_tlb_range() has a comment describing that it can
be used for page table removal, and does not use any last-level
invalidation optimizations. Fix the X86 version by making it behave the
same way.

Currently, X86 only uses this information for the following two purposes,
which I think means the issue doesn't have much impact:

 - In native_flush_tlb_multi() for checking if lazy TLB CPUs need to be
   IPI'd to avoid issues with speculative page table walks.
 - In Hyper-V TLB paravirtualization, again for lazy TLB stuff.

The patch "x86/mm: only invalidate final translations with INVLPGB" which
is currently under review (see
<https://lore.kernel.org/all/20241230175550.4046587-13-riel@surriel.com/>)
would probably be making the impact of this a lot worse.

Fixes: 016c4d92cd16 ("x86/mm/tlb: Add freed_tables argument to flush_tlb_mm_range")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250103-x86-collapse-flush-fix-v1-1-3c521856cfa6@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/tlbflush.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -222,7 +222,7 @@ void flush_tlb_others(const struct cpuma
 	flush_tlb_mm_range((vma)->vm_mm, start, end,			\
 			   ((vma)->vm_flags & VM_HUGETLB)		\
 				? huge_page_shift(hstate_vma(vma))	\
-				: PAGE_SHIFT, false)
+				: PAGE_SHIFT, true)
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,


