Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2CD1ACEDA;
	Sun,  7 Sep 2025 20:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277124; cv=none; b=Saq+Q5EX2X1P4NEiltCyuY8GnWrdLbD6U5D0rqDmXWM3Y5MVCNHpu5ptZxhCa9htUK175zeVIeq8aDSx0W4OWgOezWwAIKjIPDKtV8CxXBoYJg6xUc+VnO53A+O+8Q+5IUNkYt6UJ0Ah1mqVlgzMnrwgl4U7IDTTNPbtW7VCEaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277124; c=relaxed/simple;
	bh=Kcer0ZndHogvKe61CZVqbUsstQD/RflnTlddoLTdXUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEcLMM6qOoJ/u5HEeAY6W6EKV9HtjTcSQG3h08NfNFxf0Z8ipKp4X8ZTywzPb+4F3hmTEESqKcJhSPkKcMBIW6cPbc/NqRoTxFGwFRS8QyQTVyJMoMRXWdkOrCAE0uEIHTPBAAH9NCuIRhkRbQgvApTH11Av/XLDSiuFf/ryAIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLRPphdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLRPphdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185CFC4CEF0;
	Sun,  7 Sep 2025 20:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277124;
	bh=Kcer0ZndHogvKe61CZVqbUsstQD/RflnTlddoLTdXUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLRPphdm0ZKi1V9Miyw22XFXblAOO0XyoAXwZnG7zLSpBzeR/gYycz1KnZghcUJcL
	 LRgNnRGB3Kg0B4fWxy2USxKByj4XBAvR8w9wpaF07p1YU/ySd4prbW7If3DioknU9M
	 TLU7CI4w8aKT5CZCKXTjigw5TUNF0Zc2ytyiSUK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	panfan <panfan@qti.qualcomm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 094/175] arm64: ftrace: fix unreachable PLT for ftrace_caller in init_module with CONFIG_DYNAMIC_FTRACE
Date: Sun,  7 Sep 2025 21:58:09 +0200
Message-ID: <20250907195617.067616933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: panfan <panfan@qti.qualcomm.com>

commit a7ed7b9d0ebb038db9963d574da0311cab0b666a upstream.

On arm64, it has been possible for a module's sections to be placed more
than 128M away from each other since commit:

  commit 3e35d303ab7d ("arm64: module: rework module VA range selection")

Due to this, an ftrace callsite in a module's .init.text section can be
out of branch range for the module's ftrace PLT entry (in the module's
.text section). Any attempt to enable tracing of that callsite will
result in a BRK being patched into the callsite, resulting in a fatal
exception when the callsite is later executed.

Fix this by adding an additional trampoline for .init.text, which will
be within range.

No additional trampolines are necessary due to the way a given
module's executable sections are packed together. Any executable
section beginning with ".init" will be placed in MOD_INIT_TEXT,
and any other executable section, including those beginning with ".exit",
 will be placed in MOD_TEXT.

Fixes: 3e35d303ab7d ("arm64: module: rework module VA range selection")
Cc: <stable@vger.kernel.org> # 6.5.x
Signed-off-by: panfan <panfan@qti.qualcomm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250905032236.3220885-1-panfan@qti.qualcomm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/module.h     |    1 +
 arch/arm64/include/asm/module.lds.h |    1 +
 arch/arm64/kernel/ftrace.c          |   13 ++++++++++---
 arch/arm64/kernel/module-plts.c     |   12 +++++++++++-
 arch/arm64/kernel/module.c          |   11 +++++++++++
 5 files changed, 34 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -19,6 +19,7 @@ struct mod_arch_specific {
 
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
+	struct plt_entry	*init_ftrace_trampolines;
 };
 
 u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -2,6 +2,7 @@ SECTIONS {
 	.plt 0 : { BYTE(0) }
 	.init.plt 0 : { BYTE(0) }
 	.text.ftrace_trampoline 0 : { BYTE(0) }
+	.init.text.ftrace_trampoline 0 : { BYTE(0) }
 
 #ifdef CONFIG_KASAN_SW_TAGS
 	/*
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -195,10 +195,17 @@ int ftrace_update_ftrace_func(ftrace_fun
 	return ftrace_modify_code(pc, 0, new, false);
 }
 
-static struct plt_entry *get_ftrace_plt(struct module *mod)
+static struct plt_entry *get_ftrace_plt(struct module *mod, unsigned long addr)
 {
 #ifdef CONFIG_MODULES
-	struct plt_entry *plt = mod->arch.ftrace_trampolines;
+	struct plt_entry *plt = NULL;
+
+	if (within_module_mem_type(addr, mod, MOD_INIT_TEXT))
+		plt = mod->arch.init_ftrace_trampolines;
+	else if (within_module_mem_type(addr, mod, MOD_TEXT))
+		plt = mod->arch.ftrace_trampolines;
+	else
+		return NULL;
 
 	return &plt[FTRACE_PLT_IDX];
 #else
@@ -270,7 +277,7 @@ static bool ftrace_find_callable_addr(st
 	if (WARN_ON(!mod))
 		return false;
 
-	plt = get_ftrace_plt(mod);
+	plt = get_ftrace_plt(mod, pc);
 	if (!plt) {
 		pr_err("ftrace: no module PLT for %ps\n", (void *)*addr);
 		return false;
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -283,7 +283,7 @@ int module_frob_arch_sections(Elf_Ehdr *
 	unsigned long core_plts = 0;
 	unsigned long init_plts = 0;
 	Elf64_Sym *syms = NULL;
-	Elf_Shdr *pltsec, *tramp = NULL;
+	Elf_Shdr *pltsec, *tramp = NULL, *init_tramp = NULL;
 	int i;
 
 	/*
@@ -298,6 +298,9 @@ int module_frob_arch_sections(Elf_Ehdr *
 		else if (!strcmp(secstrings + sechdrs[i].sh_name,
 				 ".text.ftrace_trampoline"))
 			tramp = sechdrs + i;
+		else if (!strcmp(secstrings + sechdrs[i].sh_name,
+				 ".init.text.ftrace_trampoline"))
+			init_tramp = sechdrs + i;
 		else if (sechdrs[i].sh_type == SHT_SYMTAB)
 			syms = (Elf64_Sym *)sechdrs[i].sh_addr;
 	}
@@ -363,5 +366,12 @@ int module_frob_arch_sections(Elf_Ehdr *
 		tramp->sh_size = NR_FTRACE_PLTS * sizeof(struct plt_entry);
 	}
 
+	if (init_tramp) {
+		init_tramp->sh_type = SHT_NOBITS;
+		init_tramp->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
+		init_tramp->sh_addralign = __alignof__(struct plt_entry);
+		init_tramp->sh_size = NR_FTRACE_PLTS * sizeof(struct plt_entry);
+	}
+
 	return 0;
 }
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -453,6 +453,17 @@ static int module_init_ftrace_plt(const
 	__init_plt(&plts[FTRACE_PLT_IDX], FTRACE_ADDR);
 
 	mod->arch.ftrace_trampolines = plts;
+
+	s = find_section(hdr, sechdrs, ".init.text.ftrace_trampoline");
+	if (!s)
+		return -ENOEXEC;
+
+	plts = (void *)s->sh_addr;
+
+	__init_plt(&plts[FTRACE_PLT_IDX], FTRACE_ADDR);
+
+	mod->arch.init_ftrace_trampolines = plts;
+
 #endif
 	return 0;
 }


