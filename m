Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3E0364049;
	Sat, 12 Sep 2026 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201345; cv=none; b=gszuC5jHwCNEeUcPkSscc67W5ZYX/OqiarsY8apaHJa5s/B0crIHjhzUryxcrHxNiq4luFBWDYfbIYOGLaS9rn3JEurEW42Wm18NRk7wzoItXl2Fkv3zd2pX5iV8kOOAE/XNQE1fJKVUhFOgB7mXmqQrXdZKCVdpKU7QSLC8Yaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201345; c=relaxed/simple;
	bh=rcPAygXmhKB8apvUxiCZ7CTKUC/GCpCEysvp4EXNtxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4ASDE6fFQiLttH+RZrySZ5cWaHq2x5hikk7mBVCO7T0B3eajIMZSCCsM/NHa84O6PoxsV4ofOdRanFy+RanGJf+gNrYKqWiyyLCV4pBCdsKzenCE0eKS208g+OaOV6P2sh+Rmzb9n7aexbAG4Bo1a5vXd3t50D2vX+QwLeVdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUtdPrw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUtdPrw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CDD1F000FF;
	Sat, 12 Sep 2026 08:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201343;
	bh=Dax0gzxonW8VqMGxJEUTaefkIR61kZNer5MbQgXM9DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUtdPrw7SxDuWTF8axiVEWbW4Ah7i9JupfqgFZXVycYsGZbS/Q3vSz7skLqxABr3a
	 otkbeCzcwTMYp9E7NjFuborlXbkedm5SjN+f2TtEL5ZQ3ZTrxHDyDG5tOFClSRi2So
	 1YE9EIid9OF9i4W3icRP4Kyu5gZMWT6d/E5ZAKoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	live-patching@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0977/1815] objtool/klp: Add .klp.symid for sympos disambiguation
Date: Sat, 12 Sep 2026 08:45:27 +0200
Message-ID: <20260912065711.922342537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 029223d301620bc4e1086696047b0d5d6eba5edd ]

Livepatch identifies a duplicate-named symbol by its position (sympos)
among same-named kallsyms entries, which for vmlinux are counted in
ascending address order in the final linked kernel.  That order can't be
reliably derived from vmlinux.o: the final link reorders sub-sections
(.text.unlikely*, .data..*, etc).

Bridge the gap with a new .klp.symid section which can be used to
correlate symbols between vmlinux.o and vmlinux so that klp-diff can
reliably determine the sympos.

The table can't survive --gc-sections: keeping it alive would keep every
duplicate-named symbol's section alive, so the reference kernel would
stop matching the one which ships.  klp-build rejects
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION instead.  Nothing is lost today:
x86_64 is the only HAVE_KLP_BUILD arch and doesn't select
HAVE_LD_DEAD_CODE_DATA_ELIMINATION, arm64 and s390 have never selected
it either, and on powerpc, it's still EXPERIMENTAL and disabled by every
distro kernel.

This is the build-time half of reliable vmlinux sympos computation;
"objtool klp diff" will consume the table in a subsequent commit.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: live-patching@vger.kernel.org
Link: https://patch.msgid.link/64d50f077b569f47883c015cdb7079edb068efe8.1785727106.git.jpoimboe@kernel.org
Stable-dep-of: 15fa203ef91e ("objtool/klp: Fix symbol resolution for duplicate data symbols")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h       |  10 +-
 scripts/Makefile.vmlinux_o              |   3 +
 scripts/livepatch/klp-build             |   5 +
 scripts/mod/modpost.c                   |   1 +
 tools/objtool/Build                     |   1 +
 tools/objtool/builtin-check.c           |   7 ++
 tools/objtool/check.c                   |   7 ++
 tools/objtool/include/objtool/builtin.h |   1 +
 tools/objtool/include/objtool/klp.h     |  15 +++
 tools/objtool/klp-symid.c               | 117 ++++++++++++++++++++++++
 10 files changed, 166 insertions(+), 1 deletion(-)
 create mode 100644 tools/objtool/klp-symid.c

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5659f4b5a1252..ee9c5d354a856 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -839,12 +839,20 @@
 		.stab.index 0 : { *(.stab.index) }			\
 		.stab.indexstr 0 : { *(.stab.indexstr) }
 
+#ifdef CONFIG_KLP_BUILD
+#define KLP_SYMID							\
+		.klp.symid 0 : { *(.klp.symid) }
+#else
+#define KLP_SYMID
+#endif
+
 /* Required sections not related to debugging. */
 #define ELF_DETAILS							\
 		.comment 0 : { *(.comment) }				\
 		.symtab 0 : { *(.symtab) }				\
 		.strtab 0 : { *(.strtab) }				\
-		.shstrtab 0 : { *(.shstrtab) }
+		.shstrtab 0 : { *(.shstrtab) }				\
+		KLP_SYMID
 
 #define MODINFO								\
 		.modinfo : { *(.modinfo) . = ALIGN(8); }
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index 527352c222ff6..24a3a4fd271c2 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -47,6 +47,9 @@ endif
 vmlinux-objtool-args-$(CONFIG_NOINSTR_VALIDATION)	+= --noinstr \
 							   $(if $(or $(CONFIG_MITIGATION_UNRET_ENTRY),$(CONFIG_MITIGATION_SRSO)), --unret)
 
+# Only used for builds initiated by klp-build
+vmlinux-objtool-args-$(if $(KLP_SYMIDS),y)		+= --klp-symids
+
 objtool-args = $(vmlinux-objtool-args-y) --link
 
 # Link of vmlinux.o used for section mismatch analysis
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index c4a7acf8edc3f..d2b12fb68740b 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -271,6 +271,9 @@ validate_config() {
 	[[ -v CONFIG_GCC_PLUGIN_RANDSTRUCT ]] &&	\
 		die "kernel option 'CONFIG_GCC_PLUGIN_RANDSTRUCT' not supported"
 
+	[[ -v CONFIG_LD_DEAD_CODE_DATA_ELIMINATION ]] &&		\
+		die "kernel option 'CONFIG_LD_DEAD_CODE_DATA_ELIMINATION' not supported"
+
 	[[ -v CONFIG_AS_IS_LLVM ]] &&				\
 		[[ "$CONFIG_AS_VERSION" -lt 200000 ]] &&	\
 		die "Clang assembler version < 20 not supported"
@@ -555,6 +558,8 @@ build_kernel() {
 	#
 	cmd+=("KBUILD_MODPOST_WARN=1")
 
+	cmd+=("KLP_SYMIDS=1")
+
 	if [[ -v VERBOSE ]]; then
 		cmd+=("V=1")
 	else
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a7b72a81d2482..027944fe35b47 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -767,6 +767,7 @@ static const char *const section_white_list[] =
 	".llvm.call-graph-profile",	/* call graph */
 	"__llvm_covfun",
 	"__llvm_covmap",
+	".klp.symid",			/* objtool --klp-symids */
 	NULL
 };
 
diff --git a/tools/objtool/Build b/tools/objtool/Build
index 93a37b0dfd313..506f89bed808e 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -6,6 +6,7 @@ objtool-y += check.o
 objtool-y += special.o
 objtool-y += builtin-check.o
 objtool-y += elf.o
+objtool-y += klp-symid.o
 objtool-y += objtool.o
 
 objtool-$(BUILD_DISAS) += disas.o
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 118c3de2f293e..75b11dc85010e 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -76,6 +76,7 @@ static const struct option check_options[] = {
 	OPT_STRING_OPTARG('d',	 "disas", &opts.disas, "function-pattern", "disassemble functions", "*"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
 	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
+	OPT_BOOLEAN(0,		 "klp-symids", &opts.klp_symids, "generate .klp.symids for duplicate symbol disambiguation"),
 	OPT_BOOLEAN('m',	 "mcount", &opts.mcount, "annotate mcount/fentry calls for ftrace"),
 	OPT_BOOLEAN(0,		 "noabs", &opts.noabs, "reject absolute references in allocatable sections"),
 	OPT_BOOLEAN('n',	 "noinstr", &opts.noinstr, "validate noinstr rules"),
@@ -174,10 +175,16 @@ static bool opts_valid(void)
 		return false;
 	}
 
+	if (opts.klp_symids && !opts.link) {
+		ERROR("--klp-symids requires --link");
+		return false;
+	}
+
 	if (opts.disas			||
 	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
 	    opts.ibt			||
+	    opts.klp_symids		||
 	    opts.mcount			||
 	    opts.noabs			||
 	    opts.noinstr		||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3ab5b9f1c6a42..28cc2fed6f15e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -15,6 +15,7 @@
 #include <objtool/arch.h>
 #include <objtool/disas.h>
 #include <objtool/check.h>
+#include <objtool/klp.h>
 #include <objtool/special.h>
 #include <objtool/trace.h>
 #include <objtool/warn.h>
@@ -4925,6 +4926,12 @@ int check(struct objtool_file *file)
 			goto out;
 	}
 
+	if (opts.klp_symids) {
+		ret = klp_create_symid_sections(file);
+		if (ret)
+			goto out;
+	}
+
 	if (opts.noabs)
 		warnings += check_abs_references(file);
 
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index e844e9c82b7b2..349690bb1c50e 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -16,6 +16,7 @@ struct opts {
 	bool hack_noinstr;
 	bool hack_skylake;
 	bool ibt;
+	bool klp_symids;
 	bool mcount;
 	bool noabs;
 	bool noinstr;
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index aab6db42052dd..4d3c3bd462aa5 100644
--- a/tools/objtool/include/objtool/klp.h
+++ b/tools/objtool/include/objtool/klp.h
@@ -31,6 +31,21 @@ struct klp_reloc {
 	u32 type;
 };
 
+/*
+ * .klp.symid is used to correlate symbols between vmlinux.o and vmlinux, for
+ * calculating sympos to disambiguate duplicately-named symbols.
+ */
+#define KLP_SYMID_SEC	".klp.symid"
+
+struct klp_symid {
+	u64 id;
+	u64 addr;
+};
+
+struct objtool_file;
+
+int klp_create_symid_sections(struct objtool_file *file);
+
 int cmd_klp_checksum(int argc, const char **argv);
 int cmd_klp_diff(int argc, const char **argv);
 int cmd_klp_post_link(int argc, const char **argv);
diff --git a/tools/objtool/klp-symid.c b/tools/objtool/klp-symid.c
new file mode 100644
index 0000000000000..cf188cdfa6079
--- /dev/null
+++ b/tools/objtool/klp-symid.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Emit the .klp.symid table which allows "objtool klp diff" to reliably
+ * disambiguate duplicate-named local symbols in vmlinux.
+ *
+ * Livepatch identifies a duplicate-named symbol by its position (sympos)
+ * among the same-named kallsyms entries, counted in ascending address order
+ * in the final linked vmlinux.  That order can't be derived from vmlinux.o
+ * alone: the final link reorders sub-sections (.text.unlikely*, .data..*,
+ * etc).
+ *
+ * Bridge the gap with a table which survives the final link: a single
+ * non-alloc section containing an array of { id, addr } entries, where
+ * 'id' is a unique counter identifier and 'addr' has a relocation to the
+ * symbol.  The linker copies 'id' verbatim and resolves 'addr' to the symbol's
+ * final address.
+ *
+ * The table is only emitted for vmlinux.o, and only when klp-build asks for it
+ * with KLP_SYMIDS=1, which adds --klp-symids to the vmlinux.o objtool run.
+ *
+ * It can't survive --gc-sections, which sweeps the whole section; klp-build
+ * rejects CONFIG_LD_DEAD_CODE_DATA_ELIMINATION.
+ */
+#include <linux/string.h>
+
+#include <objtool/objtool.h>
+#include <objtool/warn.h>
+#include <objtool/endianness.h>
+#include <objtool/klp.h>
+
+static const char * const discarded_secs[] = {
+	".discard",
+	".modinfo",
+	"__tracepoint_check",
+};
+
+static bool discarded_sec(struct section *sec)
+{
+	if (!(sec->sh.sh_flags & SHF_ALLOC))
+		return true;
+
+	for (int i = 0; i < ARRAY_SIZE(discarded_secs); i++)
+		if (strstarts(sec->name, discarded_secs[i]))
+			return true;
+
+	return false;
+}
+
+static bool symid_needed(struct elf *elf, struct symbol *sym)
+{
+	struct symbol *s;
+
+	if (!is_local_sym(sym) || is_undef_sym(sym))
+		return false;
+
+	if (!is_func_sym(sym) && !is_object_sym(sym))
+		return false;
+
+	if (is_prefix_func(sym))
+		return false;
+
+	if (discarded_sec(sym->sec))
+		return false;
+
+	for_each_sym_by_name(elf, sym->name, s) {
+		if (s == sym || is_sec_sym(s) || is_file_sym(s) || is_undef_sym(s))
+			continue;
+		return true;
+	}
+
+	return false;
+}
+
+int klp_create_symid_sections(struct objtool_file *file)
+{
+	struct elf *elf = file->elf;
+	struct klp_symid *symids;
+	struct section *sec;
+	struct symbol *sym;
+	u64 nr = 0, i = 0;
+
+	if (!str_ends_with(objname, "vmlinux.o"))
+		return 0;
+
+	for_each_sym(elf, sym)
+		if (symid_needed(elf, sym))
+			nr++;
+
+	if (!nr)
+		return 0;
+
+	sec = elf_create_section(elf, KLP_SYMID_SEC, 0, sizeof(struct klp_symid),
+				 SHT_PROGBITS, 8, 0);
+	if (!sec)
+		return -1;
+
+	symids = elf_add_data(elf, sec, NULL, nr * sizeof(struct klp_symid));
+	if (!symids)
+		return -1;
+
+	for_each_sym(elf, sym) {
+		if (!symid_needed(elf, sym))
+			continue;
+
+		symids[i].id = bswap_if_needed(elf, i);
+
+		if (!elf_create_reloc(elf, sec,
+				      i * sizeof(struct klp_symid) +
+				      offsetof(struct klp_symid, addr),
+				      sym, 0, R_ABS64))
+			return -1;
+
+		i++;
+	}
+
+	return 0;
+}
-- 
2.53.0



