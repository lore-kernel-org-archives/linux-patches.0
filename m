Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF701268C5D;
	Tue,  8 Apr 2025 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111748; cv=none; b=mtrpZzsjhxqs6bk9+ri9wHC/GpJHRjitZ1chpyJ+Qvo/TRYQb83vQEcs7JSr3FRtAYML319pVc6o7P9fjPiB0D3K37bN39bMTsBNCEFYBrGY+Hc0zK+gMdgOkv/EKDq0k3tM+n5BaW4tsNU4VpQ4PFL2gvBbIwSnHXHM4zx4QvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111748; c=relaxed/simple;
	bh=tQwCylKN54qeahBa0z5O2KX+JdItRuBf/djAXdfwK+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxLgWuIuFKLl2F3DCV2NSl2UFwgHTNL4hJsYHgxhE1YOUrr5Qj7wn4+EOUADXxnqW/Dn5wyip+egqe5ztLk9j5Y/J1+ubWlyx55YPcHW/LKfAjttTIRR4ZLhFndZEBj+TGJM7U13qYDUq49ldQZpJEYVMhUGHI4ny/k4DPXCFJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uub/sCEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uub/sCEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB41C4CEE5;
	Tue,  8 Apr 2025 11:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111748;
	bh=tQwCylKN54qeahBa0z5O2KX+JdItRuBf/djAXdfwK+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uub/sCENMrmMJvx1awxdaWt4BgCxJfIJi6HcWaB72cHjSM7jLK5Zr+0DoK6Ayk11x
	 f2KDpS/v+xBRnCxN11tnRBLGjnJJ1xMlZjMfZl8nWCrUT3ThE7dJYG0r1/zBOsFe2a
	 DMEHKkMbfJbLlpi4KcG++HpvlzvuECxqXnauk3pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 544/731] objtool: Handle different entry size of rodata
Date: Tue,  8 Apr 2025 12:47:21 +0200
Message-ID: <20250408104926.930169713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 091bf313f8a852a7f30c3a8dcef569edfd06f5dc ]

In the most cases, the entry size of rodata is 8 bytes because the
relocation type is 64 bit. There are also 32 bit relocation types,
the entry size of rodata should be 4 bytes in this case.

Add an arch-specific function arch_reloc_size() to assign the entry
size of rodata for x86, powerpc and LoongArch.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250211115016.26913-3-yangtiezhu@loongson.cn
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Stable-dep-of: ef753d66051c ("objtool: Fix detection of consecutive jump tables on Clang 20")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c | 11 +++++++++++
 tools/objtool/arch/powerpc/decode.c   | 14 ++++++++++++++
 tools/objtool/arch/x86/decode.c       | 13 +++++++++++++
 tools/objtool/check.c                 |  2 +-
 tools/objtool/include/objtool/arch.h  |  2 ++
 5 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index 69b66994f2a15..b64205b89f6b4 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -363,3 +363,14 @@ void arch_initial_func_cfi_state(struct cfi_init_state *state)
 	state->cfa.base = CFI_SP;
 	state->cfa.offset = 0;
 }
+
+unsigned int arch_reloc_size(struct reloc *reloc)
+{
+	switch (reloc_type(reloc)) {
+	case R_LARCH_32:
+	case R_LARCH_32_PCREL:
+		return 4;
+	default:
+		return 8;
+	}
+}
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index 53b55690f3204..7c0bf24290675 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -106,3 +106,17 @@ void arch_initial_func_cfi_state(struct cfi_init_state *state)
 	state->regs[CFI_RA].base = CFI_CFA;
 	state->regs[CFI_RA].offset = 0;
 }
+
+unsigned int arch_reloc_size(struct reloc *reloc)
+{
+	switch (reloc_type(reloc)) {
+	case R_PPC_REL32:
+	case R_PPC_ADDR32:
+	case R_PPC_UADDR32:
+	case R_PPC_PLT32:
+	case R_PPC_PLTREL32:
+		return 4;
+	default:
+		return 8;
+	}
+}
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index fe1362c345647..fb9691a34d926 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -852,3 +852,16 @@ bool arch_is_embedded_insn(struct symbol *sym)
 	return !strcmp(sym->name, "retbleed_return_thunk") ||
 	       !strcmp(sym->name, "srso_safe_ret");
 }
+
+unsigned int arch_reloc_size(struct reloc *reloc)
+{
+	switch (reloc_type(reloc)) {
+	case R_X86_64_32:
+	case R_X86_64_32S:
+	case R_X86_64_PC32:
+	case R_X86_64_PLT32:
+		return 4;
+	default:
+		return 8;
+	}
+}
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 79c49c75b429b..4b9f01a11792f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1969,7 +1969,7 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 			break;
 
 		/* Make sure the table entries are consecutive: */
-		if (prev_offset && reloc_offset(reloc) != prev_offset + 8)
+		if (prev_offset && reloc_offset(reloc) != prev_offset + arch_reloc_size(reloc))
 			break;
 
 		sym_offset = reloc->sym->offset + reloc_addend(reloc);
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index d63b46a19f397..396f7c6c81c0f 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -97,4 +97,6 @@ int arch_rewrite_retpolines(struct objtool_file *file);
 
 bool arch_pc_relative_reloc(struct reloc *reloc);
 
+unsigned int arch_reloc_size(struct reloc *reloc);
+
 #endif /* _ARCH_H */
-- 
2.39.5



