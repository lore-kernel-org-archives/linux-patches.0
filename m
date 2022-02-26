Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79197367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41776C340EF;
	Sat, 26 Feb 2022 03:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845060;
	bh=bJ4TU+7a6wBfNVLcB0AHPPwgYQneQs7SYC2VFKMeTWk=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=TumeJtX4GZllAAlaadgVkdbIE7NsVTdSoUIXcwnX0Q+5PCKvzDHQ5jnpRIi6NILrO
	 aGavvggMtTa1yrFvsicGodIfdcoASQ90d+Pv+IOqBZz7OMmTtuxK2ZaxoaLKvffOYV
	 btcrKeYP04wVf504jVK9XvfZHCvQRx1MTgjM3zNY=
Date: Fri, 25 Feb 2022 19:10:59 -0800
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 03/12] kasan: test: prevent cache merging in kmem_cache_double_destroy
Message-Id: <20220226031100.41776C340EF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: test: prevent cache merging in kmem_cache_double_destroy

With HW_TAGS KASAN and kasan.stacktrace=off, the cache created in the
kmem_cache_double_destroy() test might get merged with an existing one. 
Thus, the first kmem_cache_destroy() call won't actually destroy it but
will only decrease the refcount.  This causes the test to fail.

Provide an empty constructor for the created cache to prevent the cache
from getting merged.

Link: https://lkml.kernel.org/r/b597bd434c49591d8af00ee3993a42c609dc9a59.1644346040.git.andreyknvl@google.com
Fixes: f98f966cd750 ("kasan: test: add test case for double-kmem_cache_destroy()")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy
+++ a/lib/test_kasan.c
@@ -869,11 +869,14 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
+static void empty_cache_ctor(void *object) { }
+
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
 
-	cache = kmem_cache_create("test_cache", 200, 0, 0, NULL);
+	/* Provide a constructor to prevent cache merging. */
+	cache = kmem_cache_create("test_cache", 200, 0, 0, empty_cache_ctor);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 	kmem_cache_destroy(cache);
 	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_destroy(cache));
_
