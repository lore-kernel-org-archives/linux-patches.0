Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0E11A3178;
	Thu, 17 Apr 2025 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913661; cv=none; b=lNjvDMNas2+KcYyI2HA7MV/avBCAbX0slV50Cgp/UjQW06sYEjjoHTqELDV6SRcMhZnT/i5CsT9rIuskSX+ng6u7wWtCstUy5YwBt6Icf6jUCYr/MiOTdtJglOfXdEmdPxJD0tg67tFRLkoJreAchF2LxKf+rXqXd3Xn0e6sQf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913661; c=relaxed/simple;
	bh=5iWJhhK4hUIrF35mO7X0AHBIMNb8OwPiscLWO5Gm6Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lM744z8rdCSKHRIOV/bKuOtTtFnJpgDYlljhectFOwe3Lwcrt5xSZ40ubN/25n1jPE0p7JtEEYA+tk6YeU2Xl+9fQHnIrOlyBHuKxluqJQJn68hgGxH7Npp72/FJ+6rkaEzQLbFGRJS1Xc3Fu1ECPGdIiEDFDAySVf4CwO7f65Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNC42hdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNC42hdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6BBC4CEE4;
	Thu, 17 Apr 2025 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913661;
	bh=5iWJhhK4hUIrF35mO7X0AHBIMNb8OwPiscLWO5Gm6Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNC42hdFok7tfvajpegYuhyp4fZKjkxbdd4CFH0w4S2fAQGBZJRMCc9+83C6yAJ/e
	 jiIRhgj30mPdVOaWlLcAnfKLUtAuSp6Ff/r0i9xhTboit+JQlCskiVStk5+trmetiX
	 /SwPpBOQVu3I0s0OHd0r6rKAhdVqy/Opf2+TDA7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Tahera Fahimi <fahimitahera@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.14 411/449] selftests/landlock: Split signal_scoping_threads tests
Date: Thu, 17 Apr 2025 19:51:39 +0200
Message-ID: <20250417175134.827096036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit bbe72274035a83159c8fff7d553b4a0b3c473690 upstream.

Split signal_scoping_threads tests into signal_scoping_thread_before
and signal_scoping_thread_after.

Use local variables for thread synchronization.  Fix exported function.
Replace some asserts with expects.

Fixes: c8994965013e ("selftests/landlock: Test signal scoping for threads")
Cc: Günther Noack <gnoack@google.com>
Cc: Tahera Fahimi <fahimitahera@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-7-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/scoped_signal_test.c |   49 ++++++++++++------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -249,47 +249,66 @@ TEST_F(scoped_domains, check_access_sign
 		_metadata->exit_code = KSFT_FAIL;
 }
 
-static int thread_pipe[2];
-
 enum thread_return {
 	THREAD_INVALID = 0,
 	THREAD_SUCCESS = 1,
 	THREAD_ERROR = 2,
 };
 
-void *thread_func(void *arg)
+static void *thread_sync(void *arg)
 {
+	const int pipe_read = *(int *)arg;
 	char buf;
 
-	if (read(thread_pipe[0], &buf, 1) != 1)
+	if (read(pipe_read, &buf, 1) != 1)
 		return (void *)THREAD_ERROR;
 
 	return (void *)THREAD_SUCCESS;
 }
 
-TEST(signal_scoping_threads)
+TEST(signal_scoping_thread_before)
 {
-	pthread_t no_sandbox_thread, scoped_thread;
+	pthread_t no_sandbox_thread;
 	enum thread_return ret = THREAD_INVALID;
+	int thread_pipe[2];
 
 	drop_caps(_metadata);
 	ASSERT_EQ(0, pipe2(thread_pipe, O_CLOEXEC));
 
-	ASSERT_EQ(0,
-		  pthread_create(&no_sandbox_thread, NULL, thread_func, NULL));
+	ASSERT_EQ(0, pthread_create(&no_sandbox_thread, NULL, thread_sync,
+				    &thread_pipe[0]));
 
-	/* Restricts the domain after creating the first thread. */
+	/* Enforces restriction after creating the thread. */
 	create_scoped_domain(_metadata, LANDLOCK_SCOPE_SIGNAL);
 
-	ASSERT_EQ(0, pthread_kill(no_sandbox_thread, 0));
-	ASSERT_EQ(1, write(thread_pipe[1], ".", 1));
-
-	ASSERT_EQ(0, pthread_create(&scoped_thread, NULL, thread_func, NULL));
-	ASSERT_EQ(0, pthread_kill(scoped_thread, 0));
-	ASSERT_EQ(1, write(thread_pipe[1], ".", 1));
+	EXPECT_EQ(0, pthread_kill(no_sandbox_thread, 0));
+	EXPECT_EQ(1, write(thread_pipe[1], ".", 1));
 
 	EXPECT_EQ(0, pthread_join(no_sandbox_thread, (void **)&ret));
 	EXPECT_EQ(THREAD_SUCCESS, ret);
+
+	EXPECT_EQ(0, close(thread_pipe[0]));
+	EXPECT_EQ(0, close(thread_pipe[1]));
+}
+
+TEST(signal_scoping_thread_after)
+{
+	pthread_t scoped_thread;
+	enum thread_return ret = THREAD_INVALID;
+	int thread_pipe[2];
+
+	drop_caps(_metadata);
+	ASSERT_EQ(0, pipe2(thread_pipe, O_CLOEXEC));
+
+	/* Enforces restriction before creating the thread. */
+	create_scoped_domain(_metadata, LANDLOCK_SCOPE_SIGNAL);
+
+	ASSERT_EQ(0, pthread_create(&scoped_thread, NULL, thread_sync,
+				    &thread_pipe[0]));
+
+	EXPECT_EQ(0, pthread_kill(scoped_thread, 0));
+	EXPECT_EQ(1, write(thread_pipe[1], ".", 1));
+
 	EXPECT_EQ(0, pthread_join(scoped_thread, (void **)&ret));
 	EXPECT_EQ(THREAD_SUCCESS, ret);
 


