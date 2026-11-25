Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624654;
	b=Wan6terKFas/OFVl/c0IsGKVjUkbxPJZswXNxW1zUqsttkpGJlUMrX35h5VGuxhHmZsG
	 bgGZe1NH+Sz1l1RfaOL5EdjqOBrceKpTNpFMmIOU3QDLYZ3c5YC/Pyul7dWmWB5HFESgU
	 P2uaT1QQbK2uC3VxVK0zoY1w0KnxVP2BKv6gP/N9t5nWOYas5Llhs903E1jXga/5KlwOd
	 qnCDfwWa6ZulPL78H6/j5zKzWjKxwdzUBt5aL/GJ+QZ9I6LhPujHM2H6LIMI5uadxGfqT
	 HssOGV3+8DVNh1rJKTGXoUwNaHB5QqDBISXe4O/C7kxuw+bZdC8BoeAKGtY5ExzM0hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G4ogTb7PAhU+NFPjHZO+uncnFzOsqKKKh7O9r8SS1N0=;
	b=dDxsMl/I/F0zZs82eZjAhdxwonzbSMMRg4wpUk3GTc3x0z65wJUmxG/C5npIGtH/a6jm
	 pqf04urDahAQKVYVDbBFG9aX+m6Ieny6OpUS+SWC3toYIcBSzLNf+FmFmpEmBfnjqTvsK
	 c4BUdBsRUmkJw2i2/9WD8Y+kScW+HrVWEfX65LVp8J9uNP1t3AhX51SMqXxtKo+qD0BrR
	 AWO0oewpmoy7l6up+n6RZu5TUstGM/SguBRgq8x4JP0DI5TWVEl1Ab75wCs7UgSYj1c9b
	 nf7ujsjMnsgj+VIFHKvDgLb/rvUv+Xxi6UEEAkxFTeNY/+8uUCp1uCDAV3hJL61AEgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOtQpkQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CDA606A33B;
	Wed, 25 Nov 2026 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOtQpkQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000091F000C6;
	Wed, 25 Nov 2026 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624653;
	bh=G4ogTb7PAhU+NFPjHZO+uncnFzOsqKKKh7O9r8SS1N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOtQpkQh7E3FD5FntJAuMWw24PhRmz9tRCk/ALAKfFVs8WYW5kAW60lGUpPi2XV9z
	 wMmMHbABKIId/9tnJUxQ9jvTpw1y/f5auRRzB26bk3FZtvKnCs4KDQhoItpUnQGIUT
	 bN+OJ3LHT6XHmyNagkRhvFCv4Vu0NuTOoLND6pZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ben Segall <bsegall@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/816] perf: Fix racy update of cpc->hrtimer_interval
Date: Wed, 25 Nov 2026 15:30:10 +0100
Message-ID: <20261125143855.272821033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Segall <bsegall@google.com>

[ Upstream commit 3bbd85b2f67aff58f2cbec9a7fb705677b94473b ]

Updates to cpc->hrtimer_interval can race with reads either in the
hrtimer itself, or other calls to perf_mux_hrtimer_restart. This is not
exactly expected to be a common config change, but it's easy enough to
fix.

Since there's already an IPI to each cpu to restart the timer, and all
reads are with irqs disabled, just move the update onto the target cpu.

Fixes: 62b856397927 ("perf: Add sysfs entry to adjust multiplexing interval per PMU")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://sashiko.dev/#/patchset/xm265wykhyrv.fsf%40google.com
Link: https://patch.msgid.link/xm26se1ihlqb.fsf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 45b7a1fdc964d..104064992b760 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1185,14 +1185,19 @@ static int perf_mux_hrtimer_restart(struct perf_cpu_pmu_context *cpc)
 	return 0;
 }
 
-static int perf_mux_hrtimer_restart_ipi(void *arg)
+static __always_inline struct perf_cpu_pmu_context *this_cpc(struct pmu *pmu)
 {
-	return perf_mux_hrtimer_restart(arg);
+	return *this_cpu_ptr(pmu->cpu_pmu_context);
 }
 
-static __always_inline struct perf_cpu_pmu_context *this_cpc(struct pmu *pmu)
+static int perf_mux_hrtimer_interval_ipi(void *arg)
 {
-	return *this_cpu_ptr(pmu->cpu_pmu_context);
+	struct pmu *pmu = arg;
+	struct perf_cpu_pmu_context *cpc = this_cpc(pmu);
+	int ms = pmu->hrtimer_interval_ms;
+
+	cpc->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * ms);
+	return perf_mux_hrtimer_restart(cpc);
 }
 
 void perf_pmu_disable(struct pmu *pmu)
@@ -11728,13 +11733,8 @@ perf_event_mux_interval_ms_store(struct device *dev,
 
 	/* update all cpuctx for this PMU */
 	cpus_read_lock();
-	for_each_online_cpu(cpu) {
-		struct perf_cpu_pmu_context *cpc;
-		cpc = *per_cpu_ptr(pmu->cpu_pmu_context, cpu);
-		cpc->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
-
-		cpu_function_call(cpu, perf_mux_hrtimer_restart_ipi, cpc);
-	}
+	for_each_online_cpu(cpu)
+		cpu_function_call(cpu, perf_mux_hrtimer_interval_ipi, pmu);
 	cpus_read_unlock();
 	mutex_unlock(&mux_interval_mutex);
 
-- 
2.53.0



