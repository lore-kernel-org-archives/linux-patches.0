Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F296013DB8D;
	Tue, 18 Jun 2024 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714938; cv=none; b=dFboGNNpFgphAp0JH1FqICU+4qhwanYep1w6AnnkDOcR7dmPEFsy8cfWxmirkiJbDiLi8GblLLVDEkzaEvUufV/G0sLv+PAOab9fLsseAPJTxzhY4LkOx3c2dBmL/jbsAuGdTpFtRew6p4SlFkFyyvT/MHbScMafriLqEO0kvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714938; c=relaxed/simple;
	bh=I/c5rhUBBYMsqLl9CWHDIleHDr+8GaFBGjcYsnVRvaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrC8R5YnOwSMlCFhFBey8jwbuU2F6cgfzJb0BouPI1+z0SIFeDwsjJdEfXTrGuq46dXzJv8lGVYNC6chSlLybin+oquG6LYzho6Me/X2ERP5PbZmNbPnLpQxj1tgtlK4qTWnHKcVfIlT7EJl3qD30kz1e5l33Wvz9Esti0uUiu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7P6aMkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7P6aMkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F79C3277B;
	Tue, 18 Jun 2024 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714937;
	bh=I/c5rhUBBYMsqLl9CWHDIleHDr+8GaFBGjcYsnVRvaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7P6aMkOSR12YsDdpPJS8vu/lnk6KLWeJae4rdKFSqx4xTjHh8KPAPkr7FkP2nKCA
	 TvuTA5q6KlOfcx/AcmHm4i0QeiCJBlluIbMdJ9Jf4Ev8oNPx2VRHwmgWtPEW+rNjw4
	 4ZHrLZ8rOTF0cxcXFMdg4I/NhhYGjHqkIf3q88/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/770] exec: Simplify unshare_files
Date: Tue, 18 Jun 2024 14:29:21 +0200
Message-ID: <20240618123411.442554033@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 1f702603e7125a390b5cdf5ce00539781cfcc86a ]

Now that exec no longer needs to return the unshared files to their
previous value there is no reason to return displaced.

Instead when unshare_fd creates a copy of the file table, call
put_files_struct before returning from unshare_files.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-2-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-2-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c           |  5 +----
 fs/exec.c               |  5 +----
 include/linux/fdtable.h |  2 +-
 kernel/fork.c           | 12 ++++++------
 4 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 9d91e831ed0b2..7b085975ea163 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -590,7 +590,6 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 	int ispipe;
 	size_t *argv = NULL;
 	int argc = 0;
-	struct files_struct *displaced;
 	/* require nonrelative corefile path and be extra careful */
 	bool need_suid_safe = false;
 	bool core_dumped = false;
@@ -797,11 +796,9 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 	}
 
 	/* get us an unshared descriptor table; almost always a no-op */
-	retval = unshare_files(&displaced);
+	retval = unshare_files();
 	if (retval)
 		goto close_fail;
-	if (displaced)
-		put_files_struct(displaced);
 	if (!dump_interrupted()) {
 		/*
 		 * umh disabled with CONFIG_STATIC_USERMODEHELPER_PATH="" would
diff --git a/fs/exec.c b/fs/exec.c
index 42952cf90f4af..d5c8f085235bc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1245,7 +1245,6 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 int begin_new_exec(struct linux_binprm * bprm)
 {
 	struct task_struct *me = current;
-	struct files_struct *displaced;
 	int retval;
 
 	/* Once we are committed compute the creds */
@@ -1266,11 +1265,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 		goto out;
 
 	/* Ensure the files table is not shared. */
-	retval = unshare_files(&displaced);
+	retval = unshare_files();
 	if (retval)
 		goto out;
-	if (displaced)
-		put_files_struct(displaced);
 
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index f1a99d3e55707..b32ab2163dc2d 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -109,7 +109,7 @@ struct task_struct;
 struct files_struct *get_files_struct(struct task_struct *);
 void put_files_struct(struct files_struct *fs);
 void reset_files_struct(struct files_struct *);
-int unshare_files(struct files_struct **);
+int unshare_files(void);
 struct files_struct *dup_fd(struct files_struct *, unsigned, int *) __latent_entropy;
 void do_close_on_exec(struct files_struct *);
 int iterate_fd(struct files_struct *, unsigned,
diff --git a/kernel/fork.c b/kernel/fork.c
index 633b0af1d1a73..8b8a5a172b158 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3077,21 +3077,21 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
  *	the exec layer of the kernel.
  */
 
-int unshare_files(struct files_struct **displaced)
+int unshare_files(void)
 {
 	struct task_struct *task = current;
-	struct files_struct *copy = NULL;
+	struct files_struct *old, *copy = NULL;
 	int error;
 
 	error = unshare_fd(CLONE_FILES, NR_OPEN_MAX, &copy);
-	if (error || !copy) {
-		*displaced = NULL;
+	if (error || !copy)
 		return error;
-	}
-	*displaced = task->files;
+
+	old = task->files;
 	task_lock(task);
 	task->files = copy;
 	task_unlock(task);
+	put_files_struct(old);
 	return 0;
 }
 
-- 
2.43.0



