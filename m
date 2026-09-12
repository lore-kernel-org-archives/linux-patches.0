Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118483F7A9A;
	Sat, 12 Sep 2026 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201974; cv=none; b=FMdHVHRSP2eWh3AKI+6RRvu1uXZ+d7aJvB/A63SN419EWWSmBBXwgGZU/NS6vALFfYauRs19pk1VTp48EDid3RrZA+GsC6yZOCqXJSbFY6eyhvtxrH46Iw291pmzWOkxf7UOzBly7NbnSCTh5rM3RnEIUkYtcGZETPA2dKmWMas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201974; c=relaxed/simple;
	bh=C+CG2P9uFqj8dVOLlzqMG33wtnWyBhYN0pBnKvTqI+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exXyKjr9L2+59OjrYW35f4vyfyquBipVxQI24uI17qwRpPoW8SAozTQOca0Zk2JEm80/lgXiV5ZOFs+4//1Uk+B5zKjuIQy9lCOv+RvoC5ct1/8kbp/54Q8Xki3qpBMjq1ze4rv5mPYnA9OkucOSDFd6RGamceXe5mujAhgcSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtrE7UcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtrE7UcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B831F000FF;
	Sat, 12 Sep 2026 08:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201970;
	bh=rqnEQlHhjTfhAIaJMZxatcueAQlf4emPnBsi6qbYuLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtrE7UcVb4C6Ub2MMCU/bBdoAtae3mvsCa8ZHZjjtzxr/1HrxmY1lXyZATqy1kGMp
	 quwyPNQ7+aWAP9hSxXyZl1UJSKBP7dE34o/VWYCNXOsBXE1ZFW4eJniPEo09DgNWEX
	 xwXD1sPQpOMiwfGmDaordvcVmSsctt0hhwe/3rU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1107/1815] ARM: 9483/1: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
Date: Sat, 12 Sep 2026 08:47:37 +0200
Message-ID: <20260912065715.005565892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8a58a41100ea377e978d99600ec24a9bd0273662 ]

Commit c6e61c06d606 ("ARM: 9463/1: Allow to enable RT") enabled PREEMPT_RT
on ARM but did not select HAVE_POSIX_CPU_TIMERS_TASK_WORK. This leaves
CONFIG_POSIX_CPU_TIMERS_TASK_WORK disabled, so CPU timers expire in hard
IRQ context.

On PREEMPT_RT this makes run_posix_cpu_timers() take the sleeping
sighand->siglock:

  BUG: sleeping function called from invalid context at spinlock_rt.c:48
    rt_spin_lock from lock_task_sighand
    lock_task_sighand from run_posix_cpu_timers
    run_posix_cpu_timers from update_process_times

ARM handles TIF_NOTIFY_RESUME on all return-to-user paths, including v7-M.
ARM32 KVM host support was removed by commit 541ad0150ca4 ("arm: Remove
32bit KVM host support"), so the select need not be conditional on KVM.

Select it to defer POSIX CPU timer expiry to task context.

Reproduced with setrlimit(RLIMIT_CPU, ...) and a busy loop. The same path
is used by setitimer(ITIMER_PROF or ITIMER_VIRTUAL) and POSIX CPU timers
created with timer_create().

Assisted-by: Claude:claude-fable-5

Fixes: c6e61c06d606 ("ARM: 9463/1: Allow to enable RT")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b8aa3fcce1078..bcb53bc9b931a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -133,6 +133,7 @@ config ARM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
 	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
-- 
2.53.0



