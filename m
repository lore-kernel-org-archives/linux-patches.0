Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4214B092;
	Thu, 17 Apr 2025 18:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915002; cv=none; b=EKc7wB4ulkKjYZRCXDPibsr3FGPEaGa+WC7UJorvHHDf/GMdquAuCCn1Z2Tjl7ftxqkOy2hl1DAQJtINFCHCYg6orAQk+3dZrJI5EwFiWyUveKevPKBlagDav0liLUMHfPf96COmgfTNwxen1metnHdJAZpBQNyiBGe2SbO1MMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915002; c=relaxed/simple;
	bh=U/d5VJpQ/XSRF4AZmEOh6vMH93ffrbrO1GYx3j36+LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BoUzFPShkrDT8b46f/gWb2BA7u8AnqFNh3+2jvXgQ5nt9Xdf3JWVoRfpRGsKqSuH2cxZ1rzGLi+kC8xOBz0QLKPx9DBR2HTQ9WsYn8TRPnPxUiVksB+L1h631wWV6eDG4p/JVJLSJYAWER6MV88dRQ7cTGfiHLt3RHiUBGQdnyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5NY8SUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5NY8SUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B911C4CEE4;
	Thu, 17 Apr 2025 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915001;
	bh=U/d5VJpQ/XSRF4AZmEOh6vMH93ffrbrO1GYx3j36+LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5NY8SUFvTiuH1RhsrScHxFmonsx0lJMwG4gn7tw0LXrNfdeZW8eSxcsOMEKVgJBg
	 BT1z9gd3prl5XjZcLo7bmIC6mU6B00DcG+CvA0bIZplCEJ01LAFjwcvCtKpEkIOnbE
	 Iei3xlJzQ+Ff/UhX1Mhb3LKg3wKQJglPR+SybiIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Tahera Fahimi <fahimitahera@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 374/414] selftests/landlock: Split signal_scoping_threads tests
Date: Thu, 17 Apr 2025 19:52:12 +0200
Message-ID: <20250417175126.503449640@linuxfoundation.org>
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
 


