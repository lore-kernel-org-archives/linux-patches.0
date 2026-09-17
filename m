Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0331547071;
	Thu, 17 Sep 2026 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671030; cv=none; b=OSTN13769Ebsv4z8yulykrn2n1CiFjdGfIhXJbJtnWbw2hB24Sz4cwVFmFpQ6AfG4rCWR4udTFiZrht2xKw2GNkJaEKxxTToBrHTp/E5yNJH/cVWZix7LIfjCc8E9zY1YjiD9LctIordf16XsvDXtzoto9tRCv6PS/QMfNMVAlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671030; c=relaxed/simple;
	bh=pLstQlvcDjbbtbGyuTaB3zTCHNnqH3ycsHNffRE39eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elAl6stGtRAUIeA4haI+WRHnGdcdNr+Yt2a9yOzTiZIawZA9kZ3zk5rV+bGk+KTcCPQEKcHxP8GW6xHMWGlvPlHoxcXsGiTMG+32v2ujSlEED6S+NAxUqewFpD9dK2drXKkVfS4fyjiaYup0UPbxrAcLr+mn6N27cGgoTVYiy3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTFK7lct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTFK7lct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9017E1F000FF;
	Thu, 17 Sep 2026 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671029;
	bh=uZIp9NwXFRbuLP6lil47iOGdvyWWHgy+QjM1JRjQ/ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTFK7lct/Nd85Le7DqC6Y6pdX7piQDLKLSnRRC/wdBT5FLy6B5ua7D/bQzBOuwnLH
	 Nb7CB9Zpvl26zegZEVwkSXK02rxLBH+D3nGd5IQe9LcS0oP8/hvIC7JIzV5YkO8GpG
	 ionLBQQHgsUsy4aYleKkBfe8swwhPM2642FN9nO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 0839/1102] ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()
Date: Thu, 17 Sep 2026 16:13:02 +0100
Message-ID: <20260917151601.583564261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -837,14 +837,13 @@ static void rb_wake_up_waiters(struct ir
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


