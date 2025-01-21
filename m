Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013011F5614;
	Tue, 21 Jan 2025 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483090; cv=none; b=o3VhgVXv098qdBdnS5LxFm9Octvjcv9sqMbuChByoztuuiWF0bH66eBc0ep83yw8b3tQhqJsjXhBfj87som2wvD9O0n2Fm3DVK3L223uQTLP3cVxkPg3HmqU4Nm57qGkWdd+onccHZIaQ/okPSSuutiZEVyyjyXIzcZeUyIfdiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483090; c=relaxed/simple;
	bh=3Ft9lBSBqNiFdhY0ZdKCtnti1dz1sy86eI8OvqVhJXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BywfqGZt0LLfz5cbqzhlxzKkvlT7UGk3O6ygZZEo78W5qvWqoeZAcEFULyz44ldL5N+wvwKLv0lt2tG/kqMQ5vJdVj8EBpe1wuYLkB9IhW3vLWxc/TI6KJLWfNQlCRTNOWJJ2ZjDLUUAjqa8fT9YsfFy3VpLL3fR/5SeY1idQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5Ov2YoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5Ov2YoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744FEC4CEE0;
	Tue, 21 Jan 2025 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483089;
	bh=3Ft9lBSBqNiFdhY0ZdKCtnti1dz1sy86eI8OvqVhJXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5Ov2YoKewdgo+t67m0h09cAGQQZ0cHZYurrbzRQjxjrscHHycL82jBvd9xz0vdx+
	 ufoQoGvctAdVyv5sOhbuzzBms85und0rajEk9zrEPpt/GGjoB2uVlQ2rpfg2S1HQ51
	 38IuCzdz0Vw8+Y76FKoX8d6P4YwHJDDEeNkzVlys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 113/127] hrtimers: Handle CPU state correctly on hotplug
Date: Tue, 21 Jan 2025 18:53:05 +0100
Message-ID: <20250121174534.004512885@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

commit 2f8dea1692eef2b7ba6a256246ed82c365fdc686 upstream.

Consider a scenario where a CPU transitions from CPUHP_ONLINE to halfway
through a CPU hotunplug down to CPUHP_HRTIMERS_PREPARE, and then back to
CPUHP_ONLINE:

Since hrtimers_prepare_cpu() does not run, cpu_base.hres_active remains set
to 1 throughout. However, during a CPU unplug operation, the tick and the
clockevents are shut down at CPUHP_AP_TICK_DYING. On return to the online
state, for instance CFS incorrectly assumes that the hrtick is already
active, and the chance of the clockevent device to transition to oneshot
mode is also lost forever for the CPU, unless it goes back to a lower state
than CPUHP_HRTIMERS_PREPARE once.

This round-trip reveals another issue; cpu_base.online is not set to 1
after the transition, which appears as a WARN_ON_ONCE in enqueue_hrtimer().

Aside of that, the bulk of the per CPU state is not reset either, which
means there are dangling pointers in the worst case.

Address this by adding a corresponding startup() callback, which resets the
stale per CPU state and sets the online flag.

[ tglx: Make the new callback unconditionally available, remove the online
  	modification in the prepare() callback and clear the remaining
  	state in the starting callback instead of the prepare callback ]

Fixes: 5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241220134421.3809834-1-koichiro.den@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h |    1 +
 kernel/cpu.c            |    2 +-
 kernel/time/hrtimer.c   |   11 ++++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -532,6 +532,7 @@ extern void __init hrtimers_init(void);
 extern void sysrq_timer_list_show(void);
 
 int hrtimers_prepare_cpu(unsigned int cpu);
+int hrtimers_cpu_starting(unsigned int cpu);
 #ifdef CONFIG_HOTPLUG_CPU
 int hrtimers_cpu_dying(unsigned int cpu);
 #else
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1766,7 +1766,7 @@ static struct cpuhp_step cpuhp_hp_states
 	},
 	[CPUHP_AP_HRTIMERS_DYING] = {
 		.name			= "hrtimers:dying",
-		.startup.single		= NULL,
+		.startup.single		= hrtimers_cpu_starting,
 		.teardown.single	= hrtimers_cpu_dying,
 	},
 
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2176,6 +2176,15 @@ int hrtimers_prepare_cpu(unsigned int cp
 	}
 
 	cpu_base->cpu = cpu;
+	hrtimer_cpu_base_init_expiry_lock(cpu_base);
+	return 0;
+}
+
+int hrtimers_cpu_starting(unsigned int cpu)
+{
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
+
+	/* Clear out any left over state from a CPU down operation */
 	cpu_base->active_bases = 0;
 	cpu_base->hres_active = 0;
 	cpu_base->hang_detected = 0;
@@ -2184,7 +2193,6 @@ int hrtimers_prepare_cpu(unsigned int cp
 	cpu_base->expires_next = KTIME_MAX;
 	cpu_base->softirq_expires_next = KTIME_MAX;
 	cpu_base->online = 1;
-	hrtimer_cpu_base_init_expiry_lock(cpu_base);
 	return 0;
 }
 
@@ -2262,6 +2270,7 @@ int hrtimers_cpu_dying(unsigned int dyin
 void __init hrtimers_init(void)
 {
 	hrtimers_prepare_cpu(smp_processor_id());
+	hrtimers_cpu_starting(smp_processor_id());
 	open_softirq(HRTIMER_SOFTIRQ, hrtimer_run_softirq);
 }
 


