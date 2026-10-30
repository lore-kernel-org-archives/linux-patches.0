Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362546;
	b=KkaxxQIfMsOUwXv+UNEhQvyo9W20t8Xh6HKWnn16//O3/Y7IgM8FPMkpxdbHLYhATipo
	 76EnW8+9d8KtEzxz0Ld1qpDuWtuYnlghUK6Rxu45H8nk2GlpbG/3xOWAIkBg0utpfEUcF
	 s9OSCtJDlP5bdv581/slITjeoU2TOzUm9LvepLx6pA9cxHKaLRAxPnH97OA1Kpl4BiUne
	 41LYXVO1uyqXD8oBAcXA/BatpH9RRoy7sYlkiuKa9AVk/w210ejIHp2KKpNn6m1yr6wZF
	 78oWqbiDdFJRHDcT89b8tcowv1raek2OP4rw/olYNQ6EVrGNxw5rIFPEagOfrsRJofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NXjYXberEjivtZAJ8LgyzM3G3UWRNkdqkSI3z4XS5s0=;
	b=sTcwDS3DXS/lqklfymMwhKlXdGuohzOZiwpVup9mwzJntl0+BZMz9DUZtKVWUXYWvXbL
	 7nHWhMaRoUCccaqIKSPSy/OfA+Hle7X5uBUl0WIQLNsjmVfm6lQ8eQV13GPkdB/hJ9PRo
	 uLYogGIZ8N6ZZrvM2r/2JBja25b0SCZIUFKfYBV/Vnk2y39FRriAU9svOKD8W9HGdBoIV
	 LQhH9v9dYLn6tgZRrkdWbjPZ4Mzh6qXFAWP4Q53IseXZOA3weeKqyEtUYBY3wT/mKept0
	 aUbGny4WwbkFvIf7Nj3kYiSX9wtwQiVAcsYdTB/zbd9ZbmIAjs3BSVC882MduMsocag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UzJUqvWO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B7D606A31A;
	Fri, 30 Oct 2026 12:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UzJUqvWO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32301F000C1;
	Fri, 30 Oct 2026 12:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362545;
	bh=NXjYXberEjivtZAJ8LgyzM3G3UWRNkdqkSI3z4XS5s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzJUqvWOuN/nD4JVGfcmv/ManODpFa+W72QwsJWsz9dNnjrqX3rFpkAv5qLF1szt+
	 NZ/N14cH3wyT5fnf1BlmTKbUEeCNTGKHVkVBrFKWBJAcV8MRLmY+vmn2o1oCp+BxRr
	 G3sqZwnhTJ0eZVqSYy4PTmVuOZ3G/9G8FqrcjapU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 10/10] fork: dont create io threads once PF_POSTCOREDUMP is set
Date: Fri, 30 Oct 2026 13:15:11 +0100
Message-ID: <20261030121255.505690422@linuxfoundation.org>
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

[ Upstream commit 1f978881ce6c9ac4f4d4a7b6a6e52339eadcd350 ]

zap_process() skips every thread that already has PF_POSTCOREDUMP set.
Such a thread is past synchronize_group_exit(), so a coredump can't
catch it anymore. It isn't counted in core_state->threads_remaining and
it isn't sent SIGKILL.

do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
io_uring_files_cancel() right after that. The cancellation runs task
work and a create_worker_cb() that io-wq queued before the exit creates
a new io-wq worker from there. If another thread started a coredump in
the meantime that worker joins a thread-group which is already being
dumped. zap_process() never saw it so it was never counted. But when it
exits it sees signal->core_state in synchronize_group_exit() and
decrements threads_remaining like any other thread.

So the count reaches zero one thread early and the dumper leaves
coredump_wait_inactive() while a thread it counted is still running.

The task has no fatal signal pending because zap_process() deliberately
didn't send it one, and it never went through get_signal() so it doesn't
have PF_SIGNALED either.

Refuse to create an io thread when the creator has PF_POSTCOREDUMP.
That costs nothing. io_uring_files_cancel() raises IO_WQ_BIT_EXIT
before it runs any task work, so a worker created from there only ever
gets to exit again, and io_should_retry_thread() doesn't retry -EINTR.

Clearing PF_POSTCOREDUMP for the new thread in copy_process() was the
other option. It makes the worker a thread like any other, but it only
helps while the dump hasn't started. A worker born after zap_process()
has run is invisible to it whatever its flags say and still decrements
threads_remaining on the way out. Refusing to create it covers both, and
then no task is ever born with the flag, so there is nothing to clear.

Moving io_uring_files_cancel() ahead of synchronize_group_exit() closes
the same window. It runs the cancellation, and whatever that can block
on, before the thread announces itself to the dumper. A thread that
blocks there never reaches coredump_task_exit() at all, so the dumper
ends up waiting for a thread that never parks. Refusing the creation
leaves the cancellation where it is. But it's very ugly to run io_uring
work even before we did all the generic exit work.

Fixes: 92307383082d ("coredump:  Don't perform any cleanups before dumping core")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-14-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2689,8 +2689,8 @@ struct task_struct *create_io_thread(int
 		.user_worker	= 1,
 	};
 
-	/* A creator past its fatal signal gets no thread. */
-	if (current->flags & PF_SIGNALED)
+	/* A creator past its fatal signal or its coredump point gets no thread. */
+	if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
 		return ERR_PTR(-EINTR);
 
 	return copy_process(NULL, 0, node, &args);


