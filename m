Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020433;
	b=MDImcQzzrVJmEtOodzLUXQqkJQEYf6zzd81hhug5jZRKsMo0bcVEjmEeM1emw0uDqZma
	 +wiV0o19qtPlaiB49vns5mzF/gE14yg8IYX9xjUbd2YcgD4Ezt/e+A0sYjHMauyZR9cA3
	 JJFm4aEO1zBSVnQOJNwkGSm/KEVm2uGuYPN699Wxqh82yQF1KJ2ZohF8GX2MuTXfEjre3
	 IA2x7dSq30yZd8CCB8vx9aAVQMJlopSgaxPQ21I2H/Errtt/6AoJg9IWyEwmLPaC0uHTK
	 7H4sdYt/i5QLl0nE4rN5XFXTcCeNoV9zymwn8mTIelhmbH1DwFf7hRbn9WsH3cpJqVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Zlg4C5IrVdtK3prQAcSNzAS6g+E6eta9UNlZiSNG0sw=;
	b=EZIUC/uDt03nW2MxTEOAe3hR8RLhbxUsakYsu45vpNDCmWufLgHupW5AJ/S8RcRYc7mD
	 QkZqo7xXx30kZPj76SDSQq/JgyAmkI+EK8Qb5kVYF0ndDjN5PPSwyGk3gP+iDLfirQrzX
	 BGBQqTjNb/R7z5UeFMlxhy6DILrUYldcq79SGpKe5OVCAA1C9XlkyKtOcJI0JcSrolUDt
	 3vPVXr0ehEZtaEp57Z/0t1q6ho4zISvmC5aPqcIPyYAWe77u8t3RjYaRunhmajG7IMpup
	 XPUh3RBEUinJOyhdaCR39Cya1J5nZiKQraPYRpRwabrSospXUR3m0Ay03NnxbUdgt7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GINVqLjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45569606A31C;
	Wed, 18 Nov 2026 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GINVqLjt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D92C1F000C6;
	Wed, 18 Nov 2026 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020433;
	bh=Zlg4C5IrVdtK3prQAcSNzAS6g+E6eta9UNlZiSNG0sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GINVqLjt8YGKmyyX6d7Yjo3NECCRgxw4iKHKEgj2Z/y3pSLwdY52gnRb/AfiHnIES
	 DoJ4NgqHGFtbaaj/Opu88JndtyTw0cA7kqs2JDpwQDS0dw4AIFl/eh0ysWt7Gci77S
	 fTfwAKFw5zt+AVX3KjJehAosblvEsLzqJ9a6l1xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1950/2651] irqchip/mips-gic: Fix recursive acquisition of gic_lock in gic_set_affinity()
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150356.779698380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@bootlin.com>

[ Upstream commit 1bae25dcc6beb8b874f23601d2efa142ac4f9f36 ]

Commit 322a90638768 ("irqchip/mips-gic: Multi-cluster support")
made gic_set_affinity() call gic_set_type() when an interrupt's
affinity is moved between clusters. gic_set_type() takes gic_lock with
raw_spin_lock_irqsave(), but gic_set_affinity() holds gic_lock at that
point, so the same raw spinlock is acquired twice, triggering a deadlock.

Split gic_set_type() into a gic_set_type_locked() helper that assumes
gic_lock is already held. gic_set_type() takes gic_lock and calls the
helper, and gic_set_affinity() calls gic_set_type_locked() directly,
since it already holds gic_lock.

Fixes: 322a90638768 ("irqchip/mips-gic: Multi-cluster support")
Signed-off-by: Benoît Monin <benoit.monin@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://patch.msgid.link/20260929-sync-gic-counters-v4-2-ec70c4b60434@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 3b31cbcbed6f3..f2ae60d39d66d 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -297,14 +297,14 @@ static void gic_ack_irq(struct irq_data *d)
 	}
 }
 
-static int gic_set_type(struct irq_data *d, unsigned int type)
+static int gic_set_type_locked(struct irq_data *d, unsigned int type)
 {
 	unsigned int irq, pol, trig, dual;
-	unsigned long flags;
+
+	lockdep_assert_held(&gic_lock);
 
 	irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 
-	raw_spin_lock_irqsave(&gic_lock, flags);
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_FALLING:
 		pol = GIC_POL_FALLING_EDGE;
@@ -351,11 +351,16 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	else
 		irq_set_chip_handler_name_locked(d, &gic_level_irq_controller,
 						 handle_level_irq, NULL);
-	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
 
+static int gic_set_type(struct irq_data *d, unsigned int type)
+{
+	guard(raw_spinlock_irqsave)(&gic_lock);
+	return gic_set_type_locked(d, type);
+}
+
 #ifdef CONFIG_SMP
 static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 			    bool force)
@@ -407,7 +412,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 	 * trigger type in the new cluster.
 	 */
 	if (cl != old_cl)
-		gic_set_type(d, irqd_get_trigger_type(d));
+		gic_set_type_locked(d, irqd_get_trigger_type(d));
 
 	/* Route the interrupt to its new VP(E) */
 	if (gic_irq_lock_cluster(d)) {
-- 
2.53.0



