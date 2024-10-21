Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF21D1F429E;
	Mon, 21 Oct 2024 10:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506806; cv=none; b=GZlognBzUJfhzCFk4Fo9i7LCo9dDYwlF/VB/zAoYzkFg2Q5XrW9XW4OEqNRuHy6LY7WMd9/5RJ8qqpyzlvPI3TFUY61Bl443Oy3ZRiCvwJG6PFBhIJ/Mzj4hh93UrIpZF9cgQcoM1DnfW2P8XIHO4jLfEY8r43PZv+1m4ENONIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506806; c=relaxed/simple;
	bh=OwuA1SZIgFvmJsaujaG2pSjJb0vLAdDdFhGh6UxL/RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYG4iiOjpXUezMKWWiVzNkKrsunf1uIoIntlr3YKBJSCHgm28ilFgP7bk1pjDPx4httl5HLscN0qODL5yT8kX/AmmdZM1yBeUENl49/rAShYDktLJ59DBBAeNP4rRXOyOhaJQLVkU+3I5Mx4GlZdW1RGcGAZSAG/oheXTc4SMTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1ExPhFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1ExPhFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FADEC4CEEE;
	Mon, 21 Oct 2024 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506806;
	bh=OwuA1SZIgFvmJsaujaG2pSjJb0vLAdDdFhGh6UxL/RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1ExPhFJz0m/d+7BtAfc8XbpvXzaJCci7hrYkVR9mLxLefjNiakaXi0gSFVovBZnd
	 lRD7/4dbEcXMr72HssLmcpUzYkYvWvB3UOQeYcMibqutov/smtVhU0RWrFroh69JiJ
	 DygP/Pv7k5T3+Fv/702gGGbZzVobweBCxinZsjhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.11 127/135] irqchip/sifive-plic: Unmask interrupt in plic_irq_enable()
Date: Mon, 21 Oct 2024 12:24:43 +0200
Message-ID: <20241021102304.311323656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,16 +123,6 @@ static inline void plic_irq_toggle(const
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
@@ -147,6 +137,17 @@ static void plic_irq_mask(struct irq_dat
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


