Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF8A1D12E4;
	Wed,  2 Oct 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879048; cv=none; b=SJ7DVezJPHx14gAcC0VH5FEtGkKnlkwHBdbrOujrv8+YnR+3Y6bOIBcVDnY9Xm20RCePFFDGxRNkF9Ef3BXWsDieBuP6WM3CHMTmOcrXCZcklhW3SYqKTxmGQZavEYdK34QJ9dldm8xaGbRuCSVynmA144+U+FUGopvbvZDS810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879048; c=relaxed/simple;
	bh=UdaVEj2VSMAo4o+go8Z/gP6j1Zw2vKIC7b/jCDuMKz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rysM3iyqj5J3FVmS63ZyQ00JioasULVLMDsGNo+0xy34GAz1gYEtm5cXVClrfjNIZO11K+t7fa1udN9gLLo4HKFa1oJ6gJC1THj66/maMz1qeZL8OxxlmvLdzb7l7KUsKR5bVQN+Jn/zSEjOj1phjqTdryySpkG+Q9ZRyZSfxLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNLG5uuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNLG5uuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71CCC4CEC2;
	Wed,  2 Oct 2024 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879048;
	bh=UdaVEj2VSMAo4o+go8Z/gP6j1Zw2vKIC7b/jCDuMKz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNLG5uuZLlWMClCGYTK0GNRy4NLGl6wv3rgMo4mkSildfFrqTzpRrUeiBLnMxVDzI
	 1S3ZKMlcKQA4iY3NS93eZDpuh/xyAFaTZmO/rL6ikldW4CpcOnWIKOaZDAkjg6Swjz
	 c1kDI6TGpu9y5vu815NqNnphLXI4GPYYdnsKjRB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.10 621/634] s390/ftrace: Avoid calling unwinder in ftrace_return_address()
Date: Wed,  2 Oct 2024 15:02:01 +0200
Message-ID: <20241002125835.639217644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit a84dd0d8ae24bdc6da341187fc4c1a0adfce2ccc upstream.

ftrace_return_address() is called extremely often from
performance-critical code paths when debugging features like
CONFIG_TRACE_IRQFLAGS are enabled. For example, with debug_defconfig,
ftrace selftests on my LPAR currently execute ftrace_return_address()
as follows:

ftrace_return_address(0) - 0 times (common code uses __builtin_return_address(0) instead)
ftrace_return_address(1) - 2,986,805,401 times (with this patch applied)
ftrace_return_address(2) - 140 times
ftrace_return_address(>2) - 0 times

The use of __builtin_return_address(n) was replaced by return_address()
with an unwinder call by commit cae74ba8c295 ("s390/ftrace:
Use unwinder instead of __builtin_return_address()") because
__builtin_return_address(n) simply walks the stack backchain and doesn't
check for reaching the stack top. For shallow stacks with fewer than
"n" frames, this results in reads at low addresses and random
memory accesses.

While calling the fully functional unwinder "works", it is very slow
for this purpose. Moreover, potentially following stack switches and
walking past IRQ context is simply wrong thing to do for
ftrace_return_address().

Reimplement return_address() to essentially be __builtin_return_address(n)
with checks for reaching the stack top. Since the ftrace_return_address(n)
argument is always a constant, keep the implementation in the header,
allowing both GCC and Clang to unroll the loop and optimize it to the
bare minimum.

Fixes: cae74ba8c295 ("s390/ftrace: Use unwinder instead of __builtin_return_address()")
Cc: stable@vger.kernel.org
Reported-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/ftrace.h |   17 ++++++++++++++++-
 arch/s390/kernel/stacktrace.c  |   19 -------------------
 2 files changed, 16 insertions(+), 20 deletions(-)

--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -7,8 +7,23 @@
 #define MCOUNT_INSN_SIZE	6
 
 #ifndef __ASSEMBLY__
+#include <asm/stacktrace.h>
 
-unsigned long return_address(unsigned int n);
+static __always_inline unsigned long return_address(unsigned int n)
+{
+	struct stack_frame *sf;
+
+	if (!n)
+		return (unsigned long)__builtin_return_address(0);
+
+	sf = (struct stack_frame *)current_frame_address();
+	do {
+		sf = (struct stack_frame *)sf->back_chain;
+		if (!sf)
+			return 0;
+	} while (--n);
+	return sf->gprs[8];
+}
 #define ftrace_return_address(n) return_address(n)
 
 void ftrace_caller(void);
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -162,22 +162,3 @@ void arch_stack_walk_user(stack_trace_co
 {
 	arch_stack_walk_user_common(consume_entry, cookie, NULL, regs, false);
 }
-
-unsigned long return_address(unsigned int n)
-{
-	struct unwind_state state;
-	unsigned long addr;
-
-	/* Increment to skip current stack entry */
-	n++;
-
-	unwind_for_each_frame(&state, NULL, NULL, 0) {
-		addr = unwind_get_return_address(&state);
-		if (!addr)
-			break;
-		if (!n--)
-			return addr;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(return_address);


