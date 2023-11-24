Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A1039FEE;
	Fri, 24 Nov 2023 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WydUyOie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F68AC433C7;
	Fri, 24 Nov 2023 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848930;
	bh=ReLJT21NZiEhoKT5DMOsnRGagXcgIzs2XhremriLZUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WydUyOie1NdT+C3goKn7FVOXVlabG/lLXms2dEjlUbw5b+F1+Ik2hHuU+N73wmKrL
	 VUhYpniNPeBh7Oqyo1cXEtAmtSZajonY+5mhdNKq8XPHQ4Zl01XT30Bfx6jzlWJbxJ
	 AieqoY7b5ddcI2OOiRwpKe4ybSHZaUDridVODQco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 39/57] genirq/generic_chip: Make irq_remove_generic_chip() irqdomain aware
Date: Fri, 24 Nov 2023 17:51:03 +0000
Message-ID: <20231124171931.747858188@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 5e7afb2eb7b2a7c81e9f608cbdf74a07606fd1b5 upstream.

irq_remove_generic_chip() calculates the Linux interrupt number for removing the
handler and interrupt chip based on gc::irq_base as a linear function of
the bit positions of set bits in the @msk argument.

When the generic chip is present in an irq domain, i.e. created with a call
to irq_alloc_domain_generic_chips(), gc::irq_base contains not the base
Linux interrupt number.  It contains the base hardware interrupt for this
chip. It is set to 0 for the first chip in the domain, 0 + N for the next
chip, where $N is the number of hardware interrupts per chip.

That means the Linux interrupt number cannot be calculated based on
gc::irq_base for irqdomain based chips without a domain map lookup, which
is currently missing.

Rework the code to take the irqdomain case into account and calculate the
Linux interrupt number by a irqdomain lookup of the domain specific
hardware interrupt number.

[ tglx: Massage changelog. Reshuffle the logic and add a proper comment. ]

Fixes: cfefd21e693d ("genirq: Add chip suspend and resume callbacks")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231024150335.322282-1-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/generic-chip.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -533,21 +533,34 @@ EXPORT_SYMBOL_GPL(irq_setup_alt_chip);
 void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			     unsigned int clr, unsigned int set)
 {
-	unsigned int i = gc->irq_base;
+	unsigned int i, virq;
 
 	raw_spin_lock(&gc_lock);
 	list_del(&gc->list);
 	raw_spin_unlock(&gc_lock);
 
-	for (; msk; msk >>= 1, i++) {
+	for (i = 0; msk; msk >>= 1, i++) {
 		if (!(msk & 0x01))
 			continue;
 
+		/*
+		 * Interrupt domain based chips store the base hardware
+		 * interrupt number in gc::irq_base. Otherwise gc::irq_base
+		 * contains the base Linux interrupt number.
+		 */
+		if (gc->domain) {
+			virq = irq_find_mapping(gc->domain, gc->irq_base + i);
+			if (!virq)
+				continue;
+		} else {
+			virq = gc->irq_base + i;
+		}
+
 		/* Remove handler first. That will mask the irq line */
-		irq_set_handler(i, NULL);
-		irq_set_chip(i, &no_irq_chip);
-		irq_set_chip_data(i, NULL);
-		irq_modify_status(i, clr, set);
+		irq_set_handler(virq, NULL);
+		irq_set_chip(virq, &no_irq_chip);
+		irq_set_chip_data(virq, NULL);
+		irq_modify_status(virq, clr, set);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_remove_generic_chip);


