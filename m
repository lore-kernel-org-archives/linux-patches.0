Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210275;
	b=lC+s1wkThKxdeXpKUtRfXvqowLaO2s5FztcX+T1qp6sG2jVD/WLbFajT8E8hTmqUYvKX
	 kq9hcdz9fcX4LLe/6l9+tWeNKZSRsPpe0edQJ8XhDTQn30Qpa4vMfV830UGI+HBNqcXIE
	 yy0Qdj58iuGCuB4M+BiworKrL5G9HhXjzx/Qa/1TE8/Y1NjzRqKeWsDKEpvjFem2Nssx9
	 d+/higQOswexw2ptLpOGlu2gPGuG7rthm3LIhH/upTA78++9plcCTKtAgzl4kFdLFdk7x
	 Z0TW2u/Ppa619lSopy0rOCQCO1XIO+f1sHDNRieUygGUrfIMGwaPvvHLfDIx3S0RRsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9OmtLjPzcPuisTUM3NhMQuSXm0oE5unCQijxCCWZxjw=;
	b=p36yjOkCD4hoGOd8GqpiakVLRMfMZ8W0w5R2ZopM4KqvpjzyTytmI+NiDeOxvBPvERXV
	 Tk7gGk1XpqwZ1LFwyxNU2e/cbhgMkn7TNhPbVe+LG65k824OKIRyNh0A23uZ94MEXRWf8
	 oGIV4mu+B2IoNQCRnegF3E/ydv1WdblG5KV8CJKkatlTxG6+wmEFC+S9+gEsxIVQPpG8l
	 dw8nZOfG2/oKYKZjJAWQYFqi6rIwNawBezl0c/8J4y5sQLqTJ/83CJLwsLM0o6yWe/4AG
	 Vjb1ssVZqmrNhj9IbplnV1el1ni31FB/rVYZBL1zyUZTPAe0qJAKiH29rNR9/QQdkzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyRfWHYV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80650606A31D;
	Wed, 28 Oct 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyRfWHYV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18091F01825;
	Wed, 28 Oct 2026 17:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210275;
	bh=9OmtLjPzcPuisTUM3NhMQuSXm0oE5unCQijxCCWZxjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyRfWHYVxlehzqbklwk2JA1kJzF1Mt9XrryVzGOrjSEzwlfv1kSVIf1poEPG0BeI4
	 DU1WWbuLn62xv/ZVIthVXKolUkjmfub9dxRZehswuBpXHgl+thYaAA3jEY9+66uijS
	 R217li7Q16vPiPT9Qcrq0AV+5TzsXGo5LcTp8FbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Aviv Vaknin <vaknins33@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/168] pid_namespace: make zap_pid_ns_processes() freezable
Date: Wed, 28 Oct 2026 18:00:37 +0100
Message-ID: <20261028165945.478191829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aviv Vaknin <vaknins33@gmail.com>

[ Upstream commit 81933038f5e273d17ed22792f906889393b204c5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c          | 2 +-
 kernel/pid_namespace.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 07a17f0916107..e2dae48578d96 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1648,7 +1648,7 @@ static long do_wait(struct wait_opts *wo)
 	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
 		retval = __do_wait(wo);
 		if (retval != -ERESTARTSYS)
 			break;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9b2bb260ee6c..eea15232f6690 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -245,7 +245,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 * free_pid() will awaken this task.
 	 */
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_IDLE | TASK_FREEZABLE);
 		if (pid_ns->pid_allocated == init_pids)
 			break;
 		/*
-- 
2.53.0



