Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF4B221719;
	Tue, 29 Apr 2025 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946571; cv=none; b=L6NaMKGQAqY1mRxPpkQMVsmaGpFymYC/ogAgqjmwH0HMRHIrJuby7CRtY5jYL+DXaWGmt9bXA8CC1EQ83qF7srW5cEFkI3bUlChXWIpT6MbvJCK/MjhtbJzFiuHsogOMPBg14TFxdiDN1Rpu7bdQc7y1hNexR9qY0P1JR7C7JjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946571; c=relaxed/simple;
	bh=QEJ0SZJy/fCHG4UVAXahwhBXEyzAcnstFTnDYNmpdFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfRfkDjjbIe7R7ev/t0nJsbEuXjXsw4bBU3KU/4WdmWPlaeyR3/I0VCeHkQWq79Wkg/kYIhezUCMd4USxbxMiWtUgedwh7C0SwxeePufARpMTAbNvVPyhjN9jFAr0NzmpWVMqYPZQozp6cUxRTgy5Ng7Be2hN3xM06jBfjQrfKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auN83eYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auN83eYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F84C4CEE3;
	Tue, 29 Apr 2025 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946570;
	bh=QEJ0SZJy/fCHG4UVAXahwhBXEyzAcnstFTnDYNmpdFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auN83eYUC34Wrzrqe38ov3GS+2wG5bt/BUKmrQSlK8/m6bj246Y0EjlaGkiWl+UNC
	 MGoZdbaZywO+mghgRph+M5vChZdlyVcQru5QyUt/NIq/cSsIO7YaahDFR6LXxj+h01
	 lf8qsxs89OrcsEM0iJzAMjenBnkUsvw9s4WdXfyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.14 309/311] objtool: Ignore end-of-section jumps for KCOV/GCOV
Date: Tue, 29 Apr 2025 18:42:26 +0200
Message-ID: <20250429161133.651156751@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1482,6 +1482,8 @@ static int add_jump_destinations(struct
 	unsigned long dest_off;
 
 	for_each_insn(file, insn) {
+		struct symbol *func = insn_func(insn);
+
 		if (insn->jump_dest) {
 			/*
 			 * handle_group_alt() may have previously set
@@ -1505,7 +1507,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->return_thunk) {
 			add_return_call(file, insn, true);
 			continue;
-		} else if (insn_func(insn)) {
+		} else if (func) {
 			/*
 			 * External sibling call or internal sibling call with
 			 * STT_FUNC reloc.
@@ -1538,6 +1540,15 @@ static int add_jump_destinations(struct
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
@@ -1562,8 +1573,7 @@ static int add_jump_destinations(struct
 		/*
 		 * Cross-function jump.
 		 */
-		if (insn_func(insn) && insn_func(jump_dest) &&
-		    insn_func(insn) != insn_func(jump_dest)) {
+		if (func && insn_func(jump_dest) && func != insn_func(jump_dest)) {
 
 			/*
 			 * For GCC 8+, create parent/child links for any cold
@@ -1580,10 +1590,10 @@ static int add_jump_destinations(struct
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
 


