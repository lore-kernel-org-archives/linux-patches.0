Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A8B212D6A;
	Thu, 12 Dec 2024 15:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016545; cv=none; b=mOmzR45N6Xt+2sPj+unPMjvU4V1tJagB9ey+zmCdV6dYPvw4lZJ0enYTTHSYSEf2Zs/+Yyy0BaQKZuj00mhFR/JT7y95Tx1/6KcbQBJUUO2Yc16dxQC1TfIybxNftLgSwIaJi0MWU4g3Bei26S/15VQkEP+RnvEJNOSb3J9Rsjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016545; c=relaxed/simple;
	bh=8FDJ3g54z509uVMAoq6nUrlUEkxMOwmPlzk1U8+wKoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAtj5NemJgKLgrpGmCHn6qmo1D4blA9cTQzgBx6KY9nfBJayhHvSWGyMB4x/BEDOXrsJtUhfLHcQjoCVwd1S97rs7nOg7N2jbnKHNOJa+eRl4cBFZ/1HCqxMCr0hNzGaQ5unW+S9RsFkKrw1y/o124ihSLhHBUGOSkQHLKdatlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLoYz70u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLoYz70u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5115BC4CECE;
	Thu, 12 Dec 2024 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016544;
	bh=8FDJ3g54z509uVMAoq6nUrlUEkxMOwmPlzk1U8+wKoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLoYz70u7DeKxZu7xz/gA2JsZfcpzAQaYlMl+6WyyrKlPZT4FBuhLZzHpLcB0NS8V
	 B46vi1wFDIATXQOO4VhbBlPGYBtB3ahKzZHlHm/D5GgsR01cPAciN+WoajHmXTtqvh
	 OZHgGxmB1wmmRac0ccqL73viyN5WbLGYNELVMv00=
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
Subject: [PATCH 6.12 198/466] kasan: make report_lock a raw spinlock
Date: Thu, 12 Dec 2024 15:56:07 +0100
Message-ID: <20241212144314.615810698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,7 +200,7 @@ static inline void fail_non_kasan_kunit_
 
 #endif /* CONFIG_KUNIT */
 
-static DEFINE_SPINLOCK(report_lock);
+static DEFINE_RAW_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
@@ -211,7 +211,7 @@ static void start_report(unsigned long *
 	lockdep_off();
 	/* Make sure we don't end up in loop. */
 	report_suppress_start();
-	spin_lock_irqsave(&report_lock, *flags);
+	raw_spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
 }
 
@@ -221,7 +221,7 @@ static void end_report(unsigned long *fl
 		trace_error_report_end(ERROR_DETECTOR_KASAN,
 				       (unsigned long)addr);
 	pr_err("==================================================================\n");
-	spin_unlock_irqrestore(&report_lock, *flags);
+	raw_spin_unlock_irqrestore(&report_lock, *flags);
 	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		check_panic_on_warn("KASAN");
 	switch (kasan_arg_fault) {


