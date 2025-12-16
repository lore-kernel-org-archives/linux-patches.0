Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B9C341069;
	Tue, 16 Dec 2025 11:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884201; cv=none; b=Ra8OkovGMAx4m0rMy/2+2j3K2VIi22/+fMNWm68pgZpgvumHmaLhA4GVj2Uukh5F/yhgaRpwlOks9ScdKw4M4Vf+OAHmd9rA4JK9C6dVUDcb/JhHXX3OGNAdrh+1MJNE97/oWo9LVDfRAL82PFo2J1DRwnh847LjpSnmNOQg3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884201; c=relaxed/simple;
	bh=RflQ2igDhDZGOZUxIfDMJupjcMRWH2ksqGYmai82IC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suiI4UbrKqIYZebhXmAoRHxhxnIgiafct5nK3I7tGTwIuAVcSGT7bwWoxIx7IjibhZnEEEWmOI4KTzFj5TsWdhA74uAEcIvQIA6DBpaBjWvFHVUoXisscZxbUH3mvlYZ3c9ld/XFGcpxW6XaxY0gdVdEd05fifjIAtTP3Ecal6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhdZ1iLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhdZ1iLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F06C4CEF1;
	Tue, 16 Dec 2025 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884201;
	bh=RflQ2igDhDZGOZUxIfDMJupjcMRWH2ksqGYmai82IC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhdZ1iLyUg6dvszyQyFSfXFRLOAWHN1dBQlaB/PR7+RYs6Y8z3uUS5L4DxLZzcuIr
	 qgm6VMYtmgXElFGS5HCVso9NgfYM1lPkoQxgwuwi5p+VubAfVMdmRO1H51Ga1gRzFi
	 05WOY4OmHxJysBoQSjhPq/kAIn4FACMoJoxwWpiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael van der Westhuizen <rmikey@meta.com>,
	Tobias Fleig <tfleig@meta.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/354] x86/boot: Fix page table access in 5-level to 4-level paging transition
Date: Tue, 16 Dec 2025 12:11:29 +0100
Message-ID: <20251216111325.343957694@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Usama Arif <usamaarif642@gmail.com>

[ Upstream commit eb2266312507d7b757859e2227aa5c4ba6280ebe ]

When transitioning from 5-level to 4-level paging, the existing code
incorrectly accesses page table entries by directly dereferencing CR3 and
applying PAGE_MASK. This approach has several issues:

- __native_read_cr3() returns the raw CR3 register value, which on x86_64
  includes not just the physical address but also flags. Bits above the
  physical address width of the system i.e. above __PHYSICAL_MASK_SHIFT) are
  also not masked.

- The PGD entry is masked by PAGE_SIZE which doesn't take into account the
  higher bits such as _PAGE_BIT_NOPTISHADOW.

Replace this with proper accessor functions:

- native_read_cr3_pa(): Uses CR3_ADDR_MASK to additionally mask metadata out
  of CR3 (like SME or LAM bits). All remaining bits are real address bits or
  reserved and must be 0.

- mask pgd value with PTE_PFN_MASK instead of PAGE_MASK, accounting for flags
  above bit 51 (_PAGE_BIT_NOPTISHADOW in particular). Bits below 51, but above
  the max physical address are reserved and must be 0.

Fixes: e9d0e6330eb8 ("x86/boot/compressed/64: Prepare new top-level page table for trampoline")
Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Reported-by: Tobias Fleig <tfleig@meta.com>
Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/a482fd68-ce54-472d-8df1-33d6ac9f6bb5@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/pgtable_64.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index d8c5de40669d3..b20a5790c193d 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -3,6 +3,7 @@
 #include <asm/bootparam.h>
 #include <asm/bootparam_utils.h>
 #include <asm/e820/types.h>
+#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include "pgtable.h"
 #include "../string.h"
@@ -176,9 +177,10 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 		 * For 4- to 5-level paging transition, set up current CR3 as
 		 * the first and the only entry in a new top-level page table.
 		 */
-		*trampoline_32bit = __native_read_cr3() | _PAGE_TABLE_NOENC;
+		*trampoline_32bit = native_read_cr3_pa() | _PAGE_TABLE_NOENC;
 	} else {
-		unsigned long src;
+		u64 *new_cr3;
+		pgd_t *pgdp;
 
 		/*
 		 * For 5- to 4-level paging transition, copy page table pointed
@@ -188,8 +190,9 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 		 * We cannot just point to the page table from trampoline as it
 		 * may be above 4G.
 		 */
-		src = *(unsigned long *)__native_read_cr3() & PAGE_MASK;
-		memcpy(trampoline_32bit, (void *)src, PAGE_SIZE);
+		pgdp = (pgd_t *)native_read_cr3_pa();
+		new_cr3 = (u64 *)(native_pgd_val(pgdp[0]) & PTE_PFN_MASK);
+		memcpy(trampoline_32bit, new_cr3, PAGE_SIZE);
 	}
 
 	toggle_la57(trampoline_32bit);
-- 
2.51.0



