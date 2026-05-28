Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC52E7F25;
	Thu, 28 May 2026 20:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000837; cv=none; b=B6ViD4eDVvc3cRKWWtZh9STxmE7ykT5AFfxRqHtJsobCT4QhMz7gRmVoo6f3tg9kTo76HKX3TqZAD5gspXPywJAJjttY281N3tSWZKTJZBbVkbdIvMnio0nusl0oJ5iEFz2+LmQnkqiN5EpFtof7CJ9sSuEk8nIBewfFsXNoQQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000837; c=relaxed/simple;
	bh=ncHezH3VYsVQ9Edczo10DeA06dS4HTYbBwPaJRErFqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5WGcGCNLuLGjDuTv+gZug0Qwj+3/1n8QkkU9+SWSe4pu5+Fa6rPDbu97zJO9WULlo7hmP4bjNcs+qewBvmLcb/vDss5NsL2x7xlq+YiJnLccPr9bROeXXGgCM/Zunlf4nJCEiRIodQPoN38E3C6F8IU2CmJudKiTX0T7uOyZco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZ57WKbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZ57WKbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB201F00A3A;
	Thu, 28 May 2026 20:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000836;
	bh=G+kEwK7CNsciuYJS/+Sfxg1x1LsNzfKQpmtCwM1hX1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZ57WKbwOgo8HO2IUd7KjREdfI6Cu8OdtyuraK6S7dzuSAgX4VmOjj799EiFFfPXF
	 J7YvHexUAomszT1V0R0vu5aVH9hPbNQFUJMpphU1M39ujixEYYL6HhgHq29LCkU4By
	 R/SkbLR19NLZJFNu5Rlb4Wi1yE31Gy4atPdxjYGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/272] irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT
Date: Thu, 28 May 2026 21:49:20 +0200
Message-ID: <20260528194634.490032665@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



