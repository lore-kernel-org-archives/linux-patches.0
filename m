Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274C1FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DE1C433EF;
	Thu,  1 Jun 2023 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626022;
	bh=osR7rBX8ufijqtFI3rPO0uTo4VmPXjXtgMGpM3n7/LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4S7RyTj/r8cvYGBHLVTymj3DOlTgpgraV+66h2MWtjtfEAy8lm2IYHse8nV28xTg
	 vCRmjjYswh6KEjApk+nnDmGtgvo9USJl8klNua+75Y/5vFKtmu05+/oz/CTikMG2fx
	 USieQg/wfUDzmxcjVgRgyx7HCAA9iBTatgWs+Hgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Wyes Karny <wyes.karny@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.3 44/45] cpufreq: amd-pstate: Add ->fast_switch() callback
Date: Thu,  1 Jun 2023 14:21:40 +0100
Message-Id: <20230601131940.731365582@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

commit 4badf2eb1e986bdbf34dd2f5d4c979553a86fe54 upstream.

Schedutil normally calls the adjust_perf callback for drivers with
adjust_perf callback available and fast_switch_possible flag set.
However, when frequency invariance is disabled and schedutil tries to
invoke fast_switch. So, there is a chance of kernel crash if this
function pointer is not set. To protect against this scenario add
fast_switch callback to amd_pstate driver.

Fixes: 1d215f0319c2 ("cpufreq: amd-pstate: Add fast switch function for AMD P-State")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -422,9 +422,8 @@ static int amd_pstate_verify(struct cpuf
 	return 0;
 }
 
-static int amd_pstate_target(struct cpufreq_policy *policy,
-			     unsigned int target_freq,
-			     unsigned int relation)
+static int amd_pstate_update_freq(struct cpufreq_policy *policy,
+				  unsigned int target_freq, bool fast_switch)
 {
 	struct cpufreq_freqs freqs;
 	struct amd_cpudata *cpudata = policy->driver_data;
@@ -443,14 +442,36 @@ static int amd_pstate_target(struct cpuf
 	des_perf = DIV_ROUND_CLOSEST(target_freq * cap_perf,
 				     cpudata->max_freq);
 
-	cpufreq_freq_transition_begin(policy, &freqs);
-	amd_pstate_update(cpudata, min_perf, des_perf,
-			  max_perf, false);
-	cpufreq_freq_transition_end(policy, &freqs, false);
+	WARN_ON(fast_switch && !policy->fast_switch_enabled);
+	/*
+	 * If fast_switch is desired, then there aren't any registered
+	 * transition notifiers. See comment for
+	 * cpufreq_enable_fast_switch().
+	 */
+	if (!fast_switch)
+		cpufreq_freq_transition_begin(policy, &freqs);
+
+	amd_pstate_update(cpudata, min_perf, des_perf, max_perf, fast_switch);
+
+	if (!fast_switch)
+		cpufreq_freq_transition_end(policy, &freqs, false);
 
 	return 0;
 }
 
+static int amd_pstate_target(struct cpufreq_policy *policy,
+			     unsigned int target_freq,
+			     unsigned int relation)
+{
+	return amd_pstate_update_freq(policy, target_freq, false);
+}
+
+static unsigned int amd_pstate_fast_switch(struct cpufreq_policy *policy,
+				  unsigned int target_freq)
+{
+	return amd_pstate_update_freq(policy, target_freq, true);
+}
+
 static void amd_pstate_adjust_perf(unsigned int cpu,
 				   unsigned long _min_perf,
 				   unsigned long target_perf,
@@ -698,6 +719,7 @@ static int amd_pstate_cpu_exit(struct cp
 
 	freq_qos_remove_request(&cpudata->req[1]);
 	freq_qos_remove_request(&cpudata->req[0]);
+	policy->fast_switch_possible = false;
 	kfree(cpudata);
 
 	return 0;
@@ -1230,6 +1252,7 @@ static struct cpufreq_driver amd_pstate_
 	.flags		= CPUFREQ_CONST_LOOPS | CPUFREQ_NEED_UPDATE_LIMITS,
 	.verify		= amd_pstate_verify,
 	.target		= amd_pstate_target,
+	.fast_switch    = amd_pstate_fast_switch,
 	.init		= amd_pstate_cpu_init,
 	.exit		= amd_pstate_cpu_exit,
 	.suspend	= amd_pstate_cpu_suspend,


