Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D228ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84827C433F2;
	Mon, 12 Dec 2022 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851503;
	bh=3dvlsZ0crK7vigTaS1T23MKHxpBSClQQPfxLSsv+Jmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/djl8Tiemqiiy21LjxbnoH6e+b222l0m4XUnBRsSebeQ4N6B9FqWeb2uvQjdiAFk
	 LtBK5MNx1AdP0tRiqWIlVfD8FbrPKmR/mKEK7B8WfkMEryBqHrNbQTWWuZyDwUyn3y
	 CxraZiQjTEr/VMLkZEWEKgCJVhFw4VT15Gl6+s+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Tomislav Novak <tnovak@fb.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/123] ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels
Date: Mon, 12 Dec 2022 14:16:17 +0100
Message-Id: <20221212130927.323824604@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomislav Novak <tnovak@fb.com>

[ Upstream commit 612695bccfdbd52004551308a55bae410e7cd22f ]

Store the frame address where arm_get_current_stackframe() looks for it
(ARM_r7 instead of ARM_fp if CONFIG_THUMB2_KERNEL=y). Otherwise frame->fp
gets set to 0, causing unwind_frame() to fail.

  # bpftrace -e 't:sched:sched_switch { @[kstack] = count(); exit(); }'
  Attaching 1 probe...
  @[
      __schedule+1059
  ]: 1

A typical first unwind instruction is 0x97 (SP = R7), so after executing
it SP ends up being 0 and -URC_FAILURE is returned.

  unwind_frame(pc = ac9da7d7 lr = 00000000 sp = c69bdda0 fp = 00000000)
  unwind_find_idx(ac9da7d7)
  unwind_exec_insn: insn = 00000097
  unwind_exec_insn: fp = 00000000 sp = 00000000 lr = 00000000 pc = 00000000

With this patch:

  # bpftrace -e 't:sched:sched_switch { @[kstack] = count(); exit(); }'
  Attaching 1 probe...
  @[
      __schedule+1059
      __schedule+1059
      schedule+79
      schedule_hrtimeout_range_clock+163
      schedule_hrtimeout_range+17
      ep_poll+471
      SyS_epoll_wait+111
      sys_epoll_pwait+231
      __ret_fast_syscall+1
  ]: 1

Link: https://lore.kernel.org/r/20220920230728.2617421-1-tnovak@fb.com/

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tomislav Novak <tnovak@fb.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index fe87397c3d8c..bdbc1e590891 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -17,7 +17,7 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
-	(regs)->ARM_fp = (unsigned long) __builtin_frame_address(0); \
+	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
 	(regs)->ARM_sp = current_stack_pointer; \
 	(regs)->ARM_cpsr = SVC_MODE; \
 }
-- 
2.35.1



