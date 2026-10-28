Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207131;
	b=QWB598OwzNVSAAbxBlNsHHULPTZjTqiiGztDidewlbBEOny0CtnATp1ehCEk2JtgULS/
	 lLV2pSleggIgfFY9wcr3u0+DawJ3r48Dmsf8I7Y6nbiKj1KsNhx+1JTkX6sdWaGOPPUyZ
	 qC7yw4JD5W7SP5DMySeAtCNwz1xy8wxBHgEu+ui6lrS7RedkbsZIT1LDHtjfhnxzH7mY+
	 +T5MkyRfenoN/NO4/qw8iHHZq3WyhFwJTuxtFk8+79Yq0u8O5ySiWphFU2btCtJMXgVO2
	 wz53c3nZEtoRJ9gVk4CYYZVywf5HlaM3+ihECP1nwXvRoubSJS11/ouo3QM+seBwdqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VuA5sFm6BvbqX/TETZrJ/8pypVpksNnH+JhDdTctjoo=;
	b=EASRqasvVPm6LPMWlhxvrK5CT/6eD7Jo3pluuwZeo8xRVzFd9JTvsGgvebCq+Nv9R2js
	 lxiy4Oo6BlJGlD67o7O3UBWn3u5ecdh51pH7iQTpeII0UfePpCS8OqUzM/kVmlXS6bm8v
	 dsmVrqASKHDAJgyzL+DtFFHp6JabVXpj+tJC3CeXenLlisRQ31cR+u4UIoGDHq2AtcQwR
	 as74ukSuuv23w57SXFS73uSjr/aSVMX0AKJfRE0EfOslQBeed/dIxdjn6CTdA46AjWnXB
	 TfNgqMbw6VQr/MjDmk1rOX99lG08WyuP0FAbgbAoNcMEn2Az6jYMRSsPItDlz8BUl6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfpPTsp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E0C606A31D;
	Wed, 28 Oct 2026 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfpPTsp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352991F01828;
	Wed, 28 Oct 2026 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207130;
	bh=VuA5sFm6BvbqX/TETZrJ/8pypVpksNnH+JhDdTctjoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfpPTsp0CMlndKqk6EJoP8a60yzgOmprQ50vdAP9zcfuZfJMoCHafaq3f5Wj3BXMz
	 Cw7cFXSn18ecZFB8XeFQSNZNK5WgRuzbyeFUwlQtA30hay2bHr8nImswTnQv5aa1WY
	 41VS+wCV63DPL73oKIPgeXBYGy9JAU0T6PAJwbRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 35/38] exit: hang up the tty before closing the files
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028165941.285644479@linuxfoundation.org>
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
@@ -978,10 +978,11 @@ void __noreturn do_exit(long code)
 
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


