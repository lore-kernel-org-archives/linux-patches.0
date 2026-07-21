Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB453C0A02;
	Tue, 21 Jul 2026 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670646; cv=none; b=itOKF7fCtlE8gyKkX/oXwzI7eXsJd6GcsCPwMSPnKWAK5WKT64LkOrydDvNUuD+TBLooKLmgrBxmq6wYgI14pYu9EQDxUR/8Thw2K02B8O/wYUTberXw7ofR8buTmPiXG15UW5Gk216YhmTj4Ig28xp322xortZVYtjy5i3FT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670646; c=relaxed/simple;
	bh=N4gddMDKoIp88swTeJRmK1LhgfaRXtg86Om/wWCkEAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptNI04H3fTxAZTNqmkjshaKLM8S+q7F8erWmt2HoqTa5SkKKOWjZ+9cwOfnXt/Xcq6QpdjZ16lz1Yg6G+JTK6X67rvuujGkIVi6JgdkKLvQ8nJujmjzWlVbAcfQfFeVU6PWdH/rJG/tPZ1oF4271Yg6oLZg7rBvtkm1dVLqI9o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CokY9Vth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CokY9Vth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D0A1F000E9;
	Tue, 21 Jul 2026 21:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670645;
	bh=LhxRNMvr1eB77dPAE9kp/okgAe30ers8Okb/0o1pQuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CokY9Vth7xT1w+bq41DHAwTH7HT63Ls/BtsHpnrAxav9A3lyc6vsQxxrP+BzOqS7H
	 uhiCrr7F8D0BdxVBx6Upn59kSs+TckH1d7j5YxDUSXjYAbUWawgMCuDfVFFOFNk619
	 g02gbaxDyXAXsF4AMgWpLu9yltlk4Rmo4M/spczc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kevin Parsons (Microsoft)" <parsonskev@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jann Horn <jannh@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Allen Pais <apais@linux.microsoft.com>,
	"Tyler Hicks (Microsoft)" <code@tyhicks.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1010/1067] proc: Move fdinfo PTRACE_MODE_READ check into the inode .permission operation
Date: Tue, 21 Jul 2026 17:26:51 +0200
Message-ID: <20260721152447.164740758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Tyler Hicks (Microsoft)" <code@tyhicks.com>

[ Upstream commit 0a960ba49869ebe8ff859d000351504dd6b93b68 ]

The following commits loosened the permissions of /proc/<PID>/fdinfo/
directory, as well as the files within it, from 0500 to 0555 while also
introducing a PTRACE_MODE_READ check between the current task and
<PID>'s task:

 - commit 7bc3fa0172a4 ("procfs: allow reading fdinfo with PTRACE_MODE_READ")
 - commit 1927e498aee1 ("procfs: prevent unprivileged processes accessing fdinfo dir")

Before those changes, inode based system calls like inotify_add_watch(2)
would fail when the current task didn't have sufficient read permissions:

 [...]
 lstat("/proc/1/task/1/fdinfo", {st_mode=S_IFDIR|0500, st_size=0, ...}) = 0
 inotify_add_watch(64, "/proc/1/task/1/fdinfo",
		   IN_MODIFY|IN_ATTRIB|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|
		   IN_ONLYDIR|IN_DONT_FOLLOW|IN_EXCL_UNLINK) = -1 EACCES (Permission denied)
 [...]

This matches the documented behavior in the inotify_add_watch(2) man
page:

 ERRORS
       EACCES Read access to the given file is not permitted.

After those changes, inotify_add_watch(2) started succeeding despite the
current task not having PTRACE_MODE_READ privileges on the target task:

 [...]
 lstat("/proc/1/task/1/fdinfo", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
 inotify_add_watch(64, "/proc/1/task/1/fdinfo",
		   IN_MODIFY|IN_ATTRIB|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|
		   IN_ONLYDIR|IN_DONT_FOLLOW|IN_EXCL_UNLINK) = 1757
 openat(AT_FDCWD, "/proc/1/task/1/fdinfo",
	O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 EACCES (Permission denied)
 [...]

This change in behavior broke .NET prior to v7. See the github link
below for the v7 commit that inadvertently/quietly (?) fixed .NET after
the kernel changes mentioned above.

Return to the old behavior by moving the PTRACE_MODE_READ check out of
the file .open operation and into the inode .permission operation:

 [...]
 lstat("/proc/1/task/1/fdinfo", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
 inotify_add_watch(64, "/proc/1/task/1/fdinfo",
		   IN_MODIFY|IN_ATTRIB|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|
		   IN_ONLYDIR|IN_DONT_FOLLOW|IN_EXCL_UNLINK) = -1 EACCES (Permission denied)
 [...]

Reported-by: Kevin Parsons (Microsoft) <parsonskev@gmail.com>
Link: https://github.com/dotnet/runtime/commit/89e5469ac591b82d38510fe7de98346cce74ad4f
Link: https://stackoverflow.com/questions/75379065/start-self-contained-net6-build-exe-as-service-on-raspbian-system-unauthorizeda
Fixes: 7bc3fa0172a4 ("procfs: allow reading fdinfo with PTRACE_MODE_READ")
Cc: stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Hardik Garg <hargar@linux.microsoft.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Link: https://lore.kernel.org/r/20240501005646.745089-1-code@tyhicks.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 6255da28d4bb ("proc: protect ptrace_may_access() with exec_update_lock (FD links)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/fd.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -72,7 +72,18 @@ out:
 	return 0;
 }
 
-static int proc_fdinfo_access_allowed(struct inode *inode)
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, seq_show, inode);
+}
+
+/**
+ * Shared /proc/pid/fdinfo and /proc/pid/fdinfo/fd permission helper to ensure
+ * that the current task has PTRACE_MODE_READ in addition to the normal
+ * POSIX-like checks.
+ */
+static int proc_fdinfo_permission(struct mnt_idmap *idmap, struct inode *inode,
+				  int mask)
 {
 	bool allowed = false;
 	struct task_struct *task = get_proc_task(inode);
@@ -86,18 +97,13 @@ static int proc_fdinfo_access_allowed(st
 	if (!allowed)
 		return -EACCES;
 
-	return 0;
+	return generic_permission(idmap, inode, mask);
 }
 
-static int seq_fdinfo_open(struct inode *inode, struct file *file)
-{
-	int ret = proc_fdinfo_access_allowed(inode);
-
-	if (ret)
-		return ret;
-
-	return single_open(file, seq_show, inode);
-}
+static const struct inode_operations proc_fdinfo_file_inode_operations = {
+	.permission	= proc_fdinfo_permission,
+	.setattr	= proc_setattr,
+};
 
 static const struct file_operations proc_fdinfo_file_operations = {
 	.open		= seq_fdinfo_open,
@@ -339,6 +345,8 @@ static struct dentry *proc_fdinfo_instan
 	ei = PROC_I(inode);
 	ei->fd = data->fd;
 
+	inode->i_op = &proc_fdinfo_file_inode_operations;
+
 	inode->i_fop = &proc_fdinfo_file_operations;
 	tid_fd_update_inode(task, inode, 0);
 
@@ -358,23 +366,13 @@ static int proc_readfdinfo(struct file *
 				  proc_fdinfo_instantiate);
 }
 
-static int proc_open_fdinfo(struct inode *inode, struct file *file)
-{
-	int ret = proc_fdinfo_access_allowed(inode);
-
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
+	.permission	= proc_fdinfo_permission,
 	.setattr	= proc_setattr,
 };
 
 const struct file_operations proc_fdinfo_operations = {
-	.open		= proc_open_fdinfo,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_readfdinfo,
 	.llseek		= generic_file_llseek,


