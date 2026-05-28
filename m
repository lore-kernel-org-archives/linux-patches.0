Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514662F260C;
	Thu, 28 May 2026 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001438; cv=none; b=LwwCvMHBI06olBWEIKfMZHiAslttDjcUXPwpQN+RIX5ovXRTft80p5Ai/J7yZ8F2Ayl8qGLzsrLHb+skSSQoYnMAStZORxmu0FPg4ogcRZbQJW6y2ueoARnhIkdJOxeL8a1yL2hn3626eg9Inav0/7dIIsi8hRjfBiPsIA1p2Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001438; c=relaxed/simple;
	bh=Kgndg6P1KU/kijKMv1EAAzJ3qYGAEuFDlWw8kl5tnXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVrRVeGsCvJPL0VKEe//JncfafOVdKR8INGhCP3+N7Fn0lzz4w7IxvN25l3GQQgfZTFZj4FMahiMbY6Xby9TnqfAU/RSaqAzwvsvNjEPz7jh9ruSfW6znaWlSB82PJCrY3LlJrZXgoTOv6oRtE7qo8WOxmE5pjO23Mb2BB8Zmjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egr6bBwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egr6bBwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02DE1F000E9;
	Thu, 28 May 2026 20:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001437;
	bh=P51+eyUDg1TsskTjF4/KkHTnuR1Fb1ClOXJl14vB6wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egr6bBwlLUdPE/RmlIlGZr5ZjCPnxlrmfiu1XYeaHL7DYRJSZjE0fKeHWX6pwpQ2J
	 t6UA8IzLUbeTOeVLvLDXtSV1nBkLOxd5KxJP9nS5VlGRyGBVYvfizzmEOk+vwwQqox
	 Jm35FRzywRWm81S5KFWjbJw0n3I4YIaVJrPHvEY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/186] irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT
Date: Thu, 28 May 2026 21:50:07 +0200
Message-ID: <20260528194932.374290819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 91840be8f710370607f949a627e070896faeddb8 ]

On PREEMPT_RT, non-HARD irq_work runs in per-CPU kthreads via
run_irq_workd(), so irq_work_sync() uses rcuwait() to wait for BUSY==0.

After irq_work_single() clears BUSY via atomic_cmpxchg(), it still
dereferences @work for irq_work_is_hard() and rcuwait_wake_up().

An irq_work_sync() caller on another CPU that enters after BUSY is cleared
can observe BUSY==0 immediately, return, and free the work before those
accesses complete — causing a use-after-free.

Fix this by wrapping run_irq_workd() in guard(rcu)() so that the entire
irq_work_single() execution is within an RCU read-side critical
section. Then add synchronize_rcu() in irq_work_sync() after
rcuwait_wait_event() to ensure the caller waits for the RCU grace period
before returning, preventing premature frees.

Fixes: 810979682ccc ("irq_work: Allow irq_work_sync() to sleep if irq_work() no IRQ support.")
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260330073234.303732-1-jiayuan.chen@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq_work.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 2f4fb336dda17..188721af8eb31 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -292,6 +292,12 @@ void irq_work_sync(struct irq_work *work)
 	    !arch_irq_work_has_interrupt()) {
 		rcuwait_wait_event(&work->irqwait, !irq_work_is_busy(work),
 				   TASK_UNINTERRUPTIBLE);
+		/*
+		 * Ensure irq_work_single() does not access @work
+		 * after removing IRQ_WORK_BUSY. It is always
+		 * accessed within a RCU-read section.
+		 */
+		synchronize_rcu();
 		return;
 	}
 
@@ -302,6 +308,7 @@ EXPORT_SYMBOL_GPL(irq_work_sync);
 
 static void run_irq_workd(unsigned int cpu)
 {
+	guard(rcu)();
 	irq_work_run_list(this_cpu_ptr(&lazy_list));
 }
 
-- 
2.53.0



