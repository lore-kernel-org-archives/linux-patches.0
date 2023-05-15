Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473E2FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D4AC4339B;
	Mon, 15 May 2023 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173364;
	bh=TstRdglHR/O1z2z/Hg5RWh36gcMeEsz9rH8JU3Yp1SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHdaK290E/l8ZUvJpvRq3O5V6A2erRK7JPQCCHGH/MZcPD5tcXJ6V+QHLXQVRtZ6N
	 j5w3XaOQ2qGHDlqGzGRwxLS6gH6UYsWk8RfagMzT0VUKvVg2ABN5unzJD6aO4DSm8Q
	 86ChCr9cM3YJDZsb/ELbaiNw87dFwNEy++Kl1pkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/282] tick/sched: Use tick_next_period for lockless quick check
Date: Mon, 15 May 2023 18:27:27 +0200
Message-Id: <20230515161724.303049194@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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

[ Upstream commit 372acbbaa80940189593f9d69c7c069955f24f7a ]

No point in doing calculations.

   tick_next_period = last_jiffies_update + tick_period

Just check whether now is before tick_next_period to figure out whether
jiffies need an update.

Add a comment why the intentional data race in the quick check is safe or
not so safe in a 32bit corner case and why we don't worry about it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201117132006.337366695@linutronix.de
Stable-dep-of: e9523a0d8189 ("tick/common: Align tick period with the HZ tick.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 46 ++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 88a508cc89255..1dfa53494164a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -57,11 +57,29 @@ static void tick_do_update_jiffies64(ktime_t now)
 	ktime_t delta;
 
 	/*
-	 * Do a quick check without holding jiffies_lock:
-	 * The READ_ONCE() pairs with two updates done later in this function.
+	 * Do a quick check without holding jiffies_lock. The READ_ONCE()
+	 * pairs with the update done later in this function.
+	 *
+	 * This is also an intentional data race which is even safe on
+	 * 32bit in theory. If there is a concurrent update then the check
+	 * might give a random answer. It does not matter because if it
+	 * returns then the concurrent update is already taking care, if it
+	 * falls through then it will pointlessly contend on jiffies_lock.
+	 *
+	 * Though there is one nasty case on 32bit due to store tearing of
+	 * the 64bit value. If the first 32bit store makes the quick check
+	 * return on all other CPUs and the writing CPU context gets
+	 * delayed to complete the second store (scheduled out on virt)
+	 * then jiffies can become stale for up to ~2^32 nanoseconds
+	 * without noticing. After that point all CPUs will wait for
+	 * jiffies lock.
+	 *
+	 * OTOH, this is not any different than the situation with NOHZ=off
+	 * where one CPU is responsible for updating jiffies and
+	 * timekeeping. If that CPU goes out for lunch then all other CPUs
+	 * will operate on stale jiffies until it decides to come back.
 	 */
-	delta = ktime_sub(now, READ_ONCE(last_jiffies_update));
-	if (delta < tick_period)
+	if (ktime_before(now, READ_ONCE(tick_next_period)))
 		return;
 
 	/* Reevaluate with jiffies_lock held */
@@ -72,9 +90,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 	if (delta >= tick_period) {
 
 		delta = ktime_sub(delta, tick_period);
-		/* Pairs with the lockless read in this function. */
-		WRITE_ONCE(last_jiffies_update,
-			   ktime_add(last_jiffies_update, tick_period));
+		last_jiffies_update = ktime_add(last_jiffies_update,
+						tick_period);
 
 		/* Slow path for long timeouts */
 		if (unlikely(delta >= tick_period)) {
@@ -82,15 +99,18 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 			ticks = ktime_divns(delta, incr);
 
-			/* Pairs with the lockless read in this function. */
-			WRITE_ONCE(last_jiffies_update,
-				   ktime_add_ns(last_jiffies_update,
-						incr * ticks));
+			last_jiffies_update = ktime_add_ns(last_jiffies_update,
+							   incr * ticks);
 		}
 		do_timer(++ticks);
 
-		/* Keep the tick_next_period variable up to date */
-		tick_next_period = ktime_add(last_jiffies_update, tick_period);
+		/*
+		 * Keep the tick_next_period variable up to date.
+		 * WRITE_ONCE() pairs with the READ_ONCE() in the lockless
+		 * quick check above.
+		 */
+		WRITE_ONCE(tick_next_period,
+			   ktime_add(last_jiffies_update, tick_period));
 	} else {
 		write_seqcount_end(&jiffies_seq);
 		raw_spin_unlock(&jiffies_lock);
-- 
2.39.2



