Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207363;
	b=wZX62q2AD/wfXEoMGrHz1C/FgIKPwtFI52+dUfWLWJBOQkER8KG9yegrgs6jC7xqR2zw
	 2Ma0M13T7QM5FFBWw0Gh5Qv1BUiiFqIqJd6V6wDIMo1SsLV6j4rlzqkRM5/Pfi6wdcijC
	 t/yZTjQaAUQCoEW1cqxYJp43x5fE4+yeRti5Y0lm7b3wt9c7l1GKaAbJsNKcBCkRslwfP
	 kQHcCAnhdGS0yTV/EXTnSd8J9PoNESsLj5Dg0n6zYU6Lm6wGvBzQ8OXXb4fVkz/vofji8
	 Ldf7YTN1W48sbpnFkSSOO0nRlTZUlSbZm5npE14HzVz74a56sadPhYQ4f7uCdkIJl5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/nF+kiTUGlAuiXXjbsMkwzd2+OX6893B1vhu04Cqhg=;
	b=DvrVtRJDIwBYcbBF1y5AjkYL/lEz9EpKHBbmHtSY6I/XxuqcPwWbOuXBEx3F6NRB3dZv
	 NeHTz2hZj4KBBfTPRTHA6xS8qsEeWzz4FV6AcXblNR/kiStFP3Q8730K7hM5P6nIx3P/R
	 qGQ7QT0QHuC5VRX2doRyMKCcbHu+MDi6VcH+7qoaQCdjdo7WQ8iOre1AoVdrifZd/yGnl
	 sNvn6vWoSsDFGB1SDe3A+ajqlJ4WU7aMJ605GA8znr3JzET0UeHgNDjNkHAcyov4OCnmA
	 vatz/sr7RunFZVeKSyKRSz9DsqLMCqdV77IrGJ7rGizCG6K5Rmo7qAzW2mJEPkHqauA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMFMTol9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446A6606A31A;
	Wed, 28 Oct 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMFMTol9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950571F01825;
	Wed, 28 Oct 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207363;
	bh=y/nF+kiTUGlAuiXXjbsMkwzd2+OX6893B1vhu04Cqhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMFMTol9DX2x+1M0MbEgCgJtBGdDi/5OgVGlOHgUHS1XL5zhhg/QdB6B5kIZs+uXv
	 vyCodQx+WGS53LAI+aYisIjyFvOK5z6A2WraOi+QlC69WuxNKyK0BVLNzoWFV0+Sbh
	 AW3RYo5Mu8priWVkrQX4m6th9tJoIdSGeM2WF7UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 80/88] coredump: hold RCU while releasing parked threads
Date: Wed, 28 Oct 2026 18:00:28 +0100
Message-ID: <20261028165943.997891389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 61d58591aa0188bf2463e263962256316ff8b576 upstream.

coredump_finish() releases the parked threads by clearing ->task in
their core_thread entry and calling wake_up_process() on each of them.
It does that without holding a reference on the task and without being
inside rcu.

But calling wake_up_process(task) without rcu here isn't safe. A parked
thread doesn't need that wakeup to leave. A spurious wakeup or a
preemption after the store is enough for the task to go away.

So if the coredump client is preempted between the store and
wake_up_process() the thread can exit and be freed in the meantime and
try_to_wake_up() takes pi_lock in freed memory.

Hold rcu across the loop.

Fixes: a94e2d408eae ("coredump: kill mm->core_done")
Cc: stable@vger.kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-1-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -562,6 +562,8 @@ static void coredump_finish(bool core_du
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -570,6 +572,7 @@ static void coredump_finish(bool core_du
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}


