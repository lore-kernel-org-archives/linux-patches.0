Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95781EB5FD;
	Sat, 12 Sep 2026 07:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197740; cv=none; b=DTVcOp6yrKob9GCg+aOD5gItQ1dtgY1Pq0hYf/h0Cjg8Q+Sok7DJR6cAiwbz2zCUMshgKL1t1J1Nwr6Pq+UG5wQv2MgIlJSYAtOhgZV8VomB6tgTpMWhBPR5tS9DdoDwa1RhQjz9MgYwL7folTrMJ319NiCnVwzXHWHmQndBJdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197740; c=relaxed/simple;
	bh=R6WKnPXCvP/aabmy0BZomR8sFUHQBFPmqOh6osinOZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxwXhSIpF+hgwmi3Kcv8uEzVu/edPVSQFzVd7Ru3AgzlqEdDrF/Qlp2OpE+tucmbGUj5tIM2Wihq/IzdevA/5srpTNIR4/9NNFZxWzRicUh3geRg3GxJ4syM6LE0NJlFVU7JYZug4D2b5pCc2ZMm9WDa2VArYM3hJ8nvhI05xD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P70X0aS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P70X0aS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2861C1F00893;
	Sat, 12 Sep 2026 07:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197739;
	bh=22R1zDH4+q/O3VmcMWNVvfVSEopuVHdkrRy4OZnqPRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P70X0aS+D3YUbAvvimUKm04cogsvCwRxdoHTPITtB3lrAgZSgVmsvHMfk+7g0F3Db
	 YZPOYiYgRhPnk9VbhjITPkTverP40BwsnTq+YK8WQ/ZRuvUIOdgRBzgaSCHS1e89/4
	 9PL00APuXd0qZisLvB/4Nyd8agy/7Kj6OJphUbgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0238/1815] selftests/bpf: libarena: Clean up allocation state before buddy tests
Date: Sat, 12 Sep 2026 08:33:08 +0200
Message-ID: <20260912065654.577072389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit 14c2b770d15d5b0d814cdef114de55e01a281e00 ]

Summary: The buddy allocator requires the global BPF buddy allocator
to not be already initialized. However, the test currently merely resets
the allocator before the buddy tests instead of destroying it, and the
test worked because the buddy test happened to run first. Properly
destroy the allocator instead of resetting it.

Fixes: b1487dc1b181 ("selftests/bpf: Add selftests for libarena buddy allocator")
Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260706181730.21731-4-emil@etsalapatis.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/libarena/src/common.bpf.c  | 6 ++++++
 tools/testing/selftests/bpf/prog_tests/libarena.c      | 8 ++++++--
 tools/testing/selftests/bpf/prog_tests/libarena_asan.c | 8 ++++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/libarena/src/common.bpf.c b/tools/testing/selftests/bpf/libarena/src/common.bpf.c
index 50be57213dfb8..99553aac3d433 100644
--- a/tools/testing/selftests/bpf/libarena/src/common.bpf.c
+++ b/tools/testing/selftests/bpf/libarena/src/common.bpf.c
@@ -38,6 +38,12 @@ __weak int arena_buddy_reset(void)
 	return buddy_init(&buddy);
 }
 
+SEC("syscall")
+__weak int arena_buddy_destroy(void)
+{
+	return buddy_destroy(&buddy);
+}
+
 __weak void __arena *arena_malloc(size_t size)
 {
 	return buddy_alloc(&buddy, size);
diff --git a/tools/testing/selftests/bpf/prog_tests/libarena.c b/tools/testing/selftests/bpf/prog_tests/libarena.c
index 61ea68dce4105..ba5a5a50f7c07 100644
--- a/tools/testing/selftests/bpf/prog_tests/libarena.c
+++ b/tools/testing/selftests/bpf/prog_tests/libarena.c
@@ -15,7 +15,12 @@ static void run_libarena_test(struct libarena *skel, struct bpf_program *prog,
 {
 	int ret;
 
-	if (!strstr(name, "test_buddy")) {
+	if (strstr(name, "test_buddy")) {
+		/* Buddy tests initialize the allocator directly. */
+		ret = libarena_run_prog(bpf_program__fd(skel->progs.arena_buddy_destroy));
+		if (!ASSERT_OK(ret, "arena_buddy_destroy"))
+			return;
+	} else {
 		ret = libarena_run_prog(bpf_program__fd(skel->progs.arena_buddy_reset));
 		if (!ASSERT_OK(ret, "arena_buddy_reset"))
 			return;
@@ -24,7 +29,6 @@ static void run_libarena_test(struct libarena *skel, struct bpf_program *prog,
 	ret = libarena_run_prog(bpf_program__fd(prog));
 
 	ASSERT_OK(ret, name);
-
 }
 
 static void *run_libarena_parallel_prog(void *arg)
diff --git a/tools/testing/selftests/bpf/prog_tests/libarena_asan.c b/tools/testing/selftests/bpf/prog_tests/libarena_asan.c
index d59d9dd12ef2b..f897405f701dd 100644
--- a/tools/testing/selftests/bpf/prog_tests/libarena_asan.c
+++ b/tools/testing/selftests/bpf/prog_tests/libarena_asan.c
@@ -17,7 +17,12 @@ static void run_libarena_asan_test(struct libarena_asan *skel,
 {
 	int ret;
 
-	if (!strstr(name, "test_buddy")) {
+	if (strstr(name, "test_buddy")) {
+		/* Buddy tests initialize the allocator directly. */
+		ret = libarena_run_prog(bpf_program__fd(skel->progs.arena_buddy_destroy));
+		if (!ASSERT_OK(ret, "arena_buddy_destroy"))
+			return;
+	} else {
 		ret = libarena_run_prog(bpf_program__fd(skel->progs.arena_buddy_reset));
 		if (!ASSERT_OK(ret, "arena_buddy_reset"))
 			return;
@@ -90,4 +95,3 @@ void test_libarena_asan(void)
 
 	return;
 }
-
-- 
2.53.0



