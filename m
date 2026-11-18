Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026877;
	b=Pc6GngHbSr/6MY++TemYcaNObArIFP2gMUj5t5vYlT/FuPUfRiwHT/9II0J5trrAlphu
	 xPSW3xPJYWgQubYi1TGueNtqANLgtTFjq4PbIy9gmP2ZAX1bmBNSvBGv//RUy8ZxpOgo8
	 EhFbdVwWjbLpEw1cKzrT6EC4XUl+gHXbIQNB1csj9TBWx9kHZRot8SMwIkhLv282HvSI2
	 CM7RzmAS1ZV/u47Q3MqdP5yoXnoaoyJR08JUaFAOCvdRikkVMqmhhSRSG/gjPWmTJNWjQ
	 1h+3MO476cXugxWlxm8JCazbSVex2ova1kqqGcDp/t2BOvIr0Pyir9w7if0gPBVevAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ttn3+E+nEs8sVzm2IJIiG8tptD0ZnQaOK3Dym0/wPpA=;
	b=z+fLotOx1Yx0pi58yrHyxdx81zTkcaZzHnGMWXjrJiOyP/HvscevZAt6OA0zm5+KWzIb
	 oDKYc1/0lWoa3rj8EQIS8vNxVJgRCjHINVShBS59q+8jHaQ9VOwtgPLyCNX61PxNzR9Jn
	 hDcOADNqGwhaFXi6DIxvlmcRw0LYCklzYSLS4c7HLnSz6FJgC9SRyvA43xRSoqGPZgI8Y
	 bmXHUOcq861Kk6m7mLxXWRHTY4WkdbzqG0lL77SFEV74ymGiGD86jdvlcN6S3Oa5xYm06
	 x0pbWfW5uDI3bqOyuZb4shjpbBqtqWJDcVdMfmKfCtnIZ02Rzp4ICXoYSw+Ks5FT1Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7XXcRmE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C94606A31C;
	Wed, 18 Nov 2026 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7XXcRmE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990DC1F000C4;
	Wed, 18 Nov 2026 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026877;
	bh=ttn3+E+nEs8sVzm2IJIiG8tptD0ZnQaOK3Dym0/wPpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7XXcRmEoRwXd25tj510OFGXCvupxPZ+dVqa7BU55JY62Y35wb4nNPZ0hNqPfhaNT
	 L50sGCU7Hs7veULccFoDD+CJxPFZNZcLeNXqfh18pG9TGTKd3PZ3OMu8CXowZz35xL
	 jzg/OpT/8eWkjTyMtB7slo3/gjd2RvY1Tcpb2h3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1590/2151] irqchip/mips-gic: Fix recursive acquisition of gic_lock in gic_set_affinity()
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150219.805199726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



