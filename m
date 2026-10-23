Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774503;
	b=GhDbmo1Jq1WM/skVdzWAq8kqfXU2zUr+igQANMWX2/tuAY81VGwdLSoNUmDjVkI307Ge
	 RhVbPDUb21i8SKcHHuz7wNQVw3V6robhsBRNu7cK420/M8aMCU7yf5/fx0VvMAddmOFzK
	 fxL380BiERSwlTh9FvfnaIOAiDGt9qo2nvfGBezKlea1CWneeQmwi7RNTDG+5gfwVj2+R
	 SzO78mqrccG9atwmqJ4oyyRQ9i3WCiqMI8CPUAfsaMVCE07JAMKdBZl+Pine5gOJOvMci
	 IglGLVRXWJfeVQVdlwzwWMURTwdWOLpiOM/YaQgevw1oLy8iB1/iFvXYgI5dF758D3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9QGDYhvCnrQLWh+F7BUjwEX+wQ7Wj+RIe3fYNxmt0mE=;
	b=JBGkiP4SmePAUZXnQenwQDs+r24oLXXQsYH/X5m8pcLv7SwYmkRGMjV1rkQs+LzTV12q
	 BMfMFGgeWo8gCV+9HQgD6SvSU3SwXHvrO9iRwMNzNS7iKFgeJZ63pumygsbY75a3XyV8y
	 kKclS//MF2acCNSMESLlI3y8M8YUC8H7uqxAP3bZzSsWC5KvbzrlEViFBccC3z44oUIEZ
	 iSqxqev1fit23YeEZuW9gfBJ1IyRTyZ5doKdLPNQ+P/MQb5oOpfb+qd0K3k2WpRhixdiB
	 4PIWrdUDZJ1ijj7P5aMDq9F8I54YyCqiRQ7p6n8iMbh4W1ZGoqerapvA/IJh3VPGG4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kX08fjtr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BA6606A31A;
	Fri, 23 Oct 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kX08fjtr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE571F01825;
	Fri, 23 Oct 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774502;
	bh=9QGDYhvCnrQLWh+F7BUjwEX+wQ7Wj+RIe3fYNxmt0mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kX08fjtrAxvdlbzzD6CanzNSu3WC9C69Iv9ApVulbUWMCUoxUNdMHT86Yfha+cCmt
	 py7+BzYzdot+8ZiDN5xoR5HgcqK5ExbrFhbQhBZOoABGhKD19dKk0g0eS4GrzZrtex
	 oInnakqG74SixBpE/Aq/eK/NwI0H4jy5T2aulxRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 063/242] fs: add real_fs to track tasks actual fs_struct
Date: Fri, 23 Oct 2026 18:38:25 +0200
Message-ID: <20261023163715.272230494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 1d4ee94a51bdb98610bf7283e6297b133f8c1025 ]

Add a real_fs field to task_struct that always mirrors the fs field.
This lays the groundwork for distinguishing between a task's permanent
fs_struct and one that is temporarily overridden via scoped_with_init_fs().

When a kthread temporarily overrides current->fs for path lookup, we
need to know the original fs_struct for operations like exit_fs() and
unshare_fs_struct() that must operate on the real, permanent fs.

For now real_fs is always equal to fs. It is maintained alongside fs in
all the relevant paths: exit_fs(), unshare_fs_struct(),
switch_fs_struct(), and copy_fs().

Link: https://patch.msgid.link/20260601-work-kthread-nullfs-v4-4-77ee053060e0@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d2bdb9b61b42 ("fs: let idle threads share init_fs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c        | 11 ++++++++---
 fs/proc/array.c       |  4 ++--
 fs/proc/base.c        |  8 ++++----
 fs/proc_namespace.c   |  4 ++--
 include/linux/sched.h |  1 +
 init/init_task.c      |  1 +
 kernel/fork.c         |  8 +++++++-
 kernel/kcmp.c         |  2 +-
 8 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index fcecf209f1a9e..c03a574ed65aa 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -61,7 +61,7 @@ void chroot_fs_refs(const struct path *old_root, const struct path *new_root)
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, p) {
 		task_lock(p);
-		fs = p->fs;
+		fs = p->real_fs;
 		if (fs) {
 			int hits = 0;
 			write_seqlock(&fs->seq);
@@ -89,12 +89,13 @@ void free_fs_struct(struct fs_struct *fs)
 
 void exit_fs(struct task_struct *tsk)
 {
-	struct fs_struct *fs = tsk->fs;
+	struct fs_struct *fs = tsk->real_fs;
 
 	if (fs) {
 		int kill;
 		task_lock(tsk);
 		read_seqlock_excl(&fs->seq);
+		tsk->real_fs = NULL;
 		tsk->fs = NULL;
 		kill = !--fs->users;
 		read_sequnlock_excl(&fs->seq);
@@ -126,7 +127,7 @@ struct fs_struct *copy_fs_struct(struct fs_struct *old)
 
 int unshare_fs_struct(void)
 {
-	struct fs_struct *fs = current->fs;
+	struct fs_struct *fs = current->real_fs;
 	struct fs_struct *new_fs = copy_fs_struct(fs);
 	int kill;
 
@@ -135,8 +136,10 @@ int unshare_fs_struct(void)
 
 	task_lock(current);
 	read_seqlock_excl(&fs->seq);
+	VFS_WARN_ON_ONCE(fs != current->fs);
 	kill = !--fs->users;
 	current->fs = new_fs;
+	current->real_fs = new_fs;
 	read_sequnlock_excl(&fs->seq);
 	task_unlock(current);
 
@@ -177,8 +180,10 @@ struct fs_struct *switch_fs_struct(struct fs_struct *new_fs)
 
 	scoped_guard(task_lock, current) {
 		fs = current->fs;
+		VFS_WARN_ON_ONCE(fs != current->real_fs);
 		read_seqlock_excl(&fs->seq);
 		current->fs = new_fs;
+		current->real_fs = new_fs;
 		if (--fs->users)
 			new_fs = NULL;
 		else
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 479ea8cb4ef43..f6f75d206762a 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -168,8 +168,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	cred = get_task_cred(p);
 
 	task_lock(p);
-	if (p->fs)
-		umask = p->fs->umask;
+	if (p->real_fs)
+		umask = p->real_fs->umask;
 	if (p->files)
 		max_fds = files_fdtable(p->files)->max_fds;
 	task_unlock(p);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 780f812590527..6a39de424f62a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -211,8 +211,8 @@ static int get_task_root(struct task_struct *task, struct path *root)
 	int result = -ENOENT;
 
 	task_lock(task);
-	if (task->fs) {
-		get_fs_root(task->fs, root);
+	if (task->real_fs) {
+		get_fs_root(task->real_fs, root);
 		result = 0;
 	}
 	task_unlock(task);
@@ -225,8 +225,8 @@ static int proc_cwd_link(struct dentry *dentry, struct path *path,
 	int result = -ENOENT;
 
 	task_lock(task);
-	if (task->fs) {
-		get_fs_pwd(task->fs, path);
+	if (task->real_fs) {
+		get_fs_pwd(task->real_fs, path);
 		result = 0;
 	}
 	task_unlock(task);
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5c555db68aa21..036356c0a55bb 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -254,13 +254,13 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	}
 	ns = nsp->mnt_ns;
 	get_mnt_ns(ns);
-	if (!task->fs) {
+	if (!task->real_fs) {
 		task_unlock(task);
 		put_task_struct(task);
 		ret = -ENOENT;
 		goto err_put_ns;
 	}
-	get_fs_root(task->fs, &root);
+	get_fs_root(task->real_fs, &root);
 	task_unlock(task);
 	put_task_struct(task);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5b36a3364ca09..4a2c3ea3c4e67 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1191,6 +1191,7 @@ struct task_struct {
 	unsigned long			last_switch_time;
 #endif
 	/* Filesystem information: */
+	struct fs_struct		*real_fs;
 	struct fs_struct		*fs;
 
 	/* Open file information: */
diff --git a/init/init_task.c b/init/init_task.c
index b67ef6040a655..ba5c2523f7e0c 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -162,6 +162,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	RCU_POINTER_INITIALIZER(cred, &init_cred),
 	.comm		= INIT_TASK_COMM,
 	.thread		= INIT_THREAD,
+	.real_fs	= &init_fs,
 	.fs		= &init_fs,
 	.files		= &init_files,
 #ifdef CONFIG_IO_URING
diff --git a/kernel/fork.c b/kernel/fork.c
index 739659e71af53..4441d415480c6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1621,6 +1621,8 @@ static int copy_exec_state(u64 clone_flags, struct task_struct *tsk)
 static int copy_fs(u64 clone_flags, struct task_struct *tsk)
 {
 	struct fs_struct *fs = current->fs;
+
+	VFS_WARN_ON_ONCE(current->fs != current->real_fs);
 	if (clone_flags & CLONE_FS) {
 		/* tsk->fs is already what we want */
 		read_seqlock_excl(&fs->seq);
@@ -1633,7 +1635,7 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk)
 		read_sequnlock_excl(&fs->seq);
 		return 0;
 	}
-	tsk->fs = copy_fs_struct(fs);
+	tsk->real_fs = tsk->fs = copy_fs_struct(fs);
 	if (!tsk->fs)
 		return -ENOMEM;
 	return 0;
@@ -3251,6 +3253,10 @@ int ksys_unshare(unsigned long unshare_flags)
 	if (unshare_flags & CLONE_NEWNS)
 		unshare_flags |= CLONE_FS;
 
+	/* No unsharing with overriden fs state */
+	VFS_WARN_ON_ONCE(unshare_flags & (CLONE_NEWNS | CLONE_FS) &&
+			 current->fs != current->real_fs);
+
 	err = check_unshare_flags(unshare_flags);
 	if (err)
 		goto bad_unshare_out;
diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index 7c1a65bd5f8d3..76476aeee067b 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -186,7 +186,7 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 		ret = kcmp_ptr(task1->files, task2->files, KCMP_FILES);
 		break;
 	case KCMP_FS:
-		ret = kcmp_ptr(task1->fs, task2->fs, KCMP_FS);
+		ret = kcmp_ptr(task1->real_fs, task2->real_fs, KCMP_FS);
 		break;
 	case KCMP_SIGHAND:
 		ret = kcmp_ptr(task1->sighand, task2->sighand, KCMP_SIGHAND);
-- 
2.53.0



