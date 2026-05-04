Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CF03DDDDA;
	Mon,  4 May 2026 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903133; cv=none; b=f17YVxWs4CwiFa3jKqiUNHyYRUEs25hNFcwxg54PGMeChhwASgJ6DkiOYQ2QUyyrZ34h2kmRx4hLPty7iS0DCOhZWin7ryB6XjO8UhMzwTMcjI6SAtKo2D/idmYM9chQhmJYwEjxj6yM3qqqSZEVRBr57aRgB4lckr+Oi2mcHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903133; c=relaxed/simple;
	bh=sIpe88qAR6MYlHMFKVrircWdMvLSuWfhOKJIIXAZXeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=az2vpeCWSkrozw6Q/lwXgCrZSjd0AzwM40KgmczYZbmMzY4180AjABJFeMQx9kAP9zewUHgb8SxfGLc+9lxS5XXQ16NbLTR+hvdRo7R5m2YC0KigLTAKtyeJH1BD/TkkcS9oiMUkgTgK7HoDm8pxTyz7zYuOofTzDRyAo3SWxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfClSbjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfClSbjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1ABC2BCB8;
	Mon,  4 May 2026 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903133;
	bh=sIpe88qAR6MYlHMFKVrircWdMvLSuWfhOKJIIXAZXeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfClSbjHSAOHACMa2Jmy5eMR9C4DY4uF0la7qUbehocLmoXDTM7lCz7AidaeF2vkH
	 ugQhtM5Z6f3RghwtwmlF8UiECVvl/mW064S6yKcha7m0+2Tw1YuYI57xE67SlYwsXG
	 qBf1cIlyvjTo/aJDyuw6jRy6qoXXj8KAzZI37LYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.0 099/307] landlock: Allow TSYNC with LOG_SUBDOMAINS_OFF and fd=-1
Date: Mon,  4 May 2026 15:49:44 +0200
Message-ID: <20260504135146.539008624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit e75e38055b9df5eafd663c6db00e634f534dc426 upstream.

LANDLOCK_RESTRICT_SELF_TSYNC does not allow
LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF with ruleset_fd=-1, preventing
a multithreaded process from atomically propagating subdomain log muting
to all threads without creating a domain layer.  Relax the fd=-1
condition to accept TSYNC alongside LOG_SUBDOMAINS_OFF, and update the
documentation accordingly.

Add flag validation tests for all TSYNC combinations with ruleset_fd=-1,
and audit tests verifying both transition directions: muting via TSYNC
(logged to not logged) and override via TSYNC (not logged to logged).

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Fixes: 42fc7e6543f6 ("landlock: Multithreading support for landlock_restrict_self()")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260407164107.2012589-2-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/landlock.h                 |   4 +-
 security/landlock/syscalls.c                  |  14 +-
 tools/testing/selftests/landlock/audit_test.c | 233 ++++++++++++++++++
 tools/testing/selftests/landlock/tsync_test.c |  77 ++++++
 4 files changed, 322 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index f88fa1f68b77..d37603efc273 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -116,7 +116,9 @@ struct landlock_ruleset_attr {
  *     ``LANDLOCK_RESTRICT_SELF_LOG_SAME_EXEC_OFF``, this flag only affects
  *     future nested domains, not the one being created. It can also be used
  *     with a @ruleset_fd value of -1 to mute subdomain logs without creating a
- *     domain.
+ *     domain.  When combined with %LANDLOCK_RESTRICT_SELF_TSYNC and a
+ *     @ruleset_fd value of -1, this configuration is propagated to all threads
+ *     of the current process.
  *
  * The following flag supports policy enforcement in multithreaded processes:
  *
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 0d66a68677b7..a0bb664e0d31 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -512,10 +512,13 @@ SYSCALL_DEFINE2(landlock_restrict_self, const int, ruleset_fd, const __u32,
 
 	/*
 	 * It is allowed to set LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF with
-	 * -1 as ruleset_fd, but no other flag must be set.
+	 * -1 as ruleset_fd, optionally combined with
+	 * LANDLOCK_RESTRICT_SELF_TSYNC to propagate this configuration to all
+	 * threads.  No other flag must be set.
 	 */
 	if (!(ruleset_fd == -1 &&
-	      flags == LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF)) {
+	      (flags & ~LANDLOCK_RESTRICT_SELF_TSYNC) ==
+		      LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF)) {
 		/* Gets and checks the ruleset. */
 		ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_READ);
 		if (IS_ERR(ruleset))
@@ -537,9 +540,10 @@ SYSCALL_DEFINE2(landlock_restrict_self, const int, ruleset_fd, const __u32,
 
 	/*
 	 * The only case when a ruleset may not be set is if
-	 * LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF is set and ruleset_fd is -1.
-	 * We could optimize this case by not calling commit_creds() if this flag
-	 * was already set, but it is not worth the complexity.
+	 * LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF is set (optionally with
+	 * LANDLOCK_RESTRICT_SELF_TSYNC) and ruleset_fd is -1.  We could
+	 * optimize this case by not calling commit_creds() if this flag was
+	 * already set, but it is not worth the complexity.
 	 */
 	if (ruleset) {
 		/*
diff --git a/tools/testing/selftests/landlock/audit_test.c b/tools/testing/selftests/landlock/audit_test.c
index 20099b8667e7..897596cd7c80 100644
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -162,6 +162,7 @@ TEST_F(audit, layers)
 struct thread_data {
 	pid_t parent_pid;
 	int ruleset_fd, pipe_child, pipe_parent;
+	bool mute_subdomains;
 };
 
 static void *thread_audit_test(void *arg)
@@ -367,6 +368,238 @@ TEST_F(audit, log_subdomains_off_fork)
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
+/*
+ * Thread function: runs two rounds of (create domain, trigger denial, signal
+ * back), waiting for the main thread before each round.  When mute_subdomains
+ * is set, phase 1 also mutes subdomain logs via the fd=-1 path before creating
+ * the domain.  The ruleset_fd is kept open across both rounds so each
+ * restrict_self call stacks a new domain layer.
+ */
+static void *thread_sandbox_deny_twice(void *arg)
+{
+	const struct thread_data *data = (struct thread_data *)arg;
+	uintptr_t err = 0;
+	char buffer;
+
+	/* Phase 1: optionally mutes, creates a domain, and triggers a denial. */
+	if (read(data->pipe_parent, &buffer, 1) != 1) {
+		err = 1;
+		goto out;
+	}
+
+	if (data->mute_subdomains &&
+	    landlock_restrict_self(-1,
+				   LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF)) {
+		err = 2;
+		goto out;
+	}
+
+	if (landlock_restrict_self(data->ruleset_fd, 0)) {
+		err = 3;
+		goto out;
+	}
+
+	if (kill(data->parent_pid, 0) != -1 || errno != EPERM) {
+		err = 4;
+		goto out;
+	}
+
+	if (write(data->pipe_child, ".", 1) != 1) {
+		err = 5;
+		goto out;
+	}
+
+	/* Phase 2: stacks another domain and triggers a denial. */
+	if (read(data->pipe_parent, &buffer, 1) != 1) {
+		err = 6;
+		goto out;
+	}
+
+	if (landlock_restrict_self(data->ruleset_fd, 0)) {
+		err = 7;
+		goto out;
+	}
+
+	if (kill(data->parent_pid, 0) != -1 || errno != EPERM) {
+		err = 8;
+		goto out;
+	}
+
+	if (write(data->pipe_child, ".", 1) != 1) {
+		err = 9;
+		goto out;
+	}
+
+out:
+	close(data->ruleset_fd);
+	close(data->pipe_child);
+	close(data->pipe_parent);
+	return (void *)err;
+}
+
+/*
+ * Verifies that LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF with
+ * LANDLOCK_RESTRICT_SELF_TSYNC and ruleset_fd=-1 propagates log_subdomains_off
+ * to a sibling thread, suppressing audit logging on domains it subsequently
+ * creates.
+ *
+ * Phase 1 (before TSYNC) acts as an inline baseline: the sibling creates a
+ * domain and triggers a denial that IS logged.
+ *
+ * Phase 2 (after TSYNC) verifies suppression: the sibling stacks another domain
+ * and triggers a denial that is NOT logged.
+ */
+TEST_F(audit, log_subdomains_off_tsync)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.scoped = LANDLOCK_SCOPE_SIGNAL,
+	};
+	struct audit_records records;
+	struct thread_data child_data = {};
+	int pipe_child[2], pipe_parent[2];
+	char buffer;
+	pthread_t thread;
+	void *thread_ret;
+
+	child_data.parent_pid = getppid();
+	ASSERT_EQ(0, pipe2(pipe_child, O_CLOEXEC));
+	child_data.pipe_child = pipe_child[1];
+	ASSERT_EQ(0, pipe2(pipe_parent, O_CLOEXEC));
+	child_data.pipe_parent = pipe_parent[0];
+	child_data.ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, child_data.ruleset_fd);
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+
+	/* Creates the sibling thread. */
+	ASSERT_EQ(0, pthread_create(&thread, NULL, thread_sandbox_deny_twice,
+				    &child_data));
+
+	/*
+	 * Phase 1: the sibling creates a domain and triggers a denial before
+	 * any log muting.  This proves the audit path works.
+	 */
+	ASSERT_EQ(1, write(pipe_parent[1], ".", 1));
+	ASSERT_EQ(1, read(pipe_child[0], &buffer, 1));
+
+	/* The denial must be logged. */
+	EXPECT_EQ(0, matches_log_signal(_metadata, self->audit_fd,
+					child_data.parent_pid, NULL));
+
+	/* Drains any remaining records (e.g. domain allocation). */
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+
+	/*
+	 * Mutes subdomain logs and propagates to the sibling thread via TSYNC,
+	 * without creating a domain.
+	 */
+	ASSERT_EQ(0, landlock_restrict_self(
+			     -1, LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF |
+					 LANDLOCK_RESTRICT_SELF_TSYNC));
+
+	/*
+	 * Phase 2: the sibling stacks another domain and triggers a denial.
+	 * Because log_subdomains_off was propagated via TSYNC, the new domain
+	 * has log_status=LANDLOCK_LOG_DISABLED.
+	 */
+	ASSERT_EQ(1, write(pipe_parent[1], ".", 1));
+	ASSERT_EQ(1, read(pipe_child[0], &buffer, 1));
+
+	/* No denial record should appear. */
+	EXPECT_EQ(-EAGAIN, matches_log_signal(_metadata, self->audit_fd,
+					      child_data.parent_pid, NULL));
+
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+
+	EXPECT_EQ(0, close(pipe_child[0]));
+	EXPECT_EQ(0, close(pipe_parent[1]));
+	ASSERT_EQ(0, pthread_join(thread, &thread_ret));
+	EXPECT_EQ(NULL, thread_ret);
+}
+
+/*
+ * Verifies that LANDLOCK_RESTRICT_SELF_TSYNC without
+ * LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF overrides a sibling thread's
+ * log_subdomains_off, re-enabling audit logging on domains the sibling
+ * subsequently creates.
+ *
+ * Phase 1: the sibling sets log_subdomains_off, creates a muted domain, and
+ * triggers a denial that is NOT logged.
+ *
+ * Phase 2 (after TSYNC without LOG_SUBDOMAINS_OFF): the sibling stacks another
+ * domain and triggers a denial that IS logged, proving the muting was
+ * overridden.
+ */
+TEST_F(audit, tsync_override_log_subdomains_off)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.scoped = LANDLOCK_SCOPE_SIGNAL,
+	};
+	struct audit_records records;
+	struct thread_data child_data = {};
+	int pipe_child[2], pipe_parent[2];
+	char buffer;
+	pthread_t thread;
+	void *thread_ret;
+
+	child_data.parent_pid = getppid();
+	ASSERT_EQ(0, pipe2(pipe_child, O_CLOEXEC));
+	child_data.pipe_child = pipe_child[1];
+	ASSERT_EQ(0, pipe2(pipe_parent, O_CLOEXEC));
+	child_data.pipe_parent = pipe_parent[0];
+	child_data.ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, child_data.ruleset_fd);
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+
+	child_data.mute_subdomains = true;
+
+	/* Creates the sibling thread. */
+	ASSERT_EQ(0, pthread_create(&thread, NULL, thread_sandbox_deny_twice,
+				    &child_data));
+
+	/*
+	 * Phase 1: the sibling mutes subdomain logs, creates a domain, and
+	 * triggers a denial.  The denial must not be logged.
+	 */
+	ASSERT_EQ(1, write(pipe_parent[1], ".", 1));
+	ASSERT_EQ(1, read(pipe_child[0], &buffer, 1));
+
+	EXPECT_EQ(-EAGAIN, matches_log_signal(_metadata, self->audit_fd,
+					      child_data.parent_pid, NULL));
+
+	/* Drains any remaining records. */
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+
+	/*
+	 * Overrides the sibling's log_subdomains_off by calling TSYNC without
+	 * LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF.
+	 */
+	ASSERT_EQ(0, landlock_restrict_self(child_data.ruleset_fd,
+					    LANDLOCK_RESTRICT_SELF_TSYNC));
+
+	/*
+	 * Phase 2: the sibling stacks another domain and triggers a denial.
+	 * Because TSYNC replaced its log_subdomains_off with 0, the new domain
+	 * has log_status=LANDLOCK_LOG_PENDING.
+	 */
+	ASSERT_EQ(1, write(pipe_parent[1], ".", 1));
+	ASSERT_EQ(1, read(pipe_child[0], &buffer, 1));
+
+	/* The denial must be logged. */
+	EXPECT_EQ(0, matches_log_signal(_metadata, self->audit_fd,
+					child_data.parent_pid, NULL));
+
+	EXPECT_EQ(0, close(pipe_child[0]));
+	EXPECT_EQ(0, close(pipe_parent[1]));
+	ASSERT_EQ(0, pthread_join(thread, &thread_ret));
+	EXPECT_EQ(NULL, thread_ret);
+}
+
 FIXTURE(audit_flags)
 {
 	struct audit_filter audit_filter;
diff --git a/tools/testing/selftests/landlock/tsync_test.c b/tools/testing/selftests/landlock/tsync_test.c
index 2b9ad4f154f4..9cf1491bbaaf 100644
--- a/tools/testing/selftests/landlock/tsync_test.c
+++ b/tools/testing/selftests/landlock/tsync_test.c
@@ -247,4 +247,81 @@ TEST(tsync_interrupt)
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
+/* clang-format off */
+FIXTURE(tsync_without_ruleset) {};
+/* clang-format on */
+
+FIXTURE_VARIANT(tsync_without_ruleset)
+{
+	const __u32 flags;
+	const int expected_errno;
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tsync_without_ruleset, tsync_only) {
+	/* clang-format on */
+	.flags = LANDLOCK_RESTRICT_SELF_TSYNC,
+	.expected_errno = EBADF,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tsync_without_ruleset, subdomains_off_same_exec_off) {
+	/* clang-format on */
+	.flags = LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF |
+		 LANDLOCK_RESTRICT_SELF_LOG_SAME_EXEC_OFF |
+		 LANDLOCK_RESTRICT_SELF_TSYNC,
+	.expected_errno = EBADF,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tsync_without_ruleset, subdomains_off_new_exec_on) {
+	/* clang-format on */
+	.flags = LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF |
+		 LANDLOCK_RESTRICT_SELF_LOG_NEW_EXEC_ON |
+		 LANDLOCK_RESTRICT_SELF_TSYNC,
+	.expected_errno = EBADF,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tsync_without_ruleset, all_flags) {
+	/* clang-format on */
+	.flags = LANDLOCK_RESTRICT_SELF_LOG_SAME_EXEC_OFF |
+		 LANDLOCK_RESTRICT_SELF_LOG_NEW_EXEC_ON |
+		 LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF |
+		 LANDLOCK_RESTRICT_SELF_TSYNC,
+	.expected_errno = EBADF,
+};
+
+/* clang-format off */
+FIXTURE_VARIANT_ADD(tsync_without_ruleset, subdomains_off) {
+	/* clang-format on */
+	.flags = LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF |
+		 LANDLOCK_RESTRICT_SELF_TSYNC,
+	.expected_errno = 0,
+};
+
+FIXTURE_SETUP(tsync_without_ruleset)
+{
+	disable_caps(_metadata);
+}
+
+FIXTURE_TEARDOWN(tsync_without_ruleset)
+{
+}
+
+TEST_F(tsync_without_ruleset, check)
+{
+	int ret;
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+
+	ret = landlock_restrict_self(-1, variant->flags);
+	if (variant->expected_errno) {
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(variant->expected_errno, errno);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.54.0



