Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89251FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E425FC433EF;
	Mon, 15 May 2023 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172356;
	bh=MK4HViS1Up3Z5gHvgeJYDR8EL2gb6sG8+9g9XdmKsbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cisjw9RgXAL0hGjzhIHHGEGXnMatLAN5ZZchg4Nw+i4b7gMHyB9i4VAtRDKlN4o+T
	 NDnuD9V5WZWSqxHLKTe+X7zb34Y5VX7DDXG4H70+BhzaMu5bR9Sl7K0Zc9RgLqd5qf
	 ftaJGm88ABFmGxxO7bqzWf/TGiKP6ryp8vwMREfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfeng Ye <yeyunfeng@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/381] tick/sched: Reduce seqcount held scope in tick_do_update_jiffies64()
Date: Mon, 15 May 2023 18:26:17 +0200
Message-Id: <20230515161742.519128546@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 94ad2e3cedb82af034f6d97c58022f162b669f9b ]

If jiffies are up to date already (caller lost the race against another
CPU) there is no point to change the sequence count. Doing that just forces
other CPUs into the seqcount retry loop in tick_nohz_next_event() for
nothing.

Just bail out early.

[ tglx: Rewrote most of it ]

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201117132006.462195901@linutronix.de
Stable-dep-of: e9523a0d8189 ("tick/common: Align tick period with the HZ tick.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 47 +++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4f1b6170b3a20..ac9953f6f92ce 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -84,38 +84,35 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 	/* Reevaluate with jiffies_lock held */
 	raw_spin_lock(&jiffies_lock);
+	if (ktime_before(now, tick_next_period)) {
+		raw_spin_unlock(&jiffies_lock);
+		return;
+	}
+
 	write_seqcount_begin(&jiffies_seq);
 
-	delta = ktime_sub(now, last_jiffies_update);
-	if (delta >= tick_period) {
+	last_jiffies_update = ktime_add(last_jiffies_update, tick_period);
 
-		delta = ktime_sub(delta, tick_period);
-		last_jiffies_update = ktime_add(last_jiffies_update,
-						tick_period);
+	delta = ktime_sub(now, tick_next_period);
+	if (unlikely(delta >= tick_period)) {
+		/* Slow path for long idle sleep times */
+		s64 incr = ktime_to_ns(tick_period);
 
-		/* Slow path for long timeouts */
-		if (unlikely(delta >= tick_period)) {
-			s64 incr = ktime_to_ns(tick_period);
+		ticks = ktime_divns(delta, incr);
 
-			ticks = ktime_divns(delta, incr);
+		last_jiffies_update = ktime_add_ns(last_jiffies_update,
+						   incr * ticks);
+	}
 
-			last_jiffies_update = ktime_add_ns(last_jiffies_update,
-							   incr * ticks);
-		}
-		do_timer(++ticks);
+	do_timer(++ticks);
+
+	/*
+	 * Keep the tick_next_period variable up to date.  WRITE_ONCE()
+	 * pairs with the READ_ONCE() in the lockless quick check above.
+	 */
+	WRITE_ONCE(tick_next_period,
+		   ktime_add(last_jiffies_update, tick_period));
 
-		/*
-		 * Keep the tick_next_period variable up to date.
-		 * WRITE_ONCE() pairs with the READ_ONCE() in the lockless
-		 * quick check above.
-		 */
-		WRITE_ONCE(tick_next_period,
-			   ktime_add(last_jiffies_update, tick_period));
-	} else {
-		write_seqcount_end(&jiffies_seq);
-		raw_spin_unlock(&jiffies_lock);
-		return;
-	}
 	write_seqcount_end(&jiffies_seq);
 	raw_spin_unlock(&jiffies_lock);
 	update_wall_time();
-- 
2.39.2



