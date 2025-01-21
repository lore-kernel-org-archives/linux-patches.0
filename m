Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA3AE571;
	Tue, 21 Jan 2025 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482522; cv=none; b=Vm/G0AA2R0rs4ylHyscRfRdXhaFHAjSPh01MCcdPNzDswC8C/DtG5CbpZcL77NUKDRxYP4b4QtDq0Ynr+TXN+wxe4axlcSxDst3ywTt5KMvQIa1ydX4yEB4em9eS8Bg8jfqVvu0MQXucnrYWIWDrXPPFWw2PUtjalR2MxIYlJ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482522; c=relaxed/simple;
	bh=2P/HjZrHK3YPmmqIl5o+WqF+6RizUSlMd5ktSeAoxn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sjyb8HoXnlU+gHz4DcToM7/XBkliJBt8o5kyw8Qx7Mv+hONoItAhoBWbc/MNPbLAdQJzMhD2E4wzQ7K+01rM5utcEGEaJVPEGXuMadOIyK5Wg8TdINKD+G0hr7rpcfcdcj05o61uhxFLo1yQEGZIf3LA5bQQw+uGd6U9XjPcBGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRfN3SDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRfN3SDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61A4C4CEDF;
	Tue, 21 Jan 2025 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482522;
	bh=2P/HjZrHK3YPmmqIl5o+WqF+6RizUSlMd5ktSeAoxn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRfN3SDsOQIs+TMuMemum2GtXBJk0oGEw+OeRa0XUEBc4Kklgy7lhD4bAu6j6a7gS
	 e/97S37WiiSbBw2InPBS7lDqDdEjsnikF/jgNDGNhZc4zR0I+z9rqvHybyOUmRXKl2
	 JjqSg1aLZFniZm0ZlcuyzpsC0P9qFmbC0gEUohdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 106/122] hrtimers: Handle CPU state correctly on hotplug
Date: Tue, 21 Jan 2025 18:52:34 +0100
Message-ID: <20250121174537.126406386@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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
@@ -379,6 +379,7 @@ extern void __init hrtimers_init(void);
 extern void sysrq_timer_list_show(void);
 
 int hrtimers_prepare_cpu(unsigned int cpu);
+int hrtimers_cpu_starting(unsigned int cpu);
 #ifdef CONFIG_HOTPLUG_CPU
 int hrtimers_cpu_dying(unsigned int cpu);
 #else
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2179,7 +2179,7 @@ static struct cpuhp_step cpuhp_hp_states
 	},
 	[CPUHP_AP_HRTIMERS_DYING] = {
 		.name			= "hrtimers:dying",
-		.startup.single		= NULL,
+		.startup.single		= hrtimers_cpu_starting,
 		.teardown.single	= hrtimers_cpu_dying,
 	},
 	[CPUHP_AP_TICK_DYING] = {
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2156,6 +2156,15 @@ int hrtimers_prepare_cpu(unsigned int cp
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
@@ -2164,7 +2173,6 @@ int hrtimers_prepare_cpu(unsigned int cp
 	cpu_base->expires_next = KTIME_MAX;
 	cpu_base->softirq_expires_next = KTIME_MAX;
 	cpu_base->online = 1;
-	hrtimer_cpu_base_init_expiry_lock(cpu_base);
 	return 0;
 }
 
@@ -2240,6 +2248,7 @@ int hrtimers_cpu_dying(unsigned int dyin
 void __init hrtimers_init(void)
 {
 	hrtimers_prepare_cpu(smp_processor_id());
+	hrtimers_cpu_starting(smp_processor_id());
 	open_softirq(HRTIMER_SOFTIRQ, hrtimer_run_softirq);
 }
 


