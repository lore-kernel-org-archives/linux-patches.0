Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210344;
	b=ZTiawddjccyiAnXQdAOti2iG8xBJWriDvwIDS/Zdg4V5NnoCeCTOrYDVvjn7iVU6s9p5
	 CczDIYvcoIBeGGBUhs9KqavbsDBbUPWF69/oCzwtBYCDbsFWpsf6WE7OWyLYoaO1kt3s3
	 bvK2a7O+Wnb3KVVA9xRgolvJgRxRLyP47xIjZswYJe51r4brOadQHaBDX4rue1DLAsU9I
	 B/WczcZLA1EhFXv9T69JNHdyrYtBYynybxkr5cDSbuIOa37bvsr6oZt0/jokCfhWzVi5W
	 ro6lROD4cnap2CL+h9l6UHNvJnHq+5fUPGGm5Htchwxyi6ZVEo+kfSv29scbzEld5NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=61NXN8GvYKK3A6wGB8B0tuYFlvVxKx4EgjeNy2tLnXI=;
	b=YDAobLF1TuBCSvH/kEeISLpJ6k23/uy9fEej/7RdI/rcP59AUMD6jIzZpdBQb4DbowoG
	 4f+ON5pWd8HRxZ7iGr25pNeOOiDtapDwBwK2daP6yCTCqM7hwnRW3nWNwIrf6/MB5yT57
	 k5OWHsTRkCVHIC8GnGyTV6B3zsPv1y2PCXdcmVQAC+QcqoPCEl+MZhWpnfkMqkIyOXVZt
	 c7Zk3D+2l4zdEeGWLCf8rI34MJNjMjQWAuM6P4/3xxFpdIB7fyRYQS9RgxD+PLSxXlwfJ
	 hqLxpLOTgiudQPJTxxM6QxmcM0eXR/PZ8VZvTvNoP5nhsCYXmiZbZiVF1qAIUDj7QwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ui4WEaYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3865606A327;
	Wed, 28 Oct 2026 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ui4WEaYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1199C1F031E1;
	Wed, 28 Oct 2026 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210343;
	bh=61NXN8GvYKK3A6wGB8B0tuYFlvVxKx4EgjeNy2tLnXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ui4WEaYp2QMIwgBheHsas0G8B+zomOym1chVpX7LU6Wr7qEuvzgD/PTBhstgZzCXl
	 fXTIZv6D04aoaJuMxgCWVJlHmfraR7eopmK5J1vBr+y5zl3SLW3ElD6Cx+Ug2C9R9r
	 LLMGG6MHDWSxuLFYISWvbNqWcrMSMSNX+723Tz8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 163/168] coredump: hold RCU while releasing parked threads
Date: Wed, 28 Oct 2026 18:01:39 +0100
Message-ID: <20261028165946.947239354@linuxfoundation.org>
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
@@ -469,6 +469,8 @@ static void coredump_finish(bool core_du
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -477,6 +479,7 @@ static void coredump_finish(bool core_du
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}


