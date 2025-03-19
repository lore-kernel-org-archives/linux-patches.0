Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C965C1B2194;
	Wed, 19 Mar 2025 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394901; cv=none; b=VKzI9k7wBdwpIY9H2Kk3QVB4RpS/api4CEOXJSX0w/1qBBQIl+sE7Nadk8pbp5mk4J6opPzcPfANT1Up6nWScxzbJT1lTBcAt9s0Nkxj/+U+5vpComNx/DNUdoN/3I8iBuuSEJMa49lqocrZqT05maPtm8teptBeDGvuTDkJKHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394901; c=relaxed/simple;
	bh=iq2MwUsQfJsUmkGk1fPY2VOtzjTn6EJkYKfWfqZosww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6m5OtI22dukHzXxoajMUdpj3wDVRb3dI02yWzZ/HRKpzCIPw6U3MpS8/Y9strsRGGEHKzMWznaTHX39AYbDpMvCAwsPAIIaswkBDN4oMA+sr5eJ607qSW2ESczUJdzIDv4v6HMOaQfYLYrB8nFbMEnOuCT+W/NxYHP+GF8U/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nThvSc5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nThvSc5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B178C4CEE4;
	Wed, 19 Mar 2025 14:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394901;
	bh=iq2MwUsQfJsUmkGk1fPY2VOtzjTn6EJkYKfWfqZosww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nThvSc5Tss8Znvm34FOaVOmY2JRQZTxAXQL/mtO/NMUAJsZc2A0pomPUrdoF0/Akg
	 /mrztfC9buPH1NG9RXh1Q1ilouQD1nnhQkhTEaK0Lsh5ZbKU3ySuJWeH5v7bdEyHpw
	 kNPxXsxtRBwsRB2s62xUKd632nXZs4g6ePXNszc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 070/241] kbuild: keep symbols for symbol_get() even with CONFIG_TRIM_UNUSED_KSYMS
Date: Wed, 19 Mar 2025 07:29:00 -0700
Message-ID: <20250319143029.457845706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4c56eb33e603c3b9eb4bd24efbfdd0283c1c37e4 ]

Linus observed that the symbol_request(utf8_data_table) call fails when
CONFIG_UNICODE=y and CONFIG_TRIM_UNUSED_KSYMS=y.

symbol_get() relies on the symbol data being present in the ksymtab for
symbol lookups. However, EXPORT_SYMBOL_GPL(utf8_data_table) is dropped
due to CONFIG_TRIM_UNUSED_KSYMS, as no module references it in this case.

Probably, this has been broken since commit dbacb0ef670d ("kconfig option
for TRIM_UNUSED_KSYMS").

This commit addresses the issue by leveraging modpost. Symbol names
passed to symbol_get() are recorded in the special .no_trim_symbol
section, which is then parsed by modpost to forcibly keep such symbols.
The .no_trim_symbol section is discarded by the linker scripts, so there
is no impact on the size of the final vmlinux or modules.

This commit cannot resolve the issue for direct calls to __symbol_get()
because the symbol name is not known at compile-time.

Although symbol_get() may eventually be deprecated, this workaround
should be good enough meanwhile.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  1 +
 include/linux/module.h            |  5 ++++-
 scripts/mod/modpost.c             | 35 +++++++++++++++++++++++++++++++
 scripts/mod/modpost.h             |  6 ++++++
 scripts/module.lds.S              |  1 +
 5 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 337d3336e1756..0d5b186abee86 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1038,6 +1038,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	*(.discard)							\
 	*(.discard.*)							\
 	*(.export_symbol)						\
+	*(.no_trim_symbol)						\
 	*(.modinfo)							\
 	/* ld.bfd warns about .gnu.version* even when not emitted */	\
 	*(.gnu.version*)						\
diff --git a/include/linux/module.h b/include/linux/module.h
index b3a6434353579..541e4357ea2f1 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -306,7 +306,10 @@ extern int modules_disabled; /* for sysctl */
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
-#define symbol_get(x) ((typeof(&x))(__symbol_get(__stringify(x))))
+#define symbol_get(x)	({ \
+	static const char __notrim[] \
+		__used __section(".no_trim_symbol") = __stringify(x); \
+	(typeof(&x))(__symbol_get(__stringify(x))); })
 
 /* modules using other modules: kdb wants to see this. */
 struct module_use {
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7ea59dc4926b3..967d698e0c924 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -503,6 +503,9 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->modinfo_len = sechdrs[i].sh_size;
 		} else if (!strcmp(secname, ".export_symbol")) {
 			info->export_symbol_secndx = i;
+		} else if (!strcmp(secname, ".no_trim_symbol")) {
+			info->no_trim_symbol = (void *)hdr + sechdrs[i].sh_offset;
+			info->no_trim_symbol_len = sechdrs[i].sh_size;
 		}
 
 		if (sechdrs[i].sh_type == SHT_SYMTAB) {
@@ -1562,6 +1565,14 @@ static void read_symbols(const char *modname)
 	/* strip trailing .o */
 	mod = new_module(modname, strlen(modname) - strlen(".o"));
 
+	/* save .no_trim_symbol section for later use */
+	if (info.no_trim_symbol_len) {
+		mod->no_trim_symbol = xmalloc(info.no_trim_symbol_len);
+		memcpy(mod->no_trim_symbol, info.no_trim_symbol,
+		       info.no_trim_symbol_len);
+		mod->no_trim_symbol_len = info.no_trim_symbol_len;
+	}
+
 	if (!mod->is_vmlinux) {
 		license = get_modinfo(&info, "license");
 		if (!license)
@@ -1724,6 +1735,28 @@ static void handle_white_list_exports(const char *white_list)
 	free(buf);
 }
 
+/*
+ * Keep symbols recorded in the .no_trim_symbol section. This is necessary to
+ * prevent CONFIG_TRIM_UNUSED_KSYMS from dropping EXPORT_SYMBOL because
+ * symbol_get() relies on the symbol being present in the ksymtab for lookups.
+ */
+static void keep_no_trim_symbols(struct module *mod)
+{
+	unsigned long size = mod->no_trim_symbol_len;
+
+	for (char *s = mod->no_trim_symbol; s; s = next_string(s , &size)) {
+		struct symbol *sym;
+
+		/*
+		 * If find_symbol() returns NULL, this symbol is not provided
+		 * by any module, and symbol_get() will fail.
+		 */
+		sym = find_symbol(s);
+		if (sym)
+			sym->used = true;
+	}
+}
+
 static void check_modname_len(struct module *mod)
 {
 	const char *mod_name;
@@ -2195,6 +2228,8 @@ int main(int argc, char **argv)
 		read_symbols_from_files(files_source);
 
 	list_for_each_entry(mod, &modules, list) {
+		keep_no_trim_symbols(mod);
+
 		if (mod->dump_file || mod->is_vmlinux)
 			continue;
 
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index ffd0a52a606ef..59366f456b765 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -111,6 +111,8 @@ struct module_alias {
  *
  * @dump_file: path to the .symvers file if loaded from a file
  * @aliases: list head for module_aliases
+ * @no_trim_symbol: .no_trim_symbol section data
+ * @no_trim_symbol_len: length of the .no_trim_symbol section
  */
 struct module {
 	struct list_head list;
@@ -128,6 +130,8 @@ struct module {
 	// Actual imported namespaces
 	struct list_head imported_namespaces;
 	struct list_head aliases;
+	char *no_trim_symbol;
+	unsigned int no_trim_symbol_len;
 	char name[];
 };
 
@@ -141,6 +145,8 @@ struct elf_info {
 	char         *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
+	char         *no_trim_symbol;
+	unsigned int no_trim_symbol_len;
 
 	/* support for 32bit section numbers */
 
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index c2f80f9141d40..450f1088d5fd3 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -16,6 +16,7 @@ SECTIONS {
 		*(.discard)
 		*(.discard.*)
 		*(.export_symbol)
+		*(.no_trim_symbol)
 	}
 
 	__ksymtab		0 : ALIGN(8) { *(SORT(___ksymtab+*)) }
-- 
2.39.5



