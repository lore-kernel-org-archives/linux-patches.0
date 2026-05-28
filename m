Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA425317164;
	Thu, 28 May 2026 20:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000938; cv=none; b=atU8EmvXHsmOBAV7RSkD9IUW6SzOLcE5A+cpScx2BK8MvzJvi0i94oNvI8omfJzWJDECiKVQx2SSNN/LE0XpudtHBn9dBOkT1AffE+u8t8o/uO15OZxsxLAKeCdtpGDThXwtt/F/5B1lNtDYm151IHFMdwbXhG6QVHZmmoli5Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000938; c=relaxed/simple;
	bh=76ZT5+w3SXUwrGrUhJ2O+J8Q2QEH81PRCPwmEiAYp44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpDGuthZJw1gtk8vV26fO2j73ucSSY8PO6Y2eHsPq2w96Ywo7RJ3mOsMjsaazW/XaIme2OwXjyUJgdXqxxUvWuZzv5OU+3/s+eHWhJ9289ZN2xK3ub8fgfxuY+wT19xqdKBct9R5rkJ3qTVteJzC+XkpK+E8tQH3kXxv2AMcbJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eol1Iub6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eol1Iub6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2591F000E9;
	Thu, 28 May 2026 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000936;
	bh=LX9fVVmTmh6ueoYn1XHl2xy3zISBBYq+K3sbJt8HtYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eol1Iub6FMgYB1qTGD9fsgM3SG80+OOpc94n4++fYZedeCm2blDN+3Uvyg6rF0hFd
	 TKieytAaPhQ28m7J1SLkY6PpG3DOWZ6QtQmdRlGbjNiClSWB/wQrtrDD1mZLsCu7E5
	 87t9PD3dQ4JEJOePiharUqEbT+Mjv2OcvDA+rDl0=
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
Subject: [PATCH 6.12 223/272] powerpc/time: Remove redundant preempt_disable|enable() calls from arch_irq_work_raise()
Date: Thu, 28 May 2026 21:49:57 +0200
Message-ID: <20260528194635.438515877@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0ff9f038e800d..ce7f91172ec2b 100644
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



