Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388A2218EBA;
	Thu, 20 Aug 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247124; cv=none; b=Mpq7h2gIhI0F9EqtcBS+PWfQhMlYSDETXcQwhqyehlwRpGajdeF45DO6GNTH08JtgN/Bpg5HLfuqk3Da4lkDy9AaE+gsyuaKm3bw+v+vXJsT32Y8iRfY7WSJplAdtF7pJ5kHWcggcYhzQK/UQHlYjsrGHSzTov2VC4uiJmg5BvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247124; c=relaxed/simple;
	bh=ZITVD1/kKWbYEJrK/X8Pou0+WQTXdEOw3qH2jkRQdzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sp2+OPAsHiaAd8lQWRhTsk4eEGzeW+SguVwjMOuzcDa4d8zDanebbSTju8kdoGAeUSqQa+ckO79mO1v8woC9U+YP8xX7xyBWsPq2FSMTW+7GufAVPUNLWc2uD6KYKYK7xmAHRhhfTTNIXdIDzx7lxByPyzeP6rU4vu+XLMLxLQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LROuF+1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LROuF+1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939961F000E9;
	Thu, 20 Aug 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247123;
	bh=NsHrTxGxbu9cxNqx8xONdbNTMj4WOwOA+fIR1cKPbDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LROuF+1rQvuEV0JibpGkjj1A3Gu+omxAbF6iSKX4wCPgxCnFtmUdeTJa8Xg/E3Yj7
	 zW4tESobwvkG6RlAW3PVuk5lQ+cdP/jWkSkXgrGxAQurO5OU+SCvTrzFqTvYchkEMa
	 H6BWIUl03X7ZtL/LU96AS7rUtZAfacPsI/VVXJBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/220] fs: dont block write during exec on pre-content watched files
Date: Thu, 20 Aug 2026 16:55:48 +0200
Message-ID: <20260820145228.224822104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 0357ef03c94ef835bd44a0658b8edb672a9dbf51 ]

Commit 2a010c412853 ("fs: don't block i_writecount during exec") removed
the legacy behavior of getting ETXTBSY on attempt to open and executable
file for write while it is being executed.

This commit was reverted because an application that depends on this
legacy behavior was broken by the change.

We need to allow HSM writing into executable files while executed to
fill their content on-the-fly.

To that end, disable the ETXTBSY legacy behavior for files that are
watched by pre-content events.

This change is not expected to cause regressions with existing systems
which do not have any pre-content event listeners.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241128142532.465176-1-amir73il@gmail.com
Stable-dep-of: db1856ea9196 ("binfmt_misc: restore write access when removing an entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c       |    4 ++--
 fs/binfmt_elf_fdpic.c |    4 ++--
 fs/exec.c             |    8 ++++----
 include/linux/fs.h    |   22 ++++++++++++++++++++++
 kernel/fork.c         |   12 ++++++------
 5 files changed, 36 insertions(+), 14 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1257,7 +1257,7 @@ out_free_interp:
 		}
 		reloc_func_desc = interp_load_addr;
 
-		allow_write_access(interpreter);
+		exe_file_allow_write_access(interpreter);
 		fput(interpreter);
 
 		kfree(interp_elf_ex);
@@ -1371,7 +1371,7 @@ out_free_dentry:
 	kfree(interp_elf_ex);
 	kfree(interp_elf_phdata);
 out_free_file:
-	allow_write_access(interpreter);
+	exe_file_allow_write_access(interpreter);
 	if (interpreter)
 		fput(interpreter);
 out_free_ph:
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -398,7 +398,7 @@ static int load_elf_fdpic_binary(struct
 			goto error;
 		}
 
-		allow_write_access(interpreter);
+		exe_file_allow_write_access(interpreter);
 		fput(interpreter);
 		interpreter = NULL;
 	}
@@ -471,7 +471,7 @@ static int load_elf_fdpic_binary(struct
 
 error:
 	if (interpreter) {
-		allow_write_access(interpreter);
+		exe_file_allow_write_access(interpreter);
 		fput(interpreter);
 	}
 	kfree(interpreter_name);
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -912,7 +912,7 @@ static struct file *do_open_execat(int f
 	    path_noexec(&file->f_path))
 		return ERR_PTR(-EACCES);
 
-	err = deny_write_access(file);
+	err = exe_file_deny_write_access(file);
 	if (err)
 		return ERR_PTR(err);
 
@@ -927,7 +927,7 @@ static struct file *do_open_execat(int f
  * Returns ERR_PTR on failure or allocated struct file on success.
  *
  * As this is a wrapper for the internal do_open_execat(), callers
- * must call allow_write_access() before fput() on release. Also see
+ * must call exe_file_allow_write_access() before fput() on release. Also see
  * do_close_execat().
  */
 struct file *open_exec(const char *name)
@@ -1501,7 +1501,7 @@ static void do_close_execat(struct file
 {
 	if (!file)
 		return;
-	allow_write_access(file);
+	exe_file_allow_write_access(file);
 	fput(file);
 }
 
@@ -1835,7 +1835,7 @@ static int exec_binprm(struct linux_binp
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
 
-		allow_write_access(exec);
+		exe_file_allow_write_access(exec);
 		if (unlikely(bprm->have_execfd)) {
 			if (bprm->executable) {
 				fput(exec);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3085,6 +3085,28 @@ static inline void allow_write_access(st
 	if (file)
 		atomic_inc(&file_inode(file)->i_writecount);
 }
+
+/*
+ * Do not prevent write to executable file when watched by pre-content events.
+ *
+ * Note that FMODE_FSNOTIFY_HSM mode is set depending on pre-content watches at
+ * the time of file open and remains constant for entire lifetime of the file,
+ * so if pre-content watches are added post execution or removed before the end
+ * of the execution, it will not cause i_writecount reference leak.
+ */
+static inline int exe_file_deny_write_access(struct file *exe_file)
+{
+	if (unlikely(FMODE_FSNOTIFY_HSM(exe_file->f_mode)))
+		return 0;
+	return deny_write_access(exe_file);
+}
+static inline void exe_file_allow_write_access(struct file *exe_file)
+{
+	if (unlikely(!exe_file || FMODE_FSNOTIFY_HSM(exe_file->f_mode)))
+		return;
+	allow_write_access(exe_file);
+}
+
 static inline bool inode_is_open_for_write(const struct inode *inode)
 {
 	return atomic_read(&inode->i_writecount) > 0;
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -627,8 +627,8 @@ static void dup_mm_exe_file(struct mm_st
 	 * We depend on the oldmm having properly denied write access to the
 	 * exe_file already.
 	 */
-	if (exe_file && deny_write_access(exe_file))
-		pr_warn_once("deny_write_access() failed in %s\n", __func__);
+	if (exe_file && exe_file_deny_write_access(exe_file))
+		pr_warn_once("exe_file_deny_write_access() failed in %s\n", __func__);
 }
 
 #ifdef CONFIG_MMU
@@ -1439,13 +1439,13 @@ int set_mm_exe_file(struct mm_struct *mm
 		 * We expect the caller (i.e., sys_execve) to already denied
 		 * write access, so this is unlikely to fail.
 		 */
-		if (unlikely(deny_write_access(new_exe_file)))
+		if (unlikely(exe_file_deny_write_access(new_exe_file)))
 			return -EACCES;
 		get_file(new_exe_file);
 	}
 	rcu_assign_pointer(mm->exe_file, new_exe_file);
 	if (old_exe_file) {
-		allow_write_access(old_exe_file);
+		exe_file_allow_write_access(old_exe_file);
 		fput(old_exe_file);
 	}
 	return 0;
@@ -1486,7 +1486,7 @@ int replace_mm_exe_file(struct mm_struct
 			return ret;
 	}
 
-	ret = deny_write_access(new_exe_file);
+	ret = exe_file_deny_write_access(new_exe_file);
 	if (ret)
 		return -EACCES;
 	get_file(new_exe_file);
@@ -1498,7 +1498,7 @@ int replace_mm_exe_file(struct mm_struct
 	mmap_write_unlock(mm);
 
 	if (old_exe_file) {
-		allow_write_access(old_exe_file);
+		exe_file_allow_write_access(old_exe_file);
 		fput(old_exe_file);
 	}
 	return 0;


