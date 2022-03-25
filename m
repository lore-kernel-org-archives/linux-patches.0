Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BBB1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E347C340EE;
	Fri, 25 Mar 2022 01:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170758;
	bh=AX9FUcnFo4cvpYXYJLG8g9zrRabCG/dZ+RNpVOUqYaE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=ROKu8S2zNqYIEakMqfaFCaI2ZZINlhWDzXvSRPx0Ypo5YIZTzmPLmh1cUrRwzmHoT
	 lyJJNvr+btSPmGF8VzI1ZII1nZB0owLxbjyRRaZTKw8ff5LXfYrrOwVcmZx2YDVNIZ
	 1L57R1D9x1X/OlPlp/b7pwlklKl//FjPWUQDT9+8=
Date: Thu, 24 Mar 2022 18:12:37 -0700
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 081/114] kasan: move update_kunit_status to start_report
Message-Id: <20220325011238.2E347C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move update_kunit_status to start_report

Instead of duplicating calls to update_kunit_status() in every error
report routine, call it once in start_report().  Pass the sync flag as an
additional argument to start_report().

Link: https://lkml.kernel.org/r/cae5c845a0b6f3c867014e53737cdac56b11edc7.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   75 +++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

--- a/mm/kasan/report.c~kasan-move-update_kunit_status-to-start_report
+++ a/mm/kasan/report.c
@@ -98,13 +98,40 @@ static void print_error_description(stru
 			info->access_addr, current->comm, task_pid_nr(current));
 }
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+static void update_kunit_status(bool sync)
+{
+	struct kunit *test;
+	struct kunit_resource *resource;
+	struct kunit_kasan_status *status;
+
+	test = current->kunit_test;
+	if (!test)
+		return;
+
+	resource = kunit_find_named_resource(test, "kasan_status");
+	if (!resource) {
+		kunit_set_failure(test);
+		return;
+	}
+
+	status = (struct kunit_kasan_status *)resource->data;
+	WRITE_ONCE(status->report_found, true);
+	WRITE_ONCE(status->sync_fault, sync);
+
+	kunit_put_resource(resource);
+}
+#else
+static void update_kunit_status(bool sync) { }
+#endif
+
 static DEFINE_SPINLOCK(report_lock);
 
-static void start_report(unsigned long *flags)
+static void start_report(unsigned long *flags, bool sync)
 {
-	/*
-	 * Make sure we don't end up in loop.
-	 */
+	/* Update status of the currently running KASAN test. */
+	update_kunit_status(sync);
+	/* Make sure we don't end up in loop. */
 	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
@@ -356,33 +383,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
-static void update_kunit_status(bool sync)
-{
-	struct kunit *test;
-	struct kunit_resource *resource;
-	struct kunit_kasan_status *status;
-
-	test = current->kunit_test;
-	if (!test)
-		return;
-
-	resource = kunit_find_named_resource(test, "kasan_status");
-	if (!resource) {
-		kunit_set_failure(test);
-		return;
-	}
-
-	status = (struct kunit_kasan_status *)resource->data;
-	WRITE_ONCE(status->report_found, true);
-	WRITE_ONCE(status->sync_fault, sync);
-
-	kunit_put_resource(resource);
-}
-#else
-static void update_kunit_status(bool sync) { }
-#endif
-
 void kasan_report_invalid_free(void *object, unsigned long ip)
 {
 	unsigned long flags;
@@ -390,9 +390,7 @@ void kasan_report_invalid_free(void *obj
 
 	object = kasan_reset_tag(object);
 
-	update_kunit_status(true);
-
-	start_report(&flags);
+	start_report(&flags, true);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
 	kasan_print_tags(tag, object);
 	pr_err("\n");
@@ -406,9 +404,7 @@ void kasan_report_async(void)
 {
 	unsigned long flags;
 
-	update_kunit_status(false);
-
-	start_report(&flags);
+	start_report(&flags, false);
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
@@ -425,9 +421,8 @@ static void __kasan_report(unsigned long
 	void *untagged_addr;
 	unsigned long flags;
 
-	update_kunit_status(true);
-
 	disable_trace_on_warning();
+	start_report(&flags, true);
 
 	tagged_addr = (void *)addr;
 	untagged_addr = kasan_reset_tag(tagged_addr);
@@ -442,8 +437,6 @@ static void __kasan_report(unsigned long
 	info.is_write = is_write;
 	info.ip = ip;
 
-	start_report(&flags);
-
 	print_error_description(&info);
 	if (addr_has_metadata(untagged_addr))
 		kasan_print_tags(get_tag(tagged_addr), info.first_bad_addr);
_
