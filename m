Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207699;
	b=4Ulw6yMYFoFZYdhTQGg4CB46X9YlBHoBpj4K23iq7MxV++m5LJ1CYdETipy105O/Rwa6
	 hwIwMPT8ZOE1zdqemnPy5S4tam0dVCMI9fcmCTlse/6oSi65/OTaApuCv3sb+1AlRv8wk
	 eZkXrvs4BPrGEFLumJ4UiGF8Aegr7+1EW1PQnEq4xjpiNKfFTdD+ZaojxvcyhTRaNAvKK
	 yXglYqi6s5EbCOYdZrba9A3fTfreBXug0vtj24GXCIxMiMIm2fK5ePICCGqyQyIIauY8N
	 imTym8SiBFcQeNmHIgkAyX6/z5vaVrZeCpdKVlDCfAVmLlnrPqkF9CronwPmGbtaXlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kHbVVMvC/KIOYFAhGJxtM/9wn5oil+tn2khPG+u2E8Q=;
	b=efLBT5yICa9sFD7uaV8T/O2XRVDVbnlfqmZtTSWHh8hd3ejpvWHvIEDNdAWadMd+A2L1
	 WfKyaPdTpfwMcyUv5FqPLDADFis/OCkkErdZHNSz0SZJTZFi9RxccwafQ98wN4nuXYdW7
	 9Qs+Gmy+NnuFluSlIWQNxGn9xDtex4adWzIFuyZtoSHrhS1/D0/gBDqLpj1zT7K9WOA7f
	 pUp30u/5hFvv9KBCg9VxdEQEH+rczQq1e3MioFPgUa0pPHQa4+JREjBt8JixfHI6ctT5I
	 F+8oNUdnP9Xr3e8qmgf1mRdBNqkKbpKKJ7HA9P767XeLOUIzI2rMA64yRs2phB0Yq0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iq/TZb1Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05907606A31F;
	Wed, 28 Oct 2026 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iq/TZb1Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BE71F031E0;
	Wed, 28 Oct 2026 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207698;
	bh=kHbVVMvC/KIOYFAhGJxtM/9wn5oil+tn2khPG+u2E8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iq/TZb1YWA8UILH66PfZIh9O/5w9GRnaQVqHZNdRy0RHTsgp9JoD2j3yXzq5Vqxeq
	 /1WAqDy7e+jCmaI6/bMNVGKNUD0OKyCiU+Z0IxWHQ/wZnoqx1C6QsfvNFLvnPdSnnp
	 NnqIYdTv6yypJ3eswJIO2+9qW/X8VuvAI10tc/Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 108/247] workqueue: Use raise_softirq() to trigger softirq in irq_work handler
Date: Wed, 28 Oct 2026 17:58:31 +0100
Message-ID: <20261028165949.956117179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

commit 7e2f2a377ac9f50296ad60bd331f0d4def7aee51 upstream.

bh_pool_kick_normal() and bh_pool_kick_highpri() are registered via
init_irq_work() without the IRQ_WORK_HARD_IRQ flag. On PREEMPT_RT, such
irq_work items are processed by the per-CPU irq_workd kthread in preemptible
task context with IRQs enabled. However, raise_softirq_irqoff() requires
IRQs to be disabled. Calling it from irq_workd trips the lockdep assertion
in __raise_softirq_irqoff() and the non-atomic update of the softirq pending
mask can lose bits raised by an interrupt on the same CPU. Replace
raise_softirq_irqoff() with raise_softirq() in the irq_work handlers.

Fixes: 2f34d7337d98 ("workqueue: Fix queue_work_on() with BH workqueues")
Cc: stable@vger.kernel.org # v6.9+
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7738,12 +7738,12 @@ static inline void wq_watchdog_init(void
 
 static void bh_pool_kick_normal(struct irq_work *irq_work)
 {
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	raise_softirq(TASKLET_SOFTIRQ);
 }
 
 static void bh_pool_kick_highpri(struct irq_work *irq_work)
 {
-	raise_softirq_irqoff(HI_SOFTIRQ);
+	raise_softirq(HI_SOFTIRQ);
 }
 
 static void __init restrict_unbound_cpumask(const char *name, const struct cpumask *mask)


