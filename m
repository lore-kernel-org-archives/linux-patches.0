Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88433AEF2D;
	Thu, 17 Sep 2026 18:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670995; cv=none; b=IWysWwa5LfdtQuYGGkuXQdN/KD1lKVbss3NdxtnE/wflKJvbRpEP1j59GlI7HPD43UM+hBhNijXRvaavhsgvAMiEbHTDoD9npA3elXGW6/bDAwohybBJSyrXPlozvJus4ZVDRIITBTuxpZ1HpiiuutQWeC9qk3pbOyDd0tEYgL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670995; c=relaxed/simple;
	bh=y60hjJJGsHk5R6mBLgd21Iq9++6KW9rJVfUV1RFvPQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqPyzopGM9VSoro8pRsKWF/QRNuoQGjL/4tF7zhm1GY/uZprD3iO0y+RIacX+uTluWnJLQCLMSLMZ7q4wUS2wxXAhUes2C8ENoKrC/XClaL2NuepZ2RtvpswmSzqEZ+X4FZplzlj6lxzPzGdvHT5xjesYma4YMQC0bOwZt8MoQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hw4ScVRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw4ScVRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7F41F000FF;
	Thu, 17 Sep 2026 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670993;
	bh=VSvLUgMW0NQVMb6YNAcMuLzke2jTVlGs2UMs67soHmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw4ScVRZwqQIrbNQn7u5CDZn9fSlozDABSjU9/Z3AdwHfwXHQ9xMFC8m4lPEe59zU
	 lcwJdXqIbeu7kfO/ryHhGNNdqoO/VoBdLxN0TPrEBSKJAPNOVZbkWhUbRLYGj1bo8j
	 RT2ZrwYLwLtcsz3lDdPE7X9lPbCsZ0MvzrYWC3lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@locrian.net>,
	Jann Horn <jannh@google.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 0834/1102] exec: do_close_on_exec() before taking exec_update_lock
Date: Thu, 17 Sep 2026 16:12:57 +0100
Message-ID: <20260917151601.451507799@linuxfoundation.org>
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
@@ -1263,6 +1263,20 @@ int begin_new_exec(struct linux_binprm *
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
 	 * not visible until then. Doing it here also ensures
 	 * we don't race against replace_mm_exe_file().
@@ -1312,14 +1326,6 @@ int begin_new_exec(struct linux_binprm *
 
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


