Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A455F22DF91;
	Tue, 29 Apr 2025 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948394; cv=none; b=KZyYAqVuVxY8tOMAD/n5fmpFHD7BUdhNub+rMEAlHpX9jqkNzNKnuzyUyzX77ZokFDBzS8nB8NCORYDJyE6hu9Sh26Z60QVhhC2JlG5ykhk0m6wz64lU/MXAUdBAwamHi8DBvOjaDozljWbY/zTN/6qGtOQ9GozAg7f5etWUddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948394; c=relaxed/simple;
	bh=o0IPVyEaQ20q9mEW2Or4q+ii/2kgzkDsBMa0B2/XgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRrY2wbtQ4geXa49o+KlGKi9C1vA0sKTuD44RxjiymFD7RMHmTZPo6iVoI3zeaDwpCRmTn1wf86p8TsjFkOwl4faJ6m0DuGNzCmvxFiGvSdo79Utbhcf9ODffnXEGyQ6YW2XXI1FPE7ejv/QEu65uSz3GBKia5VowWPYTYfBha0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0Thxx/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0Thxx/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE87C4CEE3;
	Tue, 29 Apr 2025 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948394;
	bh=o0IPVyEaQ20q9mEW2Or4q+ii/2kgzkDsBMa0B2/XgAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0Thxx/7Bw/Z5XvcMOPzegmQKjX4RWE3WDGtquYYaWs0o3yr/EIhWhAyrTFXlpOZd
	 gUSz3Eah39cYIOwh1Kh5QZvUmnZdKAdk3GLpOW7NXk1YIujhZqt1abjAfotlNynQR6
	 9Xpjo8GmASaP4QVU3WSJ1TxU0GSGr3xTpvz0rEe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 275/280] objtool: Ignore end-of-section jumps for KCOV/GCOV
Date: Tue, 29 Apr 2025 18:43:36 +0200
Message-ID: <20250429161126.385173501@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1570,6 +1570,8 @@ static int add_jump_destinations(struct
 	unsigned long dest_off;
 
 	for_each_insn(file, insn) {
+		struct symbol *func = insn_func(insn);
+
 		if (insn->jump_dest) {
 			/*
 			 * handle_group_alt() may have previously set
@@ -1593,7 +1595,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->return_thunk) {
 			add_return_call(file, insn, true);
 			continue;
-		} else if (insn_func(insn)) {
+		} else if (func) {
 			/*
 			 * External sibling call or internal sibling call with
 			 * STT_FUNC reloc.
@@ -1626,6 +1628,15 @@ static int add_jump_destinations(struct
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
@@ -1650,8 +1661,7 @@ static int add_jump_destinations(struct
 		/*
 		 * Cross-function jump.
 		 */
-		if (insn_func(insn) && insn_func(jump_dest) &&
-		    insn_func(insn) != insn_func(jump_dest)) {
+		if (func && insn_func(jump_dest) && func != insn_func(jump_dest)) {
 
 			/*
 			 * For GCC 8+, create parent/child links for any cold
@@ -1668,10 +1678,10 @@ static int add_jump_destinations(struct
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
 


