Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB4C470434;
	Tue, 21 Jul 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656250; cv=none; b=GAY8wxOqDuquotBXtIdZN3NiX9RVXjndlFPngUeSzzB8cF9ZZEm8TXGRTBxuV/26kCbJ4Jq8O36ZzBAAG/2UzUmOnVi780PFSzt3PktyeQ7CSgrhSZWG4s4BSBsB+oYvlK+fmNpKNShLmIjKT76M0C+j0hrqbAUZwND3OS5aNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656250; c=relaxed/simple;
	bh=yKmWoNaUTYbSazw3+LrGByrQ1K5lpBA3m8y+mLpyCA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBmU6sppRwkisuMworDZUssYvRdVEERThJIJTA5w7A5PWIbQrcv/NXzdmAYWfNhGTKcaOIJsYBmUlaetFkTAcz24IiWhdlR+t+uUgrkmG/XdvNLSdycgP8B4Njc4TV19oN2R1+wgEdHfdoKHTMAXTidHPfaqEXfxNvQb2CWE8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p09F7l3v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p09F7l3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEDA1F00A3A;
	Tue, 21 Jul 2026 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656249;
	bh=JqAywUZxaXQECN6kHNvznzQO65r8IIfDlKOx1N4Ca9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p09F7l3vtFMLXorj5ENyLA8q1xiUJm7U4oLySNC52vk1MOb2QMKVuwBHcDXNtjykE
	 MDu3S9Fo51NyIoDkHqGJbCcKbAFl8i4ql4I6V5HtsC/+YxOxa52L3T6/u7qXXVKVLe
	 5kR6R71X+uTvohlJQvWo81hsscXG+E/tQUbjb9cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0315/1611] tick/sched: Fix TOCTOU in nohz idle time fetch
Date: Tue, 21 Jul 2026 17:07:11 +0200
Message-ID: <20260721152522.163326534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 466e083c827218..4f04c621c9224f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -766,15 +766,16 @@ static u64 get_cpu_sleep_time_us(struct tick_sched *ts, ktime_t *sleeptime,
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



