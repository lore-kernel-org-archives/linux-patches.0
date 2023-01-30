Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB43229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C52AC433D2;
	Mon, 30 Jan 2023 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088394;
	bh=/kf3B+xPe72iydFm4rav9awomDkPmHf5K8qGjpi2dBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moEgkL29PKAjd/GS7Ow8dsG/MYTUFMZSg0BP2zaxufi/FO341l5YbWTUVV/OJoAu4
	 llOLAZCz5yn3rXN8MkuKvNIVsSYRIocBU+SQi1ASUNjctMOc70kPSB95QKMRPZvPr9
	 7lv5qz2rVBRWzm1hZjIKntIcDZ2qBBb8x1E/WaI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 202/204] x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL
Date: Mon, 30 Jan 2023 14:52:47 +0100
Message-Id: <20230130134325.426808175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

commit 5fa55950729d0762a787451dc52862c3f850f859 upstream.

Baoquan reported that after triggering a crash the subsequent crash-kernel
fails to boot about half of the time. It triggers a NULL pointer
dereference in the periodic tick code.

This happens because the legacy timer interrupt (IRQ0) is resent in
software which happens in soft interrupt (tasklet) context. In this context
get_irq_regs() returns NULL which leads to the NULL pointer dereference.

The reason for the resend is a spurious APIC interrupt on the IRQ0 vector
which is captured and leads to a resend when the legacy timer interrupt is
enabled. This is wrong because the legacy PIC interrupts are level
triggered and therefore should never be resent in software, but nothing
ever sets the IRQ_LEVEL flag on those interrupts, so the core code does not
know about their trigger type.

Ensure that IRQ_LEVEL is set when the legacy PCI interrupts are set up.

Fixes: a4633adcdbc1 ("[PATCH] genirq: add genirq sw IRQ-retrigger")
Reported-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Baoquan He <bhe@redhat.com>
Link: https://lore.kernel.org/r/87mt6rjrra.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/i8259.c   |    1 +
 arch/x86/kernel/irqinit.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -114,6 +114,7 @@ static void make_8259A_irq(unsigned int
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
 	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
+	irq_set_status_flags(irq, IRQ_LEVEL);
 	enable_irq(irq);
 	lapic_assign_legacy_vector(irq, true);
 }
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -65,8 +65,10 @@ void __init init_ISA_irqs(void)
 
 	legacy_pic->init(0);
 
-	for (i = 0; i < nr_legacy_irqs(); i++)
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		irq_set_chip_and_handler(i, chip, handle_level_irq);
+		irq_set_status_flags(i, IRQ_LEVEL);
+	}
 }
 
 void __init init_IRQ(void)


