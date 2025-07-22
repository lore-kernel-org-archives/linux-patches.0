Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A092E4271;
	Tue, 22 Jul 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192355; cv=none; b=ki1JySSF/Yki8CgAy4QjVkAf+EaXQ3YsjNGQgQdYqcL0DnH9gQNswD+5M1RoV8Gq4xCD63kvoz+kwnTvvUBC4A+s77EfwY1GGpesbSAkbPVnIxtP6JUmsrG6hzKJnCc16ro/8qWQnxO7iBQ2u4sUrdULnahvqxxHHsQ4gzTLlA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192355; c=relaxed/simple;
	bh=8g3oX75yP9w+5zv9Ja/1xw+LkzoKuS46JXk/iTpQXCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXObAKNyzBgnHdIpDmJMiT2lutkemuSmYl/Nu04BMkOwfVfTD11SCUe2B9sr6giugy5KkdZlK8IMtDePgiLTCW/pADv3zk4Cppcb/gqm4BPO1WRczn6lw2DmYO0Dv186TkoJa1AD6XGIItMwJeJdU9SVV0BuWjwEoBubuN7Os1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XL2YOG3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XL2YOG3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9703EC4CEEB;
	Tue, 22 Jul 2025 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192355;
	bh=8g3oX75yP9w+5zv9Ja/1xw+LkzoKuS46JXk/iTpQXCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XL2YOG3xSMzdJdvXo+nmsTHta9e/C5HrDpiotfiykYWwi7SC2FXAobcW/k6fQgp8z
	 56y828qYQqwWMCE8GTLiVSftntgCylNjPusScPuBK0o6wb8a65L7TdvFv8b69oe6N2
	 fS9NDD7vuV432VUZhvaZXMl4wtNvV2SVGwEH3h5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 042/111] pmdomain: governor: Consider CPU latency tolerance from pm_domain_cpu_gov
Date: Tue, 22 Jul 2025 15:44:17 +0200
Message-ID: <20250722134334.964271011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

commit 500ba33284416255b9a5b50ace24470b6fe77ea5 upstream.

pm_domain_cpu_gov is selecting a cluster idle state but does not consider
latency tolerance of child CPUs. This results in deeper cluster idle state
whose latency does not meet latency tolerance requirement.

Select deeper idle state only if global and device latency tolerance of all
child CPUs meet.

Test results on SM8750 with 300 usec PM-QoS on CPU0 which is less than
domain idle state entry (2150) + exit (1983) usec latency mentioned in
devicetree, demonstrate the issue.

	# echo 300 > /sys/devices/system/cpu/cpu0/power/pm_qos_resume_latency_us

Before: (Usage is incrementing)
======
	# cat /sys/kernel/debug/pm_genpd/power-domain-cluster0/idle_states
	State          Time Spent(ms) Usage      Rejected   Above      Below
	S0             29817          537        8          270        0

	# cat /sys/kernel/debug/pm_genpd/power-domain-cluster0/idle_states
	State          Time Spent(ms) Usage      Rejected   Above      Below
	S0             30348          542        8          271        0

After: (Usage is not incrementing due to latency tolerance)
======
	# cat /sys/kernel/debug/pm_genpd/power-domain-cluster0/idle_states
	State          Time Spent(ms) Usage      Rejected   Above      Below
	S0             39319          626        14         307        0

	# cat /sys/kernel/debug/pm_genpd/power-domain-cluster0/idle_states
	State          Time Spent(ms) Usage      Rejected   Above      Below
	S0             39319          626        14         307        0

Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Fixes: e94999688e3a ("PM / Domains: Add genpd governor for CPUs")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250709-pmdomain_qos-v2-1-976b12257899@oss.qualcomm.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/domain_governor.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/base/power/domain_governor.c
+++ b/drivers/base/power/domain_governor.c
@@ -8,6 +8,7 @@
 #include <linux/pm_domain.h>
 #include <linux/pm_qos.h>
 #include <linux/hrtimer.h>
+#include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/cpumask.h>
 #include <linux/ktime.h>
@@ -345,6 +346,8 @@ static bool cpu_power_down_ok(struct dev
 	struct cpuidle_device *dev;
 	ktime_t domain_wakeup, next_hrtimer;
 	ktime_t now = ktime_get();
+	struct device *cpu_dev;
+	s64 cpu_constraint, global_constraint;
 	s64 idle_duration_ns;
 	int cpu, i;
 
@@ -355,6 +358,7 @@ static bool cpu_power_down_ok(struct dev
 	if (!(genpd->flags & GENPD_FLAG_CPU_DOMAIN))
 		return true;
 
+	global_constraint = cpu_latency_qos_limit();
 	/*
 	 * Find the next wakeup for any of the online CPUs within the PM domain
 	 * and its subdomains. Note, we only need the genpd->cpus, as it already
@@ -368,8 +372,16 @@ static bool cpu_power_down_ok(struct dev
 			if (ktime_before(next_hrtimer, domain_wakeup))
 				domain_wakeup = next_hrtimer;
 		}
+
+		cpu_dev = get_cpu_device(cpu);
+		if (cpu_dev) {
+			cpu_constraint = dev_pm_qos_raw_resume_latency(cpu_dev);
+			if (cpu_constraint < global_constraint)
+				global_constraint = cpu_constraint;
+		}
 	}
 
+	global_constraint *= NSEC_PER_USEC;
 	/* The minimum idle duration is from now - until the next wakeup. */
 	idle_duration_ns = ktime_to_ns(ktime_sub(domain_wakeup, now));
 	if (idle_duration_ns <= 0)
@@ -385,8 +397,10 @@ static bool cpu_power_down_ok(struct dev
 	 */
 	i = genpd->state_idx;
 	do {
-		if (idle_duration_ns >= (genpd->states[i].residency_ns +
-		    genpd->states[i].power_off_latency_ns)) {
+		if ((idle_duration_ns >= (genpd->states[i].residency_ns +
+		    genpd->states[i].power_off_latency_ns)) &&
+		    (global_constraint >= (genpd->states[i].power_on_latency_ns +
+		    genpd->states[i].power_off_latency_ns))) {
 			genpd->state_idx = i;
 			return true;
 		}


