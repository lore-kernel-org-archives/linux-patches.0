Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832113A26F;
	Tue, 27 Feb 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043437; cv=none; b=Dj5C2QTvkjE5q29k4yCGBMpdgGzlVyAGXKKQCSIyGSbVjo5ghKO+/9LowFxeRnzyza29/5dS0tDMeyPXczJHqn6hNxqpWp7yP1pURT6smDo8e9LcJZZbSzRTrkjQLOETjtmYfszSATzODQi9nKuWJ90zuJufCyC7FRIKrD8KmBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043437; c=relaxed/simple;
	bh=VsrTB/tql4nkYzusXn+iCSmffjbdlr9OqJIvhRB0OsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvSl4FYPuHs8VIZG2LEn1sKT3iMkGHhhMIPaeGKHsFSNLu/m1g9heRrpBpsnhit/DMsw2to+nCjQ32kzvUbsdyrx16R8CMwPZHIkzrlMDWryB2V6iVTIGajWd22mis59wdMLotJoZnNncoEcZsj3zVOl+U6SDad0u0cqPCBx0+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgn5jNrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgn5jNrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA86EC433C7;
	Tue, 27 Feb 2024 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043437;
	bh=VsrTB/tql4nkYzusXn+iCSmffjbdlr9OqJIvhRB0OsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgn5jNrRtueo3qvqLtmR7duX+rja7D1FUsr4cDpnWyG32pStH6aY7vrANU1MXplgX
	 Z9CT97kTzABKFuWj1yYiJhYqbI7rnKmGOubfpHGzC6vmHEIPeFGnSI6QHuJm7ijdmZ
	 syW4+RMO4qVhff96gxtqrhXZMs4PoqdryY3ZBAQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Samuel Holland <samuel@sholland.org>,
	Marc Zyngier <maz@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	linux-riscv@lists.infradead.org
Subject: [PATCH 6.1 108/195] irqchip/sifive-plic: Enable interrupt if needed before EOI
Date: Tue, 27 Feb 2024 14:26:09 +0100
Message-ID: <20240227131614.031609537@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 9c92006b896c767218aabe8947b62026a571cfd0 upstream.

RISC-V PLIC cannot "end-of-interrupt" (EOI) disabled interrupts, as
explained in the description of Interrupt Completion in the PLIC spec:

"The PLIC signals it has completed executing an interrupt handler by
writing the interrupt ID it received from the claim to the claim/complete
register. The PLIC does not check whether the completion ID is the same
as the last claim ID for that target. If the completion ID does not match
an interrupt source that *is currently enabled* for the target, the
completion is silently ignored."

Commit 69ea463021be ("irqchip/sifive-plic: Fixup EOI failed when masked")
ensured that EOI is successful by enabling interrupt first, before EOI.

Commit a1706a1c5062 ("irqchip/sifive-plic: Separate the enable and mask
operations") removed the interrupt enabling code from the previous
commit, because it assumes that interrupt should already be enabled at the
point of EOI.

However, this is incorrect: there is a window after a hart claiming an
interrupt and before irq_desc->lock getting acquired, interrupt can be
disabled during this window. Thus, EOI can be invoked while the interrupt
is disabled, effectively nullify this EOI. This results in the interrupt
never gets asserted again, and the device who uses this interrupt appears
frozen.

Make sure that interrupt is really enabled before EOI.

Fixes: a1706a1c5062 ("irqchip/sifive-plic: Separate the enable and mask operations")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: linux-riscv@lists.infradead.org
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240131081933.144512-1-namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-sifive-plic.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -144,7 +144,13 @@ static void plic_irq_eoi(struct irq_data
 {
 	struct plic_handler *handler = this_cpu_ptr(&plic_handlers);
 
-	writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+	if (unlikely(irqd_irq_disabled(d))) {
+		plic_toggle(handler, d->hwirq, 1);
+		writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+		plic_toggle(handler, d->hwirq, 0);
+	} else {
+		writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
+	}
 }
 
 #ifdef CONFIG_SMP


