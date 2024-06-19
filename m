Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB9144D3E;
	Wed, 19 Jun 2024 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803371; cv=none; b=VKhuYiVLnmIrqYDIwfrs6e6a1yY2jaHh+Z9s9brE9a4pzZeZLwnijAkPAq9yTbf8OZWSCle1tpU8dSKlpqSt651RkcYUV1cm2MvDUmM562YVV9JaOdZWt2UdKvtpgX1CjXxvZp4JF3/vGN+SMtWZRSZFps0i0u+dHA4ocPCRKwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803371; c=relaxed/simple;
	bh=USSVEqlWyS3ZvJDjw9CkxHIWzwj/rQNjUmczqRsgKk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbBlZYAVOteaqphLPvaViWsfJHZ3cSQiIFh7t7TaIsmsX08BdI9W3t9WRxzyTIsnFTyHn93GSiv42mjoNJqJWuUDh3UR7JhuOtoGBos6uKlpe4+fKsOtye6V2C0xSPCN3N0znn112AWRgi/yEJvsjyLKzeUI4RUQRZX2lX3XSZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJR90RFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJR90RFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A544BC2BBFC;
	Wed, 19 Jun 2024 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803371;
	bh=USSVEqlWyS3ZvJDjw9CkxHIWzwj/rQNjUmczqRsgKk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJR90RFyHD8mc8j+ccmnYTf4oGnTZKyDDHU3b8nfILiFD1NeGiHmvbhbldmLSmDBx
	 AcZ8hVWE6aj9nVR+S1fADyPVhI2uWFXcPmWfs9DczrVYffVpsVFfX96blmzNnp7r7M
	 A30u3yH0FqPTlgXwE66QSV+HXGKREELsVpwG9MFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.9 213/281] irqchip/sifive-plic: Chain to parent IRQ after handlers are ready
Date: Wed, 19 Jun 2024 14:56:12 +0200
Message-ID: <20240619125618.157085030@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

commit e306a894bd511804ba9db7c00ca9cc05b55df1f2 upstream.

Now that the PLIC uses a platform driver, the driver is probed later in the
boot process, where interrupts from peripherals might already be pending.

As a result, plic_handle_irq() may be called as early as the call to
irq_set_chained_handler() completes. But this call happens before the
per-context handler is completely set up, so there is a window where
plic_handle_irq() can see incomplete per-context state and crash.

Avoid this by delaying the call to irq_set_chained_handler() until all
handlers from all PLICs are initialized.

Fixes: 8ec99b033147 ("irqchip/sifive-plic: Convert PLIC driver into a platform driver")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Anup Patel <anup@brainfault.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240529215458.937817-1-samuel.holland@sifive.com
Closes: https://lore.kernel.org/r/CAMuHMdVYFFR7K5SbHBLY-JHhb7YpgGMS_hnRWm8H0KD-wBo+4A@mail.gmail.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-sifive-plic.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -85,7 +85,7 @@ struct plic_handler {
 	struct plic_priv	*priv;
 };
 static int plic_parent_irq __ro_after_init;
-static bool plic_cpuhp_setup_done __ro_after_init;
+static bool plic_global_setup_done __ro_after_init;
 static DEFINE_PER_CPU(struct plic_handler, plic_handlers);
 
 static int plic_irq_set_type(struct irq_data *d, unsigned int type);
@@ -490,10 +490,8 @@ static int plic_probe(struct platform_de
 	unsigned long plic_quirks = 0;
 	struct plic_handler *handler;
 	u32 nr_irqs, parent_hwirq;
-	struct irq_domain *domain;
 	struct plic_priv *priv;
 	irq_hw_number_t hwirq;
-	bool cpuhp_setup;
 
 	if (is_of_node(dev->fwnode)) {
 		const struct of_device_id *id;
@@ -552,14 +550,6 @@ static int plic_probe(struct platform_de
 			continue;
 		}
 
-		/* Find parent domain and register chained handler */
-		domain = irq_find_matching_fwnode(riscv_get_intc_hwnode(), DOMAIN_BUS_ANY);
-		if (!plic_parent_irq && domain) {
-			plic_parent_irq = irq_create_mapping(domain, RV_IRQ_EXT);
-			if (plic_parent_irq)
-				irq_set_chained_handler(plic_parent_irq, plic_handle_irq);
-		}
-
 		/*
 		 * When running in M-mode we need to ignore the S-mode handler.
 		 * Here we assume it always comes later, but that might be a
@@ -600,25 +590,35 @@ done:
 		goto fail_cleanup_contexts;
 
 	/*
-	 * We can have multiple PLIC instances so setup cpuhp state
+	 * We can have multiple PLIC instances so setup global state
 	 * and register syscore operations only once after context
 	 * handlers of all online CPUs are initialized.
 	 */
-	if (!plic_cpuhp_setup_done) {
-		cpuhp_setup = true;
+	if (!plic_global_setup_done) {
+		struct irq_domain *domain;
+		bool global_setup = true;
+
 		for_each_online_cpu(cpu) {
 			handler = per_cpu_ptr(&plic_handlers, cpu);
 			if (!handler->present) {
-				cpuhp_setup = false;
+				global_setup = false;
 				break;
 			}
 		}
-		if (cpuhp_setup) {
+
+		if (global_setup) {
+			/* Find parent domain and register chained handler */
+			domain = irq_find_matching_fwnode(riscv_get_intc_hwnode(), DOMAIN_BUS_ANY);
+			if (domain)
+				plic_parent_irq = irq_create_mapping(domain, RV_IRQ_EXT);
+			if (plic_parent_irq)
+				irq_set_chained_handler(plic_parent_irq, plic_handle_irq);
+
 			cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
 					  "irqchip/sifive/plic:starting",
 					  plic_starting_cpu, plic_dying_cpu);
 			register_syscore_ops(&plic_irq_syscore_ops);
-			plic_cpuhp_setup_done = true;
+			plic_global_setup_done = true;
 		}
 	}
 


