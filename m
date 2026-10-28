Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207111;
	b=BjTCz0Rx6rO3r6FeZAM7udPq/SdmHsjoKEC0telTXt/53xj866tfqpdPwEHku4yzaRJK
	 7YDy+xjNUiXI9O1hNrRTIUEryrGj/NnnYRO2ywq86xCIkUxXJpZcoFvknWKA9czggrW5E
	 Y3wEk/AHy+wOjY28SVHwM1FMhi1mpRCJ0NiO71TaPuxlE1+7UPUdylqwFWtMJwdJLPQl9
	 3CM9YS7RtlY8PfeWevVVtU2lfXHiEkxqZMEE4ifuCMzoW9fGvD48WC5Sxm9zSXL3oFQ+0
	 KMpaOGBHfidYCPpFAqnR7oYfgJAj6DACeAIidi9G1/3k5oqh8wINl4aDGFjbwjQZkdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c9zgXtS8QcvW5eoDvATXt4I/ImLGBwve1jIkR9G+uDg=;
	b=1JG8WaFofKWQ0UN3o/nOxswAv62wu6xyrf6EnZyvlZxK6T1H0JNAhCvU9810bmmQcGKq
	 2Dys6P1BQyH5xKnQ/ac6wQN8768g1FR/FKk2vlkcvitu5IF8CYeTgvrNVdgLCM1G3ngsP
	 fxQ/nLQ0jDO6R2unppyqSF1WBIBXhmCaY+WIcW6qy84UAQknZdQbJKsnBtv9fw07iNYoh
	 UIjmth8NctALrEWynDJy6+GXCk3738aI7lEsGnxVLbe3iXS+xxzmS+LwxBBNJAfRdgWKU
	 iocdKK4Zk8BO9QJRvqJMfafUzKTbf1MCsYuLcBGlSPeDQBMHQT26UdKP6Wnv/LBX+NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mhe3PIzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F7606A31A;
	Wed, 28 Oct 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mhe3PIzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0B81F01828;
	Wed, 28 Oct 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207111;
	bh=c9zgXtS8QcvW5eoDvATXt4I/ImLGBwve1jIkR9G+uDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mhe3PIzbXkYfZZ+YqldLuRLqYMX5WwtKzzyQ88nwrsrX5HnUQl47dkVmV4khHYYLn
	 ixID8vy2S90GUs02c9QnkNp9nlDkrazCjNCpYGLpDMxUAoerqUBtx7qWI6zlIvSZTI
	 LtZiskTpZ36fjtSubFGJOILw4KXok2tFMwTKnXsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 29/38] coredump: hold RCU while releasing parked threads
Date: Wed, 28 Oct 2026 18:00:16 +0100
Message-ID: <20261028165941.144101001@linuxfoundation.org>
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


