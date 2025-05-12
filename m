Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F9623C4E7;
	Mon, 12 May 2025 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073392; cv=none; b=e/R2IQio1QuipWSah5iKKGo3EA+G2F/8Azcc5jaxG7/EhQCxsVtcaHj/VM4Zx1JZXD/BamueeJuwFaAnFWIO3Iu8hd+jpOPThjAwv8Z1jBqi3eLga+N0s0cA9x4lT73KEWlrXDFxJpKAsWb2rhZuUd/5K7/mI/OhtNumLqglI1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073392; c=relaxed/simple;
	bh=4G4SSruSqBwo16D5PMlEHwXy4ky1b4eRHjKQHrYzDso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFlTR0DMCKU5/lutfLCP0sM9NNmpobQsDjXZ9WG+KUfRBHhiffXorVj01C5QWl+9ZHD0YidMa46dAAbMNvzoubVq62wxQk8DWAlv2XmGwcrRxaoOZq7RzqFYR5vYK20uUlN6Ie8d1rFpdySKqlwzTiRUUCl1eiYX6T7Ih5bhDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3nhhwtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3nhhwtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BE5C4CEE7;
	Mon, 12 May 2025 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073392;
	bh=4G4SSruSqBwo16D5PMlEHwXy4ky1b4eRHjKQHrYzDso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3nhhwtWhlTiEJmXk7mE7c9A0F3OdICHQaimvn9jLabuLL0xcQEVY2D5UBIEtQOFF
	 Mw1ijEtbtqvMSLPPFnpzSlGjnJjTa/9JsXHwOaujhOWd7j1z7GGrOJdNxRK1JzdgJ1
	 sLxgXO976AGpfBJPwbPVPUd7WPsp3sqyDiccgfhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 061/113] clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()
Date: Mon, 12 May 2025 19:45:50 +0200
Message-ID: <20250512172030.162378225@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 94cff94634e506a4a44684bee1875d2dbf782722 upstream.

On x86 during boot, clockevent_i8253_disable() can be invoked via
x86_late_time_init -> hpet_time_init() -> pit_timer_init() which happens
with enabled interrupts.

If some of the old i8253 hardware is actually used then lockdep will notice
that i8253_lock is used in hard interrupt context. This causes lockdep to
complain because it observed the lock being acquired with interrupts
enabled and in hard interrupt context.

Make clockevent_i8253_disable() acquire the lock with
raw_spinlock_irqsave() to cure this.

[ tglx: Massage change log and use guard() ]

Fixes: c8c4076723dac ("x86/timer: Skip PIT initialization on modern chipsets")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250404133116.p-XRWJXf@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/i8253.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -103,7 +103,7 @@ int __init clocksource_i8253_init(void)
 #ifdef CONFIG_CLKEVT_I8253
 void clockevent_i8253_disable(void)
 {
-	raw_spin_lock(&i8253_lock);
+	guard(raw_spinlock_irqsave)(&i8253_lock);
 
 	/*
 	 * Writing the MODE register should stop the counter, according to
@@ -132,8 +132,6 @@ void clockevent_i8253_disable(void)
 	outb_p(0, PIT_CH0);
 
 	outb_p(0x30, PIT_MODE);
-
-	raw_spin_unlock(&i8253_lock);
 }
 
 static int pit_shutdown(struct clock_event_device *evt)


