Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217248;
	b=O4dB6XwAuu9aEbMt0iQ55Kz7j1Xmtd4Fk2I/hc1S7AEYVIbepNiT2vDj+m211FMXePb2
	 dRsLHm9VkCKZ/pH+uA7zsNkTOEc9SQ0+G/psTnVSs686eoxlaxDpq9flEi24ezLkL/qk8
	 6xkFv3gw2E+V3wDweH87jA6F2hnVKh7xaFbupyMtAkMBLXrwYnEq7gKle7xDlKkd5UvkU
	 Am2Bx2hXkqKWWm1QZ226Tkv+qgc6SrmvETpFDP1I45at6hu3YePzTO0fCoHtCI8RH952V
	 t21s9bqAyyMIlnxHjIYrVUb7dUhnJSXKAaZufcGaqYaotFiG2fwyaWcaKgJvKuABK/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=daS1aTTVKynhTipZmyB62w7P5cuy4q6Tr8Hf0H9a4RU=;
	b=gNqF1LRmtxfzlzwzOd6ZIHyh+eqnzFuz0/AueNDX7xNINCIFANKWuhVMl6jh1PfUA+pC
	 f/0PHPleet0DvFPs5hWPuIZOTXTg/OgrWwLbEaPvi07PTFopsK8xetFUzgsyj2EHSPG5V
	 fJ2nVY4xG8tiUj0n+0RQcqINS903hltdPL4QAqdwb8S2f2ecsnzgsFc3xpHEalE3rCpdi
	 54MWNoHYI6Z12lQyLvQiI4ri6i6bEJAW59eu+9fAqjpVBytVG0dxMq0Vvfqvg7m0WJNlE
	 r7G/4WcE9ZyCn60twXWEIv/vBOH2PSRc5cE7hXFCUEoGfqlPYYmS5wVox5airI4jzhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGyISh6A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68770606A31E;
	Wed, 28 Oct 2026 19:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGyISh6A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2561F01825;
	Wed, 28 Oct 2026 19:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217248;
	bh=daS1aTTVKynhTipZmyB62w7P5cuy4q6Tr8Hf0H9a4RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGyISh6Ao7ZsB/Hz+WnxPrCq5SzDKOR5vLhUnqgDveANCiuTqGHBeMFJ/XlKSB+yQ
	 0NRWArsdvkkSknGu+NzFDPGvx+E7GzSMcCGrAK2NdMtzGnWW5+/Bpe5ATFJ2AtAWkD
	 mUhTotuZLrNCCRHhhYnIZn2szMBhKoNuP78576iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Aviv Vaknin <vaknins33@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1783/1887] pid_namespace: make zap_pid_ns_processes() freezable
Date: Wed, 28 Oct 2026 18:04:39 +0100
Message-ID: <20261028170540.024667421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4addbc7aff20..b3cfeba72dc02 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1646,7 +1646,7 @@ static long do_wait(struct wait_opts *wo)
 	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE | TASK_FREEZABLE);
 		retval = __do_wait(wo);
 		if (retval != -ERESTARTSYS)
 			break;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a575fabf697eb..cd3ee747649db 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -242,7 +242,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
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



