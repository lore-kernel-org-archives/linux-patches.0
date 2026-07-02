Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D98733BBCD;
	Thu,  2 Jul 2026 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010841; cv=none; b=XzBO3TwxDZOa9khy88gwPrSEO3GPWkO+WmYOwGs5nzAcnO9NK9Z9fmjRawbD4yuw3H0HObdwbs2sM9roNVIK5S9S6uYhbWfP2fJfzya3WBsiD0h4sJEUgGGQPO4HpAR6CH46Tfu52ixhyrHwl0RnWu0+aEgqADvX2wVdVfAuz4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010841; c=relaxed/simple;
	bh=tkGpfoeiIFtJUEeWTHaqu4xczV45ZKFkXydJQC2p3Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAdkG3pa6YuGVab5HwqL3i+PssCTbWuB/4EvOIQOCQol17mn7uBrEjvSiPCFUbdecbvApfmUfVnxxfY3ii8dSuZ4nFy9pbkQysWo3tBodSwoGSNMa7P0iMVjVmIl2uilU/TDV39VPpakeepZlv7BwGN0nMMOTR0pAl9i7LI9qJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpoRRWNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpoRRWNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7B91F000E9;
	Thu,  2 Jul 2026 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010840;
	bh=7DUzqk36+grn2mkRGFkUpV4voUGt2c/c4ta5tsiOXys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpoRRWNGIzSh1MAg9rUi1OFMgoNraBYpbXu6AfZ0fmpNnp6BXZgl0kr+IehHzeySO
	 1UN3YbWqFauv0oJ/UnPWURWSsqNyoWQ7WTypo7R7mjEE5NHyytajLxnKDBQUxt/yxv
	 tUF7DpC0Zi8lr3zoMnXgijSRtf1VoJBDc78Saec8=
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
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Martin Kelly <martin.kelly@crowdstrike.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 058/175] scripts/sorttable: Use a structure of function pointers for elf helpers
Date: Thu,  2 Jul 2026 18:19:19 +0200
Message-ID: <20260702155117.015755210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 1e5f6771c247b28135307058d2cfe3b0153733dc ]

Instead of having a series of function pointers that gets assigned to the
Elf64 or Elf32 versions, put them all into a single structure and use
that. Add the helper function that chooses the structure into the macros
that build the different versions of the elf functions.

Link: https://lore.kernel.org/all/CAHk-=wiafEyX7UgOeZgvd6fvuByE5WXUPh9599kwOc_d-pdeug@mail.gmail.com/

Cc: bpf <bpf@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Martin Kelly <martin.kelly@crowdstrike.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/20250110075459.13d4b94c@gandalf.local.home
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |  175 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 118 insertions(+), 57 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -85,6 +85,25 @@ static uint64_t (*r8)(const uint64_t *);
 static void (*w)(uint32_t, uint32_t *);
 typedef void (*table_sort_t)(char *, int);
 
+static struct elf_funcs {
+	int (*compare_extable)(const void *a, const void *b);
+	uint64_t (*ehdr_shoff)(Elf_Ehdr *ehdr);
+	uint16_t (*ehdr_shstrndx)(Elf_Ehdr *ehdr);
+	uint16_t (*ehdr_shentsize)(Elf_Ehdr *ehdr);
+	uint16_t (*ehdr_shnum)(Elf_Ehdr *ehdr);
+	uint64_t (*shdr_addr)(Elf_Shdr *shdr);
+	uint64_t (*shdr_offset)(Elf_Shdr *shdr);
+	uint64_t (*shdr_size)(Elf_Shdr *shdr);
+	uint64_t (*shdr_entsize)(Elf_Shdr *shdr);
+	uint32_t (*shdr_link)(Elf_Shdr *shdr);
+	uint32_t (*shdr_name)(Elf_Shdr *shdr);
+	uint32_t (*shdr_type)(Elf_Shdr *shdr);
+	uint8_t (*sym_type)(Elf_Sym *sym);
+	uint32_t (*sym_name)(Elf_Sym *sym);
+	uint64_t (*sym_value)(Elf_Sym *sym);
+	uint16_t (*sym_shndx)(Elf_Sym *sym);
+} e;
+
 static uint64_t ehdr64_shoff(Elf_Ehdr *ehdr)
 {
 	return r8(&ehdr->e64.e_shoff);
@@ -95,6 +114,11 @@ static uint64_t ehdr32_shoff(Elf_Ehdr *e
 	return r(&ehdr->e32.e_shoff);
 }
 
+static uint64_t ehdr_shoff(Elf_Ehdr *ehdr)
+{
+	return e.ehdr_shoff(ehdr);
+}
+
 #define EHDR_HALF(fn_name)				\
 static uint16_t ehdr64_##fn_name(Elf_Ehdr *ehdr)	\
 {							\
@@ -104,6 +128,11 @@ static uint16_t ehdr64_##fn_name(Elf_Ehd
 static uint16_t ehdr32_##fn_name(Elf_Ehdr *ehdr)	\
 {							\
 	return r2(&ehdr->e32.e_##fn_name);		\
+}							\
+							\
+static uint16_t ehdr_##fn_name(Elf_Ehdr *ehdr)		\
+{							\
+	return e.ehdr_##fn_name(ehdr);			\
 }
 
 EHDR_HALF(shentsize)
@@ -119,6 +148,11 @@ static uint32_t shdr64_##fn_name(Elf_Shd
 static uint32_t shdr32_##fn_name(Elf_Shdr *shdr)	\
 {							\
 	return r(&shdr->e32.sh_##fn_name);		\
+}							\
+							\
+static uint32_t shdr_##fn_name(Elf_Shdr *shdr)		\
+{							\
+	return e.shdr_##fn_name(shdr);			\
 }
 
 #define SHDR_ADDR(fn_name)				\
@@ -130,6 +164,11 @@ static uint64_t shdr64_##fn_name(Elf_Shd
 static uint64_t shdr32_##fn_name(Elf_Shdr *shdr)	\
 {							\
 	return r(&shdr->e32.sh_##fn_name);		\
+}							\
+							\
+static uint64_t shdr_##fn_name(Elf_Shdr *shdr)		\
+{							\
+	return e.shdr_##fn_name(shdr);			\
 }
 
 #define SHDR_WORD(fn_name)				\
@@ -141,6 +180,10 @@ static uint32_t shdr64_##fn_name(Elf_Shd
 static uint32_t shdr32_##fn_name(Elf_Shdr *shdr)	\
 {							\
 	return r(&shdr->e32.sh_##fn_name);		\
+}							\
+static uint32_t shdr_##fn_name(Elf_Shdr *shdr)		\
+{							\
+	return e.shdr_##fn_name(shdr);			\
 }
 
 SHDR_ADDR(addr)
@@ -161,6 +204,11 @@ static uint64_t sym64_##fn_name(Elf_Sym
 static uint64_t sym32_##fn_name(Elf_Sym *sym)	\
 {						\
 	return r(&sym->e32.st_##fn_name);	\
+}						\
+						\
+static uint64_t sym_##fn_name(Elf_Sym *sym)	\
+{						\
+	return e.sym_##fn_name(sym);		\
 }
 
 #define SYM_WORD(fn_name)			\
@@ -172,6 +220,11 @@ static uint32_t sym64_##fn_name(Elf_Sym
 static uint32_t sym32_##fn_name(Elf_Sym *sym)	\
 {						\
 	return r(&sym->e32.st_##fn_name);	\
+}						\
+						\
+static uint32_t sym_##fn_name(Elf_Sym *sym)	\
+{						\
+	return e.sym_##fn_name(sym);		\
 }
 
 #define SYM_HALF(fn_name)			\
@@ -183,6 +236,11 @@ static uint16_t sym64_##fn_name(Elf_Sym
 static uint16_t sym32_##fn_name(Elf_Sym *sym)	\
 {						\
 	return r2(&sym->e32.st_##fn_name);	\
+}						\
+						\
+static uint16_t sym_##fn_name(Elf_Sym *sym)	\
+{						\
+	return e.sym_##fn_name(sym);		\
 }
 
 static uint8_t sym64_type(Elf_Sym *sym)
@@ -195,6 +253,11 @@ static uint8_t sym32_type(Elf_Sym *sym)
 	return ELF32_ST_TYPE(sym->e32.st_info);
 }
 
+static uint8_t sym_type(Elf_Sym *sym)
+{
+	return e.sym_type(sym);
+}
+
 SYM_ADDR(value)
 SYM_WORD(name)
 SYM_HALF(shndx)
@@ -322,29 +385,16 @@ static int compare_extable_64(const void
 	return av > bv;
 }
 
+static int compare_extable(const void *a, const void *b)
+{
+	return e.compare_extable(a, b);
+}
+
 static inline void *get_index(void *start, int entsize, int index)
 {
 	return start + (entsize * index);
 }
 
-
-static int (*compare_extable)(const void *a, const void *b);
-static uint64_t (*ehdr_shoff)(Elf_Ehdr *ehdr);
-static uint16_t (*ehdr_shstrndx)(Elf_Ehdr *ehdr);
-static uint16_t (*ehdr_shentsize)(Elf_Ehdr *ehdr);
-static uint16_t (*ehdr_shnum)(Elf_Ehdr *ehdr);
-static uint64_t (*shdr_addr)(Elf_Shdr *shdr);
-static uint64_t (*shdr_offset)(Elf_Shdr *shdr);
-static uint64_t (*shdr_size)(Elf_Shdr *shdr);
-static uint64_t (*shdr_entsize)(Elf_Shdr *shdr);
-static uint32_t (*shdr_link)(Elf_Shdr *shdr);
-static uint32_t (*shdr_name)(Elf_Shdr *shdr);
-static uint32_t (*shdr_type)(Elf_Shdr *shdr);
-static uint8_t (*sym_type)(Elf_Sym *sym);
-static uint32_t (*sym_name)(Elf_Sym *sym);
-static uint64_t (*sym_value)(Elf_Sym *sym);
-static uint16_t (*sym_shndx)(Elf_Sym *sym);
-
 static int extable_ent_size;
 static int long_size;
 
@@ -864,7 +914,30 @@ static int do_file(char const *const fna
 	}
 
 	switch (ehdr->e32.e_ident[EI_CLASS]) {
-	case ELFCLASS32:
+	case ELFCLASS32: {
+		struct elf_funcs efuncs = {
+			.compare_extable	= compare_extable_32,
+			.ehdr_shoff		= ehdr32_shoff,
+			.ehdr_shentsize		= ehdr32_shentsize,
+			.ehdr_shstrndx		= ehdr32_shstrndx,
+			.ehdr_shnum		= ehdr32_shnum,
+			.shdr_addr		= shdr32_addr,
+			.shdr_offset		= shdr32_offset,
+			.shdr_link		= shdr32_link,
+			.shdr_size		= shdr32_size,
+			.shdr_name		= shdr32_name,
+			.shdr_type		= shdr32_type,
+			.shdr_entsize		= shdr32_entsize,
+			.sym_type		= sym32_type,
+			.sym_name		= sym32_name,
+			.sym_value		= sym32_value,
+			.sym_shndx		= sym32_shndx,
+		};
+
+		e = efuncs;
+		long_size		= 4;
+		extable_ent_size	= 8;
+
 		if (r2(&ehdr->e32.e_ehsize) != sizeof(Elf32_Ehdr) ||
 		    r2(&ehdr->e32.e_shentsize) != sizeof(Elf32_Shdr)) {
 			fprintf(stderr,
@@ -872,26 +945,32 @@ static int do_file(char const *const fna
 			return -1;
 		}
 
-		compare_extable		= compare_extable_32;
-		ehdr_shoff		= ehdr32_shoff;
-		ehdr_shentsize		= ehdr32_shentsize;
-		ehdr_shstrndx		= ehdr32_shstrndx;
-		ehdr_shnum		= ehdr32_shnum;
-		shdr_addr		= shdr32_addr;
-		shdr_offset		= shdr32_offset;
-		shdr_link		= shdr32_link;
-		shdr_size		= shdr32_size;
-		shdr_name		= shdr32_name;
-		shdr_type		= shdr32_type;
-		shdr_entsize		= shdr32_entsize;
-		sym_type		= sym32_type;
-		sym_name		= sym32_name;
-		sym_value		= sym32_value;
-		sym_shndx		= sym32_shndx;
-		long_size		= 4;
-		extable_ent_size	= 8;
+		}
 		break;
-	case ELFCLASS64:
+	case ELFCLASS64: {
+		struct elf_funcs efuncs = {
+			.compare_extable	= compare_extable_64,
+			.ehdr_shoff		= ehdr64_shoff,
+			.ehdr_shentsize		= ehdr64_shentsize,
+			.ehdr_shstrndx		= ehdr64_shstrndx,
+			.ehdr_shnum		= ehdr64_shnum,
+			.shdr_addr		= shdr64_addr,
+			.shdr_offset		= shdr64_offset,
+			.shdr_link		= shdr64_link,
+			.shdr_size		= shdr64_size,
+			.shdr_name		= shdr64_name,
+			.shdr_type		= shdr64_type,
+			.shdr_entsize		= shdr64_entsize,
+			.sym_type		= sym64_type,
+			.sym_name		= sym64_name,
+			.sym_value		= sym64_value,
+			.sym_shndx		= sym64_shndx,
+		};
+
+		e = efuncs;
+		long_size		= 8;
+		extable_ent_size	= 16;
+
 		if (r2(&ehdr->e64.e_ehsize) != sizeof(Elf64_Ehdr) ||
 		    r2(&ehdr->e64.e_shentsize) != sizeof(Elf64_Shdr)) {
 			fprintf(stderr,
@@ -900,25 +979,7 @@ static int do_file(char const *const fna
 			return -1;
 		}
 
-		compare_extable		= compare_extable_64;
-		ehdr_shoff		= ehdr64_shoff;
-		ehdr_shentsize		= ehdr64_shentsize;
-		ehdr_shstrndx		= ehdr64_shstrndx;
-		ehdr_shnum		= ehdr64_shnum;
-		shdr_addr		= shdr64_addr;
-		shdr_offset		= shdr64_offset;
-		shdr_link		= shdr64_link;
-		shdr_size		= shdr64_size;
-		shdr_name		= shdr64_name;
-		shdr_type		= shdr64_type;
-		shdr_entsize		= shdr64_entsize;
-		sym_type		= sym64_type;
-		sym_name		= sym64_name;
-		sym_value		= sym64_value;
-		sym_shndx		= sym64_shndx;
-		long_size		= 8;
-		extable_ent_size	= 16;
-
+		}
 		break;
 	default:
 		fprintf(stderr, "unrecognized ELF class %d %s\n",


