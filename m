Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774654;
	b=ksRw/+1VTwsplDqU2/nRs9GyRa2oZ+cC5M7XIzWrAj21r1VzXZuzZP59nirg59jMpj5g
	 7QdusH99VqJsl+YHfvkT3gY2e93TjZ1h1PBLXlhNT44RCjBLShi2UfRRRTU6W7d5klF+d
	 7RfL+To7wHZf6AnjLLt2vfIv8joc+YMcNAeNrpqN2J+i00WUH+A7Weg6KYsVRIJs0m9If
	 t6zfC9woKm+OwHmPR+mBqWoLm6pcBEOOIdKNok5n7y3uMzfG92h1ou4pnWVQTLDR8cnFV
	 nAY19nr6BrhQ0s5bb+CuZZY/AwtzgweFhQOMl5/XxRYx2S9nm3h6IV5poO2EZdmEGaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25m3RgPO7Ww9GDCOHeWLHRAmkeAtY7WFHQ+HXwinn4M=;
	b=mCgTSgNjsCXj+meYryl0dVHsFsgfUnKdfqYLDoQ+mCze9YvHnLowPzSgXRrZ6C3md9+m
	 /MA5EzAE/bqiPFUAfFVNzI30UZelmNiW7Xe5A+xIlkAZT3Ly+tKne19VcfX6oJr443tiQ
	 u3iOXqDMmRT+qHjXFeUF/zfiCjAtKIePqV0WrLbvyM1s7grYAiYAEvjlaMQirzaB9NxyO
	 UNOadCARkSxCNNo2X/32A8GV0ZE/nIK2vqVPjCbXhqGzEkT8YqN59+IvPPCs8MMvmZs6R
	 y1aHLXUwL+2Qhhy1IR+YdHIOCXh00vgPTB25LJ1h9ekNiBS+3qgNWlQfLThxP05Vnyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/ijncWR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D612606A31D;
	Fri, 23 Oct 2026 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/ijncWR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9211F01825;
	Fri, 23 Oct 2026 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774653;
	bh=25m3RgPO7Ww9GDCOHeWLHRAmkeAtY7WFHQ+HXwinn4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/ijncWReSsuIZLx9DmwYtq/bVJ/mar7ruMiyrqQAeUN6gi/d5bplzuEblzKJXayR
	 q9CO8J7r0185cMU6jKQOMpan5pRqGEqCq8nVm/jNqEfwmTczwSBcVTM9JiRi4CIB9C
	 mEKNL4PBgqde6orPVFPhqOlYU2e/erYzIVD0hzxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Aviv Vaknin <vaknins33@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 113/242] pid_namespace: make zap_pid_ns_processes() freezable
Date: Fri, 23 Oct 2026 18:39:15 +0200
Message-ID: <20261023163716.452153964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1730,7 +1730,7 @@ static long do_wait(struct wait_opts *wo
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


