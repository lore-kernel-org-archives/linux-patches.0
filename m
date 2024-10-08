Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB581DFD1;
	Tue,  8 Oct 2024 13:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392732; cv=none; b=DSwcigP3lrMVczd5XHDh97llOkbTmQe2EJUB0PdQnrPYhWxS9EhPl3MTaw65hUcLxY8SowRejMv2LZlqWr9IJ+y/bvmEVs7o+imDZvP4/4e44BsIo5r+Dpt4EDdNd+r9+wAZuUSEDWTGu39jl/CYrgyUJkbpK/aznOXOFu1Cu3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392732; c=relaxed/simple;
	bh=RkVKPy7bFq31O6cjfaA9UEBuMw2ASko3f6P3MYYL6nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hK//3+cnDAkNghBV46kGNI5Cgi69Pfmurce+6/rbd+Y8iRLdb0BisqNCyVnRHPgYe3/jqm0p4HTeBb/jnQX6JGaxYfQOqvvh5XTK/6hy4UfKBopTF2s5C7k+UzY2H5PwOTUNXlYf66qD4r3KbeMteUEDjNN0acjU4YdZ+VvwCKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqAqWzn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqAqWzn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28ADC4CECC;
	Tue,  8 Oct 2024 13:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392732;
	bh=RkVKPy7bFq31O6cjfaA9UEBuMw2ASko3f6P3MYYL6nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqAqWzn2WxkY6Kz8W+cd+iVHfgqPFWoaoW15Eb+Sm95JLE/px2lCwXDpYSrKvKNat
	 k5xxj5aqbeAaMXHX9I7gKLRdBiwWTo7ilZpuiuIfqYHpMuyhbQQZgSqJjHmnJeqJQv
	 q5JUfjpRf6448z6bLBU20atCNRc/VH0LQC4qrsNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiao sheng wen <atzlinux@sina.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 502/558] cpufreq: intel_pstate: Make hwp_notify_lock a raw spinlock
Date: Tue,  8 Oct 2024 14:08:52 +0200
Message-ID: <20241008115721.985655690@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <ukleinek@debian.org>

commit 8b4865cd904650cbed7f2407e653934c621b8127 upstream.

notify_hwp_interrupt() is called via sysvec_thermal() ->
smp_thermal_vector() -> intel_thermal_interrupt() in hard irq context.
For this reason it must not use a simple spin_lock that sleeps with
PREEMPT_RT enabled. So convert it to a raw spinlock.

Reported-by: xiao sheng wen <atzlinux@sina.com>
Link: https://bugs.debian.org/1076483
Signed-off-by: Uwe Kleine-König <ukleinek@debian.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: xiao sheng wen <atzlinux@sina.com>
Link: https://patch.msgid.link/20240919081121.10784-2-ukleinek@debian.org
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1623,7 +1623,7 @@ static void intel_pstate_notify_work(str
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_STATUS, 0);
 }
 
-static DEFINE_SPINLOCK(hwp_notify_lock);
+static DEFINE_RAW_SPINLOCK(hwp_notify_lock);
 static cpumask_t hwp_intr_enable_mask;
 
 #define HWP_GUARANTEED_PERF_CHANGE_STATUS      BIT(0)
@@ -1646,7 +1646,7 @@ void notify_hwp_interrupt(void)
 	if (!(value & status_mask))
 		return;
 
-	spin_lock_irqsave(&hwp_notify_lock, flags);
+	raw_spin_lock_irqsave(&hwp_notify_lock, flags);
 
 	if (!cpumask_test_cpu(this_cpu, &hwp_intr_enable_mask))
 		goto ack_intr;
@@ -1654,13 +1654,13 @@ void notify_hwp_interrupt(void)
 	schedule_delayed_work(&all_cpu_data[this_cpu]->hwp_notify_work,
 			      msecs_to_jiffies(10));
 
-	spin_unlock_irqrestore(&hwp_notify_lock, flags);
+	raw_spin_unlock_irqrestore(&hwp_notify_lock, flags);
 
 	return;
 
 ack_intr:
 	wrmsrl_safe(MSR_HWP_STATUS, 0);
-	spin_unlock_irqrestore(&hwp_notify_lock, flags);
+	raw_spin_unlock_irqrestore(&hwp_notify_lock, flags);
 }
 
 static void intel_pstate_disable_hwp_interrupt(struct cpudata *cpudata)
@@ -1673,9 +1673,9 @@ static void intel_pstate_disable_hwp_int
 	/* wrmsrl_on_cpu has to be outside spinlock as this can result in IPC */
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_INTERRUPT, 0x00);
 
-	spin_lock_irq(&hwp_notify_lock);
+	raw_spin_lock_irq(&hwp_notify_lock);
 	cancel_work = cpumask_test_and_clear_cpu(cpudata->cpu, &hwp_intr_enable_mask);
-	spin_unlock_irq(&hwp_notify_lock);
+	raw_spin_unlock_irq(&hwp_notify_lock);
 
 	if (cancel_work)
 		cancel_delayed_work_sync(&cpudata->hwp_notify_work);
@@ -1690,10 +1690,10 @@ static void intel_pstate_enable_hwp_inte
 	if (boot_cpu_has(X86_FEATURE_HWP_NOTIFY)) {
 		u64 interrupt_mask = HWP_GUARANTEED_PERF_CHANGE_REQ;
 
-		spin_lock_irq(&hwp_notify_lock);
+		raw_spin_lock_irq(&hwp_notify_lock);
 		INIT_DELAYED_WORK(&cpudata->hwp_notify_work, intel_pstate_notify_work);
 		cpumask_set_cpu(cpudata->cpu, &hwp_intr_enable_mask);
-		spin_unlock_irq(&hwp_notify_lock);
+		raw_spin_unlock_irq(&hwp_notify_lock);
 
 		if (cpu_feature_enabled(X86_FEATURE_HWP_HIGHEST_PERF_CHANGE))
 			interrupt_mask |= HWP_HIGHEST_PERF_CHANGE_REQ;


