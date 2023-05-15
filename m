Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D453FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1600DC433EF;
	Mon, 15 May 2023 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172359;
	bh=H/1+UzPVQdy96Xry1hn8eJduxdk5b7vEs+RxRYk77Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgE4EThv12HxB6KJiYU+YHOwIIuFOlFjtLl03zb+8QWbCzXf1M/658raNx1wtOVo2
	 dOq+ofU9m6gR7ZBQYXYDwFii/kN723LfpJM9LMyYc5g3rc/pf9yHoCFarnvjX6JF20
	 Ix+SpCeukbEyGhXDmcMUv7NqYoE1bEXdGnTmWZEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/381] tick/sched: Optimize tick_do_update_jiffies64() further
Date: Mon, 15 May 2023 18:26:18 +0200
Message-Id: <20230515161742.566080592@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 7a35bf2a6a871cd0252cd371d741e7d070b53af9 ]

Now that it's clear that there is always one tick to account, simplify the
calculations some more.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201117132006.565663056@linutronix.de
Stable-dep-of: e9523a0d8189 ("tick/common: Align tick period with the HZ tick.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ac9953f6f92ce..5c3d4355266db 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -53,7 +53,7 @@ static ktime_t last_jiffies_update;
  */
 static void tick_do_update_jiffies64(ktime_t now)
 {
-	unsigned long ticks = 0;
+	unsigned long ticks = 1;
 	ktime_t delta;
 
 	/*
@@ -91,20 +91,21 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 	write_seqcount_begin(&jiffies_seq);
 
-	last_jiffies_update = ktime_add(last_jiffies_update, tick_period);
-
 	delta = ktime_sub(now, tick_next_period);
 	if (unlikely(delta >= tick_period)) {
 		/* Slow path for long idle sleep times */
 		s64 incr = ktime_to_ns(tick_period);
 
-		ticks = ktime_divns(delta, incr);
+		ticks += ktime_divns(delta, incr);
 
 		last_jiffies_update = ktime_add_ns(last_jiffies_update,
 						   incr * ticks);
+	} else {
+		last_jiffies_update = ktime_add(last_jiffies_update,
+						tick_period);
 	}
 
-	do_timer(++ticks);
+	do_timer(ticks);
 
 	/*
 	 * Keep the tick_next_period variable up to date.  WRITE_ONCE()
-- 
2.39.2



