Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B3A296155;
	Mon, 12 May 2025 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072058; cv=none; b=dikYdDKB1vQbgpXRIa7yAiMZcF8WjOP9J4MM1wJUA7H8v+G+k+fCDiamWz9RpUSXcvQHzdzVGsLz6ltCam2B7fT6RsBMVeB3MfangPviDy9JSdrJ4jMPe4SnqjuiGOhIqkiYtXTSDaRTXcYHrK4LcE2MNAjhXB1ssttcb8NbuUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072058; c=relaxed/simple;
	bh=IwIdCkjIHd60EL88Bmj3wNAzEmtEBkQkUDD7flYu/e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ7IebfU/MVFIhFBdd9RlQFWu6robHT7497Igbd1k7y6gPjBQo4BBIEJaIMZZXdUgsicijTeF4gkSD79ZdrgmZFAvTTjuxPDWBkQnE7CCKotlNRrLFCYps5bTg69qmE21cUiAzBgyNYXeiId1ONc8nuswv+l/pA/gBtY4dnLDEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny7e4fPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny7e4fPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460B8C4CEE7;
	Mon, 12 May 2025 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072057;
	bh=IwIdCkjIHd60EL88Bmj3wNAzEmtEBkQkUDD7flYu/e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny7e4fPlkRKhrGDKPiQbsWIzC5+I+wNWo3IGfbsa4NoNLo8O19QcjVZlcY8U1qiOo
	 CluJrWu0XajS0j/XsE1uZlbRKj5KgJ1zS2aAtWGKlGJ3KRKXMgmiToCQ+tnBoTIwSg
	 O+gqlzmcqx1nLXPWCeTym1g+MzjrkB5ThiU3rKPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.14 124/197] clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()
Date: Mon, 12 May 2025 19:39:34 +0200
Message-ID: <20250512172049.436612104@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


