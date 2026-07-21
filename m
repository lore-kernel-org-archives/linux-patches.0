Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C576408039;
	Tue, 21 Jul 2026 19:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661862; cv=none; b=IU500K/SV5Cden8ae7EB+PA6WolaeSsLj1JJEFCeN5/lB1804x90IJCSjaPAhrw9bTpZr+VBQa/KDRTx8J9DaUtOzN9+FAkmHQTvjOe9sQZB8ClDr1uwPrgT7SKshz0dnvVfj3C7mnyPu0xRMuLtILSWBhiSA3aRRqnZsdSJJHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661862; c=relaxed/simple;
	bh=gghIk5nhUuOPn4Zsx8pmUF1khvwtfPy7KXoVTbEIYAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6wx92xhT/gC0N64cHRN2jq2Op8tQy3VVEDEmpEu+hcmbvhLduoBH2TJjCA1MYr9u9bCsRZoNpTH8LmQKiffIQcTBSUN8Fjhi9sQ8DBfCVTqJ3/aU8T0B4ijp70XM+4wD2IO4dZlgrdHiGHuUNE8P0DATnvcrAudLip/uDp8oZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYeQtGnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYeQtGnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823051F000E9;
	Tue, 21 Jul 2026 19:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661861;
	bh=vnyx/PYs1n1AoYtkGRvXzl+NOvEf8GoEaTkMafeDGc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYeQtGnQ9AycdLprP2AK95htg8xFGFA8lHMRuVoQ5dvZ4Kc8ColQBi7uVuXzQjqJK
	 vmoLQcNbsMO+4DG3rgtahU3EWMPTq8t5BYcKNffeINABjT4YZKDaXKmSHT8XFAcarb
	 HY3WL0gI3l+tHJJ61wVK4wHe+0s6iW0pydW9xGuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0224/1276] tick/sched: Fix TOCTOU in nohz idle time fetch
Date: Tue, 21 Jul 2026 17:11:07 +0200
Message-ID: <20260721152451.103896391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f203f000da1ad8..88fcd439e93deb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -774,15 +774,16 @@ static u64 get_cpu_sleep_time_us(struct tick_sched *ts, ktime_t *sleeptime,
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



