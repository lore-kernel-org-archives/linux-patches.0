Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042894;
	b=aEMa8jOPwdHIxD/Gj0n7PotdJNfCm97eZtLbOJ/7QX9aI/Ex49RXE82MCd5a3NLPMATi
	 G172xQyRD2MzvCWLJDAh+akW8DrxnGqfrMMp324C1eTGz7IGFXWCSaLemNC8H1eWTjgA9
	 pvaidFqWN7w5WcuhW8/z3HFryb6BMjmFz9sTN1bFeiQaHVarnFHMd3gOHp1gGQ0G2qBMj
	 csUDr6pkmX4HXHEXg1abjB9g6AFO1YWVBtxLFm0yAukV2nxYmEQ3CyaPi2cniGYWKtHQD
	 Od4dclrrBJn7F8i8CY7Fitp0PTtGPBoaELKI4coCO9QrPcb1K1vvbv2/QZQ6Mz4jKqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2sqHTBxTwz7xiaNZ5fHmOs9VlFAHTbJprZdqU8sMtu0=;
	b=v4qsVkg4Go8lL/LZ+gV7Lbug3Tbb2eR6PTZeu9jLuy6q7R/rjPbf07xLJJkmoD+BExTi
	 tktw7w0LGhtrG6l1A9KEoF6ZRsD7yoRClvU0NeoKoi5IMTZlTicpN+CmwoHr8DFu1CgoV
	 HAUrAn+hQfjddy5H68pqYD0s+JeurkNIIWuYuAgkNCILIlEP1T1+HcJBTTBCYQ6HXiOPC
	 QhhZSmgJyT7gQRzgbigT2k0ztO3xThFcznctzvm3iPtMyM+HAh531pNPEIB6JXS3IDauz
	 AO/yUvIkpoRVdt/GctNWimC3mQLrPCUluHxLgwsX9KR0glCrc6Img7UmG3VMqCj9J/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBmqxcuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61972606A31C;
	Wed, 18 Nov 2026 23:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBmqxcuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF6D1F000C7;
	Wed, 18 Nov 2026 23:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042894;
	bh=2sqHTBxTwz7xiaNZ5fHmOs9VlFAHTbJprZdqU8sMtu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBmqxcuSGQyMl1ycAN9kUqoQQwHrWIJSaUefVxPqwDkVUEfd/HAjhCNcBHqf1YkYA
	 wT+hisGVy9sAa7jLoE1lpxYB+04WLdaPVqQdQat+VJ8drVHmU3mAAU1lbyn2UP8U0N
	 GSyGcoTH0Vwd50SGMNyJJS7KJoHIT3OX63TmbloM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0010/2857] exec: cancel io_uring requests before de_thread()
Date: Wed, 18 Nov 2026 15:17:24 +0100
Message-ID: <20261118150201.688228562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: Adjusted context around de_thread() to accommodate existing POSIX timer cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7391ec00a1cc1..05356a5122f08 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1261,6 +1261,13 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	bprm->point_of_no_return = true;
 
+	/*
+	 * Cancel any io_uring activity across execve. This runs task work
+	 * that may still create an io-wq worker, so do it while de_thread()
+	 * can still zap it.
+	 */
+	io_uring_task_cancel();
+
 	/*
 	 * Make this the only thread in the thread group.
 	 */
@@ -1283,11 +1290,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 	flush_itimer_signals();
 #endif
 
-	/*
-	 * Cancel any io_uring activity across execve
-	 */
-	io_uring_task_cancel();
-
 	/* Ensure the files table is not shared. */
 	retval = unshare_files();
 	if (retval)
-- 
2.53.0



