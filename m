Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B669446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A582C433C7;
	Sun, 13 Aug 2023 21:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963216;
	bh=3FEVHH9EMziWpu1PEM7ZB8Iv2farjZcK7HkQLcEDB98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVNVUfG7T2Md62apJI3ldu9X28vAlVrTVGbnPeT6a6w038FudOin3Sxq6GRWpFvKX
	 wHHzB2/A5wLDE3paNdVPOCaLcU3874ICmw7L36hR3bqLLkNr/m6N7pgMvzOJDznEMU
	 mOL9JF3GmEjEmHL5yRhn6mePv9I2cjtoJ4fmg6ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.15 88/89] timers/nohz: Switch to ONESHOT_STOPPED in the low-res handler when the tick is stopped
Date: Sun, 13 Aug 2023 23:20:19 +0200
Message-ID: <20230813211713.398196163@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 62c1256d544747b38e77ca9b5bfe3a26f9592576 ]

When tick_nohz_stop_tick() stops the tick and high resolution timers are
disabled, then the clock event device is not put into ONESHOT_STOPPED
mode. This can lead to spurious timer interrupts with some clock event
device drivers that don't shut down entirely after firing.

Eliminate these by putting the device into ONESHOT_STOPPED mode at points
where it is not being reprogrammed. When there are no timers active, then
tick_program_event() with KTIME_MAX can be used to stop the device. When
there is a timer active, the device can be stopped at the next tick (any
new timer added by timers will reprogram the tick).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220422141446.915024-1-npiggin@gmail.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-sched.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -950,6 +950,8 @@ static void tick_nohz_stop_tick(struct t
 	if (unlikely(expires == KTIME_MAX)) {
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
 			hrtimer_cancel(&ts->sched_timer);
+		else
+			tick_program_event(KTIME_MAX, 1);
 		return;
 	}
 
@@ -1356,9 +1358,15 @@ static void tick_nohz_handler(struct clo
 	tick_sched_do_timer(ts, now);
 	tick_sched_handle(ts, regs);
 
-	/* No need to reprogram if we are running tickless  */
-	if (unlikely(ts->tick_stopped))
+	if (unlikely(ts->tick_stopped)) {
+		/*
+		 * The clockevent device is not reprogrammed, so change the
+		 * clock event device to ONESHOT_STOPPED to avoid spurious
+		 * interrupts on devices which might not be truly one shot.
+		 */
+		tick_program_event(KTIME_MAX, 1);
 		return;
+	}
 
 	hrtimer_forward(&ts->sched_timer, now, TICK_NSEC);
 	tick_program_event(hrtimer_get_expires(&ts->sched_timer), 1);


