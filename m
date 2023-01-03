Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B2A138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBEDC433D2;
	Tue,  3 Jan 2023 08:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733759;
	bh=EP9UYaWMA4WJbWGIznN+ARUJdNsNP8rmaVOiHFsgl/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJkEKmhRk2ib4DXcjYjDZs7U6Dgr5l68fYNlpiwLH7XLQHNMKGMqDMMMBIfenqCg/
	 XvsD7qwuh+hnu7O1esjlKQa8jjcLFcxzAHWJGIhpVKFKNSa34meF3fsb/qyNxMUaQu
	 3AIqNpYvKIRZ7c7Z2oEMY5i/XfOEWW0XzZE3/C28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xtensa@linux-xtensa.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 33/63] xtensa: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:14:03 +0100
Message-Id: <20230103081310.563291429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit bec58f40d6c5372d812c93cc3947f3bc97440e57 ]

Wire up TIF_NOTIFY_SIGNAL handling for xtensa.

Thanks to Max Filippov <jcmvbkbc@gmail.com> for making the asm correct.

Cc: linux-xtensa@linux-xtensa.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/thread_info.h |    5 ++++-
 arch/xtensa/kernel/entry.S            |    4 ++--
 arch/xtensa/kernel/signal.c           |    3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -111,18 +111,21 @@ static inline struct thread_info *curren
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_SYSCALL_TRACEPOINT	4	/* syscall tracepoint instrumentation */
-#define TIF_MEMDIE		5	/* is terminating due to OOM killer */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
 #define TIF_DB_DISABLED		8	/* debug trap disabled for syscall */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
 #define TIF_SECCOMP		10	/* secure computing */
+#define TIF_MEMDIE		11	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -500,8 +500,8 @@ common_exception_return:
 	 */
 
 	_bbsi.l	a4, TIF_NEED_RESCHED, 3f
-	_bbsi.l	a4, TIF_NOTIFY_RESUME, 2f
-	_bbci.l	a4, TIF_SIGPENDING, 5f
+	movi	a2, _TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL
+	bnone	a4, a2, 5f
 
 2:	l32i	a4, a1, PT_DEPC
 	bgeui	a4, VALID_DOUBLE_EXCEPTION_ADDRESS, 4f
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -498,7 +498,8 @@ static void do_signal(struct pt_regs *re
 
 void do_notify_resume(struct pt_regs *regs)
 {
-	if (test_thread_flag(TIF_SIGPENDING))
+	if (test_thread_flag(TIF_SIGPENDING) ||
+	    test_thread_flag(TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (test_thread_flag(TIF_NOTIFY_RESUME))


