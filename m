Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B11535CBC0;
	Tue, 16 Dec 2025 12:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886791; cv=none; b=VXxmmIBUNysO0JFHI395KHWsf8g37kYsuHErEo/MoXKQmHWXtUyINAoVZkah+sp27xjM9Y1HRha86Y1Vo1JqgP39LpQV9aCfF1MsK2ctPdc9Bhp296PYRqKlAWG00N0tl/zXNXyEnlwsREkknJLccEgP95Iy4zqmoC+iBurkZ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886791; c=relaxed/simple;
	bh=vZOCk/GQgnG1oQSkPglkCD8ixAta5KkD1VLFwVNcCV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdj2rwo2cTRbWCav/nsBAQUewPJEME3y+Kzs0XPIwbxVZglw1HBzl4ZKjMY/VSRG6WYGbaU/Qr5hPA0yQzFlIcdb6dviQwHMBoYrwTVhKiLczP2V6JBu9IFGjG1lv8h5ODzkd2YyU7VSN7ZaZG4VhdnwJAcURuNJpniTfuV5EZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rufk3Z9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rufk3Z9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DA6C4CEF1;
	Tue, 16 Dec 2025 12:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886791;
	bh=vZOCk/GQgnG1oQSkPglkCD8ixAta5KkD1VLFwVNcCV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rufk3Z9ZNcz0QgBVRYKJGY+KB7HWEPD9Oz0Hn84ckda83nbZvzFRQAUk27EglXjL9
	 h+dku2PknBQWfnvNskMYPttevJMWGXLD6A3eNU1FCJ760Hzpu3RN4Usp1YvHN8Fnkj
	 QkCniFU/XwHBZRuAhT7ePHx3wBFG/PQrUt5++OBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/614] objtool: Fix weak symbol detection
Date: Tue, 16 Dec 2025 12:06:41 +0100
Message-ID: <20251216111402.545103740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



