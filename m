Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A760772249;
	Mon, 29 Jan 2024 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548511; cv=none; b=mFSKBNATwHrYVhvLLpdHXvEgf7H7/rLJBq3hf25aqxvbpcPgIePFk7QlgFXd0pjZqSQIcvIa1IbECFquuuZRzph+cGGCDZxgcooeEPJ3iyyweaEh7r3idsEqRZKqtuzkClcIRfDME0yTq5heZf+aC6phDQMM0rS3FdtyNag6Znw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548511; c=relaxed/simple;
	bh=vzFFiTzUtbGCub46isnVihGs+byhIog1+WoAZW8dRgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nes0PdAn7ijvgbYHghCzRWJLhoAyaNnbQ/Ec4o9vBepe0kZ+Kca2Ls0x4dU+F8peyEY8XMy55S9cCXnZRs+BGwoZVPtVZejpUT9Lbu7j6VSlfLuDdVQ5iIXHw44fn8TrEl34wFO2tEWjzp8TQL+5lUHDcMCY93FKBSfuL0D6hV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUd49nah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUd49nah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E0C433C7;
	Mon, 29 Jan 2024 17:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548511;
	bh=vzFFiTzUtbGCub46isnVihGs+byhIog1+WoAZW8dRgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUd49nahlzlNtX0i7hCk280O1/dkExTFnvI8Z/DNg9gctlB4nW2ETnYiO//rldHHR
	 VDvSRIXeqQKyNFY0qeo3jXMxd08FLBjYWhsOKj54Fxi2F99LJ8w+YbcF9O8/26AOEw
	 cIhPivcaZOuiScD60X3r9R/kHpEYYcUaPWklXm+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 118/331] rtc: Add support for configuring the UIP timeout for RTC reads
Date: Mon, 29 Jan 2024 09:03:02 -0800
Message-ID: <20240129170018.382913339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 120931db07b49252aba2073096b595482d71857c upstream.

The UIP timeout is hardcoded to 10ms for all RTC reads, but in some
contexts this might not be enough time. Add a timeout parameter to
mc146818_get_time() and mc146818_get_time_callback().

If UIP timeout is configured by caller to be >=100 ms and a call
takes this long, log a warning.

Make all callers use 10ms to ensure no functional changes.

Cc:  <stable@vger.kernel.org> # 6.1.y
Fixes: ec5895c0f2d8 ("rtc: mc146818-lib: extract mc146818_avoid_UIP")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Link: https://lore.kernel.org/r/20231128053653.101798-4-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/rtc.c        |    2 +-
 arch/x86/kernel/hpet.c         |    2 +-
 arch/x86/kernel/rtc.c          |    2 +-
 drivers/base/power/trace.c     |    2 +-
 drivers/rtc/rtc-cmos.c         |    6 +++---
 drivers/rtc/rtc-mc146818-lib.c |   37 +++++++++++++++++++++++++++++--------
 include/linux/mc146818rtc.h    |    3 ++-
 7 files changed, 38 insertions(+), 16 deletions(-)

--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -80,7 +80,7 @@ init_rtc_epoch(void)
 static int
 alpha_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	int ret = mc146818_get_time(tm);
+	int ret = mc146818_get_time(tm, 10);
 
 	if (ret < 0) {
 		dev_err_ratelimited(dev, "unable to read current time\n");
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1438,7 +1438,7 @@ irqreturn_t hpet_rtc_interrupt(int irq,
 	memset(&curr_time, 0, sizeof(struct rtc_time));
 
 	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE)) {
-		if (unlikely(mc146818_get_time(&curr_time) < 0)) {
+		if (unlikely(mc146818_get_time(&curr_time, 10) < 0)) {
 			pr_err_ratelimited("unable to read current time from RTC\n");
 			return IRQ_HANDLED;
 		}
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -67,7 +67,7 @@ void mach_get_cmos_time(struct timespec6
 		return;
 	}
 
-	if (mc146818_get_time(&tm)) {
+	if (mc146818_get_time(&tm, 10)) {
 		pr_err("Unable to read current time from RTC\n");
 		now->tv_sec = now->tv_nsec = 0;
 		return;
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -120,7 +120,7 @@ static unsigned int read_magic_time(void
 	struct rtc_time time;
 	unsigned int val;
 
-	if (mc146818_get_time(&time) < 0) {
+	if (mc146818_get_time(&time, 10) < 0) {
 		pr_err("Unable to read current time from RTC\n");
 		return 0;
 	}
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -231,7 +231,7 @@ static int cmos_read_time(struct device
 	if (!pm_trace_rtc_valid())
 		return -EIO;
 
-	ret = mc146818_get_time(t);
+	ret = mc146818_get_time(t, 10);
 	if (ret < 0) {
 		dev_err_ratelimited(dev, "unable to read current time\n");
 		return ret;
@@ -307,7 +307,7 @@ static int cmos_read_alarm(struct device
 	 *
 	 * Use the mc146818_avoid_UIP() function to avoid this.
 	 */
-	if (!mc146818_avoid_UIP(cmos_read_alarm_callback, &p))
+	if (!mc146818_avoid_UIP(cmos_read_alarm_callback, 10, &p))
 		return -EIO;
 
 	if (!(p.rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
@@ -556,7 +556,7 @@ static int cmos_set_alarm(struct device
 	 *
 	 * Use mc146818_avoid_UIP() to avoid this.
 	 */
-	if (!mc146818_avoid_UIP(cmos_set_alarm_callback, &p))
+	if (!mc146818_avoid_UIP(cmos_set_alarm_callback, 10, &p))
 		return -ETIMEDOUT;
 
 	cmos->alarm_expires = rtc_tm_to_time64(&t->time);
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,26 +8,31 @@
 #include <linux/acpi.h>
 #endif
 
+#define UIP_RECHECK_DELAY		100	/* usec */
+#define UIP_RECHECK_DELAY_MS		(USEC_PER_MSEC / UIP_RECHECK_DELAY)
+#define UIP_RECHECK_LOOPS_MS(x)		(x / UIP_RECHECK_DELAY_MS)
+
 /*
  * Execute a function while the UIP (Update-in-progress) bit of the RTC is
- * unset.
+ * unset. The timeout is configurable by the caller in ms.
  *
  * Warning: callback may be executed more then once.
  */
 bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
+			int timeout,
 			void *param)
 {
 	int i;
 	unsigned long flags;
 	unsigned char seconds;
 
-	for (i = 0; i < 100; i++) {
+	for (i = 0; UIP_RECHECK_LOOPS_MS(i) < timeout; i++) {
 		spin_lock_irqsave(&rtc_lock, flags);
 
 		/*
 		 * Check whether there is an update in progress during which the
 		 * readout is unspecified. The maximum update time is ~2ms. Poll
-		 * every 100 usec for completion.
+		 * for completion.
 		 *
 		 * Store the second value before checking UIP so a long lasting
 		 * NMI which happens to hit after the UIP check cannot make
@@ -37,7 +42,7 @@ bool mc146818_avoid_UIP(void (*callback)
 
 		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
 			spin_unlock_irqrestore(&rtc_lock, flags);
-			udelay(100);
+			udelay(UIP_RECHECK_DELAY);
 			continue;
 		}
 
@@ -56,7 +61,7 @@ bool mc146818_avoid_UIP(void (*callback)
 		 */
 		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
 			spin_unlock_irqrestore(&rtc_lock, flags);
-			udelay(100);
+			udelay(UIP_RECHECK_DELAY);
 			continue;
 		}
 
@@ -72,6 +77,10 @@ bool mc146818_avoid_UIP(void (*callback)
 		}
 		spin_unlock_irqrestore(&rtc_lock, flags);
 
+		if (UIP_RECHECK_LOOPS_MS(i) >= 100)
+			pr_warn("Reading current time from RTC took around %li ms\n",
+				UIP_RECHECK_LOOPS_MS(i));
+
 		return true;
 	}
 	return false;
@@ -84,7 +93,7 @@ EXPORT_SYMBOL_GPL(mc146818_avoid_UIP);
  */
 bool mc146818_does_rtc_work(void)
 {
-	return mc146818_avoid_UIP(NULL, NULL);
+	return mc146818_avoid_UIP(NULL, 10, NULL);
 }
 EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
 
@@ -130,13 +139,25 @@ static void mc146818_get_time_callback(u
 	p->ctrl = CMOS_READ(RTC_CONTROL);
 }
 
-int mc146818_get_time(struct rtc_time *time)
+/**
+ * mc146818_get_time - Get the current time from the RTC
+ * @time: pointer to struct rtc_time to store the current time
+ * @timeout: timeout value in ms
+ *
+ * This function reads the current time from the RTC and stores it in the
+ * provided struct rtc_time. The timeout parameter specifies the maximum
+ * time to wait for the RTC to become ready.
+ *
+ * Return: 0 on success, -ETIMEDOUT if the RTC did not become ready within
+ * the specified timeout, or another error code if an error occurred.
+ */
+int mc146818_get_time(struct rtc_time *time, int timeout)
 {
 	struct mc146818_get_time_callback_param p = {
 		.time = time
 	};
 
-	if (!mc146818_avoid_UIP(mc146818_get_time_callback, &p)) {
+	if (!mc146818_avoid_UIP(mc146818_get_time_callback, timeout, &p)) {
 		memset(time, 0, sizeof(*time));
 		return -ETIMEDOUT;
 	}
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -126,10 +126,11 @@ struct cmos_rtc_board_info {
 #endif /* ARCH_RTC_LOCATION */
 
 bool mc146818_does_rtc_work(void);
-int mc146818_get_time(struct rtc_time *time);
+int mc146818_get_time(struct rtc_time *time, int timeout);
 int mc146818_set_time(struct rtc_time *time);
 
 bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
+			int timeout,
 			void *param);
 
 #endif /* _MC146818RTC_H */


