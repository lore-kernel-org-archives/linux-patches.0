Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217088;
	b=a5WAuDT+qhQYoz4BeADpdFByhuOglnnBOqeT/mNyfiWGc1Ne4o7+Oz7PHTdlvHTyR0o0
	 aiKYJfjqGPAZgibhJ6jz2Qbmfa7GUNiR+wcf/BMSP07LSawreh9eMcoudHrzp5A2BNNtE
	 +m41iQ5sVeDTRqBdomG0bDjI0GF2yGzUIq8bXWtjqTmWAnCf2HOH2Nr8kyAPQ/q7G8pnD
	 pC6eb6RxXsdI76OcXd6kCsRTwmpyFPGeVzKokrprJMpdYDuwaOJl55/BBKP3QXJ7l6kHK
	 12pRc5AvtKqx8VUz+xPtqooMrjVY7UbFu93U1x+giCyEb252PuqzhFwpoCuNE5KnnJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uAUVNRst+Bd9DU9jSiOrHOfsqe93Hy8nx58iRi8R5B4=;
	b=pyIa9zOliJgNXQ98jimdrC41KNaFN/tFCcbM4Fjtiz2mBFJJzQ7jQL/LsG6eXD82gndX
	 61ycuJeyhda28S/Zw+eDo3LjOJ4YhPJdnjUXBv8IbzWZwZkQ5jT1+tmq825PmnpeEK90u
	 8akwYcxjwgfBkRPYHuFkCrZ700ggfYMfsEUgq3N9pQT3xeAYmUaQgHcJFjXOLw9mmuVAs
	 y8Ro1fPgy6BvtEuscTKWbxAjPnB4urqOCh+YwJWx5KGX+gkHk/cnromlFnzeeKVpYR1yb
	 0kan0aIx/k+G0lhtB79qhxxhA2GLhGp/ssKYpib2BcK25LcNe0xWxUiTafrsABqSKpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JaUiTyDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF77606A31E;
	Wed, 28 Oct 2026 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JaUiTyDe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC4C1F01825;
	Wed, 28 Oct 2026 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217088;
	bh=uAUVNRst+Bd9DU9jSiOrHOfsqe93Hy8nx58iRi8R5B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaUiTyDer4ahZAlD1tJyoP71oNyX7eInwZUV7+rJOrGqzTtrU0CrtbLRzxPZ9/5cG
	 U9EfCG7Y4XD580wKteAKslzTq213Zk7XBlfElsHbpmtNn8xX1gQrRgjpsjFCkR2Atp
	 Dc+6VO/bUQRws0VY5gmqDVn9HZIk5h54FudNoUEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1782/1887] exit: move core of do_wait() into helper
Date: Wed, 28 Oct 2026 18:04:38 +0100
Message-ID: <20261028170540.002144816@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 06a101ca45b296fe951692620b0bc49abf90c368 ]

Rather than have a maze of gotos, put the actual logic in __do_wait()
and have do_wait() loop deal with waitqueue setup/teardown and whether
to call __do_wait() again.

No functional changes intended in this patch.

Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 81933038f5e2 ("pid_namespace: make zap_pid_ns_processes() freezable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 413540df3e185..d4addbc7aff20 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1588,16 +1588,10 @@ static int do_wait_pid(struct wait_opts *wo)
 	return 0;
 }
 
-static long do_wait(struct wait_opts *wo)
+static long __do_wait(struct wait_opts *wo)
 {
-	int retval;
-
-	trace_sched_process_wait(wo->wo_pid);
+	long retval;
 
-	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
-	wo->child_wait.private = current;
-	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
-repeat:
 	/*
 	 * If there is nothing that can match our criteria, just get out.
 	 * We will clear ->notask_error to zero if we see any child that
@@ -1609,24 +1603,23 @@ static long do_wait(struct wait_opts *wo)
 	   (!wo->wo_pid || !pid_has_task(wo->wo_pid, wo->wo_type)))
 		goto notask;
 
-	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
 
 	if (wo->wo_type == PIDTYPE_PID) {
 		retval = do_wait_pid(wo);
 		if (retval)
-			goto end;
+			return retval;
 	} else {
 		struct task_struct *tsk = current;
 
 		do {
 			retval = do_wait_thread(wo, tsk);
 			if (retval)
-				goto end;
+				return retval;
 
 			retval = ptrace_do_wait(wo, tsk);
 			if (retval)
-				goto end;
+				return retval;
 
 			if (wo->wo_flags & __WNOTHREAD)
 				break;
@@ -1636,14 +1629,32 @@ static long do_wait(struct wait_opts *wo)
 
 notask:
 	retval = wo->notask_error;
-	if (!retval && !(wo->wo_flags & WNOHANG)) {
-		retval = -ERESTARTSYS;
-		if (!signal_pending(current)) {
-			schedule();
-			goto repeat;
-		}
-	}
-end:
+	if (!retval && !(wo->wo_flags & WNOHANG))
+		return -ERESTARTSYS;
+
+	return retval;
+}
+
+static long do_wait(struct wait_opts *wo)
+{
+	int retval;
+
+	trace_sched_process_wait(wo->wo_pid);
+
+	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
+	wo->child_wait.private = current;
+	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
+	do {
+		set_current_state(TASK_INTERRUPTIBLE);
+		retval = __do_wait(wo);
+		if (retval != -ERESTARTSYS)
+			break;
+		if (signal_pending(current))
+			break;
+		schedule();
+	} while (1);
+
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 	return retval;
-- 
2.53.0



