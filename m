Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0CE6AA7;
	Wed,  4 Jun 2025 00:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998605; cv=none; b=ANh3RciKe5H1+nvGw6RLFPHBtaYq4Kk0i1QfQPle1P3am1MHYCw4KGNnp9kSynoEzeGBwsOR5zuw+LdrfNUCrhftODLY6aEfsBhcCwCpSEOZ3J9eQ/DH3Dh9X0GwvPG8OqoqDF3MWUyHSHJMTxTdfVB5JuJpQ5G0jVhk6IE9Tvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998605; c=relaxed/simple;
	bh=F9L5Ypc+lMABqifRuArbt36pn9ATV+apmsYxvxFe2q0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uhzR7tZXYHEhYPPxks1AP42k04BtCT68uVxXgMipzuNUwkrfwdNBg4KoBrnEu9k74DFoDnzrzWqHwLpwc1ETOI6zlSs9wiKoUbHkugsI8JkfmmYeB+3VPjZ0zYZm3r5pkLnPFTSvSy/bFyCcew36qlA/gzFx7nhLJRNRvtSQ37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+tWaLEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+tWaLEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC61C4CEED;
	Wed,  4 Jun 2025 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998605;
	bh=F9L5Ypc+lMABqifRuArbt36pn9ATV+apmsYxvxFe2q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+tWaLEGtet8Amko9kKWAuYzZmU1+KtS3xzWw9CJ3LTFy5kNHfgP7uLQAhv84pBBW
	 QGiY0sVjc+k2XRIiNBvOJURNG5clC2bB93uK3JWfTJfN4yrXCwcsyaVZcGorB86Tkn
	 TejVvKCewvBsRvSso8h+rFIjU5FFPWkLvoXm0HkpxAI2tAlnTOM85fBCziG8vEug5N
	 UljPSuvFAHljKy8BGKXjXBsBdehRO75uYx++DBsNx7N2IXmXnugoG9jXwI8rVRDZCL
	 I+KF+bp+/zleaWUnQZrl/f2hWhQeZu25G0e17KW4EV5c+zU9fi6VHylAKnec0PpYed
	 oakWRfdZMzxjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	netdev@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 037/108] ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT
Date: Tue,  3 Jun 2025 20:54:20 -0400
Message-Id: <20250604005531.4178547-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 1c0829788a6e6e165846b9bedd0b908ef16260b6 ]

The statistics are incremented with raw_cpu_inc() assuming it always
happens with bottom half disabled. Without per-CPU locking in
local_bh_disable() on PREEMPT_RT this is no longer true.

Use this_cpu_inc() on PREEMPT_RT for the increment to not worry about
preemption.

Cc: David Ahern <dsahern@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250512092736.229935-4-bigeasy@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**Answer: YES** This commit should be backported to stable kernel trees
based on the following analysis: ## Technical Analysis **The Issue:**
The commit fixes a correctness bug in IPv4 routing statistics collection
on PREEMPT_RT kernels. The `RT_CACHE_STAT_INC` macro uses
`raw_cpu_inc()` which assumes preemption is disabled, but this
assumption is violated on PREEMPT_RT systems where many previously non-
preemptible contexts become preemptible. **Code Changes:** The fix is
minimal and surgical: ```c #ifndef CONFIG_PREEMPT_RT #define
RT_CACHE_STAT_INC(field) raw_cpu_inc(rt_cache_stat.field) #else #define
RT_CACHE_STAT_INC(field) this_cpu_inc(rt_cache_stat.field) #endif ```
This conditional compilation ensures that: - Non-PREEMPT_RT systems
maintain existing performance with `raw_cpu_inc()` - PREEMPT_RT systems
get correctness with `this_cpu_inc()` which includes implicit preemption
protection ## Backport Justification **1. Follows Stable Tree
Criteria:** - **Bug Fix:** Corrects statistics corruption on PREEMPT_RT
systems - **Small and Contained:** Only 4 lines changed in a single
macro definition - **Low Risk:** No behavioral change for non-PREEMPT_RT
systems - **No Architectural Changes:** Simple conditional compilation
approach **2. Consistent with Similar Commits:** The change follows the
exact same pattern as Similar Commit #1 and #3 (both marked "Backport
Status: YES"), which fix preemption-related issues in per-CPU
statistics. Like those commits, this addresses scenarios where
`__this_cpu_*` or `raw_cpu_*` operations are called from preemptible
context on PREEMPT_RT. **3. Real User Impact:** - **Affected Systems:**
PREEMPT_RT kernels with IPv4 routing (real-time systems, industrial
applications) - **Symptoms:** Inaccurate routing statistics due to race
conditions during CPU migration - **Debugging Impact:** Could mislead
network troubleshooting efforts **4. Technical Correctness:** Race
conditions can occur when a process is preempted and migrated to another
CPU between reading the per-CPU pointer and incrementing the counter,
leading to lost statistics updates. The `this_cpu_inc()` variant
prevents this by ensuring atomic access to per-CPU data. **5. Minimal
Risk Profile:** - No functional changes to packet forwarding - Zero
impact on non-PREEMPT_RT systems - Follows established kernel patterns
for PREEMPT_RT safety - No performance regression expected This is
exactly the type of targeted correctness fix that stable trees are
designed to include - it addresses a real bug affecting a specific
subset of users with minimal risk to the broader user base.

 net/ipv4/route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 753704f75b2c6..5d7c7efea66cc 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -189,7 +189,11 @@ const __u8 ip_tos2prio[16] = {
 EXPORT_SYMBOL(ip_tos2prio);
 
 static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
+#ifndef CONFIG_PREEMPT_RT
 #define RT_CACHE_STAT_INC(field) raw_cpu_inc(rt_cache_stat.field)
+#else
+#define RT_CACHE_STAT_INC(field) this_cpu_inc(rt_cache_stat.field)
+#endif
 
 #ifdef CONFIG_PROC_FS
 static void *rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
-- 
2.39.5

