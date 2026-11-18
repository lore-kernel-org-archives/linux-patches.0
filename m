Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032258;
	b=LR8w1CKgpqIbG0BqvWazMLuW3AOCds+dNCSSWpkWmm4l4NcVQtOkewYm9MyX7ZLoAQVn
	 AzPgfYS2CdWAVaeTAjr7utuTz6qn2MZTeb35mAAbZMulEYXApXHhTA+XX/n8AihZf8xI4
	 FR3+NbWImAUd1irPvS/IoBLZolD5f8SPIhLISt3cuxaINVEkJ5lRsVTjIlXbs5cc8IrlU
	 olbGReJSCTgSxG4c+6voF3TI/RFFIE4Hpkyaa3TMdnrerkBA8JU5cmvKtTnIuuBUDdHuc
	 7ky0JTego5ET1wq72r3JO1n1lKMYCH4rd1CcYfIUGX7o51slrgLQLMrwPtyFNh404Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wcyUo9LTTPQT78M3iYvFqfybZ9DVfs4z3zH+Dn9Y9Yc=;
	b=hGMSfKmo4SjWjiKNWSTg+TQfykTyPFRZ5B8yWKrUyLf1b6bCyMrzq8Y12aOjgodJ/94V
	 CGDT0e4tXvx7EjNO7OoC/8rYGFAqvfyunXmrYzu+8yGLwb92iHoSCJNQqdEqp0Gc3XDRS
	 Ze7b/dK6TQrjzSBNW/mXCKRu6mnwUkZsobEdnO+Y0eQjjLfufJoePMDWXSW6N9sQKSOIT
	 9xJrpjxso62dKMXvmAymRNbPemnDrOcOknR1tWfHcknARioRXK+vl7hBsPzwSulPvRLH5
	 OBDKZwDOhoSJr+XsM8WB25HPLgfkdgW2xW9LMR4q7EyUgoDJ4ADHKnvJ7a3PO0/emJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bk1fExWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1772E606A31C;
	Wed, 18 Nov 2026 20:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bk1fExWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651EB1F000C4;
	Wed, 18 Nov 2026 20:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032257;
	bh=wcyUo9LTTPQT78M3iYvFqfybZ9DVfs4z3zH+Dn9Y9Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bk1fExWpOKIyNcPSdYn8YJ+c2UUAYLvpoiGhjJxhUEs3otIWJRqF2cRb+lon+duQm
	 ut428nkmGrAEOKBVfkeF2YfiMwE5yocPaGbgWQLBFZsCj3giSTm6+TwOjMbsxN/B3P
	 uNycqWmzeLIXNJXpZdNmahSh6a9Q3g9g+GCxc4YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1348/1756] bpf: Claim the per-CPU send_signal irq_work before filling it
Date: Wed, 18 Nov 2026 15:57:55 +0100
Message-ID: <20261118150102.992030553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 741a8be780538..c33ab68741363 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -801,6 +801,7 @@ const struct bpf_func_proto bpf_task_pt_regs_proto = {
 
 struct send_signal_irq_work {
 	struct irq_work irq_work;
+	/* The claim: NULL marks the slot free for the next caller. */
 	struct task_struct *task;
 	u32 sig;
 	enum pid_type type;
@@ -820,6 +821,8 @@ static void do_bpf_send_signal(struct irq_work *entry)
 
 	group_send_sig_info(work->sig, siginfo, work->task, work->type);
 	put_task_struct(work->task);
+	/* Release once the fields are consumed. */
+	smp_store_release(&work->task, NULL);
 }
 
 static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struct *task, u64 value)
@@ -863,14 +866,14 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struc
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



