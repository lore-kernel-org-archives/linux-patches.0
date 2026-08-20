Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049C047F2CE;
	Thu, 20 Aug 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248519; cv=none; b=R/Bh5KNd9xgcKAvGnY1NhlJ0X1c4sOfjB9sVNNisekUyTQcHiJ5RlrJ1iq8C1XQDK1NIFK8aNQqiWuKq4Bhb9mzL/KuhLYOXF1Lj+y6b0ty+2YQegvKQYBq0uetpLc0L3rm67ERzsqKihs3PGN7hEOM4sX/vMxhM9CgGIuhakNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248519; c=relaxed/simple;
	bh=XvJFoajpGG4n3d9ZHm/L5/vsOaRxS8Fo8/sEwADv74o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh8MoPjmGCBX19vIH16MgKgl+YjatZ1/yGw3WaJoPHccASGhKNvkhmFRjgEncxtu/87ZjAIO0lLNIBNRj0FTk+bEMIBup2PtotrQCCFMKtYALo47eacEB2tbjw3GVs6Vo7xvz/AX1N6RGHyaJTLxXMtBHlT/f37aQJI9WIBRsi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4jqhtkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4jqhtkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7101F000E9;
	Thu, 20 Aug 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248517;
	bh=dBkxcq4eFHhe1srbXYuB318HFKT9bIUMZncXRAezibE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4jqhtkRNpb2FLrbHuFGD6jvFDy1FzbQgQPBj/N1mi0IC59+rYB0G4LzTyseGQm2S
	 WcPpgqOz7oKKLIerzsf4IRrF9m5Q0ZuGexy3vGeRScC4t4hRAcj9UWc90cgtq/gy56
	 2d8rabIFPHm2mVm3JbdonTGi0L4J6WXU/KThFG8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 255/303] fs: dont block write during exec on pre-content watched files
Date: Thu, 20 Aug 2026 16:56:31 +0200
Message-ID: <20260820145301.112426067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/exec.c             |    6 +++---
 include/linux/fs.h    |   22 ++++++++++++++++++++++
 kernel/fork.c         |   12 ++++++------
 5 files changed, 35 insertions(+), 13 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1288,7 +1288,7 @@ out_free_interp:
 		}
 		reloc_func_desc = interp_load_addr;
 
-		allow_write_access(interpreter);
+		exe_file_allow_write_access(interpreter);
 		fput(interpreter);
 
 		kfree(interp_elf_ex);
@@ -1397,7 +1397,7 @@ out_free_dentry:
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
@@ -937,7 +937,7 @@ static struct file *do_open_execat(int f
 	    path_noexec(&file->f_path))
 		goto exit;
 
-	err = deny_write_access(file);
+	err = exe_file_deny_write_access(file);
 	if (err)
 		goto exit;
 
@@ -1520,7 +1520,7 @@ static void free_bprm(struct linux_binpr
 		abort_creds(bprm->cred);
 	}
 	if (bprm->file) {
-		allow_write_access(bprm->file);
+		exe_file_allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
 	if (bprm->executable)
@@ -1812,7 +1812,7 @@ static int exec_binprm(struct linux_binp
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
 
-		allow_write_access(exec);
+		exe_file_allow_write_access(exec);
 		if (unlikely(bprm->have_execfd)) {
 			if (bprm->executable) {
 				fput(exec);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3115,6 +3115,28 @@ static inline void allow_write_access(st
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
@@ -576,8 +576,8 @@ static void dup_mm_exe_file(struct mm_st
 	 * We depend on the oldmm having properly denied write access to the
 	 * exe_file already.
 	 */
-	if (exe_file && deny_write_access(exe_file))
-		pr_warn_once("deny_write_access() failed in %s\n", __func__);
+	if (exe_file && exe_file_deny_write_access(exe_file))
+		pr_warn_once("exe_file_deny_write_access() failed in %s\n", __func__);
 }
 
 #ifdef CONFIG_MMU
@@ -1279,13 +1279,13 @@ int set_mm_exe_file(struct mm_struct *mm
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
@@ -1327,7 +1327,7 @@ int replace_mm_exe_file(struct mm_struct
 	}
 
 	/* set the new file, lockless */
-	ret = deny_write_access(new_exe_file);
+	ret = exe_file_deny_write_access(new_exe_file);
 	if (ret)
 		return -EACCES;
 	get_file(new_exe_file);
@@ -1339,7 +1339,7 @@ int replace_mm_exe_file(struct mm_struct
 		 * write access while someone might open the file writable.
 		 */
 		mmap_read_lock(mm);
-		allow_write_access(old_exe_file);
+		exe_file_allow_write_access(old_exe_file);
 		fput(old_exe_file);
 		mmap_read_unlock(mm);
 	}


