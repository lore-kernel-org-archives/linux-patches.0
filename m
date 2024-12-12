Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B00223C5C;
	Thu, 12 Dec 2024 16:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021407; cv=none; b=bD5vynMlRt+PYj8VZ1OcSsaqKEH8PYb5+5rGN4LGjLmh/Ph/0tIMacqLjCgeDu4l9PLZJMo3YLJtlGcwmyQtau0D4QCcXV6EnN6QXvJWXHdFyLjSNnT+89mJpAZLx6qLNg3zRUasL9gncs1iGqblWV2+w1lW+ALU4M3eQH4MPmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021407; c=relaxed/simple;
	bh=CsZGV4bH1w19SIIifY4uEQ1ShfBfp5V1nswZ7Ve3O1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsmSTmOeucd+dgV6TpxKk+H320IppsyaQ352enFFbXkWtzv/b5KTVTPHAayITCzo+8/yqHkYjhI9Agpr0Hcf52Q5cqvjRgen/KBQ0ALolsvUrGwybJEjgNulcwnPqIC6prMhz0k8Qbexigx29xHXHJYq28OJ5T2KaGHVIyGlEbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9MKP0Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9MKP0Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E06C4CECE;
	Thu, 12 Dec 2024 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021407;
	bh=CsZGV4bH1w19SIIifY4uEQ1ShfBfp5V1nswZ7Ve3O1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9MKP0VsJHkDts2ciEZ/BaHEYjs8/nkxPfcAuBJdnEAMnuJwbM9yGu+eO8i6NchrL
	 WqOO5Y7kvQzKOy8Ty7zc4ADXkh23D5DK9ObhYSdPxSsAFpxA9fv3OZg662WNr+Zgn6
	 K4ZWjNRUn5W1geEupBgZ5VTuEXBvpA2MB8aZu5s8=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 730/772] kasan: make report_lock a raw spinlock
Date: Thu, 12 Dec 2024 16:01:15 +0100
Message-ID: <20241212144420.068931417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit e30a0361b8515d424c73c67de1a43e45a13b8ba2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/report.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 821cd12e8c8a7..6ad986c267b5e 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -173,7 +173,7 @@ static void update_kunit_status(bool sync)
 static void update_kunit_status(bool sync) { }
 #endif
 
-static DEFINE_SPINLOCK(report_lock);
+static DEFINE_RAW_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
@@ -185,7 +185,7 @@ static void start_report(unsigned long *flags, bool sync)
 	lockdep_off();
 	/* Make sure we don't end up in loop. */
 	report_suppress_start();
-	spin_lock_irqsave(&report_lock, *flags);
+	raw_spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
 }
 
@@ -195,7 +195,7 @@ static void end_report(unsigned long *flags, void *addr)
 		trace_error_report_end(ERROR_DETECTOR_KASAN,
 				       (unsigned long)addr);
 	pr_err("==================================================================\n");
-	spin_unlock_irqrestore(&report_lock, *flags);
+	raw_spin_unlock_irqrestore(&report_lock, *flags);
 	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		check_panic_on_warn("KASAN");
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
-- 
2.43.0



