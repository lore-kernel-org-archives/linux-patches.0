Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208075;
	b=TRzy2cF+ahmp5h97glJeLfFU+0PHBpOT4s5KhBrPtdwMRgyJWA+29qOsDEOWaMMfnmmH
	 qMeEQsnbVnlEXgDkS2ATeIPFo3D+RqaUe3kZN7ppusTkdzNXUm8Qhk7pQwn/M1LOL/7in
	 K0mXwuESIbe7gHhBkDLC/OhL+qsooaAbQE6S2bMSvmLV44IRK7EmezKOSGFLaBzu/LV40
	 O+JYiQoGu64mokBd6QNnYaGno/1zTCWdwT7jcScOIRuFCzQ+HQOGMWlRHfw/BYRAsst82
	 7apUTHoEGX77b5TCaWDZgIwRtYfgxNRifq7qoRxLqlobloaJpFlQ2FwxWnDJ0zmZTtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0yt+9PlPIDL0+MrTEXzfTyUgAmcxwfwkp8ROWUjGlg=;
	b=ldCb6NogcRqutYzIwcM65l9GztzvLMQ2723YjTRY85fzYehFLh31OallGLe/izxFiV+0
	 UkujVQ3MCN9CxOEk3RSS5aQp0060BaYmKgx8zuW5iCwEZWbYfofPef3gaxCp8ndM4ALZ9
	 YYE2KVyKFnR4gtDkd8YZFcwhDyAmSLbIW30iirpGzYEGY9wUyfJ170j5FtV9Qb1jOHhnX
	 2k1DOd5xwePYs1QdiJ0JtsNeVWU1wRRL8dr5iOOMs07FM8NIhSgOyF61KJL5MnY+Yc3Wt
	 VN1bujZvMdzZzAzmYsDoBlfOVh8Qgh6Z4QBcusTOJ/kRyt1esjYtsGUPUqVF3+ghlzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbYKvetf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B340606A31D;
	Wed, 28 Oct 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbYKvetf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795951F01825;
	Wed, 28 Oct 2026 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208075;
	bh=r0yt+9PlPIDL0+MrTEXzfTyUgAmcxwfwkp8ROWUjGlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbYKvetfJir06GrGMon+oOrPO2uMG4+EMhwxT+8/9K/NY6vqq8kmJdP+q2V4SOEmn
	 KiMnLOjYHHDHijXHPnKGV/2zYreQeXrWeFnsLSW2VWKAwZJNJsxvzZfj93DCfTs2gJ
	 8aF4OePi+khbJxKKIF/24LHejJB+X4MeUe+JTgdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 240/247] coredump: hold RCU while releasing parked threads
Date: Wed, 28 Oct 2026 18:00:43 +0100
Message-ID: <20261028165953.105996139@linuxfoundation.org>
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
@@ -474,6 +474,8 @@ static void coredump_finish(bool core_du
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -482,6 +484,7 @@ static void coredump_finish(bool core_du
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}


