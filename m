Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833B635C1A6;
	Tue, 21 Jul 2026 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658719; cv=none; b=UEbk+P78RF+LadoXmIWzuXrhK13sbuK6jPGim1y2QshOzsR2Om7mGmfJ6rLOxCg1MVE4Xc4hWHQOy2esP8n2azxI05rU8p5i0IvdSVS0INxN4cdJDnX87ecTC0suanaf+xXnAuXPczPglWuSRRZg54ysLJEAQfJKF1o39TyBZjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658719; c=relaxed/simple;
	bh=knIlLmKYCCD/VNM0A13TSRe+slsZ4EE1I2Tpzhde038=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUsiPmS623vek0WSLB09nBL/vGH/AZ7M4Hk0DRhtCyokvIwpUj3SagYDSFOKVxdFkH0wqjOVLvuvTSKNQy4Jv3NDyDXk6xlcNddwmo4g29C32/lepPjF/7gkh4p/v8de+8PWTltLlStTRelX3Rm9WPpWIacKpcm98YEfuH6kbG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ6mBzqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ6mBzqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E477E1F000E9;
	Tue, 21 Jul 2026 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658718;
	bh=uRcE9HQV6Aq1v3WXpbd9YnOWyz01v7RQYyetncmdxko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ6mBzqdbSVe9tXAcYgiHgJWQIPizhziDVIhDZroA4PLfkvAv2ROaRNQ9JzINStK4
	 CvSS99GlsvPKUjVwiV2ATAWGS0oArjIQzhlV5309CDLsolbgFd3LnzK6p4TSZbPoFQ
	 P3webFl95da5jBeQlkeSCrB/AdMR45NLwUiJVw1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 1247/1611] selftests/landlock: Test SCOPE_SIGNAL on the SIGIO/fowner pgid path
Date: Tue, 21 Jul 2026 17:22:43 +0200
Message-ID: <20260721152543.493269193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 76579d09beedaffe7fe76e9c05644f73983e1ceb upstream.

Add regression tests for the LANDLOCK_SCOPE_SIGNAL handling of the
asynchronous SIGIO delivery path (fcntl(F_SETOWN)) with a process-group
owner.

sigio_to_pgid_members covers the bypass: a sandboxed process at the head
of its process group's PGID hlist (the default after fork()) arms
F_SETOWN(-pgrp) + O_ASYNC and triggers the fan-out; the in-domain owner
must be signaled (proving the trigger fired) while the non-sandboxed
member of the group, outside the domain, must not.

sigio_to_pgid_self covers the same-process guarantee: the owner is
registered from a sandboxed non-leader thread, whose domain differs from
the thread-group leader the kernel signals for a process-group owner.
That leader belongs to the owner's own process and must still be
signaled.

Without the fix the first test sees the out-of-domain member signaled
and the second sees the owner's own leader denied.

Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://patch.msgid.link/43370e89f7a896a583bf33d1cd171d02630e61bf.1780614610.git.hexlabsecurity@proton.me
[mic: Fix comment]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/scoped_signal_test.c |  182 ++++++++++++++++++
 1 file changed, 182 insertions(+)

--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -559,4 +559,186 @@ TEST_F(fown, sigurg_socket)
 		_metadata->exit_code = KSFT_FAIL;
 }
 
+/*
+ * Checks that LANDLOCK_SCOPE_SIGNAL is enforced on the asynchronous SIGIO
+ * delivery path (fcntl(F_SETOWN)) when the file owner is a process group.
+ *
+ * A sandboxed process sitting at the head of its process group's PID hlist (the
+ * default position right after fork()) used to escape the fcntl(F_SETOWN,
+ * -pgrp) domain recording: pid_task(pgrp, PIDTYPE_PGID) resolved to the process
+ * itself, so the same-thread-group exemption skipped recording its Landlock
+ * domain.  At SIGIO time that domain was then unset and the signal fanned out
+ * to every group member, including non-sandboxed processes outside the domain.
+ */
+TEST(sigio_to_pgid_members)
+{
+	int trigger[2], sync_child[2];
+	char buf;
+	pid_t child;
+	int status, i;
+
+	drop_caps(_metadata);
+
+	/*
+	 * Isolates the test in its own process group so the SIGIO fan-out stays
+	 * bounded to this parent and the child forked below.
+	 */
+	ASSERT_EQ(0, setpgid(0, 0));
+
+	/* The non-sandboxed parent is the protected (out-of-domain) target. */
+	ASSERT_EQ(0, setup_signal_handler(SIGURG));
+	signal_received = 0;
+
+	ASSERT_EQ(0, pipe2(trigger, O_CLOEXEC));
+	ASSERT_EQ(0, pipe2(sync_child, O_CLOEXEC));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/*
+		 * The child inherits the parent's new process group and, just
+		 * attached with hlist_add_head_rcu(), is now the head of the
+		 * pgid hlist: this is the case that used to skip the recording.
+		 */
+		EXPECT_EQ(0, close(sync_child[0]));
+
+		/* In-domain positive control: the child must be signaled. */
+		ASSERT_EQ(0, setup_signal_handler(SIGURG));
+		signal_received = 0;
+
+		create_scoped_domain(_metadata, LANDLOCK_SCOPE_SIGNAL);
+
+		/* Owns the SIGIO source for the whole process group. */
+		ASSERT_EQ(0, fcntl(trigger[0], F_SETSIG, SIGURG));
+		ASSERT_EQ(0, fcntl(trigger[0], F_SETOWN, -getpgrp()));
+		ASSERT_EQ(0, fcntl(trigger[0], F_SETFL, O_ASYNC));
+
+		/* Fans SIGURG out to every member of the process group. */
+		ASSERT_EQ(1, write(trigger[1], ".", 1));
+
+		/*
+		 * The sandboxed child is in its own domain and must always be
+		 * signaled: this proves the SIGIO actually fired.
+		 */
+		for (i = 0; i < 1000 && !signal_received; i++)
+			usleep(1000);
+		EXPECT_EQ(1, signal_received);
+
+		ASSERT_EQ(1, write(sync_child[1], ".", 1));
+		EXPECT_EQ(0, close(sync_child[1]));
+
+		_exit(_metadata->exit_code);
+		return;
+	}
+	EXPECT_EQ(0, close(sync_child[1]));
+	EXPECT_EQ(0, close(trigger[0]));
+	EXPECT_EQ(0, close(trigger[1]));
+
+	/* Waits for the child to generate the SIGIO. */
+	ASSERT_EQ(1, read(sync_child[0], &buf, 1));
+	EXPECT_EQ(0, close(sync_child[0]));
+
+	/* Lets a delivered-but-pending signal run our handler, if any. */
+	for (i = 0; i < 100 && !signal_received; i++)
+		usleep(1000);
+
+	/*
+	 * SCOPE_SIGNAL must block the fan-out to this non-sandboxed parent,
+	 * which is outside the child's Landlock domain.  Before the fix the
+	 * parent was signaled here.
+	 */
+	EXPECT_EQ(0, signal_received);
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	if (WIFSIGNALED(status) || !WIFEXITED(status) ||
+	    WEXITSTATUS(status) != EXIT_SUCCESS)
+		_metadata->exit_code = KSFT_FAIL;
+}
+
+static void *thread_setown_scoped(void *arg)
+{
+	const int fd = *(int *)arg;
+	int ruleset_fd;
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.scoped = LANDLOCK_SCOPE_SIGNAL,
+	};
+
+	/* Sandboxes only this non-leader thread (no thread syncing). */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	if (ruleset_fd < 0)
+		return (void *)THREAD_ERROR;
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) ||
+	    landlock_restrict_self(ruleset_fd, 0)) {
+		close(ruleset_fd);
+		return (void *)THREAD_ERROR;
+	}
+	close(ruleset_fd);
+
+	/* Makes this process group own the SIGIO source. */
+	if (fcntl(fd, F_SETSIG, SIGURG) || fcntl(fd, F_SETOWN, -getpgrp()) ||
+	    fcntl(fd, F_SETFL, O_ASYNC))
+		return (void *)THREAD_ERROR;
+
+	return (void *)THREAD_SUCCESS;
+}
+
+/*
+ * Checks that the SIGIO fan-out is still delivered to the file owner's own
+ * process when fcntl(F_SETOWN, -pgrp) was issued from a sandboxed non-leader
+ * thread.
+ *
+ * The Landlock domain is recorded for a process-group owner (so out-of-domain
+ * members stay blocked, see sigio_to_pgid_members), but the kernel signals a
+ * process group through its members' thread-group leaders.  Here the leader is
+ * not sandboxed and thus has a different domain than the registering thread, so
+ * the registration-time check cannot tell that it belongs to the owner's own
+ * process.  hook_file_send_sigiotask() must recognize it through the recorded
+ * thread group and allow the delivery, matching the same-process guarantee of
+ * commit 18eb75f3af40.  Without that exemption the leader is wrongly denied and
+ * never signaled.
+ */
+TEST(sigio_to_pgid_self)
+{
+	int trigger[2];
+	pthread_t thread;
+	enum thread_return ret = THREAD_INVALID;
+	int i;
+
+	drop_caps(_metadata);
+
+	/* Bounds the SIGIO fan-out to this process. */
+	ASSERT_EQ(0, setpgid(0, 0));
+
+	/* The non-sandboxed thread-group leader is the SIGIO target. */
+	ASSERT_EQ(0, setup_signal_handler(SIGURG));
+	signal_received = 0;
+
+	ASSERT_EQ(0, pipe2(trigger, O_CLOEXEC));
+
+	/*
+	 * Registers the process-group fowner from a sibling thread that
+	 * sandboxes only itself, so its domain differs from the leader's.
+	 */
+	ASSERT_EQ(0, pthread_create(&thread, NULL, thread_setown_scoped,
+				    &trigger[0]));
+	ASSERT_EQ(0, pthread_join(thread, (void **)&ret));
+	ASSERT_EQ(THREAD_SUCCESS, ret);
+
+	/* Fans SIGURG out to the process group. */
+	ASSERT_EQ(1, write(trigger[1], ".", 1));
+
+	for (i = 0; i < 1000 && !signal_received; i++)
+		usleep(1000);
+
+	/*
+	 * Same-process delivery must always be allowed, even though the owner
+	 * was registered from a sandboxed sibling thread.
+	 */
+	EXPECT_EQ(1, signal_received);
+
+	EXPECT_EQ(0, close(trigger[0]));
+	EXPECT_EQ(0, close(trigger[1]));
+}
+
 TEST_HARNESS_MAIN


