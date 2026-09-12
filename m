Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12BE25B083;
	Sat, 12 Sep 2026 08:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201335; cv=none; b=iQiPPGahazz9OSoY33uLXNXRVKh175ZTYy0XZN/aMQ1s4KSfIwWDM/ZG3qgFk3v7kZi5644L9LIeAIOuwoPVexRuVKPrVv0NHB+0Yg/smEy+Xb/Sb3y9fL7QAnYufDYq6pgFKEZLXV6R1P+epuCTAUlhax8VUvG2ljyth/LK1Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201335; c=relaxed/simple;
	bh=sltbjx1D53UapGbHE7+cD9VK2W6lfqd0NNChdcc0bRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHFIm6tVr4+UT8I0ADaRPrmb243PyzyUgy0PyAWNCmUhzNtP7B7IuNQyjW4Nfh0R825U9Y1vNPsQq8frfOyvsjhsIV5+e/aYKfqGOuonFcb7OK3YalEj3tKBCsJkxbMj6ReAzt67BUGAXnoi31jLqE3DDWO2NwkwSn/rs+P8HpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDw++Kve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDw++Kve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A951F000FF;
	Sat, 12 Sep 2026 08:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201333;
	bh=egZliB7biUMFpUePn6mT46mNx11f/WsmBP+nYiNiqxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDw++KveKYcTTVnoaW3okgE99yNl7dyWGbtwvPe/mJbQicnxvRK5SnYlVcaftMXpm
	 R4L42aokgBig2MiXdFSPokBbimpI+XLmGfaO9ZJTbX4vUaYJry1rinGX/mWDu07MJq
	 Z+jCOx5CyBlJIcj1MbnFiXKjdqxhMOv+XzyOGSoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Procknow <bprockno@redhat.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	live-patching@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0976/1815] objtool/klp: Fix false module dependencies caused by dead relocs
Date: Sat, 12 Sep 2026 08:45:26 +0200
Message-ID: <20260912065711.893801089@linuxfoundation.org>
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

[ Upstream commit 5ca8c91d1ea6534842e7e0065d15104d802506cd ]

When creating a klp reloc, klp-diff keeps the original relocation but
converts the referenced symbol to an UNDEF/WEAK placeholder tombstone
symbol, which gets fully disabled later by klp post-link.  The tombstone
symbol is only needed to avoid confusing objtool when it does the final
run on the patch module.

However, for references to exported symbols, modpost sees the reference
to the tombstone symbol as a real reference to an exported symbol,
resulting in a false module dependency getting created.

Further, for a reference to a tombstone symbol which is exported into a
module namespace, e.g. via EXPORT_SYMBOL_FOR_KVM_INTERNAL(), modpost
can't satisfy the dependency, resulting in a warning like the following:

  module ... uses symbol kvm_flush_remote_tlbs from namespace
  module:kvm-amd,kvm-intel, but does not import it.

Rename the placeholder tombstone symbols to ".klp.tombstone.<name>" so
modpost no longer recognizes them.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Reported-by: Ben Procknow <bprockno@redhat.com>
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: live-patching@vger.kernel.org
Link: https://lore.kernel.org/20260720145658.1103243-5-joe.lawrence@redhat.com
Link: https://patch.msgid.link/9548393f4d89ec3b498f4f69aa6ef6b9bb7150fe.1785727106.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c                 | 13 +++++++++++++
 tools/objtool/include/objtool/klp.h |  2 ++
 tools/objtool/klp-diff.c            | 16 ++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 33c95a74a51bd..a791f4ea6ec19 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -23,6 +23,7 @@
 #include <linux/log2.h>
 #include <objtool/builtin.h>
 #include <objtool/elf.h>
+#include <objtool/klp.h>
 #include <objtool/warn.h>
 
 static ssize_t demangled_name_len(const char *name);
@@ -626,6 +627,18 @@ static int read_symbols(struct elf *elf)
 			return -1;
 		}
 
+		/*
+		 * "klp diff" renames the placeholder symbols of KLP relocs to
+		 * hide them from modpost.  Hide the prefix from the rest of
+		 * objtool so its many name-based heuristics (noreturns,
+		 * uaccess safe list, ...) still see the original symbol name.
+		 *
+		 * st_name is left alone, so the renamed symbol is preserved in
+		 * the output file.
+		 */
+		if (strstarts(sym->name, KLP_TOMBSTONE_PREFIX))
+			sym->name += strlen(KLP_TOMBSTONE_PREFIX);
+
 		if ((sym->sym.st_shndx > SHN_UNDEF &&
 		     sym->sym.st_shndx < SHN_LORESERVE) ||
 		    (shndx_data && sym->sym.st_shndx == SHN_XINDEX)) {
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index 6f60cf05db864..aab6db42052dd 100644
--- a/tools/objtool/include/objtool/klp.h
+++ b/tools/objtool/include/objtool/klp.h
@@ -23,6 +23,8 @@
 #define KLP_RELOCS_SEC	"__klp_relocs"
 #define KLP_STRINGS_SEC	".rodata.klp.str1.1"
 
+#define KLP_TOMBSTONE_PREFIX	".klp.tombstone."
+
 struct klp_reloc {
 	void *offset;
 	void *sym;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 15d37d955af0e..75ba0e060a34d 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1362,6 +1362,7 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 	s64 addend = reloc_addend(patched_reloc);
 	const char *sym_modname, *sym_orig_name;
 	static struct section *klp_relocs;
+	char tombstone_name[SYM_NAME_LEN];
 	struct symbol *sym, *klp_sym;
 	unsigned long klp_reloc_off;
 	char sym_name[SYM_NAME_LEN];
@@ -1376,15 +1377,22 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 	/*
 	 * Keep the original reloc intact for now to avoid breaking objtool run
 	 * which relies on proper relocations for many of its features.  This
-	 * will be disabled later by "objtool klp post-link".
+	 * reloc now targets a functionally dead tombstone symbol and will be
+	 * disabled later by "objtool klp post-link".
 	 *
-	 * Convert it to UNDEF (and WEAK to avoid modpost warnings).
+	 * Convert the symbol to UNDEF/WEAK and rename to
+	 * .klp.tombstone.sym_name to prevent modpost from printing warnings or
+	 * creating false module dependencies.  The prefix is hidden from the
+	 * objtool run itself by read_symbols().
 	 */
 
 	sym = patched_sym->clone;
 	if (!sym) {
-		/* STB_WEAK: avoid modpost undefined symbol warnings */
-		sym = elf_create_symbol(e->out, patched_sym->name, NULL,
+		if (snprintf_check(tombstone_name, SYM_NAME_LEN,
+				   KLP_TOMBSTONE_PREFIX "%s", patched_sym->name))
+			return -1;
+
+		sym = elf_create_symbol(e->out, tombstone_name, NULL,
 					STB_WEAK, patched_sym->type, 0, 0);
 		if (!sym)
 			return -1;
-- 
2.53.0



