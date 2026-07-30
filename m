Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE6235DA67;
	Thu, 30 Jul 2026 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426437; cv=none; b=Gc1A0MxXuHIJLYCiniRCd7rFzJVB/+kvuoDHefB8nxOJZ5O24qv9dxi4/cSAn93KqSrS33+3U9KNJRZQsVPl7U6PzQfvLVSMl7F8pqKKP5fHCOuv2rUOl+0ctZSPown7mTeWunGVwCmwP9jz5E7rXPQD7+Rk1awGZ2hy37FuvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426437; c=relaxed/simple;
	bh=p3IoLMlP8M0hKrOKkaN7iQMvY0CRJOvnu6EV2g5c72A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKqC7usvBZjufIxDuC6WdoF+FlW3oWBm4ASMotVWizl/b6B9gVQZOypdRnZEeIyNNuQesdxU9lVZM6BmcB5hr5EqClaJmHAjrIvIbIgLQELgUkfrDirwl2P/ZJRxfjUk/X8AVLW6PZWZa2xw59Z7Nu4FBSXgRFGiBmpTvb7/3Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yY7F4tU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yY7F4tU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0551F000E9;
	Thu, 30 Jul 2026 15:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426436;
	bh=MSDied+lEHd+uQfGmMpimYFmLkpRmAdmjN3ZbMInCm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yY7F4tU9mZ0IQ7M43XR52D/gkV9Unh2QuvreCotDpz5TAFyYnIG3QBEKauV+0N9B6
	 Ges6nvRDkfwbltMVvH/CmC0MLihuQ7UAXy3XdI3OMT0ISos7giQBcOkOMN3vQ6GHdd
	 TlLSVRVWQhbYyb9fej+VtWK3hy58cVepMg8tFmDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Jann Horn <jannh@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 417/602] proc: Fix broken error paths for namespace links
Date: Thu, 30 Jul 2026 16:13:29 +0200
Message-ID: <20260730141444.727729962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


