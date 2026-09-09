Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE88579820;
	Wed,  9 Sep 2026 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964498; cv=none; b=ifd8Zs0RWndlw/yZji0UQf+g+PfeJlcdJQKBLFQW2Y3N9uoHwj19v+R90nlZ/VT0O9hLvkgnKpaRnfUhVbAbpYmmhIt3rnckMtPgYKcDKatj3h1zpfXgO+Uy0TvqOzXfoRu6Op6c7dvSJVQeTbTdQAdG1sqpcBgQAPdMBYhbtVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964498; c=relaxed/simple;
	bh=1E11VpWnEbCy64MO/cmLUTPQZZ9AsWOwsbFSTHscuQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ycqc0OyJulx/199lD8eck8ScVAhB43qwskqDgX0uTQFlB8wKMpQMQHDO7yzvvHgOV3EjNlG3/LIZFsw8D7cnOJBCrf36MvcFrP58MjZKzKoEbkELPNCqO5pYfifyGy8m0DTE17mTQs3vqSf4JW9RVL6AxVd1uWnRqgZL3MMaxos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GI72aOi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GI72aOi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCF31F00A3A;
	Wed,  9 Sep 2026 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964497;
	bh=/FA+YkoQJp9MAsmyko9zaChsAkD1vVYnXrzefex2TjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GI72aOi/vMfJNCTDCkQv6OwMlGQnl1NmhDuMTBaOl+cnbbFG8/hyCSBQnl3zfJVjl
	 jHk0eI9pqMLtYilkZSSnGEwJz/nJ8qPfvS0zkUVQbpuYvSmX91mTNa9VZjm5d1rNdi
	 PQjWXdRjl0vp/G1yYHnmDq/aHnwMDkpkikiDn+pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <me@black-desk.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 444/583] pidfd: hold exec_update_lock around namespace ioctl
Date: Wed,  9 Sep 2026 15:42:09 +0200
Message-ID: <20260909134253.356624122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -456,6 +456,7 @@ static long pidfd_ioctl(struct file *fil
 	struct task_struct *task __free(put_task) = NULL;
 	struct nsproxy *nsp __free(put_nsproxy) = NULL;
 	struct ns_common *ns_common = NULL;
+	int error;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -479,20 +480,33 @@ static long pidfd_ioctl(struct file *fil
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
@@ -558,11 +572,16 @@ static long pidfd_ioctl(struct file *fil
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


