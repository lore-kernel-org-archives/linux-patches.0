Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CAE34FF4B;
	Tue, 16 Dec 2025 11:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885675; cv=none; b=d8mjFfHikbRjOXnQudiQT/v/i/4MZh9XqDM4tNLanvqqaPeAUmZ10+rVvew/+fDBQ4m/3L4K/fUR6UKrCZV/8m8Toi3Vf76yLKUcp81fr4oohjIHsYNg/3J/HUUtnlon3YbzCu/9gYKouX6YWOWgiSP8mXfoBlFKAbuh0wWFQcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885675; c=relaxed/simple;
	bh=3T1jpHFvlSeXTRILvT7QTLcD7fTpRysRqhYIjUixr6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehylsM005/iDcZocaSS1H1mg9d3uv8FEeWa0/mcVWEZGC+eSVcvokL3lnYdCV4FXOy8Le+HpcKlAhIGViwie6HXgP2nwyLXhBqAaMUVlqwl1yWtAGZAZfF21t8Wkvrj1w0yOay3WA43sVwZXY4erT7by//tR6xbM2xrOjG4OPa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQTlEnCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQTlEnCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58091C4CEF1;
	Tue, 16 Dec 2025 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885674;
	bh=3T1jpHFvlSeXTRILvT7QTLcD7fTpRysRqhYIjUixr6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQTlEnCc/SVF5WM/XEqeMH9fwXF1W0lgYEYxauQP7xH17+DxFlKffEAr0pDaX5UEM
	 eTcn/n7HSFVWPz7Cq96kU1uOSHkqmcXNvBEK3y1PV4WqO5V1hYwCM51Q/J9ZqDqClV
	 iVU0cqNNhZA1XfTo2vzAEmjnA/qm+I9cmDCHqnGA=
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
Subject: [PATCH 6.17 177/507] x86/boot: Fix page table access in 5-level to 4-level paging transition
Date: Tue, 16 Dec 2025 12:10:18 +0100
Message-ID: <20251216111351.928911587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index bdd26050dff77..0e89e197e1126 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -3,6 +3,7 @@
 #include <asm/bootparam.h>
 #include <asm/bootparam_utils.h>
 #include <asm/e820/types.h>
+#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include "../string.h"
 #include "efi.h"
@@ -168,9 +169,10 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
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
@@ -180,8 +182,9 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
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



