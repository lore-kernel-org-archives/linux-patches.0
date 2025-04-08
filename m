Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B46B27C840;
	Tue,  8 Apr 2025 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117018; cv=none; b=pEzqN0t1B+/XdvpYRM/4s8d8QMzw3ybtxvoaHhcAqBqadnM9t8VHeSgDK9iA/VepeXjUSXppssw2MigysyhZ6XdmjB9O3c0oCCyPTsOdYJBFp1xuI8VxBtzEqSD8eh5qO7A6dvhWRFML8+hVyiPs199+YIXSzwL/7M5vfetNDxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117018; c=relaxed/simple;
	bh=rs4BoYWXnjFw42NFxdYl18/6Wtw4lP5MxsEWK0NXHRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJs8oen4yHHS+ku4gtty4d1y9HJe5qI753MZG7zV4f08TysbjeVsmpQ4OJTJUc9ptJ8BkvdWSoT6xS5sZS4LHdfH3f5ydcCx6VIRs7tAhMv+SEa4B5PUxkOc9z6UbgOMlquzrnQs/GkRFs1qF0fhCjYkVIMdxP/1AdbT/1MkWZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIvkUzza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIvkUzza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC48FC4CEE5;
	Tue,  8 Apr 2025 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117018;
	bh=rs4BoYWXnjFw42NFxdYl18/6Wtw4lP5MxsEWK0NXHRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIvkUzzarGIQrmqxx/3uS6fqkf8VqbU6NsDj6Z/MicUoTeNSunOrxY3JQt6OC47h3
	 VNwn7Nwiayzy/zErr5BuUjkHuZtJmx5hwAoq0CmbzSm1w8PJv03UGORmi/Hh8K/UIx
	 rLDmvOeqt8v46KqpqVrFJhfWLkg/sdTqnyNhY7PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/423] cgroup/rstat: Tracking cgroup-level niced CPU time
Date: Tue,  8 Apr 2025 12:51:21 +0200
Message-ID: <20250408104854.120449269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joshua Hahn <joshua.hahn6@gmail.com>

[ Upstream commit aefa398d93d5db7c555be78a605ff015357f127d ]

Cgroup-level CPU statistics currently include time spent on
user/system processes, but do not include niced CPU time (despite
already being tracked). This patch exposes niced CPU time to the
userspace, allowing users to get a better understanding of their
hardware limits and can facilitate more informed workload distribution.

A new field 'ntime' is added to struct cgroup_base_stat as opposed to
struct task_cputime to minimize footprint.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: c4af66a95aa3 ("cgroup/rstat: Fix forceidle time in cpu.stat")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup/rstat.c       | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index a32eebcd23da4..38b2af336e4a0 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -324,6 +324,7 @@ struct cgroup_base_stat {
 #ifdef CONFIG_SCHED_CORE
 	u64 forceidle_sum;
 #endif
+	u64 ntime;
 };
 
 /*
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index ce295b73c0a36..aac91466279f1 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -444,6 +444,7 @@ static void cgroup_base_stat_add(struct cgroup_base_stat *dst_bstat,
 #ifdef CONFIG_SCHED_CORE
 	dst_bstat->forceidle_sum += src_bstat->forceidle_sum;
 #endif
+	dst_bstat->ntime += src_bstat->ntime;
 }
 
 static void cgroup_base_stat_sub(struct cgroup_base_stat *dst_bstat,
@@ -455,6 +456,7 @@ static void cgroup_base_stat_sub(struct cgroup_base_stat *dst_bstat,
 #ifdef CONFIG_SCHED_CORE
 	dst_bstat->forceidle_sum -= src_bstat->forceidle_sum;
 #endif
+	dst_bstat->ntime -= src_bstat->ntime;
 }
 
 static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
@@ -534,8 +536,10 @@ void __cgroup_account_cputime_field(struct cgroup *cgrp,
 	rstatc = cgroup_base_stat_cputime_account_begin(cgrp, &flags);
 
 	switch (index) {
-	case CPUTIME_USER:
 	case CPUTIME_NICE:
+		rstatc->bstat.ntime += delta_exec;
+		fallthrough;
+	case CPUTIME_USER:
 		rstatc->bstat.cputime.utime += delta_exec;
 		break;
 	case CPUTIME_SYSTEM:
@@ -590,6 +594,7 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
 #ifdef CONFIG_SCHED_CORE
 		bstat->forceidle_sum += cpustat[CPUTIME_FORCEIDLE];
 #endif
+		bstat->ntime += cpustat[CPUTIME_NICE];
 	}
 }
 
@@ -607,13 +612,14 @@ static void cgroup_force_idle_show(struct seq_file *seq, struct cgroup_base_stat
 void cgroup_base_stat_cputime_show(struct seq_file *seq)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	u64 usage, utime, stime;
+	u64 usage, utime, stime, ntime;
 
 	if (cgroup_parent(cgrp)) {
 		cgroup_rstat_flush_hold(cgrp);
 		usage = cgrp->bstat.cputime.sum_exec_runtime;
 		cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime,
 			       &utime, &stime);
+		ntime = cgrp->bstat.ntime;
 		cgroup_rstat_flush_release(cgrp);
 	} else {
 		/* cgrp->bstat of root is not actually used, reuse it */
@@ -621,16 +627,19 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 		usage = cgrp->bstat.cputime.sum_exec_runtime;
 		utime = cgrp->bstat.cputime.utime;
 		stime = cgrp->bstat.cputime.stime;
+		ntime = cgrp->bstat.ntime;
 	}
 
 	do_div(usage, NSEC_PER_USEC);
 	do_div(utime, NSEC_PER_USEC);
 	do_div(stime, NSEC_PER_USEC);
+	do_div(ntime, NSEC_PER_USEC);
 
 	seq_printf(seq, "usage_usec %llu\n"
-		   "user_usec %llu\n"
-		   "system_usec %llu\n",
-		   usage, utime, stime);
+			"user_usec %llu\n"
+			"system_usec %llu\n"
+			"nice_usec %llu\n",
+			usage, utime, stime, ntime);
 
 	cgroup_force_idle_show(seq, &cgrp->bstat);
 }
-- 
2.39.5



