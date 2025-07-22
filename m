Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F05A288C01;
	Tue, 22 Jul 2025 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192768; cv=none; b=RB4m3oDaRbHwlD7GqbWZ4os0SlK10uDq0t5+OU5WG9yfa4YnsS+rUSae2Kj/LkrEVBPKjFihmbEDZDwvKFAaTrpFZdU339XxFW3xKZqdg4YeBl0Ag+cNq6Cz2x6Ww2Xvo0/mCCWONy3/wDLWbWJ9RaEds5AvyPO+VF005KTwkvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192768; c=relaxed/simple;
	bh=jenrdlaf+U3X1iBhXnSf8ZP1uk5ZT+IbLx6fgJYdTIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIMbewWvqDSxxsPx0xdyuI6xWv02c518T6ayhFU/LExv8uxYvTGakosDSb/yOMkj3H73wJyYHt0nTDWnwNPCimVn+ePd64/wTfL92OXTQpr1Ac1kZfCQWTQw9NtD4k/VUhlRy5gHjxJo4NUy6QWacCA4DMGvXwAJ2yFAK1kGLsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCJcTuwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCJcTuwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2167EC4CEEB;
	Tue, 22 Jul 2025 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192768;
	bh=jenrdlaf+U3X1iBhXnSf8ZP1uk5ZT+IbLx6fgJYdTIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCJcTuwg37Gzw9Sxx2dkGaW13cFl7MDwAOeimboazSXGEVrqDlUlbcbf8cTEiBkp4
	 WwVYgZvWXbGLGONFnt4siiN7MnVqiZsi3db8PiXxUpIp4DSu0DWDHftLECIDm36jql
	 nJvPojfp+lfP+pkJ/J7766/s7ZzZM8CMHvte4yDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Kakarla <quic_rkakarla@quicinc.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 051/158] cpuidle: psci: Fix cpuhotplug routine with PREEMPT_RT=y
Date: Tue, 22 Jul 2025 15:43:55 +0200
Message-ID: <20250722134342.634626595@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Daniel Lezcano <daniel.lezcano@linaro.org>

commit 621a88dbfe9006c318a0cafbd12e677ccfe006e7 upstream.

Currently cpu hotplug with the PREEMPT_RT option set in the kernel is
not supported because the underlying generic power domain functions
used in the cpu hotplug callbacks are incompatible from a lock point
of view. This situation prevents the suspend to idle to reach the
deepest idle state for the "cluster" as identified in the
undermentioned commit.

Use the compatible ones when PREEMPT_RT is enabled and remove the
boolean disabling the hotplug callbacks with this option.

With this change the platform can reach the deepest idle state
allowing at suspend time to consume less power.

Tested-on Lenovo T14s with the following script:

echo 0 > /sys/devices/system/cpu/cpu3/online
BEFORE=$(cat /sys/kernel/debug/pm_genpd/power-domain-cpu-cluster0/idle_states | grep S0 | awk '{ print $3 }') ;
rtcwake -s 1 -m mem;
AFTER=$(cat /sys/kernel/debug/pm_genpd/power-domain-cpu-cluster0/idle_states | grep S0 | awk '{ print $3 }');
if [ $BEFORE -lt $AFTER ]; then
    echo "Test successful"
else
    echo "Test failed"
fi
echo 1 > /sys/devices/system/cpu/cpu3/online

Fixes: 1c4b2932bd62 ("cpuidle: psci: Enable the hierarchical topology for s2idle on PREEMPT_RT")
Cc: Raghavendra Kakarla <quic_rkakarla@quicinc.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250709154728.733920-1-daniel.lezcano@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle-psci.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/cpuidle/cpuidle-psci.c
+++ b/drivers/cpuidle/cpuidle-psci.c
@@ -38,7 +38,6 @@ struct psci_cpuidle_data {
 static DEFINE_PER_CPU_READ_MOSTLY(struct psci_cpuidle_data, psci_cpuidle_data);
 static DEFINE_PER_CPU(u32, domain_state);
 static bool psci_cpuidle_use_syscore;
-static bool psci_cpuidle_use_cpuhp;
 
 void psci_set_domain_state(u32 state)
 {
@@ -105,8 +104,12 @@ static int psci_idle_cpuhp_up(unsigned i
 {
 	struct device *pd_dev = __this_cpu_read(psci_cpuidle_data.dev);
 
-	if (pd_dev)
-		pm_runtime_get_sync(pd_dev);
+	if (pd_dev) {
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			pm_runtime_get_sync(pd_dev);
+		else
+			dev_pm_genpd_resume(pd_dev);
+	}
 
 	return 0;
 }
@@ -116,7 +119,11 @@ static int psci_idle_cpuhp_down(unsigned
 	struct device *pd_dev = __this_cpu_read(psci_cpuidle_data.dev);
 
 	if (pd_dev) {
-		pm_runtime_put_sync(pd_dev);
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			pm_runtime_put_sync(pd_dev);
+		else
+			dev_pm_genpd_suspend(pd_dev);
+
 		/* Clear domain state to start fresh at next online. */
 		psci_set_domain_state(0);
 	}
@@ -177,9 +184,6 @@ static void psci_idle_init_cpuhp(void)
 {
 	int err;
 
-	if (!psci_cpuidle_use_cpuhp)
-		return;
-
 	err = cpuhp_setup_state_nocalls(CPUHP_AP_CPU_PM_STARTING,
 					"cpuidle/psci:online",
 					psci_idle_cpuhp_up,
@@ -240,10 +244,8 @@ static int psci_dt_cpu_init_topology(str
 	 * s2ram and s2idle.
 	 */
 	drv->states[state_count - 1].enter_s2idle = psci_enter_s2idle_domain_idle_state;
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		drv->states[state_count - 1].enter = psci_enter_domain_idle_state;
-		psci_cpuidle_use_cpuhp = true;
-	}
 
 	return 0;
 }
@@ -320,7 +322,6 @@ static void psci_cpu_deinit_idle(int cpu
 
 	dt_idle_detach_cpu(data->dev);
 	psci_cpuidle_use_syscore = false;
-	psci_cpuidle_use_cpuhp = false;
 }
 
 static int psci_idle_init_cpu(struct device *dev, int cpu)


