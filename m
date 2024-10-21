Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926471E1C11;
	Mon, 21 Oct 2024 10:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507174; cv=none; b=bOQ47wVHzr/mqM0pS45tIR7JzTS1KfZGQmfCtTIMgodh74/mz8+xj1Pr+diZKC40AAmFqnVM02euQ0L2xejYLaYZjuEgxeUnVtfEL9dTTONaJ/SQi6uRShYWi4d+NSiLSKxgnPWGvWKB2DcOCk4QXeywA3zTe4B/znXnOPQI0Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507174; c=relaxed/simple;
	bh=Dn90KtWzVpluyjLr6aLaT4Z9QmQ47roErxxjL0sgU+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZ2R7ZPkXAeFTFsTQYLr5uAkR3cQuhRbww90V+c91MrncMLREvKuLHHewqAY5Zihe7UOMYUUKVuOSKyPMlyon7y/ul0q3aBCqTZmwyaP8nYijkJbOOMXn3jJ92+OiBVjB+bSNoWmyK9aCIvTNH8XPUtGD4kHE2C6Xjk1JbSSRMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niIqk71p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niIqk71p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F9EC4CEC3;
	Mon, 21 Oct 2024 10:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507174;
	bh=Dn90KtWzVpluyjLr6aLaT4Z9QmQ47roErxxjL0sgU+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niIqk71pH8melbOgCLtIoybTOvZlIcR8LieZKpUPaY3P8jqVlO2qY5WklhJ1aTXc9
	 LgIXkEPsQSCqg37fk6TEx5XGzGHWD6RCJjeyJT3BsGF0ayxukP7gLhGxpYUHhoIqLz
	 gcwpcUtANrEzZbX1K0sQ+2xXw+7RXm4+QlBIzY38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 114/124] irqchip/sifive-plic: Unmask interrupt in plic_irq_enable()
Date: Mon, 21 Oct 2024 12:25:18 +0200
Message-ID: <20241021102301.124736044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nam Cao <namcao@linutronix.de>

commit 6b1e0651e9ce8ce418ad4ff360e7b9925dc5da79 upstream.

It is possible that an interrupt is disabled and masked at the same time.
When the interrupt is enabled again by enable_irq(), only plic_irq_enable()
is called, not plic_irq_unmask(). The interrupt remains masked and never
raises.

An example where interrupt is both disabled and masked is when
handle_fasteoi_irq() is the handler, and IRQS_ONESHOT is set. The interrupt
handler:

  1. Mask the interrupt
  2. Handle the interrupt
  3. Check if interrupt is still enabled, and unmask it (see
     cond_unmask_eoi_irq())

If another task disables the interrupt in the middle of the above steps,
the interrupt will not get unmasked, and will remain masked when it is
enabled in the future.

The problem is occasionally observed when PREEMPT_RT is enabled, because
PREEMPT_RT adds the IRQS_ONESHOT flag. But PREEMPT_RT only makes the problem
more likely to appear, the bug has been around since commit a1706a1c5062
("irqchip/sifive-plic: Separate the enable and mask operations").

Fix it by unmasking interrupt in plic_irq_enable().

Fixes: a1706a1c5062 ("irqchip/sifive-plic: Separate the enable and mask operations")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241003084152.2422969-1-namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-sifive-plic.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -120,16 +120,6 @@ static inline void plic_irq_toggle(const
 	}
 }
 
-static void plic_irq_enable(struct irq_data *d)
-{
-	plic_irq_toggle(irq_data_get_effective_affinity_mask(d), d, 1);
-}
-
-static void plic_irq_disable(struct irq_data *d)
-{
-	plic_irq_toggle(irq_data_get_effective_affinity_mask(d), d, 0);
-}
-
 static void plic_irq_unmask(struct irq_data *d)
 {
 	struct plic_priv *priv = irq_data_get_irq_chip_data(d);
@@ -144,6 +134,17 @@ static void plic_irq_mask(struct irq_dat
 	writel(0, priv->regs + PRIORITY_BASE + d->hwirq * PRIORITY_PER_ID);
 }
 
+static void plic_irq_enable(struct irq_data *d)
+{
+	plic_irq_toggle(irq_data_get_effective_affinity_mask(d), d, 1);
+	plic_irq_unmask(d);
+}
+
+static void plic_irq_disable(struct irq_data *d)
+{
+	plic_irq_toggle(irq_data_get_effective_affinity_mask(d), d, 0);
+}
+
 static void plic_irq_eoi(struct irq_data *d)
 {
 	struct plic_handler *handler = this_cpu_ptr(&plic_handlers);


