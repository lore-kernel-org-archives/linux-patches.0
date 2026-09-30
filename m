Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD7E4BFE95;
	Wed, 30 Sep 2026 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788275; cv=none; b=ss6Dkb6+ZaagL0oPR4rYgtcUzx4x7kFM36/nX307qv4NVj8uU84MmdSBBH2Icc24j5IUBI+SUbcC3pdZ601VLdaqWDxAVSYo3VIBQ31s8RGuhgYHA/mrdhTI3Hw5U+bULKCy6iyA8nAmq8sU5cgL7KZ+5BVPWDhvKTIzUVdZ3ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788275; c=relaxed/simple;
	bh=UiA9ZYygaqkCyXDWyZeIm18xQYeFwxifVsFoNEXFgNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fewfIZ7t94tfkWq7Oz93vQ5RFIc8ujUi7J8fc6DxkKJon85NpzdVN7jsyxQfvB9L2Xg8AyNi181nfUXmi87I0EfMz7xzCDwNAkq4uxNmHpY0gA3TD5t2pTIe5xbaqM+mFI5CVFJ/S8XtGjeaKcWXsi+VDxS1OHWm4Qipqu1mCag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4dLNUbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4dLNUbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E831F000FF;
	Wed, 30 Sep 2026 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788274;
	bh=ocV5oMALrg3l4lRmK5aXfUHZnqOQhNK3DTUTTxm4t+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4dLNUbscmoVPNknCkY4q1vilbSCpv62G+vQY8wPQLi1Ytdpu7Zkik82X7S7tdFi6
	 zea8gj/oIjODXvDgokla+09oR65aRcGZ0YNgdQdDbQzjhBx8wapPT7rmvOOFjWUKDI
	 zrgeaMIFtLPjj9bt6+kHMb7AfnSwSdVklao6aNw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <me@black-desk.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/877] pidfd: hold exec_update_lock around namespace ioctl
Date: Wed, 30 Sep 2026 17:15:33 +0200
Message-ID: <20260930152415.222998223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Chen Linxuan <me@black-desk.cn>

[ Upstream commit 9688a46802939da28f00cb40e8129615d5d4af39 ]

The PIDFD_GET_*_NAMESPACE ioctls in pidfd_ioctl() perform a filesystem
credentials ptrace access check before handing out a namespace file
descriptor.  The accompanying comment states that the code "mirrors nsfs
behavior", but, unlike the corresponding procfs paths, it does so without
holding the target task's exec_update_lock.

proc_ns_get_link() and proc_ns_readlink() both take exec_update_lock for
reading around the ptrace check and the namespace lookup, so that the
credentials used for the access decision match those of the task when its
namespace is read.  Without it, a caller can pass the check against the
target's old credentials and then read the namespace after the target has
execve()'d a setuid binary and committed new credentials -- accessing
namespace information it should have been denied.

Hold exec_update_lock for reading around the ptrace check and the
namespace lookup so that pidfd truly mirrors nsfs behavior, as the comment
already claims.  open_namespace() itself runs outside the lock: once a
namespace reference is obtained it carries its own refcount and is opened
with the caller's own credentials, so a concurrent execve() on the target
can no longer affect the outcome.

Fixes: 5b08bd408534 ("pidfs: allow retrieval of namespace file descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Linxuan <me@black-desk.cn>
Link: https://patch.msgid.link/20260731-pidfd-exec-update-lock-v1-1-b388f2f3a8b0@black-desk.cn
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 5a8d8eb8df23b..b2dc613a64f6f 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -122,6 +122,7 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct pid *pid = pidfd_pid(file);
 	struct ns_common *ns_common = NULL;
 	struct pid_namespace *pid_ns;
+	int error;
 
 	if (arg)
 		return -EINVAL;
@@ -130,20 +131,33 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (!task)
 		return -ESRCH;
 
+	/*
+	 * We're trying to open a file descriptor to the namespace so perform a
+	 * filesystem cred ptrace check. Hold @task's exec_update_lock for the
+	 * duration of the ptrace check and the namespace lookup so that the
+	 * credentials used for the access decision match those of @task at the
+	 * time its namespace is read, preventing a concurrent execve() from
+	 * swapping the task's credentials in between the check and the use. We
+	 * mirror nsfs behavior.
+	 */
+	error = down_read_killable(&task->signal->exec_update_lock);
+	if (error)
+		return error;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
+		error = -EACCES;
+		goto out_unlock;
+	}
+
 	scoped_guard(task_lock, task) {
 		nsp = task->nsproxy;
 		if (nsp)
 			get_nsproxy(nsp);
 	}
-	if (!nsp)
-		return -ESRCH; /* just pretend it didn't exist */
-
-	/*
-	 * We're trying to open a file descriptor to the namespace so perform a
-	 * filesystem cred ptrace check. Also, we mirror nsfs behavior.
-	 */
-	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		return -EACCES;
+	if (!nsp) {
+		error = -ESRCH; /* just pretend it didn't exist */
+		goto out_unlock;
+	}
 
 	switch (cmd) {
 	/* Namespaces that hang of nsproxy. */
@@ -211,11 +225,16 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		}
 		break;
 	default:
-		return -ENOIOCTLCMD;
+		error = -ENOIOCTLCMD;
 	}
 
-	if (!ns_common)
-		return -EOPNOTSUPP;
+	if (!error && !ns_common)
+		error = -EOPNOTSUPP;
+
+out_unlock:
+	up_read(&task->signal->exec_update_lock);
+	if (error)
+		return error;
 
 	/* open_namespace() unconditionally consumes the reference */
 	return open_namespace(ns_common);
-- 
2.53.0



