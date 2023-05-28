Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD80611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5E9C433EF;
	Sun, 28 May 2023 19:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303153;
	bh=hsYVjHiTXwRpFWIA6bLkI5JzoEY7wNSJJnBl+GGZyGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAePiiXCd1K3RNH/iJJ7tUjkYzoLc8r5InbKrN+mBHfOz6L6FzyzZXEMcpfYlwKEk
	 CJx/Uum2A61napdQD9n/xtFY5hCXrzDlcZ8hWEOMGOTxlx1bAfxN733qFHLhIXMkK/
	 7R+rzYQvL1rfZfyR5p2CCPOEG/WH08RGp5i0symI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 148/211] powerpc/64s/radix: Fix soft dirty tracking
Date: Sun, 28 May 2023 20:11:09 +0100
Message-Id: <20230528190847.190386040@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

commit 66b2ca086210732954a7790d63d35542936fc664 upstream.

It was reported that soft dirty tracking doesn't work when using the
Radix MMU.

The tracking is supposed to work by clearing the soft dirty bit for a
mapping and then write protecting the PTE. If/when the page is written
to, a page fault occurs and the soft dirty bit is added back via
pte_mkdirty(). For example in wp_page_reuse():

	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
		update_mmu_cache(vma, vmf->address, vmf->pte);

Unfortunately on radix _PAGE_SOFTDIRTY is being dropped by
radix__ptep_set_access_flags(), called from ptep_set_access_flags(),
meaning the soft dirty bit is not set even though the page has been
written to.

Fix it by adding _PAGE_SOFTDIRTY to the set of bits that are able to be
changed in radix__ptep_set_access_flags().

Fixes: b0b5e9b13047 ("powerpc/mm/radix: Add radix pte #defines")
Cc: stable@vger.kernel.org # v4.7+
Reported-by: Dan Horák <dan@danny.cz>
Link: https://lore.kernel.org/r/20230511095558.56663a50f86bdc4cd97700b7@danny.cz
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230511114224.977423-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1064,8 +1064,8 @@ void radix__ptep_set_access_flags(struct
 				  pte_t entry, unsigned long address, int psize)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long set = pte_val(entry) & (_PAGE_DIRTY | _PAGE_ACCESSED |
-					      _PAGE_RW | _PAGE_EXEC);
+	unsigned long set = pte_val(entry) & (_PAGE_DIRTY | _PAGE_SOFT_DIRTY |
+					      _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
 
 	unsigned long change = pte_val(entry) ^ pte_val(*ptep);
 	/*


