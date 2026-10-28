Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209868;
	b=fZeH44ZO8WsXYXtjS+dwK9QAMZ2ILzhH9BM+SnRVAaL4mTLsmZ+D98EVCHMD3a09Nj/J
	 E3RbDK9BIwAocC7RzV9Z/SkaJiJxrbxe5VqKoyOxwZvLQuqlOjQJOKcDqTJ0x9tS0eQLH
	 Fmjm2U1ealvARrSGQAOaPN1r/pyRlVXWeUX6GdhJvpVyGQzMm+CZnIyNoRE2THgTXljom
	 DU6LiHouCmTmvXxhVUnERXZENI9iiZroKK9wOE2lU8O8fwBZV+GRA/BjlnRGibSJzvqyH
	 /hatP5L+SKDvqJk5rg/uplNaE52iyxYQFUA8DZummZDVZwsiK9o13TQzok8GL6m744g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hok726YB0IkF3IdYcsyrB3vjA2mR0WiMVZR1rgxuISs=;
	b=s4oSIQehJ6mcg7wgTN4rjWfFl1D5LHRwULGial6s2ldvFS2QdYGlcnKuO5RjLmYoIi4m
	 Zkra0LXF7UB+ctBwr83sNzducQkm2UzR1dlME5pQV6KiMjDEYw37+xNTZNpNZWsMFal90
	 Dkqq9pjKKVotGfhQK5okwwXllvPyZGPaOMQZG9Duh++lT0hELpNPvvAbBBkwKQMYocPHV
	 idH+IJwelkA8H1Pigcfy0/OSHOJ4IZWAqe9ZFCJUWxoIzEtSMW11jGNk5Tbm8IR02gbDp
	 AG9JKxgL0Bgjj9RBWZfrbP7LzLNd4DOo1HqcconjJJn6ty6Khf/Wu7gQOzCVrYWxwKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moIAi+xO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62163606A31A;
	Wed, 28 Oct 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moIAi+xO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFF71F01825;
	Wed, 28 Oct 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209868;
	bh=hok726YB0IkF3IdYcsyrB3vjA2mR0WiMVZR1rgxuISs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moIAi+xOD4oqwiG5F5FbIb5DkNEwg6KNAfd7cMd/1ykGz2FTBpYENIx7iCNkNsSoa
	 2LGDIGJSzSv9CUHESkJ6B2R1GaS0deUwHFTFAhD/c7ujTxG36SH++GARrOx4u+6w++
	 FEVMUAz6Q4WQGP3JjbhH9wPtWaQ6yrMB/onoePU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 106/109] exit: hang up the tty before closing the files
Date: Wed, 28 Oct 2026 18:01:30 +0100
Message-ID: <20261028165944.851240476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit ad016f0131ebfec250a3360ea75d35128b3f4aa8 upstream.

do_exit() closes the task's files in exit_files() and hangs up the
controlling tty of a session leader in disassociate_ctty(1) after
that. Since commit d99d38540bf0 ("fs: make close_files() synchronous")
the final __fput() of every file runs inside exit_files(). So when the
session leader holds the last open of its tty the tty is released
before disassociate_ctty() runs. tty_release() clears signal->tty for
the whole session in session_clear_tty() once the count drops to zero
and sends no signal doing so. disassociate_ctty(1) then finds neither a
tty nor a tty_old_pgrp and does nothing. The foreground process group
loses its SIGHUP:

    do_exit()
      exit_files()
        close_files()
          tty_release()             tty->count == 0
            session_clear_tty()     signal->tty = NULL, no signal
      disassociate_ctty(1)
        get_current_tty()           NULL
        signal->tty_old_pgrp        NULL, nothing sent

That only affects real ttys. For a pty the master's open keeps the
slave's count above zero. And it only affects a foreground job that
holds no descriptor to the tty anymore while its session leader exits.
Everything else is unchanged. The DTR drop on the last close happens in
tty_port_shutdown() regardless, stopped jobs get their SIGHUP from
kill_orphaned_pgrp() and signal->tty is cleared either way.

Before that commit the final __fput() ran from exit_task_work() which
comes after disassociate_ctty(). That order isn't old. Until v3.14
exit_task_work() came right after exit_files() and before v3.6 fput()
was synchronous, so the tty was always released first. Commit
c39df5fa37b0 ("exit: call disassociate_ctty() before
exit_task_namespaces()") moved disassociate_ctty() up to fix a pppd
crash and in front of exit_task_work() as a side effect. The hangup in
this case has worked since then and that's eleven years of userspace
being able to rely on it.

Hang the tty up before closing the files. This is the ordinary hangup
with the file still open: __tty_hangup() swaps in hung_up_tty_fops and
tty_release() runs from the close afterwards as it does when a modem
drops the line. disassociate_ctty() stays in front of
exit_task_namespaces() which the pppd fix needs.

Reported-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-8-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -974,10 +974,11 @@ void __noreturn do_exit(long code)
 
 	exit_sem(tsk);
 	exit_shm(tsk);
-	exit_files(tsk);
-	exit_fs(tsk);
+	/* Hang the tty up before the last close of it can clear the session. */
 	if (group_dead)
 		disassociate_ctty(1);
+	exit_files(tsk);
+	exit_fs(tsk);
 	exit_nsproxy_namespaces(tsk);
 	exit_task_work(tsk);
 	exit_thread(tsk);


