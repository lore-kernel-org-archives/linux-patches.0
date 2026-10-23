Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774901;
	b=d5g12I8YFyzM3TCY6TTtMiWm4+ZjXfr+XyVoqrEFLa7UdN95Lp5BbcitxDwfVagxDNhU
	 hdk593U6HaqHpPiSMc6yNcmkGQyRWIkITdN0ndQvPY3SNjUceMciT8bxYQUsOYrHk0d3x
	 YLSAPtLSMZ0j0nEHjrx8UVmKZxv9DxoZClM+Ythi4GelQJSIFvjR2dMTugXcaaj0c94R4
	 xori+K8QdOZDGXZFAyX6A2b9RudrfaIt3PTos21TXUCNoCHm/Cbg8/5VRiv0Z+qw+zVSZ
	 5dd4oRym5Gdcy9VogXEZBGy9kf3hexr0TSBkngwpDAajYgOO6t9MHnaFaqQD17dV1Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GiIdNkyd4njwC5CfzfI63K3IgGlL7HO9ga8UW2t4o8w=;
	b=SzJFyz8KLEE+UZcn/GTnqrYRqI+1cy8E+xUN8gGiru6ziXGiRSIVY1EYXAn9zvXTvNW3
	 NhI4gEGOEvYRyCJi1kT0G+HrT7MB5U2OmgCzb+yYq0gzZvgrhdFY6cvTeRw4kjarbFiLU
	 HFG0JI+JJSTXT7FtfwKR2lbcN6LYOBVQakZJtvnDAf2bB9WEQ0h5jWKZaUHvQNEiTGZH4
	 J1zKaL8niWdpTygr/znFch1enOnhc6VLZ1ngxMp8McSDmLC3HMOYiQRNnqflwxlpQ51zs
	 u3GSaEiDCnfLI4IxXmkIO59fL6/gldI1dM2WLdjTg9liJR5nHcajGvWYxAZ7KepBrvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6XIB+AJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1F606A31A;
	Fri, 23 Oct 2026 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6XIB+AJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBF51F01825;
	Fri, 23 Oct 2026 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774901;
	bh=GiIdNkyd4njwC5CfzfI63K3IgGlL7HO9ga8UW2t4o8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6XIB+AJzbT+whSxiSGXMiKZm5uT7X5oYCPu9e7pQN9adSClAhh27E+8MLgNQIOA1
	 GFZKDnbwvT6wUqv3M530fHzrdKZWwzZR4GSYBclen54oCdmxf57hbWp/MAA8wwC36m
	 IK2IbVXyrJq2ODRrWwNFaOcid6V4o4j2z3dQ9hig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 196/242] workqueue: Use raise_softirq() to trigger softirq in irq_work handler
Date: Fri, 23 Oct 2026 18:40:38 +0200
Message-ID: <20261023163718.427133601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7956,12 +7956,12 @@ static inline void wq_watchdog_init(void
 
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


