Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020858;
	b=a81Y5MqVQo/FGjrMDZKwaay2OwNANL/pj40rDykW692rm8trt8Fr4LnXsksg+33iYW2B
	 wZFTMT9c8Ybk3h66Bi6gxHye8jg+DGUTDP147Sc68uis26xiMDOjx+yO8P4RjcMifC9Cc
	 LbGfhz0BgqtvKvVekOqZ0Vx5+HUJqwPeKVJl1Q9Deh2puEckADtaSAAyqppUlYLt4fWpB
	 3Pp9NmEdfhxaZA8wwGSuygMnGR1tcAHBxOxH2G/Nc6rgW6nutXwIZry64oRBcxxwxfC4x
	 tUh3/ibMYBSpw6CCwtoPJ3f3Lw1fQo4MfveXArlK155v8og+E3ovMCEA4UBuXhzA1Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=adt8Bhe01AGNlAAerc0khQdqX+nXpvbq57eVSKJL/HY=;
	b=QGWCfOaNwDiwsZBIZ+VUZ7WVDcJLttqGiP/d8F1HGHmvXmgBd8zYvcnGqFZYaQOIk9Gz
	 cMxLIC2zMzT3y7YrLb2X1DfpD8EOYDajzrkzx6Gx0fjqjoO8zPCJCuFguJ6IglIfoReg1
	 V/dTYv08dGI+WP4xBEvbtD0C2PEJEBr871abo0XS7cLxI4JbIqKUFk6F+kxKBJCsv1ZPv
	 KpuGQSZ+bQWbupBuaILKIyoHlrH+/YPXfb+3nFCpi7JPul9qATXxUr9/7f2quXdLAbrgZ
	 IuYtakJCXZ537ujsrMB6kfeff6u2TZquXwzR8bjVgAxQgfto6F7ey8vnJlkm2oHBW5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtIVJ7l3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76FA606B587;
	Wed, 18 Nov 2026 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtIVJ7l3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3253B1F000C4;
	Wed, 18 Nov 2026 16:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020858;
	bh=adt8Bhe01AGNlAAerc0khQdqX+nXpvbq57eVSKJL/HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtIVJ7l3XA6imR3rB+F+S9rPRwLU4Q85JSP8PblujnBD6S1hdpLLHFo2VkFTD10Ma
	 4eWYbaOD1Cda925rhBEcACL9y2RfxgNOhag3WHTTbna8eamTkXHLBpQ92J5xvqpra0
	 W+6Li86lAxACP+4a0nO2vueBfLAxNKQYYm0/nKC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2059/2651] bpf: Claim the per-CPU send_signal irq_work before filling it
Date: Wed, 18 Nov 2026 15:54:59 +0100
Message-ID: <20261118150400.188030235@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 2d1f101ee619435873ed8a23fcb3bd09204a5024 ]

irq_work_is_busy() cannot see the per-CPU send_signal_work while
it is being filled: the check only matches after irq_work_queue()
has claimed the work. A concurrent caller therefore passes it, both
callers race for the same irq_work, and the loser's signal is
silently lost along with its task reference while the queued work
runs with a mix of both callers' fields.

kprobe, tracepoint and perf_event programs exclude each other on
the same CPU through bpf_prog_active, so for two callers to meet,
one of the programs has to be a raw tracepoint or an fentry one.
And since commit 87c544108b61 ("bpf: Send signals asynchronously
if !preemptible") this path runs with IRQs enabled too, so a hard
IRQ can interrupt the fill as well, not only an NMI. Found by code
inspection and reproduced with a perf_event NMI program racing an
fentry one.

Claim the work through work->task itself: cmpxchg() it from NULL
to the target task before touching the other fields, and set it
back to NULL once the callback has consumed them. A context
finding the work claimed returns the documented -EBUSY.

Fixes: 1bc7896e9ef4 ("bpf: Fix deadlock with rq_lock in bpf_send_signal()")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009022427.968304-1-chenyuan@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 29260951aa871..568b9ada61daf 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -823,6 +823,7 @@ const struct bpf_func_proto bpf_task_pt_regs_proto = {
 
 struct send_signal_irq_work {
 	struct irq_work irq_work;
+	/* The claim: NULL marks the slot free for the next caller. */
 	struct task_struct *task;
 	u32 sig;
 	enum pid_type type;
@@ -842,6 +843,8 @@ static void do_bpf_send_signal(struct irq_work *entry)
 
 	group_send_sig_info(work->sig, siginfo, work->task, work->type);
 	put_task_struct(work->task);
+	/* Release once the fields are consumed. */
+	smp_store_release(&work->task, NULL);
 }
 
 static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struct *task, u64 value)
@@ -885,14 +888,14 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struc
 			return -EINVAL;
 
 		work = this_cpu_ptr(&send_signal_work);
-		if (irq_work_is_busy(&work->irq_work))
+		if (cmpxchg(&work->task, NULL, task))
 			return -EBUSY;
 
 		/* Add the current task, which is the target of sending signal,
 		 * to the irq_work. The current task may change when queued
 		 * irq works get executed.
 		 */
-		work->task = get_task_struct(task);
+		get_task_struct(task);
 		work->has_siginfo = siginfo == &info;
 		if (work->has_siginfo)
 			copy_siginfo(&work->info, &info);
-- 
2.53.0



