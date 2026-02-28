Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12533F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301146; cv=none; b=aHnX+lXEX7R8yByRlJ2RNgQQWUJCBn8Z5mtEqjJsaBsI8QlnI1TbsJsV1RAZwUvfrftUKCGGt/FGNY64FMfvbE0i0QECg4AO63u35XdL/2Pyt0meIjY8XrYY9/OSfxNRMdHZGGZ9qotAk8fla01lge/WlAmvPlPvcCYtrdBOOHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301146; c=relaxed/simple;
	bh=eJSxD8m6JPX70xqr8kY9rAV2Of6LboOOQtQM4nRT1nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDi0FZIBW8FiZLMlJ8QOL7iJ9JjzhmItrT0C8RIFiIkF/7tTypY3BiJTJfgtOXTApFQq3oqqVNTYkRKA+ezaI/Sa8B0a2hIDKaoTxDvAIOclBCEyi/FRFoKzTwubvbKpXJuxYJUcIkuwVsbBxc5LXPIBbdOylb+TVkurovKHZgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSfjHSD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSfjHSD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAFCC19424;
	Sat, 28 Feb 2026 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301146;
	bh=eJSxD8m6JPX70xqr8kY9rAV2Of6LboOOQtQM4nRT1nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSfjHSD+VJ5B2C+JqrkAFbhWjUx97a4rif4JhUWq27+5OM4LCGTNPGDQrKNu90nK7
	 qF5K2Ja20yt3O//Wq3pHgZBNQseKyK2mVKhhWuwevxekCCBn8XY6ms7//4tqtraULP
	 CxP9fMDa+WOXO20Ccj/7TscYFlaEJT/ePiPqpQN+pr+B5sigj3OASYP2qIR5CpUG83
	 b007dRd4EJGnTh+h9JKd57n6RSPeBy8ncgRcqbZEHqvnimxmcbLfX+Muv9fzv3VkUD
	 xdUnbU3USyJ3wvJikGDpRSrI5lCVJiKiVobUmK1Il6nHoSgh2xuBLmroiqGHrlyUJB
	 yywFRRdSxHD7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Colin Lord <clord@mykolab.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/752] tracing: Fix false sharing in hwlat get_sample()
Date: Sat, 28 Feb 2026 12:40:19 -0500
Message-ID: <20260228174750.1542406-308-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Colin Lord <clord@mykolab.com>

[ Upstream commit f743435f988cb0cf1f521035aee857851b25e06d ]

The get_sample() function in the hwlat tracer assumes the caller holds
hwlat_data.lock, but this is not actually happening. The result is
unprotected data access to hwlat_data, and in per-cpu mode can result in
false sharing which may show up as false positive latency events.

The specific case of false sharing observed was primarily between
hwlat_data.sample_width and hwlat_data.count. These are separated by
just 8B and are therefore likely to share a cache line. When one thread
modifies count, the cache line is in a modified state so when other
threads read sample_width in the main latency detection loop, they fetch
the modified cache line. On some systems, the fetch itself may be slow
enough to count as a latency event, which could set up a self
reinforcing cycle of latency events as each event increments count which
then causes more latency events, continuing the cycle.

The other result of the unprotected data access is that hwlat_data.count
can end up with duplicate or missed values, which was observed on some
systems in testing.

Convert hwlat_data.count to atomic64_t so it can be safely modified
without locking, and prevent false sharing by pulling sample_width into
a local variable.

One system this was tested on was a dual socket server with 32 CPUs on
each numa node. With settings of 1us threshold, 1000us width, and
2000us window, this change reduced the number of latency events from
500 per second down to approximately 1 event per minute. Some machines
tested did not exhibit measurable latency from the false sharing.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260210074810.6328-1-clord@mykolab.com
Signed-off-by: Colin Lord <clord@mykolab.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_hwlat.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 2f7b94e98317c..3fe274b84f1c2 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -102,9 +102,9 @@ struct hwlat_sample {
 /* keep the global state somewhere. */
 static struct hwlat_data {
 
-	struct mutex lock;		/* protect changes */
+	struct mutex	lock;		/* protect changes */
 
-	u64	count;			/* total since reset */
+	atomic64_t	count;		/* total since reset */
 
 	u64	sample_window;		/* total sampling window (on+off) */
 	u64	sample_width;		/* active sampling portion of window */
@@ -193,8 +193,7 @@ void trace_hwlat_callback(bool enter)
  * get_sample - sample the CPU TSC and look for likely hardware latencies
  *
  * Used to repeatedly capture the CPU TSC (or similar), looking for potential
- * hardware-induced latency. Called with interrupts disabled and with
- * hwlat_data.lock held.
+ * hardware-induced latency. Called with interrupts disabled.
  */
 static int get_sample(void)
 {
@@ -204,6 +203,7 @@ static int get_sample(void)
 	time_type start, t1, t2, last_t2;
 	s64 diff, outer_diff, total, last_total = 0;
 	u64 sample = 0;
+	u64 sample_width = READ_ONCE(hwlat_data.sample_width);
 	u64 thresh = tracing_thresh;
 	u64 outer_sample = 0;
 	int ret = -1;
@@ -267,7 +267,7 @@ static int get_sample(void)
 		if (diff > sample)
 			sample = diff; /* only want highest value */
 
-	} while (total <= hwlat_data.sample_width);
+	} while (total <= sample_width);
 
 	barrier(); /* finish the above in the view for NMIs */
 	trace_hwlat_callback_enabled = false;
@@ -285,8 +285,7 @@ static int get_sample(void)
 		if (kdata->nmi_total_ts)
 			do_div(kdata->nmi_total_ts, NSEC_PER_USEC);
 
-		hwlat_data.count++;
-		s.seqnum = hwlat_data.count;
+		s.seqnum = atomic64_inc_return(&hwlat_data.count);
 		s.duration = sample;
 		s.outer_duration = outer_sample;
 		s.nmi_total_ts = kdata->nmi_total_ts;
@@ -832,7 +831,7 @@ static int hwlat_tracer_init(struct trace_array *tr)
 
 	hwlat_trace = tr;
 
-	hwlat_data.count = 0;
+	atomic64_set(&hwlat_data.count, 0);
 	tr->max_latency = 0;
 	save_tracing_thresh = tracing_thresh;
 
-- 
2.51.0

