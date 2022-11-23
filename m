Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D647D1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F26C433B5;
	Wed, 23 Nov 2022 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196574;
	bh=GHgdIoT4lw5MoP246IlcpsNkvxqjnGhY9F5ONqN4YCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLDh3xy2vbmOJ3FGtGex8LBvlJMxe5mCJ9G/7bpe4BLaNUrEjDDHpm3XIBbZEuF81
	 eLqVRXYuOi/Z11k1B4cvOsoMswr8jojQM7fQZSVMT4QmwnCuYYIQKsUPZsO5FEfUPf
	 +XKDcAT0WWuyfkhlscgkJZs/EikCxourEqiJLyJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Li <philip.li@intel.com>,
	kernel test robot <lkp@intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 040/314] ksefltests: pidfd: Fix wait_states: Test terminated by timeout
Date: Wed, 23 Nov 2022 09:48:05 +0100
Message-Id: <20221123084627.338198974@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 88e1f16ba58665e9edfce437ea487da2fa759af9 ]

0Day/LKP observed that the kselftest blocks forever since one of the
pidfd_wait doesn't terminate in 1 of 30 runs. After digging into
the source, we found that it blocks at:
ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WCONTINUED, NULL), 0);

wait_states has below testing flow:
  CHILD                 PARENT
  ---------------+--------------
1 STOP itself
2                   WAIT for CHILD STOPPED
3                   SIGNAL CHILD to CONT
4 CONT
5 STOP itself
5'                  WAIT for CHILD CONT
6                   WAIT for CHILD STOPPED

The problem is that the kernel cannot ensure the order of 5 and 5', once
5 goes first, the test will fail.

we can reproduce it by:
$ while true; do make run_tests -C pidfd; done

Introduce a blocking read in child process to make sure the parent can
check its WCONTINUED.

CC: Philip Li <philip.li@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pidfd/pidfd_wait.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/pidfd/pidfd_wait.c b/tools/testing/selftests/pidfd/pidfd_wait.c
index 070c1c876df1..c3e2a3041f55 100644
--- a/tools/testing/selftests/pidfd/pidfd_wait.c
+++ b/tools/testing/selftests/pidfd/pidfd_wait.c
@@ -95,20 +95,28 @@ TEST(wait_states)
 		.flags = CLONE_PIDFD | CLONE_PARENT_SETTID,
 		.exit_signal = SIGCHLD,
 	};
+	int pfd[2];
 	pid_t pid;
 	siginfo_t info = {
 		.si_signo = 0,
 	};
 
+	ASSERT_EQ(pipe(pfd), 0);
 	pid = sys_clone3(&args);
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
+		char buf[2];
+
+		close(pfd[1]);
 		kill(getpid(), SIGSTOP);
+		ASSERT_EQ(read(pfd[0], buf, 1), 1);
+		close(pfd[0]);
 		kill(getpid(), SIGSTOP);
 		exit(EXIT_SUCCESS);
 	}
 
+	close(pfd[0]);
 	ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WSTOPPED, NULL), 0);
 	ASSERT_EQ(info.si_signo, SIGCHLD);
 	ASSERT_EQ(info.si_code, CLD_STOPPED);
@@ -117,6 +125,8 @@ TEST(wait_states)
 	ASSERT_EQ(sys_pidfd_send_signal(pidfd, SIGCONT, NULL, 0), 0);
 
 	ASSERT_EQ(sys_waitid(P_PIDFD, pidfd, &info, WCONTINUED, NULL), 0);
+	ASSERT_EQ(write(pfd[1], "C", 1), 1);
+	close(pfd[1]);
 	ASSERT_EQ(info.si_signo, SIGCHLD);
 	ASSERT_EQ(info.si_code, CLD_CONTINUED);
 	ASSERT_EQ(info.si_pid, parent_tid);
-- 
2.35.1



