Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774282;
	b=FVgZGFajv/KyuXr/+r6A/0lmzzDqjEEuz8Ktl3XzYOGJgmp2QYUU05+vKpSoWpw+MxlC
	 M7fKQHbngfJupwnag4yG0YNecrEuy6K3Rb2O83gD7TmEJGf//q39yQxO2tW8fKyQDiwXf
	 uFlC4ijY+acHqFztDk0GTzVQHEAEKD3PtLrrVOD8A1FbnTCp/lq1mD/ls0UnqgQj8iDDv
	 9v1xX08Zzy94mj8GgvV15J5D52HLcQ5fKva5PxpnZpW9J9dskvvrxNqC8NjWE3EGZbIgz
	 cfXz6wSDbV4ONZ5Stk2ROEfQls3u2s3p75qZssSXVoK8P1SUU/bo1ZFPXHvZxwGGoQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x2+k3HH5LL7dZg2jMbPjXQ/CbXD4j1Be2sNDBQDX+mw=;
	b=TPVoosx3l+9S2g0evUuCjp3T7y6bq/U0I+Oh/DNldvpJ8h0E2G69bdHpnyBhhe6YpGpK
	 eV8bfoajhZUdrLhFcwFeM48LFs4FqNIYl3/uJOuu2NTD/zHVk2rdjBX6yaATBk+tWlVre
	 jJAFzgOvtjBoZ0SiPtrrNh/JMQsSK+LGhrhSCRE3VIEWbdRw4lcKm4ZBD9iWAtiqZ5Ap6
	 pKW8lkqtJRHeXkPoOzew9QCDuSLoN7g4b7T1u5+eiTJzsglPbre1J9ntI9wpGTIs466uR
	 g85bjM4+UYdvG54jipYmJZJdzw0Hybz/qOqECm0XXiTrtmhU+zwNwM6LQ9mtGx47jBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjBuF5Na;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576E606A31A;
	Fri, 23 Oct 2026 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjBuF5Na
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DB1F01825;
	Fri, 23 Oct 2026 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774282;
	bh=x2+k3HH5LL7dZg2jMbPjXQ/CbXD4j1Be2sNDBQDX+mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjBuF5NacN+Dg6nXrM1Us2CWJVJhCsjjpqcWU15SFLb3G1Eb3+ORqv5hZ7KqcIY0x
	 DVnJBZzdvWnP+7D9eHncQ5K7VfMCfdpJoWPoV+goTtiF5EkR9Ic5t+m5kxB8D6vdRl
	 5kxMlLSBWW+sugzel+LwCdD6SaGWs5pJSYmIvG5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 134/193] workqueue: Use raise_softirq() to trigger softirq in irq_work handler
Date: Fri, 23 Oct 2026 18:36:51 +0200
Message-ID: <20261023163717.379911246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7808,12 +7808,12 @@ static inline void wq_watchdog_init(void
 
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


