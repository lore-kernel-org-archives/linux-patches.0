Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9143556B81;
	Tue, 16 Dec 2025 11:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883872; cv=none; b=G0qFNX3+7OhKHu5u4xbSLS1oCYwLeshd2uyqvHFpJn9WLfamKoguUkARQZIqxHgA95EgR3PStaaHw5Vf+aiSbFmY33t/oYkDqZ1NCgiyhOq0mzbGRB1s6FGuixxn/LJ2cbtfW01488NN/dOzEgwEIux2cQ4i5oy31tc5v4WZlqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883872; c=relaxed/simple;
	bh=F/tPcaJBAmoFsQ1aNW9axAirOLjLfejSaRghG7eqKl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmCPtHgxNAskoYl9Pcz7rwpMNFJIsNBIxJfIJjRyy/r0EOT1OTCt3T1ftibKHvbkPsQkJKVA2jF/253NwOIXuhPOe6KK8d5p2UOSVcp1+ZcGxDkSyjVkUfmCw0dlC63xb1BaKC5JSc8ZsSxmBDjsePZYiPAPj4nUVlKBze4VwIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzKtaGiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzKtaGiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CAFC4CEF1;
	Tue, 16 Dec 2025 11:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883872;
	bh=F/tPcaJBAmoFsQ1aNW9axAirOLjLfejSaRghG7eqKl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzKtaGizSYVtx92Rn56FO+y9aV3k7h9RtK0jEdAounBRKCkQEiJsy7xj9tPPrpcnG
	 cTUyQFGmEAbeDE9jHp3QbVivQm3dK2ghNbi/eZkcrDVYmpNcFJ/FgIpU4W9fE4IVcN
	 Vg1xi2/VUMmxY3f63HBnicJACJlvDYsKqvmYYxNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/354] objtool: Fix weak symbol detection
Date: Tue, 16 Dec 2025 12:09:51 +0100
Message-ID: <20251216111321.786783257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d27983dc908d..19021f9755ac7 100644
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
 
@@ -408,7 +407,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->len = sym->sym.st_size;
 
 	__sym_for_each(iter, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (iter->offset == sym->offset && iter->type == sym->type)
+		if (iter->offset == sym->offset && iter->type == sym->type &&
+		    iter->len == sym->len)
 			iter->alias = sym;
 	}
 
-- 
2.51.0



