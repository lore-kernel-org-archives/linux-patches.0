Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA942408039;
	Tue, 21 Jul 2026 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659326; cv=none; b=XB/Xj2ojTbIv5CRCwmKTi6/khHuZgajlhu5PeYfif8f4VXOfvoFIFUdYZxWfHl6AaW1J5lazxuOfh9ylA7UXKMve0SQgaPRCD4oOfzGquChMPZR10NK+4ZHjGEheoMamlb0ggrcTU66of/4120OGv22AYMTZu4ng41YWagTlaV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659326; c=relaxed/simple;
	bh=Vq54LyCB/Af4vL5tnIod1gkzc+qyuWrlnesf61hoWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YY6ABPnCTVi7VAmdWHBv76lV0NYx2Zt/uuC3jPuvQppATVa7xV5a+uT24tfey6wMxVG2d74EGJhTy2Xyn5K6NdOMZWa9Pe3Xp14Vr55dYYiZc3N3UnKxPzAqLpb8NEIa3mmeltWYj6n2Ec7wbTkQ/uJjRymrDkm6m0Tg0jUGq9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbC4XLJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbC4XLJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF301F000E9;
	Tue, 21 Jul 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659324;
	bh=InVS+IPuWNdq770b1XAtyfTnFjFtSMZlmyg05Y+k4nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbC4XLJHsjNNhiKfQNj92UgKSDemS2aOh7jaCvA/cwo/VmKbWyJ5zV59O0XgAvfBv
	 JxNOl5Cf0lad3vMd1XZyUKpUBdFVSHJEzibqYPaFizGneqgxz83asBDzRqs4Gq3ji0
	 bJw0yhktbfJ9SEkPDhhAzlViETp3MgBvBm+XqVq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 1476/1611] selftests/landlock: Fix screwed up pointers in the scoped_signal_test
Date: Tue, 21 Jul 2026 17:26:32 +0200
Message-ID: <20260721152548.645802111@linuxfoundation.org>
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

From: Thomas Huth <thuth@redhat.com>

commit d793186aa3bb833c878ae6826c87e62c843afaa3 upstream.

The scoped_signal_test uses pthread_join(..., (void **)&ret)) in
a couple of places, i.e. the return value of the thread is stored
in the shape of a "void *" into the memory location of &ret.
Pointers are 64-bit on modern computers, but the ret variable is
declared as a simple "enum thread_return" which is only 32 bits.
So the pthread_join() will overflow the ret variable by 4 byte.

The problem is very visible on big endian systems like s390x
where the test is failing: The least significant byte that carries
the return code of the thread is not written into the ret variable
here, but somewhere else in the stack frame, so the comparison
for the right return code is failing here.

Fix it by getting rid of the enum and defining the THREAD_* constants
and "ret" variables as proper "void *" pointers. This way we can
also get rid of some ugly (void *) castings in a couple of spots.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://patch.msgid.link/20260709164340.339656-1-thuth@redhat.com
Cc: stable@vger.kernel.org
Fixes: c8994965013e ("selftests/landlock: Test signal scoping for threads")
[mic: Add clang-format markups]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/scoped_signal_test.c |   46 +++++++++---------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -249,12 +249,12 @@ TEST_F(scoped_domains, check_access_sign
 		_metadata->exit_code = KSFT_FAIL;
 }
 
-enum thread_return {
-	THREAD_INVALID = 0,
-	THREAD_SUCCESS = 1,
-	THREAD_ERROR = 2,
-	THREAD_TEST_FAILED = 3,
-};
+/* clang-format off */
+#define THREAD_INVALID		((void *)0)
+#define THREAD_SUCCESS		((void *)1)
+#define THREAD_ERROR		((void *)2)
+#define THREAD_TEST_FAILED	((void *)3)
+/* clang-format on */
 
 static void *thread_sync(void *arg)
 {
@@ -262,15 +262,15 @@ static void *thread_sync(void *arg)
 	char buf;
 
 	if (read(pipe_read, &buf, 1) != 1)
-		return (void *)THREAD_ERROR;
+		return THREAD_ERROR;
 
-	return (void *)THREAD_SUCCESS;
+	return THREAD_SUCCESS;
 }
 
 TEST(signal_scoping_thread_before)
 {
 	pthread_t no_sandbox_thread;
-	enum thread_return ret = THREAD_INVALID;
+	void *ret = THREAD_INVALID;
 	int thread_pipe[2];
 
 	drop_caps(_metadata);
@@ -285,7 +285,7 @@ TEST(signal_scoping_thread_before)
 	EXPECT_EQ(0, pthread_kill(no_sandbox_thread, 0));
 	EXPECT_EQ(1, write(thread_pipe[1], ".", 1));
 
-	EXPECT_EQ(0, pthread_join(no_sandbox_thread, (void **)&ret));
+	EXPECT_EQ(0, pthread_join(no_sandbox_thread, &ret));
 	EXPECT_EQ(THREAD_SUCCESS, ret);
 
 	EXPECT_EQ(0, close(thread_pipe[0]));
@@ -295,7 +295,7 @@ TEST(signal_scoping_thread_before)
 TEST(signal_scoping_thread_after)
 {
 	pthread_t scoped_thread;
-	enum thread_return ret = THREAD_INVALID;
+	void *ret = THREAD_INVALID;
 	int thread_pipe[2];
 
 	drop_caps(_metadata);
@@ -310,7 +310,7 @@ TEST(signal_scoping_thread_after)
 	EXPECT_EQ(0, pthread_kill(scoped_thread, 0));
 	EXPECT_EQ(1, write(thread_pipe[1], ".", 1));
 
-	EXPECT_EQ(0, pthread_join(scoped_thread, (void **)&ret));
+	EXPECT_EQ(0, pthread_join(scoped_thread, &ret));
 	EXPECT_EQ(THREAD_SUCCESS, ret);
 
 	EXPECT_EQ(0, close(thread_pipe[0]));
@@ -327,20 +327,20 @@ void *thread_setuid(void *ptr)
 	char buf;
 
 	if (read(arg->pipe_read, &buf, 1) != 1)
-		return (void *)THREAD_ERROR;
+		return THREAD_ERROR;
 
 	/* libc's setuid() should update all thread's credentials. */
 	if (getuid() != arg->new_uid)
-		return (void *)THREAD_TEST_FAILED;
+		return THREAD_TEST_FAILED;
 
-	return (void *)THREAD_SUCCESS;
+	return THREAD_SUCCESS;
 }
 
 TEST(signal_scoping_thread_setuid)
 {
 	struct thread_setuid_args arg;
 	pthread_t no_sandbox_thread;
-	enum thread_return ret = THREAD_INVALID;
+	void *ret = THREAD_INVALID;
 	int pipe_parent[2];
 	int prev_uid;
 
@@ -367,7 +367,7 @@ TEST(signal_scoping_thread_setuid)
 	EXPECT_EQ(arg.new_uid, getuid());
 	EXPECT_EQ(1, write(pipe_parent[1], ".", 1));
 
-	EXPECT_EQ(0, pthread_join(no_sandbox_thread, (void **)&ret));
+	EXPECT_EQ(0, pthread_join(no_sandbox_thread, &ret));
 	EXPECT_EQ(THREAD_SUCCESS, ret);
 
 	clear_cap(_metadata, CAP_SETUID);
@@ -688,20 +688,20 @@ static void *thread_setown_scoped(void *
 	ruleset_fd =
 		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
 	if (ruleset_fd < 0)
-		return (void *)THREAD_ERROR;
+		return THREAD_ERROR;
 	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) ||
 	    landlock_restrict_self(ruleset_fd, 0)) {
 		close(ruleset_fd);
-		return (void *)THREAD_ERROR;
+		return THREAD_ERROR;
 	}
 	close(ruleset_fd);
 
 	/* Makes this process group own the SIGIO source. */
 	if (fcntl(fd, F_SETSIG, SIGURG) || fcntl(fd, F_SETOWN, -getpgrp()) ||
 	    fcntl(fd, F_SETFL, O_ASYNC))
-		return (void *)THREAD_ERROR;
+		return THREAD_ERROR;
 
-	return (void *)THREAD_SUCCESS;
+	return THREAD_SUCCESS;
 }
 
 /*
@@ -723,7 +723,7 @@ TEST(sigio_to_pgid_self)
 {
 	int trigger[2];
 	pthread_t thread;
-	enum thread_return ret = THREAD_INVALID;
+	void *ret = THREAD_INVALID;
 	int i;
 
 	drop_caps(_metadata);
@@ -743,7 +743,7 @@ TEST(sigio_to_pgid_self)
 	 */
 	ASSERT_EQ(0, pthread_create(&thread, NULL, thread_setown_scoped,
 				    &trigger[0]));
-	ASSERT_EQ(0, pthread_join(thread, (void **)&ret));
+	ASSERT_EQ(0, pthread_join(thread, &ret));
 	ASSERT_EQ(THREAD_SUCCESS, ret);
 
 	/* Fans SIGURG out to the process group. */


