Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618862;
	b=l34D78L813jQk7GSsvxDm5Ej3+gNmsYLjNSBVLTJWEPboKOzZm29OL89wIlKYsc3+xO4
	 FucDdH/NHDdtacCxCVjyD5ddaGfy4j+gXCQpMn+s7YFrXAbQ/+WfOJa2CeZg9aH86oZl/
	 Pofxynjkc+LL9lw64ZJAIc6TY4+Ma9LMta4yjcJrZ8DlJF+ip3q31nJxR7TPGEa0OYyUl
	 YIak2/lZYuDkmR/RqkJfrIJma9Fj9gBDzvydZxrpHS/F8kr2O/Us39kfMWSTJqksraKti
	 cPbKbNa3nbqHMVpVRiCcK4AR+RfC/n6liDmDx/5l8KU0Up40WfdZMwdxEOmY4qr/mOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bySdQj1dSDSQLcopFzs+V+t4Is2TXcZ/VDt319hQ6Cg=;
	b=TjiQiq07nlRdD/C4GpMC48Mf5Ng0IZJY0RvhcmHpsX5/PT6CBTZ07nnRdE7gEvKRSvi8
	 33Ib60seqE8MrMZ5b0lECfg9A9gXr5mftH2LPCZB192LJFl57ED/QuELn6JC/VBn2MMQ8
	 Vh5yfTjpXPQWyD/8lBUJVLPOqdjClC5vo/irlE8Cg+pL73kphctlQ33Mb6ahnJy7Gw+R5
	 30h2/Rvz8GfXmfmJYBsQk7kahfhXfhuiBmyRXSySmw0KTaE4aYNDellWfS2u01+DSr2it
	 6RDUEdThH32j5bUqo1wTItQAlJ/UfRZ4uKOfW4DJDO2ehriNdty5hlOm/J564GEXEUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iC75MoJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B685606A321;
	Wed, 25 Nov 2026 15:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iC75MoJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCF11F000C4;
	Wed, 25 Nov 2026 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618862;
	bh=bySdQj1dSDSQLcopFzs+V+t4Is2TXcZ/VDt319hQ6Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iC75MoJZGQnoHnsh8FOepwWublKEwfhI00f+m7cZ+6C0RBKRwv+4xB7gxTmIHDeYJ
	 hrrmjI4ft8bUgVPLGzi9g2wqlaBxKYMT/1kX2+BclBwOzJKpTid+6r0rIXQ0Pm7f+v
	 DU97faDq8OhJwi/bVIex14Wf5N6Dn6ylE50j/dbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ben Segall <bsegall@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0357/1005] perf: Fix racy update of cpc->hrtimer_interval
Date: Wed, 25 Nov 2026 15:28:15 +0100
Message-ID: <20261125143830.096732292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9c45f9d584d67..4239cc173e356 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1332,14 +1332,19 @@ static int perf_mux_hrtimer_restart(struct perf_cpu_pmu_context *cpc)
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
@@ -12770,13 +12775,8 @@ perf_event_mux_interval_ms_store(struct device *dev,
 
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



