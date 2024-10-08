Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3F1E04A5;
	Tue,  8 Oct 2024 13:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394124; cv=none; b=Jq30RUph3TTKOIVz/bLBBpExrZz9ICkQoUFfzUzrF2ZbJrdItniwCgK4TihFeNCrjHNkw6bDI4wtRSX0wxRfHNLrlRsKdoPWcphADo3eWxhY1mG0j4GaISgh+ZGiW8XW9rJdHpfRO6zYzuzNVrEKZiokjhs3SUlS/DhVvl1AIhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394124; c=relaxed/simple;
	bh=fXpZLfTL1khFBiS/WZHXzROhywKZsoJ5DZ6uHMat8nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=myyHFcz1Pm6ANA3A4Li0ov5BurnZdiYmhTtL+1wcAj3fWFSq58w6UvDqn/BqLTdS6BY9lPpHsB3ZO++P/XcQqPShUc9IHHE5xrkaCEMG/Oh4P62XK2hLYRZlxUqAv/llqDU75bfTkbiG5oHDaDMmja7ggPHpPMiG6v6woQ69w/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ia8b4ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ia8b4ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA0C4CEC7;
	Tue,  8 Oct 2024 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394124;
	bh=fXpZLfTL1khFBiS/WZHXzROhywKZsoJ5DZ6uHMat8nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ia8b4wwOzEPKZngd3oxHQYf9rhYQEKbzsd7sSMWnwZ6HQEyQlejrRtUcQr1ME4s6
	 CejMvV9u/aYM3OdT77j/Bqinr/m3CsClWPfcJb9qHvy09J0BrvMBZsOXdtOTgOJWQh
	 Ua+JBXeIBznWjWzTF9anquQNbiur941HXfIBASLM=
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
Subject: [PATCH 6.6 327/386] cpufreq: intel_pstate: Make hwp_notify_lock a raw spinlock
Date: Tue,  8 Oct 2024 14:09:32 +0200
Message-ID: <20241008115642.253655718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ukleinek: Backport to v6.6.y]
Signed-off-by: Uwe Kleine-König <ukleinek@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 0ee3a04bb1022..8a4fdf212ce0d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1632,7 +1632,7 @@ static void intel_pstate_notify_work(struct work_struct *work)
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_STATUS, 0);
 }
 
-static DEFINE_SPINLOCK(hwp_notify_lock);
+static DEFINE_RAW_SPINLOCK(hwp_notify_lock);
 static cpumask_t hwp_intr_enable_mask;
 
 void notify_hwp_interrupt(void)
@@ -1649,7 +1649,7 @@ void notify_hwp_interrupt(void)
 	if (!(value & 0x01))
 		return;
 
-	spin_lock_irqsave(&hwp_notify_lock, flags);
+	raw_spin_lock_irqsave(&hwp_notify_lock, flags);
 
 	if (!cpumask_test_cpu(this_cpu, &hwp_intr_enable_mask))
 		goto ack_intr;
@@ -1673,13 +1673,13 @@ void notify_hwp_interrupt(void)
 
 	schedule_delayed_work(&cpudata->hwp_notify_work, msecs_to_jiffies(10));
 
-	spin_unlock_irqrestore(&hwp_notify_lock, flags);
+	raw_spin_unlock_irqrestore(&hwp_notify_lock, flags);
 
 	return;
 
 ack_intr:
 	wrmsrl_safe(MSR_HWP_STATUS, 0);
-	spin_unlock_irqrestore(&hwp_notify_lock, flags);
+	raw_spin_unlock_irqrestore(&hwp_notify_lock, flags);
 }
 
 static void intel_pstate_disable_hwp_interrupt(struct cpudata *cpudata)
@@ -1692,10 +1692,10 @@ static void intel_pstate_disable_hwp_interrupt(struct cpudata *cpudata)
 	/* wrmsrl_on_cpu has to be outside spinlock as this can result in IPC */
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_INTERRUPT, 0x00);
 
-	spin_lock_irqsave(&hwp_notify_lock, flags);
+	raw_spin_lock_irqsave(&hwp_notify_lock, flags);
 	if (cpumask_test_and_clear_cpu(cpudata->cpu, &hwp_intr_enable_mask))
 		cancel_delayed_work(&cpudata->hwp_notify_work);
-	spin_unlock_irqrestore(&hwp_notify_lock, flags);
+	raw_spin_unlock_irqrestore(&hwp_notify_lock, flags);
 }
 
 static void intel_pstate_enable_hwp_interrupt(struct cpudata *cpudata)
@@ -1704,10 +1704,10 @@ static void intel_pstate_enable_hwp_interrupt(struct cpudata *cpudata)
 	if (boot_cpu_has(X86_FEATURE_HWP_NOTIFY)) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&hwp_notify_lock, flags);
+		raw_spin_lock_irqsave(&hwp_notify_lock, flags);
 		INIT_DELAYED_WORK(&cpudata->hwp_notify_work, intel_pstate_notify_work);
 		cpumask_set_cpu(cpudata->cpu, &hwp_intr_enable_mask);
-		spin_unlock_irqrestore(&hwp_notify_lock, flags);
+		raw_spin_unlock_irqrestore(&hwp_notify_lock, flags);
 
 		/* wrmsrl_on_cpu has to be outside spinlock as this can result in IPC */
 		wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_INTERRUPT, 0x01);
@@ -3136,10 +3136,10 @@ static void intel_pstate_driver_cleanup(void)
 			if (intel_pstate_driver == &intel_pstate)
 				intel_pstate_clear_update_util_hook(cpu);
 
-			spin_lock(&hwp_notify_lock);
+			raw_spin_lock(&hwp_notify_lock);
 			kfree(all_cpu_data[cpu]);
 			WRITE_ONCE(all_cpu_data[cpu], NULL);
-			spin_unlock(&hwp_notify_lock);
+			raw_spin_unlock(&hwp_notify_lock);
 		}
 	}
 	cpus_read_unlock();
-- 
2.43.0



