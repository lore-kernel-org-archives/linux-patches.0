Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021102;
	b=MQhRdych3agrKsjIk3j2t7OL05pzJ1aQde439xSf3pZLFYJnrkRFmhqexf6QYlgl2RuE
	 yhpD2hKrOUTHr6TdQ81qBHM1fjT0tfhTR20SyMoXnizAw1YIAaGFqwy3RJ3Wq/s02szlt
	 5aqgSlLNuSQZuMCW4WchYiqmT9541HBy3IT+Le5of670MXWz+q1WpsIUqwM2bZtMEchOx
	 UdQAUmbYTYKzvkwxnMdw4G2+AOdTHX6hrbq3WwiDbUqJMKgHZYKJcwWgVC6AAN/tMOc6L
	 Qp7zfqavSATaEGg5uC1Z6AuIdMQdAFboPVmDr2uicwxHRrzYCFCfVdxX+3QEKkX7+4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zyz4a/on31oywtBlXmLSlu++L6KvkIXismKGU6AI24o=;
	b=Yal2VKrk2HFwvRN7yIcBEJrNNELMu91XYW3op5/qo/1OgGellx+Daji6z36UffUp75sK
	 yc900tjrRHSd8sz0Ny9P3GJeZdQ0J+ZdzAOodsBaQe9uEP3fqFsvKDoqVSbGx+zgoRJfl
	 MhibesjOPsZ1WQL1TQIkxCWMXpqlAfLmMpLyECmqGKT15s2l4ba39aBlKBryKguNykwuA
	 EeTsgN7xaGJLQH3UfYGU4UvDFnwJvtXRsjLjQ2m/0hnBI/zjfkSyLYBpT1T76tlZKkeBe
	 V5Zlq84khgaAiwEqCZts29URTvI5x6hihPGAN/FLWzOMWG0NiGtuDDhu4bSM7m6JvpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g/HeEGpy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9D1606A320;
	Wed, 18 Nov 2026 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g/HeEGpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CF51F000C4;
	Wed, 18 Nov 2026 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021102;
	bh=Zyz4a/on31oywtBlXmLSlu++L6KvkIXismKGU6AI24o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/HeEGpyv1jEXn3ypttQFBI7ES7pg9PIYTsO34vfzqOOUYaJ7aRz7aO+pAjLXNo8o
	 1OqBttMX0KvJl7gd21guqKwUWagY9bWPnWHd/ETsfd2USV/EZVoSPzayHZ3CHoDls5
	 OAmWghri1tXGHwHiZR4Gf3OzNgHeVIQDPMI/hg78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Matt Turner <mattst88@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2147/2651] alpha: fix stale user_stack_pointer()
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150403.136887630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit bceba446fa2bc66a905ec0bbf6fd80e98701c1d1 ]

PALcode keeps the user stack pointer in the PCB, not the trap frame, so
pt_regs->usp is only valid where entry code stores it: entSys,
do_entArith() and do_entIF(). Interrupts, page faults and unaligned
traps leave it stale, and ptrace and /proc/<pid>/syscall read it
through user_stack_pointer().

A user-mode pt_regs is at the top of its task's stack, so find the
thread_info from it and use rdusp() for current or pcb.usp otherwise,
as KSTK_ESP() and the regset code already do.

Fixes: 8a2857bc2b30 ("alpha: enable regset-based ptrace and core dumps")
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Link: https://lore.kernel.org/r/20261018-alpha-perf-regs-v3-v3-1-52be85332c57@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/ptrace.h |  7 +------
 arch/alpha/kernel/ptrace.c      | 12 ++++++++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptrace.h
index 8e0a589e2d15b..14e8b1a2ee024 100644
--- a/arch/alpha/include/asm/ptrace.h
+++ b/arch/alpha/include/asm/ptrace.h
@@ -24,11 +24,6 @@ static inline unsigned long regs_return_value(struct pt_regs *regs)
 	return regs->r0;
 }
 
-/* Helpers for working with the user stack pointer */
-static inline unsigned long user_stack_pointer(struct pt_regs *regs)
-{
-	/* Valid for user-mode regs */
-	return regs->usp;
-}
+unsigned long user_stack_pointer(struct pt_regs *regs);
 
 #endif
diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index fc8f6cedbb286..0ba9a2da17ba2 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -405,6 +405,18 @@ ptrace_cancel_bpt(struct task_struct * child)
 	return (nsaved != 0);
 }
 
+/*
+ * PALcode keeps the user stack pointer in the PCB, not the trap frame.
+ * A user-mode pt_regs sits at the top of its task's stack, so the
+ * thread_info is at the base.
+ */
+unsigned long user_stack_pointer(struct pt_regs *regs)
+{
+	struct thread_info *ti = (void *)((unsigned long)regs & -THREAD_SIZE);
+
+	return ti == current_thread_info() ? rdusp() : ti->pcb.usp;
+}
+
 void user_enable_single_step(struct task_struct *child)
 {
 	/* Mark single stepping.  */
-- 
2.53.0



