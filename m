Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884022E718B;
	Sat, 12 Sep 2026 08:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203354; cv=none; b=pAqv4J8/BU742X/K1NfOv+umUUqWtoIFZG9E9DXS+m3ZbBqwM8aBAtmf/QCxKkPN39Y6lyYdyJOXewdQ6eIPjy+XVQKW1zH0cM7fld1ku1o9+TiWSjKCXMWOEL5e0kImjm/8W04AFaQxmBAQKdvXFWTL1qkmqc9d6qSZaOFKWec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203354; c=relaxed/simple;
	bh=SaUfpUyzHeRUHppjsbpins78NfEYxbgM13kpmC3MA2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqKbdFUN5m83bUKvpDeTVF1dwXcwd3bd7jSXe4GtbIWUv4vQgm8SpJJNMQe/FyS+RgG+Vi9lXSBwFo3zM4Qj7Zl+5phaUJSR/zrY1oQN4axkoBxt7alUtKkrcmVtcpQPpiGlOUa/enTqshSf+NY9PlIB//aZqGerEvnl958zZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGTcFkxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGTcFkxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C381F000FF;
	Sat, 12 Sep 2026 08:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203353;
	bh=xJnWSHL8MuCQ8n6812lpIhBTRhzlFwMcluTeklQGjbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGTcFkxAahfk04GtjItTHC7mYUbOXFsq9Lyt6uXRhU2+gH3iTK68PCYzjFvcQaseB
	 bgjwSfN8kcc62WQ5RMzwPuoF1hlP8Z3qXBgpBTuSUy9pPfQ/l9pOBT22GrF+GHa+IY
	 GJUViiDcmCcMNl/qzyfewVHoQ58uihY3sEYecB7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1391/1815] objtool/klp: Dont match local symbols against exports
Date: Sat, 12 Sep 2026 08:52:21 +0200
Message-ID: <20260912065721.678981943@linuxfoundation.org>
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

[ Upstream commit 86a697572c6271083694025eefa8de518eeef623 ]

While cloning a reloc, klp diff calls find_export() to determine whether
the referenced symbol is exported.  That decides whether the reference
needs a klp reloc, which object the klp symbol belongs to, and whether
the symbol's data needs to be copied into the patch module.

But find_export() matches purely on symbol name, so a static function or
variable which happens to share its name with an export is mistaken for
a reference to that export:

  - klp_reloc_needed() creates a klp reloc pointing at the exporting
    module's symbol rather than the local one.  For a vmlinux export it
    skips the klp reloc altogether, leaving a normal reloc which the
    module loader resolves to the vmlinux symbol.

  - clone_reloc() treats the symbol as external and clones it without
    its data, leaving a dangling reference.

  - validate_special_section_klp_reloc() attributes a static branch or
    call key to the wrong module, and for a vmlinux export skips the
    unsupported-key check entirely.

Exports are always global, so ignore local symbols in find_export().

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/dafc7c017d1f62e2190a20dc84a52fbfc4c70210.1786138493.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index e266a54b059d6..a7cdba08b1deb 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1102,6 +1102,9 @@ static struct export *find_export(struct symbol *sym)
 {
 	struct export *export;
 
+	if (is_local_sym(sym))
+		return NULL;
+
 	hash_for_each_possible(exports, export, hash, str_hash(sym->name)) {
 		if (!strcmp(export->sym, sym->name))
 			return export;
-- 
2.53.0



