Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9123F26B94D;
	Tue,  8 Apr 2025 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116137; cv=none; b=m297DOiIq1QZFBvgUx9AYMy5TiOHcwNkw+tlI3GfiGoWlaDe8QlNogXIc2uSsntQgi5dtg71rnMhjh3FyZBia52iIWb+Px+HvuG/1kjrPI5pzL8xvmIkunmCbRqUq4Sf3RJ2UlonYqcfxzJsvRQfWCTa08KitzPDPammLtfKxjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116137; c=relaxed/simple;
	bh=FvWvNLxLgLE4qQBdOYwvK+km0XGn937UOgmKIROYeU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLq0ZW3MEzQoxlAGM3g+sNDL5+8MSBr67PAfGUA2Z3APa6VUC1m6rguYQ1R9OphmGw6gSvWt5IPLoH5vg0hpSRiHgXrEv9XOPC5td5gRExWjtoQfcseCOZb10j8fN3XLY0VLKjVOiJyV/8U43r0xfafN3DhTT9aEIpAcnHi2wfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcY+GHx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcY+GHx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245B6C4CEE5;
	Tue,  8 Apr 2025 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116137;
	bh=FvWvNLxLgLE4qQBdOYwvK+km0XGn937UOgmKIROYeU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcY+GHx0kRL6Qrx2S/TMB7t/g7MwVjGkQSFlHjZb/kgrbiOp5V7yj+oQkPSB02r7g
	 Ur58I0LRB86NqAzn+djNcaOYPg0uW6ioq04fBHBlVp+jUobNxPhO5UKZx3mE9H6bnk
	 I2cQfELd1Za5qcd1WJ9xVY9SYcc1pWexQpT15PsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/423] x86/traps: Make exc_double_fault() consistently noreturn
Date: Tue,  8 Apr 2025 12:45:55 +0200
Message-ID: <20250408104846.427783768@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

[ Upstream commit 8085fcd78c1a3dbdf2278732579009d41ce0bc4e ]

The CONFIG_X86_ESPFIX64 version of exc_double_fault() can return to its
caller, but the !CONFIG_X86_ESPFIX64 version never does.  In the latter
case the compiler and/or objtool may consider it to be implicitly
noreturn.

However, due to the currently inflexible way objtool detects noreturns,
a function's noreturn status needs to be consistent across configs.

The current workaround for this issue is to suppress unreachable
warnings for exc_double_fault()'s callers.  Unfortunately that can
result in ORC coverage gaps and potentially worse issues like inert
static calls and silently disabled CPU mitigations.

Instead, prevent exc_double_fault() from ever being implicitly marked
noreturn by forcing a return behind a never-taken conditional.

Until a more integrated noreturn detection method exists, this is likely
the least objectionable workaround.

Fixes: 55eeab2a8a11 ("objtool: Ignore exc_double_fault() __noreturn warnings")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Link: https://lore.kernel.org/r/d1f4026f8dc35d0de6cc61f2684e0cb6484009d1.1741975349.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/traps.c | 18 +++++++++++++++++-
 tools/objtool/check.c   | 31 +------------------------------
 2 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2dbadf347b5f4..5e3e036e6e537 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -379,6 +379,21 @@ __visible void __noreturn handle_stack_overflow(struct pt_regs *regs,
 }
 #endif
 
+/*
+ * Prevent the compiler and/or objtool from marking the !CONFIG_X86_ESPFIX64
+ * version of exc_double_fault() as noreturn.  Otherwise the noreturn mismatch
+ * between configs triggers objtool warnings.
+ *
+ * This is a temporary hack until we have compiler or plugin support for
+ * annotating noreturns.
+ */
+#ifdef CONFIG_X86_ESPFIX64
+#define always_true() true
+#else
+bool always_true(void);
+bool __weak always_true(void) { return true; }
+#endif
+
 /*
  * Runs on an IST stack for x86_64 and on a special task stack for x86_32.
  *
@@ -514,7 +529,8 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 
 	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
 	die("double fault", regs, error_code);
-	panic("Machine halted.");
+	if (always_true())
+		panic("Machine halted.");
 	instrumentation_end();
 }
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3c3e5760e81b8..24a1adca30dbc 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4575,35 +4575,6 @@ static int validate_sls(struct objtool_file *file)
 	return warnings;
 }
 
-static bool ignore_noreturn_call(struct instruction *insn)
-{
-	struct symbol *call_dest = insn_call_dest(insn);
-
-	/*
-	 * FIXME: hack, we need a real noreturn solution
-	 *
-	 * Problem is, exc_double_fault() may or may not return, depending on
-	 * whether CONFIG_X86_ESPFIX64 is set.  But objtool has no visibility
-	 * to the kernel config.
-	 *
-	 * Other potential ways to fix it:
-	 *
-	 *   - have compiler communicate __noreturn functions somehow
-	 *   - remove CONFIG_X86_ESPFIX64
-	 *   - read the .config file
-	 *   - add a cmdline option
-	 *   - create a generic objtool annotation format (vs a bunch of custom
-	 *     formats) and annotate it
-	 */
-	if (!strcmp(call_dest->name, "exc_double_fault")) {
-		/* prevent further unreachable warnings for the caller */
-		insn->sym->warned = 1;
-		return true;
-	}
-
-	return false;
-}
-
 static int validate_reachable_instructions(struct objtool_file *file)
 {
 	struct instruction *insn, *prev_insn;
@@ -4620,7 +4591,7 @@ static int validate_reachable_instructions(struct objtool_file *file)
 		prev_insn = prev_insn_same_sec(file, insn);
 		if (prev_insn && prev_insn->dead_end) {
 			call_dest = insn_call_dest(prev_insn);
-			if (call_dest && !ignore_noreturn_call(prev_insn)) {
+			if (call_dest) {
 				WARN_INSN(insn, "%s() is missing a __noreturn annotation",
 					  call_dest->name);
 				warnings++;
-- 
2.39.5



