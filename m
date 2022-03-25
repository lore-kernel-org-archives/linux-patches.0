Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B74B1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A3EC340EE;
	Fri, 25 Mar 2022 01:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170755;
	bh=zKCj9zem4HgrYLg7iAwTv8ZW5zlJ+KMXrTr8EDOKmgQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=pWIubxch0/EaFAWmsZSnBmMAvjsSuyTojCW6dUilkfd3hfJQkiXTFcmyT1+6zoSty
	 KZGX194aSGK+lY9dtO+7gGRBGS0odCOSXmv9rU9Ib39Wud+BS4hxcL6qPuOrw3yxua
	 6D+TC1nI/iu2b6qzEOWl9POZMN30aS62XZw9K0EM=
Date: Thu, 24 Mar 2022 18:12:34 -0700
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 080/114] kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT
Message-Id: <20220325011235.43A3EC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT

Check the more specific CONFIG_KASAN_KUNIT_TEST config option when
defining things related to KUnit-compatible KASAN tests instead of
CONFIG_KUNIT.

Also put the kunit_kasan_status definition next to the definitons of other
KASAN-related structs.

Link: https://lkml.kernel.org/r/223592d38d2a601a160a3b2b3d5a9f9090350e62.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |   18 ++++++++----------
 mm/kasan/report.c |    2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/mm/kasan/kasan.h~kasan-check-config_kasan_kunit_test-instead-of-config_kunit
+++ a/mm/kasan/kasan.h
@@ -7,16 +7,6 @@
 #include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
-#if IS_ENABLED(CONFIG_KUNIT)
-
-/* Used in KUnit-compatible KASAN tests. */
-struct kunit_kasan_status {
-	bool report_found;
-	bool sync_fault;
-};
-
-#endif
-
 #ifdef CONFIG_KASAN_HW_TAGS
 
 #include <linux/static_key.h>
@@ -224,6 +214,14 @@ struct kasan_free_meta {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+/* Used in KUnit-compatible KASAN tests. */
+struct kunit_kasan_status {
+	bool report_found;
+	bool sync_fault;
+};
+#endif
+
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
 #ifdef CONFIG_KASAN_GENERIC
--- a/mm/kasan/report.c~kasan-check-config_kasan_kunit_test-instead-of-config_kunit
+++ a/mm/kasan/report.c
@@ -356,7 +356,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#if IS_ENABLED(CONFIG_KUNIT)
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 static void update_kunit_status(bool sync)
 {
 	struct kunit *test;
_
