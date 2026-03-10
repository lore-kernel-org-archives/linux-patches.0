Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3997389462;
	Tue, 10 Mar 2026 11:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142044; cv=none; b=uBQnXcBBjk+gdhWfRxGjL7iXUgrs+onkasZVBU8AlVzL93Y7z5A59Z4albLKzJXfrqsV3Zc8jjO1vDNzD+8xh1ZS4gWO8QwA/Dm5A2viCLBs7PIM+vjyjeaFaGy/sgIORcd8sOqD8Mc9NJkRb6Uh7G15SI7F6NZ+T9pgXYV+L8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142044; c=relaxed/simple;
	bh=ZDWTqD3x1dJWdFMkFKLQhVEm80OZj1Db4opMt6qB8NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6mfjk7GD/jyggLU4fc100ToG+Xgi1x1K/aNV6HyD+yHSlzlHmhAUphA69ED/PW82KiSaU7NhIrmm7WnzairgvJIaLI/ug6zFkkowpK9wufNOwaGTd1B6FhlGWvUZmnUQuj7peMAG58tweyzGjFloojknKn9zNVGYv6DzvhRJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvI06+Yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvI06+Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93ACC19423;
	Tue, 10 Mar 2026 11:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142044;
	bh=ZDWTqD3x1dJWdFMkFKLQhVEm80OZj1Db4opMt6qB8NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvI06+YnTAlxncV/cGS7KflYJ6+HOoZvEWQ8w/UncfvSez5WH16mG2KI2hXFQoVUh
	 M2kC727vgjX6Iz9nmDEhs0v5+CwyZi+JOwtMfGNoQ382EF56OcJmD99VPryocl3if7
	 3IIqL+pQ5IKCN1UwbEercTX0B7AHmulc1Urwwx81r1373LM/XKubN2c8flcNzaYB8s
	 0pl16+56gxuyxHmBygkPvvwYzm4NxuSpeBEKW2uGpogNID12shL7ZvEWD7y+2xKInP
	 G75am6mTEUEyfAl5o26d03SIesWyOGyN6OJlU7aZbcnb48PQzhbIyIcOGGFdh0Tf46
	 rGMy2F8kApwvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 172/314] cpufreq: intel_pstate: Fix crash during turbo disable
Date: Tue, 10 Mar 2026 07:17:11 -0400
Message-ID: <018d7d288fd854010eb63585c8b36041eb081c02.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 6b050482ec40569429d963ac52afa878691b04c9 upstream.

When the system is booted with kernel command line argument "nosmt" or
"maxcpus" to limit the number of CPUs, disabling turbo via:

 echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

results in a crash:

 PF: supervisor read access in kernel mode
 PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP PTI
 ...
 RIP: 0010:store_no_turbo+0x100/0x1f0
 ...

This occurs because for_each_possible_cpu() returns CPUs even if they
are not online. For those CPUs, all_cpu_data[] will be NULL. Since
commit 973207ae3d7c ("cpufreq: intel_pstate: Rearrange max frequency
updates handling code"), all_cpu_data[] is dereferenced even for CPUs
which are not online, causing the NULL pointer dereference.

To fix that, pass CPU number to intel_pstate_update_max_freq() and use
all_cpu_data[] for those CPUs for which there is a valid cpufreq policy.

Fixes: 973207ae3d7c ("cpufreq: intel_pstate: Rearrange max frequency updates handling code")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221068
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Link: https://patch.msgid.link/20260225001752.890164-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 38333f7da40db..00b87f8ee70bc 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1467,13 +1467,13 @@ static void __intel_pstate_update_max_freq(struct cpufreq_policy *policy,
 	refresh_frequency_limits(policy);
 }
 
-static bool intel_pstate_update_max_freq(struct cpudata *cpudata)
+static bool intel_pstate_update_max_freq(int cpu)
 {
-	struct cpufreq_policy *policy __free(put_cpufreq_policy) = cpufreq_cpu_get(cpudata->cpu);
+	struct cpufreq_policy *policy __free(put_cpufreq_policy) = cpufreq_cpu_get(cpu);
 	if (!policy)
 		return false;
 
-	__intel_pstate_update_max_freq(policy, cpudata);
+	__intel_pstate_update_max_freq(policy, all_cpu_data[cpu]);
 
 	return true;
 }
@@ -1492,7 +1492,7 @@ static void intel_pstate_update_limits_for_all(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		intel_pstate_update_max_freq(all_cpu_data[cpu]);
+		intel_pstate_update_max_freq(cpu);
 
 	mutex_lock(&hybrid_capacity_lock);
 
@@ -1932,7 +1932,7 @@ static void intel_pstate_notify_work(struct work_struct *work)
 	struct cpudata *cpudata =
 		container_of(to_delayed_work(work), struct cpudata, hwp_notify_work);
 
-	if (intel_pstate_update_max_freq(cpudata)) {
+	if (intel_pstate_update_max_freq(cpudata->cpu)) {
 		/*
 		 * The driver will not be unregistered while this function is
 		 * running, so update the capacity without acquiring the driver
-- 
2.51.0

