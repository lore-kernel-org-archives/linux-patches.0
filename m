Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20AE46AA71;
	Tue, 21 Jul 2026 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648393; cv=none; b=G9XfftNLRDcJ//RKaCY9LCklgpAHe6+MyGnt3rMN13sqMvdgqSWHO7fcIKO4guQW3N/1D6Lhs7+RW5PTHIoPGGFIsto2WzRnClq8qxZWPyh7meCUSUj+vt9cT2EHZKpTh7VyFTTZujJ8OxspVgmPgfYgOa2snNhfS59m8jlIKm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648393; c=relaxed/simple;
	bh=Vj5MSp+dxzdJpdvdl9e/pRS6pqwGxLHe5Y01x3r8rb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMhnqgM89mw8SpUiTwIWmGtAHvxaekNdGyRi4e3CXIe/81EP++lYECZWTnugzqMUlgHJA+A05tzk9Q0BaKYEoYdudi16KIrl9j9Ot2SiDwfFXBdG2NsKhdNB50dp4feX3X03oLqR4lhq5dl6A2WRnNhpD/1FusHGLR4FabHWqFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6+RX3C0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6+RX3C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2334C1F00A3A;
	Tue, 21 Jul 2026 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648391;
	bh=H+Mgvg5oPw5tViipLvWz71Bi/Bnfvei85q9Pd0q3pE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6+RX3C0QXyqE8vt+zZVsN2+BCOU/3L5hUkhzXwhvbP0wdDBYg7oth1/N3RyTIksE
	 AREE9avnZvIpoUQeAqEcER/guHBGgBZo7ReUgSF/Ax3dnqA6SGxYGrs6mGOnv+X1BS
	 1m77ag1Dyl3kH+ecVqiyaKBAzYSmlPVdvji7Hbz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0128/2077] objtool: Replace iterator callback with for_each_sym_by_mangled_name()
Date: Tue, 21 Jul 2026 16:56:41 +0200
Message-ID: <20260721152555.715058205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 0333b7399587ee0aaa863ed0d13a00a6c7c64068 ]

Convert the callback-based iterate_sym_by_demangled_name() with a new
for_each_sym_by_demangled_name() macro.  This eliminates the callback
struct/function and makes the code more compact and readable.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Stable-dep-of: a375e327b63e ("objtool: Fix reloc hash collision in find_reloc_by_dest_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c                 | 68 ++++++++---------------------
 tools/objtool/include/objtool/elf.h | 32 ++++++++++++--
 tools/objtool/klp-diff.c            | 42 ++++++------------
 3 files changed, 60 insertions(+), 82 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index f3df2bde119fc4..dc39132f71c148 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -27,27 +27,16 @@
 
 static ssize_t demangled_name_len(const char *name);
 
-static inline u32 str_hash(const char *str)
-{
-	return jhash(str, strlen(str), 0);
-}
-
-static inline u32 str_hash_demangled(const char *str)
+u32 str_hash_demangled(const char *str)
 {
 	return jhash(str, demangled_name_len(str), 0);
 }
 
-#define __elf_table(name)	(elf->name##_hash)
-#define __elf_bits(name)	(elf->name##_bits)
-
-#define __elf_table_entry(name, key) \
-	__elf_table(name)[hash_min(key, __elf_bits(name))]
-
 #define elf_hash_add(name, node, key)					\
 ({									\
 	struct elf_hash_node *__node = node;				\
-	__node->next = __elf_table_entry(name, key);			\
-	__elf_table_entry(name, key) = __node;				\
+	__node->next = __elf_table_entry(elf, name, key);		\
+	__elf_table_entry(elf, name, key) = __node;			\
 })
 
 static inline void __elf_hash_del(struct elf_hash_node *node,
@@ -69,30 +58,20 @@ static inline void __elf_hash_del(struct elf_hash_node *node,
 }
 
 #define elf_hash_del(name, node, key) \
-	__elf_hash_del(node, &__elf_table_entry(name, key))
-
-#define elf_list_entry(ptr, type, member)				\
-({									\
-	typeof(ptr) __ptr = (ptr);					\
-	__ptr ? container_of(__ptr, type, member) : NULL;		\
-})
-
-#define elf_hash_for_each_possible(name, obj, member, key)		\
-	for (obj = elf_list_entry(__elf_table_entry(name, key), typeof(*obj), member); \
-	     obj;							\
-	     obj = elf_list_entry(obj->member.next, typeof(*(obj)), member))
+	__elf_hash_del(node, &__elf_table_entry(elf, name, key))
 
 #define elf_alloc_hash(name, size)					\
 ({									\
-	__elf_bits(name) = max(10, ilog2(size));			\
-	__elf_table(name) = mmap(NULL, sizeof(struct elf_hash_node *) << __elf_bits(name), \
+	__elf_bits(elf, name) = max(10, ilog2(size));			\
+	__elf_table(elf, name) = mmap(NULL,				\
+				 sizeof(struct elf_hash_node *) << __elf_bits(elf, name), \
 				 PROT_READ|PROT_WRITE,			\
 				 MAP_PRIVATE|MAP_ANON, -1, 0);		\
-	if (__elf_table(name) == (void *)-1L) {				\
+	if (__elf_table(elf, name) == (void *)-1L) {			\
 		ERROR_GLIBC("mmap fail " #name);			\
-		__elf_table(name) = NULL;				\
+		__elf_table(elf, name) = NULL;				\
 	}								\
-	__elf_table(name);						\
+	__elf_table(elf, name);						\
 })
 
 static inline unsigned long __sym_start(struct symbol *s)
@@ -141,7 +120,7 @@ struct section *find_section_by_name(const struct elf *elf, const char *name)
 {
 	struct section *sec;
 
-	elf_hash_for_each_possible(section_name, sec, name_hash, str_hash(name)) {
+	elf_hash_for_each_possible(elf, section_name, sec, name_hash, str_hash(name)) {
 		if (!strcmp(sec->name, name))
 			return sec;
 	}
@@ -154,7 +133,7 @@ static struct section *find_section_by_index(struct elf *elf,
 {
 	struct section *sec;
 
-	elf_hash_for_each_possible(section, sec, hash, idx) {
+	elf_hash_for_each_possible(elf, section, sec, hash, idx) {
 		if (sec->idx == idx)
 			return sec;
 	}
@@ -166,7 +145,7 @@ static struct symbol *find_symbol_by_index(struct elf *elf, unsigned int idx)
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol, sym, hash, idx) {
+	elf_hash_for_each_possible(elf, symbol, sym, hash, idx) {
 		if (sym->idx == idx)
 			return sym;
 	}
@@ -285,7 +264,7 @@ struct symbol *find_symbol_by_name(const struct elf *elf, const char *name)
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(name)) {
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash, str_hash(name)) {
 		if (!strcmp(sym->name, name))
 			return sym;
 	}
@@ -300,7 +279,7 @@ static struct symbol *find_local_symbol_by_file_and_name(const struct elf *elf,
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash_demangled(name)) {
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash, str_hash_demangled(name)) {
 		if (sym->bind == STB_LOCAL && sym->file == file &&
 		    !strcmp(sym->name, name)) {
 			return sym;
@@ -314,7 +293,7 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash_demangled(name)) {
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash, str_hash_demangled(name)) {
 		if (!strcmp(sym->name, name) && !is_local_sym(sym))
 			return sym;
 	}
@@ -322,19 +301,6 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
-void iterate_global_symbol_by_demangled_name(const struct elf *elf,
-					     const char *demangled_name,
-					     void (*process)(struct symbol *sym, void *data),
-					     void *data)
-{
-	struct symbol *sym;
-
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
-		if (!strcmp(sym->demangled_name, demangled_name) && !is_local_sym(sym))
-			process(sym, data);
-	}
-}
-
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
@@ -347,7 +313,7 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
 		return NULL;
 
 	for_offset_range(o, offset, offset + len) {
-		elf_hash_for_each_possible(reloc, reloc, hash,
+		elf_hash_for_each_possible(elf, reloc, reloc, hash,
 					   sec_offset_hash(rsec, o)) {
 			if (reloc->sec != rsec)
 				continue;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 25573e5af76efe..b142984eb9b5a7 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -21,6 +21,13 @@
 #define SEC_NAME_LEN		1024
 #define SYM_NAME_LEN		512
 
+static inline u32 str_hash(const char *str)
+{
+	return jhash(str, strlen(str), 0);
+}
+
+u32 str_hash_demangled(const char *str);
+
 #define bswap_if_needed(elf, val) __bswap_if_needed(&elf->ehdr, val)
 
 #ifdef LIBELF_USE_DEPRECATED
@@ -130,6 +137,23 @@ struct elf {
 	struct symbol *symbol_data;
 };
 
+#define __elf_table(elf, name)	((elf)->name##_hash)
+#define __elf_bits(elf, name)	((elf)->name##_bits)
+
+#define __elf_table_entry(elf, name, key) \
+	__elf_table(elf, name)[hash_min(key, __elf_bits(elf, name))]
+
+#define elf_list_entry(ptr, type, member)				\
+({									\
+	typeof(ptr) __ptr = (ptr);					\
+	__ptr ? container_of(__ptr, type, member) : NULL;		\
+})
+
+#define elf_hash_for_each_possible(elf, name, obj, member, key)		\
+	for (obj = elf_list_entry(__elf_table_entry(elf, name, key), typeof(*obj), member); \
+	     obj;							\
+	     obj = elf_list_entry(obj->member.next, typeof(*(obj)), member))
+
 struct elf *elf_open_read(const char *name, int flags);
 struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name);
 
@@ -186,9 +210,6 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
-void iterate_global_symbol_by_demangled_name(const struct elf *elf, const char *demangled_name,
-					     void (*process)(struct symbol *sym, void *data),
-					     void *data);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
@@ -468,6 +489,11 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define for_each_sym_continue(elf, sym)					\
 	list_for_each_entry_continue(sym, &elf->symbols, global_list)
 
+#define for_each_sym_by_demangled_name(elf, name, sym)			\
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash,	\
+				   str_hash(name))			\
+		if (strcmp(sym->demangled_name, name)) {} else
+
 #define rsec_next_reloc(rsec, reloc)					\
 	reloc_idx(reloc) < sec_num_entries(rsec) - 1 ? reloc + 1 : NULL
 
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ef038f13366678..d0b3d1eef05215 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -46,11 +46,6 @@ static const struct option klp_diff_options[] = {
 
 static DEFINE_HASHTABLE(exports, 15);
 
-static inline u32 str_hash(const char *str)
-{
-	return jhash(str, strlen(str), 0);
-}
-
 static char *escape_str(const char *orig)
 {
 	size_t len = 0;
@@ -370,22 +365,6 @@ static bool dont_correlate(struct symbol *sym)
 	       strstarts(sym->name, "__initcall__");
 }
 
-struct process_demangled_name_data {
-	struct symbol *ret;
-	int count;
-};
-
-static void process_demangled_name(struct symbol *sym, void *d)
-{
-	struct process_demangled_name_data *data = d;
-
-	if (sym->twin)
-		return;
-
-	data->count++;
-	data->ret = sym;
-}
-
 /*
  * When there is no full name match, try match demangled_name. This would
  * match original foo.llvm.123 to patched foo.llvm.456.
@@ -397,16 +376,23 @@ static void process_demangled_name(struct symbol *sym, void *d)
 static int find_global_symbol_by_demangled_name(struct elf *elf, struct symbol *sym,
 						struct symbol **out_sym)
 {
-	struct process_demangled_name_data data = {};
+	struct symbol *sym2, *result = NULL;
+	int count = 0;
+
+	for_each_sym_by_demangled_name(elf, sym->demangled_name, sym2) {
+		if (is_local_sym(sym2) || sym2->twin)
+			continue;
 
-	iterate_global_symbol_by_demangled_name(elf, sym->demangled_name,
-						process_demangled_name,
-						&data);
-	if (data.count > 1) {
-		ERROR("Multiple (%d) correlation candidates for %s", data.count, sym->name);
+		count++;
+		result = sym2;
+	}
+
+	if (count > 1) {
+		ERROR("Multiple (%d) correlation candidates for %s", count, sym->name);
 		return -1;
 	}
-	*out_sym = data.ret;
+
+	*out_sym = result;
 	return 0;
 }
 
-- 
2.53.0



