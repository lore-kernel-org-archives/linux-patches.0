Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073741AF0BB;
	Tue, 27 May 2025 17:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367677; cv=none; b=BrPUKxvo82sLsNCgtR072RkQSoG2R5iJAwQfN06pf2a4AuhiIorUxjgAOmQmtYLjwdn9bOOq7qumUnoZYJN9hfvgFpaKagTqLUE6s9/N3ZaSw0s0amCO2HXLFhxmFLoMmVo5C1g4oU/qZA2G0wtHJZ+AlTBT7DdmToCYBv+S9XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367677; c=relaxed/simple;
	bh=35Q5Hrlsc/EOioErS8bTvufnwb03Hh7OlZRGDn9Et3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NymTdYSFEnwN/YaTpWJRVMOLO+ie4FB7h0BRc+3C2N6wOREYWtFR4dmzZ0B7FX3ujpZzvisoBJw6+AvqpYL28ZijBo5YUeBbN2FMM2oExo5KdjJooCg+DtFIYLkFHyz7Kcp4DzrvQR+75Cr3Kt0OgLPQjOrL3qzo0fJ7G1y3Kec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDlbnswV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDlbnswV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B5CC4CEE9;
	Tue, 27 May 2025 17:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367676;
	bh=35Q5Hrlsc/EOioErS8bTvufnwb03Hh7OlZRGDn9Et3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDlbnswVBQKI1SXrhvGXRFJAiXLucbPjLW1g5IoZei5GC1Pvx1WyujPccsOLPpsL2
	 oX1Q1JA91OHYuE6T2Ngc5otbw7MN9NeLd/mx2R6Vv99P51MwQOuSyvqcMB3FI4HdHX
	 458z5sVHqH9GCEl6TinY/gpav6OsJxDqsM1xKRJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 463/783] x86/ibt: Handle FineIBT in handle_cfi_failure()
Date: Tue, 27 May 2025 18:24:20 +0200
Message-ID: <20250527162531.988538210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 882b86fd4e0d49bf91148dbadcdbece19ded40e6 ]

Sami reminded me that FineIBT failure does not hook into the regular
CFI failure case, and as such CFI_PERMISSIVE does not work.

Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lkml.kernel.org/r/20250214092619.GB21726@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cfi.h    | 11 +++++++++++
 arch/x86/kernel/alternative.c | 30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cfi.c         | 22 ++++++++++++++++++----
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cfi.h b/arch/x86/include/asm/cfi.h
index 31d19c815f992..7dd5ab239c87b 100644
--- a/arch/x86/include/asm/cfi.h
+++ b/arch/x86/include/asm/cfi.h
@@ -126,6 +126,17 @@ static inline int cfi_get_offset(void)
 
 extern u32 cfi_get_func_hash(void *func);
 
+#ifdef CONFIG_FINEIBT
+extern bool decode_fineibt_insn(struct pt_regs *regs, unsigned long *target, u32 *type);
+#else
+static inline bool
+decode_fineibt_insn(struct pt_regs *regs, unsigned long *target, u32 *type)
+{
+	return false;
+}
+
+#endif
+
 #else
 static inline enum bug_trap_type handle_cfi_failure(struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f843fd37cf987..e1913bcb806e2 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1271,6 +1271,7 @@ asm(	".pushsection .rodata			\n"
 	"	endbr64				\n"
 	"	subl	$0x12345678, %r10d	\n"
 	"	je	fineibt_preamble_end	\n"
+	"fineibt_preamble_ud2:			\n"
 	"	ud2				\n"
 	"	nop				\n"
 	"fineibt_preamble_end:			\n"
@@ -1278,9 +1279,11 @@ asm(	".pushsection .rodata			\n"
 );
 
 extern u8 fineibt_preamble_start[];
+extern u8 fineibt_preamble_ud2[];
 extern u8 fineibt_preamble_end[];
 
 #define fineibt_preamble_size (fineibt_preamble_end - fineibt_preamble_start)
+#define fineibt_preamble_ud2  (fineibt_preamble_ud2 - fineibt_preamble_start)
 #define fineibt_preamble_hash 7
 
 asm(	".pushsection .rodata			\n"
@@ -1598,6 +1601,33 @@ static void poison_cfi(void *addr, void *wr_addr)
 	}
 }
 
+/*
+ * regs->ip points to a UD2 instruction, return true and fill out target and
+ * type when this UD2 is from a FineIBT preamble.
+ *
+ * We check the preamble by checking for the ENDBR instruction relative to the
+ * UD2 instruction.
+ */
+bool decode_fineibt_insn(struct pt_regs *regs, unsigned long *target, u32 *type)
+{
+	unsigned long addr = regs->ip - fineibt_preamble_ud2;
+	u32 endbr, hash;
+
+	__get_kernel_nofault(&endbr, addr, u32, Efault);
+	if (endbr != gen_endbr())
+		return false;
+
+	*target = addr + fineibt_preamble_size;
+
+	__get_kernel_nofault(&hash, addr + fineibt_preamble_hash, u32, Efault);
+	*type = (u32)regs->r10 + hash;
+
+	return true;
+
+Efault:
+	return false;
+}
+
 #else
 
 static void __apply_fineibt(s32 *start_retpoline, s32 *end_retpoline,
diff --git a/arch/x86/kernel/cfi.c b/arch/x86/kernel/cfi.c
index e6bf78fac1462..f6905bef0af84 100644
--- a/arch/x86/kernel/cfi.c
+++ b/arch/x86/kernel/cfi.c
@@ -70,11 +70,25 @@ enum bug_trap_type handle_cfi_failure(struct pt_regs *regs)
 	unsigned long target;
 	u32 type;
 
-	if (!is_cfi_trap(regs->ip))
-		return BUG_TRAP_TYPE_NONE;
+	switch (cfi_mode) {
+	case CFI_KCFI:
+		if (!is_cfi_trap(regs->ip))
+			return BUG_TRAP_TYPE_NONE;
+
+		if (!decode_cfi_insn(regs, &target, &type))
+			return report_cfi_failure_noaddr(regs, regs->ip);
+
+		break;
 
-	if (!decode_cfi_insn(regs, &target, &type))
-		return report_cfi_failure_noaddr(regs, regs->ip);
+	case CFI_FINEIBT:
+		if (!decode_fineibt_insn(regs, &target, &type))
+			return BUG_TRAP_TYPE_NONE;
+
+		break;
+
+	default:
+		return BUG_TRAP_TYPE_NONE;
+	}
 
 	return report_cfi_failure(regs, regs->ip, &target, type);
 }
-- 
2.39.5



