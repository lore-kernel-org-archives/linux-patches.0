Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8E93793D5;
	Thu, 20 Aug 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247941; cv=none; b=BPbrWXzi5XceLSdrqDtVcXw6N+w3+HexTHd+tdSt6+V5hRG173iCmdpZhKjPrur76NUyjjTJ7Ey9C6QIpUM6YcyoIB4YaoeuVHz9M9LBpyRMtNotqVWLjYyDlXE1YiyHVruPazU5tCWKeAnwsXiZ6qGOBlRJ6StQk9yOHNR5kuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247941; c=relaxed/simple;
	bh=rUjlOhdMalQJFDuHKJtsv8kPOQU3uFR2fNYacZNVeiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvBxzzVuFKr4JbYIs8cN6cqA2UBk/yJeeAFW8mViloaIf5/tlNnBPeyuJVXMD8lno7Ik7nMYUCLC+HdSoookhQhU1f0/bOGhHW/CcusG54HrT0vJe4HW6njUHOD5Y9iUinY9By7C2uEkDG4dpjaaDhMQ9ZjxpPN+GglPfynVXXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESDzYEDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESDzYEDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE1C1F000E9;
	Thu, 20 Aug 2026 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247940;
	bh=XID3IAlMXmhY1rcQT9XWE13qs3L+E0gNZSG3Ca5r5Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESDzYEDPXCXEBcHLqs+uByqDPs5PWM2xc91ZR02LDZUwGVwV3F6zEnVJD2NjxAX/R
	 EjD1AomTOcwuKswETWnXHYA8mgN9eaeHxBSoj92e5n9p3liC31cakB99uh1UVRVKXA
	 NnCrao2suDbQGV4Guh0oJ2BVBiNnr9B6oDIXon2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Ben Zong-You Xie <ben717@andestech.com>
Subject: [PATCH 6.1 054/303] RISC-V: Provide pgtable_l5_enabled on rv32
Date: Thu, 20 Aug 2026 16:53:10 +0200
Message-ID: <20260820145254.794476907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

commit 10128f8b1663a8bce27df051c750d116bb8cd737 upstream.

A few of the other page table level helpers are defined on rv32, but not
pgtable_l5_enabled.  This adds the definition as a constant and converts
pgtable_l4_enabled to a constant as well.

Link: https://lore.kernel.org/r/20230830044129.11481-2-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[ Ben: Applies unchanged; needed by both 6.1.y and 6.6.y. Both trees took
  commit e59e5e2754bf ("riscv: correct pt_level name via
  pgtable_l5/4_enabled") -- 6.1.y as of v6.1.64 -- without this
  prerequisite from the same series, so arch/riscv/mm/ptdump.c fails to
  build on rv32 whenever CONFIG_PTDUMP_CORE is enabled:

    arch/riscv/mm/ptdump.c: In function 'ptdump_init':
    arch/riscv/mm/ptdump.c:387:28: error: 'pgtable_l5_enabled' undeclared
    (first use in this function); did you mean 'pgtable_l4_enabled'?

  Only pgtable_l5_enabled fails because pgtable_l4_enabled still has an
  unconditional extern in asm/pgtable.h; this patch removes that and
  provides both as constants for rv32. The only assignments to them, in
  disable_pgtable_l4/l5(), are already inside
  #if defined(CONFIG_64BIT) && !defined(CONFIG_XIP_KERNEL), so making them
  const on rv32 is safe. v6.12 and later are unaffected. ]
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable-32.h |    3 +++
 arch/riscv/include/asm/pgtable.h    |    1 -
 arch/riscv/mm/init.c                |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -33,4 +33,7 @@
 					  _PAGE_WRITE | _PAGE_EXEC |	\
 					  _PAGE_USER | _PAGE_GLOBAL))
 
+static const __maybe_unused int pgtable_l4_enabled;
+static const __maybe_unused int pgtable_l5_enabled;
+
 #endif /* _ASM_RISCV_PGTABLE_32_H */
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -818,7 +818,6 @@ extern uintptr_t _dtb_early_pa;
 #define dtb_early_pa	_dtb_early_pa
 #endif /* CONFIG_XIP_KERNEL */
 extern u64 satp_mode;
-extern bool pgtable_l4_enabled;
 
 void paging_init(void);
 void misc_mem_init(void);
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -45,10 +45,12 @@ u64 satp_mode __ro_after_init = SATP_MOD
 #endif
 EXPORT_SYMBOL(satp_mode);
 
+#ifdef CONFIG_64BIT
 bool pgtable_l4_enabled = IS_ENABLED(CONFIG_64BIT) && !IS_ENABLED(CONFIG_XIP_KERNEL);
 bool pgtable_l5_enabled = IS_ENABLED(CONFIG_64BIT) && !IS_ENABLED(CONFIG_XIP_KERNEL);
 EXPORT_SYMBOL(pgtable_l4_enabled);
 EXPORT_SYMBOL(pgtable_l5_enabled);
+#endif
 
 phys_addr_t phys_ram_base __ro_after_init;
 EXPORT_SYMBOL(phys_ram_base);


