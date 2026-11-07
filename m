Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060551;
	b=i0JVwW4BlruvhNOXYeTAjsmqDdH8aqfFeVVy9wjVKBZd4AG9IjFL2cZC04ntL/hS8qI3
	 L1xxXx4ny4dx1Ys96Qo44M8U517Ol3BF9NxgtG/gXONQ9MbauWEBnY1hg0aiz9eLi1RII
	 nSDF9SufI1dshfbzyJZh8H1XNzH/nfYJu7jbNZVda224qpvagCiljSoXDndwtVGmLQ47c
	 hE0UI+xw5bgcg5PmC1KsLXPcTGTM105TQte60r+Gh7EKt7RoW/+sZBRJ5fJ3eqgWIVLls
	 pMs/bxRFgIKdk7uWGPpTHl78qW6DiHDYJKoCsG6t61FC21mxvo2iJ5RVEh5XRLXT4Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+wnrktn+0j6k1LGA1odHrWjtWjF/SESBio1xl8SUck=;
	b=GOmTD0OgWFH1E1RPh5Yy3LUnER8CDnPIc/nyikqP/LrLr33jaZVV+AZVqK0Z2RLF8EyW
	 UpPkurJyVZwdY61QFeh640gzg1WsmNIfn60HAWl2f4ahJqWSOL7OvVQCHDWFRp8KmbB8P
	 fzVx73Y1/+rv73DXxTyyij61NevWNN+KIbDy/VX8nPhIwmZCvQZBPYWmrRK4lfKYRYHjW
	 nHdxpHKETe80Y9L9tNOikYLQfeZy0wJoG2BCKQ94fOJoTZjfus70R4aLUXe1CBXRj1cVi
	 4VVLC3+nRMU+AxCf1cb/p8dj5YuyRi3T8gPwb7Z6C9403Cb9x2B7qB/rF3RUQnwpxVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyXnFCK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F397C606A332;
	Sat,  7 Nov 2026 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyXnFCK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933EA1F0089F;
	Sat,  7 Nov 2026 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060550;
	bh=8+wnrktn+0j6k1LGA1odHrWjtWjF/SESBio1xl8SUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyXnFCK7R2ttehnV3pnlsU/tdo+Uoa6SYtOAx7Tdz4wwfeU0hDqTNZJPiD6E8kcr+
	 D/DIQxC9lhsABlr+ri0YqC2PqwHI+lE5z9IK02V+MSmXzy9QNPFavXK5yLmEPgasFs
	 +r7s1lg+qVLCh4ZLprN7PZV7DR0mcP7+Ns5l1Jxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0017/1536] exec: cancel io_uring requests before de_thread()
Date: Sat,  7 Nov 2026 08:33:53 -0500
Message-ID: <20261107134958.163642664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 829c74c7690d8..3c84578f48db0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1257,6 +1257,13 @@ int begin_new_exec(struct linux_binprm * bprm)
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
@@ -1273,10 +1280,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 
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



