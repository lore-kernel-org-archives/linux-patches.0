Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5A350E5A6;
	Thu, 17 Sep 2026 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666367; cv=none; b=nAb9dwWJOhX4qB+XdkgKLBwunvQdpEuF8uddk8U5oFLJx5bJsTbmRkK9sZiCG5we5f18w5JSedjL+zAv63EIFkuQ3W8RPnP92zsK+wix5kOwKL2XLVGI/SXuIGz0AhVGfcgUoD4+IGSaO0npqRTASiMj1GECjJ1b4NQAjQh955Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666367; c=relaxed/simple;
	bh=DpZ7DGwBFSws6lRkPkxB4HstxToUZUV+ED2aqo6fBV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffnlQWn7OCuE5W/v+v0CKEoYLYmknm1+eN51CclxVpCYE5ULXpbO4K44lOwMb8BSKDoEyNvLLre8EKLkVHWRoir6OGkcLpp0urtDtApabL56JEMaBEweje7vnCIa/8Y0k8NVtlp/B1fNpPDRfgRrcD2Jw/TY4d/BAY5hufD7fdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBxKI13Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBxKI13Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB4C1F000FF;
	Thu, 17 Sep 2026 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666366;
	bh=DDvGwbPS3/d0mJRiFtHJT7XUffTHR2CjaIV/MpOXwyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBxKI13YP1qIJaqWMMK+viUBBNYjPQEvopCRDQKLXBYDZg3t0aPAwPhTSR9xsQkAk
	 vbVMoRCqumACcT9E68/RZ2X9Elf3qithUu2DKCzu1xfIZu8f6Ca9W0Zt6twujZcFUW
	 HxGymB9gUWtnYryRW0zZVdAGj4CmmpQv3P0kW0p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 1012/1250] ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()
Date: Thu, 17 Sep 2026 16:13:27 +0100
Message-ID: <20260917151619.476845571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -875,14 +875,13 @@ static void rb_wake_up_waiters(struct ir
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


