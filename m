Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD111CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1707EC433C8;
	Mon, 26 Jun 2023 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804766;
	bh=63HRqoZ97aVX8/+9AGQxERkNCOLukHfX0jNI7gW1kO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqrwBtSWdgoQPNi/CyBgZiw9lpBNH3tpsJ9e8PB4luXl/G7G48E+qYSh4nSbwrjNz
	 F8fBOEdexfElvemKwL79H6luLv411OXQe83DAdpFN9XG5nRKQj8zWyl9u8RsQZ9hd6
	 OPi3c/Wv3VqVsJdI2UBlD890xz/pBUoYtg5IKypY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	"Bhatnagar, Rishabh" <risbhat@amazon.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 5.15 07/96] tick/common: Align tick period during sched_timer setup
Date: Mon, 26 Jun 2023 20:11:22 +0200
Message-ID: <20230626180747.233855562@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

commit 13bb06f8dd42071cb9a49f6e21099eea05d4b856 upstream.

The tick period is aligned very early while the first clock_event_device is
registered. At that point the system runs in periodic mode and switches
later to one-shot mode if possible.

The next wake-up event is programmed based on the aligned value
(tick_next_period) but the delta value, that is used to program the
clock_event_device, is computed based on ktime_get().

With the subtracted offset, the device fires earlier than the exact time
frame. With a large enough offset the system programs the timer for the
next wake-up and the remaining time left is too small to make any boot
progress. The system hangs.

Move the alignment later to the setup of tick_sched timer. At this point
the system switches to oneshot mode and a high resolution clocksource is
available. At this point it is safe to align tick_next_period because
ktime_get() will now return accurate (not jiffies based) time.

[bigeasy: Patch description + testing].

Fixes: e9523a0d81899 ("tick/common: Align tick period with the HZ tick.")
Reported-by: Mathias Krause <minipli@grsecurity.net>
Reported-by: "Bhatnagar, Rishabh" <risbhat@amazon.com>
Suggested-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Richard W.M. Jones <rjones@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/5a56290d-806e-b9a5-f37c-f21958b5a8c0@grsecurity.net
Link: https://lore.kernel.org/12c6f9a3-d087-b824-0d05-0d18c9bc1bf3@amazon.com
Link: https://lore.kernel.org/r/20230615091830.RxMV2xf_@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-common.c |   13 +------------
 kernel/time/tick-sched.c  |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -218,19 +218,8 @@ static void tick_setup_device(struct tic
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			ktime_t next_p;
-			u32 rem;
-
 			tick_do_timer_cpu = cpu;
-
-			next_p = ktime_get();
-			div_u64_rem(next_p, TICK_NSEC, &rem);
-			if (rem) {
-				next_p -= rem;
-				next_p += TICK_NSEC;
-			}
-
-			tick_next_period = next_p;
+			tick_next_period = ktime_get();
 #ifdef CONFIG_NO_HZ_FULL
 			/*
 			 * The boot CPU may be nohz_full, in which case set
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -161,8 +161,19 @@ static ktime_t tick_init_jiffy_update(vo
 	raw_spin_lock(&jiffies_lock);
 	write_seqcount_begin(&jiffies_seq);
 	/* Did we start the jiffies update yet ? */
-	if (last_jiffies_update == 0)
+	if (last_jiffies_update == 0) {
+		u32 rem;
+
+		/*
+		 * Ensure that the tick is aligned to a multiple of
+		 * TICK_NSEC.
+		 */
+		div_u64_rem(tick_next_period, TICK_NSEC, &rem);
+		if (rem)
+			tick_next_period += TICK_NSEC - rem;
+
 		last_jiffies_update = tick_next_period;
+	}
 	period = last_jiffies_update;
 	write_seqcount_end(&jiffies_seq);
 	raw_spin_unlock(&jiffies_lock);


