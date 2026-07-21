Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9455E46A5E3;
	Tue, 21 Jul 2026 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649082; cv=none; b=EgWxF2WD3DB6yVklCICVgNoqjjCdbU2DlR87d9tTcBdH38OFisnxESOmJy1meijzH0WipFtxPa+fMOURA+tFQr8f8HdzsLmNsKmqNWgkhelyMf3mgaizHAEiTBre3qdMPVnHgE/2TJVhadwJyYkRZyIqk5BJ03//1ibEoPHPDME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649082; c=relaxed/simple;
	bh=O+nn7km2ixe1oaSrQgbyp0SG7C/2FOIts48Wr3748zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gahi1AD8ODD/+OglgwXRlFo10aVz+dNUUIOcheOfUSwXRmJl27E9pgFv9TnR5ivWgXr+3gX2K9X2yJCYcn5pePb0Lu54OXC0qrWexgadKa+1cXSNRLbZ4QkzVDNk4jFqXVwDNRcQt/A3w5HVZ90X1tpndGDVY/zjQxYtLfgTL1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuFoexn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuFoexn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5651F000E9;
	Tue, 21 Jul 2026 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649081;
	bh=wXOPVVG9hA+3OUoIZ3+QPDXBxnfMpZ3NanzQhNAV8FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuFoexn0FCWjxTV9v+ZOcswq2Z9Pnv45NOGuoBlh92Cp3k5UGFgafH/jtq+GL8O6N
	 2uoX6gQ/ELm7qSXSnYQRDwfAD0/4dWBGSUfx3TAV/QH2Ef1ZZwP2jhjj41o1t8UsDN
	 sPD7Q8AO6KtLEJy2LE56+8GpbxdTCk3eB3xuaFp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0442/2077] tick/sched: Fix TOCTOU in nohz idle time fetch
Date: Tue, 21 Jul 2026 17:01:55 +0200
Message-ID: <20260721152603.188365265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 86db4084b4b5d1a074bcc66c108a4c9d266812d4 ]

When the nohz idle time is fetched, the current clock timestamp is taken
outside the seqcount, which can result in a race as reported by Sashiko:

    get_cpu_sleep_time_us()                 tick_nohz_start_idle()
    -----------------------                 ---------------------
    now = ktime_get()
                                            write_seqcount_begin(idle_sleeptime_seq);
                                            idle_entrytime = ktime_get()
                                            tick_sched_flag_set(ts, TS_FLAG_IDLE_ACTIVE);
                                            write_seqcount_end(&ts->idle_sleeptime_seq);
    read_seqcount_begin(idle_sleeptime_seq)
    delta = now - idle_entrytime);
    //!! But now < idle_entrytime
    idle = *sleeptime +  delta;
    read_seqcount_retry(&ts->idle_sleeptime_seq, seq)

Here the read side fetches the timestamp before the write side and its
update. As a result the time delta computed on the read side is negative
(ktime_t is signed) and breaks the cputime monotonicity guarantee.

This could possibly be fixed with reading the current clock timestamp
inside the seqcount but the reader overhead might then increase. Also
simply checking that the current timestamp is above the idle entry time
is enough to prevent any issue of the like.

Fixes: 620a30fa0bd1 ("timers/nohz: Protect idle/iowait sleep time under seqcount")
Reported-by: Sashiko
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260508131647.43868-2-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cbbb87a0c6e7ce..171393367b5c1e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -797,15 +797,16 @@ static u64 get_cpu_sleep_time_us(struct tick_sched *ts, ktime_t *sleeptime,
 		*last_update_time = ktime_to_us(now);
 
 	do {
+		ktime_t delta = 0;
+
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 
 		if (tick_sched_flag_test(ts, TS_FLAG_IDLE_ACTIVE) && compute_delta) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-
-			idle = ktime_add(*sleeptime, delta);
-		} else {
-			idle = *sleeptime;
+			if (now > ts->idle_entrytime)
+				delta = ktime_sub(now, ts->idle_entrytime);
 		}
+
+		idle = ktime_add(*sleeptime, delta);
 	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(idle);
-- 
2.53.0



