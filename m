Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2113221D92;
	Mon,  2 Jun 2025 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875339; cv=none; b=JOlQuuNO8KyzW+B17rYHIPZ4FjoUkizSpmXR+O6i37m4E6MoFuYzM3AgupEactkaJx+KXjGgg/aHtO4aiucGvRmpXeJ2rR4sCVvaMQhX0yxCv70/2yLGA4aLbUzGESECj11Y0R69F5RRmxLXTWNJFLC+xBJqq0YBJodbHd0kO9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875339; c=relaxed/simple;
	bh=uwNh3ww4EwZZJta/nZf+iwbi0N44twmsjJIcOw1H3YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTiPuhWvRYo4niyvcsO1lR9IQXGnUMV4Q3H7TJlqVOnwDqbhIjPLfYjtXZPwPaX7975kwxZKFwNlFuzR8GBJrgIDMaacvRjrQqgEra/c1hHUdXU8gHZTAARSDeArZpLC0oRMOPOUVgprGuT2dEfmlieNhgOyoivNAWbvd/S/5AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOX4ENAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOX4ENAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5FC4CEEB;
	Mon,  2 Jun 2025 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875339;
	bh=uwNh3ww4EwZZJta/nZf+iwbi0N44twmsjJIcOw1H3YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOX4ENAwh11B8PYRtovXwW/usZfi/WQBJ766ZjgbUMti4gnSaEgHGITWxyLDQuu4K
	 5GI6NhN6gxg61upmnQviax7GdjoXAa/hM8dOnY0EpUKcOUdt6cj/H+Hmqil4HOCASC
	 mtFxqqvnF/oRLInW1XTVeRl1hjCJaHdcst4ev9OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 104/270] clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()
Date: Mon,  2 Jun 2025 15:46:29 +0200
Message-ID: <20250602134311.487265686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/i8253.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -103,7 +103,9 @@ int __init clocksource_i8253_init(void)
 #ifdef CONFIG_CLKEVT_I8253
 void clockevent_i8253_disable(void)
 {
-	raw_spin_lock(&i8253_lock);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	/*
 	 * Writing the MODE register should stop the counter, according to
@@ -133,7 +135,7 @@ void clockevent_i8253_disable(void)
 
 	outb_p(0x30, PIT_MODE);
 
-	raw_spin_unlock(&i8253_lock);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
 static int pit_shutdown(struct clock_event_device *evt)


