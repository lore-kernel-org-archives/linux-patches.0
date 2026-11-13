Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591469;
	b=Cv/lwW0ISfZDbixT4/s75FPjqgef7qvEoyp+8oUd8rnti9YUSNVbl3vRrcMuEsIeGAN0
	 GxBP1lFViopptMmU9s9yQ2KYK4yXV3YCTW6pcJ7w0hCq813SuQSA8B6BxP+E4VQ5YCqWA
	 BSmCuLHUambti9pLmNvzt8RKaBjz+ju0SFgzuyuqpZIkOIFivFkaK+ayoID0Wb8gMzLjw
	 SuuXMAGoWGVWLYWjApvlpJoX84hZY9aJItsPrlNcApfoA8YgqQUb8NKOOo/gQ4zBiseOD
	 taTYgnucNHWJ5ShTSRlgt1ozwcF7Qsi7SVHvFT1Mn0jISikQIGSzX2LgFZGY7wmqXxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VrAUbbrPaoXKLQARwtFFwF0qMbpX49c52JIedbC/z0o=;
	b=iCpkfR8xVpMUoAPWtL3dok44mhtq06fpyDxu9Rv6Ecgw8OxSJJQ2Vo88+0OWN65szkYu
	 f0KvKBxPDmleEFN4coGpcLAG+HZJLYkrnhAZnQrU699VI1XXkjfSW1jAnHK/JqfNWFSob
	 O0Sm4+yDAFmjDY6UlhrQHhWPZ3CvI2pPTuhzirtbzDqVsBN8jFAj6RazjLJD2vnATJ1qz
	 IkAudDLOGxtPIynYdctcuyfqVSZfRv9WJnSEoCXgX1H6K9pth6ltpvyeTYM5UjndCbfrO
	 qnNucqp2haRAMQX77DcNfPJDAJnJ8CHf7Bv8hxvsmFPAmbunaeGcfm08hOylVbA0qgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtLjzH6X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59A607D2D1;
	Fri, 13 Nov 2026 17:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtLjzH6X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499971F000C4;
	Fri, 13 Nov 2026 17:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591469;
	bh=VrAUbbrPaoXKLQARwtFFwF0qMbpX49c52JIedbC/z0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtLjzH6XTsx22OUQmAtBDQN3lnIiup0t5PetIiepyossf9WFBoqVpz0i9JwiQ2WaJ
	 nHmniC/nZeaV9U+gMVmNpeAmvNF3tt0wSjY3TPzyxnyDbUWLrl5nk16pKB0K5kpmhG
	 ZI99ZkdUOQxCVmK0P+d47JHgGNetJkx+Z9FeBBt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 553/670] irqchip/atmel-aic[5]: Disable interrupts in the irq_pm_shutdown() callbacks
Date: Fri, 13 Nov 2026 10:51:57 -0500
Message-ID: <20261113153830.622290048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0ca21fe111457c843624a835641bb490e704bb2f ]

irq_gc_shutdown() calls the irq_pm_shutdown() callbacks from
syscore_shutdown() with interrupts enabled. aic_pm_shutdown() and
aic5_pm_shutdown() take the generic chip lock with raw_spin_lock(), and
irq_gc_eoi() takes the same lock from the interrupt handler. An
interrupt from the chip while the lock is held spins in irq_gc_eoi()
and hangs the reboot.

Lockdep reports this on every reboot of a SAM9X75 Curiosity board:

  WARNING: inconsistent lock state
  inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
  busybox/101 [HC0[0]:SC0[0]:HE1:SE1] takes:
  c1c2b434 (&gc->lock){?.-.}-{2:2}, at: aic5_pm_shutdown+0x34/0xd8
  {IN-HARDIRQ-W} state was registered at:
    ...
    irq_gc_eoi+0x28/0x60
    handle_fasteoi_irq+0x120/0x214
  ...
   aic5_pm_shutdown from irq_gc_shutdown+0x4c/0x58
   irq_gc_shutdown from syscore_shutdown+0x5c/0x9c
   syscore_shutdown from kernel_restart+0x34/0x78
   kernel_restart from sys_reboot+0x180/0x25c

Use the irqsave guard, as
commit 33517881ede7 ("irqchip/brcmstb-l2: Use _irqsave locking variants in non-interrupt code")
did for brcmstb-l2.

Fixes: b1479ebb7720 ("irqchip: atmel-aic: Add atmel AIC/AIC5 drivers")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Reviewed-by: Radu Rendec <radu@rendec.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926004124.88221-1-kmehltretter@gmail.com
[ sashal: Replaced scoped irqsave guards with explicit irq_gc_lock_irqsave()/irq_gc_unlock_irqrestore() pairs using local flags. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-atmel-aic.c  | 5 +++--
 drivers/irqchip/irq-atmel-aic5.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 3839ad79ad31d..46c1b380c6040 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -125,11 +125,12 @@ static void aic_resume(struct irq_data *d)
 static void aic_pm_shutdown(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
 
-	irq_gc_lock(gc);
+	irq_gc_lock_irqsave(gc, flags);
 	irq_reg_writel(gc, 0xffffffff, AT91_AIC_IDCR);
 	irq_reg_writel(gc, 0xffffffff, AT91_AIC_ICCR);
-	irq_gc_unlock(gc);
+	irq_gc_unlock_irqrestore(gc, flags);
 }
 #else
 #define aic_suspend		NULL
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index c0f55dc7b050d..28dd53df0d7eb 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -223,15 +223,16 @@ static void aic5_pm_shutdown(struct irq_data *d)
 	struct irq_domain_chip_generic *dgc = domain->gc;
 	struct irq_chip_generic *bgc = irq_get_domain_generic_chip(domain, 0);
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
 	int i;
 
-	irq_gc_lock(bgc);
+	irq_gc_lock_irqsave(bgc, flags);
 	for (i = 0; i < dgc->irqs_per_chip; i++) {
 		irq_reg_writel(bgc, i + gc->irq_base, AT91_AIC5_SSR);
 		irq_reg_writel(bgc, 1, AT91_AIC5_IDCR);
 		irq_reg_writel(bgc, 1, AT91_AIC5_ICCR);
 	}
-	irq_gc_unlock(bgc);
+	irq_gc_unlock_irqrestore(bgc, flags);
 }
 #else
 #define aic5_suspend		NULL
-- 
2.53.0



