Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826882;
	b=UFgdq+bsKLqGpLvoIOwihVmJJjShp2rCYqi87NdtvULSlxVz21X8fSXc+GJwPJqyzk39
	 y+IXkrIp35lregI+RsmV6W3JWx0iDSMUUr2PbiJheAuME6BgxDIfPAPmfipaStXfQDs49
	 JJuh0odwpGWY+pYuXPmL7GldGrvFosaO4ven6dyuhXUM57xw5N5Mwbb9QlRjPhTd8+DPe
	 2hhHdwPGxJhG+loK1Rhs/ROYjNCxGC8vfH/lUULEeVZutizZow+y5/M96Me6jVEpW2wVB
	 IIGdRmnPc0eJH2zHI1ydvKyHerSZ6ONb7T+bQ7KOIStltgpF6L9A6/zeB1Gtjyx+AFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C+3UFKmkFmurDTYkr3DsIwN/s8Sf2PPh0gvmDmqq8Hg=;
	b=fpSzy6JpjhRcDhBZUiZMibNr+UWSOZEMpw+iCLktsSu4pB23lHc1H3uPTLppMcZvlVjA
	 X7HK+KE65CeE4gRtTgndFrmHQYmFn3zP5r6Nn1EhfpN46f2IySYhCnspVUKWtWxOcgsoc
	 o5vRorEBeyrcFfwiR7gj1i5iML1NkQpgBXcDWWCidAscbcBRWiVQb6BU+qzSu6PDv+CMk
	 bHCMYZyiIQys4NFg3FLhUSDMRarxduSSha1XXijPgD7TGSw4j5TUj0y252Xg8ebWq5eaa
	 aB7M4ZKVeG9q+/+PFyERqUlMSiw1iYspUEId2oxIK00sBc9PlB0X9CUS6+STvF3B/XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVkjuwDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36D36082FC4;
	Wed,  4 Nov 2026 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVkjuwDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C30C1F00A02;
	Wed,  4 Nov 2026 21:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826881;
	bh=C+3UFKmkFmurDTYkr3DsIwN/s8Sf2PPh0gvmDmqq8Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVkjuwDnXAlkLSG3vMRBFPH07c82IGZdcy/U87m9Ct7e9n0beFfVFHp/tul/+rxTb
	 tt2pRhGOJoSv+4eYwNz3scCykGyASHLGThJLjBFptDXQAZydyReKH+JWLYwZYWdGzt
	 vsp9UqH/hJdozZo070wpXSphjk8ZC9NbQl2fryBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 063/547] exec: cancel io_uring requests before de_thread()
Date: Wed,  4 Nov 2026 16:04:07 -0500
Message-ID: <20261104211040.064938746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1160,6 +1160,13 @@ int begin_new_exec(struct linux_binprm *
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
@@ -1176,10 +1183,6 @@ int begin_new_exec(struct linux_binprm *
 
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
-	/*
-	 * Cancel any io_uring activity across execve
-	 */
-	io_uring_task_cancel();
 
 	/* Ensure the files table is not shared. */
 	retval = unshare_files();


