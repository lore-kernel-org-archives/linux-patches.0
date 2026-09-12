Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F5B364038;
	Sat, 12 Sep 2026 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203479; cv=none; b=W80sjKTm5bJmYb7DRJ4Ew8nL89uTzMKx3nNA7bpEGP7vCHOn/cX85oQvk3OHS7SK7e5Bm7dTXqWksmGNEfDR3O2+269OrKq1MOO3VK2E0REA2Aye0Q1EbmgKBOTzZssv4rGhntmpZERFLtJjx20OlDdbXGbvxriaS4tG8CkDUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203479; c=relaxed/simple;
	bh=moV/fDodDFQmLtMB/ID1G84hEp8qZBihW/WWalQh5Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjuHqwR/3HIiPasvn4YsAws9eOtVKaoB+bcXggKO+1PeydDvDnu0yBkut6ySdYdxhr7x4od1/KDC6CPeWk3Z5zoOiz2PQi915tkMYPR4HRLtcRE+xhnHAkkM269hhOQfnXHPyg9jTeD0iZhwfi2D6gXilbyAA3kFce8WntxfEaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCKzArNo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCKzArNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06E21F000FF;
	Sat, 12 Sep 2026 08:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203478;
	bh=92rEk92nESzyyNjJnPgMc+kW+QVq6VIeDVUxEYzqypc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCKzArNo2itd7bHT2Yw/krQVAApGFQQPs+a1kWYOnS6H9i6TvLiiueExkdLzLmEtL
	 cSvK/3wrTVVTkvXeGcbRO6OFz8ucLDwh3GsBOF5akHZJS4wBWkFW9db5nAZgxOts/t
	 nctIeh2i8UAO6AmeqcSPNWa/HaK/cf7EBzz0zsZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1414/1815] objtool/klp: Fix .kcfi_traps special section extraction
Date: Sat, 12 Sep 2026 08:52:44 +0200
Message-ID: <20260912065722.217071310@linuxfoundation.org>
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

[ Upstream commit 7df1638df97b2aaaff4731b72d4940053257c952 ]

create_fake_symbols() creates a symbol per entry for special sections.
It does so in two steps: first for the sections which have
ANNOTATE_DATA_SPECIAL annotations, then for the rest, using entsize or
the reloc count to infer the entry size.  The second step skips the
sections already handled by the first one by looking for a symbol at
offset 0.

That heuristic is too fuzzy: with Clang and CONFIG_CFI, it misfires on
.kcfi_traps because Clang emits a .Ltmp* assembler-local label at the
start of the section, so no symbols are created and
clone_special_sections() extracts nothing.  klp-build still reports
SUCCESS, but the livepatch module has no __kcfi_traps section and the
traps for the patched functions are lost.

Look for the actual fake symbols created by the first step instead.

Fixes: da4326573ae8d ("objtool/klp: Fix kCFI trap handling")
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Closes: https://lore.kernel.org/r/akQNqlfFC0T5pcMa@redhat.com
Acked-by: Song Liu <song@kernel.org>
Link: https://patch.msgid.link/8faaead205b219607b6fc2359ae743be824056eb.1786230311.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/include/objtool/elf.h |  1 +
 tools/objtool/klp-diff.c            | 26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index d9c44df9cc76a..a82517a76a0f6 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -97,6 +97,7 @@ struct symbol {
 	u8 included	     : 1;
 	u8 klp		     : 1;
 	u8 dont_correlate    : 1;
+	u8 fake		     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ffa83dd88d0b0..ec2e7ae41767f 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1597,6 +1597,7 @@ static int create_fake_symbol(struct elf *elf, struct section *sec,
 			      unsigned long offset, size_t size)
 {
 	char name[SYM_NAME_LEN];
+	struct symbol *sym;
 	unsigned int type;
 	static int ctr;
 	char *c;
@@ -1613,7 +1614,24 @@ static int create_fake_symbol(struct elf *elf, struct section *sec,
 	 *	       while still allowing objdump to disassemble it.
 	 */
 	type = is_text_sec(sec) ? STT_NOTYPE : STT_OBJECT;
-	return elf_create_symbol(elf, name, sec, STB_LOCAL, type, offset, size) ? 0 : -1;
+
+	sym = elf_create_symbol(elf, name, sec, STB_LOCAL, type, offset, size);
+	if (!sym)
+		return -1;
+
+	sym->fake = 1;
+	return 0;
+}
+
+static bool has_fake_symbols(struct section *sec)
+{
+	struct symbol *sym;
+
+	sec_for_each_sym(sec, sym)
+		if (sym->fake)
+			return true;
+
+	return false;
 }
 
 /*
@@ -1705,7 +1723,11 @@ static int create_fake_symbols(struct elf *elf)
 		unsigned int entry_size;
 		unsigned long offset;
 
-		if (!is_special_section(sec) || find_symbol_by_offset(sec, 0))
+		if (!is_special_section(sec))
+			continue;
+
+		/* Skip sections already handled by step 1 above */
+		if (has_fake_symbols(sec))
 			continue;
 
 		if (!sec->rsec) {
-- 
2.53.0



