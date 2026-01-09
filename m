Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FF132BF21;
	Fri,  9 Jan 2026 11:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959465; cv=none; b=WHalOEh59NTMXZL9Bd1hAP7xbJ59wb+xdkWb0eb/aKRyF9KVC+BV9WFq93YgfqCSJD0fGnB7F9cP1+heD7q6yxhZVoLndtG4vZCa9RfCzEDjN3rn51jAx+i+YnQXBXvmXMjGbxjIKRxgaMTCba9NPU6iyRy6pEudtYmIN7TjzXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959465; c=relaxed/simple;
	bh=+4wQwfS4ELo17Mtx0O857J/fhoMssCiahWYsAyXlYJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sp+6n53STgCSoGgaBGeyqywg+X7JMEe1uvi4o90BpOArXRCx0n8x+prRs9agSs97gH0rxizuY+tnMoHq0kOhesiNiVkIvdg6yMHK2PNgAaEs9LmVnvqHxYS0WrGtSVKWnn7OKfF+Zkly335XqwEuxSkFXSlrQRmSIIzdgiyJ8m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYtFwNxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYtFwNxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12449C4CEF1;
	Fri,  9 Jan 2026 11:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959465;
	bh=+4wQwfS4ELo17Mtx0O857J/fhoMssCiahWYsAyXlYJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYtFwNxPFQIIyBOPiKELshDppqfqVZJT4td9G+kykJDtEQ2M7J0BggRft0RSlcavk
	 sa9S5oqyag3ACMxkpEZeHu/SLDTMn+ak9V+7BjJeAe4Mf6eb3+JvVQbwmcVsgZCnpU
	 pJnYv+a1NsPipvaM1RjcstYPnFQEX3v0ABJrbtsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/737] objtool: Fix weak symbol detection
Date: Fri,  9 Jan 2026 12:33:20 +0100
Message-ID: <20260109112136.288113761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 081befa4674b8..797507a90251b 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -110,7 +110,7 @@ struct symbol_hole {
 };
 
 /*
- * Find !section symbol where @offset is after it.
+ * Find the last symbol before @offset.
  */
 static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 {
@@ -121,8 +121,7 @@ static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 		return -1;
 
 	if (sh->key >= s->offset + s->len) {
-		if (s->type != STT_SECTION)
-			sh->sym = s;
+		sh->sym = s;
 		return 1;
 	}
 
@@ -410,7 +409,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->len = sym->sym.st_size;
 
 	__sym_for_each(iter, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (iter->offset == sym->offset && iter->type == sym->type)
+		if (iter->offset == sym->offset && iter->type == sym->type &&
+		    iter->len == sym->len)
 			iter->alias = sym;
 	}
 
-- 
2.51.0



