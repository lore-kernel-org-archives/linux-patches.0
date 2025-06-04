Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9661D63C7;
	Wed,  4 Jun 2025 01:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998822; cv=none; b=LurYIehur9YnN2e8YlTgZhsfqo2qdfNjNAYtf0lK0rrJybNzRViB9Bfd7Z7uwDus2tVEDTW3B++g1GGc7kP+1yBOH/uUe4wZL2a0aop2Re5OCzfM7t3hrNfFWhTeY/JToPQsFTgZfPCDNmA4gyVHALUzoY+6zoLhVq1KVI4kK1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998822; c=relaxed/simple;
	bh=90AkRalhTbIGhZjjV3ivxA/cDy2nJxG73NzBxLWHQcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CZ/pnqSMRZVLEHQf4TnctLUR1wbXlfMRFhPeNfXFVNabEJt0Qlth5dwy4b9pLJsdxc5fKgWfgZpDOSvNhYYsU22ljMaPejUeYk8H9uERMTBV64zdr6e0VLNq2+aF5pvLDoPVTqVA565y4qgO61NxuVlonDzTgorbwVWL102Tmrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKZO7iqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKZO7iqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6C1C4CEEF;
	Wed,  4 Jun 2025 01:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998822;
	bh=90AkRalhTbIGhZjjV3ivxA/cDy2nJxG73NzBxLWHQcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKZO7iqaN39QdN3nQj9krXh/Hrm2YFD3gins+248nKryx0CT1KziZl4m8aPWjqclx
	 mTmqPrWflFrFyBvM+9Xcnjli6knDimHhV/UAdKGXMiGaIR2ypEEgFY7yGO4QhXpcEI
	 +hZTiDCF8h4p8jWCObqA9jdbK/qFlwHCGiWrNbq1pt6ETn/pcLnUPAx1l8sJMCQCLY
	 J+8RV++NSy+DrXsNcVmBaOzeXOm6dK5SmbTmFzB6Sd9yWjJKmiOIE8B5DBiXx6afd9
	 XKDH4SEyUdtZ3q46+jBT2SrXOxLvaYrx1bcc/AvWY4bxm4reELoa+ZbGJ8W/04/jiX
	 L6apEmSRL4/dg==
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
Subject: [PATCH AUTOSEL 6.12 33/93] ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT
Date: Tue,  3 Jun 2025 20:58:19 -0400
Message-Id: <20250604005919.4191884-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index 41b320f0c20eb..88d7c96bfac06 100644
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

