Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C982B9B9;
	Tue,  3 Dec 2024 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242482; cv=none; b=C1EnTi3Z4lFAhTVkB/oNmHpokd9HaJ/+TmFlrun3fN3WqAC60JgOI4Ktz83QdE6LpcICkmP+SZJrXppq7bcFKN1dfDrouXweV/y4WHuCN8KPHr9peuo9Bi/oz3V7nD4UMoefIXAtQcJX9fMBCnLJabjqnJqYpukIeYf+igkVVUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242482; c=relaxed/simple;
	bh=WBU6zvR/CaoJewd76j7QmlF5bgtVrUATKdV8HAb9QBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMjY2JvArKMmsgeJINO6q3fo+Do53AzS2sqglmnvUXHrPmHVjrMaq3X+nRrBcwtNJVxQgmYaB4p7oCp+hLDj1H8GzPsZwefMtm0E1mZW84K5zoZEUTnGclAaWOLzfvX2Ln4McCLFuIBxsJOPowewVl1JgtJUSQ732s95QyEW98o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRyvQjgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRyvQjgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E636C4CECF;
	Tue,  3 Dec 2024 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242482;
	bh=WBU6zvR/CaoJewd76j7QmlF5bgtVrUATKdV8HAb9QBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRyvQjgzUjWWgH/fhR/y+/FHOgGM70nrqZPfpO5LEPbZWhkM5SrAhbPtjrUT+Yj27
	 gFXxgtFeYjFF4E6VVQl9UsEloNz3cP/ojAmAnI/p7SzHgBhqAwS76HuuJxbP+rpJEx
	 Hkhw7INP9FgWMPN2K7aZM/XsSrIrljibSk/Kw2iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 686/826] Revert "fs: dont block i_writecount during exec"
Date: Tue,  3 Dec 2024 15:46:53 +0100
Message-ID: <20241203144810.515726347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 3b832035387ff508fdcf0fba66701afc78f79e3d upstream.

This reverts commit 2a010c41285345da60cece35575b4e0af7e7bf44.

Rui Ueyama <rui314@gmail.com> writes:

> I'm the creator and the maintainer of the mold linker
> (https://github.com/rui314/mold). Recently, we discovered that mold
> started causing process crashes in certain situations due to a change
> in the Linux kernel. Here are the details:
>
> - In general, overwriting an existing file is much faster than
> creating an empty file and writing to it on Linux, so mold attempts to
> reuse an existing executable file if it exists.
>
> - If a program is running, opening the executable file for writing
> previously failed with ETXTBSY. If that happens, mold falls back to
> creating a new file.
>
> - However, the Linux kernel recently changed the behavior so that
> writing to an executable file is now always permitted
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2a010c412853).
>
> That caused mold to write to an executable file even if there's a
> process running that file. Since changes to mmap'ed files are
> immediately visible to other processes, any processes running that
> file would almost certainly crash in a very mysterious way.
> Identifying the cause of these random crashes took us a few days.
>
> Rejecting writes to an executable file that is currently running is a
> well-known behavior, and Linux had operated that way for a very long
> time. So, I don’t believe relying on this behavior was our mistake;
> rather, I see this as a regression in the Linux kernel.

Quoting myself from commit 2a010c412853 ("fs: don't block i_writecount during exec")

> Yes, someone in userspace could potentially be relying on this. It's not
> completely out of the realm of possibility but let's find out if that's
> actually the case and not guess.

It seems we found out that someone is relying on this obscure behavior.
So revert the change.

Link: https://github.com/rui314/mold/issues/1361
Link: https://lore.kernel.org/r/4a2bc207-76be-4715-8e12-7fc45a76a125@leemhuis.info
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c       |    2 ++
 fs/binfmt_elf_fdpic.c |    5 ++++-
 fs/binfmt_misc.c      |    7 +++++--
 fs/exec.c             |   23 +++++++++++++++--------
 kernel/fork.c         |   26 +++++++++++++++++++++++---
 5 files changed, 49 insertions(+), 14 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1251,6 +1251,7 @@ out_free_interp:
 		}
 		reloc_func_desc = interp_load_addr;
 
+		allow_write_access(interpreter);
 		fput(interpreter);
 
 		kfree(interp_elf_ex);
@@ -1347,6 +1348,7 @@ out_free_dentry:
 	kfree(interp_elf_ex);
 	kfree(interp_elf_phdata);
 out_free_file:
+	allow_write_access(interpreter);
 	if (interpreter)
 		fput(interpreter);
 out_free_ph:
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -394,6 +394,7 @@ static int load_elf_fdpic_binary(struct
 			goto error;
 		}
 
+		allow_write_access(interpreter);
 		fput(interpreter);
 		interpreter = NULL;
 	}
@@ -465,8 +466,10 @@ static int load_elf_fdpic_binary(struct
 	retval = 0;
 
 error:
-	if (interpreter)
+	if (interpreter) {
+		allow_write_access(interpreter);
 		fput(interpreter);
+	}
 	kfree(interpreter_name);
 	kfree(exec_params.phdrs);
 	kfree(exec_params.loadmap);
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -247,10 +247,13 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto ret;
 
-	if (fmt->flags & MISC_FMT_OPEN_FILE)
+	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
-	else
+		if (!IS_ERR(interp_file))
+			deny_write_access(interp_file);
+	} else {
 		interp_file = open_exec(fmt->interpreter);
+	}
 	retval = PTR_ERR(interp_file);
 	if (IS_ERR(interp_file))
 		goto ret;
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -883,7 +883,8 @@ EXPORT_SYMBOL(transfer_args_to_stack);
  */
 static struct file *do_open_execat(int fd, struct filename *name, int flags)
 {
-	struct file *file;
+	int err;
+	struct file *file __free(fput) = NULL;
 	struct open_flags open_exec_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC,
@@ -908,12 +909,14 @@ static struct file *do_open_execat(int f
 	 * an invariant that all non-regular files error out before we get here.
 	 */
 	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
-	    path_noexec(&file->f_path)) {
-		fput(file);
+	    path_noexec(&file->f_path))
 		return ERR_PTR(-EACCES);
-	}
 
-	return file;
+	err = deny_write_access(file);
+	if (err)
+		return ERR_PTR(err);
+
+	return no_free_ptr(file);
 }
 
 /**
@@ -923,7 +926,8 @@ static struct file *do_open_execat(int f
  *
  * Returns ERR_PTR on failure or allocated struct file on success.
  *
- * As this is a wrapper for the internal do_open_execat(). Also see
+ * As this is a wrapper for the internal do_open_execat(), callers
+ * must call allow_write_access() before fput() on release. Also see
  * do_close_execat().
  */
 struct file *open_exec(const char *name)
@@ -1475,8 +1479,10 @@ static int prepare_bprm_creds(struct lin
 /* Matches do_open_execat() */
 static void do_close_execat(struct file *file)
 {
-	if (file)
-		fput(file);
+	if (!file)
+		return;
+	allow_write_access(file);
+	fput(file);
 }
 
 static void free_bprm(struct linux_binprm *bprm)
@@ -1801,6 +1807,7 @@ static int exec_binprm(struct linux_binp
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
 
+		allow_write_access(exec);
 		if (unlikely(bprm->have_execfd)) {
 			if (bprm->executable) {
 				fput(exec);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -622,6 +622,12 @@ static void dup_mm_exe_file(struct mm_st
 
 	exe_file = get_mm_exe_file(oldmm);
 	RCU_INIT_POINTER(mm->exe_file, exe_file);
+	/*
+	 * We depend on the oldmm having properly denied write access to the
+	 * exe_file already.
+	 */
+	if (exe_file && deny_write_access(exe_file))
+		pr_warn_once("deny_write_access() failed in %s\n", __func__);
 }
 
 #ifdef CONFIG_MMU
@@ -1414,11 +1420,20 @@ int set_mm_exe_file(struct mm_struct *mm
 	 */
 	old_exe_file = rcu_dereference_raw(mm->exe_file);
 
-	if (new_exe_file)
+	if (new_exe_file) {
+		/*
+		 * We expect the caller (i.e., sys_execve) to already denied
+		 * write access, so this is unlikely to fail.
+		 */
+		if (unlikely(deny_write_access(new_exe_file)))
+			return -EACCES;
 		get_file(new_exe_file);
+	}
 	rcu_assign_pointer(mm->exe_file, new_exe_file);
-	if (old_exe_file)
+	if (old_exe_file) {
+		allow_write_access(old_exe_file);
 		fput(old_exe_file);
+	}
 	return 0;
 }
 
@@ -1457,6 +1472,9 @@ int replace_mm_exe_file(struct mm_struct
 			return ret;
 	}
 
+	ret = deny_write_access(new_exe_file);
+	if (ret)
+		return -EACCES;
 	get_file(new_exe_file);
 
 	/* set the new file */
@@ -1465,8 +1483,10 @@ int replace_mm_exe_file(struct mm_struct
 	rcu_assign_pointer(mm->exe_file, new_exe_file);
 	mmap_write_unlock(mm);
 
-	if (old_exe_file)
+	if (old_exe_file) {
+		allow_write_access(old_exe_file);
 		fput(old_exe_file);
+	}
 	return 0;
 }
 


