Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362543;
	b=ZDLAT2Ofaku9L13gnTbm9Bd77LV2l/2iNX24j6zwQU2HXqkiVaZC/43hCgUX6ITOBaHI
	 S36CsNmQoC9if3YxFz+1G9SvdjRi4Qiu9qRGy6+pITJgAYUiSvljmsjRV5wYMnmIsTq0u
	 QHX8kJQKnR0FmmVSGH2j8ncRnA0TfoLcU7lYzO7rgw19A2t+JORazScGU4Gmjj2qlEBX3
	 41beNYecShyiy96KcjFsla2Kp460WUZt8t/TR8AAcHEs/vgLksOT9ssRgtdb9r+5Mcp3y
	 5OqgLUxFQrC2OrLHi3q4p3MdF8cPCQ7YITQrxfeROThpAyPLRXjFvhDaT7oulKRTUsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Az3MSkVLvoT6XV3rKoxcl4KQhuANw1rx0a9BEoi4YqU=;
	b=Bokl/hdwsK7PgyEdOTdJfOsb+UKlDtVc5GFuTvieqQ9Q7O8ZlZqLpdX6lM71Qa6w0tQH
	 DAxECcLVjDbdLA/enxsK1taE0jRW4ntX7tXCvS/WwsAaTDRfSp9+NZT/lHra7moFGp5Xl
	 tfrO1Q1gnrQ2d+gN9uZ5e7axbPAn8ZykVPuiLd5T6yEXkjTsSuh/EJtGrw4qfGykY6chB
	 5QFSp1LhOP6PDMDMzz9mO8rVpsLXdtntc0p/j6zDRY8GrKItt3YL0DDod6q+6jMG1dQoG
	 juqx76w1C+STXspZGHWNJxJRPGtM5en/WVDso3QNimskSSffvEWl8JtbmNU3bxjFw4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJy45gc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C4F606A31A;
	Fri, 30 Oct 2026 12:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJy45gc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A2B1F000C1;
	Fri, 30 Oct 2026 12:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362542;
	bh=Az3MSkVLvoT6XV3rKoxcl4KQhuANw1rx0a9BEoi4YqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJy45gc2QLGjJHmDo8UWbyfNFfW1eOCnDUbjKq9b4kVilPVm7DnwDtsdK7oFoAgiX
	 WUI6zyEfhFPxWZOkeZPRR3+QA9azt+MNQiD9wzu5ZZDKmNW71Wv0nJOv6AtJ0/XPPN
	 860y3MnHF6CziEy/vViU7Z8ilKcFc5wtqpDt4x8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 08/10] exec: cancel io_uring requests before de_thread()
Date: Fri, 30 Oct 2026 13:15:09 +0100
Message-ID: <20261030121255.458912244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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
@@ -1145,6 +1145,13 @@ int begin_new_exec(struct linux_binprm *
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
@@ -1161,10 +1168,6 @@ int begin_new_exec(struct linux_binprm *
 
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
-	/*
-	 * Cancel any io_uring activity across execve
-	 */
-	io_uring_task_cancel();
 
 	/* Ensure the files table is not shared. */
 	retval = unshare_files();


