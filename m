Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55335B15A;
	Fri,  9 Jan 2026 12:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962648; cv=none; b=tKJaoCYChDUEN6VfYbt/mJInhiZm4Jtjqu/xGISF4iFIQppj2LgRj5IAC0WO1a1+hIatNkMVa/0Iqow+HKl1pdIfOk1d8iMOJHOivZt/3gur1Ke1Etq8EpkmHNqEMe0wnKbmMonZ6E8E5+kl0S8Y0OdlOcFldBUDgEY6oHGQW68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962648; c=relaxed/simple;
	bh=dSIZnFUG3wC640gUOjDd/AK8CUQzhZY67LyT6KxRmJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cetGA0wBq8K9LHG3x66pZIkNftN+aUuTGKZhFmez6BZXo7zprSO7rgAsqn1rev1bH5YfTg87E/24JpuiNFZjd1g/QV+OHBNJAxsRnRQ+KXqFmy774X34aWDEja8z0S8xyY4vHlqEHfoadRtvnFmB5ZhdzgmIhm1kcYd4H2vdKtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQfv7Hmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQfv7Hmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F40C19423;
	Fri,  9 Jan 2026 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962648;
	bh=dSIZnFUG3wC640gUOjDd/AK8CUQzhZY67LyT6KxRmJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQfv7HmcCRcf5ngnwWpTsdDO+D9+uBTZRnUgOtIJIx+ncJM3sCf14g7dQ9finLJWB
	 ZQGt4NVwvPY5oL3HV6J0n/Cri8ucpmoNNP2vTSJyYYRzHH8fXc3N03xldXr9I+0a4a
	 wpVFDQ1Qe0WS+SpX6c1K/Qq0U6YJ68VUhvplYIp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeelb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Leonardo Bras <leobras@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/634] sched/isolation: add cpu_is_isolated() API
Date: Fri,  9 Jan 2026 12:41:57 +0100
Message-ID: <20260109112134.060269989@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit a85c2257a8ac353af16dbcbf32c50d3380860bc5 ]

Patch series "memcg, cpuisol: do not interfere pcp cache charges draining
with cpuisol workloads".

Leonardo has reported [1] that pcp memcg charge draining can interfere
with cpu isolated workloads.  The said draining is done from a WQ context
with a pcp worker scheduled on each CPU which holds any cached charges for
a specific memcg hierarchy.  Operation is not really a common operation
[2].  It can be triggered from the userspace though so some care is
definitely due.

Leonardo has tried to address the issue by allowing remote charge draining
[3].  This approach requires an additional locking to synchronize pcp
caches sync from a remote cpu from local pcp consumers.  Even though the
proposed lock was per-cpu there is still potential for contention and less
predictable behavior.

This patchset addresses the issue from a different angle.  Rather than
dealing with a potential synchronization, cpus which are isolated are
simply never scheduled to be drained.  This means that a small amount of
charges could be laying around and waiting for a later use or they are
flushed when a different memcg is charged from the same cpu.  More details
are in patch 2.  The first patch from Frederic is implementing an
abstraction to tell whether a specific cpu has been isolated and therefore
require a special treatment.

This patch (of 2):

Provide this new API to check if a CPU has been isolated either through
isolcpus= or nohz_full= kernel parameter.

It aims at avoiding kernel load deemed to be safely spared on CPUs running
sensitive workload that can't bear any disturbance, such as pcp cache
draining.

Link: https://lkml.kernel.org/r/20230317134448.11082-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20230317134448.11082-2-mhocko@kernel.org
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Leonardo Bras <leobras@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 10845a105bbc ("blk-mq: skip CPU offline notify on unmapped hctx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/isolation.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 8c15abd67aed..fe1a46f30d24 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -46,6 +46,12 @@ static inline bool housekeeping_enabled(enum hk_type type)
 
 static inline void housekeeping_affine(struct task_struct *t,
 				       enum hk_type type) { }
+
+static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
+{
+	return true;
+}
+
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
@@ -58,4 +64,10 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline bool cpu_is_isolated(int cpu)
+{
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
+		 !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+}
+
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.51.0



