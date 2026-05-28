Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C3924677F;
	Thu, 28 May 2026 20:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998564; cv=none; b=Yum8GN5W0rpXST7Ri9EOGKmblWZ0FWmweiscV/tXNsdvnl+/vQmDtM8U9esHZOuv8DHaTmtXnL94ruu+G/2zTxXwIoNh+fKpeqm1bo9Ucz0LZZLOHoqZI0LRCD657z3bLw/8zykrFWUl39eUxtY3KsPNyqTTUCc5FiW5UrHaAwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998564; c=relaxed/simple;
	bh=KPeWlRZtsXSoW5dLTj3j4OZbe8P0WfzLCzlXjXLmEJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Td/JYtTUohPUvd8SHGN0rhEKLcDFpBnNvFsf4a9Lck4LeGjb99iMJtzaaJ1wTDVyOlwCPxYNqdUy+aBara+KVm1IcVESjrOVtMFzpEZIg2DVDsu2Qi3QJuH/9MMLbdMEmOALa7aDuyRkZhQzX/zg74/1TT6IA985f9jfd1MzHHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQPgKGaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQPgKGaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940611F000E9;
	Thu, 28 May 2026 20:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998563;
	bh=Ejj9XMcukwWLMDbFgmlz7QTuBY1p0zbioHwYwRHc21w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQPgKGaqXVv/G944wrFupQZKCMSMqDSzn7pB6lBSJ/2KjPU/rwAC4pS0pZ8Bjx4P0
	 QNvDZ9yklXp0s1QxntQdk/cLJss2cIRvCzeqR2uV7p/veah6NWhaYsNdTNXp/lSD12
	 WiJbn9UIELud5VInlnr3WPqd5hWm/bZKEztjyzHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 218/461] test_kprobes: clear kprobes between test runs
Date: Thu, 28 May 2026 21:45:47 +0200
Message-ID: <20260528194653.439555517@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit ef5581bb30efb939cc2bf093475c6cc85258e5cd ]

Running the kprobes sanity tests twice makes all tests fail and
eventually crashes the kernel.

[root@martin-riscv-1 ~]# echo 1 > /sys/kernel/debug/kunit/kprobes_test/run
...
   # Totals: pass:5 fail:0 skip:0 total:5
   ok 1 kprobes_test
[root@martin-riscv-1 ~]# echo 1 > /sys/kernel/debug/kunit/kprobes_test/run
...
  # test_kprobe: EXPECTATION FAILED at lib/tests/test_kprobes.c:64
  Expected 0 == register_kprobe(&kp), but
      register_kprobe(&kp) == -22 (0xffffffffffffffea)
...
  Unable to handle kernel paging request ...

The testsuite defines several kprobes and kretprobes as static variables
that are preserved across test runs.

After register_kprobe and unregister_kprobe, a kprobe contains some
leftover data that must be cleared before the kprobe can be registered
again. The tests are setting symbol_name to define the probe location.
Address and flags must be cleared.

The existing code clears some of the probes between subsequent tests, but
not between two test runs. The leftover data from a previous test run
makes the registrations fail in the next run.

Move the cleanups for all kprobes into kprobes_test_init, this function
is called before each single test (including the first test of a test
run).

Link: https://lore.kernel.org/all/20260507134615.1010905-1-martin@kaiser.cx/

Fixes: e44e81c5b90f ("kprobes: convert tests to kunit")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/tests/test_kprobes.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/lib/tests/test_kprobes.c b/lib/tests/test_kprobes.c
index b7582010125c3..06e729e4de051 100644
--- a/lib/tests/test_kprobes.c
+++ b/lib/tests/test_kprobes.c
@@ -12,6 +12,12 @@
 
 #define div_factor 3
 
+#define KP_CLEAR(_kp) \
+do { \
+	(_kp).addr = NULL; \
+	(_kp).flags = 0; \
+} while (0)
+
 static u32 rand1, preh_val, posth_val;
 static u32 (*target)(u32 value);
 static u32 (*recursed_target)(u32 value);
@@ -125,10 +131,6 @@ static void test_kprobes(struct kunit *test)
 
 	current_test = test;
 
-	/* addr and flags should be cleard for reusing kprobe. */
-	kp.addr = NULL;
-	kp.flags = 0;
-
 	KUNIT_EXPECT_EQ(test, 0, register_kprobes(kps, 2));
 	preh_val = 0;
 	posth_val = 0;
@@ -226,9 +228,6 @@ static void test_kretprobes(struct kunit *test)
 	struct kretprobe *rps[2] = {&rp, &rp2};
 
 	current_test = test;
-	/* addr and flags should be cleard for reusing kprobe. */
-	rp.kp.addr = NULL;
-	rp.kp.flags = 0;
 	KUNIT_EXPECT_EQ(test, 0, register_kretprobes(rps, 2));
 
 	krph_val = 0;
@@ -290,8 +289,6 @@ static void test_stacktrace_on_kretprobe(struct kunit *test)
 	unsigned long myretaddr = (unsigned long)__builtin_return_address(0);
 
 	current_test = test;
-	rp3.kp.addr = NULL;
-	rp3.kp.flags = 0;
 
 	/*
 	 * Run the stacktrace_driver() to record correct return address in
@@ -352,8 +349,6 @@ static void test_stacktrace_on_nested_kretprobe(struct kunit *test)
 	struct kretprobe *rps[2] = {&rp3, &rp4};
 
 	current_test = test;
-	rp3.kp.addr = NULL;
-	rp3.kp.flags = 0;
 
 	//KUNIT_ASSERT_NE(test, myretaddr, stacktrace_driver());
 
@@ -367,6 +362,18 @@ static void test_stacktrace_on_nested_kretprobe(struct kunit *test)
 
 static int kprobes_test_init(struct kunit *test)
 {
+	KP_CLEAR(kp);
+	KP_CLEAR(kp2);
+	KP_CLEAR(kp_missed);
+#ifdef CONFIG_KRETPROBES
+	KP_CLEAR(rp.kp);
+	KP_CLEAR(rp2.kp);
+#ifdef CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
+	KP_CLEAR(rp3.kp);
+	KP_CLEAR(rp4.kp);
+#endif
+#endif
+
 	target = kprobe_target;
 	target2 = kprobe_target2;
 	recursed_target = kprobe_recursed_target;
-- 
2.53.0



