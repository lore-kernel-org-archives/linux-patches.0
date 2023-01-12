Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9A279C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2269BC433D2;
	Thu, 12 Jan 2023 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533219;
	bh=l0YJsElX6GBt25o6kpVSuB7Iw5XqVWFcuYzU4gFsfsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGZHK5hskB/VtCOKbOx8204RVO4oggNKhkTX1ZCsSZQiXIMKD2js9jfbV9ltpVuQt
	 vvRZRNXj7ygUpHjTOBEmZgKPGExBg8Taob7J95vLwm0fPQtWyoOvuHE8MTur/jfy23
	 FfU5eMUoIVeUKRs9YlRBfbvkMlQj0wD7E60IfG5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <song.bao.hua@hisilicon.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	dmitry.torokhov@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/783] genirq: Add IRQF_NO_AUTOEN for request_irq/nmi()
Date: Thu, 12 Jan 2023 14:51:24 +0100
Message-Id: <20230112135541.391994386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Barry Song <song.bao.hua@hisilicon.com>

[ Upstream commit cbe16f35bee6880becca6f20d2ebf6b457148552 ]

Many drivers don't want interrupts enabled automatically via request_irq().
So they are handling this issue by either way of the below two:

(1)
  irq_set_status_flags(irq, IRQ_NOAUTOEN);
  request_irq(dev, irq...);

(2)
  request_irq(dev, irq...);
  disable_irq(irq);

The code in the second way is silly and unsafe. In the small time gap
between request_irq() and disable_irq(), interrupts can still come.

The code in the first way is safe though it's subobtimal.

Add a new IRQF_NO_AUTOEN flag which can be handed in by drivers to
request_irq() and request_nmi(). It prevents the automatic enabling of the
requested interrupt/nmi in the same safe way as #1 above. With that the
various usage sites of #1 and #2 above can be simplified and corrected.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: dmitry.torokhov@gmail.com
Link: https://lore.kernel.org/r/20210302224916.13980-2-song.bao.hua@hisilicon.com
Stable-dep-of: 99c05e4283a1 ("iio: adis: add '__adis_enable_irq()' implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h |  4 ++++
 kernel/irq/manage.c       | 11 +++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index ee8299eb1f52..0652b4858ba6 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -61,6 +61,9 @@
  *                interrupt handler after suspending interrupts. For system
  *                wakeup devices users need to implement wakeup detection in
  *                their interrupt handlers.
+ * IRQF_NO_AUTOEN - Don't enable IRQ or NMI automatically when users request it.
+ *                Users will enable it explicitly by enable_irq() or enable_nmi()
+ *                later.
  */
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
@@ -74,6 +77,7 @@
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
 #define IRQF_COND_SUSPEND	0x00040000
+#define IRQF_NO_AUTOEN		0x00080000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3cb29835632f..437b073dc487 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1667,7 +1667,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
 		}
 
-		if (irq_settings_can_autoenable(desc)) {
+		if (!(new->flags & IRQF_NO_AUTOEN) &&
+		    irq_settings_can_autoenable(desc)) {
 			irq_startup(desc, IRQ_RESEND, IRQ_START_COND);
 		} else {
 			/*
@@ -2054,10 +2055,15 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	 * which interrupt is which (messes up the interrupt freeing
 	 * logic etc).
 	 *
+	 * Also shared interrupts do not go well with disabling auto enable.
+	 * The sharing interrupt might request it while it's still disabled
+	 * and then wait for interrupts forever.
+	 *
 	 * Also IRQF_COND_SUSPEND only makes sense for shared interrupts and
 	 * it cannot be set along with IRQF_NO_SUSPEND.
 	 */
 	if (((irqflags & IRQF_SHARED) && !dev_id) ||
+	    ((irqflags & IRQF_SHARED) && (irqflags & IRQF_NO_AUTOEN)) ||
 	    (!(irqflags & IRQF_SHARED) && (irqflags & IRQF_COND_SUSPEND)) ||
 	    ((irqflags & IRQF_NO_SUSPEND) && (irqflags & IRQF_COND_SUSPEND)))
 		return -EINVAL;
@@ -2213,7 +2219,8 @@ int request_nmi(unsigned int irq, irq_handler_t handler,
 
 	desc = irq_to_desc(irq);
 
-	if (!desc || irq_settings_can_autoenable(desc) ||
+	if (!desc || (irq_settings_can_autoenable(desc) &&
+	    !(irqflags & IRQF_NO_AUTOEN)) ||
 	    !irq_settings_can_request(desc) ||
 	    WARN_ON(irq_settings_is_per_cpu_devid(desc)) ||
 	    !irq_supports_nmi(desc))
-- 
2.35.1



