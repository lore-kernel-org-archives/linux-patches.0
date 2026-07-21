Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE13546A5E5;
	Tue, 21 Jul 2026 15:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648875; cv=none; b=NMcg+zMrX4+RHB3NGB/zvjtEpvjd+abmC0zxJH/8caGg4t6lMrktZG/Zx/ETPKDNUjRszssXZ11pU/s7r47mooRETg79YVyMbJAfopuG4btetP+UTtC9ZqO9xXLH0kFP6b8TwFzupJdInq9bIkGhwr+UJMTRCOxZPYfVhuaGK+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648875; c=relaxed/simple;
	bh=Hun+jfGXdKmDsysgz/rFE6mjSwYGHHVk7iKsmiD9iVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhO3qQIiXISyicPRq9BEKkF1c5K7nc/56I0+7JEZbVC7WwAowHg/RBy/770jbmmY5+s7zdcWF0ALPxXuczF0UCZOcqIR5UwbKYUyChJaSRozRdU+s2pDPZoslXrYcL3JI7uGCuxXZhZgf46Os6x8Eb0yFFF0CJ1ADgAZ3PioTFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOlfplx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOlfplx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EDD1F000E9;
	Tue, 21 Jul 2026 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648873;
	bh=dFcaDKhV2VnIX0IP+KIHw/f+F6Q3K0EDE3/DBctdOZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOlfplx8liBRzv3rO1zwfPWPJQYdftlD8ZM04D63wIjEtdbiVG2F1N6QeECxs+6UK
	 BTR0dhAhbcu0ujpn5cKjngdtUUvq7hVLdF+6njRDbrkLfhZdhZ6Tw3Gy320ixtfS97
	 MtPG8j8cKSTDwoFKRz/blxbZ8YEUlqE8TVkgsgtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0320/2077] cpufreq: governor: Fix data races on per-CPU idle/nice baselines
Date: Tue, 21 Jul 2026 16:59:53 +0200
Message-ID: <20260721152600.223751931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

[ Upstream commit 91f5d698478f3d07230cf9ca4dfaf67e0316a53d ]

gov_update_cpu_data() resets per-CPU prev_cpu_idle for every CPU in the
governed domain, and conditionally resets prev_cpu_nice when
ignore_nice_load is set. It is called from sysfs store callbacks
(e.g. ignore_nice_load_store) which run under attr_set->update_lock,
held by the surrounding governor_store().

Concurrently, dbs_work_handler() calls gov->gov_dbs_update() (which calls
dbs_update()) under policy_dbs->update_mutex. dbs_update() both reads and
writes the same prev_cpu_idle / prev_cpu_nice fields. The potential race
path is:

Path A (sysfs write, holds attr_set->update_lock only):

  governor_store()
    mutex_lock(&attr_set->update_lock)
    ignore_nice_load_store()
      dbs_data->ignore_nice_load = input
      gov_update_cpu_data(dbs_data)
        list_for_each_entry(policy_dbs, ...)
          for_each_cpu(j, ...)
            j_cdbs->prev_cpu_idle = get_cpu_idle_time(...)  /* write */
            j_cdbs->prev_cpu_nice = kcpustat_field(...)     /* write */
    mutex_unlock(&attr_set->update_lock)

Path B (work queue, holds policy_dbs->update_mutex only):

  dbs_work_handler()
    mutex_lock(&policy_dbs->update_mutex)
    gov->gov_dbs_update(policy)
      dbs_update()
        for_each_cpu(j, policy->cpus)
          idle_time = cur - j_cdbs->prev_cpu_idle           /* read  */
          j_cdbs->prev_cpu_idle = cur_idle_time             /* write */
          idle_time += cur_nice - j_cdbs->prev_cpu_nice     /* read  */
          j_cdbs->prev_cpu_nice = cur_nice                  /* write */
    mutex_unlock(&policy_dbs->update_mutex)

Because attr_set->update_lock and policy_dbs->update_mutex are two
completely independent locks, the two paths are not mutually exclusive.
This results in a data race on cpu_dbs_info.prev_cpu_idle and
cpu_dbs_info.prev_cpu_nice.

Fix this by also acquiring policy_dbs->update_mutex in
gov_update_cpu_data() for each policy, so that path A participates in
the mutual exclusion already established by dbs_work_handler(). Also
update the function comment to accurately reflect the two-level locking
contract.

Additionally, cpufreq_dbs_governor_start() initializes prev_cpu_idle
using io_busy read from dbs_data->io_is_busy without holding
policy_dbs->update_mutex.  A concurrent io_is_busy_store() can update
io_is_busy and call gov_update_cpu_data(), which writes prev_cpu_idle
with the new value under the mutex.  cpufreq_dbs_governor_start() then
overwrites prev_cpu_idle with the stale io_busy value, leaving the
baseline inconsistent with the tunable.  Fix this by reading io_busy
inside the mutex.

The root of this race dates back to the original ondemand/conservative
governors. Before commit ee88415caf73 ("[CPUFREQ] Cleanup locking in
conservative governor") and commit 5a75c82828e7 ("[CPUFREQ] Cleanup
locking in ondemand governor"), all accesses to prev_cpu_idle and
prev_cpu_nice in cpufreq_governor_dbs() (path X), store_ignore_nice_load()
/io_is_busy_store() (path Y), and do_dbs_timer() (path Z) were serialised
by the same dbs_mutex, so no race existed. Those two commits switched
do_dbs_timer() from dbs_mutex to a per-policy/per-cpu timer_mutex to
reduce lock contention, but left path Y (store) still holding dbs_mutex.
As a result, path Y (store) and path Z (do_dbs_timer) no longer shared a
common lock, introducing a potential race on prev_cpu_idle/prev_cpu_nice
between path Y (store) and dbs_check_cpu().

Commit 326c86deaed54a ("[CPUFREQ] Remove unneeded locks") then removed
dbs_mutex from store_ignore_nice_load()/io_is_busy_store() entirely,
introducing an additional potential race between path Y (now lockless)
and cpufreq_governor_dbs() (path X, still holding dbs_mutex), while the
race between path Y and path Z remained.

Fixes: ee88415caf736b ("[CPUFREQ] Cleanup locking in conservative governor")
Fixes: 5a75c82828e7c0 ("[CPUFREQ] Cleanup locking in ondemand governor")
Fixes: 326c86deaed54a ("[CPUFREQ] Remove unneeded locks")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/20260419132655.3800673-2-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_governor.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 86f35e45191423..fc6f705c5a9c70 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -90,7 +90,8 @@ EXPORT_SYMBOL_GPL(sampling_rate_store);
  * (that may be a single policy or a bunch of them if governor tunables are
  * system-wide).
  *
- * Call under the @dbs_data mutex.
+ * Call under the @dbs_data->attr_set.update_lock. The per-policy
+ * update_mutex is acquired and released internally for each policy.
  */
 void gov_update_cpu_data(struct dbs_data *dbs_data)
 {
@@ -99,6 +100,7 @@ void gov_update_cpu_data(struct dbs_data *dbs_data)
 	list_for_each_entry(policy_dbs, &dbs_data->attr_set.policy_list, list) {
 		unsigned int j;
 
+		mutex_lock(&policy_dbs->update_mutex);
 		for_each_cpu(j, policy_dbs->policy->cpus) {
 			struct cpu_dbs_info *j_cdbs = &per_cpu(cpu_dbs, j);
 
@@ -107,6 +109,7 @@ void gov_update_cpu_data(struct dbs_data *dbs_data)
 			if (dbs_data->ignore_nice_load)
 				j_cdbs->prev_cpu_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
 		}
+		mutex_unlock(&policy_dbs->update_mutex);
 	}
 }
 EXPORT_SYMBOL_GPL(gov_update_cpu_data);
@@ -527,8 +530,9 @@ int cpufreq_dbs_governor_start(struct cpufreq_policy *policy)
 
 	sampling_rate = dbs_data->sampling_rate;
 	ignore_nice = dbs_data->ignore_nice_load;
-	io_busy = dbs_data->io_is_busy;
 
+	mutex_lock(&policy_dbs->update_mutex);
+	io_busy = dbs_data->io_is_busy;
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info *j_cdbs = &per_cpu(cpu_dbs, j);
 
@@ -541,6 +545,7 @@ int cpufreq_dbs_governor_start(struct cpufreq_policy *policy)
 		if (ignore_nice)
 			j_cdbs->prev_cpu_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
 	}
+	mutex_unlock(&policy_dbs->update_mutex);
 
 	gov->start(policy);
 
-- 
2.53.0



