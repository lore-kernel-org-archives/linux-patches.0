Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6A2D507
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98645C4339B;
	Mon, 15 May 2023 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173482;
	bh=t3HksqggWWqKlzkJo9evKIUOtv6TPlQa/XMBnvOdHs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8xMhLaLmJOT7eQssZpCPXSz8VmIIdo7yEw7gJ6oTUj1sly2LZqk3WvUD12qDFpUG
	 Y5iN8H/TDk/L0Y+XwkXyRUvEXFq60uRajLAKaMHNXD2zPoxyEf/mDoNuq2xDNyBUhV
	 NIenhK2WHKgy3dAQ2UrUroar/tX/LBoJYWL+ZkYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfeng Ye <yeyunfeng@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/282] tick/sched: Reduce seqcount held scope in tick_do_update_jiffies64()
Date: Mon, 15 May 2023 18:27:28 +0200
Message-Id: <20230515161724.332012350@linuxfoundation.org>
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
index 1dfa53494164a..eaeeb4bb1f8ab 100644
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



