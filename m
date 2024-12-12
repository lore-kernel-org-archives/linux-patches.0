Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C056F2FE;
	Thu, 12 Dec 2024 15:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018047; cv=none; b=VbiiuITIrsbvyNC2XQlkhehQ+f3Mu1TUyBexTu6xHC348miNGE2xxWG0spkHZmjog8Wryc+D3SO1DDZ9HWIas/ky1dmTK9a/kIfeG590GY78rKvF++Zj5/aIilzlqIahIkHKcK+ml6Yhxwgxzwiepn5GqdO4pEb1zUHXkY0zcb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018047; c=relaxed/simple;
	bh=YOddXO79Phe41kj+WUMtht2J3++Df1pkTEtnEo5+U8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toJSGS1VPMRbghTxTjsPK584glIERrc3bMexhc13sCK35PLgH4ycgbE7D7KUDJtJM/mtuGzBeXJLdREqty6Pe3Vrpo4EmnEEhNGiacdJza+H/IH15YwlqawXvqL0mjN5OYadQ4RI01044D+TPUKRewGYJKFQaWok9avGY3WZBlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvp181UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvp181UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86351C4CECE;
	Thu, 12 Dec 2024 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018046;
	bh=YOddXO79Phe41kj+WUMtht2J3++Df1pkTEtnEo5+U8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvp181UHLDSzaa/hfA90PQmx00zge2Xo1ho3HJvVVMoLPUeXpW/RaqqmtMadLoBSq
	 hc9EuGKmNBynvmGZ618qqCxWpAgjvI8SpgyLNGVUyoTIcSV2MXQTrDSie4RpruBz1X
	 OoC4ZrD204r0CsyiiTjzDafdh09Ctumo59DACUqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 182/356] kasan: make report_lock a raw spinlock
Date: Thu, 12 Dec 2024 15:58:21 +0100
Message-ID: <20241212144251.820701534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

commit e30a0361b8515d424c73c67de1a43e45a13b8ba2 upstream.

If PREEMPT_RT is enabled, report_lock is a sleeping spinlock and must not
be locked when IRQs are disabled.  However, KASAN reports may be triggered
in such contexts.  For example:

        char *s = kzalloc(1, GFP_KERNEL);
        kfree(s);
        local_irq_disable();
        char c = *s;  /* KASAN report here leads to spin_lock() */
        local_irq_enable();

Make report_spinlock a raw spinlock to prevent rescheduling when
PREEMPT_RT is enabled.

Link: https://lkml.kernel.org/r/20241119210234.1602529-1-jkangas@redhat.com
Fixes: 342a93247e08 ("locking/spinlock: Provide RT variant header: <linux/spinlock_rt.h>")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/report.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -199,7 +199,7 @@ static inline void fail_non_kasan_kunit_
 
 #endif /* CONFIG_KUNIT */
 
-static DEFINE_SPINLOCK(report_lock);
+static DEFINE_RAW_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
@@ -210,7 +210,7 @@ static void start_report(unsigned long *
 	lockdep_off();
 	/* Make sure we don't end up in loop. */
 	report_suppress_start();
-	spin_lock_irqsave(&report_lock, *flags);
+	raw_spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
 }
 
@@ -220,7 +220,7 @@ static void end_report(unsigned long *fl
 		trace_error_report_end(ERROR_DETECTOR_KASAN,
 				       (unsigned long)addr);
 	pr_err("==================================================================\n");
-	spin_unlock_irqrestore(&report_lock, *flags);
+	raw_spin_unlock_irqrestore(&report_lock, *flags);
 	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		check_panic_on_warn("KASAN");
 	switch (kasan_arg_fault) {


