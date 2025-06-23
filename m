Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBF19F120;
	Mon, 23 Jun 2025 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717080; cv=none; b=tzXyhCxuolYvGgw5vkOY9+TYnrRbOhCaLuHvgK9quFv5hIRW+cj6MN5vxfw06KsSNVT/mn53uRIHVR9vYJU0yFgubaIBXkSqK9NJrqSjdhW6DXjU9sTosXR4zA913mQvjffygA2Ay9p+AVAfK39CR9Rb1IMSLu61j0F+yhbbMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717080; c=relaxed/simple;
	bh=bdKMON2JPCB1uMpEAAd/SfFDMcdRXnEIeruK6mFvMVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2RjVHhiz9kua3q/bAVQWz+IE4DaF+SsM+eUj9Mnnji15/tJxO6ePuiNV/pEJpyo5s//8euR0T7ZjsFV5m+FoUZcfWpCq0pHeYllVAg6AWJcxDNRkluX6WXXcz3DBARXtN0ijoinVyM37kLVVs4isbXJsFA3Vwp+G9zpz61TYCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPkdUayR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPkdUayR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BD1C4CEEA;
	Mon, 23 Jun 2025 22:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717079;
	bh=bdKMON2JPCB1uMpEAAd/SfFDMcdRXnEIeruK6mFvMVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPkdUayR0+rvobsga3MY5rICrW/Kf4GC1IeKD5sOgmQfz4vXqpU2UY+PMPsLbmYS0
	 hTh0zzVDoSV2ilYgMGB6GdH+z66Iz2+zlzIaTWaWx2wH3zku2VYh8nWmyPXO11ARIZ
	 2eTz7qdoZvhpHyZ1j3pHX3dE0PpU8TFiRSxWmQ2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [PATCH 6.12 318/414] selftests/x86: Add a test to detect infinite SIGTRAP handler loop
Date: Mon, 23 Jun 2025 15:07:35 +0200
Message-ID: <20250623130649.947183933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Xin Li (Intel) <xin@zytor.com>

commit f287822688eeb44ae1cf6ac45701d965efc33218 upstream.

When FRED is enabled, if the Trap Flag (TF) is set without an external
debugger attached, it can lead to an infinite loop in the SIGTRAP
handler.  To avoid this, the software event flag in the augmented SS
must be cleared, ensuring that no single-step trap remains pending when
ERETU completes.

This test checks for that specific scenario—verifying whether the kernel
correctly prevents an infinite SIGTRAP loop in this edge case when FRED
is enabled.

The test should _always_ pass with IDT event delivery, thus no need to
disable the test even when FRED is not enabled.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250609084054.2083189-3-xin%40zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/x86/Makefile       |    2 
 tools/testing/selftests/x86/sigtrap_loop.c |  101 +++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/x86/sigtrap_loop.c

--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -12,7 +12,7 @@ CAN_BUILD_WITH_NOPIE := $(shell ./check_
 
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl ioperm \
-			test_vsyscall mov_ss_trap \
+			test_vsyscall mov_ss_trap sigtrap_loop \
 			syscall_arg_fault fsgsbase_restore sigaltstack
 TARGETS_C_BOTHBITS += nx_stack
 TARGETS_C_32BIT_ONLY := entry_from_vm86 test_syscall_vdso unwind_vdso \
--- /dev/null
+++ b/tools/testing/selftests/x86/sigtrap_loop.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Intel Corporation
+ */
+#define _GNU_SOURCE
+
+#include <err.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ucontext.h>
+
+#ifdef __x86_64__
+# define REG_IP REG_RIP
+#else
+# define REG_IP REG_EIP
+#endif
+
+static void sethandler(int sig, void (*handler)(int, siginfo_t *, void *), int flags)
+{
+	struct sigaction sa;
+
+	memset(&sa, 0, sizeof(sa));
+	sa.sa_sigaction = handler;
+	sa.sa_flags = SA_SIGINFO | flags;
+	sigemptyset(&sa.sa_mask);
+
+	if (sigaction(sig, &sa, 0))
+		err(1, "sigaction");
+
+	return;
+}
+
+static void sigtrap(int sig, siginfo_t *info, void *ctx_void)
+{
+	ucontext_t *ctx = (ucontext_t *)ctx_void;
+	static unsigned int loop_count_on_same_ip;
+	static unsigned long last_trap_ip;
+
+	if (last_trap_ip == ctx->uc_mcontext.gregs[REG_IP]) {
+		printf("\tTrapped at %016lx\n", last_trap_ip);
+
+		/*
+		 * If the same IP is hit more than 10 times in a row, it is
+		 * _considered_ an infinite loop.
+		 */
+		if (++loop_count_on_same_ip > 10) {
+			printf("[FAIL]\tDetected SIGTRAP infinite loop\n");
+			exit(1);
+		}
+
+		return;
+	}
+
+	loop_count_on_same_ip = 0;
+	last_trap_ip = ctx->uc_mcontext.gregs[REG_IP];
+	printf("\tTrapped at %016lx\n", last_trap_ip);
+}
+
+int main(int argc, char *argv[])
+{
+	sethandler(SIGTRAP, sigtrap, 0);
+
+	/*
+	 * Set the Trap Flag (TF) to single-step the test code, therefore to
+	 * trigger a SIGTRAP signal after each instruction until the TF is
+	 * cleared.
+	 *
+	 * Because the arithmetic flags are not significant here, the TF is
+	 * set by pushing 0x302 onto the stack and then popping it into the
+	 * flags register.
+	 *
+	 * Four instructions in the following asm code are executed with the
+	 * TF set, thus the SIGTRAP handler is expected to run four times.
+	 */
+	printf("[RUN]\tSIGTRAP infinite loop detection\n");
+	asm volatile(
+#ifdef __x86_64__
+		/*
+		 * Avoid clobbering the redzone
+		 *
+		 * Equivalent to "sub $128, %rsp", however -128 can be encoded
+		 * in a single byte immediate while 128 uses 4 bytes.
+		 */
+		"add $-128, %rsp\n\t"
+#endif
+		"push $0x302\n\t"
+		"popf\n\t"
+		"nop\n\t"
+		"nop\n\t"
+		"push $0x202\n\t"
+		"popf\n\t"
+#ifdef __x86_64__
+		"sub $-128, %rsp\n\t"
+#endif
+	);
+
+	printf("[OK]\tNo SIGTRAP infinite loop detected\n");
+	return 0;
+}


