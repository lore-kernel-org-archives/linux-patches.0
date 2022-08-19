Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E04A06
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01F3C43141
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933041;
	bh=CIbhw2oDHwnB0mdwATNUbJFdsByWNzrRIESJoJfu71Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=SoXTvwQ26SC/I5j5JL7ignggOXkQXoFyopgtAEo2+2DVHqDfClJpB60J7nq7koD8f
	 2E0pw/AdYWuvLnqc2SMR5MygsYPgSNvaRJpPPXXEuM6Xv4ZVoOzt0fgUpJOszpzEJx
	 SpmvVJGilOHWNREqARxOvUmOs/WaGT/e+R6xIuBgZv9B174je9D8dAH7L57/A5lgsx
	 9G8ORe9OxnZcHs1B75LZbyN2H1U8NSweK8QKa0HwbTizgG32c1fdwJfx7HKYDTJlu3
	 nR7kctpEvhVknsoCPIBQX5CJNX+6O4cTr70JMd4fYxViHcFGU15hgiCmhVwIKBC0VE
	 dJSIOrBlUsCTw==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:21 -0400
Subject: [PATCH v1 7/9] mm/compaction: Get rid of RT ifdeffery
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-7-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=azrxF6cLz1g4rOH0R6Iz3U9uOy67ToqP8jr8W0Gr6Os=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X14nOmn9rI167+17y2JELZ/z7WzsTMrnP3hWb1LirrDf
 S13EO0pZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEwk0puRYd4O1iPcyszhMWk7q8L0vf
 mdFj34pFO+9cYG/hVOavPf2TL8M/25JPPV2zm7GvpLfN8JPnHl/a7oEvClNU/kQc7c3RKsfAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

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

