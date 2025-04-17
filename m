Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E27256C93;
	Thu, 17 Apr 2025 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915971; cv=none; b=ijYw4s4zBBWRjJnt3muHHfKF1kMbcrwOjglKFzsm4zdByCRZvNarzcHUAK6pj9deJ/s3OV/cyzBp+rFlhV2aFueoz9S6sEqIvtjqwhHDlKAJg/fu3jSroceHylG+0epz/8tV9m5bt+Q8CSQxb+uy8rcgaku6SdbnRO+2PuCu888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915971; c=relaxed/simple;
	bh=nq7xMhKE7msNuEP+OfYZflZeqxdNx8+swZjdbbsxhDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oz2V2RHCpFdJgVWAnshm9JPw2JNzG7pvuE7iHG+xNziHxbvedsL62V5EBnpXl8AD9g26tXZb/ahxNYrofdKq3OBk6OAeN9orERLmCzQVbKpmwBtjTmPSL8Tzd4d0utmtmuROz9mm4UkYh5C3+NBGO36BRWLzeyq0o2xlbV4dhFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of9xheIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of9xheIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52121C4CEE4;
	Thu, 17 Apr 2025 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915970;
	bh=nq7xMhKE7msNuEP+OfYZflZeqxdNx8+swZjdbbsxhDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of9xheItYKDj1hknDM96EP27iI/y1CqBIyRnOObucGCUoQbUcv1Y5FoVqx4zLx5+w
	 H5WcgamxPK39cyFZgDaAg64o3fJJDZbQMVa695Pzl+8U5I1SsKOJSgSRtVt3We54Mr
	 137S6RM3Sv47MlLm+t9VlvXYgav/DcPl0U2EiS2w=
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
Subject: [PATCH 6.12 301/393] sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
Date: Thu, 17 Apr 2025 19:51:50 +0200
Message-ID: <20250417175119.718675458@linuxfoundation.org>
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
@@ -936,7 +936,6 @@ static inline void __set_pte_at(struct m
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	arch_enter_lazy_mmu_mode();
 	for (;;) {
 		__set_pte_at(mm, addr, ptep, pte, 0);
 		if (--nr == 0)
@@ -945,7 +944,6 @@ static inline void set_ptes(struct mm_st
 		pte_val(pte) += PAGE_SIZE;
 		addr += PAGE_SIZE;
 	}
-	arch_leave_lazy_mmu_mode();
 }
 #define set_ptes set_ptes
 


