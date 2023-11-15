Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C90364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0jNwYfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CC3C433CB;
	Wed, 15 Nov 2023 19:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076463;
	bh=zJWjHQaIZye4mP1AcMrE2pBIk04GIs1VCLWIobUOvOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0jNwYfJdUAtVkSWVO3r1Fvzhd/Efj5PUyexljdE8XXBx+UV/WwLI8mMlD2N+Piq7
	 nD0AgYXUyunGML/nrNj1R/haaCcl8orj6DZOvAqIYAI4NXfd4DjPs7j5rW/CtIta+Y
	 U8zE/AnFCTlw6pQC+0zqKMP16fxLV2TQCJi+d2K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	kernel test robot <lkp@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 282/550] kunit: test: Fix the possible memory leak in executor_test
Date: Wed, 15 Nov 2023 14:14:26 -0500
Message-ID: <20231115191620.338190864@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 8040345fdae4cb256c5d981f91ae0f22bea8adcc ]

When CONFIG_KUNIT_ALL_TESTS=y, making CONFIG_DEBUG_KMEMLEAK=y and
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y, the below memory leak is detected.

If kunit_filter_suites() succeeds, not only copy but also filtered_suite
and filtered_suite->test_cases should be freed.

So as Rae suggested, to avoid the suite set never be freed when
KUNIT_ASSERT_EQ() fails and exits after kunit_filter_suites() succeeds,
update kfree_at_end() func to free_suite_set_at_end() to use
kunit_free_suite_set() to free them as kunit_module_exit() and
kunit_run_all_tests() do it. As the second arg got of
free_suite_set_at_end() is a local variable, copy it for free to avoid
wild-memory-access. After applying this patch, the following memory leak
is never detected.

unreferenced object 0xffff8881001de400 (size 1024):
  comm "kunit_try_catch", pid 1396, jiffies 4294720452 (age 932.801s)
  hex dump (first 32 bytes):
    73 75 69 74 65 32 00 00 00 00 00 00 00 00 00 00  suite2..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817db753>] __kmalloc_node_track_caller+0x53/0x150
    [<ffffffff817bd242>] kmemdup+0x22/0x50
    [<ffffffff829e961d>] kunit_filter_suites+0x44d/0xcc0
    [<ffffffff829eb69f>] filter_suites_test+0x12f/0x360
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20
unreferenced object 0xffff8881052cd388 (size 192):
  comm "kunit_try_catch", pid 1396, jiffies 4294720452 (age 932.801s)
  hex dump (first 32 bytes):
    a0 85 9e 82 ff ff ff ff 80 cd 7c 84 ff ff ff ff  ..........|.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817dbad2>] __kmalloc+0x52/0x150
    [<ffffffff829e9651>] kunit_filter_suites+0x481/0xcc0
    [<ffffffff829eb69f>] filter_suites_test+0x12f/0x360
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20

unreferenced object 0xffff888100da8400 (size 1024):
  comm "kunit_try_catch", pid 1398, jiffies 4294720454 (age 781.945s)
  hex dump (first 32 bytes):
    73 75 69 74 65 32 00 00 00 00 00 00 00 00 00 00  suite2..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817db753>] __kmalloc_node_track_caller+0x53/0x150
    [<ffffffff817bd242>] kmemdup+0x22/0x50
    [<ffffffff829e961d>] kunit_filter_suites+0x44d/0xcc0
    [<ffffffff829eb13f>] filter_suites_test_glob_test+0x12f/0x560
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20
unreferenced object 0xffff888105117878 (size 96):
  comm "kunit_try_catch", pid 1398, jiffies 4294720454 (age 781.945s)
  hex dump (first 32 bytes):
    a0 85 9e 82 ff ff ff ff a0 ac 7c 84 ff ff ff ff  ..........|.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817dbad2>] __kmalloc+0x52/0x150
    [<ffffffff829e9651>] kunit_filter_suites+0x481/0xcc0
    [<ffffffff829eb13f>] filter_suites_test_glob_test+0x12f/0x560
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20
unreferenced object 0xffff888102c31c00 (size 1024):
  comm "kunit_try_catch", pid 1404, jiffies 4294720460 (age 781.948s)
  hex dump (first 32 bytes):
    6e 6f 72 6d 61 6c 5f 73 75 69 74 65 00 00 00 00  normal_suite....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817db753>] __kmalloc_node_track_caller+0x53/0x150
    [<ffffffff817bd242>] kmemdup+0x22/0x50
    [<ffffffff829ecf17>] kunit_filter_attr_tests+0xf7/0x860
    [<ffffffff829e99ff>] kunit_filter_suites+0x82f/0xcc0
    [<ffffffff829ea975>] filter_attr_test+0x195/0x5f0
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20
unreferenced object 0xffff8881052cd250 (size 192):
  comm "kunit_try_catch", pid 1404, jiffies 4294720460 (age 781.948s)
  hex dump (first 32 bytes):
    a0 85 9e 82 ff ff ff ff 00 a9 7c 84 ff ff ff ff  ..........|.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817dbad2>] __kmalloc+0x52/0x150
    [<ffffffff829ecfc1>] kunit_filter_attr_tests+0x1a1/0x860
    [<ffffffff829e99ff>] kunit_filter_suites+0x82f/0xcc0
    [<ffffffff829ea975>] filter_attr_test+0x195/0x5f0
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20
unreferenced object 0xffff888104f4e400 (size 1024):
  comm "kunit_try_catch", pid 1408, jiffies 4294720464 (age 781.944s)
  hex dump (first 32 bytes):
    73 75 69 74 65 00 00 00 00 00 00 00 00 00 00 00  suite...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817db753>] __kmalloc_node_track_caller+0x53/0x150
    [<ffffffff817bd242>] kmemdup+0x22/0x50
    [<ffffffff829ecf17>] kunit_filter_attr_tests+0xf7/0x860
    [<ffffffff829e99ff>] kunit_filter_suites+0x82f/0xcc0
    [<ffffffff829e9fc3>] filter_attr_skip_test+0x133/0x6e0
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20
unreferenced object 0xffff8881052cc620 (size 192):
  comm "kunit_try_catch", pid 1408, jiffies 4294720464 (age 781.944s)
  hex dump (first 32 bytes):
    a0 85 9e 82 ff ff ff ff c0 a8 7c 84 ff ff ff ff  ..........|.....
    00 00 00 00 00 00 00 00 02 00 00 00 02 00 00 00  ................
  backtrace:
    [<ffffffff817dbad2>] __kmalloc+0x52/0x150
    [<ffffffff829ecfc1>] kunit_filter_attr_tests+0x1a1/0x860
    [<ffffffff829e99ff>] kunit_filter_suites+0x82f/0xcc0
    [<ffffffff829e9fc3>] filter_attr_skip_test+0x133/0x6e0
    [<ffffffff829e802a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
    [<ffffffff81236fc6>] kthread+0x2b6/0x380
    [<ffffffff81096afd>] ret_from_fork+0x2d/0x70
    [<ffffffff81003511>] ret_from_fork_asm+0x11/0x20

Fixes: e5857d396f35 ("kunit: flatten kunit_suite*** to kunit_suite** in .kunit_test_suites")
Fixes: 76066f93f1df ("kunit: add tests for filtering attributes")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Suggested-by: David Gow <davidgow@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309142251.uJ8saAZv-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202309270433.wGmFRGjd-lkp@intel.com/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor_test.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/lib/kunit/executor_test.c b/lib/kunit/executor_test.c
index ce6749af374de..d3ee0fefa8f99 100644
--- a/lib/kunit/executor_test.c
+++ b/lib/kunit/executor_test.c
@@ -8,7 +8,7 @@
 
 #include <kunit/test.h>
 
-static void kfree_at_end(struct kunit *test, const void *to_free);
+static void free_suite_set_at_end(struct kunit *test, const void *to_free);
 static struct kunit_suite *alloc_fake_suite(struct kunit *test,
 					    const char *suite_name,
 					    struct kunit_case *test_cases);
@@ -53,7 +53,7 @@ static void filter_suites_test(struct kunit *test)
 	got = kunit_filter_suites(&suite_set, "suite2", &err);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, got.start);
 	KUNIT_ASSERT_EQ(test, err, 0);
-	kfree_at_end(test, got.start);
+	free_suite_set_at_end(test, &got);
 
 	/* Validate we just have suite2 */
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, got.start[0]);
@@ -77,7 +77,7 @@ static void filter_suites_test_glob_test(struct kunit *test)
 	got = kunit_filter_suites(&suite_set, "suite2.test2", &err);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, got.start);
 	KUNIT_ASSERT_EQ(test, err, 0);
-	kfree_at_end(test, got.start);
+	free_suite_set_at_end(test, &got);
 
 	/* Validate we just have suite2 */
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, got.start[0]);
@@ -102,7 +102,7 @@ static void filter_suites_to_empty_test(struct kunit *test)
 
 	got = kunit_filter_suites(&suite_set, "not_found", &err);
 	KUNIT_ASSERT_EQ(test, err, 0);
-	kfree_at_end(test, got.start); /* just in case */
+	free_suite_set_at_end(test, &got); /* just in case */
 
 	KUNIT_EXPECT_PTR_EQ_MSG(test, got.start, got.end,
 				"should be empty to indicate no match");
@@ -125,18 +125,26 @@ kunit_test_suites(&executor_test_suite);
 
 /* Test helpers */
 
-/* Use the resource API to register a call to kfree(to_free).
+static void free_suite_set(void *suite_set)
+{
+	kunit_free_suite_set(*(struct kunit_suite_set *)suite_set);
+	kfree(suite_set);
+}
+
+/* Use the resource API to register a call to free_suite_set.
  * Since we never actually use the resource, it's safe to use on const data.
  */
-static void kfree_at_end(struct kunit *test, const void *to_free)
+static void free_suite_set_at_end(struct kunit *test, const void *to_free)
 {
-	/* kfree() handles NULL already, but avoid allocating a no-op cleanup. */
-	if (IS_ERR_OR_NULL(to_free))
+	struct kunit_suite_set *free;
+
+	if (!((struct kunit_suite_set *)to_free)->start)
 		return;
 
-	kunit_add_action(test,
-			(kunit_action_t *)kfree,
-			(void *)to_free);
+	free = kzalloc(sizeof(struct kunit_suite_set), GFP_KERNEL);
+	*free = *(struct kunit_suite_set *)to_free;
+
+	kunit_add_action(test, free_suite_set, (void *)free);
 }
 
 static struct kunit_suite *alloc_fake_suite(struct kunit *test,
-- 
2.42.0



