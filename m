Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773980;
	b=fKZVtKRPCFoS+ZCU2FaJ8tmgYe2EcuYth6r2qvMo3WdGN0+3PaeV/37vhxNrCvvMU9Jn
	 ne3EVkofIvefQ8nWj3d3gm7qV2gccrcd/l8lLybYgj7tR9W2htvxPtXO5X7PX4LBzWeGK
	 1geeHfSQNDcIWYh09UpuWvSsy482tKUuz324MJjr/JJiTAzhlb61yu7H6nfDz0iAIGcWv
	 2NDW2nhigF7/1cHl+TtK5PCsxmLVdNtXi4JD6juVt5V1dgQmFZPfYwwElzwIcWkGezS75
	 Fh66cpOgkq2npdWYR6IN9KoZ6vz+obGl+dO1WxFg5b971k/0wZH5Gp88pGBjwbU/sZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kg9Z2wBx65SFck7SUDLbOvIFChBNnuMHj/Tf9Lic5CM=;
	b=1NQqZL2AGCAw12D5hMCzmiHf4FPuCq8KH8PhisWHEdEX9MyGNprArLgOMTp7S+4GcRZH
	 yqSJMUdwHKeZHI5Oe1QlQJYyvFifg7DjX0dgWOG7/xKg7OrPej2dHbEoVXG8Rsw9CbENZ
	 R5ugWX1rP3k0pPdzGPCAl2+jhk3qmWXQD88ZUz6/oGhYgL1R6wxQxryJfgMLdH2LG7iNe
	 kL+H3uvgOY4eFI5xgkvq46RCaXYEceZiTRMWYddWrBh/BZqFmoaHFaqxr/S989/oRgKcL
	 luijs+r9tglYPN51v11odje027fJGkaJgM7jvKfoC3eRj6FnITi4c0YwEzHG4w6lAEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVbc9MzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E06606A31A;
	Fri, 23 Oct 2026 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVbc9MzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0DB1F01825;
	Fri, 23 Oct 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773979;
	bh=Kg9Z2wBx65SFck7SUDLbOvIFChBNnuMHj/Tf9Lic5CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVbc9MzSCBdoM/V9AgtU9dfq58eXBU5K6Bw1RghZVLbMXwc7aNSSkGvIgJd0doWEe
	 HzBp32IWcAGQDPkAI3XohBgDdn3hb0VgX3VSnaV3qExUyyA3E0zE+wyK9rR3vKDw8S
	 8rcF4C0/TgRHy7HjXUCGzN/fUAEOZOS7tKwh2DHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Aviv Vaknin <vaknins33@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 080/193] pid_namespace: make zap_pid_ns_processes() freezable
Date: Fri, 23 Oct 2026 18:35:57 +0200
Message-ID: <20261023163716.100341137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -1725,7 +1725,7 @@ static long do_wait(struct wait_opts *wo
 	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
 		retval = __do_wait(wo);
 		if (retval != -ERESTARTSYS)
 			break;
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -268,7 +268,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 * free_pid() will awaken this task.
 	 */
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_IDLE | TASK_FREEZABLE);
 		if (pid_ns->pid_allocated == init_pids)
 			break;
 		schedule();


