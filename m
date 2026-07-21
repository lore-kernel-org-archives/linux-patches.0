Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416784C9567;
	Tue, 21 Jul 2026 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648250; cv=none; b=Va2brq3LiDL2+2/UGQ+v3B3P8P50mgSqh1JcSb7HbGda1HGXTyGFWTC1/KFkpvI4pSFx987p8JKboJS1FjWYNP5HsVafRBA8znYEnrwUDIDjn5NEMvu44KvjHlOj91YhqwjOq2M2ZAsWkintg8zPld253X23RO0IUmW+p3lcu4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648250; c=relaxed/simple;
	bh=FtxxeSpK68YtgCuN3BNB5xDrlSWhbJTIpLi4JYpJFec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTpYQspRCTEoXLcbNqPu2fYo8n1IAUt3ntLdQehv81LxTOdNvJ0V7xiDuuOF65dXBAL14CI7KVHefG22IQTmxPPbmrAWfv0GLu6wtR//YkOQD7LdIyU2vfxh9J8s6jRn0acwYY+FfqFr8vIQVrSYOX7n+PD25+dyWzWe8PjwN+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGBCyNcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGBCyNcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568D21F000E9;
	Tue, 21 Jul 2026 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648248;
	bh=/WB9TDMNS255ziVQaXAqkGVFsFKoO7yvLU1P9p1Mlrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGBCyNcLyU+PkfvuLWQi9O7mu7v4H4RpmTKfVYLj/2owItbeOYPpVAhotkMzMyAvk
	 UZqdzjCCMV2QSUlwmyvaS3anqVXJKHKgS2giJBo05aTEoia1beX1QughjaEq2JuzFG
	 GK2zMRPJF/wVaNJ2nLXs1ECxfnem20XRk9309Y4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0126/2077] objtool/klp: Fix extraction of text annotations for alternatives
Date: Tue, 21 Jul 2026 16:56:39 +0200
Message-ID: <20260721152555.669202122@linuxfoundation.org>
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

[ Upstream commit 62a7a01fde87c99926cd7e9670b4226c4c79ebaf ]

Objtool is failing to extract text annotations which reference
.altinstr_replacement instructions:

  1) Alternative replacement fake symbols are NOTYPE rather than FUNC,
     and they don't have sym->included set, thus they aren't recognized
     by should_keep_special_sym().

  2) .discard.annotate_insn gets processed before .altinstr_replacement,
     so the referenced (fake) symbols don't have clones yet.

Fix the first issue by checking for a valid clone instead of
sym->included and by accepting NOTYPE symbols when processing
.discard.annotate_insn.

Fix the second issue by deferring text annotation processing until after
the other special sections have been cloned.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 67fdc43a743373..61abf5ceb650e4 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1425,6 +1425,7 @@ static int create_fake_symbols(struct elf *elf)
 /* Keep a special section entry if it references an included function */
 static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
 {
+	bool annotate_insn = !strcmp(sym->sec->name, ".discard.annotate_insn");
 	struct reloc *reloc;
 
 	if (is_sec_sym(sym) || !sym->sec->rsec)
@@ -1434,7 +1435,16 @@ static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
 		if (convert_reloc_sym(elf, reloc))
 			continue;
 
-		if (is_func_sym(reloc->sym) && reloc->sym->included)
+		if (!reloc->sym->clone || is_undef_sym(reloc->sym->clone))
+			continue;
+
+		/*
+		 * Keep special section references to cloned functions.
+		 * In some cases annotate_insn can also reference cloned alt
+		 * replacement fake symbols; keep those references as well.
+		 */
+		if (is_func_sym(reloc->sym) ||
+		    (annotate_insn && is_notype_sym(reloc->sym)))
 			return true;
 	}
 
@@ -1578,15 +1588,28 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 /* Extract only the needed bits from special sections */
 static int clone_special_sections(struct elfs *e)
 {
-	struct section *patched_sec;
+	struct section *sec, *annotate_insn = NULL;
 
-	for_each_sec(e->patched, patched_sec) {
-		if (is_special_section(patched_sec)) {
-			if (clone_special_section(e, patched_sec))
+	for_each_sec(e->patched, sec) {
+		if (is_special_section(sec)) {
+			if (!strcmp(sec->name, ".discard.annotate_insn")) {
+				annotate_insn = sec;
+				continue;
+			}
+			if (clone_special_section(e, sec))
 				return -1;
 		}
 	}
 
+	/*
+	 * Do .discard.annotate_insn last, it can reference other special
+	 * sections (alt replacements) so they need to be cloned first.
+	 */
+	if (annotate_insn) {
+		if (clone_special_section(e, annotate_insn))
+			return -1;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



