Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7654347BC6;
	Tue, 21 Jul 2026 22:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674738; cv=none; b=cR5FVQEACWeI5Zn9CUGJKZYfjOsSg2sV/UwqDtczmcITyPu30AJzaR49DCrDAGg8FoFkZwP2NO2KFMlBcFurkjftfpnspYtwNYqf6ZZDykgMl+iXCZT1D9PZqKxW9u9RYROh4VPg4EzJrfKyqhw2AX89rIWm3ydV8WeN4glJhp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674738; c=relaxed/simple;
	bh=gJ+FyRYkANfi1XNUgwYEGvMkckQtf7vSs8WzTtoWaAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogUcUtoahsKXOyjYqHMAOqW4yksDk1kNzZyO5f+VOg4nUnu3pXqECmcos10k1Q7Id67GGMktNUtgMH1UsK4t3CszJAHc9dnRv0wmHTn8PS602tsTzQY+NCkmAgmMt2pWSbWwG6Uf3aK2/Jv0Hzl7I31gsWvN0HEcV4jj2YqP3AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcaEzRXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcaEzRXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297711F000E9;
	Tue, 21 Jul 2026 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674737;
	bh=jk8psCdaTcpZ8ib3I/aw6wGTQqYlmrFfj3OJU+3BTx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcaEzRXP4d59EAB7OE2xq7VPUscnYe8MyC3GC02p9rxH9UJ+V4gvwLAUwHSWb2Qnw
	 CWbFXQOq4G2CFW1OKn7v95+2DHBwK17s8A6fFdtdi6yFJP4ViHc6nLBuaY0qXEEkv+
	 n3BLiJ8SfuP298JZuCTv71z2Q8RcZVyZ7u5f6wnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 654/699] proc: protect ptrace_may_access() with exec_update_lock (part 1)
Date: Tue, 21 Jul 2026 17:26:53 +0200
Message-ID: <20260721152410.514270909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 6650527444dadc63d84aa939d14ecba4fadb2f69 ]

Fix the easy cases where procfs currently calls ptrace_may_access() without
exec_update_lock protection, where the fix is to simply add the extra lock
or use mm_access():

 - do_task_stat(): grab exec_update_lock
 - proc_pid_wchan(): grab exec_update_lock
 - proc_map_files_lookup(): use mm_access() instead of get_task_mm()
 - proc_map_files_readdir(): use mm_access() instead of get_task_mm()
 - proc_ns_get_link(): grab exec_update_lock
 - proc_ns_readlink(): grab exec_update_lock

Fixes: f83ce3e6b02d ("proc: avoid information leaks to non-privileged processes")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260518-procfs-lockfix-part1-v1-1-5c3d20e0ac33@google.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ converted NULL return from mm_access() to ERR_PTR(-ESRCH) at call sites since 5.15's mm_access() returns NULL when the task has no mm ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c      |    6 ++++++
 fs/proc/base.c       |   41 ++++++++++++++++++++++++-----------------
 fs/proc/namespaces.c |   12 ++++++++++++
 3 files changed, 42 insertions(+), 17 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -449,6 +449,11 @@ static int do_task_stat(struct seq_file
 	unsigned long flags;
 	struct signal_struct *sig = task->signal;
 	unsigned int seq = 1;
+	int ret;
+
+	ret = down_read_killable(&task->signal->exec_update_lock);
+	if (ret)
+		return ret;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -626,6 +631,7 @@ static int do_task_stat(struct seq_file
 		seq_puts(m, " 0");
 
 	seq_putc(m, '\n');
+	up_read(&task->signal->exec_update_lock);
 	if (mm)
 		mmput(mm);
 	return 0;
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -413,18 +413,24 @@ static int proc_pid_wchan(struct seq_fil
 {
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
+	int err;
 
+	err = down_read_killable(&task->signal->exec_update_lock);
+	if (err)
+		return err;
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
 		goto print0;
 
 	wchan = get_wchan(task);
 	if (wchan && !lookup_symbol_name(wchan, symname)) {
 		seq_puts(m, symname);
+		up_read(&task->signal->exec_update_lock);
 		return 0;
 	}
 
 print0:
 	seq_putc(m, '0');
+	up_read(&task->signal->exec_update_lock);
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
@@ -2327,17 +2333,17 @@ static struct dentry *proc_map_files_loo
 	if (!task)
 		goto out;
 
-	result = ERR_PTR(-EACCES);
-	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		goto out_put_task;
-
 	result = ERR_PTR(-ENOENT);
 	if (dname_to_vma_addr(dentry, &vm_start, &vm_end))
 		goto out_put_task;
 
-	mm = get_task_mm(task);
+	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (!mm)
+		mm = ERR_PTR(-ESRCH);
+	if (IS_ERR(mm)) {
+		result = ERR_CAST(mm);
 		goto out_put_task;
+	}
 
 	result = ERR_PTR(-EINTR);
 	if (mmap_read_lock_killable(mm))
@@ -2386,23 +2392,24 @@ proc_map_files_readdir(struct file *file
 	if (!task)
 		goto out;
 
-	ret = -EACCES;
-	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		goto out_put_task;
-
 	ret = 0;
 	if (!dir_emit_dots(file, ctx))
 		goto out_put_task;
 
-	mm = get_task_mm(task);
+	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (!mm)
+		mm = ERR_PTR(-ESRCH);
+	if (IS_ERR(mm)) {
+		ret = PTR_ERR(mm);
+		/* if the task has no mm, the directory should just be empty */
+		if (ret == -ESRCH)
+			ret = 0;
 		goto out_put_task;
+	}
 
 	ret = mmap_read_lock_killable(mm);
-	if (ret) {
-		mmput(mm);
-		goto out_put_task;
-	}
+	if (ret)
+		goto out_put_mm;
 
 	nr_files = 0;
 
@@ -2426,8 +2433,7 @@ proc_map_files_readdir(struct file *file
 		if (!p) {
 			ret = -ENOMEM;
 			mmap_read_unlock(mm);
-			mmput(mm);
-			goto out_put_task;
+			goto out_put_mm;
 		}
 
 		p->start = vma->vm_start;
@@ -2435,7 +2441,6 @@ proc_map_files_readdir(struct file *file
 		p->mode = vma->vm_file->f_mode;
 	}
 	mmap_read_unlock(mm);
-	mmput(mm);
 
 	for (i = 0; i < nr_files; i++) {
 		char buf[4 * sizeof(long) + 2];	/* max: %lx-%lx\0 */
@@ -2452,6 +2457,8 @@ proc_map_files_readdir(struct file *file
 		ctx->pos++;
 	}
 
+out_put_mm:
+	mmput(mm);
 out_put_task:
 	put_task_struct(task);
 out:
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -55,6 +55,10 @@ static const char *proc_ns_get_link(stru
 	if (!task)
 		return ERR_PTR(-EACCES);
 
+	error = down_read_killable(&task->signal->exec_update_lock);
+	if (error)
+		goto out_put_task;
+
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
 		goto out;
 
@@ -64,6 +68,8 @@ static const char *proc_ns_get_link(stru
 
 	error = nd_jump_link(&ns_path);
 out:
+	up_read(&task->signal->exec_update_lock);
+out_put_task:
 	put_task_struct(task);
 	return ERR_PTR(error);
 }
@@ -80,11 +86,17 @@ static int proc_ns_readlink(struct dentr
 	if (!task)
 		return res;
 
+	res = down_read_killable(&task->signal->exec_update_lock);
+	if (res)
+		goto out_put_task;
+
 	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
 		res = ns_get_name(name, sizeof(name), task, ns_ops);
 		if (res >= 0)
 			res = readlink_copy(buffer, buflen, name);
 	}
+	up_read(&task->signal->exec_update_lock);
+out_put_task:
 	put_task_struct(task);
 	return res;
 }


