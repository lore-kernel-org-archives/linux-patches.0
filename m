Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4F2365A0B;
	Sat, 12 Sep 2026 09:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204001; cv=none; b=fcY/DgpG6BX/yPjP2SYAtqVyz3t94jhQrLxYW1qkY3hYBPN2WaGIRDtri6CwWgXTtBAgR27KpQyadzlaGt0q216v8gFyRUriZfIY0TuM+Q5lR3INnWum6qz04DyPN7D5kUl3Y9ZtoqSe5b4JwqkPH2nuHiEKPMVIYhssuSJAdk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204001; c=relaxed/simple;
	bh=q4cno2+uVlNDsKxk+Lrjute4yBawBKs5AdV7J/fj6qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO8QOFA/gAJQLUbIrXL2TtKDgk+GJdj8n5D16LJCw7RMNTCbgT6xzL7jg+gTHgRW3sHnt1+vnq7R9MsXTX7S3wPPStazF5VJPmDdtRzir0/HxIJ3gKo6nCykOG0wRdawexI+yJS80zZp8dLuee8d3NPRsbL5NQmR3fJat1LMa/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRzG6fFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRzG6fFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1721F000FF;
	Sat, 12 Sep 2026 09:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204000;
	bh=KofDF5Z1wlYecYJ3faMLUuGZZt1i+2bJKYhte03h3wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRzG6fFPGcqvgFAeRKbbLxTLZS6pYYM3QV4B41tbCc8Zv1uxBxKN4PT1hWPus7HDA
	 /kXOIEVH+GE91VZqrA1+BcXyZMJ0N14yJ99+FLO3J7btwCgGYnktNNO7fUjYpM9oFB
	 VORQRsJTUblMkKsJiLrF8KPfmUAXv1Un2hKu/hvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Hatch <dylanbhatch@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1524/1815] objtool/klp: Fix vmlinux klp relocations for EXPORT_SYMBOL_FOR_MODULES()
Date: Sat, 12 Sep 2026 08:54:34 +0200
Message-ID: <20260912065724.782458339@linuxfoundation.org>
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

[ Upstream commit d8a2860b4a366bfa8acb3d64da2c546ea26d2091 ]

When a module function references a vmlinux symbol which is exported
with EXPORT_SYMBOL_FOR_MODULES(), a patch to that function needs to use
a klp reloc.

Currently, livepatch fails to load such a module:

  livepatch: invalid access to vmlinux symbol 'get_task_policy' from module-specific livepatch relocation section
  livepatch: failed to initialize patch 'livepatch_test' for module 'testmod' (-22)
  livepatch: patch 'livepatch_test' failed for module 'testmod', refusing to load module 'testmod'

klp diff puts all klp relocs in __klp_relocs.<patched object>, so
post-link names the section .klp.rela.<patched object>.<secname>, which the
kernel rejects for vmlinux symbols.

Commit 07f14d6af9d77 ("objtool/klp: Fix cross-module klp relocation
section naming") changed the meaning of objname in the klp rela section
name to be where the referenced symbol is referenced rather than where
it lives.  That premise only holds for symbols in a module: the relocs
get applied when the patched module gets patched, and the module
dependency guarantees the referenced module is loaded by then.

A vmlinux symbol needs the opposite.  It's always resolvable, and it has
to be applied when the patch module loads, before the module loader
initializes the patch module's special sections, which may reference it.
That's why livepatch rejects vmlinux symbols in module-specific
sections.

Use "vmlinux" as the section objname when the referenced symbol lives in
vmlinux.  This moves such klp relocs from .klp.rela.kvm..text to
.klp.rela.vmlinux..text.

Fixes: 07f14d6af9d77 ("objtool/klp: Fix cross-module klp relocation section naming")
Reported-by: Dylan Hatch <dylanbhatch@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://patch.msgid.link/f8e3b9fae109903a6aafb2a33310e4afdcebf58e.1786761327.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/CADBMgpz7iWC0=t=_gE-tfvv0mTPq4kg0qQ2zgPH8DVPE6eQ9Kw@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/include/objtool/klp.h |  5 +++--
 tools/objtool/klp-diff.c            | 31 +++++++++++++++++++----------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index 646d8e1f12eff..c57775d78c71e 100644
--- a/tools/objtool/include/objtool/klp.h
+++ b/tools/objtool/include/objtool/klp.h
@@ -20,8 +20,9 @@
  * SHF_RELA_LIVEPATCH, nor does it support having two RELA sections for a
  * single PROGBITS section.
  *
- * "objname" is the name of the object being patched ("vmlinux" or a module
- * name).  post-link uses it to name the resulting
+ * "objname" is the object whose loading gates the relocation: "vmlinux" for
+ * references to vmlinux symbols, otherwise the name of the module being
+ * patched.  post-link uses it to name the resulting
  * .klp.rela.objname.section_name sections.
  */
 #define KLP_RELOCS_SEC	"__klp_relocs"
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ec2e7ae41767f..291ada0aa288d 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1320,13 +1320,14 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 			   struct section *sec, unsigned long offset,
 			   struct export *export)
 {
+	const char *sym_modname, *sym_orig_name, *sec_objname;
 	struct symbol *patched_sym = patched_reloc->sym;
 	s64 addend = reloc_addend(patched_reloc);
-	const char *sym_modname, *sym_orig_name;
-	static struct section *klp_relocs;
 	char tombstone_name[SYM_NAME_LEN];
 	struct symbol *sym, *klp_sym;
 	unsigned long klp_reloc_off;
+	struct section *klp_relocs;
+	char sec_name[SEC_NAME_LEN];
 	char sym_name[SYM_NAME_LEN];
 	struct klp_reloc klp_reloc;
 	unsigned long sympos;
@@ -1408,20 +1409,28 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 	 * This intermediate step is necessary to prevent corruption by the
 	 * linker, which doesn't know how to properly handle two rela sections
 	 * applying to the same base section.
+	 *
+	 * The objname decides when the reloc gets applied.  A reference to a
+	 * vmlinux symbol goes in the vmlinux section so it gets applied when
+	 * the patch module loads.  Everything else goes in the patched
+	 * object's section, applied when the patched module is loaded.
 	 */
 
-	if (!klp_relocs) {
-		const char *objname = find_modname(e);
-		char sec_name[SEC_NAME_LEN];
-
-		if (!objname)
+	if (!strcmp(sym_modname, "vmlinux")) {
+		sec_objname = "vmlinux";
+	} else {
+		sec_objname = find_modname(e);
+		if (!sec_objname)
 			return -1;
+	}
 
-		/* section format: __klp_relocs.objname */
-		if (snprintf_check(sec_name, SEC_NAME_LEN,
-				   KLP_RELOCS_SEC ".%s", objname))
-			return -1;
+	/* section format: __klp_relocs.objname */
+	if (snprintf_check(sec_name, SEC_NAME_LEN,
+			   KLP_RELOCS_SEC ".%s", sec_objname))
+		return -1;
 
+	klp_relocs = find_section_by_name(e->out, sec_name);
+	if (!klp_relocs) {
 		klp_relocs = elf_create_section(e->out, sec_name, 0,
 						0, SHT_PROGBITS, 8, SHF_ALLOC);
 		if (!klp_relocs)
-- 
2.53.0



