Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD0A11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1382C433C7;
	Mon, 11 Sep 2023 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443017;
	bh=Ln4XpiijyuqaMfYJOnIZxahHtDXWeLc+Z6oRZCBqvnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs80rOhWzYYpPuhyn6ZrPxsX1Y4rWVmI949ClatVXj8PeBE15UfoGAE5Z0BWrjjsH
	 9xkiYDnCHw0ji2iKCMXykpF+uSiupjQjKSR0p/4H0RE1h8IOVO1jiyAfGlPs7V290R
	 GjY4np4oTgumtIUesTTypk8tryW5i2G/8wr0WPf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jeff Xu <jeffxu@google.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Daniel Verkamp <dverkamp@chromium.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 228/737] selftests: memfd: error out test process when child test fails
Date: Mon, 11 Sep 2023 15:41:27 +0200
Message-ID: <20230911134656.946690063@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <cyphar@cyphar.com>

[ Upstream commit 99f34659e78b9b781a3248e0b080b4dfca4957e2 ]

Patch series "memfd: cleanups for vm.memfd_noexec", v2.

The most critical issue with vm.memfd_noexec=2 (the fact that passing
MFD_EXEC would bypass it entirely[1]) has been fixed in Andrew's
tree[2], but there are still some outstanding issues that need to be
addressed:

 * vm.memfd_noexec=2 shouldn't reject old-style memfd_create(2) syscalls
   because it will make it far to difficult to ever migrate. Instead it
   should imply MFD_EXEC.

 * The dmesg warnings are pr_warn_once(), which on most systems means
   that they will be used up by systemd or some other boot process and
   userspace developers will never see it.

   - For the !(flags & (MFD_EXEC | MFD_NOEXEC_SEAL)) case, outputting a
     rate-limited message to the kernel log is necessary to tell
     userspace that they should add the new flags.

     Arguably the most ideal way to deal with the spam concern[3,4]
     while still prompting userspace to switch to the new flags would be
     to only log the warning once per task or something similar.
     However, adding something to task_struct for tracking this would be
     needless bloat for a single pr_warn_ratelimited().

     So just switch to pr_info_ratelimited() to avoid spamming the log
     with something that isn't a real warning. There's lots of
     info-level stuff in dmesg, it seems really unlikely that this
     should be an actual problem. Most programs are already switching to
     the new flags anyway.

   - For the vm.memfd_noexec=2 case, we need to log a warning for every
     failure because otherwise userspace will have no idea why their
     previously working program started returning -EACCES (previously
     -EINVAL) from memfd_create(2). pr_warn_once() is simply wrong here.

 * The racheting mechanism for vm.memfd_noexec makes it incredibly
   unappealing for most users to enable the sysctl because enabling it
   on &init_pid_ns means you need a system reboot to unset it. Given the
   actual security threat being protected against, CAP_SYS_ADMIN users
   being restricted in this way makes little sense.

   The argument for this ratcheting by the original author was that it
   allows you to have a hierarchical setting that cannot be unset by
   child pidnses, but this is not accurate -- changing the parent
   pidns's vm.memfd_noexec setting to be more restrictive didn't affect
   children.

   Instead, switch the vm.memfd_noexec sysctl to be properly
   hierarchical and allow CAP_SYS_ADMIN users (in the pidns's owning
   userns) to lower the setting as long as it is not lower than the
   parent's effective setting. This change also makes it so that
   changing a parent pidns's vm.memfd_noexec will affect all
   descendants, providing a properly hierarchical setting. The
   performance impact of this is incredibly minimal since the maximum
   depth of pidns is 32 and it is only checked during memfd_create(2)
   and unshare(CLONE_NEWPID).

 * The memfd selftests would not exit with a non-zero error code when
   certain tests that ran in a forked process (specifically the ones
   related to MFD_EXEC and MFD_NOEXEC_SEAL) failed.

[1]: https://lore.kernel.org/all/ZJwcsU0vI-nzgOB_@codewreck.org/
[2]: https://lore.kernel.org/all/20230705063315.3680666-1-jeffxu@google.com/
[3]: https://lore.kernel.org/Y5yS8wCnuYGLHMj4@x1n/
[4]: https://lore.kernel.org/f185bb42-b29c-977e-312e-3349eea15383@linuxfoundation.org/

This patch (of 5):

Before this change, a test runner using this self test would see a return
code of 0 when the tests using a child process (namely the MFD_NOEXEC_SEAL
and MFD_EXEC tests) failed, masking test failures.

Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-0-7ff9e3e10ba6@cyphar.com
Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-1-7ff9e3e10ba6@cyphar.com
Fixes: 11f75a01448f ("selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Cc: "Christian Brauner (Microsoft)" <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index dba0e8ba002f8..7fc5d7c3bd65b 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -1202,7 +1202,24 @@ static pid_t spawn_newpid_thread(unsigned int flags, int (*fn)(void *))
 
 static void join_newpid_thread(pid_t pid)
 {
-	waitpid(pid, NULL, 0);
+	int wstatus;
+
+	if (waitpid(pid, &wstatus, 0) < 0) {
+		printf("newpid thread: waitpid() failed: %m\n");
+		abort();
+	}
+
+	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) != 0) {
+		printf("newpid thread: exited with non-zero error code %d\n",
+		       WEXITSTATUS(wstatus));
+		abort();
+	}
+
+	if (WIFSIGNALED(wstatus)) {
+		printf("newpid thread: killed by signal %d\n",
+		       WTERMSIG(wstatus));
+		abort();
+	}
 }
 
 /*
-- 
2.40.1



