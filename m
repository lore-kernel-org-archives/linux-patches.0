Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060008;
	b=Lval0DLMtwmViDbUCBvNd5cpb0ESAVCBdWHaSeWGTyPykYnVOmfQOGLaEn2lxj13G5YN
	 x6DB0yFsP1VEi+m+NOI2U9oJvTO3lvf080ZrLo35NG/6YXCidInS7fVuSXK17idGS+7Vs
	 04TB7XzmgiTyHFmYqp8wgP+rVtovCQ2hL+wBLG1f86LgBOTubnO3o0yMrsJ6BwMbkhP6d
	 zO5njzgW2NwXgEIWqa9EJ3pMcfxSUle5UkLM/Dz5myMESz2skExhlY+V+7KJ/uYVE/j1q
	 ZmOxx2KXRyRWt39QIgy2OzBFHPt6kP8gJHIdqyx7RUDU+ud22L/FJAC75So7zMUAeHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YR8aOhCIctILgz80Uaw4BFXmdL+mCDJJloJPg7bEr2A=;
	b=QE5614PaL51+3hmJ7sYQW/0uTkL2txXJlIfQ6ixkmCKLRf5MVbTQrNzrief9vD2oxMLU
	 2jem+E671AQTARPhuw8CZlbOsf16NSq2Uddtl3rBikAry3IzY65vjHAs7/89WSHy4Bo9j
	 Q/Pwe0ZZgZ4nHxccWXqYRvwib5VBPBT6R7Xn3vnpRwp4iHhHFCxa15kF4MmajTCGx4qUh
	 Wo0WT13Qsqf1vREOkpwqp3fPOwGKUwW7mI6ac7sjqMFqw/iwatHZ7oFk8ZA5QhAKEOHu+
	 T0F49qLSadaNRfGRPbLvUkk+1M2GrdbwpgycAQes432ByIChJShj7VAdTwvs/ck4m2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLoz6h9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE05606A326;
	Thu, 19 Nov 2026 03:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLoz6h9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538801F000C4;
	Thu, 19 Nov 2026 03:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060007;
	bh=YR8aOhCIctILgz80Uaw4BFXmdL+mCDJJloJPg7bEr2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLoz6h9jjAf9zznaShlKPk3/u612JpYfs9bAme4NoEfwJvAyx9ug6LgNS1ZBjfaYe
	 LR7gMNf1HZP9ANvSgVE3hg7Ka9w8gFpekg17Ed0+vCLI9F8i6sW673arW1Urcxa+yU
	 /46WnAANJkHgJPVDJn3qAT4WUBB68kDjJyFCqNHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1045/1848] selftests:core: test coverage for dup_fd() failure handling in unshare_fd()
Date: Wed, 18 Nov 2026 15:51:23 +0100
Message-ID: <20261118150001.072062046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 611fbeb44a777e5ab54ab3127ec85f72147911d8 ]

At some point there'd been a dumb braino during the dup_fd()
calling conventions change; caught by smatch and immediately fixed.
The trouble is, there had been no test coverage for the dup_fd() failure
handling - neither in kselftests nor in LTP.  Fortunately, it can be
triggered on stock kernel - ENOMEM would require fault injection, but
EMFILE can be had with sysctl alone (fs.nr_open).

Add a test for dup_fd() failure.
Fixed up commit log and short log - Shuah Khan

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: df0b7e0ea59c ("selftests/core: fix unshare_test with large fs.nr_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/core/Makefile       |  2 +-
 tools/testing/selftests/core/unshare_test.c | 94 +++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/core/unshare_test.c

diff --git a/tools/testing/selftests/core/Makefile b/tools/testing/selftests/core/Makefile
index f6f2d6f473c6a..8cc2b79dfa4c8 100644
--- a/tools/testing/selftests/core/Makefile
+++ b/tools/testing/selftests/core/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -g -I../../../../usr/include/
 
-TEST_GEN_PROGS := close_range_test
+TEST_GEN_PROGS := close_range_test unshare_test
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/core/unshare_test.c b/tools/testing/selftests/core/unshare_test.c
new file mode 100644
index 0000000000000..7fec9dfb1b0e3
--- /dev/null
+++ b/tools/testing/selftests/core/unshare_test.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/kernel.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <sys/resource.h>
+#include <linux/close_range.h>
+
+#include "../kselftest_harness.h"
+#include "../clone3/clone3_selftests.h"
+
+TEST(unshare_EMFILE)
+{
+	pid_t pid;
+	int status;
+	struct __clone_args args = {
+		.flags = CLONE_FILES,
+		.exit_signal = SIGCHLD,
+	};
+	int fd;
+	ssize_t n, n2;
+	static char buf[512], buf2[512];
+	struct rlimit rlimit;
+	int nr_open;
+
+	fd = open("/proc/sys/fs/nr_open", O_RDWR);
+	ASSERT_GE(fd, 0);
+
+	n = read(fd, buf, sizeof(buf));
+	ASSERT_GT(n, 0);
+	ASSERT_EQ(buf[n - 1], '\n');
+
+	ASSERT_EQ(sscanf(buf, "%d", &nr_open), 1);
+
+	ASSERT_EQ(0, getrlimit(RLIMIT_NOFILE, &rlimit));
+
+	/* bump fs.nr_open */
+	n2 = sprintf(buf2, "%d\n", nr_open + 1024);
+	lseek(fd, 0, SEEK_SET);
+	write(fd, buf2, n2);
+
+	/* bump ulimit -n */
+	rlimit.rlim_cur = nr_open + 1024;
+	rlimit.rlim_max = nr_open + 1024;
+	EXPECT_EQ(0, setrlimit(RLIMIT_NOFILE, &rlimit)) {
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		exit(EXIT_FAILURE);
+	}
+
+	/* get a descriptor past the old fs.nr_open */
+	EXPECT_GE(dup2(2, nr_open + 64), 0) {
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		exit(EXIT_FAILURE);
+	}
+
+	/* get descriptor table shared */
+	pid = sys_clone3(&args, sizeof(args));
+	EXPECT_GE(pid, 0) {
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		exit(EXIT_FAILURE);
+	}
+
+	if (pid == 0) {
+		int err;
+
+		/* restore fs.nr_open */
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		/* ... and now unshare(CLONE_FILES) must fail with EMFILE */
+		err = unshare(CLONE_FILES);
+		EXPECT_EQ(err, -1)
+			exit(EXIT_FAILURE);
+		EXPECT_EQ(errno, EMFILE)
+			exit(EXIT_FAILURE);
+		exit(EXIT_SUCCESS);
+	}
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0



