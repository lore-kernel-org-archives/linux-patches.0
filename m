Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D01FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2925C340EC;
	Fri, 25 Mar 2022 01:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170704;
	bh=azOSptRJNsSppYJVS6q7vxNhMVYvJtuMPftb/5yoAI0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=T3RZA52MXC+b0FsjTIrkdhHsEqpZGimoMl8kHW9qr6LxaKzDHZwugXTQi0okM6dDQ
	 jFOSraPdbWeXj0sbF3Rf3HeiwYpcdV9yk/RligiEyG31/NHkQtj7jwcAeWlSAKzfmN
	 E8O8acOfI/0eqsF8MEKL1U/kWMEhC5DuPJgFwtSQ=
Date: Thu, 24 Mar 2022 18:11:44 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 063/114] kasan: clean up feature flags for HW_TAGS mode
Message-Id: <20220325011144.D2925C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up feature flags for HW_TAGS mode

- Untie kasan_init_hw_tags() code from the default values of
  kasan_arg_mode and kasan_arg_stacktrace.

- Move static_branch_enable(&kasan_flag_enabled) to the end of
  kasan_init_hw_tags_cpu().

- Remove excessive comments in kasan_arg_mode switch.

- Add new comments.

Link: https://lkml.kernel.org/r/76ebb340265be57a218564a497e1f52ff36a3879.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |   38 +++++++++++++++++++++-----------------
 mm/kasan/kasan.h   |    2 +-
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-clean-up-feature-flags-for-hw_tags-mode
+++ a/mm/kasan/hw_tags.c
@@ -42,16 +42,22 @@ static enum kasan_arg kasan_arg __ro_aft
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_stacktrace kasan_arg_stacktrace __initdata;
 
-/* Whether KASAN is enabled at all. */
+/*
+ * Whether KASAN is enabled at all.
+ * The value remains false until KASAN is initialized by kasan_init_hw_tags().
+ */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
 EXPORT_SYMBOL(kasan_flag_enabled);
 
-/* Whether the selected mode is synchronous/asynchronous/asymmetric.*/
+/*
+ * Whether the selected mode is synchronous, asynchronous, or asymmetric.
+ * Defaults to KASAN_MODE_SYNC.
+ */
 enum kasan_mode kasan_mode __ro_after_init;
 EXPORT_SYMBOL_GPL(kasan_mode);
 
 /* Whether to collect alloc/free stack traces. */
-DEFINE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
+DEFINE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
 /* kasan=off/on */
 static int __init early_kasan_flag(char *arg)
@@ -127,7 +133,11 @@ void kasan_init_hw_tags_cpu(void)
 	 * as this function is only called for MTE-capable hardware.
 	 */
 
-	/* If KASAN is disabled via command line, don't initialize it. */
+	/*
+	 * If KASAN is disabled via command line, don't initialize it.
+	 * When this function is called, kasan_flag_enabled is not yet
+	 * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
+	 */
 	if (kasan_arg == KASAN_ARG_OFF)
 		return;
 
@@ -154,42 +164,36 @@ void __init kasan_init_hw_tags(void)
 	if (kasan_arg == KASAN_ARG_OFF)
 		return;
 
-	/* Enable KASAN. */
-	static_branch_enable(&kasan_flag_enabled);
-
 	switch (kasan_arg_mode) {
 	case KASAN_ARG_MODE_DEFAULT:
-		/*
-		 * Default to sync mode.
-		 */
-		fallthrough;
+		/* Default is specified by kasan_mode definition. */
+		break;
 	case KASAN_ARG_MODE_SYNC:
-		/* Sync mode enabled. */
 		kasan_mode = KASAN_MODE_SYNC;
 		break;
 	case KASAN_ARG_MODE_ASYNC:
-		/* Async mode enabled. */
 		kasan_mode = KASAN_MODE_ASYNC;
 		break;
 	case KASAN_ARG_MODE_ASYMM:
-		/* Asymm mode enabled. */
 		kasan_mode = KASAN_MODE_ASYMM;
 		break;
 	}
 
 	switch (kasan_arg_stacktrace) {
 	case KASAN_ARG_STACKTRACE_DEFAULT:
-		/* Default to enabling stack trace collection. */
-		static_branch_enable(&kasan_flag_stacktrace);
+		/* Default is specified by kasan_flag_stacktrace definition. */
 		break;
 	case KASAN_ARG_STACKTRACE_OFF:
-		/* Do nothing, kasan_flag_stacktrace keeps its default value. */
+		static_branch_disable(&kasan_flag_stacktrace);
 		break;
 	case KASAN_ARG_STACKTRACE_ON:
 		static_branch_enable(&kasan_flag_stacktrace);
 		break;
 	}
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, stacktrace=%s)\n",
 		kasan_mode_info(),
 		kasan_stack_collection_enabled() ? "on" : "off");
--- a/mm/kasan/kasan.h~kasan-clean-up-feature-flags-for-hw_tags-mode
+++ a/mm/kasan/kasan.h
@@ -12,7 +12,7 @@
 #include <linux/static_key.h>
 #include "../slab.h"
 
-DECLARE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
+DECLARE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
 enum kasan_mode {
 	KASAN_MODE_SYNC,
_
