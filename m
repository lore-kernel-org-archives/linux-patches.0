Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75BD171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B19C433D2;
	Mon, 22 May 2023 19:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782990;
	bh=Wpah7egdx6vP/5IchFJnEfELXuHRoZuJAQBbEZtZdfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMn0mhhdXOMhTIUinJm7d1rD76zKkkbxKLrlHagXQ4CVpQG86IP6qTSgBRmFF3E0i
	 KxrpPio00gKGTdblxAyLPllZkO3J7jFEL0n47JpUoJm4L9pFZeG4cMpXdE053kQzby
	 hWFuZG49aNc4wZ0ojnhoyOhdfx5+IG7N8ecO1REI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jeroen Roovers <jer@xs4all.nl>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/203] parisc: Replace regular spinlock with spin_trylock on panic path
Date: Mon, 22 May 2023 20:08:47 +0100
Message-Id: <20230522190357.834632835@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 829632dae8321787525ee37dc4828bbe6edafdae ]

The panic notifiers' callbacks execute in an atomic context, with
interrupts/preemption disabled, and all CPUs not running the panic
function are off, so it's very dangerous to wait on a regular
spinlock, there's a risk of deadlock.

Refactor the panic notifier of parisc/power driver to make use
of spin_trylock - for that, we've added a second version of the
soft-power function. Also, some comments were reorganized and
trailing white spaces, useless header inclusion and blank lines
were removed.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jeroen Roovers <jer@xs4all.nl>
Acked-by: Helge Deller <deller@gmx.de> # parisc
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/pdc.h |  1 +
 arch/parisc/kernel/firmware.c | 27 +++++++++++++++++++++++----
 drivers/parisc/power.c        | 16 ++++++++++------
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/parisc/include/asm/pdc.h b/arch/parisc/include/asm/pdc.h
index b388d81765883..2f48e0a80d9c6 100644
--- a/arch/parisc/include/asm/pdc.h
+++ b/arch/parisc/include/asm/pdc.h
@@ -81,6 +81,7 @@ int pdc_do_firm_test_reset(unsigned long ftc_bitmap);
 int pdc_do_reset(void);
 int pdc_soft_power_info(unsigned long *power_reg);
 int pdc_soft_power_button(int sw_control);
+int pdc_soft_power_button_panic(int sw_control);
 void pdc_io_reset(void);
 void pdc_io_reset_devices(void);
 int pdc_iodc_getc(void);
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 8e5a906df9175..5385e0fe98426 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1158,15 +1158,18 @@ int __init pdc_soft_power_info(unsigned long *power_reg)
 }
 
 /*
- * pdc_soft_power_button - Control the soft power button behaviour
- * @sw_control: 0 for hardware control, 1 for software control 
+ * pdc_soft_power_button{_panic} - Control the soft power button behaviour
+ * @sw_control: 0 for hardware control, 1 for software control
  *
  *
  * This PDC function places the soft power button under software or
  * hardware control.
- * Under software control the OS may control to when to allow to shut 
- * down the system. Under hardware control pressing the power button 
+ * Under software control the OS may control to when to allow to shut
+ * down the system. Under hardware control pressing the power button
  * powers off the system immediately.
+ *
+ * The _panic version relies on spin_trylock to prevent deadlock
+ * on panic path.
  */
 int pdc_soft_power_button(int sw_control)
 {
@@ -1180,6 +1183,22 @@ int pdc_soft_power_button(int sw_control)
 	return retval;
 }
 
+int pdc_soft_power_button_panic(int sw_control)
+{
+	int retval;
+	unsigned long flags;
+
+	if (!spin_trylock_irqsave(&pdc_lock, flags)) {
+		pr_emerg("Couldn't enable soft power button\n");
+		return -EBUSY; /* ignored by the panic notifier */
+	}
+
+	retval = mem_pdc_call(PDC_SOFT_POWER, PDC_SOFT_POWER_ENABLE, __pa(pdc_result), sw_control);
+	spin_unlock_irqrestore(&pdc_lock, flags);
+
+	return retval;
+}
+
 /*
  * pdc_io_reset - Hack to avoid overlapping range registers of Bridges devices.
  * Primarily a problem on T600 (which parisc-linux doesn't support) but
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index 456776bd8ee66..6f5e5f0230d39 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -37,7 +37,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched/signal.h>
@@ -175,16 +174,21 @@ static void powerfail_interrupt(int code, void *x)
 
 
 
-/* parisc_panic_event() is called by the panic handler.
- * As soon as a panic occurs, our tasklets above will not be
- * executed any longer. This function then re-enables the 
- * soft-power switch and allows the user to switch off the system
+/*
+ * parisc_panic_event() is called by the panic handler.
+ *
+ * As soon as a panic occurs, our tasklets above will not
+ * be executed any longer. This function then re-enables
+ * the soft-power switch and allows the user to switch off
+ * the system. We rely in pdc_soft_power_button_panic()
+ * since this version spin_trylocks (instead of regular
+ * spinlock), preventing deadlocks on panic path.
  */
 static int parisc_panic_event(struct notifier_block *this,
 		unsigned long event, void *ptr)
 {
 	/* re-enable the soft-power switch */
-	pdc_soft_power_button(0);
+	pdc_soft_power_button_panic(0);
 	return NOTIFY_DONE;
 }
 
-- 
2.39.2



