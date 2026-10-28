Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207588;
	b=0Ed3xk+BzyuFJUpy4xnw7NIEaW0u76CAv0csUKnUAeKcpkSyFSZYvosfRYEdp29p8rFc
	 unB4PEigqRMj0AGPjUr/F92d5Dtj444c3e1QbZzFvzCzzAyL87YkLwI4BhtnSOCLmRFA4
	 SGhfY5YFpjifr+P/7Z1JYOeoZ9jhQ/JPBKZXo8JLZPGynea3A7wW/M7V0+0BXf+90j78I
	 /gLcehAHVZh4MOKdWxRdV+gfYQ8hIGXQp/6vDeXPZMToETSrWhXu2JRYF4R5jJNCleDW0
	 /vZYfDX76bbbX4SH8sZeK42LJcrl4qaegxS58rbagQrEcO0/coT+yzrBYavepMDSghg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sf6M4HLCC6edJmQURybIZrMHWxD9v3qqzQoGF4qIBM0=;
	b=cykMzrFM8qlrK7Dbw5IhrpZUBF+8HE8x+hP39PNwzL9ZftAcLJJ1GJFrCPhxj3h2+HFe
	 mb5E1TXAvOBU9ETmRsU5x1Ow3PLn2wAfqUI1kjMXyWaGoQhsDULgFrd9VLbUHgl7Jpp7d
	 0gSjXJFfduG6N9ilYcgp/77/Z9RSDbVEoI6c/FP3V+a9HixO1UdckOsfy/pjJEsyRPtRw
	 z+Ro2WYDXOTJy5P12pJbJHELTTXqPaJMwEg3uGmfNRC5rglC5xdMqHTHwG1BtZZbZ3q/o
	 CqJPocT0thtZnyYAsj/iaQT4+53JM+9UCE/hJAAFr7wt/JSft35RH9Bq1AVeaBNSmsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mew6ZWRT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F34606A335;
	Wed, 28 Oct 2026 17:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mew6ZWRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A52B1F031E3;
	Wed, 28 Oct 2026 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207588;
	bh=sf6M4HLCC6edJmQURybIZrMHWxD9v3qqzQoGF4qIBM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mew6ZWRT6tp3fz0QG/QWl1ZRZ2K5VaHWgzH9AAyBJkcvNK7VmSH33bjK24CLsKxr/
	 FPY5uz82SqR5houT6maFJqaHtS1CWfKmnJFM4m0mswJLOyso4qMaWQ/2ckpHKwKlmo
	 x3GK4LK52YTlEiAJTj79ND2w0p9TyCpSwkerHHUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Aviv Vaknin <vaknins33@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 068/247] pid_namespace: make zap_pid_ns_processes() freezable
Date: Wed, 28 Oct 2026 17:57:51 +0100
Message-ID: <20261028165949.000691679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aviv Vaknin <vaknins33@gmail.com>

commit 81933038f5e273d17ed22792f906889393b204c5 upstream.

When the init of a pid namespace exits, zap_pid_ns_processes() waits
until all other pids in the namespace are freed. A tracer outside the
namespace that does not reap its traced zombies keeps those pids
allocated, so this wait has no upper bound, and while it lasts every
suspend attempt fails:

  Freezing user space processes failed after 20.006 seconds (2 tasks refusing to freeze, wq_busy=0):

Neither wait is freezable. The first loop sleeps in do_wait(), which
returns -ERESTARTSYS on the freezer's fake signal; the loop then clears
TIF_SIGPENDING and waits again without ever freezing. The final loop
sleeps in TASK_INTERRUPTIBLE, and since nothing clears TIF_SIGPENDING
there, schedule() returns immediately after the first freeze attempt
and the task spins until the wait ends.

Sleep in TASK_INTERRUPTIBLE | TASK_FREEZABLE in do_wait(), so that the
freezer can freeze tasks waiting there directly, and in TASK_IDLE |
TASK_FREEZABLE in the final loop, like coredump_task_exit() does.

This was hit with Chromium-based browsers: crashpad ptrace-attaches the
threads of a crashed renderer, which is a pid namespace init, and does
not reap those killed during the dump.

Fixes: 3eb07c8c8adb ("pid namespaces: destroy pid namespace on init's death")
Fixes: b9a985db9896 ("pid_ns: Sleep in TASK_INTERRUPTIBLE in zap_pid_ns_processes")
Cc: stable@vger.kernel.org # 6.1+
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Aviv Vaknin <vaknins33@gmail.com>
Link: https://patch.msgid.link/20261002202820.3433318-1-vaknins33@gmail.com
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c          |    2 +-
 kernel/pid_namespace.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1696,7 +1696,7 @@ static long do_wait(struct wait_opts *wo
 	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
 		retval = __do_wait(wo);
 		if (retval != -ERESTARTSYS)
 			break;
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -246,7 +246,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 * free_pid() will awaken this task.
 	 */
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_IDLE | TASK_FREEZABLE);
 		if (pid_ns->pid_allocated == init_pids)
 			break;
 		schedule();


