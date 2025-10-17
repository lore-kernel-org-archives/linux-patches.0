Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81743328EA;
	Fri, 17 Oct 2025 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715518; cv=none; b=PU8KfpOGeM1VSbawpB9B7+IeBejnQYH7jJJCXRKeWBVjNnGgOhaSBNtTEzk/GP3iUxXRxE/85iF33ypYSihcyp5RRZNsQhUh+tVNzlvMbiDpAK5I0BbkPdmAZuOMWlt3QiShhXGXJhPAveeHXKw57YmOh5nSJP7AFDmk656PlSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715518; c=relaxed/simple;
	bh=ouaEqCDwMMj6teC84ThAPmd5HMKz2FeDb+ab2Yk+Bkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaOTgRhv6yFlYulsbkh+LAe0xuwvMHU5OZIbN5jRMUFdj3n+g6yHIidwvHq27u22KjLE64Zo31ceqIvAC06XZhj92Y1THU9xbxXkBdL8UFN7tSMWGjpuKB17uGWtR68qZpZnn8wW2ZVgWtT7Wf06kDpft042weBP8ESjB6ZVb1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoAaUJmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoAaUJmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C71FC4CEE7;
	Fri, 17 Oct 2025 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715518;
	bh=ouaEqCDwMMj6teC84ThAPmd5HMKz2FeDb+ab2Yk+Bkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoAaUJmYxXh3h0t2hk+QjrbqV8lG2efsB6DoWM+fOGPiP/PrjIOLVVmuh2Lw+OJV9
	 1Ztbh1zEaZqSiimMbIrs94j/h55pHkCrc01JV7OnBRY6DYyQ39tcycLPUX86yYf7HI
	 zjm5QGyptmEFgc2+piycUdvc1PrYpZGf+8TnZpW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Crudup <kenneth.crudup@gmail.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 245/371] PM: EM: Fix late boot with holes in CPU topology
Date: Fri, 17 Oct 2025 16:53:40 +0200
Message-ID: <20251017145210.942982380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 1ebe8f7e782523e62cd1fa8237f7afba5d1dae83 upstream.

Commit e3f1164fc9ee ("PM: EM: Support late CPUs booting and capacity
adjustment") added a mechanism to handle CPUs that come up late by
retrying when any of the `cpufreq_cpu_get()` call fails.

However, if there are holes in the CPU topology (offline CPUs, e.g.
nosmt), the first missing CPU causes the loop to break, preventing
subsequent online CPUs from being updated.

Instead of aborting on the first missing CPU policy, loop through all
and retry if any were missing.

Fixes: e3f1164fc9ee ("PM: EM: Support late CPUs booting and capacity adjustment")
Suggested-by: Kenneth Crudup <kenneth.crudup@gmail.com>
Reported-by: Kenneth Crudup <kenneth.crudup@gmail.com>
Link: https://lore.kernel.org/linux-pm/40212796-734c-4140-8a85-854f72b8144d@panix.com/
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20250831214357.2020076-1-christian.loehle@arm.com
[ rjw: Drop the new pr_debug() message which is not very useful ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/energy_model.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -799,7 +799,7 @@ void em_adjust_cpu_capacity(unsigned int
 static void em_check_capacity_update(void)
 {
 	cpumask_var_t cpu_done_mask;
-	int cpu;
+	int cpu, failed_cpus = 0;
 
 	if (!zalloc_cpumask_var(&cpu_done_mask, GFP_KERNEL)) {
 		pr_warn("no free memory\n");
@@ -817,10 +817,8 @@ static void em_check_capacity_update(voi
 
 		policy = cpufreq_cpu_get(cpu);
 		if (!policy) {
-			pr_debug("Accessing cpu%d policy failed\n", cpu);
-			schedule_delayed_work(&em_update_work,
-					      msecs_to_jiffies(1000));
-			break;
+			failed_cpus++;
+			continue;
 		}
 		cpufreq_cpu_put(policy);
 
@@ -835,6 +833,9 @@ static void em_check_capacity_update(voi
 		em_adjust_new_capacity(cpu, dev, pd);
 	}
 
+	if (failed_cpus)
+		schedule_delayed_work(&em_update_work, msecs_to_jiffies(1000));
+
 	free_cpumask_var(cpu_done_mask);
 }
 


