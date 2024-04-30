Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE2C211C;
	Tue, 30 Apr 2024 11:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475569; cv=none; b=tTx31IZ2g/evlgs5Mk2cV/j4cA6lASgS7J6PHrHD4dSV6cGJYwpBn7eEv12dRyqf50Of7Sf/UhG0XAhykxp4AstI1zktORHfNHkT6GsbIkJBu9wOZuZNQEJcG8wlm+eBktRRDN6V+3lwWuBsR/jTTP2sXKvpTpKbiSQgkTylo0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475569; c=relaxed/simple;
	bh=ChcnM5RM+24gsjg5+rIeOh5vcZJzI1Kf2nK5PondaVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D97gBMRlQmSY7VZ3ijqwYDIss+RxyJ5hZrxiJMx7HLj/ZS/iXQIVYF/wIokhZ8FLVLiVO3njDWxel2ZjwPpDuOX8YC79blL1jXU3IdmusjEKkZbTNHwvqcxY7N1QWBoHTaIF2ROIdFAiEVKjRUWlqbqnh44gs4zgZmqLyqe808A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gAOX3R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gAOX3R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AD9C2BBFC;
	Tue, 30 Apr 2024 11:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475568;
	bh=ChcnM5RM+24gsjg5+rIeOh5vcZJzI1Kf2nK5PondaVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gAOX3R6gidIq6lg1stRPWUz/sjgvijI1tIValMiJ6aSEBpsy3wYrHxHqRTCMotuB
	 iLuvbVC4WG6SZJhJZmr3snlbzenAVlxIFGAK+vw6SYVs7v4m7jCpJdXWrD3zDvvY7S
	 jdcEOHMWAX0gmQmwqFd8xFCniF9NSEbX4dMAOc4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 136/186] LoongArch: Fix callchain parse error with kernel tracepoint events
Date: Tue, 30 Apr 2024 12:39:48 +0200
Message-ID: <20240430103101.981027069@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit d3119bc985fb645ad3b2a9cf9952c1d56d9daaa3 upstream.

In order to fix perf's callchain parse error for LoongArch, we implement
perf_arch_fetch_caller_regs() which fills several necessary registers
used for callchain unwinding, including sp, fp, and era. This is similar
to the following commits.

commit b3eac0265bf6:
("arm: perf: Fix callchain parse error with kernel tracepoint events")

commit 5b09a094f2fb:
("arm64: perf: Fix callchain parse error with kernel tracepoint events")

commit 9a7e8ec0d4cc:
("riscv: perf: Fix callchain parse error with kernel tracepoint events")

Test with commands:

 perf record -e sched:sched_switch -g --call-graph dwarf
 perf report

Without this patch:

 Children      Self  Command        Shared Object      Symbol
 ........  ........  .............  .................  ....................

 43.41%    43.41%  swapper          [unknown]          [k] 0000000000000000

 10.94%    10.94%  loong-container  [unknown]          [k] 0000000000000000
         |
         |--5.98%--0x12006ba38
         |
         |--2.56%--0x12006bb84
         |
          --2.40%--0x12006b6b8

With this patch, callchain can be parsed correctly:

 Children      Self  Command        Shared Object      Symbol
 ........  ........  .............  .................  ....................

 47.57%    47.57%  swapper          [kernel.vmlinux]   [k] __schedule
         |
         ---__schedule

 26.76%    26.76%  loong-container  [kernel.vmlinux]   [k] __schedule
         |
         |--13.78%--0x12006ba38
         |          |
         |          |--9.19%--__schedule
         |          |
         |           --4.59%--handle_syscall
         |                     do_syscall
         |                     sys_futex
         |                     do_futex
         |                     futex_wait
         |                     futex_wait_queue_me
         |                     hrtimer_start_range_ns
         |                     __schedule
         |
         |--8.38%--0x12006bb84
         |          handle_syscall
         |          do_syscall
         |          sys_epoll_pwait
         |          do_epoll_wait
         |          schedule_hrtimeout_range_clock
         |          hrtimer_start_range_ns
         |          __schedule
         |
          --4.59%--0x12006b6b8
                    handle_syscall
                    do_syscall
                    sys_nanosleep
                    hrtimer_nanosleep
                    do_nanosleep
                    hrtimer_start_range_ns
                    __schedule

Cc: stable@vger.kernel.org
Fixes: b37042b2bb7cd751f0 ("LoongArch: Add perf events support")
Reported-by: Youling Tang <tangyouling@kylinos.cn>
Suggested-by: Youling Tang <tangyouling@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/perf_event.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/loongarch/include/asm/perf_event.h
+++ b/arch/loongarch/include/asm/perf_event.h
@@ -7,6 +7,14 @@
 #ifndef __LOONGARCH_PERF_EVENT_H__
 #define __LOONGARCH_PERF_EVENT_H__
 
+#include <asm/ptrace.h>
+
 #define perf_arch_bpf_user_pt_regs(regs) (struct user_pt_regs *)regs
 
+#define perf_arch_fetch_caller_regs(regs, __ip) { \
+	(regs)->csr_era = (__ip); \
+	(regs)->regs[3] = current_stack_pointer; \
+	(regs)->regs[22] = (unsigned long) __builtin_frame_address(0); \
+}
+
 #endif /* __LOONGARCH_PERF_EVENT_H__ */


