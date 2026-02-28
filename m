Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95D32ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301926; cv=none; b=Vv6zhFJXVgisElsQwBl6/KiLekOpo32MD5E+kIf1GQ1MDlpKg0I5XY23MAKNvjYxBdsfVZ1b6Dn8VI2xrqI/Tf9MOmPkLz90OGoGyfHMFskrtlhpwHIqKsysEEz6qdyUFiopQHpK/Gv4Y80M0uaTFuUnfgJO73Xv0VafKRTuumw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301926; c=relaxed/simple;
	bh=CLTApjumE7St0HDWd0Ep8O93YCdlDH/n820wmLsLZmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYW/xA6eI+OckAqPxNKwBHlnMxJJgGZsxAUo0FSPUmqEBfdIEGUCmUnRAWEyF5lhxfxEyjeEkn6dycjpJyguNhqy3jAjjzoKfT+SzQdHuwnQJFA0EoT42WQ4CmvCRR8UB4DFOR5+xYqNGFVpvGD7p+PaN1gqPCke7ubkAmuDQOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5iY6gaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5iY6gaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD71C19424;
	Sat, 28 Feb 2026 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301926;
	bh=CLTApjumE7St0HDWd0Ep8O93YCdlDH/n820wmLsLZmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5iY6gaOPOCBLZS/rWHCzLgJDwK+ZQR8rm7xEChrbo5yr6A1LLRI2du5AMOBXgw4l
	 mGPHVu/Ul4L5qYjxDxzO6GyFxdtyOnA3dhpTJYEV7DTjTlhNi85SP+QS6gT0v9PXQT
	 p44xsxKGFx7Rf6xxbP24dVyRDNpLAuo9swu7o5jlve4+NdeAp0QXn4iE7HMv6DKV6d
	 aJWzbXy+8bdxFdgM7qzMUvqh4wOsNYrwO72ABLprzVdB/8RmQmuhpXrVYq4YojjnSX
	 s/GNs3IBCs5mzWVjv/zvFeyqzoRnHI0ihHsk1mjsZXufSDoi4t3wRcA/O9KzQH7zJ8
	 mzzNOfMMBhMJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aristeu Rozanski <aris@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Shuah Khan <shuah@kernel.org>,
	liuye <liuye@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/385] selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT
Date: Sat, 28 Feb 2026 12:59:43 -0500
Message-ID: <20260228180011.1568201-361-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aristeu Rozanski <aris@redhat.com>

[ Upstream commit b24335521de92fd2ee22460072b75367ca8860b0 ]

selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

In order to synchronize new processes to test inheritance of memfd_noexec
sysctl, memfd_test sets up the sysctl with a value before creating the new
process.  The new process then sends itself a SIGSTOP in order to wait for
the parent to flip the sysctl value and send a SIGCONT signal.

This would work as intended if it wasn't the fact that the new process is
being created with CLONE_NEWPID, which creates a new PID namespace and the
new process has PID 1 in this namespace.  There're restrictions on sending
signals to PID 1 and, although it's relaxed for other than root PID
namespace, it's biting us here.  In this specific case the SIGSTOP sent by
the new process is ignored (no error to kill() is returned) and it never
stops its execution.  This is usually not noticiable as the parent usually
manages to set the new sysctl value before the child has a chance to run
and the test succeeds.  But if you run the test in a loop, it eventually
reproduces:

	while [ 1 ]; do ./memfd_test >log 2>&1 || break; done; cat log

So this patch replaces the SIGSTOP/SIGCONT synchronization with IPC
semaphore.

Link: https://lkml.kernel.org/r/a7776389-b3d6-4b18-b438-0b0e3ed1fd3b@work
Fixes: 6469b66e3f5a ("selftests: improve vm.memfd_noexec sysctl tests")
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: liuye <liuye@kylinos.cn>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 113 +++++++++++++++++++--
 1 file changed, 105 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 0a0b555160280..b518699a71038 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -18,6 +18,9 @@
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/ipc.h>
+#include <sys/sem.h>
 #include <unistd.h>
 #include <ctype.h>
 
@@ -39,6 +42,20 @@
 		    F_SEAL_EXEC)
 
 #define MFD_NOEXEC_SEAL	0x0008U
+union semun {
+	int val;
+	struct semid_ds *buf;
+	unsigned short int *array;
+	struct seminfo *__buf;
+};
+
+/*
+ * we use semaphores on nested wait tasks due the use of CLONE_NEWPID: the
+ * child will be PID 1 and can't send SIGSTOP to themselves due special
+ * treatment of the init task, so the SIGSTOP/SIGCONT synchronization
+ * approach can't be used here.
+ */
+#define SEM_KEY 0xdeadbeef
 
 /*
  * Default is not to test hugetlbfs
@@ -1291,8 +1308,22 @@ static int sysctl_nested(void *arg)
 
 static int sysctl_nested_wait(void *arg)
 {
-	/* Wait for a SIGCONT. */
-	kill(getpid(), SIGSTOP);
+	int sem = semget(SEM_KEY, 1, 0600);
+	struct sembuf sembuf;
+
+	if (sem < 0) {
+		perror("semget:");
+		abort();
+	}
+	sembuf.sem_num = 0;
+	sembuf.sem_flg = 0;
+	sembuf.sem_op = 0;
+
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		abort();
+	}
+
 	return sysctl_nested(arg);
 }
 
@@ -1313,7 +1344,9 @@ static void test_sysctl_sysctl2_failset(void)
 
 static int sysctl_nested_child(void *arg)
 {
-	int pid;
+	int pid, sem;
+	union semun semun;
+	struct sembuf sembuf;
 
 	printf("%s nested sysctl 0\n", memfd_str);
 	sysctl_assert_write("0");
@@ -1347,23 +1380,53 @@ static int sysctl_nested_child(void *arg)
 			   test_sysctl_sysctl2_failset);
 	join_thread(pid);
 
+	sem = semget(SEM_KEY, 1, IPC_CREAT | 0600);
+	if (sem < 0) {
+		perror("semget:");
+		return 1;
+	}
+	semun.val = 1;
+	sembuf.sem_op = -1;
+	sembuf.sem_flg = 0;
+	sembuf.sem_num = 0;
+
 	/* Verify that the rules are actually inherited after fork. */
 	printf("%s nested sysctl 0 -> 1 after fork\n", memfd_str);
 	sysctl_assert_write("0");
 
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl1_failset);
 	sysctl_assert_write("1");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 0 -> 2 after fork\n", memfd_str);
 	sysctl_assert_write("0");
 
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2_failset);
 	sysctl_assert_write("2");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	/*
@@ -1373,28 +1436,62 @@ static int sysctl_nested_child(void *arg)
 	 */
 	printf("%s nested sysctl 2 -> 1 after fork\n", memfd_str);
 	sysctl_assert_write("2");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2);
 	sysctl_assert_write("1");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 2 -> 0 after fork\n", memfd_str);
 	sysctl_assert_write("2");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2);
 	sysctl_assert_write("0");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 1 -> 0 after fork\n", memfd_str);
 	sysctl_assert_write("1");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl1);
 	sysctl_assert_write("0");
-	kill(pid, SIGCONT);
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
+	semctl(sem, 0, IPC_RMID);
+
 	return 0;
 }
 
-- 
2.51.0

