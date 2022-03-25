Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D693D1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DA4C36AE3;
	Fri, 25 Mar 2022 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170858;
	bh=nbyQ/0BYVWYhNlOtb8QL9frRoYDtdEEhU+RGzGww2RU=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=0E6gNbzSWUO7PWNpybdFS0jZ7DH1XNuTAPGt4bHeLhLERV/xVAEuotzSKRc4HxnUA
	 pPlLZYB0FORWSAueUjQlnSGamL70iSe5HScXz0QWs7akPdEicnKmoL7HFoMQplwu29
	 2zl6MKmOK7U+Wq7gsoEwVoNNl0A2jZSgFatZnHzY=
Date: Thu, 24 Mar 2022 18:14:18 -0700
To: shuah@kernel.org,keescook@chromium.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 114/114] selftests: kselftest framework: provide "finished" helper
Message-Id: <20220325011418.A0DA4C36AE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Kees Cook <keescook@chromium.org>
Subject: selftests: kselftest framework: provide "finished" helper

Instead of having each time that wants to use ksft_exit() have to figure
out the internals of kselftest.h, add the helper ksft_finished() that
makes sure the passes, xfails, and skips are equal to the test plan count.

Link: https://lkml.kernel.org/r/20220201013717.2464392-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h       |   10 ++++++++++
 tools/testing/selftests/vm/memfd_secret.c |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/kselftest.h~selftests-kselftest-framework-provide-finished-helper
+++ a/tools/testing/selftests/kselftest.h
@@ -28,6 +28,7 @@
  *
  * When all tests are finished, clean up and exit the program with one of:
  *
+ *    ksft_finished();
  *    ksft_exit(condition);
  *    ksft_exit_pass();
  *    ksft_exit_fail();
@@ -235,6 +236,15 @@ static inline int ksft_exit_fail(void)
 		ksft_exit_fail();	\
 	} while (0)
 
+/**
+ * ksft_finished() - Exit selftest with success if all tests passed
+ */
+#define ksft_finished()			\
+	ksft_exit(ksft_plan ==		\
+		  ksft_cnt.ksft_pass +	\
+		  ksft_cnt.ksft_xfail +	\
+		  ksft_cnt.ksft_xskip)
+
 static inline int ksft_exit_fail_msg(const char *msg, ...)
 {
 	int saved_errno = errno;
--- a/tools/testing/selftests/vm/memfd_secret.c~selftests-kselftest-framework-provide-finished-helper
+++ a/tools/testing/selftests/vm/memfd_secret.c
@@ -282,7 +282,7 @@ int main(int argc, char *argv[])
 
 	close(fd);
 
-	ksft_exit(!ksft_get_fail_cnt());
+	ksft_finished();
 }
 
 #else /* __NR_memfd_secret */
_
