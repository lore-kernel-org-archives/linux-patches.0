Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E411E6DCF;
	Thu, 30 Jan 2025 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246800; cv=none; b=TPgku2XPmRawWYRdFgaRZUoD2pUDis715DMye2b/SRr0UDSK15AQt4plixvkocNSY6cO3Sz3wfc2l7JFCS8y+ePIVnonP/pHTUdh7apvjhmkKOIwwWSfri2ydRsJyorJ8UthRwoUI1SWvRJcUAVnXQ+kswtlWM4UEcJQd+M6QcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246800; c=relaxed/simple;
	bh=rD0XmC/Dd3GmFwyWpClzvjZY8d0JG37p30F4F4HbWTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huAJnd0hOUEm/TDNalFmwP4IgNrcHIUgdXXqiNw9z4pHAzhtqrJLTq/D4fZ+Z8qXH8d7naC/pnqDPARG2aVYfvszpNiJKORg2bMPWzoaXA5FAfJmmcPrRmIIIAtgJN/9oxsIM50bCCOK8niBgh584ZbGlsL953XUjIA+72Ay5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN+0Nbla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN+0Nbla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE29C4CED2;
	Thu, 30 Jan 2025 14:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246800;
	bh=rD0XmC/Dd3GmFwyWpClzvjZY8d0JG37p30F4F4HbWTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN+0NblaOrqcauyckrXheMbJQ44ltQJlWsrm2azJoC+2kSNEMXcH7vxNnY8D+4wC3
	 REXN5gkiWTaNSN2tle0jMnyVu9HfS+j2hFhJWxD51E+UmMFzdatjUbk0djjFLbTpe0
	 qPv6mGoO6vkSe6H+FvlxONY9ReuhAiv5EoZGJCy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 71/91] hrtimers: Handle CPU state correctly on hotplug
Date: Thu, 30 Jan 2025 15:01:30 +0100
Message-ID: <20250130140136.534847352@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -527,6 +527,7 @@ extern void __init hrtimers_init(void);
 extern void sysrq_timer_list_show(void);
 
 int hrtimers_prepare_cpu(unsigned int cpu);
+int hrtimers_cpu_starting(unsigned int cpu);
 #ifdef CONFIG_HOTPLUG_CPU
 int hrtimers_cpu_dying(unsigned int cpu);
 #else
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1542,7 +1542,7 @@ static struct cpuhp_step cpuhp_hp_states
 	},
 	[CPUHP_AP_HRTIMERS_DYING] = {
 		.name			= "hrtimers:dying",
-		.startup.single		= NULL,
+		.startup.single		= hrtimers_cpu_starting,
 		.teardown.single	= hrtimers_cpu_dying,
 	},
 
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2065,6 +2065,15 @@ int hrtimers_prepare_cpu(unsigned int cp
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
@@ -2073,7 +2082,6 @@ int hrtimers_prepare_cpu(unsigned int cp
 	cpu_base->expires_next = KTIME_MAX;
 	cpu_base->softirq_expires_next = KTIME_MAX;
 	cpu_base->online = 1;
-	hrtimer_cpu_base_init_expiry_lock(cpu_base);
 	return 0;
 }
 
@@ -2151,6 +2159,7 @@ int hrtimers_cpu_dying(unsigned int dyin
 void __init hrtimers_init(void)
 {
 	hrtimers_prepare_cpu(smp_processor_id());
+	hrtimers_cpu_starting(smp_processor_id());
 	open_softirq(HRTIMER_SOFTIRQ, hrtimer_run_softirq);
 }
 


