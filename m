Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207117;
	b=wXhGBaiyPaPpftHHqJEa+StaUe+h3OnJ1RR8oWdqv2omZX93vN5jRnuws/NNoWIoYFuD
	 MM4WS5Mwo6bctrDjS/VbFy0UhbyXAaEatlOpPMZp+WufMvsMW/Mw7kU0PZAD7R8vBUlPQ
	 3CAFurDwuJ4ETZPCpE4HP7gv+01ddMSFyoAUPb0sT1rna9WrZgWGqB5IzgDVWHUE6UXVc
	 6Ia4RFt89o+3L6cnO4Fi96gSsWiguco+sS3fWVE1RWRpAvY0nxdb0UTbnd0pfHE8Lw42d
	 JAGZ+/ZwwfQgCkSXO90selbdPMhdQ1DacAkkkG/0RgOkMcFSvCtkSHkBdEqPPecGm7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JnXzmGN0k0lZO31nqYVPBk+fVGm5dkTJU/Ped/lR93k=;
	b=Vmcn2NyvhwVnynHF8gzewitSOgMyKyrCYf9RbaBvD48f8rW5IrO7eQDwtqlXpmPpsrpn
	 YnemXl1hzr69uwqqADSbjTXUMVvztYkrpdHbkFgQrWs5k0B1Qps/vDObZsndeqVIs2m+O
	 lOHTFNeAdziGeaeVgoeo5DkY2dACHPtU1dqexNaUZN0169+O8xw3fQA8lGXj4iUgioYKF
	 kUBQVUTE5ZL3K/gIS2eYbRk421v+SKnbDYuyK4xaV4VsdReAWcZfPPQ+2ERc+dHEEKrqd
	 ZsoDTAZEp+v9+4X7IxvoFlX5A4PosLp4YUs9UHlaY1OAwM1OMFHm5ATLeezoRffuyHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQQhl69H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237B9606A31C;
	Wed, 28 Oct 2026 17:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQQhl69H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A49F1F01825;
	Wed, 28 Oct 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207116;
	bh=JnXzmGN0k0lZO31nqYVPBk+fVGm5dkTJU/Ped/lR93k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQQhl69Hkw+N7io16QjmUMtnqsujlUlDpjbvKe/AjVUpbQnsgWE94TqZQ82qq2uAk
	 FAakKT/THts8rf/I/uZCsrel4YhIFW5FyI6bYaEYXtXfYJY/HiLccBXprf1je2DOIZ
	 3eZsfe5Rk0w5MnyS8Oh96UjU/kj5pkG1p70nDqY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 30/38] signal: only SIGKILL and the freezers interrupt a coredumping task
Date: Wed, 28 Oct 2026 18:00:17 +0100
Message-ID: <20261028165941.167725969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 563d606b93d7a1d23512832fc252d32c68860d87 upstream.

For quite a while now coredump has allowed either SIGKILL or freezing to
interrupt an ongoing coredump. Since we seem to like it complicated
"freezing" can mean a lot of things:

(1) Power Management induced freezing
(2) cgroup v1 freezer controller induced freezing
(3) cgroup v2 freezer controller induced freezing

So (1) and (2) are handled by checking freezing() but (3) isn't.
(3) uses cgroup_freeze_task() which sets JOBCTL_TRAP_FREEZE and calls
signal_wake_up() on every task in the cgroup. The trap isn't handled by
the coredump code.

Which means the current logic is inconsistent. Power and cgroup v1
freeze and abort the coredump. With cgroup v2 it depends on where the
core goes. A dump to a file completes and the cgroup v2 freeze has to
wait for it to finish. When dumping to a pipe or socket the dump is
interrupted at the next write because of trap's TIF_SIGPENDING. Which is
it? Let's be consistent and align (1)-(3): freezing interrupts an
ongoing coredump and doesn't make it wait until the dump is done.

All three freezers go through signal_wake_up() and so set
TIF_SIGPENDING on the dumper. And once zap_threads() has set core_state
that flag can't mean anything else anymore. prepare_signal() drops every
signal but SIGKILL for the group, the dying threads don't retarget
shared signals to the dumper, and zap_process() cleared the pending job
control traps. So the flag is the thing to check. Let dump_interrupted()
test task_sigpending() and nothing else. That is also what the pipe and
socket writes already fail on. TIF_NOTIFY_SIGNAL is left out on
purpose, task work must not cut a dump short.

A seized tracee that gets PTRACE_INTERRUPT during the dump is cut short
the same way. It already was for pipes and sockets.

The one freeze that check can miss is one requested before the dump
started. zap_threads() clears TIF_SIGPENDING and the cgroup v2 freezer
only wakes a task once while its JOBCTL_TRAP_FREEZE isn't part of
JOBCTL_PENDING_MASK and survives zap_process(). So refuse to start the
dump when freezing() is true or the trap is pending. The task then exits
without dumping, which is what happens today when the freeze interrupts
the dump at the first write.

Fixes: 403bad72b67d ("coredump: only SIGKILL should interrupt the coredumping task")
Fixes: 76f969e8948d ("cgroup: cgroup v2 freezer")
Cc: stable@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/arJ6zZuI59BJnXpl@redhat.com
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-2-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -508,7 +508,9 @@ static int zap_threads(struct task_struc
 	int nr = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task) {
+	/* A freeze requested before the dump would be lost with TIF_SIGPENDING. */
+	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task &&
+	    !freezing(tsk) && !(tsk->jobctl & JOBCTL_TRAP_FREEZE)) {
 		/* Allow SIGKILL, see prepare_signal() */
 		signal->core_state = core_state;
 		nr = zap_process(signal, exit_code);
@@ -580,13 +582,8 @@ static void coredump_finish(bool core_du
 
 static bool dump_interrupted(void)
 {
-	/*
-	 * SIGKILL or freezing() interrupt the coredumping. Perhaps we
-	 * can do try_to_freeze() and check __fatal_signal_pending(),
-	 * but then we need to teach dump_write() to restart and clear
-	 * TIF_SIGPENDING.
-	 */
-	return fatal_signal_pending(current) || freezing(current);
+	/* Only SIGKILL and the freezers set it after zap_threads(). */
+	return task_sigpending(current);
 }
 
 static void wait_for_dump_helpers(struct file *file)


