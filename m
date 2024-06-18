Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80D13A868;
	Tue, 18 Jun 2024 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714902; cv=none; b=BkTvtZLY3bzXmDS4Ou//aV4ZscdWmY8azBzmtXwjFnp1JW5GYp1VbrEhHMxIebfOpwtyCnZLvlTUrZbsqVSE/dMs3H+axyTxjbcJYIV4n/OfgrnwD549HcPqsfOCVJ5NF6WK9JsiJymJNkDUc+NW2j1fCjPpp2Ulpbe83ox2Bh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714902; c=relaxed/simple;
	bh=1fulfRyFIPjZybPQdiKhZIB28bcFqe9lw78hCEaJKkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z19+XgmFO7G3TIeGLF4MCIgjPa3TS5+EktaX7NtxlL9buVFTGZZpZVuRQvzQlCR6ecYHK31sKoXjq4tRvNgCj1ldIBamtsBkvwNy+ybgBgm4xbl8JvBodhp/L2fsoZ+avTtejJ6akKJtFdpEqNoJ/Uhgup3+QcAfnDH/8dTrrVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhnSNoOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhnSNoOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1039C3277B;
	Tue, 18 Jun 2024 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714902;
	bh=1fulfRyFIPjZybPQdiKhZIB28bcFqe9lw78hCEaJKkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhnSNoOiF1Aew1bpLkhUYKiD+5hrXVll4idXS9mj7pCc3m+bntqifO2S98ZTsy4Vk
	 ETpSekdZd5XBbrmWbntsbpcifQLGWeduNFHTjk/a+G78PAYphHKlwCamgnSS2f4zbh
	 e1LBuuDxUaoMBp84OrEbSrFvP156acRA44VfQtxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/770] file: Rename __close_fd to close_fd and remove the files parameter
Date: Tue, 18 Jun 2024 14:29:40 +0200
Message-ID: <20240618123412.177984482@linuxfoundation.org>
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

[ Upstream commit 8760c909f54a82aaa6e76da19afe798a0c77c3c3 ]

The function __close_fd was added to support binder[1].  Now that
binder has been fixed to no longer need __close_fd[2] all calls
to __close_fd pass current->files.

Therefore transform the files parameter into a local variable
initialized to current->files, and rename __close_fd to close_fd to
reflect this change, and keep it in sync with the similar changes to
__alloc_fd, and __fd_install.

This removes the need for callers to care about the extra care that
needs to be take if anything except current->files is passed, by
limiting the callers to only operation on current->files.

[1] 483ce1d4b8c3 ("take descriptor-related part of close() to file.c")
[2] 44d8047f1d87 ("binder: use standard functions to allocate fds")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-17-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-21-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c                | 10 ++++------
 fs/open.c                |  2 +-
 include/linux/fdtable.h  |  3 +--
 include/linux/syscalls.h |  6 +++---
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 48d0306e42ccc..fdb84a64724b7 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -659,11 +659,9 @@ static struct file *pick_file(struct files_struct *files, unsigned fd)
 	return file;
 }
 
-/*
- * The same warnings as for __alloc_fd()/__fd_install() apply here...
- */
-int __close_fd(struct files_struct *files, unsigned fd)
+int close_fd(unsigned fd)
 {
+	struct files_struct *files = current->files;
 	struct file *file;
 
 	file = pick_file(files, fd);
@@ -672,7 +670,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 
 	return filp_close(file, files);
 }
-EXPORT_SYMBOL(__close_fd); /* for ksys_close() */
+EXPORT_SYMBOL(close_fd); /* for ksys_close() */
 
 /**
  * __close_range() - Close all file descriptors in a given range.
@@ -1087,7 +1085,7 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 	struct files_struct *files = current->files;
 
 	if (!file)
-		return __close_fd(files, fd);
+		return close_fd(fd);
 
 	if (fd >= rlimit(RLIMIT_NOFILE))
 		return -EBADF;
diff --git a/fs/open.c b/fs/open.c
index 83f62cf1432c8..48933cbb75391 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1310,7 +1310,7 @@ EXPORT_SYMBOL(filp_close);
  */
 SYSCALL_DEFINE1(close, unsigned int, fd)
 {
-	int retval = __close_fd(current->files, fd);
+	int retval = close_fd(fd);
 
 	/* can't restart close syscall because file table entry was cleared */
 	if (unlikely(retval == -ERESTARTSYS ||
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index d26b884fcc5cc..4ed3589f9294e 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -124,8 +124,7 @@ int iterate_fd(struct files_struct *, unsigned,
 		int (*)(const void *, struct file *, unsigned),
 		const void *);
 
-extern int __close_fd(struct files_struct *files,
-		      unsigned int fd);
+extern int close_fd(unsigned int fd);
 extern int __close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
 extern int close_fd_get_file(unsigned int fd, struct file **res);
 extern int unshare_fd(unsigned long unshare_flags, unsigned int max_fds,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 17a24e1180dad..0bc3dd86f9e50 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1320,16 +1320,16 @@ static inline long ksys_ftruncate(unsigned int fd, loff_t length)
 	return do_sys_ftruncate(fd, length, 1);
 }
 
-extern int __close_fd(struct files_struct *files, unsigned int fd);
+extern int close_fd(unsigned int fd);
 
 /*
  * In contrast to sys_close(), this stub does not check whether the syscall
  * should or should not be restarted, but returns the raw error codes from
- * __close_fd().
+ * close_fd().
  */
 static inline int ksys_close(unsigned int fd)
 {
-	return __close_fd(current->files, fd);
+	return close_fd(fd);
 }
 
 extern long do_sys_truncate(const char __user *pathname, loff_t length);
-- 
2.43.0



