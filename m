Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29911268685;
	Tue,  8 Apr 2025 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110407; cv=none; b=AlJRejHs9jJtnyaP2n7LXjMU/nSgTB95J3VwHPh0dV6xSRMYvqh2AsVFUDnIgLVMuMOcva1vC/Mzq0KR1fYDpwzcTd+A8G9nR+cf+hkqtizNo9gISIALzs6TEHy7Nw21WlmaILVwfpJrtwIU+7TkWdFDUqSjaedE9AGnzRhFRkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110407; c=relaxed/simple;
	bh=fi3v1uD4ty4S2CKjC5+zNB1sLp+Z73CqfMcipQZZwJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVZF/3O7rL0biD1Apq4sKoHLQLn4GQAg9G6EbTl4BcuU2GAKxD3acFiCL0Ii1OeXtuwI8E6yZXtUE6Xj2CYz1bwgybv1LsAPlQSDQCQUm4ItM6S6OoJU/CCDoRJZEDlrAHIjLSj5+pR0dVc3SyrvOrc/yuojVEHZf5QLX+9nUE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WTliIXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WTliIXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC131C4CEE7;
	Tue,  8 Apr 2025 11:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110407;
	bh=fi3v1uD4ty4S2CKjC5+zNB1sLp+Z73CqfMcipQZZwJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WTliIXXXpNqq84U9LtUBUDg0hTSvRkqj4+EatfMCFa9UoX1nqidwkVEgGU9OmOxg
	 K98YMbpwaEwqfZksJsGf8WMT2V2p9c5+OIcCtKEQpaA+6nNTrPcfIAixL6Tz0MGkoQ
	 Wm2FeSdDKNUHOI2ZDq9UEaAZfteR+/GHL5Cp+Iyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 053/731] x86/traps: Make exc_double_fault() consistently noreturn
Date: Tue,  8 Apr 2025 12:39:10 +0200
Message-ID: <20250408104915.506992165@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
index ce973d9d8e6d8..c1fa0220f33de 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4449,35 +4449,6 @@ static int validate_sls(struct objtool_file *file)
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
@@ -4494,7 +4465,7 @@ static int validate_reachable_instructions(struct objtool_file *file)
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



