Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F16838D3E5;
	Tue, 21 Jul 2026 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648244; cv=none; b=UrfXF1lMKCbtXK2gdeVQv50pxpCr8OIF+9c1OupyGdMe+x18wRrzYbRH54Hg712zLimr66UI2iADTOpeKzDsbEphFKP41NbWEfISuFLDcFBWmumeB6SuO5k2qtwCCEYZrI8+T4LYCujdUxKDba83WavyCZrLMqdLUPuJ0wuHYkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648244; c=relaxed/simple;
	bh=uIg/93/QdGO2ZYSfpU7KMHOct7BDQnOiEIKnDw6fovI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLo6MC+o4swM5J3jHAUNeOWHv83B/8l8xrEP85LG+adGBCwAwAvzYitBpDfjQPe45cUVrxhIJ20SegsFM4iy7Xzigizdhy7B1rgfXj3K6vuW3pbE+p6S5HUzCpegCDKdZVql3PY6mXg6XTw24YaDbKSWA0HSD48NHCuVats2JHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjBHGL+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjBHGL+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008E01F000E9;
	Tue, 21 Jul 2026 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648243;
	bh=7p+C8VA9ezxpsurvQVeUe9P7FlQjoHprOQiHfkUV7Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjBHGL+zZpyiZFolt5L3rcU9pqWRDCLXguyZ/4YwgNIXv0z4Emq80ZZSoCXNuSaYX
	 PCVEuOrLYTLaQffx5Bbqn80tMhKcVWr8bMFtsuVUqxnMG61JC+61hrAsyVbBc9QJqc
	 5+E15vSU5BQYO4/iPAE1oUK4dB6h93kaGGt4vSJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0124/2077] objtool/klp: Fix handling of zero-length .altinstr_replacement sections
Date: Tue, 21 Jul 2026 16:56:37 +0200
Message-ID: <20260721152555.623064447@linuxfoundation.org>
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

[ Upstream commit c4c02d4450b5b7e2fbde578252f71a5697180112 ]

When a section is empty (e.g. only zero-length alternative
replacements), there are no symbols to convert a section symbol
reference to.  Skip the reloc instead of erroring out.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 18e40a7f864310..8aec5f5702c73b 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -993,6 +993,13 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 	/* No dedicated section; find the symbol manually */
 	sym = find_symbol_containing(sec, arch_adjusted_addend(reloc));
 	if (!sym) {
+		/*
+		 * This is presumably an .altinstr_replacement section which is
+		 * empty due to it only having zero-length replacement(s).
+		 */
+		if (!sec_size(sec))
+			return 1;
+
 		/*
 		 * This can happen for special section references to weak code
 		 * whose symbol has been stripped by the linker.
@@ -1253,6 +1260,7 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 
 	for_each_reloc(patched_rsec, patched_reloc) {
 		unsigned long offset;
+		int ret;
 
 		if (reloc_offset(patched_reloc) < start ||
 		    reloc_offset(patched_reloc) >= end)
@@ -1266,12 +1274,15 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 		    !strcmp(patched_reloc->sym->sec->name, ".altinstr_aux"))
 			continue;
 
-		if (convert_reloc_sym(e->patched, patched_reloc)) {
+		ret = convert_reloc_sym(e->patched, patched_reloc);
+		if (ret < 0) {
 			ERROR_FUNC(patched_rsec->base, reloc_offset(patched_reloc),
 				   "failed to convert reloc sym '%s' to its proper format",
 				   patched_reloc->sym->name);
 			return -1;
 		}
+		if (ret > 0)
+			continue;
 
 		offset = out_sym->offset + (reloc_offset(patched_reloc) - patched_sym->offset);
 
-- 
2.53.0



