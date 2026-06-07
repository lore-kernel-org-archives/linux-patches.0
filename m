Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412032E7373;
	Sun,  7 Jun 2026 10:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827191; cv=none; b=IPYFo0DK2svtVRGFoLau9gPZCgG6JmayVhjJudrqygH9mh3Nrr91bWR0hht6G3eldDES3wbyHRi1iJItiSNxf/a13AaF5RgH5BDnQ/YP0FYJxjmvHrwp7gcjRIEh4TMWIYHCBNK9lZuRBlHVSBo8yfBIKwvPphh6aQri/1d2GWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827191; c=relaxed/simple;
	bh=oPuduuwlhZlC4luN+w41kKU9pGlcghiuy2GCt7Bkp9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxEBu9WaXYp27K18LjSlTofAisgfPMPug7wSRNehJDxi5079ML0cO+z4NCFBRQftcyPojGw+y6LAaNzeFrEo+L3Y8zc6NpAaL1IaWtH+YPrbMyLLqLO7Qf4InbE2nn5HO61F6WB2IQqafPQvWnAohvsHT43HSivEvTxOIoues4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBC55Wjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBC55Wjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DAD1F00893;
	Sun,  7 Jun 2026 10:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827190;
	bh=kBR0+JIbSJhT0kOet8C0276a1sanOTtYNe5CeUOFKhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBC55WjgyzdyTyuUrHm1I3w/techQMvl9R2reD30DN7rtZz2XNyJ39IHgSeG1bOdu
	 ekiz92T93XSLB6+bPMQBrHskd8dso0Ccv0ypR2t6b1GyiGQACq75xCQzjvYbSS18qI
	 6ZLREA7HMHeP1J6VEh913SI1h61Bi/j6UGzlwELg=
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
Subject: [PATCH 6.12 030/307] kernel/fork: validate exit_signal in kernel_clone()
Date: Sun,  7 Jun 2026 11:57:07 +0200
Message-ID: <20260607095728.764887196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
index c4955cffcb6f4e..1f306743832b3e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2773,8 +2773,6 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
@@ -2799,6 +2797,9 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2999,11 +3000,9 @@ noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
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



