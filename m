Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8633A9DA;
	Sat, 30 May 2026 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162451; cv=none; b=Okgl7jBzYKoCD2KrOrJS+R5HH6i7V90tkQKjvKYRjoGOJpr1RPKpqg7AwqkxcJU5BnevumwtbYeXyvI95rXJbPSaaUvivNCv5vwzyLn1Dr3oLiulc2gSvGUzorZ6pCEE8WPdBtkVK0c3fn8+0f3fRGZJjnvVx70A2AKY4lfTn9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162451; c=relaxed/simple;
	bh=GUR2c42wWP2+P5sMtbFV+KQ/HiLOLmocV/Gajqram7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=taP1qZrOfsf1jibD9aa+X/YT0lQ/alU7CznOMffRL53Md6psHkIT35jpdVzQ3wN4AikaaehCHenzD6DE66Sz/C9+oJk8h6k/Ym2mXBdOk5MGEUbilCgUpmioymIG+Y6cbxtJv5lzacpFQHTyIUjqOwMcoocFNJ/6VMxeJy9avaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b49VWAia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b49VWAia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4691F00893;
	Sat, 30 May 2026 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162450;
	bh=Fob5S9rb3eNJzXOlAkamQE+ndU9C9gsY+TiYyC3zwsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b49VWAiaeD8GgV2n4jKSW/b8QX4m6zaWcFswmMW7VCVbxcg7/VMIdLKVAufvONNnT
	 6TATPANKVyToHqhWR9bNtwo8oTBgHA20Wpgrfc+sExF1mVDnboyac8qlCd1NlNNO3r
	 EV6DhDpR6TY5zjd7xtevxxdZCkbGAfaqKs9w5bW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 925/969] irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT
Date: Sat, 30 May 2026 18:07:29 +0200
Message-ID: <20260530160326.283449466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7afa40fe5cc43..6a286b2681178 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -282,6 +282,12 @@ void irq_work_sync(struct irq_work *work)
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
 
@@ -292,6 +298,7 @@ EXPORT_SYMBOL_GPL(irq_work_sync);
 
 static void run_irq_workd(unsigned int cpu)
 {
+	guard(rcu)();
 	irq_work_run_list(this_cpu_ptr(&lazy_list));
 }
 
-- 
2.53.0



