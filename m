Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7736FDE1;
	Mon, 29 Jan 2024 17:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548479; cv=none; b=IBN2xiDxGOxgERGCzl/7ldPEXi/ki8QVvSjuuubSi9ljYaa3u7fw8st//2I6KWgiN8bep9HldQXNk8MA1c+GS/Nc4bQpQXBM5wOXjq1r6aGYkWTycec5/BXeUmjXaB/w9dGSgNDjOPNaP6ZtZI7Y9IuUXM+4nuMeIUqws/DRUAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548479; c=relaxed/simple;
	bh=tjUCuCsiWu1I7vyblxyTufQtdbNiGGy9eqSuTdCi4Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4thWZGOceR/FF/oe3/WRXg/lR8fCuISkVM/VBOcIxH+ePQRKTpP1xrEMZmyP1CNL8mXo5L9Hsm6UNWh3vMnrskAYKJCblZqcJv4GtnrPcSMmSc7lXHvf9zLZLID6N9IzQqUrA9AJOxiS7ZOdH7V8ACs9kFVdYidnp0x1ioELWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUrfT8OD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUrfT8OD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755CAC433C7;
	Mon, 29 Jan 2024 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548479;
	bh=tjUCuCsiWu1I7vyblxyTufQtdbNiGGy9eqSuTdCi4Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUrfT8ODLx3WZ7WOiE11F3NNIQvVo0zuLRNDN+mHnycciTzHrdBuRFBkU+g0M5aee
	 qwog17wtVQEQs41BHUkllaF8LK/gsVJrvVMYzV7RmXAxiBZG6qs3NxjVCnHjAtXkCA
	 fqkrJNdUdbsisP+U/hVzEM9ApVbUz8vkiscjdni0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alfred Piccioni <alpic@google.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 099/331] lsm: new security_file_ioctl_compat() hook
Date: Mon, 29 Jan 2024 09:02:43 -0800
Message-ID: <20240129170017.827742889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alfred Piccioni <alpic@google.com>

commit f1bb47a31dff6d4b34fb14e99850860ee74bb003 upstream.

Some ioctl commands do not require ioctl permission, but are routed to
other permissions such as FILE_GETATTR or FILE_SETATTR. This routing is
done by comparing the ioctl cmd to a set of 64-bit flags (FS_IOC_*).

However, if a 32-bit process is running on a 64-bit kernel, it emits
32-bit flags (FS_IOC32_*) for certain ioctl operations. These flags are
being checked erroneously, which leads to these ioctl operations being
routed to the ioctl permission, rather than the correct file
permissions.

This was also noted in a RED-PEN finding from a while back -
"/* RED-PEN how should LSM module know it's handling 32bit? */".

This patch introduces a new hook, security_file_ioctl_compat(), that is
called from the compat ioctl syscall. All current LSMs have been changed
to support this hook.

Reviewing the three places where we are currently using
security_file_ioctl(), it appears that only SELinux needs a dedicated
compat change; TOMOYO and SMACK appear to be functional without any
change.

Cc: stable@vger.kernel.org
Fixes: 0b24dcb7f2f7 ("Revert "selinux: simplify ioctl checking"")
Signed-off-by: Alfred Piccioni <alpic@google.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: subject tweak, line length fixes, and alignment corrections]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ioctl.c                    |    3 +--
 include/linux/lsm_hook_defs.h |    2 ++
 include/linux/security.h      |    9 +++++++++
 security/security.c           |   18 ++++++++++++++++++
 security/selinux/hooks.c      |   28 ++++++++++++++++++++++++++++
 security/smack/smack_lsm.c    |    1 +
 security/tomoyo/tomoyo.c      |    1 +
 7 files changed, 60 insertions(+), 2 deletions(-)

--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -920,8 +920,7 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned i
 	if (!f.file)
 		return -EBADF;
 
-	/* RED-PEN how should LSM module know it's handling 32bit? */
-	error = security_file_ioctl(f.file, cmd, arg);
+	error = security_file_ioctl_compat(f.file, cmd, arg);
 	if (error)
 		goto out;
 
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -171,6 +171,8 @@ LSM_HOOK(int, 0, file_alloc_security, st
 LSM_HOOK(void, LSM_RET_VOID, file_free_security, struct file *file)
 LSM_HOOK(int, 0, file_ioctl, struct file *file, unsigned int cmd,
 	 unsigned long arg)
+LSM_HOOK(int, 0, file_ioctl_compat, struct file *file, unsigned int cmd,
+	 unsigned long arg)
 LSM_HOOK(int, 0, mmap_addr, unsigned long addr)
 LSM_HOOK(int, 0, mmap_file, struct file *file, unsigned long reqprot,
 	 unsigned long prot, unsigned long flags)
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -389,6 +389,8 @@ int security_file_permission(struct file
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int security_file_ioctl_compat(struct file *file, unsigned int cmd,
+			       unsigned long arg);
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags);
 int security_mmap_addr(unsigned long addr);
@@ -986,6 +988,13 @@ static inline int security_file_ioctl(st
 {
 	return 0;
 }
+
+static inline int security_file_ioctl_compat(struct file *file,
+					     unsigned int cmd,
+					     unsigned long arg)
+{
+	return 0;
+}
 
 static inline int security_mmap_file(struct file *file, unsigned long prot,
 				     unsigned long flags)
--- a/security/security.c
+++ b/security/security.c
@@ -2648,6 +2648,24 @@ int security_file_ioctl(struct file *fil
 }
 EXPORT_SYMBOL_GPL(security_file_ioctl);
 
+/**
+ * security_file_ioctl_compat() - Check if an ioctl is allowed in compat mode
+ * @file: associated file
+ * @cmd: ioctl cmd
+ * @arg: ioctl arguments
+ *
+ * Compat version of security_file_ioctl() that correctly handles 32-bit
+ * processes running on 64-bit kernels.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_file_ioctl_compat(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	return call_int_hook(file_ioctl_compat, 0, file, cmd, arg);
+}
+EXPORT_SYMBOL_GPL(security_file_ioctl_compat);
+
 static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
 {
 	/*
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3725,6 +3725,33 @@ static int selinux_file_ioctl(struct fil
 	return error;
 }
 
+static int selinux_file_ioctl_compat(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	/*
+	 * If we are in a 64-bit kernel running 32-bit userspace, we need to
+	 * make sure we don't compare 32-bit flags to 64-bit flags.
+	 */
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	case FS_IOC32_GETVERSION:
+		cmd = FS_IOC_GETVERSION;
+		break;
+	case FS_IOC32_SETVERSION:
+		cmd = FS_IOC_SETVERSION;
+		break;
+	default:
+		break;
+	}
+
+	return selinux_file_ioctl(file, cmd, arg);
+}
+
 static int default_noexec __ro_after_init;
 
 static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
@@ -7037,6 +7064,7 @@ static struct security_hook_list selinux
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
+	LSM_HOOK_INIT(file_ioctl_compat, selinux_file_ioctl_compat),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
 	LSM_HOOK_INIT(file_mprotect, selinux_file_mprotect),
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4973,6 +4973,7 @@ static struct security_hook_list smack_h
 
 	LSM_HOOK_INIT(file_alloc_security, smack_file_alloc_security),
 	LSM_HOOK_INIT(file_ioctl, smack_file_ioctl),
+	LSM_HOOK_INIT(file_ioctl_compat, smack_file_ioctl),
 	LSM_HOOK_INIT(file_lock, smack_file_lock),
 	LSM_HOOK_INIT(file_fcntl, smack_file_fcntl),
 	LSM_HOOK_INIT(mmap_file, smack_mmap_file),
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -568,6 +568,7 @@ static struct security_hook_list tomoyo_
 	LSM_HOOK_INIT(path_rename, tomoyo_path_rename),
 	LSM_HOOK_INIT(inode_getattr, tomoyo_inode_getattr),
 	LSM_HOOK_INIT(file_ioctl, tomoyo_file_ioctl),
+	LSM_HOOK_INIT(file_ioctl_compat, tomoyo_file_ioctl),
 	LSM_HOOK_INIT(path_chmod, tomoyo_path_chmod),
 	LSM_HOOK_INIT(path_chown, tomoyo_path_chown),
 	LSM_HOOK_INIT(path_chroot, tomoyo_path_chroot),


