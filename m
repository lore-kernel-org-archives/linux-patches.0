Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7A1C433D2;
	Mon, 16 Jan 2023 16:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886214;
	bh=fB8yGnaaX2amwdCOVR52A2gAn31TlLkiNTn9seiyPLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cm5+F3nN8myRQsVLgP28f1ti3ScLTL7b9C5Jy/8h/jC5Wpf6ubr9i1tOnnO7NmLR3
	 2EwHHOrM+KPF5efZEQEopHxsVf6ZY1G9QkliITzEfFYAcyvj0/nMAkpd0G7pvZtES1
	 QAIefsV8BGfDbNC+zSdh6iaOcccKtrklroBZK13Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 344/658] rtc: cmos: Eliminate forward declarations of some functions
Date: Mon, 16 Jan 2023 16:47:12 +0100
Message-Id: <20230116154925.300170732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit dca4d3b71c8a09a16951add656711fbd6f5bfbb0 ]

Reorder the ACPI-related code before cmos_do_probe() so as to eliminate
excessive forward declarations of some functions.

While at it, for consistency, add the inline modifier to the
definitions of empty stub static funtions and remove it from the
corresponding definitions of functions with non-empty bodies.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/13157911.uLZWGnKmhe@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 304 ++++++++++++++++++++---------------------
 1 file changed, 149 insertions(+), 155 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 27150d86f5ed..bc8f65014025 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -698,8 +698,155 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 		return IRQ_NONE;
 }
 
-static inline void rtc_wake_setup(struct device *dev);
-static void cmos_wake_setup(struct device *dev);
+#ifdef	CONFIG_ACPI
+
+#include <linux/acpi.h>
+
+static u32 rtc_handler(void *context)
+{
+	struct device *dev = context;
+	struct cmos_rtc *cmos = dev_get_drvdata(dev);
+	unsigned char rtc_control = 0;
+	unsigned char rtc_intr;
+	unsigned long flags;
+
+
+	/*
+	 * Always update rtc irq when ACPI is used as RTC Alarm.
+	 * Or else, ACPI SCI is enabled during suspend/resume only,
+	 * update rtc irq in that case.
+	 */
+	if (cmos_use_acpi_alarm())
+		cmos_interrupt(0, (void *)cmos->rtc);
+	else {
+		/* Fix me: can we use cmos_interrupt() here as well? */
+		spin_lock_irqsave(&rtc_lock, flags);
+		if (cmos_rtc.suspend_ctrl)
+			rtc_control = CMOS_READ(RTC_CONTROL);
+		if (rtc_control & RTC_AIE) {
+			cmos_rtc.suspend_ctrl &= ~RTC_AIE;
+			CMOS_WRITE(rtc_control, RTC_CONTROL);
+			rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
+			rtc_update_irq(cmos->rtc, 1, rtc_intr);
+		}
+		spin_unlock_irqrestore(&rtc_lock, flags);
+	}
+
+	pm_wakeup_hard_event(dev);
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+	return ACPI_INTERRUPT_HANDLED;
+}
+
+static void rtc_wake_setup(struct device *dev)
+{
+	if (acpi_disabled)
+		return;
+
+	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
+	/*
+	 * After the RTC handler is installed, the Fixed_RTC event should
+	 * be disabled. Only when the RTC alarm is set will it be enabled.
+	 */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+}
+
+static void rtc_wake_on(struct device *dev)
+{
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_enable_event(ACPI_EVENT_RTC, 0);
+}
+
+static void rtc_wake_off(struct device *dev)
+{
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+}
+
+#ifdef CONFIG_X86
+/* Enable use_acpi_alarm mode for Intel platforms no earlier than 2015 */
+static void use_acpi_alarm_quirks(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
+
+	if (!is_hpet_enabled())
+		return;
+
+	if (dmi_get_bios_year() < 2015)
+		return;
+
+	use_acpi_alarm = true;
+}
+#else
+static inline void use_acpi_alarm_quirks(void) { }
+#endif
+
+static void cmos_wake_setup(struct device *dev)
+{
+	if (acpi_disabled)
+		return;
+
+	use_acpi_alarm_quirks();
+
+	cmos_rtc.wake_on = rtc_wake_on;
+	cmos_rtc.wake_off = rtc_wake_off;
+
+	/* ACPI tables bug workaround. */
+	if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
+		dev_dbg(dev, "bogus FADT month_alarm (%d)\n",
+			acpi_gbl_FADT.month_alarm);
+		acpi_gbl_FADT.month_alarm = 0;
+	}
+
+	cmos_rtc.day_alrm = acpi_gbl_FADT.day_alarm;
+	cmos_rtc.mon_alrm = acpi_gbl_FADT.month_alarm;
+	cmos_rtc.century = acpi_gbl_FADT.century;
+
+	if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
+		dev_info(dev, "RTC can wake from S4\n");
+
+	/* RTC always wakes from S1/S2/S3, and often S4/STD */
+	device_init_wakeup(dev, 1);
+}
+
+static void cmos_check_acpi_rtc_status(struct device *dev,
+					      unsigned char *rtc_control)
+{
+	struct cmos_rtc *cmos = dev_get_drvdata(dev);
+	acpi_event_status rtc_status;
+	acpi_status status;
+
+	if (acpi_gbl_FADT.flags & ACPI_FADT_FIXED_RTC)
+		return;
+
+	status = acpi_get_event_status(ACPI_EVENT_RTC, &rtc_status);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "Could not get RTC status\n");
+	} else if (rtc_status & ACPI_EVENT_FLAG_SET) {
+		unsigned char mask;
+		*rtc_control &= ~RTC_AIE;
+		CMOS_WRITE(*rtc_control, RTC_CONTROL);
+		mask = CMOS_READ(RTC_INTR_FLAGS);
+		rtc_update_irq(cmos->rtc, 1, mask);
+	}
+}
+
+#else /* !CONFIG_ACPI */
+
+static inline void rtc_wake_setup(struct device *dev)
+{
+}
+
+static inline void cmos_wake_setup(struct device *dev)
+{
+}
+
+static inline void cmos_check_acpi_rtc_status(struct device *dev,
+					      unsigned char *rtc_control)
+{
+}
+#endif /* CONFIG_ACPI */
 
 #ifdef	CONFIG_PNP
 #define	INITSECTION
@@ -1083,9 +1230,6 @@ static void cmos_check_wkalrm(struct device *dev)
 	}
 }
 
-static void cmos_check_acpi_rtc_status(struct device *dev,
-				       unsigned char *rtc_control);
-
 static int __maybe_unused cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -1152,156 +1296,6 @@ static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
  * predate even PNPBIOS should set up platform_bus devices.
  */
 
-#ifdef	CONFIG_ACPI
-
-#include <linux/acpi.h>
-
-static u32 rtc_handler(void *context)
-{
-	struct device *dev = context;
-	struct cmos_rtc *cmos = dev_get_drvdata(dev);
-	unsigned char rtc_control = 0;
-	unsigned char rtc_intr;
-	unsigned long flags;
-
-
-	/*
-	 * Always update rtc irq when ACPI is used as RTC Alarm.
-	 * Or else, ACPI SCI is enabled during suspend/resume only,
-	 * update rtc irq in that case.
-	 */
-	if (cmos_use_acpi_alarm())
-		cmos_interrupt(0, (void *)cmos->rtc);
-	else {
-		/* Fix me: can we use cmos_interrupt() here as well? */
-		spin_lock_irqsave(&rtc_lock, flags);
-		if (cmos_rtc.suspend_ctrl)
-			rtc_control = CMOS_READ(RTC_CONTROL);
-		if (rtc_control & RTC_AIE) {
-			cmos_rtc.suspend_ctrl &= ~RTC_AIE;
-			CMOS_WRITE(rtc_control, RTC_CONTROL);
-			rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-			rtc_update_irq(cmos->rtc, 1, rtc_intr);
-		}
-		spin_unlock_irqrestore(&rtc_lock, flags);
-	}
-
-	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
-	return ACPI_INTERRUPT_HANDLED;
-}
-
-static inline void rtc_wake_setup(struct device *dev)
-{
-	if (acpi_disabled)
-		return;
-
-	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
-	/*
-	 * After the RTC handler is installed, the Fixed_RTC event should
-	 * be disabled. Only when the RTC alarm is set will it be enabled.
-	 */
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
-}
-
-static void rtc_wake_on(struct device *dev)
-{
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_enable_event(ACPI_EVENT_RTC, 0);
-}
-
-static void rtc_wake_off(struct device *dev)
-{
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
-}
-
-#ifdef CONFIG_X86
-/* Enable use_acpi_alarm mode for Intel platforms no earlier than 2015 */
-static void use_acpi_alarm_quirks(void)
-{
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
-		return;
-
-	if (!is_hpet_enabled())
-		return;
-
-	if (dmi_get_bios_year() < 2015)
-		return;
-
-	use_acpi_alarm = true;
-}
-#else
-static inline void use_acpi_alarm_quirks(void) { }
-#endif
-
-static void cmos_wake_setup(struct device *dev)
-{
-	if (acpi_disabled)
-		return;
-
-	use_acpi_alarm_quirks();
-
-	cmos_rtc.wake_on = rtc_wake_on;
-	cmos_rtc.wake_off = rtc_wake_off;
-
-	/* ACPI tables bug workaround. */
-	if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
-		dev_dbg(dev, "bogus FADT month_alarm (%d)\n",
-			acpi_gbl_FADT.month_alarm);
-		acpi_gbl_FADT.month_alarm = 0;
-	}
-
-	cmos_rtc.day_alrm = acpi_gbl_FADT.day_alarm;
-	cmos_rtc.mon_alrm = acpi_gbl_FADT.month_alarm;
-	cmos_rtc.century = acpi_gbl_FADT.century;
-
-	if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
-		dev_info(dev, "RTC can wake from S4\n");
-
-	/* RTC always wakes from S1/S2/S3, and often S4/STD */
-	device_init_wakeup(dev, 1);
-}
-
-static void cmos_check_acpi_rtc_status(struct device *dev,
-				       unsigned char *rtc_control)
-{
-	struct cmos_rtc *cmos = dev_get_drvdata(dev);
-	acpi_event_status rtc_status;
-	acpi_status status;
-
-	if (acpi_gbl_FADT.flags & ACPI_FADT_FIXED_RTC)
-		return;
-
-	status = acpi_get_event_status(ACPI_EVENT_RTC, &rtc_status);
-	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "Could not get RTC status\n");
-	} else if (rtc_status & ACPI_EVENT_FLAG_SET) {
-		unsigned char mask;
-		*rtc_control &= ~RTC_AIE;
-		CMOS_WRITE(*rtc_control, RTC_CONTROL);
-		mask = CMOS_READ(RTC_INTR_FLAGS);
-		rtc_update_irq(cmos->rtc, 1, mask);
-	}
-}
-
-#else
-
-static void cmos_wake_setup(struct device *dev)
-{
-}
-
-static void cmos_check_acpi_rtc_status(struct device *dev,
-				       unsigned char *rtc_control)
-{
-}
-
-static void rtc_wake_setup(struct device *dev)
-{
-}
-#endif
-
 #ifdef	CONFIG_PNP
 
 #include <linux/pnp.h>
-- 
2.35.1



