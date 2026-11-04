Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826790;
	b=fL6YH9NlYmnXkNLdhYFUFCrxbwt2xb708SwvYuEiUvhhtgBvKURspgvyGfNIaAA14jYi
	 1fZKDwf65uEQzX470FbKBrXBTJJnWalt8Mammovty82N1PAEE5Ku3QVLypm3JN99VHKJz
	 TlonU8CAEtLvppzCpJyc2LB7AKmP62gN4Y0MX38CYjjvT38sZHY8ZeelFoCFgmLog2lVk
	 jtt6NpFID3LwCSzJeoKpwDnPN8NQQe1LKaryeYXBVPdNNd+RXDYLOJb3pSoAtFNl4GQYB
	 0W0JDoP60wrmYiocM4np4npHF8gUVkBJuVSQXXmYwAtEHWxRaxEeB0wPgmOKXXNivdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DqIlOilLLn/bPvIcMs5OBYd5js16QyERUEORWcRFA0=;
	b=rQ60YkIemg8V6KQNVGsb87vT8E2S+oc8XmICZnPIxWN7kPSs+3ZN8Ga4CrMZXbTAmkyq
	 wXmKo0EENo7A27AYzpXodHTylcHtlc3o9vfhStAIgiepE2kmCZCqskq8eiEmMgauu10eW
	 IVdAAzWdVYenpTeJVQ68r+DltUjLID92Im91H8wVM78+iOquyhYB8nxkLKYaZqXYVwvQB
	 +aQPLUhC7OKX2f1Hed3W/Sa5VgcmHGDuCoctegvq0spZ4lCk5vLdrCy0/vNlJhl9hOfrW
	 +lGasGerbA/Dzz5eLuv83FZztFn6lu25om743tLjkSvSo83WpN206MzePMPDh6+Sbpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=If1s1fBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37506071A07;
	Wed,  4 Nov 2026 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=If1s1fBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AE01F000C1;
	Wed,  4 Nov 2026 21:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826789;
	bh=9DqIlOilLLn/bPvIcMs5OBYd5js16QyERUEORWcRFA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=If1s1fBa7Yu8B1CH7Ukiy2ikt7/EWzKg7VRwtFw6q5ICIu4+LM16wBa7Tl8ViLHHH
	 4mAzwwD0mmR0BLJlgJuPetPk3MRTIDgaFmsHclhIXQDDZhr3ndSe1Ay5seVjyEdZQk
	 b2e6mjl/PeBWWp5fyDXUgbnrZVD5qvezo/Osd/LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0008/1005] exec: cancel io_uring requests before de_thread()
Date: Wed,  4 Nov 2026 15:55:41 -0500
Message-ID: <20261104211043.766954811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4aa6905259591..3f301138e65a0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1134,6 +1134,13 @@ int begin_new_exec(struct linux_binprm * bprm)
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
@@ -1150,10 +1157,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 
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



