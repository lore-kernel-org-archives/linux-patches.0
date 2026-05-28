Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6422E7379;
	Thu, 28 May 2026 20:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000032; cv=none; b=F4IdvqmteHT7Gcg4H7RwWKgbY5hHwZ7+psXR9tVPO4qQxAXOSzwuxARoeKCq5TYcFKolbym9IXPhfbhBgL3bm/XeXWrt4HOD6+T3qKXoKbnSjr9jTs7gfklN6K2didB4wTyqkypo6435Ga2GiIK2GwnyVMzLDEZYtPLDse/4/Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000032; c=relaxed/simple;
	bh=C5zxWqZyFFjwNmXxyvN5eC0YJzLaYwRWZPmvSmcjYZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VM44HqjSNznNV1J8KFUQ4QM2aq7UQcGneeNtWm7iARUQ5w+TZid+ss3vjGNQ9yU2ypB15gjOnuCzlkAvETbKIuGnXXzCiiwSxXgRu2CSeFC3+k2XSjbzUESTdWxXa+O/XPPdVxt7p2WDPh/K82tSPCMFc3Ws/SX5F90nHCrAAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SamWyETF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SamWyETF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6801F000E9;
	Thu, 28 May 2026 20:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000031;
	bh=mmrSvZ3YUUVaAd8BuzqOm2+nMxWiD8ZpmwoOZG2Xd38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SamWyETFKBvKqDw0kLPES/TBO+vzP0jpX1/un6TZ+HT1j7GgH6dmBOuzyPnRBvKbL
	 8wZ4ePh1FyPKsvG6M4QA1tyGUN6/COQtWmfRir1gF/Soin8juIAWySoC5FvjXy1qIF
	 3NQTllsMDUrE4zNu2N/Gi/k4HHZZy6iIkwR36HXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sayali Patil <sayalip@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/377] powerpc/time: Remove redundant preempt_disable|enable() calls from arch_irq_work_raise()
Date: Thu, 28 May 2026 21:48:37 +0200
Message-ID: <20260528194646.435486143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 31467b23823ffec1f6fff407f8e3ca9af8b7491a ]

A kernel panic is observed when handling machine check exceptions from
real mode.

  BUG: Unable to handle kernel data access on read at 0xc00000006be21300
  Oops: Kernel access of bad area, sig: 11 [#1]
  MSR:  8000000000001003 <SF,ME,RI,LE>  CR: 88222248  XER: 00000005
  CFAR: c00000000003ffc4 DAR: c00000006be21300 DSISR: 40000000 IRQMASK: 0
  NIP [c000000000029e40] arch_irq_work_raise+0x10/0x70
  LR [c00000000003ffc8] machine_check_queue_event+0xa8/0x150
  Call Trace:
  [c0000000179d3c70] [c00000000003ff64] machine_check_queue_event+0x44/0x150
  [c0000000179d3d30] [c0000000000084e0] machine_check_early_common+0x1f0/0x2c0

The crash occurs because arch_irq_work_raise() calls preempt_disable()
from machine check exception (MCE) handlers running in real mode. In
this context, accessing the preempt_count can fault, leading to the panic.

The preempt_disable()/preempt_enable() pair in arch_irq_work_raise()
was originally added by commit 0fe1ac48bef0 ("powerpc/perf_event: Fix
oops due to perf_event_do_pending call") to avoid races while raising
irq work from exception context.

Later, commit 471ba0e686cb ("irq_work: Do not raise an IPI when
queueing work on the local CPU") added preemption protection in
irq_work_queue() path, while commit 20b876918c06 ("irq_work: Use per
cpu atomics instead of regular atomics") added equivalent
protection in irq_work_queue_on() before reaching arch_irq_work_raise():

  irq_work_queue() / irq_work_queue_on()
    -> preempt_disable()
      -> __irq_work_queue_local()
        -> irq_work_raise()
          -> arch_irq_work_raise()

As a result, callers other than mce_irq_work_raise() already execute
with preemption disabled, making the additional
preempt_disable()/preempt_enable() pair in arch_irq_work_raise()
redundant.

The arch_irq_work_raise() function executes in NMI context when called
from MCE handler. Hence we will not be preempted or scheduled out since
we are in NMI context with MSR[EE]=0. Therefore, it is safe to remove
the preempt_disable()/preempt_enable() calls from here.

Remove it to avoid accessing preempt_count from real mode context.

Fixes: cc15ff327569 ("powerpc/mce: Avoid using irq_work_queue() in realmode")
Suggested-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Acked-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
[Maddy: Fixed the commit title]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260513081413.222490-1-sayalip@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 4bbeb8644d3da..b4472288e0d43 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -458,6 +458,10 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 
 #endif /* 32 vs 64 bit */
 
+/*
+ * Must be called with preemption disabled since it updates
+ * per-CPU irq_work state and programs the local CPU decrementer.
+ */
 void arch_irq_work_raise(void)
 {
 	/*
@@ -471,10 +475,8 @@ void arch_irq_work_raise(void)
 	 * which could get tangled up if we're messing with the same state
 	 * here.
 	 */
-	preempt_disable();
 	set_irq_work_pending_flag();
 	set_dec(1);
-	preempt_enable();
 }
 
 static void set_dec_or_work(u64 val)
-- 
2.53.0



