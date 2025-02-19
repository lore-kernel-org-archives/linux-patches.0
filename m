Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7174B155753;
	Wed, 19 Feb 2025 08:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955254; cv=none; b=iEjyjiHorFwyi2H02FMSQo6vOrMBvWiJpce9vw0vfiWizleaF1ADBJxJ33152E1bYSuDDpH5WNb8v+1IqpykJufKYcU/clxVHHINMPKnTPl5KDdrybOqWCAwnoNUmI0YLQKL9Z2WRLEqG8STZD8VYluUJTe/y3RDBGeedBr9iCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955254; c=relaxed/simple;
	bh=/KLFXpyUP976cdrCi9yHF0N2BIUaiYEzcUqsUYlaJTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb59UtzGXle+bXGy3YeXKT9nTXzt1ZY2GADLsF2rtTVCyH8vjyKBC/a3+IF6LMvjtlmAHn5HeiuQZl//1UTUdzJTmpx3Cq49J650xCY1/DYE7bptMe0/SLS2qpmyfrsK55IEr88nFEb7urUSf92Gw9nk5NtB5VnccwPl3zwMwl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXPJvTWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXPJvTWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E342EC4CED1;
	Wed, 19 Feb 2025 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955254;
	bh=/KLFXpyUP976cdrCi9yHF0N2BIUaiYEzcUqsUYlaJTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXPJvTWre8qU+8NeKbwl2+FNA6Zur+PmRT4VunfNH2HSo872yMmxaFeuMBa2K6dJ7
	 euhpPba+rs8y2jj5BifyL7zo0SdUHaUHPo6eSGxhPjGEXPQcLSiXCO7LvE7k89dEu9
	 8AMtPUfA01WaTxfg8Lr7WOIUqzwZVGcdUg3gVUso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/230] cpufreq/amd-pstate: convert mutex use to guard()
Date: Wed, 19 Feb 2025 09:28:17 +0100
Message-ID: <20250219082608.745357792@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 6c093d5a5b73ec1caf1e706510ae6031af2f9d43 ]

Using scoped guard declaration will unlock mutexes automatically.

Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20241209185248.16301-5-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 3ace20038e19 ("cpufreq/amd-pstate: Fix cpufreq_policy ref counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 145a48fc49034..33777f5ab7d16 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -696,12 +696,12 @@ static int amd_pstate_set_boost(struct cpufreq_policy *policy, int state)
 		pr_err("Boost mode is not supported by this processor or SBIOS\n");
 		return -EOPNOTSUPP;
 	}
-	mutex_lock(&amd_pstate_driver_lock);
+	guard(mutex)(&amd_pstate_driver_lock);
+
 	ret = amd_pstate_cpu_boost_update(policy, state);
 	WRITE_ONCE(cpudata->boost_state, !ret ? state : false);
 	policy->boost_enabled = !ret ? state : false;
 	refresh_frequency_limits(policy);
-	mutex_unlock(&amd_pstate_driver_lock);
 
 	return ret;
 }
@@ -792,7 +792,8 @@ static void amd_pstate_update_limits(unsigned int cpu)
 	if (!amd_pstate_prefcore)
 		return;
 
-	mutex_lock(&amd_pstate_driver_lock);
+	guard(mutex)(&amd_pstate_driver_lock);
+
 	ret = amd_get_highest_perf(cpu, &cur_high);
 	if (ret)
 		goto free_cpufreq_put;
@@ -812,7 +813,6 @@ static void amd_pstate_update_limits(unsigned int cpu)
 	if (!highest_perf_changed)
 		cpufreq_update_policy(cpu);
 
-	mutex_unlock(&amd_pstate_driver_lock);
 }
 
 /*
@@ -1145,11 +1145,11 @@ static ssize_t store_energy_performance_preference(
 	if (ret < 0)
 		return -EINVAL;
 
-	mutex_lock(&amd_pstate_limits_lock);
+	guard(mutex)(&amd_pstate_limits_lock);
+
 	ret = amd_pstate_set_energy_pref_index(cpudata, ret);
-	mutex_unlock(&amd_pstate_limits_lock);
 
-	return ret ?: count;
+	return ret ? ret : count;
 }
 
 static ssize_t show_energy_performance_preference(
@@ -1297,13 +1297,10 @@ EXPORT_SYMBOL_GPL(amd_pstate_update_status);
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
-	ssize_t ret;
 
-	mutex_lock(&amd_pstate_driver_lock);
-	ret = amd_pstate_show_status(buf);
-	mutex_unlock(&amd_pstate_driver_lock);
+	guard(mutex)(&amd_pstate_driver_lock);
 
-	return ret;
+	return amd_pstate_show_status(buf);
 }
 
 static ssize_t status_store(struct device *a, struct device_attribute *b,
@@ -1312,9 +1309,8 @@ static ssize_t status_store(struct device *a, struct device_attribute *b,
 	char *p = memchr(buf, '\n', count);
 	int ret;
 
-	mutex_lock(&amd_pstate_driver_lock);
+	guard(mutex)(&amd_pstate_driver_lock);
 	ret = amd_pstate_update_status(buf, p ? p - buf : count);
-	mutex_unlock(&amd_pstate_driver_lock);
 
 	return ret < 0 ? ret : count;
 }
@@ -1614,13 +1610,11 @@ static int amd_pstate_epp_cpu_offline(struct cpufreq_policy *policy)
 
 	min_perf = READ_ONCE(cpudata->lowest_perf);
 
-	mutex_lock(&amd_pstate_limits_lock);
+	guard(mutex)(&amd_pstate_limits_lock);
 
 	amd_pstate_update_perf(cpudata, min_perf, 0, min_perf, false);
 	amd_pstate_set_epp(cpudata, AMD_CPPC_EPP_BALANCE_POWERSAVE);
 
-	mutex_unlock(&amd_pstate_limits_lock);
-
 	return 0;
 }
 
@@ -1656,13 +1650,11 @@ static int amd_pstate_epp_resume(struct cpufreq_policy *policy)
 	struct amd_cpudata *cpudata = policy->driver_data;
 
 	if (cpudata->suspended) {
-		mutex_lock(&amd_pstate_limits_lock);
+		guard(mutex)(&amd_pstate_limits_lock);
 
 		/* enable amd pstate from suspend state*/
 		amd_pstate_epp_reenable(cpudata);
 
-		mutex_unlock(&amd_pstate_limits_lock);
-
 		cpudata->suspended = false;
 	}
 
-- 
2.39.5



