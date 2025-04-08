Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A6268FD5;
	Tue,  8 Apr 2025 11:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112251; cv=none; b=UaXGJWQWtntMtUBmU9MGlvNiQD0/LrDGhc7Ek1/0AzlYoFthF8O2cp2n6Kd+z2uRI0FY7/qeunv6NmE7eaK3nlUhNRNYIiseGBTzdAKsq1yxhsxlPKnyobg4ciINLEGPuaXc8DU3lAHeBSXi/O4syLkJfBib7/4Wm+1Pq23JCbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112251; c=relaxed/simple;
	bh=/eqPrk0l1/q6z+QHMfleydlp+sTRFl6TohciS+cEWqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmtqS98Eo9a7NmWVFzBjXfjKo8Hos5PD91yLM/Cas/K5TyDMHVe+SKo0q5NvEwwtekzR/zjXqqVq8yMetNkdEySPOAZt96OZPeZ4cQPAROrekeAaoEgn6nAEa5XnjULq4WKbMMr6f8hVccT11oSg0JKb0wiSX8F4omfhZo8puD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yML4odwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yML4odwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90141C4CEE7;
	Tue,  8 Apr 2025 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112250;
	bh=/eqPrk0l1/q6z+QHMfleydlp+sTRFl6TohciS+cEWqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yML4odwU6IrLl8OywgERHJGViaF5sE9AyMUh7DFDndKGMtdAN8d0UwISRQnHn9KqW
	 dysMX/ElraCW4QdF7670kbkvMY7Wd0k8XqbDRyuvkS9ILYOD5+ef5RRGHdZj22nJqY
	 WR0vr35PUq/OV+e8thUTtfJcOIWke8d5lSJZr2WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c486d0b62032c82a968@syzkaller.appspotmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.14 721/731] exec: fix the racy usage of fs_struct->in_exec
Date: Tue,  8 Apr 2025 12:50:18 +0200
Message-ID: <20250408104931.045028901@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit af7bb0d2ca459f15cb5ca604dab5d9af103643f0 upstream.

check_unsafe_exec() sets fs->in_exec under cred_guard_mutex, then execve()
paths clear fs->in_exec lockless. This is fine if exec succeeds, but if it
fails we have the following race:

	T1 sets fs->in_exec = 1, fails, drops cred_guard_mutex

	T2 sets fs->in_exec = 1

	T1 clears fs->in_exec

	T2 continues with fs->in_exec == 0

Change fs/exec.c to clear fs->in_exec with cred_guard_mutex held.

Reported-by: syzbot+1c486d0b62032c82a968@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67dc67f0.050a0220.25ae54.001f.GAE@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20250324160003.GA8878@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1229,13 +1229,12 @@ int begin_new_exec(struct linux_binprm *
 	 */
 	bprm->point_of_no_return = true;
 
-	/*
-	 * Make this the only thread in the thread group.
-	 */
+	/* Make this the only thread in the thread group */
 	retval = de_thread(me);
 	if (retval)
 		goto out;
-
+	/* see the comment in check_unsafe_exec() */
+	current->fs->in_exec = 0;
 	/*
 	 * Cancel any io_uring activity across execve
 	 */
@@ -1497,6 +1496,8 @@ static void free_bprm(struct linux_binpr
 	}
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		/* in case exec fails before de_thread() succeeds */
+		current->fs->in_exec = 0;
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1618,6 +1619,10 @@ static void check_unsafe_exec(struct lin
 	 * suid exec because the differently privileged task
 	 * will be able to manipulate the current directory, etc.
 	 * It would be nice to force an unshare instead...
+	 *
+	 * Otherwise we set fs->in_exec = 1 to deny clone(CLONE_FS)
+	 * from another sub-thread until de_thread() succeeds, this
+	 * state is protected by cred_guard_mutex we hold.
 	 */
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
@@ -1862,7 +1867,6 @@ static int bprm_execve(struct linux_binp
 
 	sched_mm_cid_after_execve(current);
 	/* execve succeeded */
-	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	rseq_execve(current);
 	user_events_execve(current);
@@ -1881,7 +1885,6 @@ out:
 		force_fatal_sig(SIGSEGV);
 
 	sched_mm_cid_after_execve(current);
-	current->fs->in_exec = 0;
 	current->in_execve = 0;
 
 	return retval;


