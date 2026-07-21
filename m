Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C78746D565;
	Tue, 21 Jul 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658714; cv=none; b=HTKZrVpTwrY1zdiR+d7+8LbpSg/lVIGpISHukYv1rrnZDPji1I7/AEFy4WlBfTYyMCVeFb+oXDfoYsfQNFFss9lbaxERI+Wwydy/4xSrIqGP5dnGVtPcJ6T69wUhGVEJujoHxY3mmDor8uA7fOfMjY19XrtP2fncHIGMwpH8Vdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658714; c=relaxed/simple;
	bh=6FGaE2QHUxP/5oqnzT9DRhfrTgmb3GlN/IYEW5159o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yse9fZHwVWBgZ1FlfSpZNJ9urdktu3IZSNQIrmNyhJA1RGE8RPDPZNnP/KNSrBzGHK1u/9EJzxWBBGYc1GW0x6yDw8A7Spl5QRcxvv8sVZVemjGNae6Qs/+Nq39wudIbxwgaPwdUKsNQ5w4xUXNYGVia35DRMGQX5AcCKA5VlIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiZzXrHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiZzXrHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BC21F000E9;
	Tue, 21 Jul 2026 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658713;
	bh=cQVGoH+ce1cHbYtP2109u6eq6qTY+TPbel6GFDs9Mjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiZzXrHLYddTWSacmgu4deXxWW/Jfr8jRDtf4hCTE+kSrfWjFn5IFg3BE/uNDSmLG
	 5UlFIRgyAL4E8bhzTwH/1Gpj75cREUYjJBDYY3VthzpbRFZY3PRjp36wM2powjVwbF
	 7Pyplhqc8qaLCChy7LkC0RDF1gQryuCo4Hl6t3eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 1245/1611] landlock: Fix LANDLOCK_SCOPE_SIGNAL bypass on the SIGIO path
Date: Tue, 21 Jul 2026 17:22:41 +0200
Message-ID: <20260721152543.446695764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 4b80320ca7ed03d6e683f95b6066565dc97b9f92 upstream.

LANDLOCK_SCOPE_SIGNAL must prevent a sandboxed process from signaling
processes outside its Landlock domain.  It can be bypassed through the
asynchronous SIGIO delivery path.

A sandboxed process that owns any file or socket can arm it with
fcntl(fd, F_SETOWN, -pgid), fcntl(fd, F_SETSIG, SIGKILL) and O_ASYNC, so
that an I/O event makes the kernel deliver the chosen signal to the
whole process group.  As the head of its process group's task list (the
default position right after fork()) that group can also hold the
non-sandboxed process that launched it, e.g. a supervisor or a security
monitor.  The sandbox can thus kill or signal the processes
LANDLOCK_SCOPE_SIGNAL is meant to protect from it.

The scope is enforced in hook_file_send_sigiotask() against the Landlock
domain recorded at F_SETOWN time, not the live domain of the sender.
control_current_fowner() decides whether to record that domain and skips
recording it when the fowner target is in the caller's thread group,
which is safe only for a single-task target (PIDTYPE_PID, PIDTYPE_TGID).
For a process group (PIDTYPE_PGID) pid_task() returns only one member;
recording is skipped whenever that member shares the caller's thread
group, and hook_file_send_sigiotask() then lets the signal fan out to
the whole group unchecked.

Record the domain for every non single-process target so the scope is
enforced against each group member at delivery time.

That recording is necessary but not sufficient on its own: the kernel
signals a process group through its members' thread-group leaders, and
the leader of the registrant's own process can carry a different
Landlock domain than the sibling thread that armed the owner.
domain_is_scoped() would then deny that leader, even though commit
18eb75f3af40 ("landlock: Always allow signals between threads of the
same process") requires same-process delivery to be allowed.
hook_task_kill() avoids this by evaluating same_thread_group() live, per
recipient; the SIGIO path instead delegates the whole decision to a
single registration-time check, which a process-group fan-out cannot
honor.

So also record the registrant's thread group next to its domain and
exempt it at delivery: hook_file_send_sigiotask() allows the signal
whenever the recipient belongs to the registrant's own process,
restoring the same-process guarantee while keeping out-of-domain group
members blocked.  The direct kill() path (hook_task_kill) already
evaluates the live domain and is unaffected.

Fixes: 18eb75f3af40 ("landlock: Always allow signals between threads of the same process")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://patch.msgid.link/56bffc24f3d0d08b45a686a48e99766b0a0821fa.1780614610.git.hexlabsecurity@proton.me
[mic: Check pid_type earlier and improve comment, fix commit message,
fix comment formatting]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c   |   14 ++++++++++++++
 security/landlock/fs.h   |   10 ++++++++++
 security/landlock/task.c |   11 +++++++++++
 3 files changed, 35 insertions(+)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -1799,6 +1799,14 @@ static bool control_current_fowner(struc
 	lockdep_assert_held(&fown->lock);
 
 	/*
+	 * A process-group or session owner (PIDTYPE_PGID/PIDTYPE_SID) fans the
+	 * signal out to every member at delivery time, so record the domain and
+	 * let hook_file_send_sigiotask() check the live scope per recipient.
+	 */
+	if (fown->pid_type != PIDTYPE_PID && fown->pid_type != PIDTYPE_TGID)
+		return true;
+
+	/*
 	 * Some callers (e.g. fcntl_dirnotify) may not be in an RCU read-side
 	 * critical section.
 	 */
@@ -1814,6 +1822,7 @@ static void hook_file_set_fowner(struct
 {
 	struct landlock_ruleset *prev_dom;
 	struct landlock_cred_security fown_subject = {};
+	struct pid *prev_tg, *fown_tg = NULL;
 	size_t fown_layer = 0;
 
 	if (control_current_fowner(file_f_owner(file))) {
@@ -1826,21 +1835,26 @@ static void hook_file_set_fowner(struct
 		if (new_subject) {
 			landlock_get_ruleset(new_subject->domain);
 			fown_subject = *new_subject;
+			fown_tg = get_pid(task_tgid(current));
 		}
 	}
 
 	prev_dom = landlock_file(file)->fown_subject.domain;
+	prev_tg = landlock_file(file)->fown_tg;
 	landlock_file(file)->fown_subject = fown_subject;
+	landlock_file(file)->fown_tg = fown_tg;
 #ifdef CONFIG_AUDIT
 	landlock_file(file)->fown_layer = fown_layer;
 #endif /* CONFIG_AUDIT*/
 
 	/* May be called in an RCU read-side critical section. */
 	landlock_put_ruleset_deferred(prev_dom);
+	put_pid(prev_tg);
 }
 
 static void hook_file_free_security(struct file *file)
 {
+	put_pid(landlock_file(file)->fown_tg);
 	landlock_put_ruleset_deferred(landlock_file(file)->fown_subject.domain);
 }
 
--- a/security/landlock/fs.h
+++ b/security/landlock/fs.h
@@ -78,6 +78,16 @@ struct landlock_file_security {
 	 * euid.
 	 */
 	struct landlock_cred_security fown_subject;
+	/**
+	 * @fown_tg: Thread group of the task that set the file owner, pinned
+	 * while @fown_subject holds a domain.  It lets
+	 * hook_file_send_sigiotask() always allow a SIGIO delivered to the
+	 * owner's own process -- e.g. the thread-group leader reached through a
+	 * process-group owner -- matching the same-process exemption of
+	 * hook_task_kill().  NULL when no domain is recorded.  Protected by
+	 * file->f_owner->lock, like @fown_subject.
+	 */
+	struct pid *fown_tg;
 };
 
 #ifdef CONFIG_AUDIT
--- a/security/landlock/task.c
+++ b/security/landlock/task.c
@@ -407,6 +407,17 @@ static int hook_file_send_sigiotask(stru
 	if (!subject->domain)
 		return 0;
 
+	/*
+	 * Always allow delivery to the file owner's own process, including a
+	 * thread-group leader reached through a process-group owner.  This
+	 * mirrors hook_task_kill()'s same-process exemption and preserves the
+	 * guarantee of commit 18eb75f3af40 ("landlock: Always allow signals
+	 * between threads of the same process"), which the registration-time
+	 * check cannot honor for a process-group target.
+	 */
+	if (task_tgid(tsk) == landlock_file(fown->file)->fown_tg)
+		return 0;
+
 	scoped_guard(rcu)
 	{
 		is_scoped = domain_is_scoped(subject->domain,


