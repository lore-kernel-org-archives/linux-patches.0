Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5823135AC23;
	Tue, 10 Mar 2026 11:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141140; cv=none; b=LHvZdv7x0xlCIg46SKxlu6SjGmEqspZzRgf/IZU6YZsaTw7ZhuAV9oS/91HPmEOnRhLnWrNYLUfyL9s307RZtTBQyJXPu8seSmgSca2JddOFl3QV7vkinwEevVrb9bMnjBpydmKh34Y9KwA8K/0q5crweyFT0JU/MFwahvJASLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141140; c=relaxed/simple;
	bh=s38zKs7aIdTeeI34cq8xnsqCV0OfzElDTsh+qo586wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7zTbgVxoABLkt0ixSdYPH36q/owl8NVZ/LcfNUDkYNB9uDFTfZHbrekCLHV3WEvD6Cz6bX1cWpLYWyfoMCibRmsWZ8GxfOIx0caL09Q8RrcGRUxstHp31nRSE11dUg4D3YRBZiZoAV9dg2hTs8vIGtUP93WhcNz/fGILteJmWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZULZ9wtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZULZ9wtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFB6C2BC86;
	Tue, 10 Mar 2026 11:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141140;
	bh=s38zKs7aIdTeeI34cq8xnsqCV0OfzElDTsh+qo586wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZULZ9wtLytoft8O7mRiGLwv8B1RVM7f/pZOzFWSd7t7n8KUnbdmV74ToiliK4uuck
	 psMwLltGlvCi+EjsX5cAI/KbGcfcTL8EifgiZdYMfESBhyTNZjjggaAuzWD+HraMtF
	 pzRiE9AaYbZmKIjOGP6qGOlfajEoDUf6GIKv6c7dh8BOl2PBIzd9/GKYufAd7XFCs8
	 8TPDa4DdVVWsMKuM9IWOUfD808L8uqcxgr4mM0r5bEGQehQwAp1M5GPo2L9K7ZfUG0
	 sSg2NG4eg5PqqtJl5HqpxjZ7O+arqBKm8Qgt5Cl1xRmUikikLPq6nQSRSrWZsk0NO9
	 HBGatCYw/8S1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 144/311] cpufreq: intel_pstate: Fix crash during turbo disable
Date: Tue, 10 Mar 2026 07:03:11 -0400
Message-ID: <242867afb662651b0c9f19acfafe57948eaf724c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 1625ec2d0d06a..ec8308629432b 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1476,13 +1476,13 @@ static void __intel_pstate_update_max_freq(struct cpufreq_policy *policy,
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
@@ -1501,7 +1501,7 @@ static void intel_pstate_update_limits_for_all(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		intel_pstate_update_max_freq(all_cpu_data[cpu]);
+		intel_pstate_update_max_freq(cpu);
 
 	mutex_lock(&hybrid_capacity_lock);
 
@@ -1908,7 +1908,7 @@ static void intel_pstate_notify_work(struct work_struct *work)
 	struct cpudata *cpudata =
 		container_of(to_delayed_work(work), struct cpudata, hwp_notify_work);
 
-	if (intel_pstate_update_max_freq(cpudata)) {
+	if (intel_pstate_update_max_freq(cpudata->cpu)) {
 		/*
 		 * The driver will not be unregistered while this function is
 		 * running, so update the capacity without acquiring the driver
-- 
2.51.0

