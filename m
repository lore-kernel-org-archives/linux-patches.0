Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1678E307492;
	Thu, 20 Aug 2026 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247506; cv=none; b=GWTbOdh56eEr0GZB6G3I4eZ0x9YlsDFiM0tU68OtLWPt6CX2JBfaYNVs5pU23uoyq0NpeHHiIpDge++qjxJs/mpyMeQRfpaNgGTgLKQtO3AsVCo7lPGT+LhwDpM9H6r8pxGyGjTuyxJEeHz5Ra/9wug3kEAVqMFzQ2xL1V31XOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247506; c=relaxed/simple;
	bh=QN3dNLH68ATFOn2BunhvMrSbTAEgaaVG9LT9Q7N5wFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et/jsT3gWerQPFbGGQp+C2gCg1lE4yHD5Hdr0L7ugjTn/6nF5E2bbj+ZRyUmzMxInhZNLoLxpN8/6lwDXshlDgPtVjyITTihA1yAIO9ZdlYUYiO1aAmcVoXPTgmdMxKdVb/ym/StnD6ohPJ1D4N15h27603ldPrAiqzkT5bfLlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA2Sbr0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA2Sbr0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EF31F000E9;
	Thu, 20 Aug 2026 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247504;
	bh=APEcegKdDXVYIlS4ASkQ0J4YiM+j9FSomPJi79glixQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iA2Sbr0KZlhtRcDzfJFnjUQZbJun+Rba9JFiE6tEHcVpMjTj4soPFgymfindCs+Da
	 2cr/oms9atdFDBTuLhrBNYNhD1rYcRPmKTdirTPIMVRF4632UwxUBdIG4vG7flDZwQ
	 7OmeuojU9b7X2IbXjn8PPjYBHr4vYc3k4Jgtt6eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Ben Zong-You Xie <ben717@andestech.com>
Subject: [PATCH 6.6 068/166] RISC-V: Provide pgtable_l5_enabled on rv32
Date: Thu, 20 Aug 2026 16:55:27 +0200
Message-ID: <20260820145213.190731619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -905,7 +905,6 @@ extern uintptr_t _dtb_early_pa;
 #define dtb_early_pa	_dtb_early_pa
 #endif /* CONFIG_XIP_KERNEL */
 extern u64 satp_mode;
-extern bool pgtable_l4_enabled;
 
 void paging_init(void);
 void misc_mem_init(void);
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -50,10 +50,12 @@ u64 satp_mode __ro_after_init = SATP_MOD
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


