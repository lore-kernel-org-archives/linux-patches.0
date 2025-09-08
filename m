Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C2224247
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757368832; cv=none; b=WQMhfV1wS7duKGQQIGthXbhV/h6KvzEZX5YFMpMVI1arocSsVBT+0rHEV6P1gF29W91dFJh6tYeOHHlfxg9aiLzLtuwjuglVwDQXutTRhQeAOG3OoVND1vk1cm98zm/vemdbcfYls2sVAOMmWsZWCceL9cCaDluAwXuQJ0F8xqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757368832; c=relaxed/simple;
	bh=RPrfcCoCldrbAE6gBsixpuRnRnSRk6iX7jPBvUCFPaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t3tQ5XCy8CXZrHXF4u1St0UF4pSxn7rkVyACSzHjIgLu9eOOsypShrvyHw1hoi6VGWiBAZrK+djLWxQTuxju3DAvDC0w8JdtCFiTs06XJE2cdbBC0EWNQPhIoTNuMV7syLBr+a1K0naPoSe/XlFf21TO6VArkRd0ISts2ZByLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JnENuwqM; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnENuwqM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757368830; x=1788904830;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RPrfcCoCldrbAE6gBsixpuRnRnSRk6iX7jPBvUCFPaY=;
  b=JnENuwqMeSJmJOxgMtFG8geTIGFKvd7Ogoowc/XfY1m20dI6fKXk0oHi
   EKCP5HcpZW4pgx9XnHuEP0y3T+X6fICYOc4ETKdFZ19qDwd4gVL2uuJyU
   mH/GWTGeuwhcqJbjkJUFkf2rwNCCxI3iihMG/bufXQ1th14PQ0yWeTznP
   Aw7sizUnijfsr7FXqkUiXAEEU8b4cjeW1Jcc1UQDWDLBH0CL+fqMciASm
   rAL3Xz/l5rOXJHdVcrl4HatiLfOW3HsCVCt+Y/uam+Dj40/rcW+nlided
   bkcLlKSxOj4l4cEUkjJM06MQyz0/8Ra24unKn9YxJHWW0pAtlU9ErYusC
   A==;
X-CSE-ConnectionGUID: s9BTgBhsQdKUalt3Q486Qw==
X-CSE-MsgGUID: bM4+UJJJRXyYPRJa04gfuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="62269893"
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="62269893"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 15:00:29 -0700
X-CSE-ConnectionGUID: SNnYNmWRRDOJOx5aobceSQ==
X-CSE-MsgGUID: I8ML/hIlRKKPSGhWcrcDDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="172088103"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 15:00:29 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: qinyuntan@linux.alibaba.com,
	tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH] fs/resctrl: Eliminate false positive lockdep warning when reading SNC counters
Date: Mon,  8 Sep 2025 15:15:51 -0700
Message-ID: <0819ce534d0cb919f728e940d9412c3bab1a27c7.1757369564.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running resctrl_tests on an SNC-2 system with lockdep debugging enabled
triggers several warnings with following trace:
	WARNING: CPU: 0 PID: 1914 at kernel/cpu.c:528 lockdep_assert_cpus_held+0x8a/0xc0
	...
	Call Trace:
	__mon_event_count
	? __lock_acquire
	? __pfx___mon_event_count
	mon_event_count
	? __pfx_smp_mon_event_count
	smp_mon_event_count
	smp_call_on_cpu_callback
	<snip>

get_cpu_cacheinfo_level() called from __mon_event_count() requires CPU
hotplug lock to be held. The hotplug lock is indeed held during this time,
as confirmed by the lockdep_assert_cpus_held() within mon_event_read()
that calls mon_event_count() via IPI, but the lockdep tracking is not able
to follow the IPI.

Fresh CPU cache information via get_cpu_cacheinfo_level() from
__mon_event_count() was added to support the fix for the issue where
resctrl inappropriately maintained links to L3 cache information that will
be stale in the case when the associated CPU goes offline.

Keep the cacheinfo ID in struct rdt_mon_domain to ensure that
resctrl does not maintain stale cache information while CPUs can go
offline. Return to using a pointer to the L3 cache information (struct
cacheinfo) in struct rmid_read, rmid_read::ci. Initialize rmid_read::ci
before the IPI where it is used. CPU hotplug lock is held across
rmid_read::ci initialization and use to ensure that it points to accurate
cache information.

Fixes: 594902c986e2 ("x86,fs/resctrl: Remove inappropriate references to cacheinfo in the resctrl subsystem")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/ctrlmondata.c | 2 +-
 fs/resctrl/internal.h    | 4 ++--
 fs/resctrl/monitor.c     | 6 ++----
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d98e0d2de09f..3c39cfacb251 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -625,11 +625,11 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 */
 		list_for_each_entry(d, &r->mon_domains, hdr.list) {
 			if (d->ci_id == domid) {
-				rr.ci_id = d->ci_id;
 				cpu = cpumask_any(&d->hdr.cpu_mask);
 				ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 				if (!ci)
 					continue;
+				rr.ci = ci;
 				mon_event_read(&rr, r, NULL, rdtgrp,
 					       &ci->shared_cpu_map, evtid, false);
 				goto checkresult;
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 0a1eedba2b03..9a8cf6f11151 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -98,7 +98,7 @@ struct mon_data {
  *	   domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
- * @ci_id: Cacheinfo id for L3. Only set when @d is NULL. Used when summing domains.
+ * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
  * @val:   Returned value of event counter. If @rgrp is a parent resource group,
  *	   @val includes the sum of event counts from its child resource groups.
@@ -112,7 +112,7 @@ struct rmid_read {
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
-	unsigned int		ci_id;
+	struct cacheinfo	*ci;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index f5637855c3ac..7326c28a7908 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -361,7 +361,6 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
 	struct rdt_mon_domain *d;
-	struct cacheinfo *ci;
 	struct mbm_state *m;
 	int err, ret;
 	u64 tval = 0;
@@ -389,8 +388,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	}
 
 	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
-	if (!ci || ci->id != rr->ci_id)
+	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
 		return -EINVAL;
 
 	/*
@@ -402,7 +400,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	 */
 	ret = -EINVAL;
 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
-		if (d->ci_id != rr->ci_id)
+		if (d->ci_id != rr->ci->id)
 			continue;
 		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
 					     rr->evtid, &tval, rr->arch_mon_ctx);
-- 
2.50.1

