Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2653183A06;
	Mon,  8 Apr 2024 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582688; cv=none; b=Sqq1Zml4FgUCh0AOgnVXuAQf8ywbG26QPAst2KrPSr7bHiQ3+rOZlfaEnr68ktwX717rNq2YTKmGBY6u9DQT8qIRU9Y0sfOxhyfKAeOtHsTi6mHSXeOa9mIYfQ9xp/W7D7jFGt9SnbV4wAYkt+lQ4pnNM6nigDB45agQ2zhNcCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582688; c=relaxed/simple;
	bh=04Gi2D1gWD5jo905sehyc0ydG1cgv+a+JP4RNy4PyWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUDFmuOwpfgb9TvdzE7eIlJVZ925zj7HqNvfFxsfgVIaFHjgygg/CJ/OCavcs8L6GQEGNDWAty2GGlbDwPR8JiSONFvsaWDUBCNep8fNW6A0rs4qLmTnm1Nf9Yjx3DHHcxALc0knYHyyfFIAvmkl5wV4bvaqevRnVBojv5RKrzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1TyhamT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1TyhamT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B21C433F1;
	Mon,  8 Apr 2024 13:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582687;
	bh=04Gi2D1gWD5jo905sehyc0ydG1cgv+a+JP4RNy4PyWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1TyhamTc/lEtzafauwXsAWW6fQFuQRMGrad4HIXPzuo5IAmkesNwBLXXRsjBKfH1
	 BTE5qE7jieom9fVG697zkbsW3ifIIRX5PqSqT/cdND8847QOW6E7Izo8CKAKCiu8SI
	 MgXPGX+uN4n+HkLpbkRWq7CA9rc1FAK40NkGoUmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Erhard F." <erhard_f@mailbox.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 165/690] x86/static_call: Add support for Jcc tail-calls
Date: Mon,  8 Apr 2024 14:50:31 +0200
Message-ID: <20240408125405.529079653@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 923510c88d2b7d947c4217835fd9ca6bd65cc56c upstream.

Clang likes to create conditional tail calls like:

  0000000000000350 <amd_pmu_add_event>:
  350:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1) 351: R_X86_64_NONE      __fentry__-0x4
  355:       48 83 bf 20 01 00 00 00         cmpq   $0x0,0x120(%rdi)
  35d:       0f 85 00 00 00 00       jne    363 <amd_pmu_add_event+0x13>     35f: R_X86_64_PLT32     __SCT__amd_pmu_branch_add-0x4
  363:       e9 00 00 00 00          jmp    368 <amd_pmu_add_event+0x18>     364: R_X86_64_PLT32     __x86_return_thunk-0x4

Where 0x35d is a static call site that's turned into a conditional
tail-call using the Jcc class of instructions.

Teach the in-line static call text patching about this.

Notably, since there is no conditional-ret, in that case patch the Jcc
to point at an empty stub function that does the ret -- or the return
thunk when needed.

Reported-by: "Erhard F." <erhard_f@mailbox.org>
Change-Id: I99c8fc3f721e5d1c74f06710b38d4bac5230303a
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/Y9Kdg9QjHkr9G5b5@hirez.programming.kicks-ass.net
[cascardo: __static_call_validate didn't have the bool tramp argument]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/static_call.c |   50 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -9,6 +9,7 @@ enum insn_type {
 	NOP = 1,  /* site cond-call */
 	JMP = 2,  /* tramp / site tail-call */
 	RET = 3,  /* tramp / site cond-tail-call */
+	JCC = 4,
 };
 
 /*
@@ -25,12 +26,40 @@ static const u8 xor5rax[] = { 0x2e, 0x2e
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
+static u8 __is_Jcc(u8 *insn) /* Jcc.d32 */
+{
+	u8 ret = 0;
+
+	if (insn[0] == 0x0f) {
+		u8 tmp = insn[1];
+		if ((tmp & 0xf0) == 0x80)
+			ret = tmp;
+	}
+
+	return ret;
+}
+
+extern void __static_call_return(void);
+
+asm (".global __static_call_return\n\t"
+     ".type __static_call_return, @function\n\t"
+     ASM_FUNC_ALIGN "\n\t"
+     "__static_call_return:\n\t"
+     ANNOTATE_NOENDBR
+     ANNOTATE_RETPOLINE_SAFE
+     "ret; int3\n\t"
+     ".size __static_call_return, . - __static_call_return \n\t");
+
 static void __ref __static_call_transform(void *insn, enum insn_type type,
 					  void *func, bool modinit)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
 	const void *code;
+	u8 op, buf[6];
+
+	if ((type == JMP || type == RET) && (op = __is_Jcc(insn)))
+		type = JCC;
 
 	switch (type) {
 	case CALL:
@@ -56,6 +85,20 @@ static void __ref __static_call_transfor
 		else
 			code = &retinsn;
 		break;
+
+	case JCC:
+		if (!func) {
+			func = __static_call_return;
+			if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+				func = x86_return_thunk;
+		}
+
+		buf[0] = 0x0f;
+		__text_gen_insn(buf+1, op, insn+1, func, 5);
+		code = buf;
+		size = 6;
+
+		break;
 	}
 
 	if (memcmp(insn, code, size) == 0)
@@ -67,13 +110,14 @@ static void __ref __static_call_transfor
 	text_poke_bp(insn, code, size, emulate);
 }
 
-static void __static_call_validate(void *insn, bool tail)
+static void __static_call_validate(u8 *insn, bool tail)
 {
-	u8 opcode = *(u8 *)insn;
+	u8 opcode = insn[0];
 
 	if (tail) {
 		if (opcode == JMP32_INSN_OPCODE ||
-		    opcode == RET_INSN_OPCODE)
+		    opcode == RET_INSN_OPCODE ||
+		    __is_Jcc(insn))
 			return;
 	} else {
 		if (opcode == CALL_INSN_OPCODE ||


