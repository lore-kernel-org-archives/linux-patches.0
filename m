Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29941779B1;
	Tue,  8 Oct 2024 12:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390956; cv=none; b=AcJgV9I89D83XD5i6SvRriKlsH3CesIwWlTGRO0RccAzGu+rvsH0xe0+PqPce4+rbYztWM3zD+qDpDKrGyOLSoKcJ6ZNbN1sLrIGdFhI45G2zyVwk2JXfGGUC96Wd+oZojGnfTQ5wpIVZeb2NEYN9Qi9+5yy2MjRPtOGlbY1Dhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390956; c=relaxed/simple;
	bh=mylY7cghqDlsfXmulSYjeI06WkrUkE9tYR+gAkK0c1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PYwW0fU74/cItt1xuix0jhUbJL+o8kx6UMB8jS5cxg5CB/Dpfpx/8l7mUPrv3nsSzYtMTbCf47erBfXzPIZm79kgYl0RazkR4AD2kVZXvgwmhWCbdI9zlpqKZazLX0VvZnHi8t01gASkGXMi/HsXLiROWIH1rxcS5BnO/4h8ASk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBriszbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBriszbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D15FC4CEC7;
	Tue,  8 Oct 2024 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390955;
	bh=mylY7cghqDlsfXmulSYjeI06WkrUkE9tYR+gAkK0c1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBriszbiYv8e4i2U5PFIMNaPlM6PTLXre+5VFaATiGF5fky6ZbvEz64TyAX8oVc9D
	 9XF3MbEMMtTkMmAXR1WrA5rmOICOmGFBnj//Z1iPCGN7yP0YNKkH/zlN+Lta0qDn2C
	 Jr3de+2REjHltlJC/2Egce3cURHpDALzJuuBAaE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiao sheng wen <atzlinux@sina.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 446/482] cpufreq: intel_pstate: Make hwp_notify_lock a raw spinlock
Date: Tue,  8 Oct 2024 14:08:29 +0200
Message-ID: <20241008115706.074395333@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
[ukleinek: Backport to v6.10.y]
Signed-off-by: Uwe Kleine-König <ukleinek@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c31914a9876fa..b694e474acece 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1622,7 +1622,7 @@ static void intel_pstate_notify_work(struct work_struct *work)
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_STATUS, 0);
 }
 
-static DEFINE_SPINLOCK(hwp_notify_lock);
+static DEFINE_RAW_SPINLOCK(hwp_notify_lock);
 static cpumask_t hwp_intr_enable_mask;
 
 void notify_hwp_interrupt(void)
@@ -1638,7 +1638,7 @@ void notify_hwp_interrupt(void)
 	if (!(value & 0x01))
 		return;
 
-	spin_lock_irqsave(&hwp_notify_lock, flags);
+	raw_spin_lock_irqsave(&hwp_notify_lock, flags);
 
 	if (!cpumask_test_cpu(this_cpu, &hwp_intr_enable_mask))
 		goto ack_intr;
@@ -1646,13 +1646,13 @@ void notify_hwp_interrupt(void)
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
@@ -1665,9 +1665,9 @@ static void intel_pstate_disable_hwp_interrupt(struct cpudata *cpudata)
 	/* wrmsrl_on_cpu has to be outside spinlock as this can result in IPC */
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_INTERRUPT, 0x00);
 
-	spin_lock_irq(&hwp_notify_lock);
+	raw_spin_lock_irq(&hwp_notify_lock);
 	cancel_work = cpumask_test_and_clear_cpu(cpudata->cpu, &hwp_intr_enable_mask);
-	spin_unlock_irq(&hwp_notify_lock);
+	raw_spin_unlock_irq(&hwp_notify_lock);
 
 	if (cancel_work)
 		cancel_delayed_work_sync(&cpudata->hwp_notify_work);
@@ -1677,10 +1677,10 @@ static void intel_pstate_enable_hwp_interrupt(struct cpudata *cpudata)
 {
 	/* Enable HWP notification interrupt for guaranteed performance change */
 	if (boot_cpu_has(X86_FEATURE_HWP_NOTIFY)) {
-		spin_lock_irq(&hwp_notify_lock);
+		raw_spin_lock_irq(&hwp_notify_lock);
 		INIT_DELAYED_WORK(&cpudata->hwp_notify_work, intel_pstate_notify_work);
 		cpumask_set_cpu(cpudata->cpu, &hwp_intr_enable_mask);
-		spin_unlock_irq(&hwp_notify_lock);
+		raw_spin_unlock_irq(&hwp_notify_lock);
 
 		/* wrmsrl_on_cpu has to be outside spinlock as this can result in IPC */
 		wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_INTERRUPT, 0x01);
-- 
2.43.0



