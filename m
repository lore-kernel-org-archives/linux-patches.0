Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F35349B16;
	Tue, 16 Dec 2025 11:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885178; cv=none; b=s/HSiNOxuSdwLEXxeK8/yHJrM+9WyqLtPoI5SIeTvOt6kDgaV3QRjx1UwmlETb/4ENShyav6zZJQdMquJ4LqtfRmRQwYPDXEQszFeaLmhoEJhhjELt9jl5Ia951Vb2tEIFfQps3cuIwcbJ4l46E8Kb1qkyPmORGc0FJwZSMxne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885178; c=relaxed/simple;
	bh=A3G+yQ7Sj81HxVPA2FDQW+587W1uR7xxslBy4guUs0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MANDXB/r2S8COmoLTG9uFbNEOBD4IQB0FJmG5je0gfTOoug8bpY44n9PY7bY2me98/RF3ucCeaMZYkYjSFEdRymqQG+ndsgsKzM61100I3rg92iGDxZFXcyPsBZVVnVV2aeV+fM1ZGPXVqtvUyUedx7CiL0IKw2CrhsraZH22kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxCsL9+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxCsL9+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE63C4CEF1;
	Tue, 16 Dec 2025 11:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885178;
	bh=A3G+yQ7Sj81HxVPA2FDQW+587W1uR7xxslBy4guUs0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxCsL9+2oukYnnsIR1nQsP0uQE+sJqlR2n+t22zeFRvM4h+1a8kYM8PtBCvm4QydF
	 wnHAI3hAfrQvpjUf8UqMYpcxtW6dEabiuCs64axA/YKYDC+lAa2oPZbLTyIPOLS3xA
	 yJRghxxpHXe2O8hYi9NjgZb06C6uE8mrtusni6KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 029/507] objtool: Fix weak symbol detection
Date: Tue, 16 Dec 2025 12:07:50 +0100
Message-ID: <20251216111346.593842161@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 72567c630d32bc31f671977f78228c80937ed80e ]

find_symbol_hole_containing() fails to find a symbol hole (aka stripped
weak symbol) if its section has no symbols before the hole.  This breaks
weak symbol detection if -ffunction-sections is enabled.

Fix that by allowing the interval tree to contain section symbols, which
are always at offset zero for a given section.

Fixes a bunch of (-ffunction-sections) warnings like:

  vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x10: unreachable instruction

Fixes: 4adb23686795 ("objtool: Ignore extra-symbol code")
Acked-by: Petr Mladek <pmladek@suse.com>
Tested-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index ca5d77db692a2..9cb51fcde7986 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -108,7 +108,7 @@ struct symbol_hole {
 };
 
 /*
- * Find !section symbol where @offset is after it.
+ * Find the last symbol before @offset.
  */
 static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 {
@@ -119,8 +119,7 @@ static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 		return -1;
 
 	if (sh->key >= s->offset + s->len) {
-		if (s->type != STT_SECTION)
-			sh->sym = s;
+		sh->sym = s;
 		return 1;
 	}
 
@@ -412,7 +411,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->len = sym->sym.st_size;
 
 	__sym_for_each(iter, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (iter->offset == sym->offset && iter->type == sym->type)
+		if (iter->offset == sym->offset && iter->type == sym->type &&
+		    iter->len == sym->len)
 			iter->alias = sym;
 	}
 
-- 
2.51.0



