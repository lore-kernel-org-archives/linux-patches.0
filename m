Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346B830EF7F;
	Fri, 21 Nov 2025 13:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733169; cv=none; b=ODdqiUBriaWFUpMzUKSvopgvzm5+lW7kb+KRUSqbdFHsGiRr7xQeRfm7GVSAMTKKh3ibozIKfEjApf8z0yonaUzuC8kjnika5+8KEhXp+v0BeMSW1/8XDjanMFPEy1vrjuLyiRK5bzXCBtsxrMhg24s3WToTkFN2Ulgq0sojF+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733169; c=relaxed/simple;
	bh=g646qc3woR6+zAYmIm3VHrNq4IgwJAkNFUiMO7fEYT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GH7c/qucJhQ7g1olfgxnWGAZQAX5gVN/8cyCAuO/y7FMiYZ+Xaft5LOKb9Llng0n4jIwyRvYDhtXk/8EtLlowLW3/D1c8YTYCvJIG4MIqV0iz7gz6FVneGAqMgURQrzJEXozUJy6SPwH8pbKgDNBaxh4bD+KKjpigz1q2KhdnEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mmbn7jbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mmbn7jbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA430C4CEF1;
	Fri, 21 Nov 2025 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733169;
	bh=g646qc3woR6+zAYmIm3VHrNq4IgwJAkNFUiMO7fEYT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mmbn7jbF/cPfrCzWDMyYteYm0OsKOeffLVlL6CyLMZPfEf8UufDpNhkHMW8lc/Qt6
	 ptXsv0feVd7klDOVmjvfZ3UgRkRJbJXBiqmzClx0pqoLY87z4CfQ6SPhMBW3XtA1vt
	 BzFn7kUDL1Xp1lHfdJPBI47QWg0FOdzAC3waqFlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 375/529] riscv: stacktrace: fix backtracing through exceptions
Date: Fri, 21 Nov 2025 14:11:14 +0100
Message-ID: <20251121130244.369468845@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

commit 51356ce60e5915a6bd812873186ed54e45c2699d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/entry.S      |    1 +
 arch/riscv/kernel/stacktrace.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -174,6 +174,7 @@ SYM_CODE_START_NOALIGN(ret_from_exceptio
 #else
 	sret
 #endif
+SYM_INNER_LABEL(ret_from_exception_end, SYM_L_GLOBAL)
 SYM_CODE_END(ret_from_exception)
 ASM_NOKPROBE(ret_from_exception)
 
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -33,6 +33,7 @@
 })
 
 extern asmlinkage void handle_exception(void);
+extern unsigned long ret_from_exception_end;
 
 static inline int fp_is_valid(unsigned long fp, unsigned long sp)
 {
@@ -88,7 +89,8 @@ void notrace walk_stackframe(struct task
 			pc = READ_ONCE_TASK_STACK(task, frame->ra);
 			pc = ftrace_graph_ret_addr(current, &graph_idx, pc,
 						   &frame->ra);
-			if (pc == (unsigned long)handle_exception) {
+			if (pc >= (unsigned long)handle_exception &&
+			    pc < (unsigned long)&ret_from_exception_end) {
 				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
 					break;
 


