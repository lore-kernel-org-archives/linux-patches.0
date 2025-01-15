Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F4F248BD1;
	Wed, 15 Jan 2025 10:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938083; cv=none; b=BgBK1pyTAZFV+jeCWw86OuQXhNgBSrlZHwxm2RhAz7yPGK8Ode+Yyca/d0cFNJHodRbDYiUxr8VJOk+bHpFjljXo9MjSjTCoLkdzYaiaJMwB0qmMN+R9lmVyUfPB+xkuRlct12GsmJwp1cEMr1YP560df94dQVQvUISZfoO4BJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938083; c=relaxed/simple;
	bh=ccb1rhupZfNODDWDjDr/nCZakpz8py4uInPfQfNEvxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hz+0rsf0BGtD6mJ8SKKLvgDs/xyY3jHygzsPEDazcsGbO8OVq5qfKURMa/lzyqJH3/KBQHO80oNwDNNkOF4eeTbxYyxKz7PclexFlpsBwjwlSQb+cLMKlq3a5n/kFEu7W9tWVgU9H/KGSCywAhj3nG6FUriFD2HS7wYcqkoEuLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BN9x1WMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BN9x1WMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CB4C4CEDF;
	Wed, 15 Jan 2025 10:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938083;
	bh=ccb1rhupZfNODDWDjDr/nCZakpz8py4uInPfQfNEvxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BN9x1WMKiLJdpyqnMxvkVLW5JD8ducDkOe+RDhaVAcllggez//bDEgpunWOvqg/ZQ
	 qhC+sk6jOIRzxuDWUTOuTs+bjxnwxc0j3QHofncdV5rcCXklOYsToqiDSzyWzPFbIV
	 yEQ74um0Lk8EC0ZTwiOj5RREDFkHSDlZhL8dYqJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/189] riscv: stacktrace: fix backtracing through exceptions
Date: Wed, 15 Jan 2025 11:36:14 +0100
Message-ID: <20250115103609.463357796@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 51356ce60e5915a6bd812873186ed54e45c2699d ]

Prior to commit 5d5fc33ce58e ("riscv: Improve exception and system call
latency"), backtrace through exception worked since ra was filled with
ret_from_exception symbol address and the stacktrace code checked 'pc' to
be equal to that symbol. Now that handle_exception uses regular 'call'
instructions, this isn't working anymore and backtrace stops at
handle_exception(). Since there are multiple call site to C code in the
exception handling path, rather than checking multiple potential return
addresses, add a new symbol at the end of exception handling and check pc
to be in that range.

Fixes: 5d5fc33ce58e ("riscv: Improve exception and system call latency")
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20241209155714.1239665-1-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S      | 1 +
 arch/riscv/kernel/stacktrace.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index c200d329d4bd..7a6c48e6d211 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -278,6 +278,7 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 #else
 	sret
 #endif
+SYM_INNER_LABEL(ret_from_exception_end, SYM_L_GLOBAL)
 SYM_CODE_END(ret_from_exception)
 ASM_NOKPROBE(ret_from_exception)
 
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 153a2db4c5fa..d4355c770c36 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -17,6 +17,7 @@
 #ifdef CONFIG_FRAME_POINTER
 
 extern asmlinkage void handle_exception(void);
+extern unsigned long ret_from_exception_end;
 
 static inline int fp_is_valid(unsigned long fp, unsigned long sp)
 {
@@ -71,7 +72,8 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, &graph_idx, frame->ra,
 						   &frame->ra);
-			if (pc == (unsigned long)handle_exception) {
+			if (pc >= (unsigned long)handle_exception &&
+			    pc < (unsigned long)&ret_from_exception_end) {
 				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
 					break;
 
-- 
2.39.5



