Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD3213E67;
	Tue, 29 Apr 2025 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950782; cv=none; b=hvR6H/WV3JioU7PvQO+1DhbhVtvj4kpNLV1SzwKmdqAVyBV4/X0/zKUWzJ/M4zkOjzZO0ZHoC+yHfjPcf0Uu8mrm8fPuvhA0qqv9nOvaxJ++/Ymgqc3bsIbw1molAXgCRT/N2a0JjCe+aSmNx2+od6BmHlcBXUEIu7Cx3koArmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950782; c=relaxed/simple;
	bh=fsnqkwiejmjO6sRPq/k0JW8r7bTCddkanOInfKSD9cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaCtKZ3yeYw5DPYIgwslJ5i8tUclg33qe9LWvlXcn++rMEVL691jbqt9FIn75KQjeqJusU+hgcMNXw705ZldRy0aj3zkv1PsW+mLv4PiwLesWpNTODJoahjUr3sDQc8AgFWYw18tTUQnlxx+kfNZtxOOCmMGghvjUh3g6pRGgWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uomY901t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uomY901t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A387FC4CEE3;
	Tue, 29 Apr 2025 18:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950782;
	bh=fsnqkwiejmjO6sRPq/k0JW8r7bTCddkanOInfKSD9cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uomY901t4yvQPepBjCrVpP8xxS6QJu4U++AKbgvqS32t4rrXJZdTKiR42zQSxqxsJ
	 MO1bCUrofouTUFsWCPW13yRJ9pMXTeT4J9hZt9x4/N58h4ZV6jx842dZDx44eFewZH
	 lJP1UKvWXX3F+KB6ObD4x/kAh/gkXfDOkLniYIqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 203/204] objtool: Ignore end-of-section jumps for KCOV/GCOV
Date: Tue, 29 Apr 2025 18:44:51 +0200
Message-ID: <20250429161107.683641426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 0d7597749f5a3ac67851d3836635d084df15fb66 upstream.

When KCOV or GCOV is enabled, dead code can be left behind, in which
case objtool silences unreachable and undefined behavior (fallthrough)
warnings.

Fallthrough warnings, and their variant "end of section" warnings, were
silenced with the following commit:

  6b023c784204 ("objtool: Silence more KCOV warnings")

Another variant of a fallthrough warning is a jump to the end of a
function.  If that function happens to be at the end of a section, the
jump destination doesn't actually exist.

Normally that would be a fatal objtool error, but for KCOV/GCOV it's
just another undefined behavior fallthrough.  Silence it like the
others.

Fixes the following warning:

  drivers/iommu/dma-iommu.o: warning: objtool: iommu_dma_sw_msi+0x92: can't find jump dest instruction at .text+0x54d5

Fixes: 6b023c784204 ("objtool: Silence more KCOV warnings")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/08fbe7d7e1e20612206f1df253077b94f178d93e.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/314f8809-cd59-479b-97d7-49356bf1c8d1@infradead.org/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1552,6 +1552,8 @@ static int add_jump_destinations(struct
 	unsigned long dest_off;
 
 	for_each_insn(file, insn) {
+		struct symbol *func = insn_func(insn);
+
 		if (insn->jump_dest) {
 			/*
 			 * handle_group_alt() may have previously set
@@ -1575,7 +1577,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->return_thunk) {
 			add_return_call(file, insn, true);
 			continue;
-		} else if (insn_func(insn)) {
+		} else if (func) {
 			/*
 			 * External sibling call or internal sibling call with
 			 * STT_FUNC reloc.
@@ -1608,6 +1610,15 @@ static int add_jump_destinations(struct
 				continue;
 			}
 
+			/*
+			 * GCOV/KCOV dead code can jump to the end of the
+			 * function/section.
+			 */
+			if (file->ignore_unreachables && func &&
+			    dest_sec == insn->sec &&
+			    dest_off == func->offset + func->len)
+				continue;
+
 			WARN_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
 				  dest_sec->name, dest_off);
 			return -1;
@@ -1616,8 +1627,7 @@ static int add_jump_destinations(struct
 		/*
 		 * Cross-function jump.
 		 */
-		if (insn_func(insn) && insn_func(jump_dest) &&
-		    insn_func(insn) != insn_func(jump_dest)) {
+		if (func && insn_func(jump_dest) && func != insn_func(jump_dest)) {
 
 			/*
 			 * For GCC 8+, create parent/child links for any cold
@@ -1634,10 +1644,10 @@ static int add_jump_destinations(struct
 			 * case where the parent function's only reference to a
 			 * subfunction is through a jump table.
 			 */
-			if (!strstr(insn_func(insn)->name, ".cold") &&
+			if (!strstr(func->name, ".cold") &&
 			    strstr(insn_func(jump_dest)->name, ".cold")) {
-				insn_func(insn)->cfunc = insn_func(jump_dest);
-				insn_func(jump_dest)->pfunc = insn_func(insn);
+				func->cfunc = insn_func(jump_dest);
+				insn_func(jump_dest)->pfunc = func;
 			}
 		}
 


