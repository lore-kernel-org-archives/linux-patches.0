Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C74527D763;
	Wed, 23 Apr 2025 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421526; cv=none; b=m4vpkT1urcclkQaJlrdgq7TkwRBXgd0QbO7AFeo/gf0NcDkygYC92j/DUetnHbiWSdKkjxsqYPyUkP/57/e0sxwahppk6wTvzaL0o22WKyFYMkXhZZGYBvZyMcYqbc10LC7ogSoRva1Vwb72CPkrsjUvgOCcwY/VAnNdaigW/I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421526; c=relaxed/simple;
	bh=dcagu0EtLKpOPlSEgZBiJsWLYNitevcJAoBOxmZeyAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izLFrBuwhCGXdR6M8tk5WfoSshRiochZ2qOIhMHbDgkRAFBNMKMLHWYnQ5UphA5LFure9vXxCSfq3QZXeqrrPdJ46hiTSURHCLYkSH4WQo/klrPnKln47hbUbhHl2I3q9cCLFEjiw5aZi8X4HpLmB8yjDCbzw35MGxDJ4Bn8ptU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pb2RiLzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pb2RiLzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F20C4CEE2;
	Wed, 23 Apr 2025 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421526;
	bh=dcagu0EtLKpOPlSEgZBiJsWLYNitevcJAoBOxmZeyAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pb2RiLzzxiXW72EPNhU4UcS9R0Jb/5onM/DPqNc+NdgVOdBDsC/2LGNM8LfwPproS
	 1Lu56lkbVQhqcbgcz/6Edm3RfzHxXC56rNJKWsjUfPSuknC79rh7fHc8YMtbMLCmBM
	 878JN/TjcQAjBjvxJoSpj+LaYzIQOFNRfLJDdtqs=
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
Subject: [PATCH 6.6 188/393] sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
Date: Wed, 23 Apr 2025 16:41:24 +0200
Message-ID: <20250423142651.149820300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit eb61ad14c459b54f71f76331ca35d12fa3eb8f98 upstream.

With commit 1a10a44dfc1d ("sparc64: implement the new page table range
API") set_ptes was added to the sparc architecture.  The implementation
included calling arch_enter/leave_lazy_mmu() calls.

The patch removes the usage of arch_enter/leave_lazy_mmu() since this
implies nesting of lazy mmu regions which is not supported.  Without this
fix, lazy mmu mode is effectively disabled because we exit the mode after
the first set_ptes:

remap_pte_range()
  -> arch_enter_lazy_mmu()
  -> set_ptes()
      -> arch_enter_lazy_mmu()
      -> arch_leave_lazy_mmu()
  -> arch_leave_lazy_mmu()

Powerpc suffered the same problem and fixed it in a corresponding way with
commit 47b8def9358c ("powerpc/mm: Avoid calling
arch_enter/leave_lazy_mmu() in set_ptes").

Link: https://lkml.kernel.org/r/20250303141542.3371656-5-ryan.roberts@arm.com
Fixes: 1a10a44dfc1d ("sparc64: implement the new page table range API")
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
 arch/sparc/include/asm/pgtable_64.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -931,7 +931,6 @@ static inline void __set_pte_at(struct m
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	arch_enter_lazy_mmu_mode();
 	for (;;) {
 		__set_pte_at(mm, addr, ptep, pte, 0);
 		if (--nr == 0)
@@ -940,7 +939,6 @@ static inline void set_ptes(struct mm_st
 		pte_val(pte) += PAGE_SIZE;
 		addr += PAGE_SIZE;
 	}
-	arch_leave_lazy_mmu_mode();
 }
 #define set_ptes set_ptes
 


