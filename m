Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB720E8
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 00:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3039BC340EB;
	Sat, 12 Feb 2022 00:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1644625956;
	bh=LG+O9Dos60jXlG5yaueRFYqeJn7krLFBx1XdsQyPi5U=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=mQTT9h0oH3Xl7JycSrRg/DDDEkMEL3TWPLvrIc4Fe9r9vOFf3zcbQQ5zqObffahtE
	 xpFm87r32DRY8DOeIKzOt5ofOulciKhA1N7J8rq1An2vendSxU5uIuKgRLNQ4/QtoL
	 rd1gL3iIsYkgkkMq94YaIZCoXFmt4IYBDiyg5qIA=
Date: Fri, 11 Feb 2022 16:32:35 -0800
To: sumit.semwal@linaro.org,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,christian.koenig@amd.com,liupeng256@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 5/5] kfence: make test case compatible with run time set sample interval
Message-Id: <20220212003236.3039BC340EB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Peng Liu <liupeng256@huawei.com>
Subject: kfence: make test case compatible with run time set sample interval

The parameter kfence_sample_interval can be set via boot parameter and
late shell command, which is convenient for automated tests and KFENCE
parameter optimization.  However, KFENCE test case just uses compile-time
CONFIG_KFENCE_SAMPLE_INTERVAL, which will make KFENCE test case not run as
users desired.  Export kfence_sample_interval, so that KFENCE test case
can use run-time-set sample interval.

Link: https://lkml.kernel.org/r/20220207034432.185532-1-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Christian Knig <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/kfence.h~kfence-make-test-case-compatible-with-run-time-set-sample-interval
+++ a/include/linux/kfence.h
@@ -17,6 +17,8 @@
 #include <linux/atomic.h>
 #include <linux/static_key.h>
 
+extern unsigned long kfence_sample_interval;
+
 /*
  * We allocate an even number of pages, as it simplifies calculations to map
  * address to metadata indices; effectively, the very first page serves as an
--- a/mm/kfence/core.c~kfence-make-test-case-compatible-with-run-time-set-sample-interval
+++ a/mm/kfence/core.c
@@ -47,7 +47,8 @@
 
 static bool kfence_enabled __read_mostly;
 
-static unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
+unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
+EXPORT_SYMBOL_GPL(kfence_sample_interval); /* Export for test modules. */
 
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
--- a/mm/kfence/kfence_test.c~kfence-make-test-case-compatible-with-run-time-set-sample-interval
+++ a/mm/kfence/kfence_test.c
@@ -268,13 +268,13 @@ static void *test_alloc(struct kunit *te
 	 * 100x the sample interval should be more than enough to ensure we get
 	 * a KFENCE allocation eventually.
 	 */
-	timeout = jiffies + msecs_to_jiffies(100 * CONFIG_KFENCE_SAMPLE_INTERVAL);
+	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
 	/*
 	 * Especially for non-preemption kernels, ensure the allocation-gate
 	 * timer can catch up: after @resched_after, every failed allocation
 	 * attempt yields, to ensure the allocation-gate timer is scheduled.
 	 */
-	resched_after = jiffies + msecs_to_jiffies(CONFIG_KFENCE_SAMPLE_INTERVAL);
+	resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
 	do {
 		if (test_cache)
 			alloc = kmem_cache_alloc(test_cache, gfp);
@@ -608,7 +608,7 @@ static void test_gfpzero(struct kunit *t
 	int i;
 
 	/* Skip if we think it'd take too long. */
-	KFENCE_TEST_REQUIRES(test, CONFIG_KFENCE_SAMPLE_INTERVAL <= 100);
+	KFENCE_TEST_REQUIRES(test, kfence_sample_interval <= 100);
 
 	setup_test_cache(test, size, 0, NULL);
 	buf1 = test_alloc(test, size, GFP_KERNEL, ALLOCATE_ANY);
@@ -739,7 +739,7 @@ static void test_memcache_alloc_bulk(str
 	 * 100x the sample interval should be more than enough to ensure we get
 	 * a KFENCE allocation eventually.
 	 */
-	timeout = jiffies + msecs_to_jiffies(100 * CONFIG_KFENCE_SAMPLE_INTERVAL);
+	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
 	do {
 		void *objects[100];
 		int i, num = kmem_cache_alloc_bulk(test_cache, GFP_ATOMIC, ARRAY_SIZE(objects),
_
