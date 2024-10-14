Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DB21798C;
	Mon, 14 Oct 2024 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919474; cv=none; b=I4IP7eoqcbIve+0VMoM98VWaDN6DutWh2p6c1g9SJ4sKOOTOzjPEVHA1qAG2/QdHJ6zjU3jF5tTVh1lEjTiyMxx9Yn7Q300JI8eO1MokdHBVHAu8bgL13USUxvbjYr7bBUpapfChSVXT1IXBAi45ytXWtFnsCx2NsL6+pxQQ/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919474; c=relaxed/simple;
	bh=9KLkm7LuR7qCF3JEImJTS1eibC5VtaZPKgA6bt/g1xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOxYW1alrcu7WU+X5CoRuE6nYvHLK4duCdjY2afHZ65Lb/sDuKgNwGZMhMU5SjozErLop5dC8qwnB+KCfEurjb3VYuRqKsc7jvo0bAnmJPDxMPKfgI+quktrx21+F2Zr/JQvnNfCpdjNSq4GrH2diFVvnrGJ/7DWBYfVBK01w9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+vTfZLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+vTfZLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188A2C4CEC3;
	Mon, 14 Oct 2024 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919474;
	bh=9KLkm7LuR7qCF3JEImJTS1eibC5VtaZPKgA6bt/g1xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+vTfZLXmywjkrk/wdg5KJh0uyrkGEZHsjTxtuRkWo/lb5sbvPkKA2ywJkb2mklis
	 2xAP/QVyBmEkd40BFcvt7Bd+Joj/UtTBtTXCKLpvbk7u05eXusjdOspNXvtLyr1OKW
	 nPpd5TM2LURpLgSlR+oYH+pSRN3+yvODdG+jYg9M=
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
Subject: [PATCH 6.1 616/798] cpufreq: intel_pstate: Make hwp_notify_lock a raw spinlock
Date: Mon, 14 Oct 2024 16:19:30 +0200
Message-ID: <20241014141242.241556264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4abda800c632d..d471d74df3bbb 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1596,7 +1596,7 @@ static void intel_pstate_notify_work(struct work_struct *work)
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_STATUS, 0);
 }
 
-static DEFINE_SPINLOCK(hwp_notify_lock);
+static DEFINE_RAW_SPINLOCK(hwp_notify_lock);
 static cpumask_t hwp_intr_enable_mask;
 
 void notify_hwp_interrupt(void)
@@ -1613,7 +1613,7 @@ void notify_hwp_interrupt(void)
 	if (!(value & 0x01))
 		return;
 
-	spin_lock_irqsave(&hwp_notify_lock, flags);
+	raw_spin_lock_irqsave(&hwp_notify_lock, flags);
 
 	if (!cpumask_test_cpu(this_cpu, &hwp_intr_enable_mask))
 		goto ack_intr;
@@ -1637,13 +1637,13 @@ void notify_hwp_interrupt(void)
 
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
@@ -1656,10 +1656,10 @@ static void intel_pstate_disable_hwp_interrupt(struct cpudata *cpudata)
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
@@ -1668,10 +1668,10 @@ static void intel_pstate_enable_hwp_interrupt(struct cpudata *cpudata)
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
@@ -3101,10 +3101,10 @@ static void intel_pstate_driver_cleanup(void)
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



