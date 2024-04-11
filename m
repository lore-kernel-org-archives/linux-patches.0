Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B2D145B0A;
	Thu, 11 Apr 2024 10:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829797; cv=none; b=sNHSQCblmyKmuaiVK0ZK9Vty6NpPx5NlwKt4vcHxXbWukcsrqWpr2mBLaYOoiuwPjMSvz9QzkB3X7q2fh+MaNvSAvtyIThIUfWKSb7a4Z30Cs49pN4cxfdfbFSltTaAiwemBvUIXVUUQN0KEh2hlpIpdRHZmHnJzVSVth1uIqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829797; c=relaxed/simple;
	bh=Omkx93eAL2gchqZp2lifispFJNMbNeE0AlSsNEzXO+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idD3mo2W1NTVZHbIEgZ3HNMZC5l/pUZAjIeTtttNdj8q2nzjB7/v79stu8oKmcMnMSIRKjf1W0O14+aYPGMdO4M5SnhpKYd2l7Ugiv8jftVXnotPqdZNqAZHZW0KlLXNALa1/EtcuiBHhZU/fWPztH9Q3Ds96o0Vrh93G4Q4HL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML+Cfh9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML+Cfh9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11CDC43399;
	Thu, 11 Apr 2024 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829797;
	bh=Omkx93eAL2gchqZp2lifispFJNMbNeE0AlSsNEzXO+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML+Cfh9pjMvGZb3WB0MRiZGhbVwWFJX9Jpif6VEMi/erqv7Ym6ghGg6Jz8USSCEnS
	 h509Yael+U/IqE3eH5HBpNfAYRMCEYvL6/ZlY3/2M/mIxUDJ5veLgNRXRkn6xkSHk/
	 QJ9nADj1UbRRBM1Oj4ADzY691/pQ/XbE3MHMjmgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa7c2385d46c5eba0b89@syzkaller.appspotmail.com,
	syzbot+abea4558531bae1ba9fe@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4.19 108/175] timers: Move clearing of base::timer_running under base:: Lock
Date: Thu, 11 Apr 2024 11:55:31 +0200
Message-ID: <20240411095422.819180143@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit bb7262b295472eb6858b5c49893954794027cd84 upstream.

syzbot reported KCSAN data races vs. timer_base::timer_running being set to
NULL without holding base::lock in expire_timers().

This looks innocent and most reads are clearly not problematic, but
Frederic identified an issue which is:

 int data = 0;

 void timer_func(struct timer_list *t)
 {
    data = 1;
 }

 CPU 0                                            CPU 1
 ------------------------------                   --------------------------
 base = lock_timer_base(timer, &flags);           raw_spin_unlock(&base->lock);
 if (base->running_timer != timer)                call_timer_fn(timer, fn, baseclk);
   ret = detach_if_pending(timer, base, true);    base->running_timer = NULL;
 raw_spin_unlock_irqrestore(&base->lock, flags);  raw_spin_lock(&base->lock);

 x = data;

If the timer has previously executed on CPU 1 and then CPU 0 can observe
base->running_timer == NULL and returns, assuming the timer has completed,
but it's not guaranteed on all architectures. The comment for
del_timer_sync() makes that guarantee. Moving the assignment under
base->lock prevents this.

For non-RT kernel it's performance wise completely irrelevant whether the
store happens before or after taking the lock. For an RT kernel moving the
store under the lock requires an extra unlock/lock pair in the case that
there is a waiter for the timer, but that's not the end of the world.

Reported-by: syzbot+aa7c2385d46c5eba0b89@syzkaller.appspotmail.com
Reported-by: syzbot+abea4558531bae1ba9fe@syzkaller.appspotmail.com
Fixes: 030dcdd197d7 ("timers: Prepare support for PREEMPT_RT")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/87lfea7gw8.fsf@nanos.tec.linutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1304,8 +1304,10 @@ static inline void timer_base_unlock_exp
 static void timer_sync_wait_running(struct timer_base *base)
 {
 	if (atomic_read(&base->timer_waiters)) {
+		raw_spin_unlock_irq(&base->lock);
 		spin_unlock(&base->expiry_lock);
 		spin_lock(&base->expiry_lock);
+		raw_spin_lock_irq(&base->lock);
 	}
 }
 
@@ -1490,14 +1492,14 @@ static void expire_timers(struct timer_b
 		if (timer->flags & TIMER_IRQSAFE) {
 			raw_spin_unlock(&base->lock);
 			call_timer_fn(timer, fn, baseclk);
-			base->running_timer = NULL;
 			raw_spin_lock(&base->lock);
+			base->running_timer = NULL;
 		} else {
 			raw_spin_unlock_irq(&base->lock);
 			call_timer_fn(timer, fn, baseclk);
+			raw_spin_lock_irq(&base->lock);
 			base->running_timer = NULL;
 			timer_sync_wait_running(base);
-			raw_spin_lock_irq(&base->lock);
 		}
 	}
 }


