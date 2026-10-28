Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208505;
	b=LeWlHkmr0mXUyQssTwdGF5zZLtWFFVmUTS0AolFKtzQUyoM/Cc+I+VxRxUSSjEyfarh/
	 q4lb+w/YtIYf/6i926e/1tsEaxDUytCCLywylnNvKvr6/i1GWPu5nzT7oCN3YDl30uNlP
	 zegdA0o7IdVzV5JJWeZkKp7zd38lZOVtMlFbA5dyYfL+/ABunKRpNRfCcR/7LTlVJAfJD
	 eHZhsbkj68+qLl0jKaLAAzo2QyBvf7huOXzUo9IbEt1tsKuV155vLesGVymUGBDYnzgnd
	 EBrD5Y7o5ojTkAU6mQMcvjXVQvxQpjK4gs0p/NchQ7Qp06T1LvOz1CyLs0fJOrSxhGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IVAlaHIe3ExAzkC6wIwzDUD9pjYTTzvLX9+0tyvS4bQ=;
	b=mWt3ccAZlunjNqVr4TO5waxN6/SlrFnHP+o2lK2euWd7KJR9BCQ0wclNlosueF2vh0xg
	 bFaeH1N3PpoZ630/OeV7q4KFWXXaeFums9Sd4MUEhS60XgORiM7LWxvIL1UK5yigtWYZE
	 DUxLnJ3NiY25yzK6weix2dM1mt+oiRdP1PeMR3Wui378T+qQrl9vYKq4UwtXaqNhaSRup
	 O3+tRIOe46EMkIQCLfPv8yaviT2ZQWJV2jTa+aw8UzggsbOcA5cM0uXxLNvzvMRdsP+qR
	 quFQmD/nCYdYr4VkZE6+QRSXBeOZRmKbPcI7sao2aGOl91p4y+qbxpL67iwV9smkj9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UICSRrG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC50606A31E;
	Wed, 28 Oct 2026 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UICSRrG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBAB1F01825;
	Wed, 28 Oct 2026 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208505;
	bh=IVAlaHIe3ExAzkC6wIwzDUD9pjYTTzvLX9+0tyvS4bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UICSRrG37v2p8H1f66oK5X0X4rSHUEsAvq0M7phr8FePzQR9YeDpgeoZ8Ej7Th3gc
	 L8GKwGu76sr4GwvuDVzqaUEdrK0wZwBvlbLX9+KHaj0MOSU6zuw0+xQwmE0FRm+L5v
	 yWfSqhWNoZSkeQYKwWToiGO7L6zpaXGA7KsiwQIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/516] ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()
Date: Wed, 28 Oct 2026 17:54:12 +0100
Message-ID: <20261028170005.890261689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 815e07c8fe885a87751c2496a30ae0dcd4118210 ]

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
[ Replaced scoped_guard() with explicit raw_spin_lock_irqsave()/raw_spin_unlock_irqrestore() calls for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1c1b4139c4726..0612ef61bf973 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -835,15 +835,15 @@ static void rb_wake_up_waiters(struct irq_work *work)
 		/* Only cpu_buffer sets the above flags */
 		struct ring_buffer_per_cpu *cpu_buffer =
 			container_of(rbwork, struct ring_buffer_per_cpu, irq_work);
+		unsigned long flags;
 
-		/* Called from interrupt context */
-		raw_spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 		rbwork->wakeup_full = false;
 		rbwork->full_waiters_pending = false;
 
 		/* Waking up all waiters, they will reset the shortest full */
 		cpu_buffer->shortest_full = 0;
-		raw_spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 		wake_up_all(&rbwork->full_waiters);
 	}
-- 
2.53.0



