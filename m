Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037967;
	b=B4sWB/sr0qUwtnzlk/1WE17Gp2ATwCU1yxEFGLZHWDz1ddzmGCS1U1n90z+RMR7dUMtz
	 YreD+kiOVVQy9zDt9YTAAf23al4x9FeadPXGRlkrFkBigHhbOY8mgMwE2fYRJZvcDX3x2
	 3X/8nwBGMkAmgCQMa7/19pRPn/TlHza0CpAIRlJ2FhXbPlmBP3C+JDU8JOwcwrvG6YGbT
	 DH6SpY15vV5ziSlbY0Wws9JHfAtwG541l7ltoP5FtO24XPWRbGJ2mr4WwOAUWWwNLAvVx
	 j+4iSHRkKvXiiVwsXFaSy33ypDW/1DIBO5H+dDoPZwPFKGVvU8XxAkKjNeI4Nn9u32Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6b8tMLzbmUiYw3TDP6buGfddiyfnZ3E91Zk+ARRn6Q=;
	b=JPw47+S6IOfVyyV9ZW9eXYAcPqlUUkfGyA9S5mXF5AOoQMkZM9zbCrodXSp3Fed3cutH
	 NcO3MO5y3BaNxtCzDGVkq/ku5eMoeWZUvsB7774gwnL+1dU63WnQVJjfHxqzOsKLfxhHx
	 ZdgQAcKdXUTPxI929CQvkB/jaHASRiuN0Ynbr8dpAn4vMXoqTAyc1T81rk5vZG3Y1ls/c
	 aAHUbw6GT3sBhDNDPJz9qBWwz1SfbwSeMkdpe9BidQBiGXPo85UY4Q8oKeiFGkaD9pAXH
	 vtebrjTV4eYtG1gimoKU4dwSJ4ptNbQ5oQz29o+L8wzQs/9dSYKyaHdein+Byht8eDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZR3F1uCV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716B606A32C;
	Wed, 18 Nov 2026 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZR3F1uCV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C8E1F000C4;
	Wed, 18 Nov 2026 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037967;
	bh=F6b8tMLzbmUiYw3TDP6buGfddiyfnZ3E91Zk+ARRn6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR3F1uCVdC1ptPlLeZfW6Y8Gg5219lzuxfK/1oEEzE2d95UFveQ7cOdRgO44oE0pN
	 hbj8Evo9mViWtvbhPv0312JVLz40BqDLQJNW8DcSoEOx/CmsIGDJKl4JVjgmHko8yp
	 9h+ngUzNNjjRmBl16btXw2qqTOIEFpGdYKDJoqHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1580/3318] genirq/kexec: Do not take the bus lock of an interrupt chip on the crash path
Date: Wed, 18 Nov 2026 15:36:42 +0100
Message-ID: <20261118150408.517827796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 717862eac6eff0eea8ac30a0c0de0bed84922aab upstream.

machine_kexec_mask_interrupts() calls irq_set_irqchip_state() for every
started interrupt. That function takes the bus lock of the chip and
desc->lock, and syncs the chip when it drops them. On the crash path
interrupts are off and the other CPUs are stopped, so a chip whose bus
transfer is completed by an interrupt never returns from the sync.

On RK3399 boards with an RK808 PMIC the RTC alarm interrupt belongs to
the regmap-irq chip of the RK808, which sits on I2C. rk808_irq_chip sets
init_ack_masked, so regmap_irq_sync_unlock() writes the ack register on
every unlock, and the I2C controller needs its own interrupt to finish
the transfer. A panic with a crash kernel loaded prints

  SMP: stopping secondary CPUs

and then nothing until the watchdog resets the board.

machine_kexec_mask_interrupts() takes neither lock for the other
operations on the descriptor. Move the search for the chip that
implements irq_set_irqchip_state() into __irq_set_irqchip_state(), which
takes no locks, and call it from machine_kexec_mask_interrupts().

Fixes: 78fd584cdec0 ("arm64: kdump: implement machine_crash_shutdown()")
Suggested-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Igor Velkov <iav@iav.lv>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015-kexec-irq-bus-lock-v2-1-2af15f0757b6@iav.lv
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec.c |  2 +-
 include/linux/interrupt.h         |  1 +
 kernel/irq/manage.c               | 49 ++++++++++++++++---------------
 3 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 9307a1421d67e..ece524271b964 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -235,7 +235,7 @@ static void machine_kexec_mask_interrupts(void)
 		 * First try to remove the active state. If this
 		 * fails, try to EOI the interrupt.
 		 */
-		ret = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
+		ret = __irq_set_irqchip_state(desc, IRQCHIP_STATE_ACTIVE, false);
 
 		if (ret && irqd_irq_inprogress(&desc->irq_data) &&
 		    chip->irq_eoi)
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a42191c6a0e87..2d1dd4a86e49c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -507,6 +507,7 @@ extern int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool *state);
 extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 				 bool state);
+extern int __irq_set_irqchip_state(struct irq_desc *desc, enum irqchip_irq_state which, bool val);
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifdef CONFIG_PREEMPT_RT
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4b976a8fc0698..a67e40c8ce62d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2864,6 +2864,28 @@ int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 }
 EXPORT_SYMBOL_GPL(irq_get_irqchip_state);
 
+int __irq_set_irqchip_state(struct irq_desc *desc, enum irqchip_irq_state which, bool val)
+{
+	struct irq_data *data = irq_desc_get_irq_data(desc);
+	struct irq_chip *chip;
+
+	do {
+		chip = irq_data_get_irq_chip(data);
+
+		if (WARN_ON_ONCE(!chip))
+			return -ENODEV;
+
+		if (chip->irq_set_irqchip_state)
+			break;
+
+		data = irqd_get_parent_data(data);
+	} while (data);
+
+	if (data)
+		return chip->irq_set_irqchip_state(data, which, val);
+	return -EINVAL;
+}
+
 /**
  *	irq_set_irqchip_state - set the state of a forwarded interrupt.
  *	@irq: Interrupt line that is forwarded to a VM
@@ -2880,36 +2902,15 @@ int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 			  bool val)
 {
 	struct irq_desc *desc;
-	struct irq_data *data;
-	struct irq_chip *chip;
 	unsigned long flags;
-	int err = -EINVAL;
+	int err;
 
 	desc = irq_get_desc_buslock(irq, &flags, 0);
 	if (!desc)
-		return err;
-
-	data = irq_desc_get_irq_data(desc);
-
-	do {
-		chip = irq_data_get_irq_chip(data);
-		if (WARN_ON_ONCE(!chip)) {
-			err = -ENODEV;
-			goto out_unlock;
-		}
-		if (chip->irq_set_irqchip_state)
-			break;
-#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
-		data = data->parent_data;
-#else
-		data = NULL;
-#endif
-	} while (data);
+		return -EINVAL;
 
-	if (data)
-		err = chip->irq_set_irqchip_state(data, which, val);
+	err = __irq_set_irqchip_state(desc, which, val);
 
-out_unlock:
 	irq_put_desc_busunlock(desc, flags);
 	return err;
 }
-- 
2.53.0



