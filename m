Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621734;
	b=jfW1nIaSZkkouO24aKcSJ9UzHy8avlQZT23vk6fiLWk6EKIi+aMuFS2Fp1w9bJW8aiRB
	 exQoXRRr7zuest0YHjBOJ+pJtXMN9FIwjNe1tC5HQVyqhVHAONY1Rf1J4uESGV0Jt4taV
	 jMv12dyD/SLvUKlmxoa5VK3k8BQcaq4KWZe6BzoQquVnpwbtKK+tADLIBWFxb1y4wTe59
	 5NYdaTJQj5AvSXK/y0TCM/2OExrRM9wxb1AWmUVg874wWQa8UslICn8qGo9rGR+J2iN7/
	 r4uWv13Zi41b9h3lYviWwG6QUd/Bwr3su429XV3eUjcBCuifRWdMvzJ5FbmNHQQcRTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRzGsQLaapZWsG2plXc+cWi7RxRDnC/So+uU4lPBU/4=;
	b=IEmDYbUGIJsj1URi/EQb01k9+KHwEU2WT6yZzftv4xisr6OTjZIe6Ta/PGQTlbhW4/XC
	 5amdAZ3TvviA1gyoz0WhBpaqP2BPm9KJ/XWgpPtX+75+xkp5C9tu+mA4gchhmRxm3KJur
	 2PUY3J2xaph61XpXLw1N+UZ7tSQLE2WIlQrnljbA05GkWWONciMbxw5h7d8Av69/OgQ3A
	 o9AZXSlguscVvWnqREgE2hsd4RwFIVFGg8MSYupNzhHZgJDiqmfyT3ToLuUqFusXg7JdW
	 p3lC6+qpXeWuzcUqUBXQLAiygM40Ici3dzcdVqU6BVsWdyk5+2tawpkXYIOmpjU2Grw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqLNu30P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADE7606A334;
	Wed, 25 Nov 2026 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqLNu30P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E62E1F000E0;
	Wed, 25 Nov 2026 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621734;
	bh=uRzGsQLaapZWsG2plXc+cWi7RxRDnC/So+uU4lPBU/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqLNu30PuT9O++KHagTZZWKNFwASibikXrRJfkEO+bikd7p0P2LaQZyepuKR87xU4
	 X6WPJePgWjBdJMW1q0rat7nXMCRyPKk7vH3QAfgvoZuYAn6oA/rTMgzo90RB0FCtbf
	 cq3uhcXslRPPWzu5QpEcrGC02EpNk0zgKrkc6ADg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ben Segall <bsegall@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/990] perf: Fix racy update of cpc->hrtimer_interval
Date: Wed, 25 Nov 2026 15:28:08 +0100
Message-ID: <20261125143829.608032074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6d3fe508b7406..0f367ffef6deb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1231,14 +1231,19 @@ static int perf_mux_hrtimer_restart(struct perf_cpu_pmu_context *cpc)
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
@@ -12453,13 +12458,8 @@ perf_event_mux_interval_ms_store(struct device *dev,
 
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



