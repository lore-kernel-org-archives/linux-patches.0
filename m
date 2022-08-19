Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BF94A08
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F67C43140
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1660933458;
	bh=CIbhw2oDHwnB0mdwATNUbJFdsByWNzrRIESJoJfu71Q=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=hvGWNhlHZL+Uadse+l+JSwKJdEFaYU/OdhbsDiozFlrNvKEoq1oiJaXdHahbAdkBP
	 +V0c0AjNF2Pe0Y8s0AyRlhuo7wQw9So9P6dBWTgYICrjO5UOBoI1vItMFPPX8Q8UXF
	 +MVLamc+zqxgALsTNXrJxIEjZVo0wJ/ZJL0XKwl0=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 19 Aug 2022 14:24:16 -0400
Subject: [PATCH RESEND v1 7/9] mm/compaction: Get rid of RT ifdeffery
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-7-dfdb252f35f4@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-dfdb252f35f4@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-dfdb252f35f4@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=azrxF6cLz1g4rOH0R6Iz3U9uOy67ToqP8jr8W0Gr6Os=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X/V/qP33ybntbq6L9k/mLuK5ZxB/81LxLrugeReWmgYb
 Lyg+11HKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAiL+UZ/qd61694ebbGaKdN/k6XqY
 ZrDygsZY4S5NeUl4g811hVHMfwP9NvmSbrdovP9z2dwzUPNv6f2Kk+N7ObI6Bml8L6juNNjAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

From: Thomas Gleixner <tglx@linutronix.de>

Move the RT dependency for the initial value of
sysctl_compact_unevictable_allowed into Kconfig.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: linux-mm@kvack.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/mm/Kconfig b/mm/Kconfig
index 0331f1461f81..a0506a54a4f3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -579,6 +579,11 @@ config COMPACTION
 	  it and then we would be really interested to hear about that at
 	  linux-mm@kvack.org.
 
+config COMPACT_UNEVICTABLE_DEFAULT
+	int
+	default 0 if PREEMPT_RT
+	default 1
+
 #
 # support for free page reporting
 config PAGE_REPORTING
diff --git a/mm/compaction.c b/mm/compaction.c
index 640fa76228dd..10561cb1aaad 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1727,11 +1727,7 @@ typedef enum {
  * Allow userspace to control policy on scanning the unevictable LRU for
  * compactable pages.
  */
-#ifdef CONFIG_PREEMPT_RT
-int sysctl_compact_unevictable_allowed __read_mostly = 0;
-#else
-int sysctl_compact_unevictable_allowed __read_mostly = 1;
-#endif
+int sysctl_compact_unevictable_allowed __read_mostly = CONFIG_COMPACT_UNEVICTABLE_DEFAULT;
 
 static inline void
 update_fast_start_pfn(struct compact_control *cc, unsigned long pfn)

-- 
b4 0.10.0-dev-c53d8

