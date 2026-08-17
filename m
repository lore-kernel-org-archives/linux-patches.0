Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C00D442361;
	Mon, 17 Aug 2026 14:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975871; cv=none; b=BF2WLKDmfW0bCjIs2LZDbJOnin4GccX8xYv6LvCcfjfGf9FI6mYmkXN0lOf9BsH0eA0l3m6ibnrkfhBhLyNOl0y5xPDHYG1vJRlNwWlv8fGpkmcrwZfgysnoBbpBnsqvzD6Y0BUSUNS4FGZf6lOop05gxvBIbNI9woN4cxBsEhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975871; c=relaxed/simple;
	bh=VFog0HwwxpiqbsqxCFbVPqixRH4xSkGxcOXWXA30XEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kftR/U0BNWXS2Z5laycC6V0UBAHf8RDoSJXqc9W4EFG7v0jT11KWVME6TkuFYENXNiZMI6h2NaIvJR01IRg333GSq0gy90gvWfhCt/p98mTSYbxNNeaGtD9XQNaCTC0pjFdVg3+uHPfPRvQgI4kKFwDNeno/Wg6IjBJAvdI0Ijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0ukAF/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0ukAF/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05761F000E9;
	Mon, 17 Aug 2026 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975870;
	bh=h4G6Hg5gv7jeTdqG7Gy25q3x58l8kDpJSiIXNPzDtTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0ukAF/lpB3ZzQzfEd0jVs+sB1bYFcIjq2tmU5+700qb3sjWybiclycwiy7mJjnuN
	 /MES4G4PGhDZMXd5mEMxzdGBL4Au8+ghMzmwJ15NR3X2KTGLOyqVx/0opkI6GXRITX
	 2vt0SC8d9A/L/rw1lmVHzm4ggm7hzZIoonFl81Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Jann Horn <jannh@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 177/389] proc: Fix broken error paths for namespace links
Date: Mon, 17 Aug 2026 15:30:16 +0200
Message-ID: <20260817132546.086986837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

commit 425224c2d700391729be7fe6929a88ef4e2d7a4e upstream.

Don't return the return value of down_read_killable() (0) when a ptrace
access check fails, return -EACCES as intended.

Reported-by: Magnus Lindholm <linmag7@gmail.com>
Closes: https://lore.kernel.org/r/20260706170735.2941493-1-linmag7@gmail.com
Fixes: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260706-procfs-ns-eacces-fix-v1-1-a69ab14c02e6@google.com
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/namespaces.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -46,7 +46,7 @@ static const char *proc_ns_get_link(stru
 	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns_ops;
 	struct task_struct *task;
 	struct path ns_path;
-	int error = -EACCES;
+	int error;
 
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
@@ -59,6 +59,7 @@ static const char *proc_ns_get_link(stru
 	if (error)
 		goto out_put_task;
 
+	error = -EACCES;
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
 		goto out;
 
@@ -90,6 +91,7 @@ static int proc_ns_readlink(struct dentr
 	if (res)
 		goto out_put_task;
 
+	res = -EACCES;
 	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
 		res = ns_get_name(name, sizeof(name), task, ns_ops);
 		if (res >= 0)


