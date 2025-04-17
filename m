Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C07214B092;
	Thu, 17 Apr 2025 18:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915010; cv=none; b=PIU+Of7FaSE/ul872uDBh5K6ynqjgiMGpXW4RABUQ+2Che7/oheAP2fLGOcK8NUyjNR1hu1f4wrtJIVKmvNyolg8eHmWnvf2FJUDEfiq61dyIt2R5T5z2GGvky6mlaHIBR6FIeapokiOBgztzZAijzwodtYIyjUrYm3Cu8DRh8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915010; c=relaxed/simple;
	bh=qhqiygk4CEdSHjDj1IKR2RjI+Du7kGmSbjyXeIcPc94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eCqvLYi2jN5ZmwFztTid2fLpwzgZbVf0isE5/r8cuOJu1HCK4fJEphkGhY9Lwkm9T4LEs5USoSS8kUI23mB9+naTpsYbMfTdHJC32uLf8ErHyOfqXe/L1FWr+WSYjxHGMM1cElohdqS0ZjLvSTvGX+5r/C46O593wk/z24ab6Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mswjRSzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mswjRSzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307A2C4CEE4;
	Thu, 17 Apr 2025 18:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915010;
	bh=qhqiygk4CEdSHjDj1IKR2RjI+Du7kGmSbjyXeIcPc94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mswjRSzfbYK9TKXCDJw4bGiyoIV2x5gHvpY4JjHuxvBECuUO386Ix4StqP77eo3Vm
	 zIIbMyomPKFqkR4oJEsWT0Javczh6kBXfoEidG9OBqqJtM7F5AZJUcc2zhsKXqu0Ga
	 pGP9n+0X+Ba/Tp6vq2R9BBiB4Lkgo+GKArZrBMU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Tahera Fahimi <fahimitahera@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 375/414] selftests/landlock: Add a new test for setuid()
Date: Thu, 17 Apr 2025 19:52:13 +0200
Message-ID: <20250417175126.543172807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit c5efa393d82cf68812e0ae4d93e339873eabe9fe upstream.

The new signal_scoping_thread_setuid tests check that the libc's
setuid() function works as expected even when a thread is sandboxed with
scoped signal restrictions.

Before the signal scoping fix, this test would have failed with the
setuid() call:

  [pid    65] getpid()                    = 65
  [pid    65] tgkill(65, 66, SIGRT_1)     = -1 EPERM (Operation not permitted)
  [pid    65] futex(0x40a66cdc, FUTEX_WAKE_PRIVATE, 1) = 0
  [pid    65] setuid(1001)                = 0

After the fix, tgkill(2) is successfully leveraged to synchronize
credentials update across threads:

  [pid    65] getpid()                    = 65
  [pid    65] tgkill(65, 66, SIGRT_1)     = 0
  [pid    66] <... read resumed>0x40a65eb7, 1) = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
  [pid    66] --- SIGRT_1 {si_signo=SIGRT_1, si_code=SI_TKILL, si_pid=65, si_uid=1000} ---
  [pid    66] getpid()                    = 65
  [pid    66] setuid(1001)                = 0
  [pid    66] futex(0x40a66cdc, FUTEX_WAKE_PRIVATE, 1) = 0
  [pid    66] rt_sigreturn({mask=[]})     = 0
  [pid    66] read(3,  <unfinished ...>
  [pid    65] setuid(1001)                = 0

Test coverage for security/landlock is 92.9% of 1137 lines according to
gcc/gcov-14.

Fixes: c8994965013e ("selftests/landlock: Test signal scoping for threads")
Cc: Günther Noack <gnoack@google.com>
Cc: Tahera Fahimi <fahimitahera@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-8-mic@digikod.net
[mic: Update test coverage]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/common.h             |    1 
 tools/testing/selftests/landlock/scoped_signal_test.c |   59 ++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -68,6 +68,7 @@ static void _init_caps(struct __test_met
 		CAP_MKNOD,
 		CAP_NET_ADMIN,
 		CAP_NET_BIND_SERVICE,
+		CAP_SETUID,
 		CAP_SYS_ADMIN,
 		CAP_SYS_CHROOT,
 		/* clang-format on */
--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -253,6 +253,7 @@ enum thread_return {
 	THREAD_INVALID = 0,
 	THREAD_SUCCESS = 1,
 	THREAD_ERROR = 2,
+	THREAD_TEST_FAILED = 3,
 };
 
 static void *thread_sync(void *arg)
@@ -316,6 +317,64 @@ TEST(signal_scoping_thread_after)
 	EXPECT_EQ(0, close(thread_pipe[1]));
 }
 
+struct thread_setuid_args {
+	int pipe_read, new_uid;
+};
+
+void *thread_setuid(void *ptr)
+{
+	const struct thread_setuid_args *arg = ptr;
+	char buf;
+
+	if (read(arg->pipe_read, &buf, 1) != 1)
+		return (void *)THREAD_ERROR;
+
+	/* libc's setuid() should update all thread's credentials. */
+	if (getuid() != arg->new_uid)
+		return (void *)THREAD_TEST_FAILED;
+
+	return (void *)THREAD_SUCCESS;
+}
+
+TEST(signal_scoping_thread_setuid)
+{
+	struct thread_setuid_args arg;
+	pthread_t no_sandbox_thread;
+	enum thread_return ret = THREAD_INVALID;
+	int pipe_parent[2];
+	int prev_uid;
+
+	disable_caps(_metadata);
+
+	/* This test does not need to be run as root. */
+	prev_uid = getuid();
+	arg.new_uid = prev_uid + 1;
+	EXPECT_LT(0, arg.new_uid);
+
+	ASSERT_EQ(0, pipe2(pipe_parent, O_CLOEXEC));
+	arg.pipe_read = pipe_parent[0];
+
+	/* Capabilities must be set before creating a new thread. */
+	set_cap(_metadata, CAP_SETUID);
+	ASSERT_EQ(0, pthread_create(&no_sandbox_thread, NULL, thread_setuid,
+				    &arg));
+
+	/* Enforces restriction after creating the thread. */
+	create_scoped_domain(_metadata, LANDLOCK_SCOPE_SIGNAL);
+
+	EXPECT_NE(arg.new_uid, getuid());
+	EXPECT_EQ(0, setuid(arg.new_uid));
+	EXPECT_EQ(arg.new_uid, getuid());
+	EXPECT_EQ(1, write(pipe_parent[1], ".", 1));
+
+	EXPECT_EQ(0, pthread_join(no_sandbox_thread, (void **)&ret));
+	EXPECT_EQ(THREAD_SUCCESS, ret);
+
+	clear_cap(_metadata, CAP_SETUID);
+	EXPECT_EQ(0, close(pipe_parent[0]));
+	EXPECT_EQ(0, close(pipe_parent[1]));
+}
+
 const short backlog = 10;
 
 static volatile sig_atomic_t signal_received;


