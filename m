Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337182550A7;
	Mon, 12 May 2025 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072948; cv=none; b=qgH117q1sYMLHVz8uDyoKkVaiAwaOdmdY7gImzApcS/EE0T2ZeccQoVpp+Sd/tbj+msC50PlFQjjkOHowfMNVdKh9MbWmHGW+ummV/6VO3r1RGjV++ClUg0ZJhSGC0BUTlASXLXLjoatiSovlqsivjy9WrdLVBYudpB/Pa31DiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072948; c=relaxed/simple;
	bh=K89jmE3m380NlAcCc5yQPCvMaGFA2MxZhMhESpO2ORA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6Dna6ZfZEMp+BXYfA5EJKkjRn5K94yNapVe7OxhlbTlvzpmm26s2pofZcbFo0J4LbNSNTKsGZbDfAn/obtxParjruM2WnA359vlLX/u74PdJMK2FPeC901jyGsBtR9TZxSUxGPHQazhQ1W/eISZ8IP6WwFMXP6ZWrD9c8Wo3Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzokPnRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzokPnRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F203C4CEE7;
	Mon, 12 May 2025 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072948;
	bh=K89jmE3m380NlAcCc5yQPCvMaGFA2MxZhMhESpO2ORA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzokPnRm1n4Jl46CZCWyqmwrajOn9gJJmyAPS9c8TFYLs0G1D0+xz8EyhW9O4MG4P
	 eapVPyYG+oXtp/icn7tOL6Yo5nEi8OtXVLJISv1TdXOgq3U9+uB1cedTAt19kAdo7X
	 0RDBEzT5xTLBGbkJhb6hSjSXST398WZh5tui1SbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 107/184] arm64: cpufeature: Move arm64_use_ng_mappings to the .data section to prevent wrong idmap generation
Date: Mon, 12 May 2025 19:45:08 +0200
Message-ID: <20250512172046.183757589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

commit 363cd2b81cfdf706bbfc9ec78db000c9b1ecc552 upstream.

The PTE_MAYBE_NG macro sets the nG page table bit according to the value
of "arm64_use_ng_mappings". This variable is currently placed in the
.bss section. create_init_idmap() is called before the .bss section
initialisation which is done in early_map_kernel(). Therefore,
data/test_prot in create_init_idmap() could be set incorrectly through
the PAGE_KERNEL -> PROT_DEFAULT -> PTE_MAYBE_NG macros.

   # llvm-objdump-21 --syms vmlinux-gcc | grep arm64_use_ng_mappings
     ffff800082f242a8 g     O .bss    0000000000000001 arm64_use_ng_mappings

The create_init_idmap() function disassembly compiled with llvm-21:

  // create_init_idmap()
  ffff80008255c058: d10103ff     	sub	sp, sp, #0x40
  ffff80008255c05c: a9017bfd     	stp	x29, x30, [sp, #0x10]
  ffff80008255c060: a90257f6     	stp	x22, x21, [sp, #0x20]
  ffff80008255c064: a9034ff4     	stp	x20, x19, [sp, #0x30]
  ffff80008255c068: 910043fd     	add	x29, sp, #0x10
  ffff80008255c06c: 90003fc8     	adrp	x8, 0xffff800082d54000
  ffff80008255c070: d280e06a     	mov	x10, #0x703     // =1795
  ffff80008255c074: 91400409     	add	x9, x0, #0x1, lsl #12 // =0x1000
  ffff80008255c078: 394a4108     	ldrb	w8, [x8, #0x290] ------------- (1)
  ffff80008255c07c: f2e00d0a     	movk	x10, #0x68, lsl #48
  ffff80008255c080: f90007e9     	str	x9, [sp, #0x8]
  ffff80008255c084: aa0103f3     	mov	x19, x1
  ffff80008255c088: aa0003f4     	mov	x20, x0
  ffff80008255c08c: 14000000     	b	0xffff80008255c08c <__pi_create_init_idmap+0x34>
  ffff80008255c090: aa082d56     	orr	x22, x10, x8, lsl #11 -------- (2)

Note (1) is loading the arm64_use_ng_mappings value in w8 and (2) is set
the text or data prot with the w8 value to set PTE_NG bit. If the .bss
section isn't initialized, x8 could include a garbage value and generate
an incorrect mapping.

Annotate arm64_use_ng_mappings as __read_mostly so that it is placed in
the .data section.

Fixes: 84b04d3e6bdb ("arm64: kernel: Create initial ID map from C code")
Cc: stable@vger.kernel.org # 6.9.x
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Link: https://lore.kernel.org/r/20250502180412.3774883-1-yeoreum.yun@arm.com
[catalin.marinas@arm.com: use __read_mostly instead of __ro_after_init]
[catalin.marinas@arm.com: slight tweaking of the code comment]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -111,7 +111,14 @@ static struct arm64_cpu_capabilities con
 
 DECLARE_BITMAP(boot_cpucaps, ARM64_NCAPS);
 
-bool arm64_use_ng_mappings = false;
+/*
+ * arm64_use_ng_mappings must be placed in the .data section, otherwise it
+ * ends up in the .bss section where it is initialized in early_map_kernel()
+ * after the MMU (with the idmap) was enabled. create_init_idmap() - which
+ * runs before early_map_kernel() and reads the variable via PTE_MAYBE_NG -
+ * may end up generating an incorrect idmap page table attributes.
+ */
+bool arm64_use_ng_mappings __read_mostly = false;
 EXPORT_SYMBOL(arm64_use_ng_mappings);
 
 DEFINE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector) = vectors;


