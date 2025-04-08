Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC88F27F4FC;
	Tue,  8 Apr 2025 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117184; cv=none; b=OYBzCqcI9MWVU8GC5D+XCjfZ2Gf2tKS9gjMzaJzd0hp5uQ8JjI8CcUgLIH4BaVWxHjMBSM9VElmU8woy3+QGQCqxsSDljFzjMMA828AeKsUyFcOg3f53Ce8NjKQGWJdv0dnmSzLXtBotvW7TUdaabtqnaZQBTAatsWOd6Chzup8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117184; c=relaxed/simple;
	bh=+RQ37sSpq/5HKBZKmLBu3NaszJsjbKSvv/UaYfqa1bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDFd8tAK1p1eqyt9VWyg4Bftgkop1tTw6Aj6ps74/7GVZ2XXaYTNyPf13pu4858a0aFMkbj2W0s44J/LDv1O73Gl83kDepJjIw1D2I8E40R6btc/olPsIEWevzMkwmOZkHIL0gUYV+a2bQ07A9DfHBU94YRxOlrmw7L/Hm+bdEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIeK8MuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIeK8MuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D4CC4CEE5;
	Tue,  8 Apr 2025 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117184;
	bh=+RQ37sSpq/5HKBZKmLBu3NaszJsjbKSvv/UaYfqa1bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIeK8MuZpfqhPOsbBdViOnpjwteMFeP4an9xYclpxaF8Yf8Xwh16mAacsp1GGGnNs
	 uhKcI4Nio1ZsZgXBeGPoaGGl9Vj6sTq2xtk3kPiXDT0JRPZbrAaxxEaRTYdsNVpg73
	 3gtpP+u7nVfT3/Osc/cyazr418atMBUqLzW3t99A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c486d0b62032c82a968@syzkaller.appspotmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 415/423] exec: fix the racy usage of fs_struct->in_exec
Date: Tue,  8 Apr 2025 12:52:21 +0200
Message-ID: <20250408104855.588595097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1246,13 +1246,12 @@ int begin_new_exec(struct linux_binprm *
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
@@ -1514,6 +1513,8 @@ static void free_bprm(struct linux_binpr
 	}
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		/* in case exec fails before de_thread() succeeds */
+		current->fs->in_exec = 0;
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1620,6 +1621,10 @@ static void check_unsafe_exec(struct lin
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
@@ -1878,7 +1883,6 @@ static int bprm_execve(struct linux_binp
 
 	sched_mm_cid_after_execve(current);
 	/* execve succeeded */
-	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	rseq_execve(current);
 	user_events_execve(current);
@@ -1897,7 +1901,6 @@ out:
 		force_fatal_sig(SIGSEGV);
 
 	sched_mm_cid_after_execve(current);
-	current->fs->in_exec = 0;
 	current->in_execve = 0;
 
 	return retval;


