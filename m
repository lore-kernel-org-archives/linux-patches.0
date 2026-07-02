Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D3D82866;
	Thu,  2 Jul 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011079; cv=none; b=TwZpWxJKBh9oZFmP+AFMLv1xoPxF5C/SqiXNxYKYDUQjRc1dCMcFx5BKxeby48vkOrCS6MozipT1q46BPFwiE3kKIdyUT67jqiZJLtvrWbae5UPd//bepo8AysQ1WxPSk7KxAs3b6OMuSX0Ey+56TyN/dgHXZd6uQqXwMkgTbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011079; c=relaxed/simple;
	bh=Zz1roTpX9vrxcuqLjrmaxRHsmZqaoSxW9VVIs5CXcz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgp6mD7R7lO5b3IHpyFJG8EP8rU0U3QpK1NVZlZ6KxdTSV9wotcMR9h8FiR09Cq1A3+rvl/VbXoE56RwUJqnR/uIaB4IwRu+1nwwhjeE294bHjPXwQU2xkOUg9gGV4oWgyORJt5+qXvJZ9amB2TFWeo4HMkt0meUoO2L2F8WWCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1A9mGtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1A9mGtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9AD1F00A3A;
	Thu,  2 Jul 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011078;
	bh=26yMTZjxhoIzQP8MAJLXlBshLRX6EQjDKiIfLcJluiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1A9mGtCsNoYf+Za4AUHsRE4uV8yZL1BFC0gqy6w5Uw1GQOCGb4nwFapwqOcBEVEv
	 VM0tvK82WkKUHztUrw1lYvD9vwzOLGX87FzjxRc4jF7P3Y2/FaSMBGdkPnGheC2Yar
	 bK6SqlbP1tV6Ea3iFDV8l2p2COji2TpPNS+Kq5vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 149/175] LoongArch: Report dying CPU to RCU in stop_this_cpu()
Date: Thu,  2 Jul 2026 18:20:50 +0200
Message-ID: <20260702155118.942384274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit f2539c56c74691e7a88af6372ba2b48c06ed2fe4 upstream.

This is a port of MIPS commit 9f3f3bdc6d9dac1 ("MIPS: smp: report dying
CPU to RCU in stop_this_cpu()"). smp_send_stop() parks all secondary
CPUs in stop_this_cpu(). And the function marks the CPU offline for the
scheduler via set_cpu_online(false) but never informs RCU, so RCU keeps
expecting a quiescent state from CPUs that are now spinning forever with
interrupts disabled.

As long as nothing waits for an RCU grace period after smp_send_stop()
this is harmless, which is why it went unnoticed. However, since commit
91840be8f710370 ("irq_work: Fix use-after-free in irq_work_single() on
PREEMPT_RT"), irq_work_sync() calls synchronize_rcu() on architectures
without an irq_work self-IPI, i.e. where arch_irq_work_has_interrupt()
returns false. Any irq_work_sync() issued in the reboot/shutdown/halt
path after smp_send_stop() then blocks on a grace period that can never
complete, hanging the reboot:

  WARNING: CPU: 0 PID: 15 at kernel/irq_work.c:144 irq_work_queue_on
  ...
  rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
  rcu: Offline CPU 1 blocking current GP.
  rcu: Offline CPU 2 blocking current GP.
  rcu: Offline CPU 3 blocking current GP.

This issue needs some hacks to reproduce, and it was not noticed on
LoongArch because arch_irq_work_has_interrupt() usually returns true.

Call rcutree_report_cpu_dead() once interrupts are disabled, mirroring
the generic CPU-hotplug offline path, so RCU stops waiting on the parked
CPUs and grace periods can still complete. LoongArch shuts down all CPUs
here without going through the CPU-hotplug mechanism, so this report is
not otherwise issued.

Cc: <stable@vger.kernel.org>
Fixes: 91840be8f710 ("irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT")
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -613,6 +613,7 @@ static void stop_this_cpu(void *dummy)
 	set_cpu_online(smp_processor_id(), false);
 	calculate_cpu_foreign_map();
 	local_irq_disable();
+	rcutree_report_cpu_dead();
 	while (true);
 }
 


