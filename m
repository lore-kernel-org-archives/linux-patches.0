Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033476;
	b=MVs+irS4qFKVHBYhf52K89jSnaCblEB7KppctkUBLnw9m5GNnZrFCYZZJdbzhaYyqWPW
	 rxlwkwVsvWHcf8iDoW1kK13IndrF9khl+pgDrv5lNbm3hHvp+GEp7Gek4/lqJy4Prija5
	 9xw64M0Utx1N4YyM7KdTu+l24iMfPajMj4qSmgb1S/4igFfY5X97ZxVlEZw5jbHWcfYUE
	 XZ7N/ZWcsVUwv1iJ7FYPEKiGOILOZzfwdlnmlXP1Psavq4/aiy1bWdkI1YYutV/YyEgPE
	 dBo1QEZt1ewvqUrTdgdOKJGQZYgoaPaLdV/pNJ0OpwmlnecYAyMjCgclqGejRgt/Wqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SCGr0aNl7r0ZERoXl/kGPHmi9oiqZ9z5ENpbu0iKYn4=;
	b=B3WK1CHmj5x4VgGEHRYRj9/09twj/9ESXBsDyY1MhJZKsca+cyQWpy2YqlCx8BJH32B5
	 05RcEVfegKWEq9aTy3AkmK7sItyeOXdCjcqBh2cy2aHTTt2NDL5X+MoaDRlO7PvnNplIN
	 lYNwI6BXLimp8FrCZOAY6YbjfBJsinhJLsnSQbLUKAMLEnJoueW3Z+OZC27rlwAO6vGyT
	 dp+wFGLONj1pam3og4c73Rev+NkYagrwTfnBE8kElFiaiQSqGdDRPj//bIWD9rOS8ntfq
	 klVJhfGnST4Z3H9u49D9S627mHRF1xo5+v4zuXqY2t8RVCAUeLL9yoRK5Z/qij6EiUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gn6sI4cb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D333606A320;
	Wed, 18 Nov 2026 20:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gn6sI4cb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0181F000C6;
	Wed, 18 Nov 2026 20:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033476;
	bh=SCGr0aNl7r0ZERoXl/kGPHmi9oiqZ9z5ENpbu0iKYn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gn6sI4cbt1gBqS24ChB6S6Vhfqdm3PFJzOQ91ZKEZU7VbyIZXwV6bXII27feLzqwC
	 NN12R0YNvABm3pRIVxVkGjvl/kbOenH8YOX4dtUJ1vM3xMdu+lrA2omHOAT84zwBuD
	 I8JCaJ06Ynxu2XwvjYFWiU6t58Yl4PhgG6stoNDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0010/3318] exec: cancel io_uring requests before de_thread()
Date: Wed, 18 Nov 2026 15:10:32 +0100
Message-ID: <20261118150313.962655999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

[ Upstream commit b42c85c20d84ff3e4f0f027d6596c3b3b4a20657 ]

begin_new_exec() cancels the exec'ing thread's io_uring requests after
de_thread() made it the only thread in the thread-group. Now
io_uring_task_cancel() runs task work after. If it runs a
create_worker_cb() item then a io-wq queued on the thread before the
exec creates a new io-wq worker thread.

Said thread joins the thread-group which de_thread() just took down. The
io-iwq sticks around until it notices that its workqueue is dying. But
code after de_thread() relies on being single-threaded.

Move io_uring_task_cancel() before de_thread() but behind the point of
no return. Any worker created during task work run from
io_uring_task_cancel() is just a sibling thread that de_thread() will
take down and reap.

Once io_uring_task_cancel() returned the thread has neither a task
context nor a workqueue left so nothing can add a thread behind
de_thread()'s back anymore.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0_lvHDViIpX_Mu@redhat.com
Fixes: 3bfe6106693b ("io-wq: fork worker threads from original task")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-12-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4f59e453cecdc..7833518692eaa 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1268,6 +1268,13 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	bprm->point_of_no_return = true;
 
+	/*
+	 * Cancel any io_uring activity across execve. This runs task work
+	 * that may still create an io-wq worker, so do it while de_thread()
+	 * can still zap it.
+	 */
+	io_uring_task_cancel();
+
 	/* Make this the only thread in the thread group */
 	retval = de_thread(me);
 	if (retval)
@@ -1284,10 +1291,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
-	/*
-	 * Cancel any io_uring activity across execve
-	 */
-	io_uring_task_cancel();
 
 	/* Ensure the files table is not shared. */
 	retval = unshare_files();
-- 
2.53.0



