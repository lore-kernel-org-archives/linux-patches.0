Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4DB234994;
	Sun,  7 Jun 2026 10:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826854; cv=none; b=u1O4q1og2PvyAPOiPLi0CaUmi7SsjqW8nDTCUDWhiVNK0kq7txv7wg1aRn0Wxo5j7LcgFkN7Vmb/p8o9ph3FytJGCzV0W55pSb3An8xXlsSP8zC3dIoh840A26wtq1cKmbPS+OBzCp5UHSR4sUnI39F6/eSWtHMQfFFWP8/usvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826854; c=relaxed/simple;
	bh=yuQLiYC30TovAZeWE0BzvmzBG+tBjUXy7byWvV3YLcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME6k47rwvYKIVXHt5+wFdTKKra+Z9AYo4Ize47bKPBYsxuvAeIJbAWgemWa/PtVBVZ4HhVNnpeianw35Ho2n5MwlDjORyvAHHDVTdp4iXYgdAwCHRfv5ZeBrnRoBJjOjL2oC3Iy1grvYoR9N4AK1YZxKnwNh5UabuZkewQS2mH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbAV8qvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbAV8qvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F811F00893;
	Sun,  7 Jun 2026 10:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826853;
	bh=EqXyAD9y3kdIGYutZXR5X8+BoudR2PyTvq0Dst1n/Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbAV8qvLUMyOB4qrXcE6bfku63VAnXmAIHvHPy9AfMFEG+EJ3UGs+HyT6+RrAShnP
	 /auFpBie28WoL1vOFlMblliud2MbrGHtMek1y+e5I5NPoFMs84XXuJUY8Nm92qi5E7
	 wz2OadnoBJZIS3B4amsUMfMLYdOA9uoQ8TbJ60QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@suse.com>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/315] kernel/fork: validate exit_signal in kernel_clone()
Date: Sun,  7 Jun 2026 11:56:42 +0200
Message-ID: <20260607095728.055006611@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 09e7827e785729f391c8d46dc71becce70d296ab ]

When a child process exits, it sends exit_signal to its parent via
do_notify_parent().  The clone() syscall constructs exit_signal as:

(lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible.  However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64).  A
non-zero non-valid exit_signal acts the same as exit_signal == 0: the
parent process is not signaled when the child terminates.

The syzkaller reproducer triggers this by calling clone() with flags=0x80,
resulting in exit_signal = (0x80 & CSIGNAL) = 128, which exceeds _NSIG and
is not a valid signal.

The v1 of this patch added the check only in the clone() syscall handler,
which is incomplete.  kernel_clone() has other callers such as
sys_ia32_clone() which would remain unprotected.  Move the check to
kernel_clone() to cover all callers.

Since the valid_signal() check is now in kernel_clone() and covers all
callers including clone3(), the same check in copy_clone_args_from_user()
becomes redundant and is removed.  The higher 32bits check for clone3() is
kept as it is clone3() specific.

Note that this is a user-visible change: previously, passing an invalid
exit_signal to clone() was silently accepted.  The man page for clone()
does not document any defined behavior for invalid exit_signal values, so
rejecting them with -EINVAL is the correct behavior.  It is unlikely that
any sane application relies on passing an invalid exit_signal.

[oleg@redhat.com: the comment above kernel_clone() should be updated]
  Link: https://lore.kernel.org/abwvgU17W8wuW2-J@redhat.com
Link: https://lore.kernel.org/20260316151956.563558-1-kartikey406@gmail.com
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260307064202.353405-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260316104536.558108-1-kartikey406@gmail.com/T/ [v2]
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1215d3f52c6d21..521e9d2be6f097 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2562,8 +2562,6 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
@@ -2588,6 +2586,9 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2786,11 +2787,9 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		return -EINVAL;
 
 	/*
-	 * Verify that higher 32bits of exit_signal are unset and that
-	 * it is a valid signal
+	 * Verify that higher 32bits of exit_signal are unset
 	 */
-	if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
-		     !valid_signal(args.exit_signal)))
+	if (unlikely(args.exit_signal & ~((u64)CSIGNAL)))
 		return -EINVAL;
 
 	if ((args.flags & CLONE_INTO_CGROUP) &&
-- 
2.53.0



