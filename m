Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B400537CD22;
	Wed, 30 Sep 2026 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785469; cv=none; b=WhIkKpEToVhXSUz4xxi0XplyNy/JK5bTvSaqs2KQ1EYW7WCNgwGWqZy4Ey1mw8Q+EX72Dj36A+LR3R0Wc1+POwrLkQ034M7VM8PO71aevcoW7Dnysrf8wv8mhGHlTVo84xNDLm+DEG1xnP3KUXqufjnb48E7OZZzKGN2H58aIoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785469; c=relaxed/simple;
	bh=Cdg7PHqIW6CK1t1QYHxfS8Ff76yFQY9MY5Ei3EZTlnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtfbNgmNbFmIV/+j0vA+9jt4ugYuJ562UJ8DzaX1DPhpR4CD9UlGlMMHVJyYtDs1u/vyvrlOYr0cv58A/qq/4SWDSWQTkX/gdtFg8+3OaqCiNfBBL4yqIX3AuiNSgzdhQjw1QO93LxRtNvNHSQ8d8ZcjSY89t0U1zmCRDpg3+9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwEe1iqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwEe1iqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482DF1F00898;
	Wed, 30 Sep 2026 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785463;
	bh=sOQQHkC9YHnXuroy45Spge745mAS89fslZGkNcKJ2GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwEe1iqjdMxW3tYET0NuKSmCExMT+qZ7gky63ULKG2Afl04dcNEoW/3ebVbXigWG4
	 It/tFFbEhc2GSVqaH2ZBFXy8iE9Lg+0AzV/qnn+sl+GUYxANCvDsgCEJfR19ybFpuq
	 l3+2W/r0B7CGGPP+WOktKAtApdEVFDQyCL5FwE2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 518/982] ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()
Date: Wed, 30 Sep 2026 17:20:54 +0200
Message-ID: <20260930152427.903782650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 815e07c8fe885a87751c2496a30ae0dcd4118210 upstream.

rb_wake_up_waiters() is a irq_work callback which is initialized with
init_irq_work(). As such it will be invoked in thread context on
PREEMPT_RT. Invoking the callback in IRQ context on PREEMPT_RT is not an
option due its usage of wake_up_all().  Since this callback may run in
thread context, it needs to acquire ring_buffer_per_cpu::reader_lock with
disabling interrupts and may not assume that they are disabled.

Use raw_spinlock_irqsave() to acquire ring_buffer_per_cpu::reader_lock.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260911102152.YEtwkBj9@linutronix.de
Fixes: 68282dd930ea3 ("ring-buffer: Fix resetting of shortest_full")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -912,14 +912,13 @@ static void rb_wake_up_waiters(struct ir
 		struct ring_buffer_per_cpu *cpu_buffer =
 			container_of(rbwork, struct ring_buffer_per_cpu, irq_work);
 
-		/* Called from interrupt context */
-		raw_spin_lock(&cpu_buffer->reader_lock);
-		rbwork->wakeup_full = false;
-		rbwork->full_waiters_pending = false;
+		scoped_guard(raw_spinlock_irqsave, &cpu_buffer->reader_lock) {
+			rbwork->wakeup_full = false;
+			rbwork->full_waiters_pending = false;
 
-		/* Waking up all waiters, they will reset the shortest full */
-		cpu_buffer->shortest_full = 0;
-		raw_spin_unlock(&cpu_buffer->reader_lock);
+			/* Waking up all waiters, they will reset the shortest full */
+			cpu_buffer->shortest_full = 0;
+		}
 
 		wake_up_all(&rbwork->full_waiters);
 	}


