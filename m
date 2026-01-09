Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814D835B12D;
	Fri,  9 Jan 2026 12:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961536; cv=none; b=oMfvRj4njNlWLNEX7ilNhwpXDbzU9cFM6cPTCL6nL0RtzmUL0e8xCivaxrBDOUqknDZoHxtVIkolGE05rE/1ohvCfibe3HfRw1nyoysyggxBp69swoFxG+3xRY8cXignleI5jxx0F+WjcKOO1LC8VCI+SUvH6yWgRyeySgUyeQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961536; c=relaxed/simple;
	bh=XYg+aZu06euuWSqj7N7/yG1nCYrFe6jOvWTWnZzvuF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVL3A/fZqJrOV4aRo8t5U2WxNvyMGlzWWfVfJ7u/3+1s06JXdldYZwwHkNOYVBfTwn12fqzIwwxsmGxdbzo8wcsqVzIF8TADjQgQvxi/I1pH/NTFgjtwSKKzi5IUd9qHHVHOQyi6Cgg5R+Prjxm9P6UwUB2fKjXJlF5TQaJx7HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpF6fvI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpF6fvI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D346C4CEF1;
	Fri,  9 Jan 2026 12:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961535;
	bh=XYg+aZu06euuWSqj7N7/yG1nCYrFe6jOvWTWnZzvuF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpF6fvI8d7NK5zCQpZCs9z8ToLMjzwq6qTdihNsOOMeBDV7BPMRxvIyzq6GZ+egby
	 yuowN1i3M2tD2yjZ5mieHHYuaxXKbpgJpEuFQa0jACkk2zTFAK6mGGVmXYY/PlyrAX
	 MpflTtkjkm+5wTC/GLfkonbOiMAUGPxiFWkHteEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/634] objtool: Fix weak symbol detection
Date: Fri,  9 Jan 2026 12:35:26 +0100
Message-ID: <20260109112119.253919730@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89b37cd4ab1dc..905253421e8c8 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -74,7 +74,7 @@ struct symbol_hole {
 };
 
 /*
- * Find !section symbol where @offset is after it.
+ * Find the last symbol before @offset.
  */
 static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 {
@@ -85,8 +85,7 @@ static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 		return -1;
 
 	if (sh->key >= s->offset + s->len) {
-		if (s->type != STT_SECTION)
-			sh->sym = s;
+		sh->sym = s;
 		return 1;
 	}
 
@@ -369,7 +368,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->len = sym->sym.st_size;
 
 	__sym_for_each(iter, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (iter->offset == sym->offset && iter->type == sym->type)
+		if (iter->offset == sym->offset && iter->type == sym->type &&
+		    iter->len == sym->len)
 			iter->alias = sym;
 	}
 
-- 
2.51.0



