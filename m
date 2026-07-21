Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F1446C4A5;
	Tue, 21 Jul 2026 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648877; cv=none; b=OIbUrJ23Epu7Z4sVz0vHh58YsP36fhdmNeBP+xMiCbVmY0bLdfWlyl/yZBbb5aV7X78RrXYgYqxk1SaPsE3fTYZn/iGqIPIDB6/O0TTq4y4e8aCAycXVf9kEsn8DZmls8aZPZ96sRjOPy8tOi2JF+OUUeub/M8CP39aEmIbYTzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648877; c=relaxed/simple;
	bh=5/IiGzuO7GDXdgIkca4LMZdCTEKHjsiWVjHxLli4BMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lynotzxq9JSyh/PwGQ2dxXJMvfA0v4LKXz9pHzRxLbBuUXMxzvJtECjUGuufecKwiOUhxyOy4JPyv0yjLWlE1fZOXTrxU/xw20SNMCAVAe/B+7o+tT2lGZzxEjm+FHFeQg4T+1CuEPDl6tTLH8V7nzw9OzhGqpNT+lm9aMp9q08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGJhDpvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGJhDpvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2A1F00A3A;
	Tue, 21 Jul 2026 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648876;
	bh=oSKluRSIXopEWHMz8MASyw3FGYNKGxQkVfUZspKhmq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGJhDpvbgk9BkVXCLrktm64gbqUyLHpgsmXHM+nX41j+12tRX6fnJIRhJ+1qHUVvr
	 /7hL/I4WtRCt8w+5JG0F2hbRgnO5BAD07Ui5ZCQSHJV9bJKApuHHVZcAX2sVIa7xSA
	 xHr7Pd1rCU/2ZheH3pe2/n+eqZuSPuRF3CVP5v00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0321/2077] cpufreq: governor: Fix stale prev_cpu_nice spike when enabling ignore_nice_load
Date: Tue, 21 Jul 2026 16:59:54 +0200
Message-ID: <20260721152600.248627043@linuxfoundation.org>
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

[ Upstream commit 24fc5870808dea4290e9563746cb5f2146043c6c ]

When ignore_nice_load is toggled from 0 to 1 via sysfs, dbs_update() may
run concurrently and observe the new tunable value while prev_cpu_nice
still holds a stale baseline, producing a spurious massive idle_time that
results in an incorrect CPU load value.

The race can be illustrated with two concurrent paths:

Path A (sysfs write, holds attr_set->update_lock):

governor_store()
  mutex_lock(&attr_set->update_lock)
  ignore_nice_load_store()
    dbs_data->ignore_nice_load = 1              /* (A1) */
    gov_update_cpu_data(dbs_data)
      mutex_lock(&policy_dbs->update_mutex)     /* (A2) */
        j_cdbs->prev_cpu_nice = kcpustat_field(...)
      mutex_unlock(&policy_dbs->update_mutex)
  mutex_unlock(&attr_set->update_lock)

Path B (work queue, wins the race between A1 and A2):

dbs_work_handler()
  mutex_lock(&policy_dbs->update_mutex)         /* acquired before A2 */
  dbs_update()
    ignore_nice = dbs_data->ignore_nice_load    /* sees new value: 1 */
    cur_nice = kcpustat_field(...)
    idle_time += div_u64(cur_nice - j_cdbs->prev_cpu_nice, ..) /* stale */
    j_cdbs->prev_cpu_nice = cur_nice
  mutex_unlock(&policy_dbs->update_mutex)

Fix this by unconditionally sampling cur_nice and advancing prev_cpu_nice
in dbs_update() on every call, regardless of ignore_nice. With
prev_cpu_nice always reflecting the most recent sample, enabling
ignore_nice_load can never produce a stale-baseline spike: the delta will
always be the nice time accumulated in the last sampling interval, not
since boot. The additional kcpustat_field() call per CPU per sample is
negligible given that the sampling path already reads idle and load
accounting.

To keep prev_cpu_nice handling consistent with the always-tracking
semantics introduced above:

  - gov_update_cpu_data() unconditionally resets prev_cpu_nice alongside
    prev_cpu_idle, so both baselines share the same timestamp when
    io_is_busy changes.  This prevents an interval mismatch between
    idle_time and nice_delta on the next dbs_update() when
    ignore_nice_load is enabled.
  - cpufreq_dbs_governor_start() unconditionally initializes prev_cpu_nice
    so the baseline is always valid from the first dbs_update() call;
    remove the ignore_nice guard and the now-unused ignore_nice variable.

Fixes: ee88415caf736b ("[CPUFREQ] Cleanup locking in conservative governor")
Fixes: 5a75c82828e7c0 ("[CPUFREQ] Cleanup locking in ondemand governor")
Fixes: 326c86deaed54a ("[CPUFREQ] Remove unneeded locks")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/20260419132655.3800673-3-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_governor.c | 33 +++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index fc6f705c5a9c70..8a85bd32defe7a 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -92,6 +92,12 @@ EXPORT_SYMBOL_GPL(sampling_rate_store);
  *
  * Call under the @dbs_data->attr_set.update_lock. The per-policy
  * update_mutex is acquired and released internally for each policy.
+ *
+ * Note: prev_cpu_nice is reset here unconditionally alongside prev_cpu_idle.
+ * When io_is_busy changes, both baselines must be advanced to the same
+ * timestamp so that the next dbs_update() computes idle_time and nice_delta
+ * over the same interval, preventing an artificially inflated idle_time when
+ * ignore_nice_load is enabled.
  */
 void gov_update_cpu_data(struct dbs_data *dbs_data)
 {
@@ -106,8 +112,7 @@ void gov_update_cpu_data(struct dbs_data *dbs_data)
 
 			j_cdbs->prev_cpu_idle = get_cpu_idle_time(j, &j_cdbs->prev_update_time,
 								  dbs_data->io_is_busy);
-			if (dbs_data->ignore_nice_load)
-				j_cdbs->prev_cpu_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
+			j_cdbs->prev_cpu_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
 		}
 		mutex_unlock(&policy_dbs->update_mutex);
 	}
@@ -121,6 +126,7 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 	unsigned int ignore_nice = dbs_data->ignore_nice_load;
 	unsigned int max_load = 0, idle_periods = UINT_MAX;
 	unsigned int sampling_rate, io_busy, j;
+	u64 cur_nice;
 
 	/*
 	 * Sometimes governors may use an additional multiplier to increase
@@ -167,12 +173,18 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 
 		j_cdbs->prev_cpu_idle = cur_idle_time;
 
-		if (ignore_nice) {
-			u64 cur_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
-
+		/*
+		 * Always sample cur_nice and advance prev_cpu_nice, regardless
+		 * of ignore_nice.  This keeps prev_cpu_nice current so that
+		 * enabling ignore_nice_load via sysfs never produces a
+		 * stale-baseline spike (the delta will be at most one sampling
+		 * interval of accumulated nice time, not since boot).
+		 */
+		cur_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
+		if (ignore_nice)
 			idle_time += div_u64(cur_nice - j_cdbs->prev_cpu_nice, NSEC_PER_USEC);
-			j_cdbs->prev_cpu_nice = cur_nice;
-		}
+
+		j_cdbs->prev_cpu_nice = cur_nice;
 
 		if (unlikely(!time_elapsed)) {
 			/*
@@ -519,7 +531,7 @@ int cpufreq_dbs_governor_start(struct cpufreq_policy *policy)
 	struct dbs_governor *gov = dbs_governor_of(policy);
 	struct policy_dbs_info *policy_dbs = policy->governor_data;
 	struct dbs_data *dbs_data = policy_dbs->dbs_data;
-	unsigned int sampling_rate, ignore_nice, j;
+	unsigned int sampling_rate, j;
 	unsigned int io_busy;
 
 	if (!policy->cur)
@@ -529,7 +541,6 @@ int cpufreq_dbs_governor_start(struct cpufreq_policy *policy)
 	policy_dbs->rate_mult = 1;
 
 	sampling_rate = dbs_data->sampling_rate;
-	ignore_nice = dbs_data->ignore_nice_load;
 
 	mutex_lock(&policy_dbs->update_mutex);
 	io_busy = dbs_data->io_is_busy;
@@ -541,9 +552,7 @@ int cpufreq_dbs_governor_start(struct cpufreq_policy *policy)
 		 * Make the first invocation of dbs_update() compute the load.
 		 */
 		j_cdbs->prev_load = 0;
-
-		if (ignore_nice)
-			j_cdbs->prev_cpu_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
+		j_cdbs->prev_cpu_nice = kcpustat_field(&kcpustat_cpu(j), CPUTIME_NICE, j);
 	}
 	mutex_unlock(&policy_dbs->update_mutex);
 
-- 
2.53.0



