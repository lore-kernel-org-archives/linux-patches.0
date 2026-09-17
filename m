Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2E37FF6F;
	Thu, 17 Sep 2026 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671491; cv=none; b=GMKmsh2v2DIUVazQ6L1Kt89CxigdoljwdaWBd8VRvZjqwtdUYKzuUE8DdsYTnui7HSGQfW9wFRao4xEj2S64xiqI8nDKTUN9JaUXFTcCl5F4WPZVMxD9uk2Fknczdnb1UVrwypKUc4FSdST8IdAVD0eNCIK/4UsDQHSjTlbpfAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671491; c=relaxed/simple;
	bh=ei85sgO7KrVqS2E9QTPMmVXSH48mw8CnguRs41e0LGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkMoEllgFeLeelIxSOr/OLSbXHWa4dN97uobAoe9W/sniGtz+jWfH3A96+Twk/hYnOcr4xlJR6QnM1TrXlxB34uzKIy0q+GE+Sfq/5EvCcnkXHjTY1PPjiu4IOg5I3OYNnt5GtDdplGyxZMugrF+DdLPiPLQKpsxGgYnX4o4ea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scj2yPSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scj2yPSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B041F000FF;
	Thu, 17 Sep 2026 18:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671489;
	bh=jB77YI3PAYhsfXC+KTzqVfzHWrHvrjHuYueLFnzVTnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scj2yPSvM423e9mMYGMfH82/so8oLGHHbiri/VVdJybgOqMnabNC3aj9fF6bx5yh8
	 B+Dl+QTJeO++v1wdNhMGuwRA0b5nO5gS4pR4ggsfqcg5KSfFb7sSGS1z2AL1flaXfV
	 aETN9l0/8S8DSl8z0iyXHQJ6+o5lxT86+H7r2duE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <me@black-desk.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0992/1102] pidfd: hold exec_update_lock around namespace ioctl
Date: Thu, 17 Sep 2026 16:15:35 +0100
Message-ID: <20260917151605.620867869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -125,6 +125,7 @@ static long pidfd_ioctl(struct file *fil
 	struct task_struct *task __free(put_task) = NULL;
 	struct nsproxy *nsp __free(put_nsproxy) = NULL;
 	struct ns_common *ns_common = NULL;
+	int error;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -136,20 +137,33 @@ static long pidfd_ioctl(struct file *fil
 	if (arg)
 		return -EINVAL;
 
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
@@ -221,11 +235,16 @@ static long pidfd_ioctl(struct file *fil
 #endif
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


