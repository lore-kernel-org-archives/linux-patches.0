Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74CE145B31;
	Tue, 18 Jun 2024 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714867; cv=none; b=MjnwmIr+YdONkkHNRI05YT+8DWMc0mk7+csfE6wC7/2bi8baI9Mb0Wk29ZFyonCpKH0Lnkrd7CSMcgRAPWi1hj85RIN1kUi8Yhm1QtbDTa97b9tOclcBd5k0K/pX0r5OoPSMZ0jOI+TdECQj2LIUSNSvjueNUlL3Own0yG9Lelw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714867; c=relaxed/simple;
	bh=8CcTWP1D/Q3N/thETE400p/cotlNxrkXRZiXup3bsgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9VeJADB+weU3vJlnbrw27nUShvW0pmUCKPBCQD3q7HIICqgUkSK49eyi43cdsodmcwfMh4Pe7jDe9geHguoUPsAV3uY/GxJqV7SZGO03SPTdgx+w2FH6FcI33q0SX6dm1v4lu0fKkNUo34FFHuo8HQakOtwYdLe/KLnSr6nTaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaWz7IVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaWz7IVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F702C3277B;
	Tue, 18 Jun 2024 12:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714866;
	bh=8CcTWP1D/Q3N/thETE400p/cotlNxrkXRZiXup3bsgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaWz7IVnfgwfStxEszR1FCWtTOx+AiRat6VWZ6kZfAb/YxjHA1rHCiZMYasMb1c+V
	 j/hHxWCrN/lytzNi8c9PPc/lSWDxKrRm1X9lSCkAGqvwrWmqVhFxhtOVkVraRyzClV
	 xZzEQy7HQbTdkVWjyL3LtAtbLAjztWys1hfZVNCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/770] file: Replace fcheck_files with files_lookup_fd_rcu
Date: Tue, 18 Jun 2024 14:29:29 +0200
Message-ID: <20240618123411.748329366@linuxfoundation.org>
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

[ Upstream commit f36c2943274199cb8aef32ac96531ffb7c4b43d0 ]

This change renames fcheck_files to files_lookup_fd_rcu.  All of the
remaining callers take the rcu_read_lock before calling this function
so the _rcu suffix is appropriate.  This change also tightens up the
debug check to verify that all callers hold the rcu_read_lock.

All callers that used to call files_check with the files->file_lock
held have now been changed to call files_lookup_fd_locked.

This change of name has helped remind me of which locks and which
guarantees are in place helping me to catch bugs later in the
patchset.

The need for better names became apparent in the last round of
discussion of this set of changes[1].

[1] https://lkml.kernel.org/r/CAHk-=wj8BQbgJFLa+J0e=iT-1qpmCRTbPAJ8gd6MJQ=kbRPqyQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20201120231441.29911-9-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/files.rst | 6 +++---
 fs/file.c                           | 4 ++--
 fs/proc/fd.c                        | 4 ++--
 include/linux/fdtable.h             | 7 +++----
 kernel/bpf/task_iter.c              | 2 +-
 kernel/kcmp.c                       | 2 +-
 6 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/files.rst b/Documentation/filesystems/files.rst
index cbf8e57376bf6..ea75acdb632c0 100644
--- a/Documentation/filesystems/files.rst
+++ b/Documentation/filesystems/files.rst
@@ -62,7 +62,7 @@ the fdtable structure -
    be held.
 
 4. To look up the file structure given an fd, a reader
-   must use either fcheck() or fcheck_files() APIs. These
+   must use either fcheck() or files_lookup_fd_rcu() APIs. These
    take care of barrier requirements due to lock-free lookup.
 
    An example::
@@ -84,7 +84,7 @@ the fdtable structure -
    on ->f_count::
 
 	rcu_read_lock();
-	file = fcheck_files(files, fd);
+	file = files_lookup_fd_rcu(files, fd);
 	if (file) {
 		if (atomic_long_inc_not_zero(&file->f_count))
 			*fput_needed = 1;
@@ -104,7 +104,7 @@ the fdtable structure -
    lock-free, they must be installed using rcu_assign_pointer()
    API. If they are looked up lock-free, rcu_dereference()
    must be used. However it is advisable to use files_fdtable()
-   and fcheck()/fcheck_files() which take care of these issues.
+   and fcheck()/files_lookup_fd_rcu() which take care of these issues.
 
 7. While updating, the fdtable pointer must be looked up while
    holding files->file_lock. If ->file_lock is dropped, then
diff --git a/fs/file.c b/fs/file.c
index 6a6b03ce4ad69..6149f75a18a66 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -856,7 +856,7 @@ static struct file *__fget_files(struct files_struct *files, unsigned int fd,
 
 	rcu_read_lock();
 loop:
-	file = fcheck_files(files, fd);
+	file = files_lookup_fd_rcu(files, fd);
 	if (file) {
 		/* File object ref couldn't be taken.
 		 * dup2() atomicity guarantee is the reason
@@ -1187,7 +1187,7 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 		int retval = oldfd;
 
 		rcu_read_lock();
-		if (!fcheck_files(files, oldfd))
+		if (!files_lookup_fd_rcu(files, oldfd))
 			retval = -EBADF;
 		rcu_read_unlock();
 		return retval;
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 2cca9bca3b3a3..3dec44d7c5c5c 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -90,7 +90,7 @@ static bool tid_fd_mode(struct task_struct *task, unsigned fd, fmode_t *mode)
 		return false;
 
 	rcu_read_lock();
-	file = fcheck_files(files, fd);
+	file = files_lookup_fd_rcu(files, fd);
 	if (file)
 		*mode = file->f_mode;
 	rcu_read_unlock();
@@ -243,7 +243,7 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 		char name[10 + 1];
 		unsigned int len;
 
-		f = fcheck_files(files, fd);
+		f = files_lookup_fd_rcu(files, fd);
 		if (!f)
 			continue;
 		data.mode = f->f_mode;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 87be704268d26..a45fa2ef723f5 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -98,10 +98,9 @@ static inline struct file *files_lookup_fd_locked(struct files_struct *files, un
 	return files_lookup_fd_raw(files, fd);
 }
 
-static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
+static inline struct file *files_lookup_fd_rcu(struct files_struct *files, unsigned int fd)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
-			   !lockdep_is_held(&files->file_lock),
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
 			   "suspicious rcu_dereference_check() usage");
 	return files_lookup_fd_raw(files, fd);
 }
@@ -109,7 +108,7 @@ static inline struct file *fcheck_files(struct files_struct *files, unsigned int
 /*
  * Check whether the specified fd has an open file.
  */
-#define fcheck(fd)	fcheck_files(current->files, fd)
+#define fcheck(fd)	files_lookup_fd_rcu(current->files, fd)
 
 struct task_struct;
 
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index f3d3a562a802a..762b4d7c37795 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -185,7 +185,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
 	for (; curr_fd < max_fds; curr_fd++) {
 		struct file *f;
 
-		f = fcheck_files(curr_files, curr_fd);
+		f = files_lookup_fd_rcu(curr_files, curr_fd);
 		if (!f)
 			continue;
 		if (!get_file_rcu(f))
diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index bd6f9edf98fd3..5b2435e030472 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -67,7 +67,7 @@ get_file_raw_ptr(struct task_struct *task, unsigned int idx)
 	rcu_read_lock();
 
 	if (task->files)
-		file = fcheck_files(task->files, idx);
+		file = files_lookup_fd_rcu(task->files, idx);
 
 	rcu_read_unlock();
 	task_unlock(task);
-- 
2.43.0



