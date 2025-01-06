Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC7F182D2;
	Mon,  6 Jan 2025 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178904; cv=none; b=mQzWwS7fJ1xzgzYyqnjXNXY0WdFHzUJqsY+BY4jpNOwBxBXXiVesuJ7NwtzLwj1tDSOp8oICgMw4dHy09dZQiZhfyriRE0fApLofjFBUQGyobGnKkN0MD53NjAbC5yc7jUF55T/4BWHFtAIhlviazl+9uJffm2xfHyIoQ9ksTlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178904; c=relaxed/simple;
	bh=Ry6DDh+Ca3MwfhWvgYpi2BXlqSjQ8c9bWB1TZNeVAPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYQIC61jovwr0yX5n1EbgnE7eDx0UoCd0rIjwMdUpNvVU0J+qYJW8oDwUQNNRQ0Ziq4Ccg49PmCMIiuIDLdWPaDC4VuHCigVtqbrB4gfUsdkxsrsg/Db3pqFTjcfpDYDnQs045ewRNYEMpKWvXDdRxfNcx7PopbmbEwkrPaRKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRx9yQ5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRx9yQ5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16DAC4CED2;
	Mon,  6 Jan 2025 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178904;
	bh=Ry6DDh+Ca3MwfhWvgYpi2BXlqSjQ8c9bWB1TZNeVAPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRx9yQ5+UWsiQ5YCp66rpsSo2hKMCnPol55CHz25gVslmVbgR2oSjnw2SrRVPdK3z
	 Z4z47TlFe3KvLW3sXNME9Tfy292LVmaBjuD4crXDvTMmzv+Fo9OxsxOArWyeyt3tpt
	 NPJMktb2/7TIIDssNVcJOpAogFCATIgw3qBg42hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 104/168] x86/hyperv: Fix hv tsc page based sched_clock for hibernation
Date: Mon,  6 Jan 2025 16:16:52 +0100
Message-ID: <20250106151142.388836805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit bcc80dec91ee745b3d66f3e48f0ec2efdea97149 upstream.

read_hv_sched_clock_tsc() assumes that the Hyper-V clock counter is
bigger than the variable hv_sched_clock_offset, which is cached during
early boot, but depending on the timing this assumption may be false
when a hibernated VM starts again (the clock counter starts from 0
again) and is resuming back (Note: hv_init_tsc_clocksource() is not
called during hibernation/resume); consequently,
read_hv_sched_clock_tsc() may return a negative integer (which is
interpreted as a huge positive integer since the return type is u64)
and new kernel messages are prefixed with huge timestamps before
read_hv_sched_clock_tsc() grows big enough (which typically takes
several seconds).

Fix the issue by saving the Hyper-V clock counter just before the
suspend, and using it to correct the hv_sched_clock_offset in
resume. This makes hv tsc page based sched_clock continuous and ensures
that post resume, it starts from where it left off during suspend.
Override x86_platform.save_sched_clock_state and
x86_platform.restore_sched_clock_state routines to correct this as soon
as possible.

Note: if Invariant TSC is available, the issue doesn't happen because
1) we don't register read_hv_sched_clock_tsc() for sched clock:
See commit e5313f1c5404 ("clocksource/drivers/hyper-v: Rework
clocksource and sched clock setup");
2) the common x86 code adjusts TSC similarly: see
__restore_processor_state() ->  tsc_verify_tsc_adjust(true) and
x86_platform.restore_sched_clock_state().

Cc: stable@vger.kernel.org
Fixes: 1349401ff1aa ("clocksource/drivers/hyper-v: Suspend/resume Hyper-V clocksource for hibernation")
Co-developed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20240917053917.76787-1-namjain@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240917053917.76787-1-namjain@linux.microsoft.com>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mshyperv.c     |   58 +++++++++++++++++++++++++++++++++++++
 drivers/clocksource/hyperv_timer.c |   14 ++++++++
 include/clocksource/hyperv_timer.h |    2 +
 3 files changed, 73 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -150,6 +150,63 @@ static void hv_machine_crash_shutdown(st
 	hyperv_cleanup();
 }
 #endif /* CONFIG_KEXEC_CORE */
+
+static u64 hv_ref_counter_at_suspend;
+static void (*old_save_sched_clock_state)(void);
+static void (*old_restore_sched_clock_state)(void);
+
+/*
+ * Hyper-V clock counter resets during hibernation. Save and restore clock
+ * offset during suspend/resume, while also considering the time passed
+ * before suspend. This is to make sure that sched_clock using hv tsc page
+ * based clocksource, proceeds from where it left off during suspend and
+ * it shows correct time for the timestamps of kernel messages after resume.
+ */
+static void save_hv_clock_tsc_state(void)
+{
+	hv_ref_counter_at_suspend = hv_read_reference_counter();
+}
+
+static void restore_hv_clock_tsc_state(void)
+{
+	/*
+	 * Adjust the offsets used by hv tsc clocksource to
+	 * account for the time spent before hibernation.
+	 * adjusted value = reference counter (time) at suspend
+	 *                - reference counter (time) now.
+	 */
+	hv_adj_sched_clock_offset(hv_ref_counter_at_suspend - hv_read_reference_counter());
+}
+
+/*
+ * Functions to override save_sched_clock_state and restore_sched_clock_state
+ * functions of x86_platform. The Hyper-V clock counter is reset during
+ * suspend-resume and the offset used to measure time needs to be
+ * corrected, post resume.
+ */
+static void hv_save_sched_clock_state(void)
+{
+	old_save_sched_clock_state();
+	save_hv_clock_tsc_state();
+}
+
+static void hv_restore_sched_clock_state(void)
+{
+	restore_hv_clock_tsc_state();
+	old_restore_sched_clock_state();
+}
+
+static void __init x86_setup_ops_for_tsc_pg_clock(void)
+{
+	if (!(ms_hyperv.features & HV_MSR_REFERENCE_TSC_AVAILABLE))
+		return;
+
+	old_save_sched_clock_state = x86_platform.save_sched_clock_state;
+	x86_platform.save_sched_clock_state = hv_save_sched_clock_state;
+
+	old_restore_sched_clock_state = x86_platform.restore_sched_clock_state;
+	x86_platform.restore_sched_clock_state = hv_restore_sched_clock_state;
+}
 #endif /* CONFIG_HYPERV */
 
 static uint32_t  __init ms_hyperv_platform(void)
@@ -438,6 +495,7 @@ static void __init ms_hyperv_init_platfo
 
 	/* Register Hyper-V specific clocksource */
 	hv_init_clocksource();
+	x86_setup_ops_for_tsc_pg_clock();
 #endif
 	/*
 	 * TSC should be marked as unstable only after Hyper-V
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -26,7 +26,8 @@
 #include <asm/mshyperv.h>
 
 static struct clock_event_device __percpu *hv_clock_event;
-static u64 hv_sched_clock_offset __ro_after_init;
+/* Note: offset can hold negative values after hibernation. */
+static u64 hv_sched_clock_offset __read_mostly;
 
 /*
  * If false, we're using the old mechanism for stimer0 interrupts
@@ -416,6 +417,17 @@ static void resume_hv_clock_tsc(struct c
 	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
 }
 
+/*
+ * Called during resume from hibernation, from overridden
+ * x86_platform.restore_sched_clock_state routine. This is to adjust offsets
+ * used to calculate time for hv tsc page based sched_clock, to account for
+ * time spent before hibernation.
+ */
+void hv_adj_sched_clock_offset(u64 offset)
+{
+	hv_sched_clock_offset -= offset;
+}
+
 #ifdef HAVE_VDSO_CLOCKMODE_HVCLOCK
 static int hv_cs_enable(struct clocksource *cs)
 {
--- a/include/clocksource/hyperv_timer.h
+++ b/include/clocksource/hyperv_timer.h
@@ -34,6 +34,8 @@ extern void hv_init_clocksource(void);
 
 extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
 
+extern void hv_adj_sched_clock_offset(u64 offset);
+
 static inline notrace u64
 hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur_tsc)
 {


