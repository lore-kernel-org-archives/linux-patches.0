Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C11D1720;
	Wed,  2 Oct 2024 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879746; cv=none; b=mgIRQFRqKzTqsDvUL4QHHSA/PYV1j6B4sUc3xyQeQCiXT2hiRThb3wFG+4vQVToB7TNmCYSPRRPdxN2FqHg53ro72Jkz4MFaOilNt+ZOL9iul3PcRGGjcLPUEWRoCo3g3p9U8WWygFCVSHNZReYWhmuFQyomb8Plj6X9OG0eIwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879746; c=relaxed/simple;
	bh=+LgV3y8sOJ1EW16J30uOZGMNeHEaKLSqy64YQIH8oNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q99Wv9c+lbZIJ+lQyn+ulboIUPdU/kx3oaPiJmkD9+LXz9oVgxDXt2dJOaEy0/dsa9zagjnPN7jKoU9O7wuCmKDgAjZ8svHjLacgDZ1WegpaPABrEvN34tfA0f5HwgeeQgw+to0H82k+yoCore1obQE76mWKmugauL3T/wZUAiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po7d/P8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po7d/P8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0F6C4CEC2;
	Wed,  2 Oct 2024 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879746;
	bh=+LgV3y8sOJ1EW16J30uOZGMNeHEaKLSqy64YQIH8oNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po7d/P8H+eKLsoWRGPxhRjq5LUTEUtSSYvckamYD0sd5f1Rw3ByRB1V6xjcvR23NI
	 0Fi0Cr5aP3xy6GF+cPUJh7aO+y5cnfvth7KF9qrRIpLKrZpJ4ngkQgdr/GBQPRr4zP
	 NvkSQCVtnr2989ZGwsNaQiszp8bJdqfnh5lgxCEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/538] selftests/bpf: Refactor out some functions in ns_current_pid_tgid test
Date: Wed,  2 Oct 2024 14:57:16 +0200
Message-ID: <20241002125800.031546140@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 4d4bd29e363c467752536f874a2cba10a5923c59 ]

Refactor some functions in both user space code and bpf program
as these functions are used by later cgroup/sk_msg tests.
Another change is to mark tp program optional loading as later
patches will use optional loading as well since they have quite
different attachment and testing logic.

There is no functionality change.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240315184904.2976123-1-yonghong.song@linux.dev
Stable-dep-of: 21f0b0af9772 ("selftests/bpf: Fix include of <sys/fcntl.h>")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 53 ++++++++++++-------
 .../bpf/progs/test_ns_current_pid_tgid.c      | 10 ++--
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 3a0664a86243e..847d7b70e2902 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -16,30 +16,46 @@
 #define STACK_SIZE (1024 * 1024)
 static char child_stack[STACK_SIZE];
 
-static int test_current_pid_tgid(void *args)
+static int get_pid_tgid(pid_t *pid, pid_t *tgid,
+			struct test_ns_current_pid_tgid__bss *bss)
 {
-	struct test_ns_current_pid_tgid__bss  *bss;
-	struct test_ns_current_pid_tgid *skel;
-	int ret = -1, err;
-	pid_t tgid, pid;
 	struct stat st;
+	int err;
 
-	skel = test_ns_current_pid_tgid__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_ns_current_pid_tgid__open_and_load"))
-		goto out;
-
-	pid = syscall(SYS_gettid);
-	tgid = getpid();
+	*pid = syscall(SYS_gettid);
+	*tgid = getpid();
 
 	err = stat("/proc/self/ns/pid", &st);
 	if (!ASSERT_OK(err, "stat /proc/self/ns/pid"))
-		goto cleanup;
+		return err;
 
-	bss = skel->bss;
 	bss->dev = st.st_dev;
 	bss->ino = st.st_ino;
 	bss->user_pid = 0;
 	bss->user_tgid = 0;
+	return 0;
+}
+
+static int test_current_pid_tgid_tp(void *args)
+{
+	struct test_ns_current_pid_tgid__bss  *bss;
+	struct test_ns_current_pid_tgid *skel;
+	int ret = -1, err;
+	pid_t tgid, pid;
+
+	skel = test_ns_current_pid_tgid__open();
+	if (!ASSERT_OK_PTR(skel, "test_ns_current_pid_tgid__open"))
+		return ret;
+
+	bpf_program__set_autoload(skel->progs.tp_handler, true);
+
+	err = test_ns_current_pid_tgid__load(skel);
+	if (!ASSERT_OK(err, "test_ns_current_pid_tgid__load"))
+		goto cleanup;
+
+	bss = skel->bss;
+	if (get_pid_tgid(&pid, &tgid, bss))
+		goto cleanup;
 
 	err = test_ns_current_pid_tgid__attach(skel);
 	if (!ASSERT_OK(err, "test_ns_current_pid_tgid__attach"))
@@ -55,11 +71,10 @@ static int test_current_pid_tgid(void *args)
 
 cleanup:
 	test_ns_current_pid_tgid__destroy(skel);
-out:
 	return ret;
 }
 
-static void test_ns_current_pid_tgid_new_ns(void)
+static void test_ns_current_pid_tgid_new_ns(int (*fn)(void *), void *arg)
 {
 	int wstatus;
 	pid_t cpid;
@@ -67,8 +82,8 @@ static void test_ns_current_pid_tgid_new_ns(void)
 	/* Create a process in a new namespace, this process
 	 * will be the init process of this new namespace hence will be pid 1.
 	 */
-	cpid = clone(test_current_pid_tgid, child_stack + STACK_SIZE,
-		     CLONE_NEWPID | SIGCHLD, NULL);
+	cpid = clone(fn, child_stack + STACK_SIZE,
+		     CLONE_NEWPID | SIGCHLD, arg);
 
 	if (!ASSERT_NEQ(cpid, -1, "clone"))
 		return;
@@ -84,7 +99,7 @@ static void test_ns_current_pid_tgid_new_ns(void)
 void serial_test_ns_current_pid_tgid(void)
 {
 	if (test__start_subtest("root_ns_tp"))
-		test_current_pid_tgid(NULL);
+		test_current_pid_tgid_tp(NULL);
 	if (test__start_subtest("new_ns_tp"))
-		test_ns_current_pid_tgid_new_ns();
+		test_ns_current_pid_tgid_new_ns(test_current_pid_tgid_tp, NULL);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
index 0763d49f9c421..aa3ec7ca16d9b 100644
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -10,17 +10,21 @@ __u64 user_tgid = 0;
 __u64 dev = 0;
 __u64 ino = 0;
 
-SEC("tracepoint/syscalls/sys_enter_nanosleep")
-int handler(const void *ctx)
+static void get_pid_tgid(void)
 {
 	struct bpf_pidns_info nsdata;
 
 	if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata, sizeof(struct bpf_pidns_info)))
-		return 0;
+		return;
 
 	user_pid = nsdata.pid;
 	user_tgid = nsdata.tgid;
+}
 
+SEC("?tracepoint/syscalls/sys_enter_nanosleep")
+int tp_handler(const void *ctx)
+{
+	get_pid_tgid();
 	return 0;
 }
 
-- 
2.43.0



