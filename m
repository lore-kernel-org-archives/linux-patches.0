Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF973438A1;
	Wed, 30 Sep 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791668; cv=none; b=ZO4nxKwYGGaY8roep0HTyz7rjYDnUHWmMlyF32MIajMRERBu8oFBIVetyjFTJzKd/9a1O+4MoGk88SlRHS316iRbS/7Wc4Ukr/BB0cqa4k1XMAxVBS7rrQFao5m8+lFordvRbMihlABbGtiWS6RMKgW11iWaJVv9G3I13H9qeoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791668; c=relaxed/simple;
	bh=sINnrK/ykBGQK5O57KWBz1KOcpOhu+N9VirrUFI6yyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1dkBKc5qEdbcBfjiVD4T+qe8cUBv0PtFjBiOZWWQhWGk4NVzLo9t8ZwOlGL0aBdtY3DFS+l3OFxacER6aOiHzruKAskc0lJ6gryF0m/6vaxRLZTqb3h5SUE6c9YvWUsA4euWS1NcheblWsZWy8vyA0jmDQdg02czJumpkJ+ifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8zgs27F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8zgs27F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA2F1F000FF;
	Wed, 30 Sep 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791667;
	bh=Xzl+7nwzG0ZWdRSaq9Hezr7Puh5z0xNrRdjJTace77I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8zgs27FQtvHtIIVxnRgIv5UJKt3Gro6kLcOuOp8o/oWQ9S6eyW2Upam/8LnH62WW
	 4JH1qblCSgFyYm7LvmlK0MRU5pg2pTI9CBraExzckLcXr42alOANPfj41RtpiLCoin
	 rlOguM1QIpXpipUsML64f3ZpAYEyuSa2bj8PRv0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@locrian.net>,
	Jann Horn <jannh@google.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 384/752] exec: do_close_on_exec() before taking exec_update_lock
Date: Wed, 30 Sep 2026 17:24:14 +0200
Message-ID: <20260930152406.585504866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit e780259b54e618ceb4763fbc21314acf3565e813 upstream.

do_close_on_exec() currently happens while holding the exec_update_lock,
which is used in a lot of places that access process state to
synchronize access checks.
I recently added another such use of exec_update_lock, causing a
regression.

do_close_on_exec() can block waiting for a reply from a filesystem.
That means a hung filesystem can block codepaths that use
exec_update_lock; and it also means that a FUSE filesystem which
attempts to inspect the calling process can deadlock.

To avoid such problems, move do_close_on_exec() before the
exec_update_lock is taken, but after the FD table has been copied if
necessary.

I have looked through all the calls between the old and new position of
the do_close_on_exec() call; there seems to be no file descriptor table
access in between.

Reported-by: Benjamin Peterson <benjamin@locrian.net>
Closes: https://lore.kernel.org/r/f5e8166a-88be-46c5-8939-1e5227ffe4c2@app.fastmail.com
Fixes: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260907-cloexec-before-exec-update-lock-v1-1-8018c201a7df@google.com
Tested-by: Benjamin Peterson <benjamin@locrian.net>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1273,6 +1273,20 @@ int begin_new_exec(struct linux_binprm *
 		goto out;
 
 	/*
+	 * We have to apply CLOEXEC before we change whether the process is
+	 * dumpable (in setup_new_exec) to avoid a race with a process in userspace
+	 * trying to access the should-be-closed file descriptors of a process
+	 * undergoing exec(2).
+	 *
+	 * This can block on filesystem ->flush() handlers, including waiting
+	 * for FUSE daemons, so do it before exec_mmap takes the
+	 * exec_update_lock.
+	 * This must happen after the point of no return, and after unsharing
+	 * the FD table.
+	 */
+	do_close_on_exec(me->files);
+
+	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visibile until then. This also enables the update
 	 * to be lockless.
@@ -1324,14 +1338,6 @@ int begin_new_exec(struct linux_binprm *
 
 	clear_syscall_work_syscall_user_dispatch(me);
 
-	/*
-	 * We have to apply CLOEXEC before we change whether the process is
-	 * dumpable (in setup_new_exec) to avoid a race with a process in userspace
-	 * trying to access the should-be-closed file descriptors of a process
-	 * undergoing exec(2).
-	 */
-	do_close_on_exec(me->files);
-
 	if (bprm->secureexec) {
 		/* Make sure parent cannot signal privileged process. */
 		me->pdeath_signal = 0;


