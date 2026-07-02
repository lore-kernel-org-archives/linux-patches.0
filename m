Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE63346FB0;
	Thu,  2 Jul 2026 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010423; cv=none; b=UkfMC2lZfPRz8HDtuArveIwuWOJv73RjVQvizGSv/ZCZxH5KsGVAyTATfxD6rbG4CXiMB3kkOK1oJXPOlJNSDR8iK0P6kvqPP5thtw13hu8eC+2k3TvLxQmWLfX+yVwqNGWeX3Hjcem0r3PX4oEdtHyi4m2aEs6WrDZozut9Zn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010423; c=relaxed/simple;
	bh=Jkt3RZj7l+YOTr2S1r4d33EV9/LLyf1/v7sO5sruenk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3Ik+vzEjtb62NJstXMs7nCC+f62rOacuDAfHOTQ5mTiE5gsBgzzU4LeT67ePGZZ/zpfTtm8k1QijKhK5/5P6JLrmYXFORAR9XIURCOaj37vqU78qqlFbJ8S47f9JwVR9uLmaBsI6J4R7Jd2CSI99DQ9eJGM2oF1FruydCG7XxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qh01nPGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qh01nPGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057671F000E9;
	Thu,  2 Jul 2026 16:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010421;
	bh=dr51g1tmut50fa7VAgz6AUDzqcdDGLDv33ySpzniSYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qh01nPGCElVUURYeaX6vm3mOLUa+Dup8BEuFce6o0ltxFQQseqvMzek+8jZkm7Ehk
	 gb3QL3d9rhsEJy6HzdsxbxSD2yNFy4ABElbxpIm3Bbo7yNNku708kx7GSep/52afNB
	 ODXr1kl+hwRKOi6uOIGiUL4lM7ophqlDUVEa8yxc=
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
Subject: [PATCH 6.12 066/204] scripts/sorttable: Add helper functions for Elf_Shdr
Date: Thu,  2 Jul 2026 18:18:43 +0200
Message-ID: <20260702155120.046932949@linuxfoundation.org>
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

[ Upstream commit 67afb7f504400e5b4e5ff895459fbb3eb63d4450 ]

In order to remove the double #include of sorttable.h for 64 and 32 bit
to create duplicate functions, add helper functions for Elf_Shdr.  This
will create a function pointer for each helper that will get assigned to
the appropriate function to handle either the 64bit or 32bit version.

This also moves the _r()/r() wrappers for the Elf_Shdr references that
handle endian and size differences between the different architectures,
into the helper function and out of the open code which is more error
prone.

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
Link: https://lore.kernel.org/20250105162345.940924221@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |   42 +++++++++++++++++++++++++++++++++
 scripts/sorttable.h |   66 +++++++++++++++++++++++++++++++++-------------------
 2 files changed, 85 insertions(+), 23 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -110,6 +110,48 @@ EHDR_HALF(shentsize)
 EHDR_HALF(shstrndx)
 EHDR_HALF(shnum)
 
+#define SHDR_WORD(fn_name)				\
+static uint32_t shdr64_##fn_name(Elf_Shdr *shdr)	\
+{							\
+	return r(&shdr->e64.sh_##fn_name);		\
+}							\
+							\
+static uint32_t shdr32_##fn_name(Elf_Shdr *shdr)	\
+{							\
+	return r(&shdr->e32.sh_##fn_name);		\
+}
+
+#define SHDR_ADDR(fn_name)				\
+static uint64_t shdr64_##fn_name(Elf_Shdr *shdr)	\
+{							\
+	return r8(&shdr->e64.sh_##fn_name);		\
+}							\
+							\
+static uint64_t shdr32_##fn_name(Elf_Shdr *shdr)	\
+{							\
+	return r(&shdr->e32.sh_##fn_name);		\
+}
+
+#define SHDR_WORD(fn_name)				\
+static uint32_t shdr64_##fn_name(Elf_Shdr *shdr)	\
+{							\
+	return r(&shdr->e64.sh_##fn_name);		\
+}							\
+							\
+static uint32_t shdr32_##fn_name(Elf_Shdr *shdr)	\
+{							\
+	return r(&shdr->e32.sh_##fn_name);		\
+}
+
+SHDR_ADDR(addr)
+SHDR_ADDR(offset)
+SHDR_ADDR(size)
+SHDR_ADDR(entsize)
+
+SHDR_WORD(link)
+SHDR_WORD(name)
+SHDR_WORD(type)
+
 /*
  * Get the whole file as a programming convenience in order to avoid
  * malloc+lseek+read+free of many pieces.  If successful, then mmap
--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -31,6 +31,13 @@
 #undef ehdr_shentsize
 #undef ehdr_shstrndx
 #undef ehdr_shnum
+#undef shdr_addr
+#undef shdr_offset
+#undef shdr_link
+#undef shdr_size
+#undef shdr_name
+#undef shdr_type
+#undef shdr_entsize
 
 #ifdef SORTTABLE_64
 # define extable_ent_size	16
@@ -47,6 +54,13 @@
 # define ehdr_shentsize		ehdr64_shentsize
 # define ehdr_shstrndx		ehdr64_shstrndx
 # define ehdr_shnum		ehdr64_shnum
+# define shdr_addr		shdr64_addr
+# define shdr_offset		shdr64_offset
+# define shdr_link		shdr64_link
+# define shdr_size		shdr64_size
+# define shdr_name		shdr64_name
+# define shdr_type		shdr64_type
+# define shdr_entsize		shdr64_entsize
 #else
 # define extable_ent_size	8
 # define compare_extable	compare_extable_32
@@ -62,6 +76,13 @@
 # define ehdr_shentsize		ehdr32_shentsize
 # define ehdr_shstrndx		ehdr32_shstrndx
 # define ehdr_shnum		ehdr32_shnum
+# define shdr_addr		shdr32_addr
+# define shdr_offset		shdr32_offset
+# define shdr_link		shdr32_link
+# define shdr_size		shdr32_size
+# define shdr_name		shdr32_name
+# define shdr_type		shdr32_type
+# define shdr_entsize		shdr32_entsize
 #endif
 
 #if defined(SORTTABLE_64) && defined(UNWINDER_ORC_ENABLED)
@@ -177,8 +198,8 @@ struct elf_mcount_loc {
 static void *sort_mcount_loc(void *arg)
 {
 	struct elf_mcount_loc *emloc = (struct elf_mcount_loc *)arg;
-	uint_t offset = emloc->start_mcount_loc - _r(&(emloc->init_data_sec)->etype.sh_addr)
-					+ _r(&(emloc->init_data_sec)->etype.sh_offset);
+	uint_t offset = emloc->start_mcount_loc - shdr_addr(emloc->init_data_sec)
+					+ shdr_offset(emloc->init_data_sec);
 	uint_t count = emloc->stop_mcount_loc - emloc->start_mcount_loc;
 	unsigned char *start_loc = (void *)emloc->ehdr + offset;
 
@@ -267,18 +288,18 @@ static int do_sort(Elf_Ehdr *ehdr,
 
 	shstrndx = ehdr_shstrndx(ehdr);
 	if (shstrndx == SHN_XINDEX)
-		shstrndx = r(&shdr_start->etype.sh_link);
+		shstrndx = shdr_link(shdr_start);
 	string_sec = get_index(shdr_start, shentsize, shstrndx);
-	secstrings = (const char *)ehdr + _r(&string_sec->etype.sh_offset);
+	secstrings = (const char *)ehdr + shdr_offset(string_sec);
 
 	shnum = ehdr_shnum(ehdr);
 	if (shnum == SHN_UNDEF)
-		shnum = _r(&shdr_start->etype.sh_size);
+		shnum = shdr_size(shdr_start);
 
 	for (i = 0; i < shnum; i++) {
 		Elf_Shdr *shdr = get_index(shdr_start, shentsize, i);
 
-		idx = r(&shdr->etype.sh_name);
+		idx = shdr_name(shdr);
 		if (!strcmp(secstrings + idx, "__ex_table"))
 			extab_sec = shdr;
 		if (!strcmp(secstrings + idx, ".symtab"))
@@ -286,9 +307,9 @@ static int do_sort(Elf_Ehdr *ehdr,
 		if (!strcmp(secstrings + idx, ".strtab"))
 			strtab_sec = shdr;
 
-		if (r(&shdr->etype.sh_type) == SHT_SYMTAB_SHNDX)
+		if (shdr_type(shdr) == SHT_SYMTAB_SHNDX)
 			symtab_shndx = (Elf32_Word *)((const char *)ehdr +
-						      _r(&shdr->etype.sh_offset));
+						      shdr_offset(shdr));
 
 #ifdef MCOUNT_SORT_ENABLED
 		/* locate the .init.data section in vmlinux */
@@ -304,14 +325,14 @@ static int do_sort(Elf_Ehdr *ehdr,
 #if defined(SORTTABLE_64) && defined(UNWINDER_ORC_ENABLED)
 		/* locate the ORC unwind tables */
 		if (!strcmp(secstrings + idx, ".orc_unwind_ip")) {
-			orc_ip_size = _r(&shdr->etype.sh_size);
+			orc_ip_size = shdr_size(shdr);
 			g_orc_ip_table = (int *)((void *)ehdr +
-						   _r(&shdr->etype.sh_offset));
+						   shdr_offset(shdr));
 		}
 		if (!strcmp(secstrings + idx, ".orc_unwind")) {
-			orc_size = _r(&shdr->etype.sh_size);
+			orc_size = shdr_size(shdr);
 			g_orc_table = (struct orc_entry *)((void *)ehdr +
-							     _r(&shdr->etype.sh_offset));
+							     shdr_offset(shdr));
 		}
 #endif
 	} /* for loop */
@@ -374,23 +395,22 @@ static int do_sort(Elf_Ehdr *ehdr,
 		goto out;
 	}
 
-	extab_image = (void *)ehdr + _r(&extab_sec->etype.sh_offset);
-	strtab = (const char *)ehdr + _r(&strtab_sec->etype.sh_offset);
-	symtab = (const Elf_Sym *)((const char *)ehdr +
-						  _r(&symtab_sec->etype.sh_offset));
+	extab_image = (void *)ehdr + shdr_offset(extab_sec);
+	strtab = (const char *)ehdr + shdr_offset(strtab_sec);
+	symtab = (const Elf_Sym *)((const char *)ehdr + shdr_offset(symtab_sec));
 
 	if (custom_sort) {
-		custom_sort(extab_image, _r(&extab_sec->etype.sh_size));
+		custom_sort(extab_image, shdr_size(extab_sec));
 	} else {
-		int num_entries = _r(&extab_sec->etype.sh_size) / extable_ent_size;
+		int num_entries = shdr_size(extab_sec) / extable_ent_size;
 		qsort(extab_image, num_entries,
 		      extable_ent_size, compare_extable);
 	}
 
 	/* find the flag main_extable_sort_needed */
-	sym_start = (void *)ehdr + _r(&symtab_sec->etype.sh_offset);
-	sym_end = sym_start + _r(&symtab_sec->etype.sh_size);
-	symentsize = _r(&symtab_sec->etype.sh_entsize);
+	sym_start = (void *)ehdr + shdr_offset(symtab_sec);
+	sym_end = sym_start + shdr_size(symtab_sec);
+	symentsize = shdr_entsize(symtab_sec);
 
 	for (sym = sym_start; (void *)sym + symentsize < sym_end;
 	     sym = (void *)sym + symentsize) {
@@ -415,9 +435,9 @@ static int do_sort(Elf_Ehdr *ehdr,
 				       symtab_shndx);
 	sort_needed_sec = get_index(shdr_start, shentsize, sort_need_index);
 	sort_needed_loc = (void *)ehdr +
-		_r(&sort_needed_sec->etype.sh_offset) +
+		shdr_offset(sort_needed_sec) +
 		_r(&sort_needed_sym->etype.st_value) -
-		_r(&sort_needed_sec->etype.sh_addr);
+		shdr_addr(sort_needed_sec);
 
 	/* extable has been sorted, clear the flag */
 	w(0, sort_needed_loc);


