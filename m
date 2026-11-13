Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590869;
	b=LT6eOlb0nMoV2fUS5DNQ46Wov9lrp1ILDW5gGUZarKU+M8VP1hZKTDur3DO1M7T1Z7ev
	 sjYaqoNmxGD7GYOeRrNu1SD6mDd/4CX67udvgKOGRwCis0A0oQhwMyKh5WXPhgBqU7AE5
	 pMGFscNnsU82Cqvi0Nsj02DZ4aKplXoU9zNG3/D4REo5+u9sz2A9rwy6SzUIp7fUx+9uN
	 HGeZPAKrblqCUFOFU1SVq/8fGWTW5wT+EFS9pD0s6MAUnQwBKXx/5WZO+avsRIKxxX+ml
	 VhVhGBBzj9Y2yH0bJKF5vKJPCVkKOJB8n5rKZOZKcfBjVBA87JX9JXIVcdcKn7EH9hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zwg1PwKH5m5ifzEY41s5HYiocUOF6nCWaqBc3rpKKa4=;
	b=eAb8tBBHBNi2clpnzqwAgSUVKw6ldX/Zz1kLqDvaNVibgGzYi6iiykv6xRILqfI1ERQI
	 cWikGGTgUTgtmTzl6IgrAOhf4Ti7z2IxtYejyPJhFfwhw9FBHtnJ50rtBs1kcUaHMwUL3
	 RQycyuUtNmnRl2AErFHRXAuRDUIfs8G5KjB/rqjwSNXvSYzT+CheyN9EwAiYKIvDvrqcN
	 wlabHayCu752rhRGvTHeiJtAADIEmKmXXEC/Hd4FyJM6MX3opQMurGLNrhpEC69Gu9AdK
	 ZCfPp2PDihZciEENo1NQf6ug+c83rHv6CzZdOhET62rrZUsIKXZbKLwijUzyb0ID5EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gtysE5D8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E4606D857;
	Fri, 13 Nov 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gtysE5D8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDD71F000C4;
	Fri, 13 Nov 2026 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590869;
	bh=zwg1PwKH5m5ifzEY41s5HYiocUOF6nCWaqBc3rpKKa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtysE5D8DwTxvyDxhsMxpP7Lgoc2em7ncAXnPuif9vO4iMw9auNZ3335ywWkpBdkP
	 XMbTqUUQLjettiXAYyQW4gVvF99AoTNIgrkSczBxomp7bY6GhuZzg8KYpTF3wk93Au
	 8rPOwP+RG6UjDXnSb3clV/KXMLy9sZW23RKfzRwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/670] genirq/kexec: Do not take the bus lock of an interrupt chip on the crash path
Date: Fri, 13 Nov 2026 10:43:51 -0500
Message-ID: <20261113153813.782033919@linuxfoundation.org>
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
 kernel/irq/internals.h |  1 +
 kernel/irq/kexec.c     |  2 +-
 kernel/irq/manage.c    | 49 +++++++++++++++++++++---------------------
 3 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 7062a99a1ddd2..0b60f8aa62868 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -77,6 +77,7 @@ enum {
 #include "settings.h"
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned long flags);
+extern int __irq_set_irqchip_state(struct irq_desc *desc, enum irqchip_irq_state which, bool val);
 extern void __disable_irq(struct irq_desc *desc);
 extern void __enable_irq(struct irq_desc *desc);
 
diff --git a/kernel/irq/kexec.c b/kernel/irq/kexec.c
index 0f9548c1708dd..58d92a7f2af1c 100644
--- a/kernel/irq/kexec.c
+++ b/kernel/irq/kexec.c
@@ -25,7 +25,7 @@ void machine_kexec_mask_interrupts(void)
 			 * First try to remove the active state from an interrupt which is forwarded
 			 * to a VM. If the interrupt is not forwarded, try to EOI the interrupt.
 			 */
-			check_eoi = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
+			check_eoi = __irq_set_irqchip_state(desc, IRQCHIP_STATE_ACTIVE, false);
 		}
 
 		if (check_eoi && chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 67b1c5a352014..927a6e52a58c9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2867,6 +2867,28 @@ int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
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
@@ -2883,36 +2905,15 @@ int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
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



