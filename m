Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597DB242D93;
	Tue, 20 May 2025 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749260; cv=none; b=o8x9u2ayAkPdw+6yTq6Wtf3diT/N6+/5vdbzQRI3HHa16EtEmnIGvznFmy957EMKzfZdzyE7lTx4GoWfG+iDLIfiYD4hVJxi88FcZR78IMRcRxhuyktSwK13nEWgmTq8K7YOA6fJvsxrZwfyasr1stBWZp5WZQdvobk5lXnccIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749260; c=relaxed/simple;
	bh=O6hE7KXVfsbBo2yIecqXjeaK7JdXxPI8z1BujHOkIl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrnqxuT1ADgfabMXqyPdYyN4oRL6cwFX5+0frmH8AUVaqYrHc4Np/K3O5Fzeheffh8shtXy8PiArmdkfc5ott385rYo78fknqggoUEZ3/6uZdz7HoneTiNEF4s8JUUb14TRvdMb5sQHJeovEzdjHSm2TvsaMBPJndz1cwTsdkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vOP5kqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vOP5kqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF95CC4CEE9;
	Tue, 20 May 2025 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749260;
	bh=O6hE7KXVfsbBo2yIecqXjeaK7JdXxPI8z1BujHOkIl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vOP5kqtpkZEhNzpwfDDA4CohegWtaLQRDzR/V2qwb8RzTF+GJl3sXmH/+00VKJck
	 c5GnnpQEs48fIdzwbpFX8Mh9c4QJv2yeeODg8wwEBrAhLUk7jciNTlvk72t8bga6bp
	 KHdAzvsg3wEWR7fmGw7b8257mrYsK3eBvT3palmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 47/59] clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()
Date: Tue, 20 May 2025 15:50:38 +0200
Message-ID: <20250520125755.712144707@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


