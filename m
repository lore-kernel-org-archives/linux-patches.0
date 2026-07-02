Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79920353A73;
	Thu,  2 Jul 2026 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010442; cv=none; b=FIbnPFTRrMCu8/p7RUjFZiPn/YXgfGwHlB6RNu4/8+RCmu92vHSAjGTdjVbEAbHTLSF0vMdp/SpGesac92daPtMmG12twP9Ygkp7F3SAiM9g0Ppx+s+LLDrGzk1/o//w0Krv7CZiNTm+8oeNJ+0vMqMV9oZkKX8pl15p26SsTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010442; c=relaxed/simple;
	bh=uOTYxwKFJpqhUbJ7Enoe8S9DJEiNIy+KHkMIMudhg1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp2omGL7qjkHy/pDaaqgH7nzhS9EjZcrpflIzWDrdDEdLEML8+jwGHFy/NK7dpZ79Y08h3RmIFxr0eJ4/C0EE/mvhPgSao25R8En+jjOQ4ny4UXBjVnu7DkwjHzBMRB1KM16HKQM6q1dTUkpNq4XhJO6hncMdfFTdZqqOfDB5AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkHZRxZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkHZRxZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BFB1F000E9;
	Thu,  2 Jul 2026 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010440;
	bh=q3f2VeQAcLwqbvXr7+VXRf4VnafmPHXalhq77wyG9X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkHZRxZj6Nwz3aXQq7pxSq7epMfuf9H/dl+JXychtxWAJicGArxNbrblgclhxhrn9
	 nFgwQ9Nc0YE6qkIH6Al6sKHzOBVnDCanYQ+p5gopQbZiznQF+YKuGdAs+oDO1xrhAJ
	 aU+RlrVNLzjCVGSnjtut9VfQTN6/iQP04CDOblgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bpf <bpf@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Martin Kelly <martin.kelly@crowdstrike.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.12 067/204] scripts/sorttable: Add helper functions for Elf_Sym
Date: Thu,  2 Jul 2026 18:18:44 +0200
Message-ID: <20260702155120.067051698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 17bed33ac12f011f4695059960e1b1d6457229a7 ]

In order to remove the double #include of sorttable.h for 64 and 32 bit
to create duplicate functions, add helper functions for Elf_Sym.  This
will create a function pointer for each helper that will get assigned to
the appropriate function to handle either the 64bit or 32bit version.

This also removes the last references of etype and _r() macros from the
sorttable.h file as their references are now just defined in the
appropriate architecture version of the helper functions. All read
functions now exist in the helper functions which makes it easier to
maintain, as the helper functions define the necessary architecture sizes.

Cc: bpf <bpf@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Martin  Kelly <martin.kelly@crowdstrike.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/20250105162346.185740651@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 scripts/sorttable.h |   30 ++++++++++++++++--------------
 2 files changed, 63 insertions(+), 14 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -152,6 +152,53 @@ SHDR_WORD(link)
 SHDR_WORD(name)
 SHDR_WORD(type)
 
+#define SYM_ADDR(fn_name)			\
+static uint64_t sym64_##fn_name(Elf_Sym *sym)	\
+{						\
+	return r8(&sym->e64.st_##fn_name);	\
+}						\
+						\
+static uint64_t sym32_##fn_name(Elf_Sym *sym)	\
+{						\
+	return r(&sym->e32.st_##fn_name);	\
+}
+
+#define SYM_WORD(fn_name)			\
+static uint32_t sym64_##fn_name(Elf_Sym *sym)	\
+{						\
+	return r(&sym->e64.st_##fn_name);	\
+}						\
+						\
+static uint32_t sym32_##fn_name(Elf_Sym *sym)	\
+{						\
+	return r(&sym->e32.st_##fn_name);	\
+}
+
+#define SYM_HALF(fn_name)			\
+static uint16_t sym64_##fn_name(Elf_Sym *sym)	\
+{						\
+	return r2(&sym->e64.st_##fn_name);	\
+}						\
+						\
+static uint16_t sym32_##fn_name(Elf_Sym *sym)	\
+{						\
+	return r2(&sym->e32.st_##fn_name);	\
+}
+
+static uint8_t sym64_type(Elf_Sym *sym)
+{
+	return ELF64_ST_TYPE(sym->e64.st_info);
+}
+
+static uint8_t sym32_type(Elf_Sym *sym)
+{
+	return ELF32_ST_TYPE(sym->e32.st_info);
+}
+
+SYM_ADDR(value)
+SYM_WORD(name)
+SYM_HALF(shndx)
+
 /*
  * Get the whole file as a programming convenience in order to avoid
  * malloc+lseek+read+free of many pieces.  If successful, then mmap
--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -23,10 +23,7 @@
 #undef sort_mcount_loc
 #undef elf_mcount_loc
 #undef do_sort
-#undef ELF_ST_TYPE
 #undef uint_t
-#undef _r
-#undef etype
 #undef ehdr_shoff
 #undef ehdr_shentsize
 #undef ehdr_shstrndx
@@ -38,6 +35,10 @@
 #undef shdr_name
 #undef shdr_type
 #undef shdr_entsize
+#undef sym_type
+#undef sym_name
+#undef sym_value
+#undef sym_shndx
 
 #ifdef SORTTABLE_64
 # define extable_ent_size	16
@@ -46,10 +47,7 @@
 # define sort_mcount_loc	sort_mcount_loc_64
 # define elf_mcount_loc		elf_mcount_loc_64
 # define do_sort		do_sort_64
-# define ELF_ST_TYPE		ELF64_ST_TYPE
 # define uint_t			uint64_t
-# define _r			r8
-# define etype			e64
 # define ehdr_shoff		ehdr64_shoff
 # define ehdr_shentsize		ehdr64_shentsize
 # define ehdr_shstrndx		ehdr64_shstrndx
@@ -61,6 +59,10 @@
 # define shdr_name		shdr64_name
 # define shdr_type		shdr64_type
 # define shdr_entsize		shdr64_entsize
+# define sym_type		sym64_type
+# define sym_name		sym64_name
+# define sym_value		sym64_value
+# define sym_shndx		sym64_shndx
 #else
 # define extable_ent_size	8
 # define compare_extable	compare_extable_32
@@ -68,10 +70,7 @@
 # define sort_mcount_loc	sort_mcount_loc_32
 # define elf_mcount_loc		elf_mcount_loc_32
 # define do_sort		do_sort_32
-# define ELF_ST_TYPE		ELF32_ST_TYPE
 # define uint_t			uint32_t
-# define _r			r
-# define etype			e32
 # define ehdr_shoff		ehdr32_shoff
 # define ehdr_shentsize		ehdr32_shentsize
 # define ehdr_shstrndx		ehdr32_shstrndx
@@ -83,6 +82,10 @@
 # define shdr_name		shdr32_name
 # define shdr_type		shdr32_type
 # define shdr_entsize		shdr32_entsize
+# define sym_type		sym32_type
+# define sym_name		sym32_name
+# define sym_value		sym32_value
+# define sym_shndx		sym32_shndx
 #endif
 
 #if defined(SORTTABLE_64) && defined(UNWINDER_ORC_ENABLED)
@@ -414,9 +417,9 @@ static int do_sort(Elf_Ehdr *ehdr,
 
 	for (sym = sym_start; (void *)sym + symentsize < sym_end;
 	     sym = (void *)sym + symentsize) {
-		if (ELF_ST_TYPE(sym->etype.st_info) != STT_OBJECT)
+		if (sym_type(sym) != STT_OBJECT)
 			continue;
-		if (!strcmp(strtab + r(&sym->etype.st_name),
+		if (!strcmp(strtab + sym_name(sym),
 			    "main_extable_sort_needed")) {
 			sort_needed_sym = sym;
 			break;
@@ -430,14 +433,13 @@ static int do_sort(Elf_Ehdr *ehdr,
 		goto out;
 	}
 
-	sort_need_index = get_secindex(r2(&sym->etype.st_shndx),
+	sort_need_index = get_secindex(sym_shndx(sym),
 				       ((void *)sort_needed_sym - (void *)symtab) / symentsize,
 				       symtab_shndx);
 	sort_needed_sec = get_index(shdr_start, shentsize, sort_need_index);
 	sort_needed_loc = (void *)ehdr +
 		shdr_offset(sort_needed_sec) +
-		_r(&sort_needed_sym->etype.st_value) -
-		shdr_addr(sort_needed_sec);
+		sym_value(sort_needed_sym) - shdr_addr(sort_needed_sec);
 
 	/* extable has been sorted, clear the flag */
 	w(0, sort_needed_loc);


