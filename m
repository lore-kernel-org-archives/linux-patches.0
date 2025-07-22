Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312572ECE9D;
	Tue, 22 Jul 2025 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193478; cv=none; b=gDXqR3J8X47KKPehOleBYAThAFXsmvC5q+S2aIBtRUGzHu9MmyZ+NMmXajZjybTGErVVFHbS0yBqJJaZ96rPvC8BIroOjgKilZIsbklDl79iFipkAsQt/l+b0Zw2eM+bCGJvWRLq2cPSfcjg6kV3G4LqCSQxG2xU+cxJm5Crlqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193478; c=relaxed/simple;
	bh=hV0CBgeIlme9LDCZJIULzEuUksXqkBx6fNhnPFQlzAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGyxVB/OONtwD5L8OZXE2mOnrwKjFBUBlhyqRcGPaOsgYso6xI72owqSRzogSbCcdQQ05HeQYCqKkBG3k44UTkmDKm3bIJ8R8vm0wnbaejY2mmHZgvzqBImOCgLeFATCubcZ1AsWbOFW7dOk+vqsY1B7iBJSzHUw4QCLFi/d1KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezkckw7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezkckw7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C808C4CEF1;
	Tue, 22 Jul 2025 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193478;
	bh=hV0CBgeIlme9LDCZJIULzEuUksXqkBx6fNhnPFQlzAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezkckw7ASvIF7Tt6Hj2D1vEG4MX3NRFnniPbQx8YgZ6Yspi/5/R+TXlvQSF/KzZt1
	 YxfRiRyJwWmThQ9mVyJxgWjpMm4r31ieaUj7qPiiseZolLi0bH7S1bT8c6iPTP2q/+
	 Ybs4YCBJ3C0if+LU7Is9l9Sa6G//pVgHqW0wl+gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 072/187] pmdomain: governor: Consider CPU latency tolerance from pm_domain_cpu_gov
Date: Tue, 22 Jul 2025 15:44:02 +0200
Message-ID: <20250722134348.415556898@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pmdomain/governor.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/governor.c
+++ b/drivers/pmdomain/governor.c
@@ -8,6 +8,7 @@
 #include <linux/pm_domain.h>
 #include <linux/pm_qos.h>
 #include <linux/hrtimer.h>
+#include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/cpumask.h>
 #include <linux/ktime.h>
@@ -349,6 +350,8 @@ static bool cpu_power_down_ok(struct dev
 	struct cpuidle_device *dev;
 	ktime_t domain_wakeup, next_hrtimer;
 	ktime_t now = ktime_get();
+	struct device *cpu_dev;
+	s64 cpu_constraint, global_constraint;
 	s64 idle_duration_ns;
 	int cpu, i;
 
@@ -359,6 +362,7 @@ static bool cpu_power_down_ok(struct dev
 	if (!(genpd->flags & GENPD_FLAG_CPU_DOMAIN))
 		return true;
 
+	global_constraint = cpu_latency_qos_limit();
 	/*
 	 * Find the next wakeup for any of the online CPUs within the PM domain
 	 * and its subdomains. Note, we only need the genpd->cpus, as it already
@@ -372,8 +376,16 @@ static bool cpu_power_down_ok(struct dev
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
@@ -389,8 +401,10 @@ static bool cpu_power_down_ok(struct dev
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


