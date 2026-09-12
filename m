Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE32E718B;
	Sat, 12 Sep 2026 08:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203296; cv=none; b=q5NwH0PvUBtxi9XunX3J2SI8Gicn2XnDMLExXA2oIuy8TZN8BTC7STCWJOkGgcmJOqSOr+q/aUpTXtV88o9jfpYQr1mGTVyhB/3PMTuuDG6vfi3ziTooMCfESzUipLVrlFLb7+PUkZxOj2qjWxIh8jeAJ6uSHTsSeHnnEtbJfzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203296; c=relaxed/simple;
	bh=aXz4E6T5eydLbiAzXqum49X00wPtam2zKapS39PIigo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP8nv5iKU41HsypZmaWBJx6XXzDTT17zjZ7GoW8xB9QEMIIhC2fTTfsjAnAq1PVQDcVYPVAXGVCsduub5ddSFnAMkRQmqx2k//J67LDc91rSkwHRyOLW2DVxyP8FIPm09xeZpvOjHfo8cIg6c62va2bUR1D3ZfSb905lVEdnBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCFmhX3z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCFmhX3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB41F1F00893;
	Sat, 12 Sep 2026 08:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203294;
	bh=EI5lPFaIGTMH2rYPK+/hghD/n5+8+i6nSAozWsqznuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCFmhX3zrGFZXScvoD70Ai7j/ULPizIUfIfc2ERXeCtPeIJuFYYQJYCKLfs8kL3AF
	 BuATou3sr3Y2Q99lj9SW+KfA4dYQuSs6wIaw2+n1t+8Xusds6j32jIodY/oA5RW59z
	 p133QzAIH99gJI5/Qbvq5yhTI6ULfJgXqA4IdLag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1380/1815] objtool/klp: Ignore replacement offset of empty x86 alternatives
Date: Sat, 12 Sep 2026 08:52:10 +0200
Message-ID: <20260912065721.422593761@linuxfoundation.org>
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

[ Upstream commit 636f230ce21e2730072c58280f1fa0bed4a00eed ]

An x86 alternative with an empty replacement, e.g. the second entry of

  ALTERNATIVE_2("orig", "repl", ft1, "", ft2)

has a replacementlen of zero.  Its replacement offset still gets a
relocation, but the label it points at is the end of the previous
replacement, which is also the beginning of the *next* alternative's
replacement.  The value is meaningless; get_alt_entry() already ignores
it for that reason.

klp diff doesn't ignore it.  When such an alternative belongs to a
changed function, cloning its relocations drags in the unrelated
neighboring replacement, along with everything that replacement
references.  On an x86 clang/lto build an empty alternative in
meminfo_proc_show() pulled in the replacement of an alternative in
proc_kcore_init(), silently emitting a klp relocation against init text
which has long since been freed by the time the patch is applied.

Add arch_alt_ignore_new_reloc() and skip such relocations when cloning.
This has to be arch specific: on arm64 a zero-length replacement instead
identifies an alternative callback, whose replacement offset points at
the callback function and must be preserved.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/7a885b70974795c3417f3358869e62aafd4ef783.1786138493.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/special.c        | 27 +++++++++++++++++++++++++
 tools/objtool/include/objtool/special.h |  7 +++++++
 tools/objtool/klp-diff.c                |  6 +++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/special.c b/tools/objtool/arch/x86/special.c
index e817a3fff4491..1e84c81bfcd81 100644
--- a/tools/objtool/arch/x86/special.c
+++ b/tools/objtool/arch/x86/special.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <string.h>
 
+#include <arch/special.h>
 #include <objtool/special.h>
 #include <objtool/builtin.h>
 #include <objtool/warn.h>
@@ -9,6 +10,32 @@
 /* cpu feature name array generated from cpufeatures.h */
 #include "cpu-feature-names.c"
 
+/*
+ * An alternative with an empty replacement, e.g. the second entry of
+ *
+ *   ALTERNATIVE_2("orig", "repl", ft1, "", ft2)
+ *
+ * still gets a relocation for its replacement offset.  But the label it points
+ * at is the end of the previous entry's replacement, which is also the
+ * beginning of the *next* entry's replacement.  The value is meaningless: it's
+ * only ever used with a length of zero.
+ */
+bool arch_alt_ignore_new_reloc(struct section *sec, unsigned long offset)
+{
+	unsigned long entry_off;
+
+	if (strcmp(sec->name, ".altinstructions"))
+		return false;
+
+	entry_off = offset - (offset % ALT_ENTRY_SIZE);
+
+	if (offset - entry_off != ALT_NEW_OFFSET)
+		return false;
+
+	return !*(unsigned char *)(sec->data->d_buf + entry_off +
+				   ALT_NEW_LEN_OFFSET);
+}
+
 void arch_handle_alternative(struct special_alt *alt)
 {
 	static struct special_alt *group, *prev;
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 121c3761899c1..620dbf6cb0e58 100644
--- a/tools/objtool/include/objtool/special.h
+++ b/tools/objtool/include/objtool/special.h
@@ -32,6 +32,13 @@ int special_get_alts(struct elf *elf, struct list_head *alts);
 
 void arch_handle_alternative(struct special_alt *alt);
 
+/*
+ * Should the reloc at @offset -- the "new" (replacement) field of a special
+ * section group entry -- be ignored?  The meaning of a zero-length replacement
+ * is arch specific, so the arch decides.
+ */
+bool arch_alt_ignore_new_reloc(struct section *sec, unsigned long offset);
+
 bool arch_support_alt_relocation(struct special_alt *special_alt,
 				 struct instruction *insn,
 				 struct reloc *reloc);
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index b4220e12a8e2f..df2fe014ec7e8 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -12,7 +12,7 @@
 #include <objtool/arch.h>
 #include <objtool/klp.h>
 #include <objtool/util.h>
-#include <arch/special.h>
+#include <objtool/special.h>
 
 #include <linux/align.h>
 #include <linux/objtool_types.h>
@@ -1538,6 +1538,10 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 		    !strcmp(patched_reloc->sym->sec->name, ".altinstr_aux"))
 			continue;
 
+		if (arch_alt_ignore_new_reloc(patched_sym->sec,
+					      reloc_offset(patched_reloc)))
+			continue;
+
 		ret = convert_reloc_sym(e->patched, patched_reloc);
 		if (ret < 0) {
 			ERROR_FUNC(patched_rsec->base, reloc_offset(patched_reloc),
-- 
2.53.0



