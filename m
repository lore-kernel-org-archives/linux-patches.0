Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCDA4F3923;
	Thu, 17 Sep 2026 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660397; cv=none; b=j7ImVhjg+tFslFm284+UjmRDiFeGCPpbmjdsrLJEdaqsnjxRMm5LtI1kqMpq9X3bglzCltkeGPmr+RwWVD3i6WFVzXI8H2wzGuh09BdT7UujpoeyFQ6ZIDbZXf/0yO2FfXpuASnBE3mVq76a+GVj4FyidY6LcrUZDi35QZowYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660397; c=relaxed/simple;
	bh=9KvkQa2QYMIWmP9L8cOs0rMUDismZwRjmazERBpfLdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtM9h2qqeoT2j5g9ZOZxoYmE956Zj7Xdn7Gm/qlIS2gkYl9lCDdgdhzBitpgYszLRZWqAsD50na189JX6zXH3d/UUIjyWBVnX8vEdKbUnIZo0QH2mzOUvieShx++sbz1UW8oCQCKcrZ7WUlpQvnaXEVImrmI1PD/hxZqS1d468w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=borOwsen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="borOwsen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1BB1F000FF;
	Thu, 17 Sep 2026 15:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660395;
	bh=B5m2KlzioEysMgBIVrrkUs/A5/Dnj42dAgGvVQnAMYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=borOwsenIqTwqn/eyNztBCqUe/e/27bAr+LO/vmvGUCGYUUrzZ1Hnr2Zz6VD6FrbF
	 T10sBnCZ2r0l/ufiUN6qGlw1J9ScQQ4PcADDqvi57x8bkDxPeKwPJ4y1dnO9hHiX5E
	 h/S429gC5lLi7VswlhxhQm1cPKppoiFrlmjDyAEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 540/733] ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()
Date: Thu, 17 Sep 2026 16:14:08 +0100
Message-ID: <20260917151405.684277846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
@@ -885,14 +885,13 @@ static void rb_wake_up_waiters(struct ir
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


